unit uImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Parameters,
//  uScan,
//  uCheck,
  StdCtrls, ExtCtrls,
  uCmap,
  uImage2,
  math

  ;

type
  TfImage = class(TForm)
    Label9: TLabel;
    Label10: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit7: TEdit;
    Edit8: TEdit;
    Label8: TLabel;
    Edit6: TEdit;
    Button3: TButton;
    Label5: TLabel;
    Edit5: TEdit;
    RadioGroup2: TRadioGroup;
    CheckBox3: TCheckBox;
    Button7: TButton;
    Button8: TButton;
    Edit10: TEdit;
    Label7: TLabel;
    Button5: TButton;
    Label13: TLabel;
    Edit14: TEdit;
    Label14: TLabel;
    Edit15: TEdit;
    RadioGroup3: TRadioGroup;
    Label15: TLabel;
    Edit16: TEdit;
    procedure Button3Click(Sender: TObject);
//    procedure RadioGroup3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fImage: TfImage;

procedure Set_image;
procedure Free_Memory_image;
procedure Update_Image;



var
RGB0:TRGBTriple;


var
Max_JSR,
Max_display_sub, Min_display_sub:double;

var
FontSize1, TextOfsetVmInX, TextOfsetVmInY: integer;
InOneLineboo: boolean;
procedure SaveBitmap1(DirAndFnameStr: string);

// bitmaps
var
Bitmap1, Bitmap2:TBitmap;
Bitmap_scan1:TBitmap;
Bitmaps_have_been_created:boolean;


implementation

{$R *.dfm}

uses uSANCmodel;

// EXPORT Images
var

//  redraw_image1_boo,   redraw_image2_boo: boolean;


//  VISUALIZATION ///////////////////////////

// painting Ca and JSR

Pixels_per_voxel:integer;
X_offset_paint_JSR_pixels, Y_offset_paint_JSR_pixels: integer;
JSR_pixel_size_paint: integer;
//Row1, Row2:  pRGBTripleArray;

//Max_display_SR, Min_display_SR:double;
//Min_display_INCX, Max_display_INCX:double;





procedure SaveBitmap1(DirAndFnameStr: string);
begin
    Bitmap1.SaveToFile(DirAndFnameStr);
end;

procedure Free_Memory_image;
begin
    Bitmap1.free;
    Bitmap2.Free;
    Bitmaps_have_been_created:=false;
end;



Procedure CreateBitMap(var Bitmap:TBitmap; Image:TImage); ///////////////////
  begin
   // redraw_image1_boo:=true;
  //  redraw_image2_boo:=true;
    Image.Width:= xGridLen*Pixels_per_voxel;
    Image.Height:=yGridLen*Pixels_per_voxel;

    fImage2.Width:=  Image.Width+30;
    fImage2.Height:=Image.Height+60;


  Bitmap := TBitmap.Create;
    Bitmap.PixelFormat := pf24bit;
    Bitmap.Width  := Image.Width;
    Bitmap.Height := Image.Height;

  //    Bitmapi.Canvas.Font.Name := 'Arial';
      Bitmap.Canvas.Font.Color := clWhite;
      Bitmap.Canvas.Font.Size := 10;
      Bitmap.Canvas.Font.Style:=[fsBold];
  //  Bitmap.Canvas.Font.Style := [fsItalic];
      Bitmap.Canvas.Brush.Color:= clBlack;
      Bitmap.Canvas.Pen.Color:= clBlack;

  end;



Procedure ColorCRUs(var Bitmap:TBitmap);
var
intens1_int:integer;
CRUi: integer;
voxeli:integer;
xx, yy, y1, y2, x1, x2:integer;

begin
// color each CRU

        FOR CRUi:=0 to nCRUs-1 do
      begin


          intens1_int:= round(255*ArCRU[CRUi].CajSR1/Max_JSR);
          if intens1_int>255 then intens1_int:=255;
          if intens1_int<0 then intens1_int:=0;


        // painting
              // not open but ready to fire
              if (not ArCRU[CRUi].Open) and (ArCRU[CRUi].CajSR1>= CaJSR_spark_activation) then
               begin
                 RGB0:=RGB_ready;  // paint green
               end
               else
             if  ArCRU[CRUi].Open then
               with RGB0 do   // paint on white shades
                begin
                    rgbtRed   := intens1_int;
                    rgbtGreen := intens1_int;
                    rgbtBlue  := intens1_int;
                 end
             else
               with RGB0 do
                  BEGIN // closed in refractory period
                    rgbtRed   := 0;
                    rgbtGreen := 0; // intens1_int;
                    rgbtBlue  := intens1_int;
                END; //


        for voxeli := 0 to ArCRU[CRUi].NVoxels -1 do
        begin
        y1:= ArCRU[CRUi].Voxels[voxeli].yv;
        x1:=  ArCRU[CRUi].Voxels[voxeli].xv;
         y2:=y1*Pixels_per_voxel;
         Row1 := Bitmap.Scanline[y2];
         x2:=x1 *Pixels_per_voxel;
           for yy:=0 to Pixels_per_voxel -1 do // coloring 1 pixel along y
           begin
            Row1 := Bitmap.Scanline[y2+yy];
             // next line is coloring 1 pixel along x
            for xx:=0  to Pixels_per_voxel -1 do
            begin
              Row1[x2+xx]:=  RGB0;
            end; // for xx
          end; // for yy


        end; // for vixeli

        end; // for CRUi


end;  // proc



procedure UpdateBitmap(Voxel:VoxelType;min, max: double;var Bitmap:TBitmap;Ar:Ar2Dtype);
  VAR
  x1,y1, x2,y2  :  INTEGER;
  xx,yy: integer;
  intens: integer;
  // test,
  Amplitude:double;

begin
with Voxel do
begin
    Amplitude:= max-min;
    if Amplitude=0 then exit; // avoding div to zero
    RGB0.rgbtBlue:=0;
    RGB0.rgbtGreen:=0;


  FOR y1 := 0 TO yGridLen-1 DO
  BEGIN
  y2:=y1*Pixels_per_voxel;
  Row1 := Bitmap.Scanline[y2];

    FOR x1:= 0  TO NvoxX-1 DO
    BEGIN
       if Ar[y1,x1] <= min then intens:=0
       else
       begin
       intens:=  round(255*(Ar[y1,x1] -min)/Amplitude);
       if intens>255 then intens:=255;
       if intens<0 then intens:=0;
       end;

     //  RGB0.rgbtRed:=intens;
     RGB0:= ColorScheme1(intens, colorSCHi);



    x2:=x1 *Pixels_per_voxel;
    for yy:=0 to Pixels_per_voxel -1 do // coloring 1 pixel along y
    begin
    Row1 := Bitmap.Scanline[y2+yy];
     // next line is coloring 1 pixel along x
     for xx:=0  to Pixels_per_voxel -1 do
     begin
      Row1[x2+xx]:=  RGB0;
     end; // for xx
     end; // for yy

    END; // for x
  END;// for y
end; // with voxel
end;











procedure Update_Image;
var s1, s2:string;
begin
with fImage do
begin

// update Image 1
//if redraw_image1_boo then ImageSet;
    if checkbox2.Checked then  // show Ca
    UpdateBitmap(VoxelSub, Min_display_sub, Max_display_sub,  Bitmap1, ArSubCyt);


// color CRUs on Image 1
 if checkbox1.Checked then
  begin
   ColorCRUs(Bitmap1);
  // redraw_image1_boo:=false;
  end;


  if checkbox3.Checked then
  begin
  // Write Time  and voltage
    s1:= 'Time(ms)='+FloatToStrF(SimTime,ffGeneral, 8,8);
//    Bitmap1.Canvas.TextOut(150, 1, s);
    s2:= 'V(mV)='+FloatToStrF(Vm,ffGeneral, 5,5);
    Bitmap1.Canvas.TextOut(1, 1, s1);

    if InOneLineboo then
    Bitmap1.Canvas.TextOut(TextOfsetVmInX, 1, s2)
    else
    Bitmap1.Canvas.TextOut(1,TextOfsetVmInY, s2);

  end;

// Display on screen
 if checkbox2.Checked or checkbox1.Checked then
 begin
   FImage2.Image1.Picture.Graphic := Bitmap1;
 end;




end;// with fImage



end;













procedure Set_image;
var
jSR_Xsize_in_pixels,
//jSR_Ysize_in_pixels,
X_offset_to_CRU_center_pixels, Y_offset_to_CRU_center_pixels: integer;


begin
 if  Bitmaps_have_been_created then Free_Memory_image;

with fImage do
begin
Max_JSR:=StrToFloat(edit10.Text);
Pixels_per_voxel:= StrToInt(Edit6.Text);
Max_display_sub:=StrToFloat(Edit7.Text)*(1E-3);
Min_display_sub:= StrToFloat(Edit8.Text)*(1E-3);
CreateBitMap(Bitmap1,fIMage2.Image1);

//Max_display_SR:=StrToFloat(Edit9.Text);
//Min_display_SR:=StrToFloat(Edit10.Text);

//Max_display_INCX:=StrToFloat(Edit11.Text);
//Min_display_INCX:=StrToFloat(Edit14.Text);


//  CreateBitMap(Bitmap2,Image2);

    Bitmaps_have_been_created:=true;

{
    JSR_pixel_size_paint:= StrToInt(Edit5.Text);
    jSR_Xsize_in_pixels:= jSR_Xsize_in_grid_units* Pixels_per_voxel;

if ((jSR_Xsize_in_pixels mod 2 =0)  and (JSR_pixel_size_paint mod 2 =1))
OR
   ((jSR_Xsize_in_pixels mod 2 =1)  and (JSR_pixel_size_paint mod 2 =0))
then
begin
   case RadioGroup2.ItemIndex of
     1: inc(JSR_pixel_size_paint);
     2: dec(JSR_pixel_size_paint);
   end;
   Edit5.Text:= IntToStr(JSR_pixel_size_paint);
end;

    X_offset_to_CRU_center_pixels:= jSR_Xsize_in_grid_units*Pixels_per_voxel div 2;
    Y_offset_to_CRU_center_pixels:= jSR_Ysize_in_grid_units*Pixels_per_voxel div 2;


   X_offset_paint_JSR_pixels:=
   X_offset_to_CRU_center_pixels - ( JSR_pixel_size_paint div 2);

   Y_offset_paint_JSR_pixels:=
   Y_offset_to_CRU_center_pixels - ( JSR_pixel_size_paint div 2);

   // redraw_image1_boo:=true;
   // redraw_image2_boo:=true;

   }
end;// with


end;// proc






procedure TfImage.Button3Click(Sender: TObject);
begin
Set_image;
if SimTickNumber>0 then Update_Image;
end;

//procedure TfImage.RadioGroup3Click(Sender: TObject);
//begin
// redraw_image2_boo:=true;
//end;

procedure TfImage.FormCreate(Sender: TObject);
begin
  Bitmaps_have_been_created:=false;
end;









procedure TfImage.Button5Click(Sender: TObject);
begin
// refresh image
//Set_image;
Update_image;
end;



procedure TfImage.Button7Click(Sender: TObject);
begin
//
fCmap.Visible:= true;
fCmap.BringToFront;
end;

procedure TfImage.Button8Click(Sender: TObject);
begin
 fImage2.Visible:= true;
 fImage2.BringToFront;
end;

end.
