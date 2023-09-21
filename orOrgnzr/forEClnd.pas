unit forEClnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdActns, ActnList, ImgList, Menus, ExtCtrls, StdCtrls, ComCtrls,
  FDatePicker, ToolWin, uorCalnd, forSchd, Grids, forNetMt, math;

type
  TfrmEditApp = class(TForm)
    PageControl1: TPageControl;
    shtTask: TTabSheet;
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    txtSubject: TEdit;
    cboAppType: TComboBox;
    chkReminder: TCheckBox;
    Panel2: TPanel;
    reMemo: TRichEdit;
    Panel4: TPanel;
    chkPrivate: TCheckBox;
    txtCategories: TEdit;
    cmdCategory: TButton;
    pnlWarn: TPanel;
    lblWarn: TLabel;
    MainMenu1: TMainMenu;
    mnuTask: TMenuItem;
    mnuNewItem: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuDelete: TMenuItem;
    mnuDash: TMenuItem;
    mnuPrint: TMenuItem;
    mnuAppPad: TMenuItem;
    N1: TMenuItem;
    mnuClose: TMenuItem;
    mnuCloseAll: TMenuItem;
    N7: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    N11: TMenuItem;
    mnuFont: TMenuItem;
    mnuPrev: TMenuItem;
    mnuPrevious: TMenuItem;
    mnuNext: TMenuItem;
    ImageList1: TImageList;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    FontDialog: TFontDialog;
    cboReminderTime: TComboBox;
    Label3: TLabel;
    ToolBar1: TToolBar;
    tbbSaveClose: TToolButton;
    ToolButton1: TToolButton;
    tbbCut: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    tbbDelete: TToolButton;
    ToolButton12: TToolButton;
    tbbPrevious: TToolButton;
    tbbNext: TToolButton;
    ActionList1: TActionList;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    txtLocation: TEdit;
    N2: TMenuItem;
    mnuRecurr: TMenuItem;
    pnlDate: TPanel;
    cboStartHour: TComboBox;
    cboEndHour: TComboBox;
    dpStartDate: TFDatePicker;
    dpEndDate: TFDatePicker;
    Label5: TLabel;
    Label2: TLabel;
    chkAllDayEvent: TCheckBox;
    TabSheet1: TTabSheet;
    sg: TStringGrid;
    Label10: TLabel;
    Panel3: TPanel;
    Bevel3: TBevel;
    Label4: TLabel;
    Label6: TLabel;
    dpStartPlan: TFDatePicker;
    dpEndPlan: TFDatePicker;
    cboStartPlanHr: TComboBox;
    cboEndPlanHr: TComboBox;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cmdNetMeet: TButton;
    sch: TfrmSchd;
    Label11: TLabel;
    procedure cmdCategoryClick(Sender: TObject);
    procedure Changed(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure tbbSaveCloseClick(Sender: TObject);
    procedure tbbDeleteClick(Sender: TObject);
    procedure tbbPreviousClick(Sender: TObject);
    procedure tbbNextClick(Sender: TObject);
    procedure mnuPrintClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuNewItemClick(Sender: TObject);
    procedure mnuFontClick(Sender: TObject);
    procedure reMemoEnter(Sender: TObject);
    procedure reMemoExit(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure chkReminderClick(Sender: TObject);
    procedure cboReminderTimeChange(Sender: TObject);
    procedure mnuCloseAllClick(Sender: TObject);
    procedure mnuAppPadClick(Sender: TObject);
    procedure cboReminderTimeClick(Sender: TObject);
    procedure dpEndDateChange(Sender: TObject);
    procedure dpStartDateChange(Sender: TObject);
    procedure chkAllDayEventClick(Sender: TObject);
    procedure cboStartHourChange(Sender: TObject);
    procedure mnuRecurrClick(Sender: TObject);
    procedure dpStartPlanChange(Sender: TObject);
    procedure dpEndPlanChange(Sender: TObject);
    procedure cboStartPlanHrChange(Sender: TObject);
    procedure cboEndHourChange(Sender: TObject);
    procedure cboEndHourExit(Sender: TObject);
    procedure cboEndPlanHrChange(Sender: TObject);
    procedure cboStartHourExit(Sender: TObject);
    procedure cmdNetMeetClick(Sender: TObject);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    dtStartTime, dtEndTime: TDateTime;
    mvarChanged: boolean;
    mvarAppItem : UAppointmentItem;
    RecState : integer;
    mvarCallingDate : TdateTime;
    mvarAttendies : TList;
    function getTime(sin: string): TDateTime;
    procedure setChanged(Const Value : Boolean);
    function  Save: Boolean;
    { Private declarations }
    function MemoText: TTextAttributes;
    function DatePart(dt : TDateTime): TDateTime;
    function TimePart(dt : TDateTime): TDateTime;
    procedure CheckWarningPanel;
    procedure generateToTime;
    procedure CheckSchedule;
    procedure AdjustTime(AStart, AEnd: TdateTime);
    procedure DrawScheduleRow(const row : integer; FromDate, ToDate : TdateTime; var clr: TColor; var State: boolean);
    procedure FreeAttendiesExcept(Uid, idType : integer);
    procedure ChangeCap;
    procedure ShowAttendies(lst : TList);
  public
    { Public declarations }
    property AppChange : Boolean read mvarChanged write setChanged;
    property AppItem : UAppointmentItem read mvarAppItem write mvarAppItem;
    property CallingDate : TdateTime read mvarCallingDate write mvarCallingDate;
  end;

implementation

uses uorCtg, dmorgnzr, forRecur;
var
  delay : integer;
  AppLen : real;

{$R *.DFM}
function ValueOfString(s: string): real;
begin
  try
     Result:= StrTOFloat(s);
  except
     on e: exception do Result:=0;
  end;
end;

procedure TfrmEditApp.cmdCategoryClick(Sender: TObject);
var
 cat : UCategory;
 CatStr: string;
begin
 CatStr := txtCategories.text;
 cat:= UCategory.Create;
 if cat.Execute(CatStr) then
    txtCategories.text:= CatStr;
 cat.free;
end;

procedure TfrmEditApp.Changed(Sender: TObject);
begin
 AppChange:= true;
end;

procedure TfrmEditApp.setChanged(Const Value: boolean);
begin
   mvarChanged := Value;
   tbbSaveClose.Enabled := mvarChanged;
   CheckWarningPanel;
end;
procedure TfrmEditApp.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 id, idType : integer;
begin
  id := AppItem.Appointment.UserId ;
  idType:=AppItem.Appointment.IdType ;
  if AppItem.Appointment.SysId = 0 then
     AppItem.Delete
  else
     AppItem.ReleaseForm;
  FreeAttendiesExcept(id,idType);
end;
procedure TfrmEditApp.FreeAttendiesExcept(uid, idType : integer);
var
  i: integer;
begin
  if  mvarAttendies <> nil then begin
      for i:=mvarAttendies.Count-1 downto 0  do
          with UAppMeeting(mvarAttendies[i]) do begin
              if (Id <> uid) or (NameType <> idType) then
                  mvarAppList.delList(Id, NameType);
          UAppMeeting(mvarAttendies[i]).free;
      end;
      mvarAttendies.free;
      mvarAttendies:= nil;
  end;
end;
///////////////////////////////////////////////////////////////////



procedure TfrmEditApp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
     AppChange := false;
     Close;
  end;
end;

procedure TfrmEditApp.FormShow(Sender: TObject);
var
 i: integer;
 dt: TDateTime;
 hr, min, sec, msec : word;
begin
   sg.Cells[0,0]:= 'Õ«÷—Ì‰ Ê  ÃÂÌ“« ';
   Organizer.InitHolidays(dpStartDate);
   Organizer.InitHolidays(dpEndDate);
   pnlWarn.Visible := false;
   with AppItem.Appointment  do begin
     txtSubject.text    := Subject;
     with cboAppType do begin
        Clear;
        items.Add ('¬“«œ');
        items.Add ('‰Ì„Â „‘€Ê·');
        items.Add ('„‘€Ê·');
        items.Add ('»Ì—Ê‰ «“ œ› —');
        ItemIndex := ord(AppType);
     end;
     txtLocation.text := Location;
     reMemo.Text        :=  Attachments;
     txtCategories.text := Categories;
     chkPrivate.Checked := Privacy;
     with  cboReminderTime do begin
           Items.add('0 œﬁÌﬁÂ');
           Items.add('5 œﬁÌﬁÂ');
           Items.add('10 œﬁÌﬁÂ');
           Items.add('15 œﬁÌﬁÂ');
           Items.add('30 œﬁÌﬁÂ');
           Items.add('1 ”«⁄ ');
           Items.add('2 ”«⁄ ');
           Items.add('3 ”«⁄ ');
           Items.add('4 ”«⁄ ');
           Items.add('5 ”«⁄ ');
           Items.add('6 ”«⁄ ');
           Items.add('7 ”«⁄ ');
           Items.add('8 ”«⁄ ');
           Items.add('9 ”«⁄ ');
           Items.add('10 ”«⁄ ');
           Items.add('11 ”«⁄ ');
           Items.add('12 ”«⁄ ');
           Items.add('1 —Ê“');
           Items.add('2 —Ê“');
           itemindex:=0;
     end;
     if ReminderTime > 0 then begin
         chkReminder.Checked := true;
         cboReminderTime.Enabled := true;
         cboReminderTime.itemindex:=-1;
         dt:= AppItem.Appointment.StartTime-ReminderTime;
         if dt >= 1 then begin
            if dt =1 then
               cboReminderTime.Itemindex:= 17
            else
               cboReminderTime.ItemIndex:= 18;
         end else begin
            decodetime(dt, hr, min, sec, msec);
            if (hr > 0) then
               cboReminderTime.Text := inttostr(hr)  + ' ”«⁄ '
            else if (min>0) then
               cboReminderTime.Text := inttostr(min) + ' œﬁÌﬁÂ'
         end;
     end else begin
        cboReminderTime.Enabled := false;
        chkReminder.Checked := false;
     end;
     dtStartTime := StartTime;
     dtEndTime   := EndTime;
     AppLen:= dtEndTime - dtStartTime;
     Organizer.generateTimeFrom(cboStartHour,0);
     cboStartPlanHr.Items.Assign(cboStartHour.items);
     GenerateToTime;
     if AllDayEvent then
        chkAllDayEvent.Checked := true;
     if appItem.Appointment.Recurrence <> nil then begin
        RecState := mrok;
     end else
        RecState := mrYes;

   end;
   dpStartDate.Miladi := dtStartTime; // this will fire change event
   Sch.ShamsiDate := dpStartDate.ShamsiDate ;
   sch.WorkStartHour := dpStartDate.Miladi + Organizer.WorkingStartHour;
   Sch.WorkEndHour   := Organizer.WorkingEndHour;
   Sch.NotifyDateTimeChange := AdjustTime;
   Sch.OnDrawRow := DrawScheduleRow;
   mvarAttendies:= nil;
   if AppItem.Appointment.MeetingId <> 0 then begin
      mvarAttendies := Organizer.getAttendies(AppItem.Appointment.MeetingId);
      ShowAttendies(mvarAttendies);
   end;
   AppChange := false;
   CheckWarningPanel;
   ChangeCap;
end;

procedure TfrmEditApp.tbbSaveCloseClick(Sender: TObject);
begin
  if Save then
     Close;
end;

procedure TfrmEditApp.tbbDeleteClick(Sender: TObject);
begin
  AppItem.Delete;
end;

procedure TfrmEditApp.tbbPreviousClick(Sender: TObject);
var
  ai : UAppointmentItem;
begin
    ai:=AppItem.PreviousItem;
    if ai <> nil then
       ai.edit(CallingDate)
    else if not AppChange then
         Close;
end;

procedure TfrmEditApp.tbbNextClick(Sender: TObject);
var
 ai : UAppointmentItem;
begin
    ai:= AppItem.NextItem;
    if ai <> nil then
       ai.edit(CallingDate)
    else if not AppChange then
         Close;
end;

procedure TfrmEditApp.mnuPrintClick(Sender: TObject);
begin
 if PrintDialog.Execute then
    reMemo.Print('');
end;

procedure TfrmEditApp.mnuSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
      if MessageDlg(Format('»—«Ì ﬂÅÌ —ÊÌ ‰”ŒÂ ﬁ»·Ì ﬂ·Ìœ OK —« »“‰Ìœ %s;', [SaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
    rememo.Lines.SaveToFile(SaveDialog.FileName);
    reMemo.Modified := False;
  end;
end;


function TfrmEditApp.Save: Boolean;
var
 tim: TDateTime;
 mid, rid, i: integer;
begin
   if not AppChange then begin
      result:= true;
      exit;
   end;
   result:= false;
   with AppItem.Appointment do begin
     if chkAllDayEvent.Checked then begin
        AllDayEvent := true;
        AppItem.Appointment.AllDayEvent:= true;
        StartTime := dtStartTime;
        EndTime   := dtEndTime;
     end else begin
        tim := getTime(cboStartHour.Text);
        if tim < 0  then begin
           showmessage('”«⁄  ‘—Ê⁄ ﬁ—«— ’ÕÌÕ ‰Ì” ');
           exit;
        end;
        ReplaceTime(dtStartTime, tim);
        tim := getTime(cboEndHour.Text);
        if tim < 0 then begin
           showmessage('”«⁄  Å«Ì«‰ ﬁ—«— ’ÕÌÕ ‰Ì” ');
           exit;
        end;
        ReplaceTime(dtEndTime, tim);
        if dtEndTime < dtStartTime then begin
           showmessage('‘—Ê⁄ ﬁ—«— »“—ê — «“ Å«Ì«‰ ¬‰ «” ');
           exit;
        end;
        AllDayEvent := False;
     end;
     StartTime:= dtStartTime;
     EndTime  := dtEndTime;
     Subject  := txtSubject.text;
     Location := txtLocation.text;
     Attachments:= reMemo.Text;
     Categories:= txtCategories.text;
     Privacy:= chkPrivate.Checked;
     AppType := CalAppType(cboAppType.itemindex);
     AppChange := false;
     if chkReminder.checked then
        ReminderTime := StartTime - delay/1440
     else
        ReminderTime :=0;

     if Recurrence <> nil then
        case RecState of
           mrOk      : with AppItem.Appointment do begin
                            StartTime := Recurrence.StartDate + Recurrence.StartHour;
                            EndTime   := StartTime + Recurrence.Duration;
                            Recurrence.UpdatePattern;
                       end;
           mrNoToAll : begin
                         Recurrence.Delete;
                         Recurrence := nil;
                         Recurrence.free;
                       end;
        end;
     // in case there is no meeting at all
     // Last Settings of  Meeting should be deleted first
     if AppItem.Appointment.MeetingId <> 0 then begin
        Organizer.DeleteMeeting(AppItem.Appointment.MeetingId);
        AppItem.Appointment.MeetingId :=0;           // a simple appointment
        AppItem.Appointment.Sysid :=0;
     end;
     AppItem.Save;
     if mvarAttendies <> nil then begin
          // important!!!
          // anyone who arranges a meeting is a partner wether
          // he/she is listed in attendies list or not !
          if mvarAttendies.Count > 0 then begin
             mid := appItem.Appointment.Sysid;
             appItem.Appointment.MeetingId := mid;
             appItem.Save;
          end;
          for i:=0 to mvarAttendies.Count-1 do
              AppItem.Save(UAppMeeting(mvarAttendies[i]));
          mvarAppList.setList(AppItem.Appointment.userid, AppItem.Appointment.IdType);
     end;
     Result:= true;
   end;
end;

{            if (Recurrence <> nil) and (RecState= mrOk)  then
               with AppItem.Appointment do begin
                    StartTime := Recurrence.StartDate + Recurrence.StartHour;
                    EndTime   := StartTime + Recurrence.Duration;
                    Recurrence.ID := 0;      // forcing new record
                    Recurrence.UpdatePattern;
               end;}

procedure TfrmEditApp.mnuCloseClick(Sender: TObject);
begin
  if AppChange then
     if MessageDlg(' €ÌÌ—«  œ— ›«Ì· À»  ‰ŒÊ«Â‰œ ‘œ ¬Ì« „ÿ„∆‰ Â” Ìœ', mtConfirmation, mbYesNoCancel, 0) <> idYes then
        Exit;
  Close;
end;


procedure TfrmEditApp.mnuFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(rememo.SelAttributes);
  if FontDialog.Execute then
     MemoText.Assign(FontDialog.Font);
end;

function TfrmEditApp.MemoText: TTextAttributes;
begin
  with reMemo do
    if SelLength > 0 then
       Result := SelAttributes
    else
       Result := DefAttributes;
end;

procedure TfrmEditApp.reMemoEnter(Sender: TObject);
begin
 mnuFont.Enabled := true;
end;


procedure TfrmEditApp.reMemoExit(Sender: TObject);
begin
  mnuFont.Enabled := false;
end;

procedure TfrmEditApp.mnuSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TfrmEditApp.chkReminderClick(Sender: TObject);
begin
  cboReminderTime.Enabled:= chkReminder.checked;
  if cboReminderTime.Enabled then
     cboReminderTime.itemindex:=1
  else
     cboReminderTime.itemindex:=-1;
  Appchange := true;
end;

procedure TfrmEditApp.CheckWarningPanel;
var
  mess, st : string;
begin
  mess:='';
  if Appitem.Appointment.Recurrence = nil then begin
     if Organizer.getTime(cboEndHour.text, st) then
        if dpEndDate.Miladi + StrToTime(st) < now() then
           mess:= '«Ì‰ ﬁ—«— „—»Êÿ »Â ê–‘ Â «” '
  end else begin
      if CallingDate < now() then
          mess:= '«Ì‰ ﬁ—«—  ﬂ—«—Ì Ê  „—»Êÿ »Â ê–‘ Â «” ';
      pnlDate.Visible:= RecState <> mrok;
      if (RecState = mrok) then begin
         if mess <> '' then
            mess := mess + chr(13)+ chr(10);

         mess:= mess + AppItem.Appointment.Recurrence.Text ;
      end;
  end;
  lblWarn.Caption := mess;
  pnlWarn.Visible := Length(mess) > 0;
end;

procedure TfrmEditApp.cboReminderTimeChange(Sender: TObject);
var
 d : real;
begin
 d:=getTime(cboReminderTime.text );
 if d> 0 then
    Delay := trunc(d * 1440);
 AppChange := true;
end;

procedure TfrmEditApp.mnuAppPadClick(Sender: TObject);
begin
   with Organizer do
      if CalendarPad <> nil then
         CalendarPad.BringToFront
      else
         ShowCalendarPad;
end;

procedure TfrmEditApp.mnuCloseAllClick(Sender: TObject);
begin
  AppItem.Parent.CloseAll;
end;

procedure TfrmEditApp.mnuNewItemClick(Sender: TObject);
var
 ai: UAppointmentItem;
begin
 ai:=UAppointmentItem.Create;
 ai.Edit(CallingDate);
end;

procedure TfrmEditApp.cboReminderTimeClick(Sender: TObject);
begin
  with cboReminderTime do
    case ItemIndex of
       0, 1, 2,3 :
           Delay:= ItemIndex *  5;     // 0,5,10,15 minutes
       4 :
           Delay := 30;
       5,6,7,8,9,10,11,12,13,14,15,16 :            // 1..12 hours
           Delay :=  (ItemIndex-4) *  60;
       17,18 :
           Delay:= (ItemIndex-16) *  24 * 60; // 1..2 days
     end;
end;
function TfrmEditApp.DatePart(dt : TDateTime): TDateTime;
var
  y,m,d : word;
begin
  Decodedate(dt, y, m, d);
  Result:=EnCodeDate(y, m, d);
end;

function TfrmEditApp.TimePart(dt : TDateTime): TDateTime;
var
  h, m, s, ms : word;
begin
  DecodeTime(dt, h, m, s, ms);
  Result:=EnCodeTime(h, m, s, ms);
end;

procedure TfrmEditApp.dpStartDateChange(Sender: TObject);
  begin
   dtStartTime := dpStartDate.Miladi + TimePart(dtStartTime);
   dtEndTime   := dtStartTime + AppLen;
   cboStartHour.Text:= TimeTostr(dtStartTime);
   cboStartPlanHr.Text := cboStartHour.Text;
   cboEndHour.Text:= TimeTostr(dtEndTime);
   dpEndDate.Miladi := dtEndTime;
   dpEndPlan.Miladi := dtEndTime;
   if dpStartPlan.Miladi <> dpStartDate.Miladi then
     dpStartPlan.Miladi := dpStartDate.Miladi;
   Sch.AppointmentStart := dtStartTime;
   AppChange := true;

  end;

procedure TfrmEditApp.dpEndDateChange(Sender: TObject);
  var
   dt : TDateTime;
  begin
   dt := dpEndDate.Miladi + StrToTime(cboEndHour.Text);
   if dt < dtStartTime then begin
      showmessage(' «—ÌŒ Å«Ì«‰ ﬁ»· «“  «—ÌŒ ‘—Ê⁄ «” ');
      dpEndDate.Miladi := dtEndTime;
   end else begin
      dtEndTime := dt;
      AppLen := dtEndTime - dtStartTime;
   end;
   generateToTime;
   if dpEndPlan.Miladi <> dpEndDate.Miladi  then
      dpEndPlan.Miladi := dpEndDate.Miladi;
    Sch.AppointmentEnd := dtEndTime;
   AppChange := true;
  end;

function TfrmEditApp.getTime(sin: string): TDateTime;
var
 sout: string;
begin
  Result:= -1;
  if Organizer.getTime(sin, sout) then
     Result:= strtoTime(sout);
end;

procedure TfrmEditApp.generateToTime;
begin
     if DatePart(dtEndTime) <> DatePart(dtStartTime) then
        Organizer.generateTimeFrom(cboEndHour,0)
     else
        Organizer.generateTimeFrom(cboEndHour,TimePart(dtStartTime));
      cboEndPlanHr.Items.Assign(cboEndHour.Items);
     if cboEndPlanHr.Text <> cboEndHour.Text then
        cboEndPlanHr.Text := cboEndHour.Text
end;
procedure TfrmEditApp.chkAllDayEventClick(Sender: TObject);
var
 b: boolean;
begin
 b:= not chkAllDayEvent.Checked;
 cboStartHour.Visible := b;
 cboEndHour.Visible := b;
 if b then begin
    if dtEndTime <= dtStartTime then
       ReplaceTime(dtEndTime, TimePart(dtStartTime)+ 1/24); // an hour
    cboStartHour.Text := TimeTostr(dtStartTime);
    cboEndHour.Text := TimeTostr(dtEndTime);
    applen:=dtEndTime - dtStartTime;
 end
 else begin
    dtStartTime:= floor(dtStartTime);
    dtEndTime:= ceil(dtEndTime);
    AppLen :=  dtEndTime- dtStartTime;
    CheckSchedule;
    dpStartPlan.Miladi := dtStartTime;
    dpEndPlan.Miladi := dtEndTime;
    cboStartPlanhr.Text := 'AM 12:00';
    cboEndPlanhr.Text := 'AM 12:00';
 end;
 changeCap;
 AppChange := true;
end;

procedure TfrmEditApp.cboStartHourChange(Sender: TObject);
var
 ti : TDateTime;
begin
   ti:= getTime(cboStartHour.text);
   if ti >=0 then begin
       dtStartTime    := DatePart(dtStartTime) + ti;
       dtEndTime      := dtStartTime + AppLen;
       cboEndHour.text    := TimeToStr(dtEndTime);
       dpEndDate.miladi:= dtEndTime;
       if cboStartHour.text <> cboStartPlanHr.Text then
          cboStartPlanHr.text:= TimeTostr(dtStartTime);
       CheckSchedule;
       generateToTime;
       chkAllDayEvent.Checked := (dtStartTime = floor(dtStartTime)) and (dtEndTime = floor(dtEndTime)) and ( AppLen > 0);
    end else begin
       showmessage('›—„  ”«⁄  €·ÿ «” ');
       cboStartHour.text:= TimeToStr(dtStartTime);
    end;
    Changed(sender);
end;

procedure TfrmEditApp.mnuRecurrClick(Sender: TObject);
var
  f : TfrmRecurr;
begin
  f :=TfrmRecurr.Create(self);
  if (AppItem.Appointment.Recurrence <> nil) and (RecState <> mrNoToAll) then begin
     f.RecurrenceBeforeEdit := AppItem.Appointment.Recurrence;
     f.State := True;
  end
  else begin
     f.RecurrenceBeforeEdit := UReccWeekly.Create;
     with UReccWeekly(f.RecurrenceBeforeEdit) do begin
       if AppItem.Appointment.Recurrence <> nil then
          id := AppItem.Appointment.Recurrence.Id
       else
          id :=0;
       StartDate := dpStartDate.miladi;
       StartHour := frac(dtStartTime);
       Duration  := AppLen;
       Every_N_Weeks :=1;
       WeekDays := 1;
     end;
  end;
  RecState:= mrYes;
  case f.showmodal of
     mrOk : begin
                RecState := mrOk;
                appItem.Appointment.Recurrence.Free;
                appItem.Appointment.Recurrence := f.RecurrenceAfterEdit;
            end;
     mrNoToAll : RecState := mrNoToAll
  end;
  if (RecState = mrOk) or (RecState = mrNoToAll) then
     AppChange := true;
  f.free;
  CheckWarningPanel;
end;

procedure TfrmEditApp.dpStartPlanChange(Sender: TObject);
begin
 dpStartDate.miladi := dpStartPlan.miladi;
end;

procedure TfrmEditApp.dpEndPlanChange(Sender: TObject);
begin
  dpEndDate.Miladi:= dpEndPlan.Miladi;
end;

procedure TfrmEditApp.CheckSchedule;
begin
 Sch.AppointmentStart := dtStartTime;
 Sch.AppointmentEnd   := dtEndTime;
end;

procedure TfrmEditApp.cboStartPlanHrChange(Sender: TObject);
begin
   if cboStartHour.Text <> cboStartPlanHr.Text then begin
      cboStartHour.Text := cboStartPlanHr.Text;
      cboStartHourChange(cboStartHour);
   end;
end;

procedure TfrmEditApp.cboEndHourChange(Sender: TObject);
var
 dt : TDateTime;
 ti: TDateTime;
begin
  ti:=getTime(cboEndHour.text);
  if ti >-1 then begin
     dt:= DatePart(dtEndTime) + ti;
     if  dt >= dtStartTime then begin
        dtEndTime := dt;
        AppLen := dtEndTime - dtStartTime ;
        if cboEndHour.text <> cboEndPlanHr.text then
           cboEndPlanHr.text:= TimeToStr(dtEndTime);
        CheckSchedule;    
     end;
  end else begin
     showmessage('”«⁄  €·ÿ «” ');
     cboEndHour.text:= TimeToStr(dtEndTime);
  end;
  Changed(sender);
end;

procedure TfrmEditApp.cboEndHourExit(Sender: TObject);
var
  ti, dt: TDateTime;
begin
   ti:=getTime(cboEndHour.text);
   dt:= DatePart(dtEndTime) + ti;
   if ti >-1 then begin
      if  dt < dtStartTime then begin
        Showmessage('”«⁄  ‘—Ê⁄ »«Ì” Ì ﬂÊçﬂ — «“ ”«⁄  Å«Ì«‰ »«‘œ');
        cboEndHour.text := TimeToStr(dtEndTime);
     end else begin
        cboEndHour.text:= TimeToStr(dtEndTime);
        cboEndPlanHr.text:= cboEndHour.text;
     end;
   end
   else begin
     showmessage('”«⁄  €·ÿ «” ');
     cboEndHour.text:= TimeToStr(dtEndTime);
   end;
end;

procedure TfrmEditApp.cboEndPlanHrChange(Sender: TObject);
begin
   if cboEndHour.Text <> cboEndPlanHr.Text then begin
      cboEndHour.Text := cboEndPlanHr.Text;
      cboEndHourChange(cboEndHour);
   end;

end;

procedure TfrmEditApp.cboStartHourExit(Sender: TObject);
var
  ti: TDateTime;
begin
   ti:=getTime(cboStartHour.text);
   if ti > 0 then begin
      cboStartHour.text:= TimeToStr(dtStartTime);
      cboStartPlanHr.text:= cboStartHour.text;
   end
   else begin
     showmessage('”«⁄  €·ÿ «” ');
     cboStartHour.text:= TimeToStr(dtStartTime);
   end;

end;

procedure TfrmEditApp.AdjustTime(AStart, AEnd : TdateTime);
begin
    dtStartTime:= AStart;
    dtEndTime  := AEnd;
    AppLen:= dtEndTime- dtStartTime;

    cboStartHour.Text := Timetostr(dtStartTime);
    cboStartPlanHr.Text := cboStartHour.Text;
    cboEndHour.Text := Timetostr(dtEndTime);
    cboEndPlanHr.Text := cboEndHour.Text;
    if dpStartDate.Miladi <> DatePart(dtStartTime) then
       dpStartDate.Miladi := dtStartTime;
    if dpEndDate.Miladi <> DatePart(dtEndTime) then
       dpEndDate.Miladi := dtEndTime;
    AppChange:= true;
end;
procedure TfrmEditApp.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect:= sg.Cells[acol, arow] <> '';
end;

procedure TfrmEditApp.ShowAttendies(lst : TList);
var
 i: integer;
begin
    if lst = nil then
       exit;
    sg.RowCount := 30;
    for i:=1 to sg.rowcount-1 do
        sg.Cells[0,i]:='';
    for i:=0 to lst.Count-1 do
         sg.Cells[0,i+1] := UAppMeeting(lst[i]).Text;
    for i:=0 to lst.Count-1 do
        with UAppMeeting(lst[i]) do begin
             if (Id <> AppItem.Appointment.UserId) or (NameType <> AppItem.Appointment.IdType) then
                Organizer.ReadAppointments(Id , NameType);
        end;
    mvarAppList.setList(AppItem.Appointment.UserId, AppItem.Appointment.IdType);
    Sch.ScheduledRows := lst.count;
end;

procedure TfrmEditApp.cmdNetMeetClick(Sender: TObject);
var
 f: TfrmNetMeet;
 i: integer;
 ar : TList;
 un : UAppMeeting;
begin
 ar:= TList.Create;
 f:= TfrmNetMeet.Create(self);
 if mvarAttendies <> nil then begin
    for i:=0 to mvarAttendies.Count-1 do begin
       un:= UAppMeeting.Create;
       un.Id:= UAppMeeting(mvarAttendies[i]).Id;
       un.NameType:= UAppMeeting(mvarAttendies[i]).NameType;
       ar.Add(un);
    end;
    f.List:=mvarAttendies;
 end;
 if f.showModal = mrOk then
    AppChange := true;
    with f do  begin
        for i:=0 to ar.count-1 do
           with UAppMeeting(ar[i]) do
             if (id <> AppItem.Appointment.UserId) or (NameType <> AppItem.Appointment.idType) then
                mvarAppList.delList(id, NameType);
        for i:= 0 to ar.Count-1 do
            UAppMeeting(ar[i]).free;
        mvarAttendies:= f.List;
        ShowAttendies(mvarAttendies);
    end;
 f.free;
end;

procedure TfrmEditApp.DrawScheduleRow(const row: integer; FromDate,
  ToDate: TdateTime; var clr: TColor; var State: boolean);
var
 cu_id, cu_type, i : integer;
 List : TList;
 dts, dte, hrFrom, hrTo : TdateTime;

begin

 cu_id := mvarAppList.CurrentList.UserId;
 cu_type := mvarAppList.CurrentList.IdType;
 mvarAppList.setList(UAppMeeting(mvarAttendies[row-1]).Id, UAppMeeting(mvarAttendies[row-1]).NameType);
 List := mvarAppList.getList;
 dts :=DatePart(FromDate);
 dte := DatePart(ToDate);
 if (cu_id = 30000034) and (dts = 36900) then
    FromDate := FromDate + 2 - 2/1;
 while (dts <= dte) and (not State) do begin
      for i:= 0 to List.Count - 1 do
         if UAppointmentItem(List[i]).Appointment.OccuresAt(dts, hrFrom, hrTo) then begin
            if (hrFrom < ToDate) and (hrto > FromDate) then
              if (UAppointmentItem(List[i]).Appointment.SysId <> 0) then begin
               case UAppointmentItem(List[i]).Appointment.AppType of
                    ctnFree       : clr := clWhite;
                    ctnTentative  : clr := clTeal;
                    ctnBusy       : clr := clBlue;
                    ctnOut        : Clr := clPurple;
               end;
               State := true;
               break;
            end;
         end;
      dts := dts+1;
 end;
 mvarAppList.setList(cu_id, cu_Type);
end;

procedure TfrmEditApp.ChangeCap;
begin
   if trim(txtSubject.Text) <> '' then
      if chkAllDayEvent.Checked then
         Caption := txtSubject.Text + '- „‰«”» '
      else
          Caption := txtSubject.Text + '- ﬁ—«—'
   else
      if chkAllDayEvent.Checked then
         Caption := '»œÊ‰ ⁄‰Ê«‰ - „‰«”» '
      else
          Caption := '»œÊ‰ ⁄‰Ê«‰ - ﬁ—«—';
end;

end.
