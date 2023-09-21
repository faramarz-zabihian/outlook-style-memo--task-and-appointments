unit forRecur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FDatePicker, uorCalnd, dmorgnzr;

type
  TfrmRecurr = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cmdCancel: TButton;
    cmdOk: TButton;
    RecDel: TButton;
    cboDuration: TComboBox;
    cboEndHour: TComboBox;
    cboStartHour: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    rdDaily: TRadioButton;
    rdWeekly: TRadioButton;
    rdMonthly: TRadioButton;
    nbk: TNotebook;
    txtEveryNDay: TEdit;
    Label5: TLabel;
    rdEveryNDay: TRadioButton;
    rdAllofWeekDays: TRadioButton;
    chk0: TCheckBox;
    chk1: TCheckBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk4: TCheckBox;
    chk5: TCheckBox;
    chkFr: TCheckBox;
    txtWeekly: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    txtDayofMonth: TEdit;
    Label8: TLabel;
    txtEveryNMonth: TEdit;
    Label9: TLabel;
    rdDayNofMonth: TRadioButton;
    RadioButton7: TRadioButton;
    cboMonthWeek: TComboBox;
    Label10: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label11: TLabel;
    dpStartDate: TFDatePicker;
    rdEndLess: TRadioButton;
    rdTimes: TRadioButton;
    rdEndDate: TRadioButton;
    dpEndDate: TFDatePicker;
    txtTimes: TEdit;
    Label12: TLabel;
    cboWeekDay: TComboBox;
    procedure rdDailyClick(Sender: TObject);
    procedure rdWeeklyClick(Sender: TObject);
    procedure rdMonthlyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboDurationClick(Sender: TObject);
    procedure cboEndHourChange(Sender: TObject);
    procedure cboStartHourChange(Sender: TObject);
    procedure dpEndDateChange(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure RecDelClick(Sender: TObject);
    procedure cboDurationChange(Sender: TObject);
    procedure txtTimesChange(Sender: TObject);
    procedure txtEveryNMonthChange(Sender: TObject);
    procedure cboMonthWeekClick(Sender: TObject);
    procedure txtEveryNDayChange(Sender: TObject);
    procedure chkClick(Sender: TObject);
  private
    { Private declarations }
    AppLen : real;
    function getTime(sin: string): TDateTime;
    function DailyAppCheck : UReccPattern;
    function WeeklyAppCheck : UReccPattern;
    function MonthlyAppCheck : UReccPattern;
    function chkCheck(ChkLeft, ChkMid, ChkRight : TCheckBox): boolean;
    function CheckWeekChecks: boolean;
  public
    { Public declarations }
    State : boolean;
    StartHour : real;
    RecurrenceBeforeEdit, RecurrenceAfterEdit : UReccPattern;
  end;

var
  frmRecurr: TfrmRecurr;

implementation

{$R *.DFM}

procedure TfrmRecurr.rdDailyClick(Sender: TObject);
begin
  nbk.pageindex :=0;
end;

procedure TfrmRecurr.rdWeeklyClick(Sender: TObject);
begin
  nbk.pageindex :=1;
end;

procedure TfrmRecurr.rdMonthlyClick(Sender: TObject);
begin
  nbk.pageindex :=2;
end;

procedure TfrmRecurr.FormShow(Sender: TObject);
begin
    Organizer.InitHolidays(dpStartDate);
    Organizer.InitHolidays(dpEndDate);  
    cboDuration.Items.Clear;
    cboDuration.Items.add('5 œﬁÌﬁÂ');
    cboDuration.Items.add('10 œﬁÌﬁÂ');
    cboDuration.Items.add('15 œﬁÌﬁÂ');
    cboDuration.Items.add('30 œﬁÌﬁÂ');
    cboDuration.Items.add('1 ”«⁄ ');
    cboDuration.Items.add('2 ”«⁄ ');
    cboDuration.Items.add('3 ”«⁄ ');
    cboDuration.Items.add('4 ”«⁄ ');
    cboDuration.Items.add('5 ”«⁄ ');
    cboDuration.Items.add('6 ”«⁄ ');
    cboDuration.Items.add('7 ”«⁄ ');
    cboDuration.Items.add('8 ”«⁄ ');
    cboDuration.Items.add('9 ”«⁄ ');
    cboDuration.Items.add('10 ”«⁄ ');
    cboDuration.Items.add('11 ”«⁄ ');
    cboDuration.Items.add('12 ”«⁄ ');
    cboDuration.itemindex:=0;
    cboWeekDay.ItemIndex :=0;
    cboMonthWeek.ItemIndex :=0;

    StartHour := RecurrenceBeforeEdit.StartHour;
    organizer.generateTimeFrom(cboEndHour   ,StrToTime(TimeToStr(StartHour)));
    organizer.generateTimeFrom(cboStartHour ,StartHour);
    cboStartHour.text := TimeToStr(StartHour);
    with RecurrenceBeforeEdit do begin
       AppLen    := Duration;
       dpStartDate.Miladi := StartDate;
       cboDuration.Text := FormatDateTime('hh:mm', Duration);
       cboEndHour.Text  := TimeToStr(StartHour+Duration);
       if After_N_Ocuur > 0 then begin
          txtTimes.Text := inttostr(After_N_Ocuur);
          rdTimes.Checked := true;
       end
       else if EndDate > 0 then begin
           dpEndDate.Miladi := EndDate;
           rdEndDate.Checked := true;
       end
       else rdEndLess.Checked := true;


       case RecurrenceType of
           rbDaily : with UReccDaily(RecurrenceBeforeEdit) do begin
                          if EveryWeekDay then
                             rdAllofWeekDays.checked:= true
                          else
                             txtEveryNDay.Text := IntToStr(Every_N_Days);
                          rdDaily.checked:= true;
                          nbk.pageindex:=0;
                      end;

           rbWeekly : with UReccWeekly(RecurrenceBeforeEdit) do begin
                           txtWeekly.text := inttostr(Every_N_Weeks);
                           if (WeekDays and  1 >0) then
                               chk0.Checked:= true;
                           if (WeekDays and  2 >0) then
                               chk1.Checked:= true;
                           if (WeekDays and  4 >0) then
                               chk2.Checked:= true;
                           if (WeekDays and  8 >0) then
                               chk3.Checked:= true;
                           if (WeekDays and  16 >0) then
                               chk4.Checked:= true;
                           if (WeekDays and  32 >0) then
                               chk5.Checked:= true;
                           if (WeekDays and  64>0) then
                               chkfr.Checked:= true;
                           rdWeekly.checked:= true;
                           nbk.pageindex:=1;

                      end;

            rbMonthly : with UReccMonthly(RecurrenceBeforeEdit) do begin
                             rdMonthly.checked:= true;
                             nbk.pageindex:=2;
                             if (WeekDay<> -1) and (MonthWeek <> -1) then begin
                                cboWeekDay.ItemIndex:=WeekDay;
                                cboMonthWeek.ItemIndex:=MonthWeek;
                                RadioButton7.Checked := true;
                             end else begin
                                 txtDayofMonth.Text := intTostr(DayOfMonth);
                                 txtEveryNMonth.text := inttostr(EveryNMonth);
                                 rdDayNofMonth.checked := true;
                             end;

                        end;
       end;
           RecDel.Enabled  := State;
    end;

end;

function TfrmRecurr.getTime(sin: string): TDateTime;
var
 sout: string;
begin
  Result:= -1;
  if Organizer.getTime(sin, sout) then
     Result:= strtoTime(sout);
end;

procedure TfrmRecurr.cboDurationClick(Sender: TObject);
var
 oldVal : real;
begin
  with TComboBox(Sender) do
  case ItemIndex of
     0, 1, 2 : AppLen:= (ItemIndex+1) *  5;     // 5 minute chunks
     3       : AppLen := 30;
     4,5,6,7,
     8,9,10,
     11,12,13,
     14,15   : AppLen := (ItemIndex-3) *  60; // 1 to 12 hour
  end;
  oldVal := AppLen;
  AppLen := AppLen / 1440;
  if not CheckWeekChecks  then
     AppLen := OldVal;

  cboEndHour.text :=  TimeToStr(getTime(cboStartHour.Text) + Applen);
end;

procedure TfrmRecurr.cboEndHourChange(Sender: TObject);
var
 r : real;
begin
  r:= getTime(cboEndHour.Text);
  if r >= 0 then begin
    AppLen := r - StartHour;
    cboDuration.Text := FormatDateTime('hh:mm',AppLen);
  end;
end;

procedure TfrmRecurr.cboStartHourChange(Sender: TObject);
var
 r : real;
begin
  r:= getTime(cboStartHour.Text);
  if r >= 0 then begin
    StartHour := r;
    cboEndHour.Text := TimetoStr(StartHour + AppLen);
  end;

end;

procedure TfrmRecurr.dpEndDateChange(Sender: TObject);
begin
  rdEndDate.Checked := true;
  if dpEndDate.Miladi <= dpStartDate.Miladi then
     showmessage(' «—ÌŒ Å«Ì«‰ ﬁ—«—Â«»«Ì” Ì «“ ‘—Ê⁄ ¬‰ »“—ê — »«‘œ');
end;

function TfrmRecurr.DailyAppCheck : UReccPattern;
var
  v: integer;
  pat : UReccDaily;
begin
  Result:= nil;
  if rdEveryNDay.Checked then begin
     v:= trunc(Organizer.ValueOfString(txtEveryNDay.Text));
     if v <=0 then begin
        showmessage('›«’·Â —Ê“Â« „‘Œ’ ‰Ì” ');
        exit;
     end;
  end;
  pat := UReccDaily.Create;
  if rdEveryNDay.Checked then
     pat.Every_N_Days:= v
  else
     pat.EveryWeekDay := true;
  Result:= pat;
end;

function TfrmRecurr.WeeklyAppCheck : UReccPattern;
var
  v : integer;
  pat : UReccWeekly;
begin
  Result:= nil;
  v:= trunc(Organizer.ValueOfString(txtWeekly.Text));
  if v <=0 then begin
     showmessage('⁄œœ Â— Â› Â „‘Œ’ ‰Ì” ');
     exit;
  end;
  pat := UReccWeekly.Create;
  pat.Every_N_Weeks := v;
  pat.WeekDays:=0;
  if chk0.Checked then
     pat.WeekDays := 1;
  if chk1.Checked then
     pat.WeekDays := pat.WeekDays or 2;
  if chk2.Checked then
     pat.WeekDays := pat.WeekDays or 4;
  if chk3.Checked then
     pat.WeekDays := pat.WeekDays or 8;
  if chk4.Checked then
     pat.WeekDays := pat.WeekDays or 16;
  if chk5.Checked then
     pat.WeekDays := pat.WeekDays or 32;
  if chkFr.Checked then
     pat.WeekDays := pat.WeekDays or 64;
  if pat.WeekDays > 0 then
     Result:= pat
  else  begin
     pat.free;
     showmessage('—Ê“Â«Ì Â› Â „‘Œ’ ‰Ì” ‰œ');
  end;
end;

function TfrmRecurr.MonthlyAppCheck : UReccPattern;
var
  v,v1: integer;
  pat : UReccMonthly;
begin
  Result:= nil;
  if rdDayNofMonth.Checked then begin
      v:= trunc(Organizer.ValueOfString(txtDayofMonth.Text));
      if v <=0 then begin
         showmessage('‘„«—Â —Ê“ „‘Œ’ ‰Ì” ');
         exit;
      end;
      v1:= trunc(Organizer.ValueOfString(txtEveryNMonth.Text));
      if v1 <=0 then begin
         showmessage('›«’·Â „«ÂÂ« „‘Œ’ ‰Ì” ');
         exit;
      end;
  end;
  pat := UReccMonthly.Create;
  Result:= pat;
  if rdDayNofMonth.Checked then begin
     pat.DayOfMonth := v;
     pat.EveryNMonth := v1;
     pat.WeekDay := -1;
     pat.MonthWeek:=-1;
  end else begin
     pat.WeekDay := cboWeekDay.ItemIndex;
     pat.MonthWeek := cboMonthWeek.ItemIndex;
  end
end;

procedure TfrmRecurr.cmdOkClick(Sender: TObject);
var
 pat : UReccPattern;
 r : real;
 times : integer;
begin
  r := getTime(cboStartHour.text);
  if r < 0 then begin
     showmessage('”«⁄  ‘—Ê⁄ ﬁ—«— «Ì—«œ œ«—œ');
     exit
  end;
  StartHour :=r;
  r := getTime(cboEndHour.text);
  if r < 0 then begin
     showmessage('”«⁄  ‘—Ê⁄ ﬁ—«— «Ì—«œ œ«—œ');
     exit
  end;
  AppLen := r - StartHour;
  if rdTimes.Checked then begin
     times:= trunc(Organizer.ValueOfString(txtTimes.text));
     if times <=0 then begin
        showmessage('œ›⁄«  ﬁ—«— „‘Œ’ ‰Ì” ');
        exit
     end;
  end else if rdEndDate.Checked then begin
     if dpEndDate.Miladi <= dpStartDate.Miladi then begin
        showmessage(' «—ÌŒ Å«Ì«‰ »«Ì” Ì »“—ê — «“  «—ÌŒ ‘—Ê⁄ »«‘œ');
        exit;
     end
  end;
  pat := nil;
  if rdDaily.checked then
     pat:=DailyAppCheck
  else if rdWeekly.Checked then
          pat:=WeeklyAppCheck
       else pat:=MonthlyAppCheck;
  if pat = nil then
     exit;
  pat.StartHour := StartHour;
  pat.Duration  := AppLen;
  pat.StartDate := dpStartDate.Miladi;
  if rdEndDate.Checked then
     pat.EndDate := dpEndDate.Miladi
  else if rdTimes.Checked then
       pat.After_N_Ocuur := times;
  RecurrenceAfterEdit := pat;
  if RecurrenceBeforeEdit  <> nil then
     RecurrenceAfterEdit.Id := RecurrenceBeforeEdit.id;
  ModalResult := mrok;
end;

procedure TfrmRecurr.cmdCancelClick(Sender: TObject);
begin
   RecurrenceAfterEdit := RecurrenceBeforeEdit;
   ModalResult := mrCancel;
end;

procedure TfrmRecurr.RecDelClick(Sender: TObject);
begin
  ModalResult:= mrNoToAll;
end;

procedure TfrmRecurr.cboDurationChange(Sender: TObject);
var
 r : real;
 OldVal: Real;
begin
  r:= getTime(cboDuration.Text);
  if r >= 0 then begin
    AppLen := r;
    if not CheckWeekChecks  then
       AppLen := OldVal;

    cboEndHour.Text := TimeToStr(StartHour+ AppLen);
  end;
end;

procedure TfrmRecurr.txtTimesChange(Sender: TObject);
begin
 rdTimes.Checked := true;
end;

procedure TfrmRecurr.txtEveryNMonthChange(Sender: TObject);
begin
  rdDayNofMonth.checked:= true;
end;

procedure TfrmRecurr.cboMonthWeekClick(Sender: TObject);
begin
  RadioButton7.checked := true;
end;

procedure TfrmRecurr.txtEveryNDayChange(Sender: TObject);
begin
  rdEveryNDay.checked:= true;
end;
function TfrmRecurr.chkCheck(ChkLeft, ChkMid, ChkRight : TCheckBox): boolean;
begin
  result:= True;
  if ChkMid.Checked then
    if StartHour + AppLen > 1 then
       if ChkLeft.Checked or ChkRight.checked then
          Result:= false;
end;
function TfrmRecurr.CheckWeekChecks: boolean;
begin
   Result:= True;
   if not chkCheck(Chkfr, Chk0, Chk1) or
      not chkCheck(Chk0 , Chk1, Chk2) or
      not chkCheck(Chk1 , Chk2, Chk3) or
      not chkCheck(Chk2 , Chk3, Chk4) or
      not chkCheck(Chk3 , Chk4, Chk5) or
      not chkCheck(Chk5 , Chkfr, Chk0) then begin
          showmessage('ÿÊ· ﬁ—«— ‰»«Ì” Ì œÊ —Ê“ Â› Â —« ÅÊ‘‘ œÂœ');
      Result:= false;
   end;
end;
procedure TfrmRecurr.chkClick(Sender: TObject);
begin
   if TCheckBox(Sender).Checked then
      if not CheckWeekChecks then
        TCheckBox(Sender).Checked := false;

end;

end.
