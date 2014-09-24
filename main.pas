unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ComCtrls, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
		procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
		procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
					Shift: TShiftState; X, Y: Integer);
		procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
					Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
    FGrid: array of array of Integer;
    FWidth, FHeight: integer;
    FGridSize: integer;
    FRoundCounter: integer;

    procedure DrawGrid;
    procedure EvaluateGrid;
    procedure GenerateRandom;
    function CountNeighbours(x, y: integer): integer;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1.OnPaint := @FormPaint;
  FGridSize := 10;
  FWidth := 20;
  FHeight := 20;
  FRoundCounter := 0;
  SetLength(FGrid, 20, 20);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  FWidth := StrToInt(LabeledEdit2.Text);
  FHeight := StrToInt(LabeledEdit3.Text);
  FGridSize := StrToInt(LabeledEdit1.Text);
  SetLength(FGrid, FWidth, FHeight);
  GenerateRandom;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  SetLength(FGrid, 0, 0);
  SetLength(FGrid, FWidth, FHeight);
  DrawGrid;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  DrawGrid;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  MenuItem3.Checked := not (MenuItem3.Checked);
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
begin
  if ((x/FGridSize) >= 0) and ((x/FGridSize) < FWidth) then
  begin
    if ((y/FGridSize) >= 0) and ((y/FGridSize) < FHeight) then
    begin
      FGrid[round(x/FGridSize),round(y/FGridSize)] := 1;
		end;
	end;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
begin
  //DrawGrid;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Inc(FRoundCounter);
  EvaluateGrid;
  DrawGrid;
  //Application.MessageBox(PChar('Neighbors of 1,1: ' + IntToStr(CountNeighbours(1,1))), 'Test', 0);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Timer1.Interval := TrackBar1.Position;
  Label2.Caption := IntToStr(TrackBar1.Position);
end;

procedure TForm1.DrawGrid;
var
  x, y: integer;
begin
  Label1.Caption := 'Runde: ' + IntToStr(FRoundCounter);

        {
  if (MenuItem3.Checked) then
  begin
    Panel1.Canvas.Pen.Color := clWhite;
  end
  else
  begin
    Panel1.Canvas.Pen.Color := clBlack;
  end;  }

  Panel1.Canvas.Font.Size := 7;

  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      Panel1.Canvas.Pen.Color := clBlack;
      Panel1.Canvas.Line(x * FGridSize, y * FGridSize, x * FGridSize + FGridSize, y * FGridSize);
      Panel1.Canvas.Line(x * FGridSize, y * FGridSize, x * FGridSize, y * FGridSize + FGridSize);
      if (FGrid[x, y] = 1) then
      begin
        Panel1.Canvas.Brush.Color := clYellow;
        Panel1.Canvas.Rectangle(x * FGridSize, y * FGridSize, x * FGridSize + FGridSize, y * FGridSize + FGridSize);
      end
      else
      begin
        Panel1.Canvas.Brush.Color := clWhite;
        Panel1.Canvas.Rectangle(x * FGridSize, y * FGridSize, x * FGridSize + FGridSize, y * FGridSize + FGridSize);
      end;


      Panel1.Canvas.TextOut(x * FGridSize, y * FGridSize, IntToStr(CountNeighbours(x,y)));
      //Panel1.Canvas.Pen.Color := clBlack;
      Panel1.Canvas.Pen.Color := clWhite;
    end;
  end;

  if MenuItem3.Checked then
  begin
    Panel1.Canvas.Line(0, (FHeight * FGridSize), FWidth * FGridSize, (FHeight * FGridSize));
    Panel1.Canvas.Line((FWidth * FGridSize), 0, FWidth * FGridSize, (FHeight * FGridSize));
  end;
  Panel1.Canvas.Brush.Color := clBlack;
  Application.ProcessMessages;
end;

procedure TForm1.EvaluateGrid;
var
  x, y: integer;
  tmp: array of array of Integer;
  res: Integer;
begin

  SetLength(tmp, FWidth, FHeight);

  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      res := CountNeighbours(x, y);
      if (FGrid[x, y] = 1) then
      begin
        if (res < 2) or (res > 3) then
        begin
          tmp[x, y] := 0;
        end
        else
        begin
          tmp[x,y] := 1;
				end;
			end
      else
      begin
        if (res = 3) then
        begin
          tmp[x, y] := 1;
				end
        else
        begin
          tmp[x, y] := 0;
				end;
			end;
		end;
  end;
  FGrid := tmp;

end;

procedure TForm1.GenerateRandom;
var
  x, y: integer;
begin
  Randomize;
  SetLength(FGrid, 0, 0);
  SetLength(FGrid, FWidth, FHeight);
  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      if (Random(100) > 86) then
      begin
        FGrid[x, y] := 1;
			end;
		end;
  end;
  Panel1.Canvas.Clear;
  Timer1.Enabled := False;
  FRoundCounter := 0;
  DrawGrid;
end;

function TForm1.CountNeighbours(x, y: integer): integer;
var
  x2, y2: integer;
begin
  Result := 0;

  for y2 := -1 to 1 do
  begin
    for x2 := -1 to 1 do
    begin
      if (x+x2 >= 0) and (y+y2 >= 0) and (x+x2 < FWidth) and (y+y2 < FHeight) then
      begin
        if (FGrid[x+x2, y+y2] = 1) then
        begin
          Inc(Result);
        end;
      end;
		end;
	end;
  //if (Result > 0) then dec(Result);

end;

{$R *.lfm}

end.
