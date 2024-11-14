unit uSANCmodel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DateUtils,
  UITypes,
  Math,
    parameters, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ToolWin, Vcl.ComCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart,
uImage,
uImage2, // Ca image form
uCheck, uCmap,
uParams,
uPlotVm
;


type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Button6: TButton;
    Edit4: TEdit;
    Button7: TButton;
    Button8: TButton;
    Label4: TLabel;
    Edit6: TEdit;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    Label7: TLabel;
    Label8: TLabel;
    Button9: TButton;
    Chart1: TChart;
    Series1: TBarSeries;
    Label9: TLabel;
    Edit7: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    CheckBox2: TCheckBox;
    Button10: TButton;
    Button11: TButton;
    Edit12: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    RadioGroup1: TRadioGroup;
    Label26: TLabel;
    Edit24: TEdit;
    Button21: TButton;
    Button22: TButton;
    Edit22: TEdit;
    Label27: TLabel;
    Label31: TLabel;
    Label46: TLabel;
    Edit34: TEdit;
    CheckBox11: TCheckBox;
    Label49: TLabel;
    Label50: TLabel;
    Label14: TLabel;
    GroupBox1: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Edit13: TEdit;
    Button23: TButton;
    Edit25: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Button31: TButton;
    GroupBox2: TGroupBox;
    Button2: TButton;
    Button3: TButton;
    Button16: TButton;
    Button18: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

procedure IndexCircling(gridSize:integer; var index_test:integer);// going around the torus
procedure   Set_geometry;
procedure   Set_SERCA_tabulation;


implementation

{$R *.dfm}

var
Stop_bo:boolean;


// Interface
procedure Read_Interface;
begin

with fParams do
begin
  NTicks_Diffu2D_Ring_FSR:=StrToInt(edit5.text);
  NTicks_Diffu_FSR_to_JSR:=StrToInt(edit6.text);
  NTicks_Diffu_Ring_to_Core_FSR:=StrToInt(edit7.text);
  NTicks_Diffu_Ring_to_Core_Cyt:=StrToInt(edit8.text);
  NTicks_SERCA:=StrToInt(edit9.text);
//  NTicks_test_trends:=StrToInt(edit10.text);
end;

with Form1 do
begin
  TimeTick:=  StrToFloat(Edit22.Text);

   SimTotalDuration_ms:= StrToFloat(Edit2.Text); //300;
   SimOutputSampling_ms:=StrToFloat(Edit1.Text);// 1


  bAR_stimulation_apply:= fParams.CheckBox3.Checked;
  bAR_onset:= StrToFloat(fParams.Edit22.Text);
  bAR_percent:=  StrToFloat(fParams.Edit23.Text);

// Default Basal state values:

    V_Ih12 := -64;
    gKr := 0.05679781;

  Pup:= StrToFloat(fParams.edit12.Text);
  gCaL:= StrToFloat(fParams.edit13.Text);

// set CRU firing
    CRU_Casens := StrToFloat(fParams.edit1.Text);// 0.00015; // mM: sensitivity of Ca release to Casub
    CRU_ProbConst := StrToFloat(fParams.edit2.Text);// 0.00027; // 0.0003 ms-1: CRU open probability rate at Casub=CRU_Casens
    ScalingPobConst:=  StrToFloat(fParams.edit11.Text); // 4.3 to match previosu model with new Stern activation vs. SR Ca
    Ispark_activation_tau_ms:=   StrToFloat(fParams.edit14.Text);

      Ispark_activation_tau_in_timeticks:=  Ispark_activation_tau_ms/TimeTick;
      Ispark_inactivation_tau_in_timeticks:= Ispark_inactivation_tau_ms/TimeTick; //tau = 1/kom; //  = 8.54700854701 ms

    CRU_ProbPower := StrToFloat(fParams.edit3.Text); // 3; //: Cooperativity of CRU activation by Casub
    Ispark_Termination_scale:=      StrToFloat( fParams.Edit25.Text);

 frac13_gCaL:=StrToFloat(fParams.edit4.Text); // fraction of ICaL via Cav1.3
 frac12_gCaL:= 1 - frac13_gCaL; // fraction of ICaL via Cav1.2


  end;// with Form1
end;


// going around the torus
procedure IndexCircling(gridSize:integer; var index_test:integer);
begin
     index_test:= index_test mod gridSize;
     if  index_test <0 then  index_test := gridSize + index_test;
end;


procedure Ar2D_free_memory;
begin
  ArSubCyt:=nil;
  ArSubCyt_dCa:=nil;
  ArSubfCM:=nil;
  ArRingfCM:=nil;
  ArRingCyt:=nil;
  ArRingFSR:=nil;
  ArRingCyt_dCa:=nil;
  ArRingfSR_dCa:=nil;
end;


// Set sizes for 2D arrays for Ca dynamics
Procedure Ar2D_Set_Size;
begin
with VoxelSub do
begin
  SetLength(ArSubCyt,     NvoxY, NvoxX); // create subspace Ca arrasy
  SetLength(ArSubCyt_dCa, NvoxY, NvoxX); // + subspace Ca each time tick
  SetLength(ArSubfCM, NvoxY, NvoxX); // Fractional occupancy of calmodulin by Ca in submembrane space
end;

with VoxelRing do
begin
  SetLength(ArRingfCM, NvoxY, NvoxX); // Fractional occupancy of calmodulin by Ca in myoplasm
  SetLength(ArRingCyt, NvoxY, NvoxX); // create cytosol Ca array
  SetLength(ArRingFSR, NvoxY, NvoxX); // free SR Ca
  SetLength(ArRingCyt_dCa, NvoxY, NvoxX); // + cytosol Ca  each time tick
  SetLength(ArRingfSR_dCa, NvoxY, NvoxX); // + free SR Ca  each time tick
end;
end;// end proc


// setting a value in a 2D array
Procedure Ar2D_Set_Value(var Ar:Ar2Dtype; val: double);
var xi,yi:integer;
begin
  for xi:=0 to High(Ar[0]) do  Ar[0][xi]:= val;
  for yi:=1 to High(Ar) do Ar[yi]:= Copy(Ar[0]);
end;


procedure Set_geometry;
begin

// Calculate Grid size in grid units
xGridLen := Trunc(L_cell_approx_mkm/GridSz_mkm);
L_cross_perimeter_approx_mkm := 2*Pi* R_cell_approx_mkm;
yGridLen := Trunc(L_cross_perimeter_approx_mkm / GridSz_mkm);



// Exact cell sizes
L_cell_mkm :=  xGridLen*GridSz_mkm;
L_cross_mkm := yGridLen*GridSz_mkm;
R_cell_mkm :=  L_cross_mkm/(2*Pi);
S_cell_mkm2 := L_cell_mkm* L_cross_mkm; // ??? add two ends


// Cell volume for a cylinder Vcell = pi*Rcell^2 * Lcell
	V_cell_mkm3 := Pi * R_cell_mkm*R_cell_mkm*L_cell_mkm;

// Total Submembrane volume
// ??? use this to calculate volumes incl volume of subspace elementary volume
  V_sub_mkm3 := 2*Pi*Sub_depth_mkm*(R_cell_mkm - Sub_depth_mkm/2)*L_cell_mkm;
  V_sub_picoliter :=  V_sub_mkm3*1e-3;

// Cell core located under cytosol ring
  R_core_mkm:=  R_cell_mkm - VoxelRing_depth_mkm - Sub_depth_mkm;

// Ring is a cell compartment between the core and subspace
V_ring_mkm3 := Pi* sqr(R_cell_mkm - Sub_depth_mkm) * L_cell_mkm  -Pi* sqr(R_core_mkm) * L_cell_mkm;


//We place JSRs inside respective ring voxels just below their outer
// side facing the cell membrane. To simplify computation, volumes of these ring
// voxels are kept the same by their extending into the core by
// the exact volume of the JSR. To calculate the core volume, we then subtract
// all JSR volumes from the volume of the cylinder core.
  V_core_mkm3 := Pi* sqr(R_core_mkm) * L_cell_mkm -  V_JSR_total_mkm3;

 // Set subspace voxels
With VoxelSub do
begin
  SzX:= 1;
  SzY:= 1;
  NvoxX:= xGridLen div  SzX;
  NvoxY:= yGridLen div  SzY;
  Num_Sub_voxels:= NvoxX*NvoxY;
  V1_mkm3:= V_sub_mkm3 / Num_Sub_voxels;
  V1_liters:= V_sub_mkm3*1e-15 / Num_Sub_voxels;
// distance between neighboring voxel centers in x
 dX_mkm:=  SzX * GridSz_mkm;
// distance between neighboring voxel centers in y
  dY_mkm:=  2*(R_cell_mkm - Sub_depth_mkm/2)*sin(2*pi/(NvoxY*2));
end; //   With VoxelSub

// set ring voxel
 With VoxelRing do
begin
   SzX:= VoxelRing_GridSizeX;
   SzY:= VoxelRing_GridSizeY;
   NvoxX:= xGridLen div  SzX;
   NvoxY:= yGridLen div  SzY;
   Num_Ring_voxels:= NvoxX*NvoxY;
   V1_mkm3:= V_ring_mkm3 / Num_Ring_voxels;
   V1_liters:= V_ring_mkm3*1e-15/ Num_Ring_voxels;
// distance between neighboring voxel centers in x
   dX_mkm:=  SzX * GridSz_mkm;
// distance between neighboring voxel centers in y
   dY_mkm:= 2*(R_core_mkm + VoxelRing_depth_mkm/2)*sin(2*pi/(NvoxY*2));
end;
 Volume_ratio_fSR_to_cyt:= V_fSR_part/V_cyt_part;  // used in SERCA pumping
end; // proc SetGeometry




Function CharStr(delim:char; s:string; N:integer):string;
var tabcount,i:integer; s1:string;
begin
 CharStr:=''; if s='' then exit;
 i:=0; tabcount:=0; s1:='';
 repeat
 inc(i);
 if s[i]=delim then
 begin
   inc(tabcount);
    if   tabcount = N then
   begin
     CharStr:=s1; exit;
   end else s1:='';
 end  // ','
 else s1:=s1+s[i];

 until i=length(s);
if N= tabcount+1 then  CharStr:=s1; // if  TabulatedStr is at the end
end; // proc



procedure ReadRyRSizeDistribution(mem1:Tmemo); //
var
//dat1: array of real;
Nbins,i: integer;
//BinSzInt: integer;
x, y, BinSzDouble: double;
s:string;
NRyRtotalRead: double;
NRyRtotalModel: integer;
NRyR_in_given_bin: double;
CRUSizeDistrRead: array of double;
scale1: double;
DelimCh: char;

begin
// let's read experimental (or any) RyR distribution
CRUSizeDistrRead:= nil;
Nbins:=0;
NRyRtotalRead:=0;
if  Mem1.Lines.Count = 0 then exit;

      s:= Mem1.Lines[0];
      if Pos(',', s)<>0 then  DelimCh:= ',' else
      if Pos(#9, s)<>0 then  DelimCh:= #9 else
      exit;

with Mem1 do
  for I := 0 to Lines.Count-1 do
  begin

       s:=CharStr(DelimCh, Lines[i],2);
    if TryStrToFloat(s, y) then  // if y is a real number we add one more bin
     begin
        inc(Nbins);
        setlength(CRUSizeDistrRead, Nbins);
        CRUSizeDistrRead[Nbins-1]:=y;
     // CRU sizes change as multiples of 16 RyRs
        NRyR_in_given_bin:=  y*Nbins*16;
        NRyRtotalRead:= NRyRtotalRead+NRyR_in_given_bin;
     end;
  end; //for i, with


 NRyRtotalModel:= StrToInt(Form1.edit5.text);

        setlength(CRUSizeDistr, Nbins);
        scale1:=  NRyRtotalModel/NRyRtotalRead;
 // scale
 for i := 0 to High(CRUSizeDistrRead) do
    begin
        CRUSizeDistr[i]:= round(scale1*CRUSizeDistrRead[i]);
    end;

 CRUSizeDistrRead:= nil; // clear memory
end; // proc


Procedure show_distr_of_CRUs;
var Hist_test: array of integer;
i:integer;
begin // show distr or CRU sizes
   if Form1.CheckBox11.checked then
    begin
     Form1.Chart1.leftAxis.Automatic:= true;
     Form1.Chart1.BottomAxis.Automatic:= true;
    end;

    SetLength(Hist_test, (MaxVoxelsN+1)*16);
    for i := 0 to High(ArCRU) do
    with  ArCRU[i] do
    begin
      inc(Hist_test[nRyR]);
    end;

    Form1.Series1.Clear;
for I := 0 to High(Hist_test) do
  begin
  Form1.Series1.AddXY(i,Hist_test[i]);
  end;
Hist_test:=nil;
end;      // proc



Procedure Show_NRyRs_in_CRU_of_each_size;
var Hist_test: array of integer;
i:integer;
begin
    // show disrtibution
   if Form1.CheckBox11.checked then
    begin
     Form1.Chart1.leftAxis.Automatic:= true;
     Form1.Chart1.BottomAxis.Automatic:= true;
    end;


    SetLength(Hist_test, (MaxVoxelsN+1)*16);
    for i := 0 to High(ArCRU) do
    with  ArCRU[i] do
    begin
      inc(Hist_test[nRyR]);
    end;

  Form1.Series1.Clear;
for I := 0 to High(Hist_test) do
  begin
  Form1.Series1.AddXY(i,Hist_test[i]*i);
  end;
Hist_test:=nil;
end; // proc


procedure Set_CRU_activation_and_termination;
var i, CRUi: integer;
y, y144: double;
delta: double; //  used to find shift of spark activation
Scale_Ispark_Termination_for_nRyR144: double;
function FitToCaAtNearestNeighbor(Nryr1: integer):double;
begin
result:= -15.1187*EXP(-(Nryr1-9)/50.5692)+26.4344;
end;

begin
// let's find border effect
y144:=  FitToCaAtNearestNeighbor(144);
for i:=1 to 500 do
  begin
      // include border effect
       y:= FitToCaAtNearestNeighbor(i);
       y:= y/y144;
       y:= Power(y, 3);
   BorderEffect[i]:=y;
  end;
end;




/////////////////////////////
procedure Set_JSRs;
var
xi, yi: integer; // indexes in x and y
i, j: integer; // indexes in x and y
RandomRotation:integer;
CRUi: integer; // cru index in var CRU size option
SizeMax :integer; // increasing cluster to accomodate all RyRs
NRyRi,  // RyR down-counter
voxeli, // voxel index
Nvox: integer; // number of voxel in a CRU
RyRcount: integer; // RyR counter

//MinNVoxels, MaxNVoxels: integer;

x_JSR, y_JSR:integer;  // coordinates of JSR left upper corner in cell grid

// boolean grid to track vacant locations for new JSR positions to exlude overlap
Vacant_locations: array of array of boolean;
//CountRyRsBoo: boolean;
label AllDone;

var
number_jSRs_X:integer;
number_jSRs_Y: integer;
jSR_grid_sz: integer;
jSR_grid_sz_exact: double;
area1:   double;
Ntry: integer;



// this subroutine checks for overlap
function  No_overlap2(CRUi:integer): boolean; // subroutine
var
No_overlap_test:boolean;
i:integer;
x1, y1:integer;
xx, yy: integer;
xxi, yyi: integer;

begin
             No_overlap_test:=true;
             for i:=0  to ArCRU[CRUi].NVoxels -1  do
             begin
               x1:=  ArCRU[CRUi].Voxels[i].xv;
               y1:=  ArCRU[CRUi].Voxels[i].yv;
               for xxi := -1 to 1 do
               for yyi := -1 to 1 do
               begin
                 xx:= x1+xxi;
                 yy:= y1+yyi;
                 IndexCircling(xGridLen,xx);
                 IndexCircling(yGridLen,yy);
                No_overlap_test:= No_overlap_test and Vacant_locations[yy, xx];
               end;
            end;
            result:= No_overlap_test;
end; // subroutine


// this subroutine marks locations occupied with JSR
procedure MarkLocations2(CRUi:integer); // subroutine
var
i:integer;
x1, y1:integer;
begin
            for i:=0  to ArCRU[CRUi].NVoxels -1  do
             begin
               x1:=  ArCRU[CRUi].Voxels[i].xv;
               y1:=  ArCRU[CRUi].Voxels[i].yv;
               Vacant_locations[y1, x1]:=false;
            end;
end;// subroutine



procedure ProcessOneVoxel;
var
xtest, ytest: integer;
begin
if NRyRi>0 then
  begin
    inc(voxeli);
    xtest:=x_JSR+i;
    ytest:=y_JSR+j;

    IndexCircling(xGridLen,xtest);
    IndexCircling(yGridLen,ytest);

    ArCRU[CRUi].voxels[voxeli].xv:=xtest;
    ArCRU[CRUi].voxels[voxeli].yv:=ytest;

    // partial occupancy of this voxel by RyRs
    if NRyRi<16 then
    begin
       ArCRU[CRUi].voxels[voxeli].nRyRv:=NRyRi;
       NRyRi:=0; // done;
    end
        else
    // this voxel is full of RyRs
    begin
       NRyRi:= NRyRi - 16;
       ArCRU[CRUi].voxels[voxeli].nRyRv:=16
     end;
  end; // if NRyR>0;
end;


function FindLastNonZeroBin: integer;
var i: integer;
begin
  for i := High(CRUSizeDistr) downto 0 do
      if CRUSizeDistr[i]>0 then
    begin
     CRUSizeDistr[i]:= CRUSizeDistr[i] - 1;
     result:= i;
     exit;
    end;
 result:=-1;// not found;
end;


function FindFirstNonZeroBin: integer;
var i: integer;
begin
  for i := 0 to High(CRUSizeDistr) do
      if CRUSizeDistr[i]>0 then
    begin
     CRUSizeDistr[i]:= CRUSizeDistr[i] - 1;
     result:= i;
     exit;
    end;
 result:=-1;// not found;
end;


Procedure SetEqualBins;
var CRUsInOneBin, i, minBin, maxBin, nBins: integer;

begin
  minBin:= MinNRyRsInCRU div 16;
  maxBin:= MaxNRyRsInCRU div 16;

  nBins:=  maxBin - minBin+1;
  //https://testbook.com/learn/maths-consecutive-numbers/
  CRUsInOneBin:= round( TotalNRyRs/(16*0.5*nBins*(2*minBin + nBins-1)) );

  setlength(CRUSizeDistr, maxBin);
  for I := 0 to minBin-1 do
  begin
    CRUSizeDistr[i]:=0;
  end;

   if minBin=maxBin then
begin
   CRUSizeDistr[minBin-1]:=CRUsInOneBin;
   exit;
end;

//  for I := minBin to maxBin-1 do  CRUSizeDistr[i]:=RyRsInOneBin;
  for I := minBin to maxBin-1 do
  begin
    CRUSizeDistr[i]:=CRUsInOneBin;
  end;
end;


// Main procedure starts here
  begin
   // read interface
     MaxNRyRsInCRU:= StrToInt(Form1.Edit12.Text); // maximal # of RyRs in CRU
     MinNRyRsInCRU:= StrToInt(Form1.Edit24.Text); // main # of RyRs in CRU
//     nCRUs:=StrToInt(Form1.Edit13.Text); // total # of CRUs
     TotalNRyRs:=StrToInt(Form1.Edit5.Text); // total # of RyRs

    case Form1.Radiogroup1.ItemIndex of
      0:SetEqualBins;
      1:ReadRyRSizeDistribution(fParams.Memo1);
    end;

  // calculate total # of CRUs
    nCRUs:=0;
    for I := 0 to High(CRUSizeDistr) do  nCRUs:= nCRUs+ CRUSizeDistr[i];
 // grid size in x = xGridLen
 //  grid size in y = yGridLen
 // total # of sub voxels is  Num_Sub_voxels or   xGridLen*yGridLen
// let's try to accomadate all CRUs eqaally separated on the grid
// find number_jSRs_X, number_jSRs_Y: integer;
    area1:=  Num_Sub_voxels /nCRUs;
    jSR_grid_sz_exact:=sqrt(area1);
    jSR_grid_sz:= round(sqrt(area1));
    number_jSRs_X:= xGridLen div  jSR_grid_sz; //+1;
    number_jSRs_Y:= yGridLen div  jSR_grid_sz;


//    Let's make square grid

     MaxVoxelsN:= 0;
     MinVoxelsN:= maxint;

  // make xy array to mark JSR locations on the grid
          SetLength(Vacant_locations, yGridLen, xGridLen);
          for xi:=0 to xGridLen-1 do
//          for yi:=1 to yGridLen -1 do // !!! =1 ???
          for yi:=0 to yGridLen -1 do
          Vacant_locations[yi,xi]:= true;

        Randomize;
     NvoxelsInAllCRUs:=0;
     CRUi:=-1;
     RyRcount:= 0;

    repeat
    inc(CRUi);
    Setlength(ArCRU,CRUi+1);
    with ArCRU[CRUi] do
        begin // for each CRUi

   NRyR:= 16*(FindLastNonZeroBin+1);

           // if no RyRs, then step back
               if NRyR<=0 then
               begin
                     Setlength(ArCRU,CRUi);
                     dec(CRUi);
                     goto AllDone;
               end;

            // try to accomadate this CRU size in the grid
            Ntry:=0;
            repeat
                inc(Ntry); // count attempts
              // assign starting (seeding) coordinates for this CRU
                        x_JSR:= RandomRange(0, xGridLen);
                        y_JSR:= RandomRange(0, yGridLen);

          // set Ca sensor at the xy seed
               x:=  x_JSR;
               y:=  y_JSR;

             // find # of voxels for this CRU to accomadate all RyRs
             // maximum 16 RyRs of 30x30 nm in each voxel 120x120 nm
             if NRyR <=16 then Nvox:=1
             else
             begin
              Nvox:= NRyR div 16;
              if NRyR mod 16 > 0 then inc(Nvox);
             end;
             voxels:=nil;
             SetLength(voxels,Nvox);

             SizeMax:= trunc(sqrt(Nvox));
             if frac(sqrt(Nvox))>0 then inc(SizeMax);

             voxeli:=-1;
             NRyRi:= NRyR;
             // generates a random number among 1,2,3,4 (not 5)
             RandomRotation:=RandomRange(1, 5);

             case RandomRotation of
              1: begin
                   for i := 0 to SizeMax-1 do
                   for j := 0 to SizeMax-1 do
                   ProcessOneVoxel;
                 end;

              2: begin
                   for i := SizeMax-1 downto 0 do
                   for j := 0 to SizeMax-1 do
                   ProcessOneVoxel;
                 end;

              3: begin
                   for i := 0 to SizeMax-1 do
                   for j := SizeMax-1 downto 0 do
                   ProcessOneVoxel;
                 end;

              4: begin
                   for i := SizeMax-1 downto 0 do
                   for j := SizeMax-1 downto 0 do
                   ProcessOneVoxel;
                 end;

             end;
              NVoxels:=voxeli+1;  // !!!
              until No_overlap2(CRUi) or (Ntry>1000); // this CRU must fit vacant voxels

         // if the CRU cannot fit vacant voxels
         if Ntry>10000 then
               begin
                     Setlength(ArCRU,CRUi);  // step back
                     dec(CRUi);
                     goto AllDone;
               end;



         // we have just created a CRU, now let's record its properties
          MarkLocations2(CRUi); // mark occupied voxels
          RyRcount:= RyRcount + NRyR;
          Dyadic_volume_liter:=NVoxels*VoxelSub.V1_liters*V_cyt_part;
          JSR1_volume_mkm3:= NVoxels * GridSz_mkm * GridSz_mkm* jSR_depth_mkm;
          JSR1_volume_liter:= JSR1_volume_mkm3*1e-15;
          Ispark_at_1mM_CaJSR1:= NRyR* Iryr_at_1mM_CaJSR; // pA
          NvoxelsInAllCRUs:= NvoxelsInAllCRUs+ NVoxels;


          if NVoxels > MaxVoxelsN then  MaxVoxelsN:=NVoxels;
          if NVoxels < MinVoxelsN then MinVoxelsN:= NVoxels;
        end; // for CRUi

        until (RyRcount>= TotalNRyRs);


      AllDone:

   // all CRUs have been created
      nCRUs:=CRUi+1;
      TotalNRyRs:= RyRcount; // record the number of RyRs that was really created

      // Total junctional SR volume
      Form1.label25.Caption:=  'TotalNCRUs real= '+ IntToStr(nCRUs);
      Form1.label31.Caption:=  'TotalNRyRs real = ' + IntToStr(TotalNRyRs);
      if Ntry <10000 then
         Form1.label14.Caption:='Successs= Yes'  else
      begin
       Form1.label14.Caption:='Successs= No';
       MessageDlg('Cannot populate the CRU network',mtWarning, [mbOK], 0);
      end;


      V_JSR_total_mkm3 := NvoxelsInAllCRUs*GridSz_mkm * GridSz_mkm*Sub_depth_mkm;

      // set Ispark
      Vacant_locations:=nil; // free memory

      show_distr_of_CRUs;

  end;// proc


//////////////////////////////////////////////////////////////////



procedure Set_Diffusion;
var s_mkm2, distance_mkm: double;
 Tau, Tau1X, Tau1Y, DeltaT :double;
 v2_div_sum_v1_and_v2, Tau1, Tau2: double;
 Sx_mkm2, //   Sx_mkm2,  // boarding area in Y direction - around cell cross section
 Sy_mkm2:  //  Sy_mkm2,  // boarding area in X direction - along cell length
 double;
 CRUi:integer;

begin
// Diffusion within subspace cytosol: v1=v2 and τ1 = τ2
with  VoxelSub  do
  begin
   DeltaT:= TimeTick;
   // for diffusion along X, Ca crosses Y area shaped as a part of the ring
   Sy_mkm2:= (Pi*sqr(R_cell_mkm)- Pi*sqr(R_cell_mkm - Sub_depth_mkm))/ NvoxY;
   Tau1X:=  V1_mkm3 * dX_mkm / (DCyt_mkm2_per_ms * Sy_mkm2);
   FCC_CytSubX:= 0.5*(1- exp(-2*DeltaT/Tau1X));
   //  for diffusion along Y, Ca crosses X area shaped as as a rectangle
   Sx_mkm2:= Sub_depth_mkm * (SzX * GridSz_mkm); // exact
   Tau1Y:=  V1_mkm3 * dY_mkm / (DCyt_mkm2_per_ms * Sx_mkm2);
   FCC_CytSubY:= 0.5*(1- exp(-2*DeltaT/Tau1Y));
  end;


with  VoxelRing  do    // v1=v2 and τ1 = τ2,
  begin
   // Diffusion within ring cytosol
   DeltaT:= TimeTick;
  // for diffusion along X, Ca crosses Y area shaped as a part of the ring
   Sy_mkm2:= (Pi*sqr(R_cell_mkm-Sub_depth_mkm)- Pi*sqr(R_core_mkm))/ NvoxY;
   Tau1X:=  V1_mkm3 * dX_mkm / (DCyt_mkm2_per_ms * Sy_mkm2);
   FCC_CytRingX:=0.5*(1- exp(-2*DeltaT/Tau1X));
//  for diffusion along Y, Ca crosses X area shaped as as a rectangle
  Sx_mkm2:= VoxelRing_depth_mkm * SzX * GridSz_mkm;
   Tau1Y:=  V1_mkm3 * dY_mkm / (DCyt_mkm2_per_ms * Sx_mkm2);
   FCC_CytRingY:=0.5*(1- exp(-2*DeltaT/Tau1Y));

 // Diffusion within ring FSR
   DeltaT:= NTicks_Diffu2D_Ring_FSR*TimeTick;
   Tau1X:=  V1_mkm3 * dX_mkm / (DFSR_mkm2_per_ms * Sy_mkm2);
   FCC_FSRRingX:=0.5*(1- exp(-2*DeltaT/Tau1X));
   Tau1Y:=  V1_mkm3 * dY_mkm / (DFSR_mkm2_per_ms * Sx_mkm2);
   FCC_FSRRingY:=0.5*(1- exp(-2*DeltaT/Tau1Y));
  end;


// Diffusion between a subspace voxel and a ring voxel
 DeltaT:= TimeTick;
 distance_mkm:= Sub_depth_mkm/2 + VoxelRing_depth_mkm/2;
 s_mkm2:=   2*Pi*(R_cell_mkm - Sub_depth_mkm)*L_cell_mkm/(VoxelSub.NvoxX*VoxelSub.NvoxY);
 Tau1:=VoxelSub.V1_mkm3*distance_mkm/(DCyt_mkm2_per_ms * s_mkm2);
 Tau2:=VoxelRing.V1_mkm3*distance_mkm/(DCyt_mkm2_per_ms * s_mkm2);
 Tau:= (Tau1*Tau2)/(Tau1+Tau2);
 v2_div_sum_v1_and_v2:=  VoxelRing.V1_mkm3/(VoxelSub.V1_mkm3+VoxelRing.V1_mkm3);
 FCC_CytSubToRing:= v2_div_sum_v1_and_v2*(1- exp(-DeltaT/Tau));
 Volume_ratio_VoxelSub_to_VoxelRing:=  VoxelSub.V1_mkm3/VoxelRing.V1_mkm3;

// Diffusion between ring and the core
with  VoxelRing  do
  begin
   distance_mkm:= R_core_mkm + VoxelRing_depth_mkm/2;
   s_mkm2:= dX_mkm * (2*Pi*R_core_mkm)/NvoxY;
   Volume_ratio_VoxelRing_to_Core:= V1_mkm3/V_core_mkm3;
   // in cytosol
   DeltaT:=  NTicks_Diffu_Ring_to_Core_Cyt*TimeTick;
   Tau1:=V1_mkm3*distance_mkm/(DCyt_mkm2_per_ms * s_mkm2);
   Tau2:= V_core_mkm3*distance_mkm/(DCyt_mkm2_per_ms * s_mkm2);
   Tau:= (Tau1*Tau2)/(Tau1+Tau2);
   v2_div_sum_v1_and_v2:=  V_core_mkm3/(V_core_mkm3+V1_mkm3);
   FCC_CytRingToCore:= v2_div_sum_v1_and_v2*(1- exp(-DeltaT/Tau));
  // in FSR
   DeltaT:=  NTicks_Diffu_Ring_to_Core_FSR*TimeTick;
   Tau1:=V1_mkm3*distance_mkm/(DFSR_mkm2_per_ms * s_mkm2);
   Tau2:= V_core_mkm3*distance_mkm/(DFSR_mkm2_per_ms * s_mkm2);
   Tau:= (Tau1*Tau2)/(Tau1+Tau2);
   v2_div_sum_v1_and_v2:=  V_core_mkm3/(V_core_mkm3+V1_mkm3);
   FCC_FSRRingToCore:= v2_div_sum_v1_and_v2*(1- exp(-DeltaT/Tau));

  // Diffusion between FSR and JSR:
  DeltaT:=   NTicks_Diffu_FSR_to_JSR*TimeTick;
  FOR CRUi:=0 to nCRUs-1 do
with ArCRU[CRUi] do
    begin
     Volume_ratio_jSR_to_FSR_in_VoxelRing1:= JSR1_volume_mkm3/(V1_mkm3*V_fSR_part);
     v2_div_sum_v1_and_v2:=  V1_mkm3*V_fSR_part/(JSR1_volume_mkm3+V1_mkm3*V_fSR_part);
     Tau:= Tau_FSR_JSR_ML_model * v2_div_sum_v1_and_v2;
     Tau:=  NVoxels * Tau;
     FCC_FSRtoJSR1:= v2_div_sum_v1_and_v2*(1- exp(-DeltaT/Tau));
    end;
  end;
end; // proc Set_Diffusion


procedure Set_SERCA_tabulation;
var i:integer;
begin
// We use tabulated SERCA formulation because calclulation of power function is very slow
for i:=1 to SERCA_tab_max do
begin
//             SERCA_i :=  power(Ca_cytosol/Kmf, H_SERCA);
//          	 SERCA_SR := power(Ca_in_SR/Kmr, H_SERCA);
  SERCA_i_tab[i]:= power(i*1e-6/Kmf, H_SERCA);
  SERCA_SR_tab[i]:=  power(i*1e-5/Kmr, H_SERCA);
end;
end; // proc



procedure Set_electrophysiology;
var r:double;
var CRUi:integer;
  begin
    EK:=  RTdivF * ln(Ko/Ki);   //   Equilibrium potential for K+, mV
    EKs:= RTdivF * ln((Ko + 0.12* Nao)/(Ki + 0.12 * Nai)); //   Reversal potential of IKs, mV
    ENa:= RTdivF * ln(Nao/Nai); //   Equilibrium potential for Na+, mV
    // Electrical capacitance
    Cm:=  C_pF_per_mkm2 *S_cell_mkm2;
    // Maximum Cav1.3 and Cav1.2 ICaL conductance of cell membrane facing the dyadic space of one CRU

        FOR CRUi:=0 to nCRUs-1 do
        with ArCRU[CRUi] do
        begin
           CRUgCav12:= Cm*gCaL*frac12_gCaL*NVoxels/NvoxelsInAllCRUs;
           CRUgCav13:= Cm*gCaL*frac13_gCaL*NVoxels/NvoxelsInAllCRUs;
        end;

    // Maximum INCX current of 1 grid area
     INCX_max_1_voxel:=kNCX*Cm/Num_Sub_voxels;
    // Constant part of INaK
    kNaK:= Cm*InaKmax /((1 + power(KmKp/Ko,1.2))*(1+ power(KmNap/Nai,1.3)));
    Iext:=0;
  end;

Procedure Set_Tick_Counters;
  begin
    // set tick counters for integration of slow diffusion
    iTicks_Diffu2D_Ring_fSR:=0;
    iTicks_Diffu_FSR_to_JSR:=0;
    iTicks_Diffu_Ring_to_Core_FSR:=0;
    iTicks_Diffu_Ring_to_Core_Cyt:=0;
    iTicks_SERCA:=0;
  end;

// procedure to set initial values
procedure Set_initial_values;
var CRUi:integer;
begin
// [Ca] in mM
  Initial_Ca_Cyt:= 120*1e-6; // Initial Ca concentration in cytosol
  Initial_Ca_fSR:=1; //1; // Initial  Ca concentration of free SR
  //Initial_Ca_jSR:=1; // 0.8; // Initial Ca concentration in junctional SR
  Initial_Ca_jSR:= StrToFloat(fParams.edit15.Text); // Sr_Ca_t0_mM
  Initial_fCM_cyt:= 0.0787; //Fractional occupancy of calmodulin by Ca in myoplasm
  Initial_fCM_sub:=0.0575; //Fractional occupancy of calmodulin by Ca in submembrane space
  Initial_fCQ_jsr:=0.6; //Fractional occupancy of calsequestrin by Ca in junctional SR
  Initial_fCa:=1; // ICaL availablity  via Ca-dependent inactivation


  if fParams.CheckBox7.Checked then // FCQ is balanced with Ca_jSR
  Initial_fCQ_jsr:=  kfCQ *Initial_Ca_jSR/(kfCQ *Initial_Ca_jSR+kbCQ);


// set initial values in cell compartments
  Ar2D_Set_Value(ArSubCyt, Initial_Ca_Cyt); // subspace Ca
  Ar2D_Set_Value(ArRingCyt, Initial_Ca_Cyt); // cytosol Ca
  Ar2D_Set_Value(ArRingFSR,  Initial_Ca_fSR); // free SR Ca

// set initial values in calmodulin local variables
  Ar2D_Set_Value(ArRingfCM, Initial_fCM_cyt); // Fractional occupancy of calmodulin by Ca in myoplasm
  Ar2D_Set_Value(ArSubfCM, Initial_fCM_sub); // Fractional occupancy of calmodulin by Ca in submembrane space

// set initial values in the core
  CoreCyt:= Initial_Ca_Cyt;
  CoreFSR:=Initial_Ca_fSR;
  CorefCM:=Initial_fCM_cyt;

// CRU ini values
    for CRUi:=0 to nCRUs -1 do
  with ArCRU[CRUi] do
  begin
         TimeOpen :=0;
         TimeClosed :=0;
         Open := false;
         CajSR1:=  Initial_Ca_jSR;
         fCQ :=   Initial_fCQ_jsr;
         fCa:=Initial_fCa;
         Ispark:=0;
         Ispark_before:=0;
         activation:=0;
         inactivation:=0;
  end; // with

  // set default ini values for ion currents
  Vm:=	-57.9639346865;
  dL13:=	0.000584545564405;
  fL13:=	0.862381249774;

  dL12:=dL13;
  fL12:=fL13;

  //Note: fCa is local and it is a property of the CRU object
  paF:=	0.144755091176;
  paS:=	0.453100576739;
  pi_:=	0.849409822329;
  n:=	0.0264600410928;
  y:=	0.113643187247;
  dT:=	0.00504393374639;
  fT:=	0.420757825415;
  q:=	0.694241313965;
  r:=	0.00558131733359;

end; // proc set ini values



//  Model execution pocedures

procedure Do_SERCA_puming_ring;
var
xi, yi: integer;
dCa :double;
Ca_cytosol_tab, Ca_in_SR_tab:integer;
SERCA_i, SERCA_SR:double;
begin
with VoxelRing do
  begin
          for xi:=0 to   NvoxX -1 do
          for yi:=0 to   NvoxY -1 do
    begin
       Ca_cytosol_tab:= round(ArRingCyt[yi,xi]/1e-6);
       SERCA_i := SERCA_i_tab[Ca_cytosol_tab];
       Ca_in_SR_tab:= round( ArRingFSR[yi,xi]/1e-5);
       SERCA_SR:=  SERCA_SR_tab[Ca_in_SR_tab];
       dCa:= NTicks_SERCA*TimeTick * Pup *(SERCA_i - SERCA_SR)/(1+SERCA_i +SERCA_SR);
       ArRingfSR_dCa[yi,xi]:=ArRingfSR_dCa[yi,xi] + dCa;
       ArRingCyt_dCa[yi,xi]:= ArRingCyt_dCa[yi,xi] - dCa* Volume_ratio_fSR_to_cyt;
     end; // for xi... for yi
   end;// with Voxel
end; // proc


procedure Do_SERCA_pumping_core;
var
SERCA_i, SERCA_SR:double;
dCa:double;
  begin
     SERCA_i :=  power(CoreCyt/Kmf, H_SERCA);
     SERCA_SR:=  power(CoreFSR/Kmr, H_SERCA);
     dCa:= NTicks_SERCA*TimeTick * Pup *(SERCA_i - SERCA_SR)/(1+SERCA_i +SERCA_SR);
     CoreFSR_dCa:=CoreFSR_dCa + dCa;
     CoreCyt_dCa:= CoreCyt_dCa - dCa* Volume_ratio_fSR_to_cyt;
  end; // proc


procedure Do_BufferCM(Voxel:VoxelType; Ar_Ca:Ar2Dtype; var Ar_fCM, Ar_dCa:Ar2Dtype);
var
  xi, yi: integer;
  fCMs1, dfCMsdt :double;
begin
 for xi:=0 to   Voxel.NvoxX -1 do
 for yi:=0 to   Voxel.NvoxY -1 do
  begin
      fCMs1:=Ar_fCM[yi,xi];
      dfCMsdt:= kfCM *Ar_Ca[yi,xi]*(1 - fCMs1) - kbCM * fCMs1;
      Ar_fCM[yi,xi]:=fCMs1+dfCMsdt*TimeTick;
      Ar_dCa[yi,xi]:=  Ar_dCa[yi,xi] -CM_total *dfCMsdt*TimeTick;
  end; // for xi... for yi
end; // proc


procedure Do_Buffer_CQ_jSR;
var CRUi: integer;
dfCQdt, dCadt :double;
begin
  for CRUi:=0 to  nCRUs -1 do
   begin
     with ArCRU[CRUi] do
     begin
       dfCQdt:=   kfCQ *CajSR1*(1- fCQ) -  kbCQ * fCQ;
       fCQ:=fCQ+dfCQdt*TimeTick;
       dCadt:=  - CQtot * dfCQdt;
       CajSR1:=CajSR1+ dCadt*TimeTick;
     end;// with
   end; // for
end;// proc


procedure Do_Buffer_CM_Core;
var
dfCMdt_core :double;
  begin
      dfCMdt_core:= kfCM *CoreCyt*(1 - CorefCM) - kbCM * CorefCM;
      CorefCM:=CorefCM+dfCMdt_core*TimeTick;
      CoreCyt_dCa:= CoreCyt_dCa - CM_total*dfCMdt_core*TimeTick;
  end; // proc


Procedure Do_Diffusion2D(Voxel:VoxelType;FCCx,FCCy:double;ArCa:Ar2Dtype;var ArdCa:Ar2Dtype);
var
xi, yi, xi_next, yi_next: integer;
DeltaCa:double;

begin
  with Voxel do
  begin
     for xi:=0 to   NvoxX -1 do
       begin
        // Find xi_next and  then yi_next, indexes of right and top neighboring voxels
        xi_next:=xi+1;
        if  xi_next = NvoxX then xi_next:=0;

           for yi:=0 to   NvoxY -1 do
           begin
          // diffusion along X
          // recieving voxel is [yi, xi]
              DeltaCa:= ArCa[yi,xi_next] - ArCa[yi,xi];
              ArdCa[yi,xi]:= ArdCa[yi,xi]+ DeltaCa * FCCx;
          // Because voxels are of same volume,
          // dCa value is the same for two neighboring voxels, but comes with different signs
            ArdCa[yi,xi_next]:= ArdCa[yi,xi_next] - DeltaCa * FCCx;

          // diffusion along Y
              yi_next:=yi+1;
                  if  yi_next = NvoxY then yi_next:=0;
              DeltaCa:= ArCa[yi_next,xi] - ArCa[yi,xi];
              ArdCa[yi,xi]:= ArdCa[yi,xi]+ DeltaCa *FCCy;
              ArdCa[yi_next,xi]:= ArdCa[yi_next,xi] - DeltaCa *FCCy;

           end; // for yi
         end; // for xi
   end; // with Voxel
end; // proc


//  Diffusion between Cytosol ring and cell Core
Procedure Do_Diffusion_ring_and_core_Cyt;
var xi, yi: integer;
dCa:double;
begin
  with VoxelRing do
  begin
          for xi:=0 to   NvoxX -1 do
          for yi:=0 to   NvoxY -1 do
   begin
    dCa := (CoreCyt - ArRingCyt[yi,xi])* FCC_CytRingToCore;
    ArRingCyt_dCa[yi,xi]:= ArRingCyt_dCa[yi,xi] + dCa;
    CoreCyt:= CoreCyt - dCa*Volume_ratio_VoxelRing_to_Core;
   end;  // for xi, yi
  end; // with Voxel
end; // proc


//  Diffusion between fSR ring and cell Core
Procedure Do_Diffusion_ring_and_core_fSR;
var xi, yi: integer;
dCa:double;
begin
with VoxelRing do
  begin
          for xi:=0 to   NvoxX -1 do
          for yi:=0 to   NvoxY -1 do
   begin
    dCa := (CoreFSR - ArRingFSR[yi,xi]) * FCC_FSRRingToCore;
    ArRingfSR_dCa[yi,xi]:= ArRingfSR_dCa[yi,xi] + dCa;
    CoreFSR:= CoreFSR - dCa*Volume_ratio_VoxelRing_to_Core;
   end;  // for xi, yi
  end; // with Voxel
end; // proc


Procedure Do_Diffusion_Sub_and_Ring_Cyt;
var
xi_sub, yi_sub: integer;
xi_ring, yi_ring: integer;
DifferenceCa, dCa:double;
begin
  with VoxelSub do
  begin
    for xi_sub:=0 to   NvoxX -1 do
    for yi_sub:=0 to   NvoxY -1 do
     begin
        // find receiving voxel in ring
        xi_ring:= xi_sub div VoxelRing.SzX;
        yi_ring:= yi_sub div VoxelRing.SzY;
        //find dCa
        DifferenceCa:= ArRingCyt[yi_ring,xi_ring] - ArSubCyt[yi_sub,xi_sub];
        dCa:=  DifferenceCa*FCC_CytSubToRing;
        //update Ca arrays
        ArSubCyt_dCa[yi_sub,xi_sub]:= ArSubCyt_dCa[yi_sub,xi_sub] + dCa;
        ArRingCyt_dCa[yi_ring,xi_ring]:=
        ArRingCyt_dCa[yi_ring,xi_ring]- dCa*Volume_ratio_VoxelSub_to_VoxelRing;
     end; // for xi... for yi
  end; // with VoxelSub
end; // proc


Procedure Do_Diffusion_fSR_jSR;
var CRUi:integer;
var xx, yy: integer;
var yy_Ring, xx_Ring: integer;
//CajSR1_begin :double;
dCa, DeltaCa:double;
voxeli:integer;
begin
  for CRUi:=0 to  nCRUs -1 do
     with ArCRU[CRUi], VoxelRing do
     begin
       for voxeli := 0 to NVoxels-1 do
         begin
          // Ca diffusion via 1 diffusion connection (made in 1 grid voxel)
          // from 1 ring voxel (FSR part) to the entire JSR
          // We have NVoxels = NRyR/16 such connections
          // Let's find the ring voxel corresponding the JSR connetion
           xx:= voxels[voxeli].xv;
           yy:= voxels[voxeli].yv;
           xx_Ring:= xx div SzX;
           yy_Ring:= yy div SzY;
           IndexCircling(NvoxX,xx_Ring);
           IndexCircling(NvoxY,yy_Ring);
          // Then find the Ca gradient
            DeltaCa := ArRingFSR[yy_Ring,xx_Ring] - CajSR1;
          // find dCa during time tick in the JSR
            dCa:= DeltaCa*FCC_FSRtoJSR1;
          // update Ca_in_JSR after the change
            CajSR1 := CajSR1 + dCa;
           // new_Ca_in_FSR:
            ArRingfSR_dCa[yy_Ring,xx_Ring]:= ArRingfSR_dCa[yy_Ring,xx_Ring]
           - dCa* Volume_ratio_jSR_to_FSR_in_VoxelRing1;
       end;
     end;// for CRUi with ArCRU[i], VoxelRing
end;// proc



// This procedure distributes injected Ca to a CRU evenly among
// voxels of subspace (dyadic space) of that CRUi
// Ca injected via either ICaL or RyRs
procedure Do_dCa_dyadic_space(CRUi: integer; inject_Ca_mM: double);
var xx_temp, yy_temp: integer;
dCa_mM_per_liter: double;
voxeli: integer;

begin
   with ArCRU[CRUi] do
  begin
    dCa_mM_per_liter:=  inject_Ca_mM / Dyadic_volume_liter;
    for voxeli := 0 to NVoxels -1 do
    begin
      xx_temp:= voxels[voxeli].xv;
      yy_temp:=voxels[voxeli].yv;
      ArSubCyt_dCa[yy_temp,xx_temp]:= ArSubCyt_dCa[yy_temp,xx_temp] + dCa_mM_per_liter
    end;
  end;
end; // proc



Procedure Do_CRUs;
var CRUi: integer;
Casub_local,
ionsCa_released_in_mM,
p, // probability of firing
random0: double;
//Ispark_previous_tick:double;
CajSR1_future: double;
Ispark_Termination_now: double;
I_one_RyR: double;





var
   psp_vs_casjsr: double;

begin
for CRUi:=0 to  nCRUs -1  do // for loop for all CRUs
  with ArCRU[CRUi] do // process CRU with index CRUi
     begin
       Casub_local:= ArSubCyt[y,x];  // voxel of Ca sensor

           if not Open then // try to open this CRU
         begin
             inc(TimeClosed);


                      if CajSR1>=CaJSR_spark_activation then      // if CaJSR reaches a critical value for activation phase transition
                   begin
                      p:= ScalingPobConst*(CRU_ProbConst/144) * NRyR* power((Casub_local/CRU_Casens ), CRU_ProbPower)*BorderEffect[NRyR]*TimeTick;

                     random0 := Random; // generates a random # with the range of [0, 1)
                     if (random0 < p) then
                       begin // firing begins
                          Open:=true;
                          TimeOpen:=0;
                          Ispark:=0;
                       end;// if random
                   end; // id CajSR1>=CaJSR_spark_activation

         end; //if not open, i.e. if closed



           if Open then // CRU generates Ispark and may close if the current is too small
            begin
               inc(TimeOpen);
            // activation kinetics of Ispark
              activation:= 1- exp(-TimeOpen/Ispark_activation_tau_in_timeticks); // simple exponential =0 at t=0 and =1 at t=infinity
              inactivation:= exp(-TimeOpen/Ispark_inactivation_tau_in_timeticks); // simple exponential =1 at 0 and = 0 at t=infinity

              Ispark:=activation*inactivation*Ispark_at_1mM_CaJSR1 * (CajSR1 - Casub_local);
              I_one_RyR:= Iryr_at_1mM_CaJSR *  (CajSR1 - Casub_local);
            // Let's find released Ca ammount in mM
            // current in pA, factor e-12, and TimeTick in ms
             ionsCa_released_in_mM:= Ispark*TimeTick *(1e-12)/FaradayConst_x_2;
            // Deplete Ca JSR for the time tick
            // but not more than CaJSR realy has to avoid Ca leak from system!
            // testing if all Ca in jSR is released
             CajSR1 :=  CajSR1 - ionsCa_released_in_mM/ JSR1_volume_liter;

             // testing if all Ca in jSR is released
              if  CajSR1<0 then
              begin
                CajSR1:=0;
                ionsCa_released_in_mM :=   CajSR1*JSR1_volume_liter;
                Ispark:= ionsCa_released_in_mM/(TimeTick *(1e-12)/FaradayConst_x_2);
              end;
              Do_dCa_dyadic_space(CRUi, ionsCa_released_in_mM);

     // Terminate spark only when Ispark becomes decaying

            if Ispark < Ispark_before then
                  begin

                           Ispark_Termination_now:= I_one_RyR*Ispark_Termination_scale;

                      // try to terminate the spark
                  if  Ispark < Ispark_Termination_now then
                     begin
                       Open:=false;
                       TimeClosed:=0;
                       Ispark:=0;
                       activation:=0;
                       inactivation:=0;
                     end;

                  end; //// if Ispark < Ispark_before

             Ispark_before:=Ispark; // save current Ispark for next tendency check

//           end; // if Check_trends_boo
          end;// if open

      end; // for CRUi, with CRUi,
end; // proc


/////////////////////////////////////////////////////////////
Procedure Do_Update_Ca;
var xi, yi:  integer;
begin
 // local Ca is updated each time tick by adding dCa
          for xi:=0 to   VoxelSub.NvoxX -1 do
          for yi:=0 to   VoxelSub.NvoxY -1 do
     begin
         ArSubCyt[yi,xi]:= ArSubCyt[yi,xi] + ArSubCyt_dCa[yi,xi];
     end; // xi, yi

         for xi:=0 to   VoxelRing.NvoxX -1 do
         for yi:=0 to   VoxelRing.NvoxY -1 do
     begin
         ArRingCyt[yi,xi]:= ArRingCyt[yi,xi] + ArRingCyt_dCa[yi,xi];
         ArRingFSR[yi,xi]:= ArRingFSR[yi,xi] + ArRingfSR_dCa[yi,xi];
      end; // xi, yi

    CoreFSR:=CoreFSR + CoreFSR_dCa;
    CoreCyt:= CoreCyt+ CoreCyt_dCa;
end;// proc


// procedures for Electrophysiology in run time

// A common procedure to find ion current gating variables:
// x = dL, fL, fCa, dT, fT, etc.
procedure Find_Gating(x_inf, tau_x:double; var x:double);
var dxdt:double;
begin
  dxdt:=(x_inf - x)/tau_x;
  x:= x+ dxdt*TimeTick;
end;

procedure Find_ICaL(V:double); // total L-type Ca2+ current
var CRUi: longint;
tau_dL, tau_fL, tau_fCa :double;
DL_inf, FL_inf, fCa_inf, alfa_dL, beta_dL: double;
ICaL12_CRUi, ICaL13_CRUi :double;
inject_Ca_in_mM: double;

  begin
      ICaL12:=0;
      ICaL13:=0;
  // First calculate voltage-dependent parameters common for Cav1.3 and Cav1.2
  // Voltage-dependent activation
     if V=0 then V:=0.00001;  // avoiding 0/0
     alfa_dL:= -0.02839*(V+ 35)/ (exp(-(V+35)/2.5 )- 1)-0.0849 * V / (exp(-V/4.8)- 1);
     if V=5 then  V:=5.00001; // avoiding 0/0
     beta_dL:= 0.01143 * (V - 5)/ (exp((V- 5)/2.5) -1);
     tau_dL:=1/(alfa_dL+beta_dL);
  // Voltage-dependent inactivation
     tau_fL:=  k_TauFL*(257.1 * exp(-sqr((V+ 32.5)/13.9)) + 44.3); // sqr(x)=x*x

         // specific for Cav1.2
      // Voltage-dependent pat
         DL_inf:=1/(1+ exp(-(V+6.6)/6));   // GJP
         Find_Gating(dL_inf, tau_dL, dL12);
         FL_inf:=1/(1+exp((V +35)/7.3));
         Find_Gating(FL_inf, tau_fL, fL12);

         // specific for Cav1.3
      // Voltage-dependent part
         DL_inf:=1/(1+ exp(-(V+13.5)/6));   // M-L model
         Find_Gating(dL_inf, tau_dL, dL13);
         FL_inf:=1/(1+exp((V +35)/7.3));
         Find_Gating(FL_inf, tau_fL, fL13);

  // Cav1.2 and Cav1.3 are located in CRUs
    for CRUi:=0 to  nCRUs -1 do // for-loop to find ICaLi in each CRUi
         with ArCRU[CRUi] do
        begin
         //ArCRU[CRUi].

  // Ca-dependent inactivation of ICaL_local in each CRU
            fCa_inf:=1/(1 + ArSubCyt[y,x]/KmfCa);   // ArSubCyt[y,x] is the voxel of Ca sensor
            tau_fCa:= fCa_inf/alfafCa;
            Find_Gating(fCa_inf, tau_fCa, fCa);// find new fCa

            ICaL12_CRUi:=CRUgCav12*(V- ECaL)* dL12*fL12 * fCa;
            ICaL13_CRUi:=CRUgCav13*(V- ECaL)* dL13*fL13 * fCa;

      //integration of local currents to get whole-cell ICaL for Cav1.2 and Cav1.3
            ICaL12:= ICaL12 + ICaL12_CRUi;
            ICaL13:= ICaL13 + ICaL13_CRUi;
            // Now let's find Ca injected into CRUi via local ICaL
            // Current is in pA. With the factor 1e-12 and time in ms, [Ca] is in mM.
            // Inward ICaL is negative, and factor -1 gives positive flux
            // and increase of [Ca] in the dyadic space
            inject_Ca_in_mM := - (1e-12)*((ICaL12_CRUi + ICaL13_CRUi)/FaradayConst_x_2)*TimeTick;
            // change [Ca] in dyadic space due to Ca  influx of ICaL_local
            Do_dCa_dyadic_space(CRUi, inject_Ca_in_mM);
       end;// with

 ICaL:=  ICaL12+ICaL13;
end;





procedure Find_INCX(V:double);//  NCX current
var
  di, do_,k43,k12, k14, k41, k34, k21, k23, k32, x1, x2, x3, x4: double;
  xi, yi: integer;
  Casub_voxel, INCX_voxel :double;
  Add_Ca_mM_per_liter:double;
  di_1,  di_2,  k12_1,  k14_1: double;
begin
// NOTE   Qco =0 in Kurata model
  do_:=1+(Cao/Kco)*(1+exp(Qco * V/RTdivF))+(Nao/K1no)*
    (1+(Nao/K2no)*(1+Nao/K3no));
  k43:=Nai/(K3ni +Nai);
  k41 := exp(-Qn * V /(2*RTdivF));
  k34 :=Nao/(K3no+Nao);
  k21:=(Cao/Kco)*exp(Qco * V/RTdivF) /do_;
  k23 := (Nao/K1no)*(Nao/K2no)*(1+Nao/K3no)* exp(-Qn* V/(2*RTdivF))/do_;
  k32:=exp(Qn * V/(2*RTdivF));
  x1:= k34 * k41 *(k23 + k21) + k21 * k32 *(k43 + k41);

//let's first find  voltage dependent component common for all patches
  di_1:= (1/Kci)*(1 + exp(-Qci * V /RTdivF)+Nai/Kcni);
  di_2:= (Nai/K1ni)*(1 +(Nai/K2ni)*(1 +Nai/K3ni));
  k12_1:= (1/Kci)* exp(-Qci* V/RTdivF);
  k14_1:= (Nai/K1ni)*(Nai/K2ni)*
    (1 +Nai/K3ni)* exp(Qn * V /(2*RTdivF));

// now local Ca-dependent part
 INCX:=0;
 for xi:=0 to   VoxelSub.NvoxX -1 do
 for yi:=0 to   VoxelSub.NvoxY -1 do
 begin
  Casub_voxel:= ArSubCyt[yi,xi];

    di:=1+ Casub_voxel*di_1+di_2;
    k12:= Casub_voxel*k12_1/di;
    k14:= k14_1/di;

  x2:= k43* k32  *(k14 + k12) + k41* k12 *(k34 + k32);
  x3:= k43 * k14 *(k23 + k21) + k12 * k23*(k43 + k41);
  x4:= k34 * k23 *(k14 + k12) + k21 * k14* (k34+ k32);
  INCX_voxel:= INCX_max_1_voxel *(k21 * x2 - k12 * x1) / (x1 + x2 + x3 + x4);

//integration of whole-cell INCX from local currents
  INCX:=INCX + INCX_voxel;

 // Impact of NCX on local subspace Ca:
 // Ca current via NCX = 2*INCX because each net NCX transfer with ratio
 // of 3Na to 1Ca results in one elementary charge transfer, but
 // associated with one Ca ion transfer that has 2 elementary charges
 // Faraday constant should be doubled becuase Ca2+ has two elementary +charges
 // picoAmpers match picoliters and ms will give mM, no scaling factor is needed

 Add_Ca_mM_per_liter:=
 (2*INCX_voxel/FaradayConst_x_2)*TimeTick/(VoxelSub.V1_liters*V_cyt_part*1e12);
      ArSubCyt_dCa[yi,xi] := ArSubCyt_dCa[yi,xi] + Add_Ca_mM_per_liter;
 end; // for xi... for yi
end; // proc




// T-type Ca2+ current and background Ca current
procedure find_ICaT_and_IbCa(V:double);
var DT_inf, tau_dT, FT_inf, tau_fT:double;
dCa_mM_per_liter:double;
xi, yi:integer;
begin
// find ICaT
 DT_inf:=1/ (1 + exp(-(V + 26.3)/6.0));
 FT_inf:= 1/(1+  exp(  (V+ 61.7)/5.6));
 tau_dT:= 1/( 1.068  * exp(  (V+ 26.3)/30   ) + 1.068 * exp(-(V + 26.3)/30 ) );
 tau_fT :=1/( 0.0153 * exp(- (V + 61.7)/83.3) + 0.015 * exp( (V + 61.7)/15.38));
 Find_Gating(dT_inf, tau_dT, dT);
 Find_Gating(fT_inf, tau_fT, fT);
 ICaT:= Cm*gCaT * (V- ECaT)* dT* fT;
 // find IbCa
 IbCa:= Cm*gbCa*(V - ECaL);
// find local Ca change via ICaT and IbCa that is the same in each voxel
 dCa_mM_per_liter:= - ((ICaT+IbCa)/FaradayConst_x_2)*TimeTick/V_sub_picoliter;
 for xi:=0 to   VoxelSub.NvoxX -1 do
 for yi:=0 to   VoxelSub.NvoxY -1 do
 begin
    ArSubCyt_dCa[yi,xi]:= ArSubCyt_dCa[yi,xi]+ dCa_mM_per_liter;
 end; // for xi... for yi
end;  // proc

// Rapidly activating delayed rectifier K+ current
procedure find_IKr(V:double);
var Pa_inf, Pi_inf, tau_paF, tau_paS, tau_pi:double;
begin
  Pa_inf:=1/ (1  +  exp(-(V+23.2)/10.6));
  Pi_inf:= 1/ (1 + exp(   (V + 28.6)/17.1));
  tau_paF:= k_IKr_Tau*(0.84655354/(0.0372 * exp((V)/15.9) + 0.00096 * exp(-(V)/22.5)));
  tau_paS:= k_IKr_Tau*(0.84655354/(0.0042 * exp((V)/17.0) +  0.00015  * exp(-(V)/21.6)));
  tau_pi:= 1/(0.1 * exp(-V/54.645) + 0.656 * exp(V/106.157));
  Find_Gating(pa_inf, tau_paF, paF);
  Find_Gating(pa_inf, tau_paS, paS);
  Find_Gating(pi_inf, tau_pi, pi_);
  IKr:=Cm*gKr*(V - EK)*(0.6* paF + 0.4 * paS)*  pi_;
end;  // proc

// Slowly activating delayed rectifier K+ current
procedure find_IKs(V:double);
var n_inf, alfa_n, beta_n,tau_n:double;
begin
  alfa_n:= 0.014/ (1 + exp(-(V- 40)/9));
  beta_n:= 0.001 * exp(-V/45);
  n_inf:= alfa_n/(alfa_n +beta_n);
  tau_n:=1/(alfa_n+beta_n);
  Find_Gating(n_inf, tau_n, n);
  IKs:= Cm*gKs*(V - Eks)*sqr(n); // sqr(n)=n*n
end;   // proc

// 4-AP-sensitive currents
procedure find_Ito_and_Isus(V:double);
var q_inf, r_inf, tau_q, tau_r:double;
begin
  q_inf:=1/(1 + exp((V+ 49)/13));
  r_inf:=1/(1 + exp(-(V - 19.3)/15));
 tau_q:= 39.102/(0.57*exp(-0.08*(V+44))+0.065*exp(0.1*(V+45.93)))+ 6.06;
 tau_r:=14.40516/(1.037*exp(0.09*(V+30.61))+0.369*exp(-0.12*(V+23.84)))+2.75352;
  Find_Gating(q_inf, tau_q, q);
  Find_Gating(r_inf, tau_r, r);
  Ito:= Cm*gto*(V- EK)* q* r;
  Isus:= Cm*gsus * (V - EK)* r;
end;   // proc

// Hyperpolarization-activated current
procedure find_If(V:double);
var
IhNa,   //  Na+ part of I_f
IhK:    //  K+ part of I_f
double;
y_inf, tau_y: double;
begin
  y_inf:= 1/(1 + exp((V-V_Ih12)/13.5));
  tau_y:= 0.7166529/(exp(-(V+ 386.9)/45.302) + exp((V - 73.08)/19.231));
  Find_Gating(y_inf, tau_y, y);
  IhNa:=Cm*0.3833 * gh *(V - ENa)*sqr(y) ; // sqr(y)=y*y
  IhK:= Cm*0.6167 * gh *(V -  EK)*sqr(y);
  I_f:=IhNa+ IhK;
end;   // proc


//  Na+/K+ pump current
procedure find_INaK(V:double);
begin
//INaK:= Cm*InaKmax /((1 + power(KmKp/Ko,1.2))*
//  (1+ power(KmNap/Nai,1.3))*(1+ exp(-(V- ENa+ 120)/30)));
// kNaK:= Cm*InaKmax /((1 + power(KmKp/Ko,1.2))*(1+ power(KmNap/Nai,1.3)));
 INaK:= kNaK/(1+ exp(-(V- ENa+ 120)/30));
end;   // proc




////////////////////////////////////////////////
procedure Model_setup;
var s: string;
begin
  // free memory
  ArCRU:=nil;
  Ar2D_free_memory;
  Read_Interface;

// Randomize sets random CRU firing and CRU distribution.
// It initiates the built-in random number generator with a random
// value obtained from the system clock
  Randomize;
  Set_geometry;
  Ar2D_Set_Size;
  Set_JSRs;
  Set_Diffusion;
  Set_SERCA_tabulation;
  Set_CRU_activation_and_termination;
  Set_electrophysiology;
  Set_initial_values;
  Set_Tick_Counters;
  
// set output
  Set_image;
  
 // Set simulation duration and output
  SimTickNumber:=0;
  SimTime:=0;
  SimOutputSampling_ticks:= round(SimOutputSampling_ms/TimeTick);

  SimOutputTick_counter:=0;
//  iTicks_test_trends:=0;
//  Check_trends_boo:= false;
  Stop_simulations:=false;

// outpout key parameters and model state at t=0
  WriteParams;
//  Update_Plots;
  Update_Image;

  // Set controls
  Form1.Enabled:=true;
  Form1.BringToFront;
  Form1.Button1.Enabled:= true;  // allow model to run
  Form1.Button9.Enabled:= true; // allow to make histogram
  Form1.label8.Caption:='None'; // reset file loading wit a new CRU distribution
  // specify Form caption to separate multiple parallel program runs
  if bAR_stimulation_apply then s:='bAR_' else s:='Basal';
  Form1.Caption:=s;

end; // proc

Procedure Model_Exit;
begin
// reset program for a new simulation
  Form1.Button1.Enabled:= false;
  Form1.Button9.Enabled:= false;
  Form1.label8.Caption:='None';
end;   // proc


///////////////// COMPUTING THE MODEL AND OUTPUT ////////////////
procedure Model_Run;
var CRUi:integer;
testg, time_save, time_now: Ttime;


begin
time_save:= time;
fPlotVm.Series1.Clear;

 repeat
   inc(SimTickNumber);
   SimTime:= SimTime+TimeTick;

  // bAR stimulation
   if bAR_stimulation_apply then
    if SimTime>= bAR_onset then
      begin
        gCaL := gCaL*(1 +(1.75-1)*bAR_percent/100);

                FOR CRUi:=0 to nCRUs-1 do
        begin
           ArCRU[CRUi].CRUgCav12:= Cm*gCaL*frac12_gCaL*ArCRU[CRUi].NVoxels/NvoxelsInAllCRUs;
           ArCRU[CRUi].CRUgCav13:= Cm*gCaL*frac13_gCaL*ArCRU[CRUi].NVoxels/NvoxelsInAllCRUs;
        end;

        V_Ih12 := -64 +7.8*bAR_percent/100;    //-56.2;
        gKr := gKr*(1 + (1.5-1)*bAR_percent/100);
        Pup := Pup*(1 + (2-1)*bAR_percent/100);

        bAR_stimulation_apply:= false; // apply only once, not every timetick
      end;



  // zeroing dCa arrays
   Ar2D_Set_Value(ArSubCyt_dCa, 0);
   Ar2D_Set_Value(ArRingCyt_dCa, 0);
   Ar2D_Set_Value(ArRingfSR_dCa, 0);
   CoreCyt_dCa:=0;
   CoreFSR_dCa:=0;


// Electrophysiology
// Find all membrane currents and their respective local Ca changes, if any
   Find_ICaL(Vm);
   Find_INCX(Vm);
   find_ICaT_and_IbCa(Vm);
   find_IKr(Vm);
   find_If(Vm);
   find_Ito_and_Isus(Vm);
   find_INaK(Vm);
   find_IKs(Vm);

Iext:=0;

// Update total membrane current Im
      Im:=ICaL+ICaT+IKr+IKs+Ito+Isus+I_f+INaK+INCX+IbCa+Iext;

// voltage clamp
 if Apply_voltage_clamp then
   begin
      if SimTime < V_Tbegin then Vm:= V_hold;
      if SimTime>= V_Tbegin then Vm:= V_pulse;
      if SimTime> V_Tend then Vm:= V_hold;
   end else
   begin
      dVdt:= -Im/Cm;
      Vm := Vm + dVdt * TimeTick;
   end;


// Ca buffers
// Buffer CaM in subspace
    Do_BufferCM(VoxelSub, ArSubCyt, ArSubfCM, ArSubCyt_dCa);
// Buffer CaM in ring
    Do_BufferCM(VoxelRing, ArRingCyt, ArRingfCM, ArRingCyt_dCa);
// Buffer CaM in the core
   Do_Buffer_CM_Core;

//Buffer Calsequestrin in JSR
 if fParams.CheckBox11.Checked then
   Do_Buffer_CQ_jSR;

 // Ca Diffusion within 2D layers
 // Ca Diffusion wthin subspace cytosol
  Do_Diffusion2D(VoxelSub,FCC_CytSubX, FCC_CytSubY, ArSubCyt, ArSubCyt_dCa);

  // Ca Diffusion within ring cytosol
  Do_Diffusion2D(VoxelRing,FCC_CytRingX, FCC_CytRingY, ArRingCyt, ArRingCyt_dCa);

// Ca Diffusion within ring FSR
   inc(iTicks_Diffu2D_Ring_fSR);    // tick counter
   if  iTicks_Diffu2D_Ring_fSR = NTicks_Diffu2D_Ring_FSR then
   begin
    Do_Diffusion2D(VoxelRing, FCC_FSRRingX, FCC_FSRRingY, ArRingFSR, ArRingfSR_dCa);
     iTicks_Diffu2D_Ring_fSR:=0;
     end;

// Radial Ca diffusion between layers
//Ca Diffusion Subspace - Ring in Cytosol
  Do_Diffusion_Sub_and_Ring_Cyt;

// Ca Diffusion ring - core in FSR
 inc(iTicks_Diffu_Ring_to_Core_FSR);  // tick counter
  if   iTicks_Diffu_Ring_to_Core_FSR =  NTicks_Diffu_Ring_to_Core_FSR then
 begin
  Do_Diffusion_ring_and_core_fSR;
  iTicks_Diffu_Ring_to_Core_FSR:=0;
 end;

 // Ca Diffusion ring - core in Cytosol
inc(iTicks_Diffu_Ring_to_Core_Cyt);   // tick counter
 if iTicks_Diffu_Ring_to_Core_Cyt =   NTicks_Diffu_Ring_to_Core_Cyt then
 begin
  Do_Diffusion_ring_and_core_Cyt;
  iTicks_Diffu_Ring_to_Core_Cyt:=0;
 end;

//  Ca Diffusion  FSR - JSR
 inc(iTicks_Diffu_FSR_to_JSR); // tick counter
 if  iTicks_Diffu_FSR_to_JSR= NTicks_Diffu_FSR_to_JSR then
 begin
   Do_Diffusion_fSR_jSR;
   iTicks_Diffu_FSR_to_JSR:=0;
 end;

 // Ca pumping by SERCA
 inc(iTicks_SERCA); // tick counter
if iTicks_SERCA = NTicks_SERCA then
 begin
   Do_SERCA_puming_ring;
   Do_SERCA_pumping_core;
   iTicks_SERCA:=0;
 end;

 // Ca Release
   Do_CRUs;

// Add dCa arrays to arrays of local Ca
  Do_Update_Ca;

  // Output

       inc(SimOutputTick_counter);
      if SimOutputTick_counter >= SimOutputSampling_ticks then // output tick counter
       begin
        SimOutputTick_counter:=0;
        Update_Plots;
        if Form1.CheckBox2.Checked then Update_Image;
       end;

// keep functional interface at least once in second
    if SecondOf(time - time_save) >=1  then
      begin
       Application.ProcessMessages;
       time_save:= time;
      end;

  // check trends
//   Check_trends_boo:= false;
//   inc(iTicks_test_trends);
//  if SimOutputTick_counter = NTicks_test_trends then // output tick counter   =10
//    begin
//      Check_trends_boo:= true;
//      iTicks_test_trends:=0;
//    end;

  until (SimTime >= SimTotalDuration_ms) or Stop_simulations;

end; // proc


procedure TForm1.Button11Click(Sender: TObject);
begin
Stop_simulations:=true;
end;




procedure TForm1.Button16Click(Sender: TObject);
begin
    fImage.Visible:= true;
    fImage.BringToFront;
end;


procedure TForm1.Button18Click(Sender: TObject);
begin
 fParams.Visible:=true;
 fParams.BringToFront;
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  Model_Run;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
    fPlotVm.Visible:=true;
    fPlotVm.BringToFront;

end;




procedure TForm1.Button31Click(Sender: TObject);
begin
  Stop_bo:= true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 fImage2.Visible:= true;
 fImage2.BringToFront;
end;


procedure TForm1.Button6Click(Sender: TObject); // model setup
begin
 Model_setup;
end;

  // Save model
procedure TForm1.Button7Click(Sender: TObject);
var s: string;
begin
  s:=Form1.Edit4.Text+'.txt';
  s:= IncludeTrailingPathDelimiter(s);
  savemodel(s+Form1.Edit6.Text);
end;


// read model
procedure TForm1.Button8Click(Sender: TObject);
begin
  readmodel;
end;

// nearest neighbor
procedure TForm1.Button9Click(Sender: TObject);
begin
  Make_histogram;
end;



procedure TForm1.Button21Click(Sender: TObject); // show distr or CRU sizes
begin
 show_distr_of_CRUs;
end;



procedure TForm1.Button22Click(Sender: TObject);// show NRyRs in CRU each size
begin
Show_NRyRs_in_CRU_of_each_size;
end;



////////////////////////////////////////////////////////////////
procedure TForm1.Button23Click(Sender: TObject); // repulsion simulation
var
repul_strength: double;
Friction,
Integration_dist: double;
i: integer;
Nticks, ticki:integer;
dt: double;
dir1, Fname1: string;



procedure find_repulsion_force;
var NRyRi, i, ii: integer;
dist1, dist2, dist3, distX, distY: double;
F, Fx, Fy, distance, x_test, y_test: double;
begin
// repulsion
  for i := 0 to High(ArCRU) do  // find force for each CRU
  begin
      ArCRU[i].ForceX:=0;
      ArCRU[i].ForceY:=0;
      x_test:= ArCRU[i].xe;
      y_test:= ArCRU[i].ye;
      NRyRi:=ArCRU[i].NRyR;

     for ii := 0 to High(ArCRU) do // with respect to all other CRUs
     with ArCRU[ii] do
     if ii <> i then
       begin

       // finding distance along x
       dist1:= -(xe-x_test); // distance directly
       dist2:= x_test+xGridLen-xe; // distance going around the torus right
       dist3:= -(xe+xGridLen-x_test); // distance going around the torus left
       if abs(dist3)<abs(dist2) then dist2:= dist3;
       if abs(dist1) < abs(dist2) then distX:=dist1 else  distX:=dist2;

       // finding distance along y
       dist1:= -(ye-y_test);
       dist2:= y_test+yGridLen-ye;
       dist3:= - (ye+yGridLen-y_test);
       if abs(dist3)<abs(dist2) then dist2:= dist3;
       if abs(dist1) < abs(dist2) then distY:=dist1 else  distY:=dist2;

        if not ((DistX=0) and  (DistY=0)) then // if not the same voxel
        begin
            distance:= sqrt(sqr(DistX)+sqr(DistY)); // find the distance in 2D
           if (distance <Integration_dist) then
//          if (abs(DistX)<Integration_dist) and (abs(DistY)<Integration_dist) then
         begin
            F:= repul_strength*NRyRi*NRyR/(sqr(distance));  // find force
            Fx:= F*distX/ distance; // find x projection of force
            Fy:= F*distY/ distance; // find y projection of force
            ArCRU[i].ForceX:= ArCRU[i].ForceX + Fx; // integrate force in x
            ArCRU[i].ForceY:= ArCRU[i].ForceY + Fy;  // integrate force in y
          end;


        end;
          // find fource only for close neighbours for compute speed
//          if (abs(DistX)<Integration_dist) and (abs(DistY)<Integration_dist) then
       end; // for CRUii
  end; // for i, with
end;


procedure find_distance_travel_dt;
var voxeli, dx, dy, xini, yini, i : integer;
distX, distY: double;

begin

  for i := 0 to High(ArCRU) do // for each CRU
  with ArCRU[i] do
  begin
      xini:= x;
      dx2dt:= (ForceX - Friction*dxdt)/nRyR;
    // D = v*t + 1/2*a*t^2
      distX:= dxdt*dt+0.5*dx2dt*dt*dt;
      xe:= xe+distX;
// getting x corrdinate in the grid in units by truncation of the exact coordinate
      x:=trunc(xe);
      dx:= x-xini;
      IndexCircling(xGridLen,x);
          xe:= x+frac(xe); // getting the exact coordinate after circling
      dxdt:= dxdt + dx2dt*dt;
         if dx<>0 then
        begin
         for voxeli := 0 to NVoxels -1 do
         with Voxels[voxeli] do
              begin
               xv:=xv+dx;
              IndexCircling(xGridLen,xv);
              end;
        end;

//   same for y
      yini:=y;
      dy2dt:= (ForceY - Friction*dydt)/nRyR;
      distY:= dydt*dt+0.5*dy2dt*dt*dt;
      ye:= ye+distY;
      y:=trunc(ye);
      dy:= y-yini;
        IndexCircling(yGridLen,y);
        ye:= y+frac(ye);
      dydt:= dydt + dy2dt*dt;
         if dy<>0 then
        begin
         for voxeli := 0 to NVoxels -1 do
         with Voxels[voxeli] do
              begin
               yv:=yv+dy;
              IndexCircling(yGridLen,yv);
              end;
        end;

  end;  // for i, with CRU
end;


begin    // MAIN PROCEDURE
// read parameters from interface
  repul_strength:= StrToFloat(edit13.Text);  // 0.08
  Nticks:= StrToInt(edit25.text);            // 100
  Friction:=strtofloat(Form1.Edit28.Text);   // 10
  Integration_dist:= strtofloat(Form1.Edit29.Text); // 50
  dt:= strtofloat(Form1.Edit30.Text); // 1
  Stop_bo:= false;



// set exact cooordinates and 0 velocity and acceleration at t=0 for each CRU
  for i := 0 to High(ArCRU) do
  with ArCRU[i] do
  begin
// xe is the exact x coordinate, x is coordinate in grid units that (120 nm/unit)
     xe:= x;
// ye is the exact y coordinate, y is coordinate in grid units (120 nm/unit)
     ye:= y;
     dxdt:= 0; // velocity in x direction
     dydt:=0; // velocity in y direction
     dx2dt:= 0; // acceleration in x direction
     dy2dt:=0; // acceleration in y direction
  end;

 dir1:=Form1.Edit4.Text;  // set directory for output file that is C:\Users\Public\
 dir1:=IncludeTrailingPathDelimiter(dir1);
 Memo1.Clear;
 Memo1.Lines.Add('step'+#9+'mean NDD'+#9+'NDD SD');

  ticki:=0;  // set tick to 0
  repeat

   Update_Image;
   Application.ProcessMessages;  // wait until all done
   Form1.Label34.Caption:= 'Tick#'+intToStr(ticki); // report the tick number



   Memo1.Lines.Add(IntToStr(ticki) +#9+edit8.text+#9+edit9.text);




  // do reulsion
    find_repulsion_force;
    find_distance_travel_dt;

//       x_test_sub:= ArCRU[CRUi_test].x; // to show cross-line
//       y_test_sub:= ArCRU[CRUi_test].y;
//   Update_Image;
//   Application.ProcessMessages;  // wait until all done
//    Form1.Label34.Caption:= 'Tick#'+intToStr(ticki); // report the tick number
  inc(ticki);
    until (ticki=Nticks+1) or Stop_bo;
end;  // proc




//procedure FreeMemory and halt
procedure TForm1.Button10Click(Sender: TObject); // halt program
begin
 if ArCRU<>nil then Model_Exit; // free memory
 Free_Memory_image;
// free histogram memory
 NND:=nil;
 NNDhist:=nil;
 CRUSizeDistr:=nil;
 halt;
end;



//////////////////////////////








end.
