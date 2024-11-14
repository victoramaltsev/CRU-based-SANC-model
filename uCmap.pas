unit uCmap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfCmap = class(TForm)
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    Image1: TImage;
    Image2: TImage;
    Image4: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Image5: TImage;
    Label4: TLabel;
    Image6: TImage;
    Label6: TLabel;
    Image7: TImage;
    Label7: TLabel;
    ScrollBar4: TScrollBar;
    ScrollBar5: TScrollBar;
    ScrollBar6: TScrollBar;
    ScrollBar7: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);
    procedure ScrollBar5Change(Sender: TObject);
    procedure ScrollBar6Change(Sender: TObject);
    procedure ScrollBar7Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCmap: TfCmap;


Const MaxPixelCount=2048*16; // used in an array to specify a pixel along image

TYPE
    TRGBTripleArray = ARRAY[0..MaxPixelCount-1] OF TRGBTriple;
    pRGBTripleArray = ^TRGBTripleArray;

const
RGB_white: TRGBTriple = (rgbtBlue:255; rgbtGreen:255; rgbtRed:255);
RGB_ready: TRGBTriple = (rgbtBlue:0; rgbtGreen:255; rgbtRed:0);
RGB_red: TRGBTriple = (rgbtBlue:0; rgbtGreen:0; rgbtRed:255);
RGB_aqua: TRGBTriple = (rgbtBlue:255; rgbtGreen:255; rgbtRed:0);

var Row1, Row2:  pRGBTripleArray;
colorSCHi: integer;

//Procedure Do_color_map;
Function ColorScheme1(i1, SchN :integer):TRGBTriple;


implementation

{$R *.dfm}

var CH_maxi:integer; // number of color schemes

var
BitmapCH:array of TBitmap;
ImageCH: array of TImage;



Function Line2(x1,x2,y1,y2,i1:integer):integer;
 var test:integer;   k:double;
begin
Line2:=y1;
if (y1=y2) or (x1=x2) then exit;
k:=(y2-y1)/(x2-x1);
test:=round(y1+k*(i1-x1));
          if test<0 then test:=0;
  if test>255 then test:=255;
  Line2:=test;

end;

Function GetLinearChange255(x1,x2, i1:integer):integer;
 var test:integer;   k:double;
begin
  k:=255/(x2-x1);
  test:= round(k*(i1-x1));
  if test<0 then test:=0;
  if test>255 then test:=255;
  GetLinearChange255:=test;
end;



function JetColor(i1:integer):TRGBTriple;
var
    RGB1:  TRGBTriple;
  r, g, b: byte;
  x1, x2, x3, x4: byte;

begin
   x1:= fCmap.ScrollBar4.Position;
   x2:= fCmap.ScrollBar5.Position;
   x3:= fCmap.ScrollBar6.Position;
   x4:= fCmap.ScrollBar7.Position;

if (i1>=0) and (i1<=x1) then
 begin
    r:= 0;
    b:=Line2(0,x1,0,255,i1);
//    b:=Line2(0,x1,140,255,i1);
    g:=0;
 end else

if (i1>x1) and (i1<=x2) then
 begin
    r:= 0;
    b:=$ff;
    g:= Line2(x1,x2,0, 255,i1);
 end else

if (i1>x2) and (i1<=x3) then
 begin
    r:=Line2(x2,x3,0, 255,i1);
    b:=  Line2(x2,x3,255,0,i1);
    g:= $ff;
 end else

if (i1>x3) and (i1<=x4) then
 begin
    r:=$ff;
    b:=  0;
    g:= Line2(x3,x4,255,0,i1);
 end else

 begin
    r:=Line2(x4,255,255,128,i1);
    b:=0;
    g:=0;
 end;
 RGB1.rgbtBlue:=b;
 RGB1.rgbtGreen:=g;
 RGB1.rgbtRed:=r;
 JetColor:=RGB1;
end;


function RainBowcolor(i1:integer):TRGBTriple;
var
    RGB1:  TRGBTriple;
  r, g, b: byte;
   x1_rain,   x2_rain,    x3_rain: byte;



begin
//   x1_rain:= 105;
//   x2_rain:=  155;
//   x3_rain:=  208;
   x1_rain:= fCmap.ScrollBar1.Position;
   x2_rain:= fCmap.ScrollBar2.Position;
   x3_rain:= fCmap.ScrollBar3.Position;

//i1:=255-i1;

if (i1>=0) and (i1<=x1_rain) then
 begin
   if i1< x1_rain div 2 then
   begin
    r:=  Line2(0,x1_rain div 2,0,255,i1);
    b:=0;
    g:=0;;
   end
   else
   begin
    r:= $ff;
    b:=0;
    g:= Line2(x1_rain div 2,x1_rain,0,255,i1);
   end;

 end else

if (i1>x1_rain) and (i1<=x2_rain) then
 begin
    r:= Line2(x1_rain,x2_rain,255,0,i1);
    b:=0;
    g:= $ff;
 end else

if (i1>x2_rain) and (i1<=x3_rain) then
 begin
    r:=0;
    b:=  Line2(x2_rain,x3_rain,0,255,i1);
    g:= Line2(x2_rain,x3_rain,255,0,i1);
 end else

 begin
    r:=Line2(x3_rain,255,0,168,i1);
    b:= $ff;
    g:=0;
 end;
 RGB1.rgbtBlue:=b;
 RGB1.rgbtGreen:=g;
 RGB1.rgbtRed:=r;
 RainBowcolor:=RGB1;
end;



function RainBowcolor0(i1:integer):TRGBTriple;
var
    fraction, m: Double;
    r, g, b, mt: Byte;
    RGB1:  TRGBTriple;
begin
    if i1=0 then
     begin
        R := 0;
        G := 0;
        B := 0;
          RGB1.rgbtBlue:= B;
          RGB1.rgbtGreen:=G;
          RGB1.rgbtRed:=R;
          RainBowcolor0:=RGB1;
        exit;
     end;

    fraction:= i1/255;
    if fraction <= 0 then m := 0 else
    if fraction >= 1 then m := 6
                     else m := fraction * 5;
    mt := 255-(round (frac (m) * $FF));
    case Trunc (m) of
    0: begin
        R := mt;
        G := 0;
        B := $FF;
      end;
    1: begin
        R := 0;
        G := $FF - mt;
        B := $FF;
      end;
    2: begin
        R := 0;
        G := $FF;
        B := mt;
      end;
    3: begin
        R := $FF - mt;
        G := $FF;
        B := 0;
      end;
    4: begin
        R := $FF;
        G := mt;
        B := 0;
      end;
  end;
  RGB1.rgbtRed:=R;
  RGB1.rgbtGreen:=G;
  RGB1.rgbtBlue:= B;
  RainBowcolor0:=RGB1;
end;




Function ColorScheme1(i1, SchN :integer):TRGBTriple;
var RGB1:  TRGBTriple;
i2:integer;
begin


     if i1=0 then  // start always with black
        begin
         RGB1.rgbtBlue:=0;
         RGB1.rgbtGreen:=0;
         RGB1.rgbtRed:=0;
         ColorScheme1:=RGB1;
         exit;
       end;

Case   SchN of
  0: begin // red shade
       RGB1.rgbtRed:=i1;
       RGB1.rgbtGreen:=0;
       RGB1.rgbtBlue:=0;
     end;

  1: begin //
      RGB1.rgbtRed:= GetLinearChange255(0,163, i1);
      RGB1.rgbtGreen:=GetLinearChange255(111,235, i1);
      RGB1.rgbtBlue:=GetLinearChange255(176,235, i1);
     end;

   2:begin
      i2:=0;
        Case i1 of
//          red
0 ..10: i2:=Line2(0,10,0,140,i1);
11 ..30: i2:=Line2(11,30,140,0,i1);
58 .. 86:i2:=  Line2(58,84,0,255,i1);
87 .. 170:i2:=Line2(86,170,255,255,i1);
171 .. 234:i2:=Line2(170,234,255,130,i1);
235 .. 255:i2:=Line2(234,255,130,130,i1);
          end;
   RGB1.rgbtRed:=i2;

      i2:=0;
        Case i1 of
// Green
30..44: i2:=Line2(30,44,0,255,i1);
45..86: i2:=Line2(45,86,255,255,i1);
87..110: i2:=Line2(87,110,255,140,i1);
111..170: i2:=Line2(111,170,140,0,i1);
       end;
      RGB1.rgbtGreen:=i2;

      i2:=0;
        Case i1 of
// Blue
0..10: i2:=Line2(0,10,0,190,i1);
11..30: i2:=Line2(11,30,190,255,i1);
31..45: i2:=Line2(30,45,255,255,i1);
46..58: i2:=Line2(45,58,255,0,i1);
        end; // case
      RGB1.rgbtBlue:=i2;

     end; // 2



      3:begin
      i2:=0;
        Case i1 of
//          red
1 ..57: i2:=Line2(0,30,140,0,i1);
58 .. 86:i2:=  Line2(58,84,0,255,i1);
87 .. 170:i2:=Line2(86,170,255,255,i1);
171 .. 234:i2:=Line2(170,234,255,130,i1);
235 .. 255:i2:=Line2(234,255,130,130,i1);
          end;
   RGB1.rgbtRed:=i2;

      i2:=0;
        Case i1 of
// Green
30..44: i2:=Line2(30,44,0,255,i1);
45..86: i2:=Line2(45,86,255,255,i1);
87..110: i2:=Line2(87,110,255,140,i1);
111..170: i2:=Line2(111,170,140,0,i1);
       end;
      RGB1.rgbtGreen:=i2;

      i2:=0;
        Case i1 of
// Blue
1..30: i2:=Line2(0,30,190,255,i1);
31..45: i2:=Line2(30,45,255,255,i1);
46..58: i2:=Line2(45,58,255,0,i1);
        end; // case
      RGB1.rgbtBlue:=i2;

     end; // 3

      4:
      begin
        RGB1:= RainBowcolor(i1);
      end; // 4

      5:
      begin
        RGB1:= JetColor(i1);
      end; // 5

      6:
      begin
        RGB1:= RainBowcolor0(i1);
      end; // 5


  end;// case
 ColorScheme1:=RGB1;
end;


Procedure Paint_color_map(i: integer);
var
xi,yi:integer;
RGB1:TRGBTriple;
begin
with fCmap do
begin
  for xi:=0 to 255 do
    begin
     RGB1:= ColorScheme1(xi, i);
     for yi:=0 to BitmapCh[i].Height-1 do
     begin
     // alongY
       Row1:=  BitmapCh[i].Scanline[yi];
      // along X
       Row1[xi]:= RGB1;
     end;
    end;
    ImageCh[i].Picture.Graphic := BitmapCh[i];
end; // with
end; // proc/







procedure TfCmap.Button1Click(Sender: TObject);
begin
// reset jet:
   fCmap.ScrollBar4.Position:=28;
   fCmap.ScrollBar5.Position:=92;
   fCmap.ScrollBar6.Position:=157;
   fCmap.ScrollBar7.Position:=221;
      Paint_color_map(5);
end;

procedure TfCmap.Button2Click(Sender: TObject);
begin
   fCmap.ScrollBar1.Position:=105;
   fCmap.ScrollBar2.Position:=155;
   fCmap.ScrollBar3.Position:=208;
      Paint_color_map(4);
end;






Procedure ShowColorSchemes;
var i: integer;
begin
 with fCmap do
  begin
   CH_maxi := 6;
   colorSCHi:=  RadioGroup1.ItemIndex;
  //  colorSCHi:=0;
    SetLength(BitmapCH,7);
    SetLength(ImageCH,7);
    ImageCH[0]:= Image1;
    ImageCH[1]:= Image2;
    ImageCH[2]:= Image3;
    ImageCH[3]:= Image4;
    ImageCH[4]:= Image5;
    ImageCH[5]:= Image6;
    ImageCH[6]:= Image7;

    for i := 0 to CH_maxi do
    begin
      ImageCH[i].Width:= 256;
      BitmapCh[i]:= TBitmap.Create;
      BitmapCh[i].PixelFormat := pf24bit;
      BitmapCh[i].Width  := ImageCh[i].Width;
      BitmapCh[i].Height := ImageCh[i].Height;
      Paint_color_map(i);
    end;
  end;
end;

procedure TfCmap.CheckBox1Click(Sender: TObject);
begin
// exp correction
  ShowColorSchemes;
end;


procedure TfCmap.FormCreate(Sender: TObject);
begin
  ShowColorSchemes;
end;

procedure TfCmap.RadioGroup1Click(Sender: TObject);
begin
 colorSCHi:=  RadioGroup1.ItemIndex;
end;

procedure TfCmap.ScrollBar1Change(Sender: TObject);
begin
Paint_color_map(4);
end;

procedure TfCmap.ScrollBar2Change(Sender: TObject);
begin
Paint_color_map(4);
end;

procedure TfCmap.ScrollBar3Change(Sender: TObject);
begin
Paint_color_map(4);
end;

procedure TfCmap.ScrollBar4Change(Sender: TObject);
begin
Paint_color_map(5);
end;

procedure TfCmap.ScrollBar5Change(Sender: TObject);
begin
Paint_color_map(5);
end;

procedure TfCmap.ScrollBar6Change(Sender: TObject);
begin
   Paint_color_map(5);
end;

procedure TfCmap.ScrollBar7Change(Sender: TObject);
begin
Paint_color_map(5);
end;

end.
