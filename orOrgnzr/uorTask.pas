unit uorTask;

interface
uses  Classes, windows, forms, comctrls, Controls, dialogs, sysutils, graphics, uorComm, FCal ;

Type
  TaskValueType = (uvtString, uvtValue);
  TaskStatus = (tsNotStarted, tsInProgress, tsCompleted, tsWaiting, tsDeferred);
  TaskImportance = (prlow, prNormal, prHigh);
  TaskCols = ( tcDummy, tcDateCreated, tcSubject, tcDueDate, tcStartDate , tcLastModifyDate,
     tcStatus, tcImportance, tcPercentCompleted, tcReminderDate, tcAttachments,
     tcCategories, tcPrivacy, tcDateCompleted, tcActualWork,  tcTotalWork,
     tcContacts, tcBillingInformation, tcCompanies, tcMileage, tcLastElement);

  UTask = Class
     private
       mvarSysId : integer;
       mvarSubject : string;
       mvarDueDate, mvarStartDate : TDate;
       mvarStatus : TaskStatus;
       mvarPercentCompleted : integer;
       mvarImportance : TaskImportance;
       mvarCategories: string;
       mvarPrivacy : boolean;
       mvarDateCompleted : TDate;
       mvarCreationTime,
       mvarLastModificationTime: TDate;
       mvarAttachments : string;
       mvarBillingInformation,
       mvarContacts,
       mvarCompanies,
       mvarMileage : string;
       mvarActualWork,
       mvarTotalWork : real;
       mvarReminder : TDateTime;
       mvarPostReminder : TDateTime;
       mvarChanged: Boolean;
       procedure setActualWork(const Value: real);
       procedure setTotalWork(const Value: real);
       procedure setSubject(const Value: string);
       procedure setDueDate(const Value: TDate);
       procedure setStartDate(const Value: TDate);
       procedure setStatus(const Value: TaskStatus);
       procedure setPercentCompleted(const Value: integer);
       procedure setImportance(const Value: TaskImportance);
       procedure setCategories(const Value: string);
       procedure setPrivacy(const Value: Boolean);
       procedure setAttachments(const Value: string);
       procedure setDateCompleted(const Value: TDate);
       procedure setBillingInformation(const Value: string);
       procedure setContacts(const Value: string);
       procedure setCompanies(const Value: string);
       procedure setMileage(const Value: string);
       procedure setLastModificationTime(const Value: TDate);
       procedure setReminder(const Value: TDateTime);
     public
       function getProperty(index : TaskCols): string;
       function getPropertyValue(index: TaskCols): variant;
       property SysId : integer read mvarSysId write mvarSysId;
       property DateCreated: TDate read mvarCreationTime write mvarCreationTime;
       property LastModifyDate: TDate read mvarLastModificationTime write setLastModificationTime;
       property Subject : string read mvarSubject write setSubject;
       property DueDate : TDate read mvarDueDate write setDueDate;
       property StartDate: TDate read mvarStartDate write setStartDate;
       property Status: TaskStatus read mvarStatus write setStatus;
       property Importance: TaskImportance read mvarImportance write setImportance;
       property PercentCompleted: integer read mvarPercentCompleted write setPercentCompleted;
       property ReminderDate: TDateTime read mvarReminder write setReminder;
       property PostReminderDate: TDateTime read mvarPostReminder write mvarPostReminder;
       property Attachments : string read mvarAttachments write setAttachments;
       property Categories: string read mvarCategories write setCategories;
       property Privacy : Boolean read mvarPrivacy write setPrivacy;
       property DateCompleted : TDate read mvarDateCompleted write setDateCompleted;
       property ActualWork : real read mvarActualWork write setActualWork;
       property TotalWork : real read mvarTotalWork write setTotalWork;
       property Contacts: string read mvarContacts write setContacts;
       property BillingInformation: string read mvarBillingInformation write setBillingInformation;
       property Companies: string read mvarCompanies write setCompanies;
       property Mileage: string read mvarMileage write setMileage;
       property Changed:Boolean read mvarChanged write mvarChanged;
       procedure PropertyExternalyChanged( tc: TaskCols);
       class function CanSort(tc : TaskCols): boolean;
       class function getCaption( tc : TaskCols): string;
       class function getPropertyCount: integer;
       class function ImportanceName(tim : TaskImportance): string;
       class function StatusName(tst : TaskStatus): string;
       class function PrivacyName(st : boolean): string;
       class procedure getWidth(tc: TaskCols; var wd, maxw, minw: integer);
  end;
  UTaskList = class(UList)
    public
      class function TaskList : TList;
      procedure CloseAll; override;
      class function FindFirst(subj : string): integer; override;
      class function FindNext(subj : string; index: integer): integer; override;
      constructor Create(UpdateProc, DeleteProc:TNotifyEvent; Uid, uiType : integer); override;
      class procedure FreeTaskList;
  end;

  UtaskItem = class;
  UATaskItems = array of UtaskItem;
  UTaskItem = Class
     private
        mvarChanged : Boolean;
        mvarList: TListItem;
        mvarfrmTask : TForm;
        mvarTask : UTask;
        mvarParent : UTaskList;
        procedure UpdateRowCells;
        procedure setListItem(const Value: TListItem);
        procedure setChanged( status : boolean);
     public
        property Parent : UTaskList read mvarParent;
        property Changed : Boolean read mvarChanged write setChanged;
        property Task : UTask read mvarTask write mvarTask;
        property List : TListItem read mvarList write setListItem;
        procedure Edit;
        procedure Save;
        procedure SaveAs;
        procedure Delete;

        class procedure PrintOut(ar : UATaskItems);
        class function Find(id: integer) : UTaskItem;
        constructor Create;
        destructor destroy;override;
        procedure ReleaseForm;
        function  PreviousItem: UTaskItem;
        function  NextItem : UTaskItem;

  end;
  UItemData = class
    public
      ItemCol : TaskCols;
      Caption : string;
      Width : integer;
  end;

var
  mvarTaskItemList: UTaskList;
implementation
uses forTskEd, dmorgnzr, forTskPd, forPrvw ;

procedure UTaskItem.Delete;
begin
  ReleaseForm;
  if Assigned(Parent.OnDelete) then
     Parent.OnDelete(self);
  Parent.List.Remove(self);
  List.Delete;
  Free;
end;

class procedure UTaskItem.PrintOut(ar: UATaskItems);
var
 fpv: TfrmPreview;
 ti : UTaskItem;
 i,li: integer;
 tab : char;
 sout : string;
begin
 if ar = nil then
    exit;
 tab:= chr(9);
 fpv:= TfrmPreview.Create(application);
 with fpv.re do begin
     Lines.Clear;
     for i:= 0 to high(ar) do begin
         ti:= ar[i];
         sout := inttostr(i+1)+' : ';
         if trim(ti.Task.Subject) <> '' then
            sout := sout + ti.Task.Subject;
         SelAttributes.Style := [fsbold];
         Lines.Add(sout);
         SelAttributes.Style := [];
         if trim(ti.Task.Attachments) <> '' then
            Lines.Add(ti.Task.Attachments);
         Lines.Add('');
     end;
     fpv.PrintOut;
 end;
 fpv.free;
// to be implemented
end;

procedure UTaskItem.Save;
begin
  Parent.Update(self);
  if Organizer.TasksPad<> nil then begin
       if List = nil then
          Organizer.TasksPad.Append(self);
       UpdateRowCells;
  end;
end;


procedure UTaskItem.UpdateRowCells;
var
 i: integer;
begin
  for i:= 0 to List.SubItems.Count-1 do
      List.SubItems.Strings[i]:= Task.getProperty(TaskCols(Organizer.TasksPad.lv.Columns[i].tag));

  with TListView(List.ListView) do
     if SortType <> stNone then begin
        SortType := stNone; //force refresh
        SortType := stData;
     end;
end;

procedure UTaskItem.SaveAs;
begin
// to be implemented
end;


procedure UTask.setActualWork(const Value: real);
begin
  mvarActualWork:= Value;
  changed := true;
end;

procedure UTask.setAttachments(const Value: string);
begin
   mvarAttachments:= Value;
   changed:= true;
end;

procedure UTask.setBillingInformation(const Value: string);
begin
  mvarBillingInformation := Value;
  changed:= true;
end;

procedure UTask.setCategories(const Value: string);
begin
  mvarCategories := Value;
  changed:= true;
end;

procedure UTask.setCompanies(const Value: string);
begin
  mvarCompanies:= Value;
  Changed := true;
end;

procedure UTask.setContacts(const Value: string);
begin
  mvarContacts := Value;
  Changed := true;
end;

procedure UTask.setDateCompleted(const Value: TDate);
begin
   mvarDateCompleted := Value;
   Changed := true;
end;

procedure UTask.setDueDate(const Value: TDate);
begin
  mvarDueDate := Value;
  Changed := true;
end;

procedure UTask.setLastModificationTime(const Value: TDate);
  begin
      mvarLastModificationTime := Value;
      Changed := true;
  end;

procedure UTask.setMileage(const Value: string);
  begin
    mvarMileage := Value;
    Changed := true;
  end;

procedure UTask.setPercentCompleted(const Value: integer);
  begin
    mvarPercentCompleted := Value;
    Changed := true;
  end;

procedure UTask.setImportance(const Value: TaskImportance);
  begin
       mvarImportance := Value;
       Changed := true;
  end;

procedure UTask.setPrivacy(const Value: Boolean);
  begin
    mvarPrivacy := Value;
    changed := true;
  end;

procedure UTask.setReminder(const Value: TDateTime);
begin
   mvarReminder:= Value;
   changed := true;
end;

procedure UTask.setStartDate(const Value: TDate);
  begin
    mvarStartDate := Value;
    changed := true;
  end;

procedure UTask.setStatus(const Value: TaskStatus);
begin
 mvarStatus := Value;
 case mvarStatus of
     tsCompleted : PercentCompleted := 100;
     tsNotStarted : PercentCompleted := 0;
 end;
 changed := true;
end;

procedure UTask.setSubject(const Value: string);
  begin
    mvarSubject := Value;
    changed := true;
  end;

procedure UTask.setTotalWork(const Value: real);
  begin
    mvarTotalWork:= Value;
    changed := true;
  end;

procedure UTaskItem.Edit;
var
 f: TfrmEditTask;
begin
    if mvarfrmTask = nil then begin
       f := TfrmEditTask.Create(application);
       f.TaskItem  := self;
       f.Visible   := true;
       mvarfrmTask := f;
    end;
    mvarfrmTask.show;
end;

procedure UTaskItem.setListItem(const Value: TListItem);
var
 i: integer;
begin
     mvarList:= Value;
     mvarList.SubItems.Clear;
     for i:= 0 to TListView(mvarList.listview).Columns.count-1 do
         mvarList.SubItems.add('');
     mvarList.Data := self;
     UpdateRowCells;
     mvarList.ImageIndex := -1; // as nachry
end;

constructor UTaskItem.Create;
begin
   task:= Utask.Create;
   mvarTaskItemList.List.Add(self);
   mvarParent := mvarTaskItemList;
end;

procedure UTaskItem.ReleaseForm;
begin
   if mvarfrmTask <> nil then
      mvarfrmTask.Release;
   mvarfrmTask := nil;
end;

procedure UTaskList.CloseAll;
var
 i: integer;
begin
   for i:=0 to List.Count -1 do
       if UTasKItem(mvarTaskItemList.List[i]).mvarfrmTask <> nil then
          UTasKItem(mvarTaskItemList.List[i]).ReleaseForm;
end;

constructor UTaskList.Create(UpdateProc, DeleteProc:TNotifyEvent; Uid, uiType : Integer);
begin
  mvarTaskItemList := self;
  OnUpdate := UpdateProc;
  OnDelete := DeleteProc;
  List     := TList.Create;
end;

class procedure UTaskList.FreeTaskList;
var
 i: integer;
begin
  for i:=0 to mvarTaskItemList.List.count-1 do
      TObject(mvarTaskItemList.List[0]).destroy;
  FreeAndNil(mvarTaskItemList);
end;

class function UTaskList.FindFirst(subj: string): integer;
var
 i,j: integer;
begin
  result:= -1;
  for j:=0 to mvarTaskItemList.List.Count-1 do
      UTaskItem(mvarTaskItemList.List[j]).List.selected:= false;

  for i:=0 to  mvarTaskItemList.List.Count-1 do
      with UTaskItem(mvarTaskItemList.List[i]) do
        if pos(subj, Task.Subject) > 0 then begin
           List.Selected := true;
           result:= i;
           exit;
        end;
end;

class function UTaskList.FindNext(subj: string; index: integer): integer;
var
 i,j: integer;
begin
  result:= -1;
  for j:=0 to mvarTaskItemList.List.Count-1 do
      UTaskItem(mvarTaskItemList.List[j]).List.selected:= false;
  for i:=index+1 to  mvarTaskItemList.List .Count -1 do
      with mvarTaskItemList do
        if pos(subj, UTaskItem(List[i]).Task.Subject) > 0 then begin
           UTaskItem(List[i]).List.Selected := true;
           result:= i;
           exit;
        end;
end;




function UTaskItem.NextItem: UTaskItem;
begin
 Result:= UTaskItem(Parent.NextItem(self));
end;

function UTaskItem.PreviousItem: UTaskItem;
begin
 Result:= UTaskItem(Parent.PreviousItem(self));
end;

function getDateName(dt:Tdate): string;
begin
  if dt = 0 then
     Result:= ''
  else
     Result:= Organizer.Datename(dt,dnDayMonthYear);
end;

function UTask.getPropertyValue(index: TaskCols): variant;
begin
  case index of
     tcDateCreated   : result := DateCreated;
     tcSubject       : result := Subject;
     tcDueDate       : result := DueDate;
     tcStartDate     : result := StartDate;
     tcLastModifyDate: result := LastModifyDate;
     tcStatus        : result := Status;
     tcImportance    : result := Importance;
     tcPercentCompleted: result := PercentCompleted;
     tcReminderDate  : result := ReminderDate;
     tcAttachments   : result := Attachments ;
     tcCategories    : result := Categories;
     tcPrivacy       :
       if Privacy then
          Result:=1
       else
          Result:=0;
     tcDateCompleted : result := DateCompleted;
     tcActualWork    : result := ActualWork;
     tcTotalWork     : result := TotalWork;
     tcContacts      : result := Contacts;
     tcBillingInformation : result := BillingInformation;
     tcCompanies     : result := Companies;
     tcMileage       : result := Mileage;
  end;
end;

function UTask.getProperty(index: TaskCols): string;
begin
  case index of
     tcDateCreated : result := getDateName(DateCreated);
     tcSubject     : result := Subject;
     tcDueDate     : result := getDateName(DueDate);
     tcStartDate   : result := getDateName(StartDate);
     tcLastModifyDate: result := getDateName(LastModifyDate);
     tcStatus : result := StatusName(Status);
     tcImportance : result := ImportanceName(Importance);
     tcPercentCompleted : result := inttostr(PercentCompleted);
     tcReminderDate : result := getDateName(ReminderDate);
     tcAttachments : result :=Attachments ;
     tcCategories : result := Categories;
     tcPrivacy : result := PrivacyName(Privacy);
     tcDateCompleted : result := getDateName(DateCompleted);
     tcActualWork : result := FloatTostr(ActualWork);
     tcTotalWork : result := FloatTostr(TotalWork);
     tcContacts : result := Contacts;
     tcBillingInformation : result := BillingInformation;
     tcCompanies : result := Companies;
     tcMileage: result := Mileage;
  end;

end;


class function UTask.ImportanceName(tim : TaskImportance): string;
begin
  case Tim of
     prLow    : Result:= '����';
     prNormal : Result:= '���';
     prHigh   : Result:= '����';
  end;
end;

class function UTask.getCaption(tc : TaskCols): string;
begin
  case tc of
     tcDateCreated        : result := '����� �����';
     tcSubject            : result := '�����';
     tcDueDate            : result := '����� ������';
     tcStartDate          : result := '����� ����';
     tcLastModifyDate     : result := '����� �����';
     tcStatus             : result := '�����';
     tcImportance         : result := '�����';
     tcPercentCompleted   : result := '���� �����';
     tcReminderDate       : result := '����� �������';
     tcAttachments        : result := '�����';
     tcCategories         : result := '���� ����';
     tcPrivacy            : result := '����';
     tcDateCompleted      : result := '����� �����';
     tcActualWork         : result := '��� �����';
     tcTotalWork          : result := '�� ���';
     tcContacts           : result := '������';
     tcBillingInformation : result := '������� ��������';
     tcCompanies          : result := '������';
     tcMileage            : result := '�����';
  end;
end;
class function UTask.CanSort(tc : TaskCols): boolean;
begin
  CanSort := true;
  case tc of
      tcCategories: CanSort:= False;
  end;
end;

class function UTask.StatusName(tst : TaskStatus): string;
begin
  case tst of
      tsNotStarted: Result:= '���� ����';
      tsInProgress: Result:= '�� ��� ����';
      tsCompleted : Result:= '����� ��� ';
      tsWaiting   : Result:= '����� ���';
      tsDeferred  : Result:= '����� ���';
  end;
end;

class function UTask.PrivacyName(st : Boolean): string;
begin
  if st then
     Result:= '����'
  else
     Result:='';
end;


class function UTask.getPropertyCount: integer;
begin
   Result:= ord(tcLastElement);
end;

procedure UTaskItem.setChanged(status: boolean);
begin
  mvarChanged := true;
  if mvarfrmTask <> nil then
     with TfrmEditTask(mvarfrmTask) do begin
         txtCategories.text:= Task.Categories;
         cboStatus.ItemIndex := integer(Task.Status);
         case Task.Status of
             tsCompleted : txtCompletedPercent.text:='100';
             tsNotStarted : txtCompletedPercent.text:='';
         end;

     end;
end;

class procedure UTask.getWidth(tc: TaskCols; var wd, maxw, minw: integer);
begin
   maxw:=-1;
   minw:= 16;
   wd:=-1;
   case tc of
      tcSubject : wd:= 300;
      tcDateCreated,
      tcDueDate,
      tcStartDate,
      tcLastModifyDate,
      tcDateCompleted,
      tcReminderDate :
                  begin
                     maxw := 120;
                     wd   := 120;
                  end;
      tcImportance :
                  begin
                     maxw := 45;
                     wd   := 45;
                  end;
      tcStatus :
                  begin
                     maxw := 200;
                     wd   := 45;
                  end;

      tcPercentCompleted:
                  begin
                     maxw := 50;
                     wd   := 50;
                  end;
      tcPrivacy:
                  begin
                     maxw := 50;
                     wd   := 50;
                  end;

      tcActualWork, tcTotalWork :
                  begin
                     maxw := 50;
                     wd   := 50;
                  end;

end;
end;

procedure UTask.PropertyExternalyChanged(tc: TaskCols);
begin
//   case tc of
//   end;
end;

class function UTaskItem.Find(id: integer): UTaskItem;
var
i: integer;
begin
 Result:= nil;
 if mvarTaskItemList = nil then
    exit;
 for i:=0 to mvarTaskItemList.List.count-1 do
     if UTaskItem(mvarTaskItemList.List[i]).Task.SysId = id then begin
        Result:= UTaskItem(mvarTaskItemList.List[i]);
        exit;
     end;
end;

class function UTaskList.TaskList: TList;
begin
  Result:= mvarTaskItemList.List;
end;

destructor UTaskItem.destroy;
begin
  ReleaseForm;
  Parent.List.Remove(self);
  Task.free;
  inherited;
end;

end.
