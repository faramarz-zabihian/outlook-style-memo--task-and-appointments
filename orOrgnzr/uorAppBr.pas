unit uorAppBr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TuorAppBar = class(TFrame)
    pnl: TPanel;
    txtSubject: TEdit;
    Shape1: TShape;
    procedure FrameResize(Sender: TObject);
  private
    mvarAppointmentItem : TObject;
    function getText: string;
    procedure setText(const Value: string);
  public
    { Public declarations }
    property  AppointmentItem : TObject read mvarAppointmentItem write mvarAppointmentItem;
    procedure Invalidate;override;
    property  Text : string read getText write setText;
    constructor Create(AOwner : TComponent);override;
  end;
implementation
uses
 uorCalnd;
{$R *.DFM}
{procedure TuorAppBar.Paint;
var
 rc : TRect;
begin
  inherited;
  if txtSubject <> nil then
     txtSubject.Repaint;
  pnl.Repaint;

{  with pnl.Canvas do begin
    FrameRect(ClientRect);
    rc.BottomRight := ClientRect.BottomRight;
    rc.TopLeft :=ClientRect.TopLeft;
    if not mvarAppointmentItem.Appointment.AllDayEvent then begin
        rc.left := rc.right-6;
        brush.Color := clBlack;
        FrameRect(rc);
    end;
    inc(rc.Left);
    inc(rc.top);
    dec(rc.bottom);
    dec(rc.right);
    if not mvarAppointmentItem.Appointment.AllDayEvent then begin
        case mvarAppointmentItem.Appointment.AppType of
            ctnFree       : brush.Color := mvarEdit.Color;
            ctnTentative  : brush.Color := clTeal;
            ctnBusy       : brush.Color := clBlue;
            ctnOut        : brush.Color := clPurple;
        end;
    end else brush.Color:= mvarEdit.Color;
    FillRect(rc);
  end;
end; }


procedure TuorAppBar.Invalidate;
begin
  inherited;
  if txtSubject <> nil then
     txtSubject.Invalidate;
  pnl.Repaint;
end;

function TuorAppBar.getText: string;
begin
  Result:=txtSubject.Text;
end;

procedure TuorAppBar.setText(const Value: string);
begin
  txtSubject.Text:= Value;
end;

constructor TuorAppBar.Create(AOwner: TComponent);
begin
  inherited;
//  BevelInner := bvNone;
//  BevelOuter := bvNone;
  Color := clBlack;
end;

procedure TuorAppBar.FrameResize(Sender: TObject);
begin
  txtSubject.Height := Height;
end;

end.
