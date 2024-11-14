unit uCheck;

interface

uses
System.SysUtils,
System.UITypes,
Vcl.Dialogs,
Math,
  uImage,
  uParams,
  uPlotVm,
Parameters;


var
// histogram;
NND: array of double;
NNDhist:  array of integer;


Procedure WriteParams;
procedure readmodel;
Procedure Update_Plots;
procedure Make_histogram;
procedure savemodel(DirAndFnameStr: string);



implementation
uses
uSANCmodel;









Procedure Update_Plots;
var s: string;
begin
      // show progress
      s:=FloatToStrF(SimTime, FFgeneral, 8, 8);
      Form1.Label1.Caption:= 'SimTime='+s;
      fPlotVm.series1.AddXY(SimTime, Vm);
end;



Procedure WriteParams;
var ave1, y1,y2: double;
CRUi:integer;
NRYRtotal: integer;

begin
Form1.memo1.Clear;
with Form1.memo1.Lines do
begin
 add('Cell Geometry:');
 add('Cm (pF) = ' + FloatToStrF(Cm,ffGeneral,7,9));
 add('L_cell (mkm) = ' + FloatToStrF(L_cell_mkm, ffGeneral,7,9));
 add('R_cell (mkm) = ' + FloatToStrF(R_cell_mkm, ffGeneral,7,9));
 add('L_cross (mkm) = ' + FloatToStrF(L_cross_mkm,ffGeneral,7,9));
 add('V_cyt_part = ' + FloatToStrF(V_cyt_part, ffGeneral,8,9));
 add('V_fSR_part = ' + FloatToStrF(V_fSR_part, ffGeneral,8,9));

 add('');
  add('Cell surface grid:');
 add('Grid unit, mkm = '+ FloatToStrF(GridSz_mkm,ffGeneral,7,9));
 add('Grid length in X = ' + IntToStr(xGridLen));
 add('Grid length in Y = ' + IntToStr(yGridLen));

add('');
add('Subspace:');
 add('Num_Sub_voxels = ' + IntToStr(Num_Sub_voxels));
 add('Sub_depth_mkm = ' + FloatToStrF(Sub_depth_mkm, ffGeneral,8,9));
 add('xGridLen = ' + IntToStr(xGridLen));
 add('yGridLen = ' + IntToStr(yGridLen));

with VoxelSub do
begin
 add('Voxel dX, mkm = ' + FloatToStrF(dX_mkm, ffGeneral,9,9));
 add('Voxel dY, mkm = ' + FloatToStrF(dY_mkm, ffGeneral,9,9));
end;

add('');
add('Ring:');
add('Num_Ring_voxels = ' + IntToStr(Num_Ring_voxels));
 add('VoxelRing_depth_mkm = ' + FloatToStrF(VoxelRing_depth_mkm, ffGeneral,8,9));
with VoxelRing do
begin
 add('V1_liters = ' + FloatToStrF(V1_liters, ffGeneral,9,9));
 add('Voxel dX, mkm = ' + FloatToStrF(dX_mkm, ffGeneral,9,9));
 add('Voxel dY, mkm = ' + FloatToStrF(dY_mkm, ffGeneral,9,9));
end;
add('R_cyt_core_mkm = ' + FloatToStrF(R_core_mkm, ffGeneral,8,9));
 add('');

 NRYRtotal:=0;
 for CRUi:=0 to  nCRUs -1  do // for loop for all CRUs
      NRYRtotal:= NRYRtotal+ ArCRU[CRUi].NRyR;
      add('total #RyRs = '+ IntToStr(NRYRtotal));
      add('average CRU size  = '+ floatToStrF(NRYRtotal/nCRUs, ffgeneral, 8, 8));


 add('');
 add('Whole-cell volumes, in femtoliter (10^-15 liter) ');
 add('V_cell= ' + FloatToStrF(V_cell_mkm3, ffGeneral,7,9));
 add('V_sub_total = ' + FloatToStrF(V_sub_mkm3, ffGeneral,7,9));
 add('V_jSR_total = ' + FloatToStrF(V_JSR_total_mkm3, ffGeneral,7,9));
 add('V_ring_total = ' + FloatToStrF(V_ring_mkm3, ffGeneral,7,9));
 add('V_core = ' + FloatToStrF(V_core_mkm3, ffGeneral,7,9));
 add('V_ring_FSR = ' + FloatToStrF(V_ring_mkm3*V_fSR_part, ffGeneral,7,9));
 add('V_core_FSR = ' + FloatToStrF(V_core_mkm3*V_fSR_part, ffGeneral,7,9));

 add('');
 add('Local volumes, in atoliter (10^-18 liter):');
 add('1Voxel_subspace = ' + FloatToStrF(VoxelSub.V1_liters*1e18, ffGeneral,7,9));
 add('1Voxel_Ring = ' + FloatToStrF(VoxelRing.V1_liters*1e18, ffGeneral,7,9));
 add('average 1jSR = ' + FloatToStrF((V_JSR_total_mkm3/nCRUs) *1e3, ffGeneral,7,9));

// add('1Dyadic space = ' +
// FloatToStrF(Dyadic_space_voxels*VoxelSub.V1_liters*1e18, ffGeneral,7,9));

 add('');

add('TimeTick='+#9+FloatToStrF(TimeTick,ffGeneral,7,9));
// ion currents;
 add('');
 add('Ca release:');
 add('TotalNRyRs = ' + IntToStr(TotalNRyRs));
 add('TotalNCRUs  = ' + IntToStr(nCRUs));
  Add('MaxVoxelsN =  ' + IntToStr(MaxVoxelsN)+' MaxRyRinCRU(real) = ' + IntToStr(MaxVoxelsN*16));
  Add('MinVoxelsN =  ' + IntToStr(MinVoxelsN)+' MinRyRinCRU(real) = ' + IntToStr(MinVoxelsN*16));

 add('Iryr_at_1mM_CaJSR, pA = '+#9+FloatToStrF(Iryr_at_1mM_CaJSR,ffGeneral,7,9));
 add('CRU_firing_ProbConst = '+#9+FloatToStrF(CRU_ProbConst,ffGeneral,7,9));
 add('CRU_firing_ProbPower = '+#9+FloatToStrF(CRU_ProbPower,ffGeneral,7,9));
 add('CRU_firing_sensitivity, mM = '+#9+FloatToStrF(CRU_Casens,ffGeneral,7,9));
 add('CaJSR_spark_activation = '+#9+FloatToStrF(CaJSR_spark_activation,ffGeneral,7,9));
 add('Ispark_Termination ='+#9+FloatToStrF(Ispark_Termination,ffGeneral,7,9));
 add('Ispark_activation_tau_ms = '+#9+FloatToStrF(Ispark_activation_tau_ms,ffGeneral,7,9));


 add('');
 add('Membrane currents:');
add('C_pF_per_mkm2='+#9+FloatToStrF(C_pF_per_mkm2,ffGeneral,7,9));
add('gCaL'+#9+FloatToStrF(gCaL,ffGeneral,7,9));
add('Cav1.3%='+#9+fParams.Edit4.Text);
add('kNCX'+#9+FloatToStrF(kNCX,ffGeneral,7,9));
add('gKr'+#9+FloatToStrF(gKr,ffGeneral,7,9));
add('gh'+#9+FloatToStrF(gh,ffGeneral,7,9));
add('gto'+#9+FloatToStrF(gto,ffGeneral,7,9));
add('gsus'+#9+FloatToStrF(gsus,ffGeneral,7,9));
add('gCaT'+#9+FloatToStrF(gCaT,ffGeneral,7,9));
add('INaKmax'+#9+FloatToStrF(INaKmax,ffGeneral,7,9));
add('gbCa'+#9+FloatToStrF(gbCa,ffGeneral,7,9));
add('gKs'+#9+FloatToStrF(gKs,ffGeneral,7,9));
add('Membrane currents TUNING:');
add('KmfCa = '+#9+FloatToStrF(KmfCa  ,ffGeneral,7,9));
add('alfafCa='+#9+FloatToStrF(alfafCa   ,ffGeneral,7,9));
add('k_TauFL = '+#9+FloatToStrF(k_TauFL ,ffGeneral,7,9));
add('k_IKr_Tau = '+#9+FloatToStrF(k_IKr_Tau,ffGeneral,7,9));
add('V_Ih12 = '+#9+FloatToStrF(V_Ih12  ,ffGeneral,7,9));
 if fParams.CheckBox3.Checked then
   add('bAR stim%,ms'+#9+fParams.Edit23.Text+#9+fParams.Edit22.Text)
 else
 add('bAR stim'+#9+'No');

add('');
add('Ca diffusion, pumping, and buffering:');
add('Dcyt = '+#9+FloatToStrF(DCyt_mkm2_per_ms   ,ffGeneral,7,9));
add('DFSR = '+#9+FloatToStrF(DFSR_mkm2_per_ms   ,ffGeneral,7,9));
add('Tau_FSR_JSR_ML = '+#9+FloatToStrF(Tau_FSR_JSR_ML_model  ,ffGeneral,7,9));
add('Pup = '+#9+FloatToStrF(Pup   ,ffGeneral,7,9));
add('CQtot = '+#9+FloatToStrF(CQtot   ,ffGeneral,7,9));
add('CM_total = '+FloatToStrF(CM_total   ,ffGeneral,7,9));

add('');
   add('VoxelSub Cytosol');
    add('DeltaT='+ FloatToStrF(TimeTick, FFgeneral, 8,8));
    add('FCC_CytSubX='+ FloatToStrF(FCC_CytSubX, FFgeneral, 8,8));
    add('FCC_CytSubY='+ FloatToStrF(FCC_CytSubY, FFgeneral, 8,8));
 add('');
    add('VoxelRing Cytosol');
    add('DeltaT='+ FloatToStrF(TimeTick, FFgeneral, 8,8));
    add('FCC_CytRingX='+ FloatToStrF(FCC_CytRingX, FFgeneral, 8,8));
    add('FCC_CytRingY='+ FloatToStrF(FCC_CytRingY, FFgeneral, 8,8));
 add('');
    add('VoxelRing FSR');
    add('DeltaT='+ FloatToStrF(TimeTick*NTicks_Diffu2D_Ring_FSR, FFgeneral, 8,8));
    add('FCC_FSRRingX='+ FloatToStrF(FCC_FSRRingX, FFgeneral, 8,8));
    add('FCC_FSRRingY='+ FloatToStrF(FCC_FSRRingY, FFgeneral, 8,8));
add('');
  add('subspace - ring Cyt, v2=voxel ring');
  add('DeltaT='+ FloatToStrF(TimeTick, FFgeneral, 8,8));
  add('FCC_CytSubToRing='+ FloatToStrF(FCC_CytSubToRing, FFgeneral, 8,8));
add('');
  add('Ring and Core, v2 is the core');
  add('In cytosol');
  add('DeltaT='+ FloatToStrF(NTicks_Diffu_Ring_to_Core_Cyt*TimeTick, FFgeneral, 8,8));
  add('FCC_CytRingToCore='+ FloatToStrF(FCC_CytRingToCore, FFgeneral, 8,8));
add('');
add('In FSR');
add('DeltaT='+ FloatToStrF(NTicks_Diffu_Ring_to_Core_FSR*TimeTick, FFgeneral, 8,8));
add('FCC_FSRRingToCore='+ FloatToStrF(FCC_FSRRingToCore, FFgeneral, 8,8));
add('');
add('FSR - JSR, v2 is ring voxel');
add('DeltaT='+ FloatToStrF(NTicks_Diffu_FSR_to_JSR*TimeTick, FFgeneral, 8,8));
add('FCC_FSRtoJSR='+ FloatToStrF(FCC_FSRtoJSR, FFgeneral, 8,8));


  end;// with memo1

end;




Function TabStr(s:string; N:integer):string;
var tabcount,i:integer; s1:string;
begin
 TabStr:=''; if s='' then exit;
 i:=0; tabcount:=0; s1:='';
 repeat
 inc(i);
 if s[i]=#9 then
 begin
   inc(tabcount);
    if   tabcount = N then
   begin
     TabStr:=s1; exit;
   end else s1:='';
 end  // #9
 else s1:=s1+s[i];

 until i=length(s);
if N= tabcount+1 then  TabStr:=s1; // if  TabulatedStr is at the end
end; // proc



procedure readmodel;
var s:string; F: TextFile;
number_jSRs_X_read, number_jSRs_Y_read,
voxeli, CRUi:integer;
SD1: double;
s1: string;

begin
// load model
  Form1.OpenDialog1.Filter:=  'CRU file(*.txt)|*.txt';


  if Form1.OpenDialog1.Execute then
   begin
     s := Form1.OpenDialog1.FileName;
         AssignFile(F,s);
         Reset(F);
    readln(F,s); readln(F,nCRUs);
    readln(F,s); readln(F,TotalNRyRs);
    readln(F,s); readln(F,NvoxelsInAllCRUs);
    readln(F,s);
    for CRUi:=0 to nCRUs-1 do
      with ArCRU[CRUi] do
       begin
        readln(F,s);
        readln(F,s); s:= Tabstr(s,2); x:= StrToInt(s);
        readln(F,s); s:= Tabstr(s,2); y:= StrToInt(s);
        readln(F,s); s:= Tabstr(s,2); NRyR:= StrToInt(s);
        readln(F,s); s:= Tabstr(s,2); NVoxels:= StrToInt(s);
            setlength(Voxels, NVoxels);
          for voxeli := 0 to NVoxels-1 do
          with Voxels[voxeli] do
          begin
            readln(F,s);
            readln(F,s); s:= Tabstr(s,2); xv:= StrToInt(s);
            readln(F,s); s:= Tabstr(s,2); yv:= StrToInt(s);
            readln(F,s); s:= Tabstr(s,2); nRyRv:= StrToInt(s);
          end;

         // parameters
          Dyadic_volume_liter:=NVoxels*VoxelSub.V1_liters*V_cyt_part;
          JSR1_volume_mkm3:= NVoxels * GridSz_mkm * GridSz_mkm* jSR_depth_mkm;
          JSR1_volume_liter:= JSR1_volume_mkm3*1e-15;
          Ispark_at_1mM_CaJSR1:= NRyR* Iryr_at_1mM_CaJSR; // pA

        // ini values
         TimeOpen :=0;
         TimeClosed :=0;
         Open := false;
         CajSR1:=  Initial_Ca_jSR;
         fCQ :=   Initial_fCQ_jsr;
         fCa:=Initial_fCa;
         Ispark:=0;
         Ispark_before:=0;
         activation:=0;
     end; // with, for CRUi


     V_JSR_total_mkm3 := NvoxelsInAllCRUs*GridSz_mkm * GridSz_mkm*Sub_depth_mkm;
     Ispark_activation_tau_in_timeticks:=  Ispark_activation_tau_ms/TimeTick;


       s:=ExtractFileName(Form1.OpenDialog1.FileName);
       Form1.label8.Caption:=s;

      CloseFile(F);
     Update_Image;
   end;// if Open

end; // proc



procedure Make_histogram;
var i,j:integer;
d, dmin: double;
bin: double;
Max, Min: integer;
CRUi:integer;
begin
 NND:=nil;
 NNDhist:=nil;
 setlength(NND,nCRUs);
 for i:= 0 to nCRUs-1 do
  begin
  dmin:=1e100;
  for j:= 0 to nCRUs-1 do
  if i<>j then
  begin
   d:= sqrt(sqr(GridSz_mkm*(ArCRU[i].x-ArCRU[j].x))
   +sqr(GridSz_mkm*(ArCRU[i].y - ArCRU[j].y)));
   if d<dmin then dmin:=d;
  end;  // for j
   NND[i]:=dmin;
 end;// for i

//  calculate histogram
 max:=0; min:=1000000000;
 bin:=StrToFloat(Form1.edit7.text);
 setlength(NNDhist, round(L_cell_mkm/bin));
 for CRUi := 0 to nCRUs-1 do
 begin
  i:= trunc(NND[CRUi]/bin);
  inc(NNDhist[i]);
  if i>max then max:=i;
  if i<min then min:=i;

 end;

// write mean and SD
   Form1.Edit8.text:= FloatToStrF(mean(NND), FFgeneral, 8,8);
   Form1.Edit9.text:= FloatToStrF(StdDev(NND), FFgeneral, 8,8);

 Form1.Chart1.Title.Caption:= 'Mean='+ Form1.Edit8.text+' SD='+ Form1.Edit9.text;

//  Plot histogram
   Form1.Series1.clear;
   if Form1.CheckBox11.checked then
   Form1.Chart1.leftAxis.Automatic:= true
   else
   begin
   Form1.Chart1.LeftAxis.Automatic:= false;
   Form1.Chart1.LeftAxis.Maximum:= StrToFloat(Form1.Edit34.Text);
   Form1.Chart1.LeftAxis.Minimum:=0;
   end;

   Form1.Chart1.BottomAxis.Automatic:= false;
   Form1.Chart1.BottomAxis.Maximum:= 1.5;
   Form1.Chart1.BottomAxis.Minimum:=0;


for i := 0 to max do
  Form1.Series1.addXY(i*bin,NNDhist[i]);

// Chart1.series1
// NND:=nil;
// NNDhist:=nil;
end;




procedure savemodel(DirAndFnameStr: string);
var F: TextFile;
voxeli, CRUi:integer;
begin
if nCRUs=0 then exit;
AssignFile(F,DirAndFnameStr);
rewrite(F);
writeln(F,'nCRUs');
writeln(F,nCRUs);
writeln(F,'TotalNRyRs');
writeln(F,TotalNRyRs);
writeln(F,'NvoxelsInAllCRUs');
writeln(F,NvoxelsInAllCRUs);
writeln(F,'Parameters of CRUs');

for CRUi:=0 to nCRUs-1 do
with ArCRU[CRUi] do
 Begin
   Writeln(F,'CRU #'+#9+ intTostr(CRUi));
   Writeln(F,'x'+#9+intTostr(x));
   Writeln(F,'y'+#9+ intTostr(y));
   Writeln(F,'NRyR'+#9+intTostr(NRyR));
   Writeln(F,'NVoxels'+#9+intTostr(NVoxels));
  for voxeli := 0 to NVoxels-1 do
  with Voxels[voxeli] do
  begin
   Writeln(F,'Voxel#'+#9+intTostr(voxeli));
   Writeln(F,'xv'+#9+intTostr(xv));
   Writeln(F,'yv'+#9+intTostr(yv));
   Writeln(F,'nRyRv'+#9+intTostr(nRyRv));
  end; // for voxeli
 end; // for CRUi
CloseFile(F);

end;








end.
