unit forTskEd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Menus, ImgList, ToolWin, uorTask, StdActns,
  ActnList, FDatePicker;

type
  TfrmEditTask = class(TForm)
    PageControl1: TPageControl;
    shtTask: TTabSheet;
    shtStatus: TTabSheet;
    MainMenu1: TMainMenu;
    mnuTask: TMenuItem;
    mnuNewTask: TMenuItem;
    mnuSave: TMenuItem;
    mnuDelete: TMenuItem;
    mnuDash: TMenuItem;
    mnuPrint: TMenuItem;
    mnuClose: TMenuItem;
    N7: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    N11: TMenuItem;
    mnuPrev: TMenuItem;
    mnuPrevious: TMenuItem;
    mnuNext: TMenuItem;
    mnuFont: TMenuItem;
    ImageList1: TImageList;
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
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    txtTotalWork: TEdit;
    txtActualWork: TEdit;
    Bevel3: TBevel;
    Label10: TLabel;
    txtCompanies: TEdit;
    ActionList1: TActionList;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    mnuSaveAs: TMenuItem;
    FontDialog: TFontDialog;
    dpDateCompleted: TFDatePicker;
    Label6: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    txtMileage: TEdit;
    txtBillingInfo: TEdit;
    txtContacts: TEdit;
    Panel1: TPanel;
    pnlWarn: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StaticText1: TStaticText;
    spCompleted: TUpDown;
    Panel3: TPanel;
    rdNotDue: TRadioButton;
    rdHasDue: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    txtSubject: TEdit;
    dpDueDate: TFDatePicker;
    dpStartDate: TFDatePicker;
    cboImportance: TComboBox;
    txtCompletedPercent: TEdit;
    cboStatus: TComboBox;
    cboReminderHour: TComboBox;
    dpReminderDate: TFDatePicker;
    chkReminder: TCheckBox;
    lblWarn: TLabel;
    imgWarn: TImage;
    Panel2: TPanel;
    reMemo: TRichEdit;
    Panel4: TPanel;
    chkPrivate: TCheckBox;
    txtCategories: TEdit;
    cmdCategory: TButton;
    N1: TMenuItem;
    N2: TMenuItem;
    mnuTaskPad: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Changed(Sender: TObject);
    procedure tbbSaveCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbbDeleteClick(Sender: TObject);
    procedure tbbPreviousClick(Sender: TObject);
    procedure tbbNextClick(Sender: TObject);
    procedure mnuPrintClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuNewTaskClick(Sender: TObject);
    procedure mnuFontClick(Sender: TObject);
    procedure reMemoEnter(Sender: TObject);
    procedure reMemoExit(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure chkReminderClick(Sender: TObject);
    procedure rdHasDueClick(Sender: TObject);
    procedure dpStartDateChange(Sender: TObject);
    procedure dpDueDateChange(Sender: TObject);
    procedure cmdCategoryClick(Sender: TObject);
    procedure cboReminderHourChange(Sender: TObject);
    procedure dpReminderDateChange(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure cboStatusChange(Sender: TObject);
    procedure mnuTaskPadClick(Sender: TObject);
    procedure txtCompletedPercentChange(Sender: TObject);
  private
    mvarTaskItem : UTaskItem;
    mvarChanged : Boolean;
    procedure setChanged(const Value: Boolean);
    property TaskChange : Boolean read mvarChanged write setChanged;
    function MemoText: TTextAttributes;
    procedure CheckWarningPanel;
    procedure setTaskItem(const Value: UTaskItem);
  public
    property TaskItem : UTaskItem read mvarTaskItem write setTaskItem;
    function Save: boolean;
  end;

implementation
uses uorCtg, dmorgnzr;
{$R *.DFM}

procedure TfrmEditTask.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if TaskChange then
     if MessageDlg(' €ÌÌ—«  œ— ›«Ì· À»  ‰ŒÊ«Â‰œ ‘œ ¬Ì« „ÿ„∆‰ Â” Ìœ', mtConfirmation, mbYesNoCancel, 0) <> idYes then begin
        Action:=  caNone;
        Exit;
     end;
  TaskItem.ReleaseForm;
end;


procedure TfrmEditTask.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
     TaskChange := false;
     Close;
  end;
end;

procedure TfrmEditTask.FormShow(Sender: TObject);
var
 i,h: integer;
 s: string;

begin
   Organizer.InitHolidays(dpStartDate);
   Organizer.InitHolidays(dpDueDate);
   Organizer.InitHolidays(dpReminderDate);
   Organizer.InitHolidays(dpDateCompleted);
   pnlWarn.Visible := false;
   with TaskItem.Task do begin
     txtSubject.text    := Subject;
     rdHasDue.checked := DueDate <> 0;
     rdNotDue.Checked := not rdHasDue.checked;
     dpDueDate.Miladi:= DueDate;
     dpStartDate.Miladi := StartDate;
     with cboStatus do begin
        ItemIndex := ord(Status);
     end;
     with  cboImportance do begin
        ItemIndex := ord(Importance);
     end;
     with cboReminderHour do begin
         Clear;
         for i:= 0 to 47 do begin
            if i mod 24 <=1 then
               h := 12
            else
               h:=trunc(i/2) mod 12;
            s:=stringreplace(format('%2d:%2d', [h,i mod 2 * 30 ]), ' ','0', [rfreplaceall]);
            if i < 24 then
               //s:= s + ' ’»Õ'
               s:= s + ' AM'
            else
               //s:= s + ' ⁄’—';
               s:= s + ' PM';
            items.add(s);
         end;
     end;
     txtCompletedPercent.text := floattostr(PercentCompleted);
     chkReminder.OnClick := nil;  // to suppress Click Event
     chkReminder.Checked := ReminderDate <> 0;
     if ReminderDate <> 0 then begin
        cboReminderHour.text := TimeToStr(ReminderDate);
        cboReminderHour.Enabled := True;;
     end else begin
        cboReminderHour.Enabled := false;
        cboReminderHour.text := '';
        dpReminderDate.Miladi := 0;
     end;
     dpReminderDate.Enabled := chkReminder.Checked;
     dpReminderDate.Miladi := ReminderDate;
     chkReminder.OnClick := chkReminderClick; 
     reMemo.Text        :=  Attachments;
     txtCategories.text := Categories;
     chkPrivate.Checked := Privacy;
// second tab
     txtCompletedPercent.text := inttostr(PercentCompleted);
     dpDateCompleted.Miladi := DateCompleted;
     txtTotalWork.text  := floatTostr(TotalWork);
     txtActualWork.text := floatTostr(actualWork);
     txtMileage.text:= Mileage;
     txtBillingInfo.text:=BillingInformation;
     txtContacts.text:=Contacts;
     txtCompanies.text  := Companies;
   end;
   TaskChange := false;

end;

procedure TfrmEditTask.Changed(Sender: TObject);
begin
 TaskChange:= true;
end;

procedure TfrmEditTask.tbbSaveCloseClick(Sender: TObject);
begin
  if Save then
     Close;
end;

procedure TfrmEditTask.setChanged(const Value: Boolean);
begin
   mvarChanged := Value;
   tbbSaveClose.Enabled := mvarChanged;
end;

procedure TfrmEditTask.tbbDeleteClick(Sender: TObject);
begin
  TaskItem.Delete;
end;

procedure TfrmEditTask.tbbPreviousClick(Sender: TObject);
var
  ti : UTaskItem;
begin
    ti:=TaskItem.PreviousItem;
    if ti <> nil then
       ti.edit
    else if not TaskChange then
         Close;
end;

procedure TfrmEditTask.tbbNextClick(Sender: TObject);
var
 ti : UTaskItem;
begin
    ti:= TaskItem.NextItem;
    if ti <> nil then
       ti.edit
    else if not TaskChange then
         Close;
end;

procedure TfrmEditTask.mnuPrintClick(Sender: TObject);
begin
 if PrintDialog.Execute then
    reMemo.Print('');
end;

procedure TfrmEditTask.mnuSaveAsClick(Sender: TObject);
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

function getTime(txt: string; var st: string): boolean;
var
 dt: TDateTime;
 base : integer;
 mor, aft, rep: string;
begin
  mor:='’»Õ';
  aft:='⁄’—';
  try
    st:= txt;
    dt:=strToTime(st);
    Result:= true;
  except
    on e: EConverterror do begin
       rep:='';
       base :=0;
       if pos(aft,st)>0 then begin
          base:= 12;
          rep:= aft;
       end else if pos(mor, st) >0 then
                   rep := mor;
       st:=stringReplace(st,rep,'', [rfReplaceAll]);
       try
          st:= TimeToStr(StrToTime(st) + base);
          Result:= True;
       except
          on e: EConvertError do
             Result:= False;
       end;
     end;
   end;
end;

function TfrmEditTask.Save: Boolean;
var
 dt : TDateTime;
 st: string;
begin
   result:= false;
   with TaskItem.Task do begin

     if rdHasDue.Checked then
        if not dpDueDate.ISValid then
           begin
              showmessage(' «—ÌŒ ”— —”Ìœ „⁄ »— ‰Ì” ');
              exit;
           end;
     if trim(dpStartDate.text) <> '' then
        if not dpStartDate.ISValid then
            begin
                  showmessage(' «—ÌŒ ‘—Ê⁄ „⁄ »— ‰Ì” ');
                  exit;
            end;
     chkReminder.Checked:= dpReminderDate.Miladi <> 0;
     dt:=0;
     if chkReminder.Checked then
        if not dpReminderDate.ISValid then
           begin
              showmessage(' «—ÌŒ Ì«œ¬Ê—Ì „⁄ »— ‰Ì” ');
              exit;
           end
        else begin
           dt :=dpReminderDate.Miladi;
           if not getTime(trim(cboReminderHour.text), st) then begin
              showmessage('”«⁄  Ì«œ¬Ê—Ì „‘Œ’ ‰Ì” ');
              exit;
           end
           else
              ReplaceTime(dt, StrTotime(st))
        end;

     if trim(dpDateCompleted.text) <> '' then
        if not dpDateCompleted.ISValid then
            begin
                  showmessage(' «—ÌŒ Œ« „Â „⁄ »— ‰Ì” ');
                  exit;
            end;

     Subject := txtSubject.text;
     Status := TaskStatus(cboStatus.itemindex);
     Importance := TaskImportance(cboImportance.ItemIndex);
     Attachments:= reMemo.Text;
     Categories:= txtCategories.text;
     Privacy:= chkPrivate.Checked;

     PercentCompleted := round(Organizer.ValueofString(txtCompletedPercent.text));
     TotalWork        := Organizer.ValueofString(txtTotalWork.text);
     actualWork       := Organizer.ValueofString(txtActualWork.text);
     Mileage          := txtMileage.text;
     BillingInformation := txtBillingInfo.text;
     Contacts         := txtContacts.text;
     Companies := txtCompanies.text;
//
     if rdHasDue.Checked then
        DueDate   := dpDueDate.Miladi
     else
        DueDate :=0;
//
     if trim(dpStartDate.text) <> '' then
         StartDate := dpStartDate.Miladi
     else
         StartDate :=0;
//
     if chkReminder.Enabled then begin
        ReminderDate   := dt;
        PostReminderDate := dt;
     end
     else
        ReminderDate :=0;
//
     if trim(dpDateCompleted.text) <> '' then
         DateCompleted := dpDateCompleted.Miladi
     else
         DateCompleted :=0;
   end;
   TaskChange := false;
   TaskItem.Save;
   Result:= true;
end;

procedure TfrmEditTask.mnuCloseClick(Sender: TObject);
begin
  if TaskChange then
     if MessageDlg(' €ÌÌ—«  œ— ›«Ì· À»  ‰ŒÊ«Â‰œ ‘œ ¬Ì« „ÿ„∆‰ Â” Ìœ', mtConfirmation, mbYesNoCancel, 0) <> idYes then
        Exit;
  Close;
end;

procedure TfrmEditTask.mnuNewTaskClick(Sender: TObject);
var
 ti: UTaskItem;
begin
 ti:=UTaskItem.Create;
 ti.Edit;
end;

procedure TfrmEditTask.mnuFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(rememo.SelAttributes);
  if FontDialog.Execute then
     MemoText.Assign(FontDialog.Font);
end;

function TfrmEditTask.MemoText: TTextAttributes;
begin
  with reMemo do
    if SelLength > 0 then
       Result := SelAttributes
    else
       Result := DefAttributes;
end;

procedure TfrmEditTask.reMemoEnter(Sender: TObject);
begin
 mnuFont.Enabled := true;
end;

procedure TfrmEditTask.reMemoExit(Sender: TObject);
begin
  mnuFont.Enabled := false;
end;

procedure TfrmEditTask.mnuSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TfrmEditTask.chkReminderClick(Sender: TObject);
begin
  if not chkReminder.Checked then
     begin
       dpReminderDate.miladi :=0;
       cboReminderHour.ItemIndex :=-1;
     end
  else
     begin
       if dpDueDate.miladi > 0 then
          dpReminderDate.miladi := dpDueDate.miladi
       else
          dpReminderDate.miladi := Date()+1;
          cboReminderHour.ItemIndex :=16;
     end;
  dpReminderDate.Enabled := chkReminder.Checked;
  cboReminderHour.Enabled:= chkReminder.Checked;
  Taskchange := true;
end;

procedure TfrmEditTask.rdHasDueClick(Sender: TObject);
//var
//  d: TDateTime;
begin
  if rdNotDue.checked then begin
     dpStartDate.miladi :=0;
     dpDueDate.Miladi:= 0;
  end
  else begin
     dpStartDate.miladi :=0;
     if dpDueDate.Miladi = 0 then
        if TaskItem.Task.DueDate= 0 then
           dpDueDate.Miladi:= date()
        else
           dpDueDate.Miladi:= TaskItem.Task.DueDate;
  end;
  TaskChange := true;
end;


procedure TfrmEditTask.dpStartDateChange(Sender: TObject);
begin
 TaskChange := true;
 rdHasDue.Checked := (dpStartDate.Miladi <> 0) or (dpDueDate.Miladi <> 0);
 if rdHasDue.Checked and (dpStartDate.Miladi > dpDueDate.Miladi) then
    dpDueDate.Miladi:= dpStartDate.Miladi;
 CheckWarningPanel;
end;

procedure TfrmEditTask.dpDueDateChange(Sender: TObject);
var
  b : boolean;
begin
 TaskChange := true;
 b:= (dpduedate.Miladi <> 0);
 if b and
      (dpStartDate.Miladi<>0) and
      (dpduedate.Miladi < dpStartDate.Miladi) then begin
    beep;
    ShowMessage(' «—ÌŒ ”——”Ìœ ‰„Ì Ê«‰œ «“  «—ÌŒ ‘—Ê⁄ ﬂ„ — »«‘œ');
    dpduedate.Miladi := dpStartDate.Miladi;
 end;
 CheckWarningPanel;
 if b then
    rdHasDue.Checked := true
 else
    rdNotDue.Checked := true;
end;

procedure TfrmEditTask.CheckWarningPanel;
var
  days : integer;
  c : string;
  b : boolean;
begin
  lblWarn.Visible := false;
  b:= pnlwarn.Visible;
  if not rdhasDue.checked then begin
     pnlwarn.Visible :=false;
     exit;
  end;

  days := trunc(dpDueDate.miladi - date());
  if abs(days) > 14 then begin
     pnlwarn.Visible :=false;
     exit;
  end;

  pnlwarn.Visible :=true;
  case days of
    -2 : c:= '”——”Ìœ Å—Ì——Ê“ »Êœ';
    -1 : c:= '”——”Ìœ œÌ——Ê“ »Êœ';
     0 : c:= '”——”Ìœ «„—Ê“ «” ';
     1 : c:= '›—œ« ”— —”Ìœ „Ì‘Êœ';
     2 : c:= 'Å” ›—œ« ”— —”Ìœ „Ì‘Êœ';
    else
     if days < 0 then
        c:= '  ”——”Ìœ‘ ' + inttostr(-days)+ ' —Ê“ ﬁ»· »Êœ'
     else
        c:= '  ' + inttostr(days) + ' —Ê“ œÌê— ”——”Ìœ „Ì‘Êœ';
  end;
   imgWarn.Visible := days < 0;
   lblWarn.caption := c;
   lblWarn.Visible := True;
end;
procedure TfrmEditTask.cmdCategoryClick(Sender: TObject);
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

procedure TfrmEditTask.cboReminderHourChange(Sender: TObject);
begin
 TaskChange := true;
end;

procedure TfrmEditTask.dpReminderDateChange(Sender: TObject);
begin
  TaskChange := true;
  if (not chkReminder.Checked) or (dpReminderDate.miladi >= Date) then
     exit;
  if dpReminderDate.miladi <> 0 then
     showmessage(' «—ÌŒ Ì«œ¬Ê—Ì «“ «„—Ê“ ⁄ﬁ»  — «” ')
  else
     showmessage(' «—ÌŒ Ì«œ¬Ê—Ì „‘Œ’ ‰Ì” ');
end;                            

procedure TfrmEditTask.N2Click(Sender: TObject);
begin
  TaskItem.Parent.CloseAll; 
end;

procedure TfrmEditTask.cboStatusChange(Sender: TObject);
begin
 case TaskStatus(cboStatus.itemindex) of
     tsCompleted  :  txtCompletedPercent.text:= '100';
     tsNotStarted :  txtCompletedPercent.text:= '0';
 end;
 TaskChange := true;
end;

procedure TfrmEditTask.mnuTaskPadClick(Sender: TObject);
begin
   with Organizer do
      if TasksPad <> nil then
         TasksPad.BringToFront
      else
         TasksPad.show;
end;

procedure TfrmEditTask.txtCompletedPercentChange(Sender: TObject);
var
 value : real;
begin
  value := round(Organizer.ValueofString(txtCompletedPercent.text));
  if Value > 100 then
     txtCompletedPercent.text := '100';
  if Value = 100 then begin
     if dpDateCompleted.Miladi = 0 then
        dpDateCompleted.Miladi := Date;
     cboStatus.ItemIndex := 2;
  end else begin
     dpDateCompleted.Miladi := 0;
     if cboStatus.ItemIndex = 2 then
        cboStatus.ItemIndex :=0;
  end;
end;
procedure TfrmEditTask.setTaskItem(const Value: UTaskItem);
begin
  mvarTaskItem:= Value;
end;

end.
