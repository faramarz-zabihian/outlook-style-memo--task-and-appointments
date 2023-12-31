unit frmMonth;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FCal;

type
  TState = (stUpward, stStatic, stDownWard);
  UMonthItem = class
    private
       mvarDate : TdateTime;
    public
       property Date : TDateTime read mvarDate;
       constructor Create(dt : TDateTime);
  end;
  TfrmMonthCal = class(TForm)
    lb: TListBox;
    tm: TTimer;
    procedure lbMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmTimer(Sender: TObject);
    procedure lbMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    InitialDate, SelectedMonth : TdateTime;
    Cal : TCal;

    { Public declarations }
  end;
implementation
var
 Act : TState;
{$R *.DFM}

procedure TfrmMonthCal.lbMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 pt : TPoint;
 ind : integer;
begin
     ReleaseCapture;
     tm.Enabled := false;
     pt := lb.ScreentoClient(Mouse.CursorPos);
     ind := lb.ItemAtPos(pt, true);
     if ind <> -1 then
        SelectedMonth := UMonthItem(lb.Items.Objects[ind]).Date
     else
        SelectedMonth := 0;
   Close;
end;

procedure TfrmMonthCal.tmTimer(Sender: TObject);
var
 dt : TDateTime;
 pt : TPoint;
 ind : integer;
 mi : UMonthItem;
begin
  if act = stStatic then begin
     pt := lb.ScreentoClient(Mouse.CursorPos);
     pt.x:=0;
     ind:= lb.ItemAtPos(pt, true);
     if ind <> -1 then begin
        lb.itemindex:= ind;
     end;
     exit;
  end;
  lb.Items.BeginUpdate;
  if act = stDownWard then begin
     lb.Items.Delete(0);
     dt := Cal.incrementMonth(UMonthItem(lb.Items.Objects[lb.Items.count-1]).Date,1);
     mi:= UMonthItem.Create(dt);
     lb.Items.AddObject(Cal.DateName(mi.Date, dnMonthYear), mi);
  end else if act = stUpward then begin
     dt:=  Cal.incrementMonth(UMonthItem(lb.Items.Objects[0]).Date,-1);
     mi:= UMonthItem.Create(dt);
     lb.Items.Delete(lb.items.count-1);
     lb.Items.InsertObject(0, Cal.DateName(mi.Date, dnMonthYear), mi);
  end;
  lb.Itemindex :=-1;
  lb.Items.EndUpdate;
end;

procedure TfrmMonthCal.lbMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if y > lb.ClientHeight then
     act := stDownWard
  else if y < 0 then
      act := stUpWard
  else act:= stStatic;
  if act <> stStatic then begin
     if ( y > 1.5 * lb.Height) or (-y > 0.5 * lb.Height) then
      tm.Interval := 100
     else if ( y > 1.2 * lb.Height) or (-y > 0.2 * lb.Height) then
             tm.Interval := 150
          else
             tm.Interval := 400;
  end else
      tm.Interval := 250;
end;

procedure TfrmMonthCal.FormCreate(Sender: TObject);
begin
 AutoSize := true;
 Act := stStatic;
 lb.ctl3d:= false;
 lb.Clear;
end;


{ MonthItem }

constructor UMonthItem.Create(dt: TDateTime);
begin
  mvarDate := dt;
end;


procedure TfrmMonthCal.FormShow(Sender: TObject);
var
 i: integer;
 mi : UMonthItem;
begin
 for i:= -3 to 3 do begin
     mi := UMonthItem.Create(Cal.IncrementMonth(InitialDate,i));
     lb.items.AddObject (Cal.DateName(mi.Date, dnMonthYear), mi);
 end;
 SetCaptureControl(lb);
end;

end.







