unit FDatePicker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, buttons, stdCtrls, frmCal, FCal;

type
  TFDatePicker = class(TPanel)
  private
    fc : TfrmDtPicker;
    mvarCloseOnSelection : boolean;
    editbox:tedit;
    mvarOnChange : TNotifyevent;
    { Private declarations }
    procedure SpClick( Sender: TObject);
    procedure fcDateChange(Sh:string; mi : TDateTime);
    function getText: String;
    function getMiladi : TDateTime;
    procedure setMiladi( Value : TDateTime);
    procedure setFooterType( ft : TCalButtonSet);
    procedure EditChange(Sender: TObject);
    function  getFooterType: TCalButtonSet;
    property  CloseOnSelection: boolean read mvarCloseOnSelection write mvarCloseOnSelection;
    procedure ExitControl( Sender: TObject);
    function  getHoliday( Day : integer): boolean;
    procedure setShamsiDate(state : boolean);
    procedure setHoliday( Day : integer; hol : boolean);
    function getShamsiDate: boolean;
  protected
    procedure resize;override;
  public
    property Text : string read getText;
    procedure setFocus;override;
    Constructor Create( AOwner : TComponent);override;
    destructor Destroy;override;
    function Shamsi(d: TDateTime): string;
    function ISValid: boolean;
    property Miladi : TDateTime read getMiladi write setMiladi;
    function ToMiladi( Value : string): TDateTime;
    Property Holiday[day : integer]: boolean read getHoliday write setHoliday;
  published
    property ShamsiDate : boolean read getShamsiDate write setShamsiDate;
    property FooterType : TCalButtonSet read getFooterType write setFooterType;
    property OnChange : TNotifyEvent read mvarOnChange write mvarOnChange;
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('Standard', [TFDatePicker]);
end;

{ TFDatePicker }

constructor TFDatePicker.Create(AOwner: TComponent);
begin
  inherited;
  BevelInner := bvNone;
  BevelOuter := bvNone;
   with TSpeedButton.Create(self) do begin
       parent:= self;
       Align := alLeft;
       Width := 13;
       OnClick := SpClick;
  end;
  editbox :=TEdit.Create(self);
  with editbox do begin
      parent:= self;
      Align := alleft;
      ParentBiDiMode := False;
      width := 200;
      BiDiMode := bdRightToLeft;
      ParentFont := true;
      onChange := EditChange;
      onExit:= ExitControl;
  end;
  fc:= TfrmDtPicker.Create(nil);
  fc.Calendar.OnDateChange := fcDateChange;
  CloseOnSelection := true;
end;

procedure TFDatePicker.fcDateChange(Sh :string; mi : TDateTime);
begin
  editbox.onchange := nil;
  if mi <> 0 then
    if ShamsiDate then
       editbox.Text := sh
    else
       editbox.Text := DateToStr(mi);
  editbox.onchange := EditChange;
  if assigned(OnChange) then
     OnChange(self);
  if CloseOnSelection then begin
     fc.Hide;
  end
end;


function TFDatePicker.getText: String;
begin
  Result:= editbox.text;
end;

function TFDatePicker.ISValid: boolean;
begin
  Result:=fc.Calendar.ValidDate(editbox.text);
end;

function TFDatePicker.getMiladi: TDateTime;
begin
   if fc.Calendar.ValidDate(editbox.Text) then
      if ShamsiDate then
         result:= fc.Calendar.Miladi(editbox.Text)
      else
         result:= StrToDate(editbox.Text)
   else
      result:= 0;
end;

procedure TFDatePicker.resize;
begin
  inherited;
  editbox.Width := ClientWidth - 14;
end;

function TFDatePicker.Shamsi(d: TDateTime): string;
begin
  Result:= fc.Calendar.shamsi(d);
end;

procedure TFDatePicker.SpClick(Sender: TObject);
var
 po : TPoint;
begin
 po:= ClientToScreen(Point(0,height));
 fc.left := po.x;
 fc.top  := po.y;
 if fc.Showing then
    fc.Hide
 else begin
    fc.Show;
    fc.font:= font;
 end;
end;

procedure TFDatePicker.setMiladi(Value: TDateTime);
begin
  if Value = 0 then begin
     editbox.Text := '';
     if assigned(OnChange) then
        OnChange(self);
  end
  else
     if ShamsiDate then
        fc.Calendar.initialDate := Shamsi(Value) // automatically changes editbox.text
     else
        fc.Calendar.initialDate := DateTostr(Value);
 
end;

function TFDatePicker.getFooterType: TCalButtonSet;
begin
   Result:= fc.Calendar.FooterType;
end;

procedure TFDatePicker.setFooterType(ft: TCalButtonSet);
begin
  fc.Calendar.FooterType:= ft;
end;

procedure TFDatePicker.EditChange(Sender: TObject);
begin
  editbox.onchange:= nil;          // to supress cycling
  // oooo
  fc.Calendar.InitialDate := editbox.text; // validation will be checked by Fcal
  editbox.onchange:= EditChange;
end;

destructor TFDatePicker.Destroy;
begin
  fc.hide;
  fc.Free;
  inherited;
end;

procedure TFDatePicker.ExitControl(Sender: TObject);
begin
  if Assigned(onExit) then
     OnExit(self);
end;

procedure TFDatePicker.setFocus;
begin
  inherited;
  editBox.SetFocus; 
end;

function TFDatePicker.ToMiladi(Value: string): TDateTime;
begin
   Result:= fc.Calendar.Miladi(Value);
end;

function TFDatePicker.getHoliday(Day: integer): boolean;
begin
  Result:= fc.Calendar.Holiday[day];
end;

procedure TFDatePicker.setHoliday(Day: integer; hol: boolean);
begin
 fc.Calendar.Holiday[day]:= hol;
end;

procedure TFDatePicker.setShamsiDate(state: boolean);
begin
   fc.Calendar.ShamsiDate := State;
   if State  then
      editbox.BidiMode := bdrighttoLeft
   else
      editbox.BidiMode := bdLeftToRight;

end;

function TFDatePicker.getShamsiDate: boolean;
begin
  Result:=fc.Calendar.ShamsiDate;
end;

end.
