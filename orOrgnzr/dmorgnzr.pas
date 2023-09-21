unit dmorgnzr;

interface
uses
  windows, SysUtils, Classes,  Forms, Controls, ImgList, Db, DBTables, forTskPd,
  ExtCtrls, uorTask, uorCalnd,forCalnd, dialogs, stdCtrls, FCal, FDatePicker, math, uorNItem,
  comctrls, ADODB;

const
  AppIdType_Resource = 1 ;
  AppIdType_User = 2 ;
  AppIdType_ManComp = 3 ;
var
  mvarUserId : longint;
type
  TdmOrganizer = class(TDataModule)
    imgNotes: TImageList;
    imgTasks: TImageList;
    spCategory_Select: TStoredProc;
    spCategory_Delete: TStoredProc;
    tmrReminder: TTimer;
    spDefaults_getSet: TStoredProc;
    spAppointments_SelectMeeting: TStoredProc;
    spNotes_insert: TStoredProc;
    spNotes_Update: TStoredProc;
    spNotes_Delete: TStoredProc;
    spNotes_Select: TStoredProc;
    spTask_insert: TStoredProc;
    spTask_Update: TStoredProc;
    spTask_Delete: TStoredProc;
    spTask_Select: TStoredProc;
    spTask_Select_BySysId: TStoredProc;
    spTaskColumn_Select: TStoredProc;
    spTaskColumn_Delete: TStoredProc;
    spTaskColumn_Insert: TStoredProc;
    spEvents_Insert: TStoredProc;
    spEvents_Update: TStoredProc;
    spEvents_Delete: TStoredProc;
    spEvents_Select: TStoredProc;
    spCategory_Delete1: TStoredProc;
    spCategory_Insert: TStoredProc;
    spAppointments_Insert: TStoredProc;
    spAppointments_Update: TStoredProc;
    spAppointments_Delete: TStoredProc;
    spAppointments_Select: TStoredProc;
    spAppointments_Select_BySysId: TStoredProc;
    spRecurrence_insert: TStoredProc;
    spRecurrence_Delete: TStoredProc;
    spRecurrence_Update: TStoredProc;
    spRecurrence_Select: TStoredProc;
    spAppointment_DeleteMeeting: TStoredProc;
    spNames_Select: TStoredProc;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure tmrReminderTimer(Sender: TObject);
  private
       mvarShamsiDate : boolean;
       mvarWorkingStartHour, mvarWorkingEndHour : TdateTime;
       mvarNotesPad : TFORM;
       mvarTasksPad : TfrmTaskPad;
       mvarCalendarPad : TfrmCalendar;
       mvarCal : TCal;
       mvarHoliday : array [1..7] of boolean;
       procedure UpdateNote(S: TObject);
       procedure DeleteNote(S: TObject);

       procedure NotesPadClosed(S: TObject);
       procedure UpdateTask(S: TObject);
       procedure DeleteTask(S: TObject);
       procedure TasksPadClosed(S: TObject);
       procedure CalendarPadClosed(S: TObject);
       function CreateTaskItem(id: integer): UTaskItem;

       procedure UpdateAppointment(S: TObject);
       procedure DeleteAppointment(S: TObject);
       function CreateAppointmentItem(id: integer): UAppointmentItem;
       function getHoliday( day : integer) : boolean;
       procedure setHoliday( day : integer; hol : boolean);
       procedure CreateTaskList;
       procedure CreateNotesList;
       procedure CreateTaskPad;
  public
       procedure TasksPadColumnsUpdate(S: TObject);
       procedure UpdateRecurrence(Rec : UReccPattern);
       function  Category_Select: TDataSet;
       procedure Category_Insert;
       procedure WriteDefaults;
       property ShamsiDate : boolean read mvarShamsiDate write mvarShamsiDate;
       procedure ShowNotePad;
       function getNames(Value : integer): TDataSet;
       property WorkingStartHour : TdateTime read mvarWorkingStartHour write mvarWorkingStartHour;
       property WorkingEndHour : TdateTime   read mvarWorkingEndHour   write mvarWorkingEndHour;
       property Holidays[day : integer]: boolean read getHoliday       write setHoliday;
       function  CountHolidays(dtStart_S, dtEnd_S: String; var Weekly, Events : integer): integer;
       function Datename(dt : TdateTime; fmt: TDateNameFormat): string;
       procedure InitHolidays( Obj : TObject);
       function Shamsi( dt: TDateTime) : string;
       function Miladi( sdt: string) : TDateTime;
       function isHoliday(dt : TdateTime): boolean;
       function GetRecurrPat(id : integer): UReccPattern;
       function ValueOfString(s: string): real;
       procedure generateTimeFrom(cbo: TComboBox; dt : TdateTime);
       procedure ReadAppointments(uid, idType : integer);
       property NotesPad : TForm read mvarNotesPad write mvarNotesPad;
       procedure ShowTaskPad;
       procedure ShowCalendarPad;
       property  TasksPad : TfrmTaskPad read mvarTasksPad write mvarTasksPad;
       property  CalendarPad : TfrmCalendar read mvarCalendarPad write mvarCalendarPad;
       procedure AddToCategory(Name: string; Status: integer);
       procedure DelCategory(Name: string);
       procedure ResetCategory();
       function getTime(stTime: string; var st: string): boolean; //used in appedit and taskedit
       function getEvents( dtFrom, dtTo : TDateTime) : TList;
       procedure EventUpdate(S : Tobject);
       procedure EventDelete(S : TObject);
       procedure DeleteRecurrence(rec : UReccPattern);
       procedure DeleteMeeting(id : longint);
       function getAttendies(id : longint): TList;
end;


var
 Organizer : TdmOrganizer;
implementation
{$R *.DFM}
uses forRmnd, forEvent, forNotesPad, uorNote, forNetMt;
var
  mvarlastQuery : TdateTime;

function TdmOrganizer.getHoliday( day : integer) : boolean;
begin
   Result:=mvarHoliday[day];
end;

procedure TdmOrganizer.setHoliday( day : integer; hol : boolean);
begin
 mvarHoliday[day]:= hol;
end;

var
  //mvarUserId: Integer;
  mvarInTimer: boolean;

function TdmOrganizer.getTime(stTime: string; var st: string): boolean;
var
 dt: TDateTime;
 base : integer;
 mor, aft, rep: string;
 txt : string;
begin
  txt:= trim(stTime);
  if txt = '' then
     txt := '00:00';
  if txt[Length(txt)] = ':' then
     txt:= txt+ '00';
  if txt = '' then
     txt := '12';
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


procedure TdmOrganizer.DeleteTask(S: TObject);
  begin
     with UTaskItem(S).Task  do begin
          spTask_Delete.ParambyName('@SysId').Asinteger := SysId;
          spTask_Delete.ExecProc;
     end;
  end;

procedure TdmOrganizer.DataModuleCreate(Sender: TObject);
var
 hol : integer;
 i: integer;
begin

 ShamsiDate := true;
 mvarCal := TCal.Create(self);
 TasksPad := nil;
 UTaskList.Create(UpdateTask, DeleteTask, mvarUserId,0);
 UNoteItems.Notescreate;
 CreateNotesList;
 CreateTaskList;;

 mvarAppList := UAppList.Create(UpdateAppointment , DeleteAppointment);
 ReadAppointments(mvarUserId,AppIdType_User);

 mvarlastQuery := time;

 with spDefaults_getSet do begin
      ParamByName('@opCode').Value :=0;
      ExecProc;
      Hol := Parambyname('@wend').asinteger;
      for i:=1 to 7 do
          if Hol and trunc(power(2,i-1)) > 0 then
             Holidays[i]:= true;
      WorkingStartHour := Parambyname('@hrFrom').asDateTime;
      WorkingENdHour   := Parambyname('@hrTo').asDateTime;
 end;
 tmrReminder.Enabled := true;

   if not spNotes_insert.Prepared then
      spNotes_insert.Prepare;

   if not spNotes_Update.Prepared then
      spNotes_Update.Prepare;

   if not spNotes_Delete.Prepared then
      spNotes_Delete.Prepare;

   if not spNotes_Select.Prepared then
      spNotes_Select.Prepare;

end;

procedure TdmOrganizer.DataModuleDestroy(Sender: TObject);
begin
 tmrReminder.Enabled := false;
 mvarCal.free;
 if NotesPad <> nil then begin
    NotesPad.Close;
    NotesPad.Free;
 end;
 if TasksPad <> nil then begin
    TasksPad.Close;
    TasksPad.Free;
 end;
 mvarNoteItems.destroy;
 UTaskList.FreeTaskList;
 mvarAppList.free;
 Organizer := nil
end;

procedure TdmOrganizer.NotesPadClosed(S: TObject);
begin
  NotesPad := nil;
end;

procedure TdmOrganizer.TasksPadColumnsUpdate(S: TObject);
var
  i:integer;
begin
  spTaskColumn_Delete.ParamByName('@UserId').asinteger := mvarUserId;
  spTaskColumn_Delete.ExecProc;
  for i:= 1 to TasksPad.lv.Columns.count-1 do
      with spTaskColumn_Insert do begin
           ParamByName('@UserId').Value := mvarUserId;
           ParamByName('@ColumnId').Value := TasksPad.lv.Columns[i].Tag;
           ParamByName('@RowNo').Value := i;
           ExecProc;
   end;
end;


procedure TdmOrganizer.TasksPadClosed(S: TObject);
begin
  TasksPad.Release();
  TasksPad := nil;
end;

procedure TdmOrganizer.ShowTaskPad;
begin
  If CalendarPad <> nil then
     CalendarPad.Close;
  if TasksPad = nil then
     CreateTaskPad;
  TasksPad.Show;
end;

procedure TdmOrganizer.CreateTaskPad;
var
 i: integer;
begin
  TasksPad         := TfrmTaskPad.Create(application);
  TasksPad.OnClose :=  TasksPadClosed;
  with spTaskColumn_Select do begin   // Reading Task Columns
       ParamByName('@UserId').Value := mvarUserId;
       Open;
       if not eof then
          while not eof do begin
                TasksPad.AddColumn(TaskCols(FieldByName('ColumnId').asinteger), -1 ,
                                                      ColumnHeaderWidth);
                Next;
          end
       else begin
            TasksPad.AddColumn(tcSubject,-1 , ColumnHeaderWidth);
            TasksPad.AddColumn(tcStartDate,-1, ColumnHeaderWidth);
            TasksPad.AddColumn(tcImportance,-1, ColumnHeaderWidth);
       end;
       Close;
   end;
   for i:=0 to UTaskList.TaskList.Count-1 do
       TasksPad.Append(UTaskList.TaskList[i]);
end;

procedure TdmOrganizer.UpdateTask(S: TObject);
  var
    sp: TStoredProc;
  begin
    with UTaskItem(S).Task, sp do begin
         if SysId <> 0 then
            sp := spTask_Update
         else begin
            sp := spTask_insert;
            ParamByName('@UserId').Value   := mvarUserId;
         end;
         ParamByName('@SysId').Value              := SysId;
         ParamByName('@Subject').Value            := Subject;
         ParamByName('@DueDate').Value            := DueDate;
         ParamByName('@StartDate').Value          := StartDate;
         ParamByName('@Status').Value             := Status;
         ParamByName('@Importance').Value         := Importance;
         ParamByName('@PercentCompleted').Value   := PercentCompleted;
         ParamByName('@PostReminderDate').Value   := PostReminderDate;
         ParamByName('@ReminderDate').Value       := ReminderDate;
         ParamByName('@Attachments').Value        := Attachments;
         ParamByName('@Categories').Value         := Categories;
         if Privacy then
            ParamByName('@Privacy').Value            := 1
         else
            ParamByName('@Privacy').Value            := 0;
         ParamByName('@DateCompleted').Value      := DateCompleted;
         ParamByName('@ActualWork').Value         := ActualWork;
         ParamByName('@TotalWork').Value          := TotalWork;
         ParamByName('@Contacts').Value           := Contacts;
         ParamByName('@BillingInformation').Value := BillingInformation;
         ParamByName('@Companies').Value          := Companies;
         ParamByName('@Mileage').Value            := Mileage;
         sp.ExecProc;
         LastModifyDate := ParamByName('@LastModifyDate').AsDate;
         if SysId = 0 then begin
            DateCreated    := ParamByName('@CreationDate').AsDate;
            SysId          := ParamByName('@Sysid').AsInteger;
         end;
   end;
 end;

procedure TdmOrganizer.AddToCategory(Name: string; Status: integer);
begin
  spCategory_Insert.ParamByName('@Name').Value:= Name;
  spCategory_Insert.ParamByName('@Status').Value:= Status;
  spCategory_Insert.ParamByName('@UserId').AsInteger := mvarUserId;
  spCategory_Insert.ExecProc;
end;

procedure TdmOrganizer.DelCategory(Name: string);
begin
    spCategory_Delete.ParamByName('@PName').Value := Name;
    spCategory_Delete.ParamByName('@UserId').Value := mvarUserId;
    spCategory_Delete.execProc;
end;

procedure TdmOrganizer.ResetCategory;
begin
    spCategory_Delete1.ParamByName('@UserId').Value:= mvarUserId;
    spCategory_Delete1.Execproc;
end;

procedure TdmOrganizer.ReadAppointments(uid, idType : integer);
begin
   with spAppointments_Select do begin
        ParamByName('@UserId').Value := uid;
        ParamByName('@IdType').Value := idType;
        ParamByName('@StartDate').Value := 0;
        ParamByName('@EndDate').Value   := Date() + 1000;// 3 years later
        Open;
        mvarAppList.DelList(uid, idType);
        mvarAppList.NewList(uid, idType);
        mvarAppList.setList(uid, idType);
        while not Eof do begin
              CreateAppointmentItem(FieldbyName('SysId').asinteger);
              Next;
        end;
        Close;
   end;
end;

procedure TdmOrganizer.tmrReminderTimer(Sender: TObject);
var
 f: TfrmRemind;
 t1,t2: TSystemTime;
 i, res : integer;
 ti : UTaskItem;
 List : TList;
 sid : integer;
begin
   if mvarInTimer then
      exit;
   mvarInTimer:=true;
   with UTaskList do
        for i:=0 to TaskList.Count -1 do begin
           ti :=UTaskItem(TaskList[i]);
           if (ti.Task.ReminderDate = 0) or                   // no reminder at all or
              (ti.Task.PostReminderDate = 0) or               // reminder but ingnored
                 (now() - ti.Task.PostReminderDate > 14)  or // more than one two weeks ago
                 (now() < ti.Task.PostReminderDate) then     // time not reached
              continue;
           f:= TfrmRemind.Create(application);
           f.lblSubject.Caption := ti.task.Subject;
           res :=f.showmodal;
           case res of
                10 : begin         // don't remind again
                        ti.Task.PostReminderDate :=0;
                        ti.Save;
                       end;
                20 :               // postpone
                     begin
                        ti.Task.PostReminderDate := now()+(f.Delay * 60)/ SecsPerDay;
                        ti.Save;
                       end;
                30 : begin       // open
                        ti.Task.ReminderDate :=0;
                        ti.Save;
                        ti.edit;
                     end;
           end;
           f.free;
  end;
  if CalendarPad = nil then begin
     mvarInTimer:= False;
     exit;
  end;
  mvarInTimer:= False;
  exit;
  List := mvarAppList.getList;
  for i:= 0 to List.Count-1 do
     with UAppointmentItem(List[i]) do begin
          DateTimeToSystemTime(Appointment.ReminderTime, t1);
          DateTimeToSystemTime(now(), t2);
          if (t1.wYear = t2.wyear) and (t1.wMonth  = t2.wmonth) and
             (t1.wday = t2.wday) and   (t1.wHour  = t2.wHour) and
                                       (t1.wMinute   = t2.wMinute) then
              if not mvarInTimer then begin
                 mvarInTimer:=true;
                 sid:= Appointment.SysId;
                 f:= TfrmRemind.Create(application);
                 f.lblSubject.Caption := Appointment.Subject;
                 tmrReminder.Enabled := false;
                 case f.showmodal of
                    10 : begin         // don't remind again
                            Appointment.ReminderTime :=0;
                            Save;
                         end;
                    20 : begin         // postpone
                            Appointment.ReminderTime:= Appointment.ReminderTime + (f.Delay * 60)/ SecsPerDay;
                            Save;
                         end;
                    30 : begin       // open
                            Appointment.ReminderTime :=0;
                            Save;
                            Edit(Appointment.ReminderTime);
                         end;
                 end;
                 f.free;
                 mvarInTimer:= False;
                 tmrReminder.Enabled := true;
              end else
                 if sid <> Appointment.Sysid then begin
                    Appointment.ReminderTime:= Appointment.ReminderTime + 1 / 1440;
                    Save;
                 end;

      end;
      mvarInTimer:= False;
end;

function TdmOrganizer.CreateAppointmentItem(id: integer): UAppointmentItem;
begin
   Result:= nil;
   with spAppointments_Select_BySysId   do begin
        ParamByName('@SysId').Value := id;
        Open;
        if eof then begin
           close;
           exit;
        end;
        Result:= UAppointmentItem.Create;
        with Result.Appointment do begin
           SysId              := id;
           Subject            := FieldByName('Subject').AsString;
           Location           := FieldByName('Location').AsString;
           StartTime          := FieldByName('StartTime').AsDateTime;
           EndTime            := FieldByName('EndTime').AsDateTime;
           AppType            := CalAppType(FieldByName('AppType').AsInteger);
           ReminderTime       := FieldByName('ReminderTime').AsDateTime;
           Attachments        := FieldByName('Attachments').asString;
           Categories         := FieldByName('Categories').Asstring;
           Privacy            := FieldByName('Privacy').Asinteger <> 0;
           AllDayEvent        := FieldByName('AllDayEvent').asinteger <>0 ;
           UserId             := FieldByName('UserId').asinteger;
           IdType             := FieldByName('IdType').asinteger;
           MeetingId          := FieldByName('MeetingId').asinteger;
           RequiredInMeeting  := FieldByName('RequiredInMeeting').asinteger=1;
           if FieldByName('RecurrenceId').asinteger <> 0 then
              Recurrence := GetRecurrPat(FieldByName('RecurrenceId').asinteger)
           else
              Recurrence := nil;
           close;
        end;
    end;
end;

function TdmOrganizer.CreateTaskItem(id: integer): UTaskItem;
begin
    Result:= nil;
    with spTask_Select_BySysId do begin
         ParamByName('@SysId').Value := id;
         Open;
         if eof then begin
            close;
            exit;
         end;
         Result:= UTaskItem.Create;
         with Result.task do begin
           SysId              := id;
           DateCreated        := FieldByName('CreationDate').AsDateTime;
           LastModifyDate     := FieldByName('LastModifyDate').AsDateTime;
           Subject            := FieldByName('TaskSubject').AsString ;
           DueDate            := FieldByName('DueDate').AsDateTime;
           StartDate          := FieldByName('StartDate').AsDateTime;
           Status             := TaskStatus(FieldByName('Status').AsInteger);
           Importance         := TaskImportance(FieldByName('Importance').asinteger);
           PercentCompleted   := FieldByName('PercentCompleted').AsInteger;
           ReminderDate       := FieldByName('ReminderDate').AsDateTime;
           PostReminderDate   := FieldByName('PostReminderDate').AsDateTime;
           Attachments        := FieldByName('Attachments').asstring;
           Categories         := FieldByName('Categories').Asstring;
           Privacy            := FieldByName('Privacy').Asinteger <> 0;
           DateCompleted      := FieldByName('DateCompleted').AsDateTime;
           ActualWork         := FieldByName('ActualWork').AsFloat;
           TotalWork          := FieldByName('TotalWork').AsFloat;
           Contacts           := FieldByName('Contacts').Asstring;
           BillingInformation := FieldByName('BillingInformation').Asstring;
           Companies          := FieldByName('Companies').Asstring;
           Mileage            := FieldByName('Mileage').Asstring;
        end;
        Close;
    end;
end;


procedure TdmOrganizer.DeleteAppointment(S: TObject);
begin
     with UAppointmentItem(S).Appointment do begin
          if Recurrence <> nil then
             Recurrence.Delete;
          spAppointments_Delete.ParamByName('@SysId').Value := SysId;
          spAppointments_Delete.ParamByName('@IdType').Value := IdType ;
          spAppointments_Delete.ExecProc;
     end;
end;

procedure TdmOrganizer.UpdateAppointment(S: TObject);
  var
    sp : TStoredProc;
  begin
    with UAppointmentItem(S).Appointment,sp do begin
        if SysId = 0 then begin
           sp := spAppointments_Insert;
           if UserId = 0 then
              UserId:= mvarUserId;
        end else
           sp:= spAppointments_Update;
       ParamByName('@IdType').Value := IdType;
       ParamByName('@UserId').Value := UserId;
       ParamByName('@SysId').Value := SysId;
       ParamByName('@Subject').Value        := Subject;
       ParamByName('@Location').Value       := Location;
       if EndTime <= StartTime then
          EndTime := StartTime+1/86400;
       ParamByName('@StartTime').Value      := StartTime;
       ParamByName('@EndTime').Value        := EndTime;
       ParamByName('@AppType').Value        := ord(AppType);
       ParamByName('@ReminderTime').Value   := ReminderTime;
       ParamByName('@Attachments').Value    := Attachments;
       ParamByName('@Categories').Value     := Categories;
       if Recurrence <> nil then
          ParamByName('@RecurrenceId').Value   := Recurrence.Id
       else
          ParamByName('@RecurrenceId').Value   :=0;

       if Privacy then
          ParamByName('@Privacy').Value     := 1
       else
          ParamByName('@Privacy').Value     := 0;

       if AllDayEvent then
          ParamByName('@AllDayEvent').Value     := 1
       else
          ParamByName('@AllDayEvent').Value     := 0;
       if RequiredInMeeting then
          ParamByName('@RequiredInMeeting').Value :=  1
       else
          ParamByName('@RequiredInMeeting').Value :=  0;

       ParamByName('@MeetingId').Value :=  MeetingId;
       Execproc;
       if SysId=0 then
          SysId := ParamByName('@SysId').Value;
   end;
end;


function TdmOrganizer.getEvents(dtFrom, dtTo: TDateTime): TList;
var
 li : TList;
 ev : UEvents;
 attr : integer;
begin
   Li := TList.Create;
   with spEvents_Select do begin
        ParamByName('@FD').Value := dtFrom;
        ParamByName('@TD').Value := dtTo;
        Open;
        while not Eof do begin
           ev := UEvents.Create;
           ev.SysID := FieldByName('SysId').AsInteger;
           ev.Description := FieldByName('Description').AsString;
           ev.EventDate := FieldByName('EventDate').AsDateTime;
           attr := FieldByName('Attributes').AsInteger;
           if (1 and attr) <> 0 then
              ev.Event:= ev.Event + [uenHoliday];
           if (2 and attr) <> 0 then
              ev.Event:= ev.Event + [uenBirth];
           if (4 and attr) <> 0 then
              ev.Event:= ev.Event + [uenDie];
           Li.Add(ev);
           next;
        end;
        Close;
   end;
   Result:= Li;
end;

procedure TdmOrganizer.EventDelete(S: Tobject);
begin
  With spEvents_Delete, UEvents(S) do begin
       ParamByName('@SysId').Value := SysId;
       ExecProc;
  end;
end;

procedure TdmOrganizer.EventUpdate(S: Tobject);
var
    sp : TStoredProc;
    attr : integer;
begin

 with UEvents(S), sp do begin
      if SysId = 0  then
         sp := spEvents_Insert
      else
         sp:= spEvents_Update;
      ParamByName('@Description').Value := Description;
      ParamByName('@EventDate').Value := EventDate;
      ParamByName('@SysId').Value := SysId;
      attr :=0;
      if uenHoliday in Event then
         attr := attr or 1;
      if uenBirth in Event then
         attr := attr or 2;
      if uenDie in Event then
         attr := attr or 4;
      ParamByName('@Attributes').Value := attr;
      try
         Execproc;
         if SysId=0  then
            SysId:= ParamByName('@SysId').Value;
      except
           showmessage('œ— À»   «—Œ «Ì‰ „‰«”»  „‘ﬂ· ÊÃÊœ œ«—œ');
      end;
    end;
end;
procedure TdmOrganizer.generateTimeFrom(cbo: TComboBox; dt : TdateTime);
var
  i, h: integer;
  tmp, s,st: string;
begin
   tmp:= cbo.Text;
   cbo.Clear;
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
         if Organizer.getTime(s, st) then
            if StrToTime(st) > dt then
               cbo.items.add(s);
   end;
   cbo.Text := tmp;
end;

function TdmOrganizer.GetRecurrPat(id : integer):UReccPattern;
var
  rp : UReccPattern;
begin
   with spRecurrence_Select  do begin
        ParamByName('@RecId').Value := id;
        Open;
        if eof then begin
           Close;
           Result:= nil;
           exit;
        end;

        case FieldByName('Type').Value of
             ord(rbDaily)   : rp := UReccDaily.Create;
             ord(rbWeekly)  : rp := UReccWeekly.Create;
             ord(rbMonthly) : rp:=  UReccMonthly.Create;
        end;
        rp.Id := id;
        rp.StartHour := FieldByName('StartHour').AsDateTime;
        rp.StartDate := FieldByName('StartDate').AsDateTime;
        rp.EndDate   := FieldByName('EndDate').AsDateTime;
        rp.Duration  := FieldByName('Duration').AsFloat;
        rp.After_N_Ocuur := FieldByName('Times').Asinteger;
        case rp.RecurrenceType  of
             rbDaily   : with UReccDaily(rp) do  begin
                           Every_N_Days := FieldByName('Attr1').asinteger;
                           EveryWeekDay := FieldByName('Attr2').asinteger <> 0;
                         end;
             rbWeekly  :
                         with UReccWeekly(rp) do  begin
                           Every_N_Weeks  := FieldByName('Attr1').asinteger;
                           WeekDays       := FieldByName('Attr2').asinteger;
                         end;
             rbMonthly : with UReccMonthly(rp) do  begin
                           DayOfMonth  := FieldByName('Attr1').asinteger;
                           EveryNMonth := FieldByName('Attr2').asinteger;
                           WeekDay     := FieldByName('Attr3').asinteger;
                           MonthWeek   := FieldByName('Attr4').asinteger;
                         end;
         end;
         Result:= rp;
         Close;
   end;
end;

function TdmOrganizer.ValueOfString(s: string): real;
begin
  try
     Result:= StrTOFloat(s);
  except
     on e: exception do Result:=0;
  end;
end;

procedure TdmOrganizer.UpdateRecurrence(Rec : UReccPattern);
var
  sp : TStoredProc;
begin
   with  sp do begin
      if Rec.Id = 0 then
         sp := spRecurrence_insert
      else
         sp := spRecurrence_Update;
        ParamByName('@RecId').Value := Rec.Id;
        ParamByName('@Type').Value :=  Rec.RecurrenceType;
        ParamByName('@StartHour').Value := Rec.StartHour;
        ParamByName('@StartDate').Value := Rec.StartDate;
        ParamByName('@EndDate').Value := Rec.EndDate;
        ParamByName('@Duration').Value := Rec.Duration;
        ParamByName('@Times').Value := Rec.After_N_Ocuur;
        ParamByName('@Attr3').Value := 0;
        ParamByName('@Attr4').Value := 0;

        case rec.RecurrenceType of
           rbDaily : with UReccDaily(Rec) do begin
                         ParamByName('@Attr1').Value := Every_N_Days;
                         ParamByName('@Attr2').Value := EveryWeekDay;
                     end;
           rbWeekly : with UReccWeekly(Rec) do begin
                         ParamByName('@Attr1').Value := Every_N_Weeks ;
                         ParamByName('@Attr2').Value := WeekDays;
                      end;
           rbMonthly :with UReccMonthly(Rec) do begin
                         ParamByName('@Attr1').Value := DayOfMonth ;
                         ParamByName('@Attr2').Value := EveryNMonth ;
                         ParamByName('@Attr3').Value := WeekDay;
                         ParamByName('@Attr4').Value := MonthWeek;
                      end;
        end;
        ExecProc;
        if Rec.Id = 0 then
           Rec.Id := ParamByName('@RecId').Value;
   end;
end;

procedure TdmOrganizer.DeleteRecurrence(rec: UReccPattern);
begin
  spRecurrence_Delete.ParamByName('@RecId').Value := Rec.id;
  spRecurrence_Delete.ExecProc;
end;

function TdmOrganizer.Shamsi(dt: TDateTime): string;
begin
  Result:=mvarCal.Shamsi(dt);
end;

function TdmOrganizer.Miladi(sdt: string): TDateTime;
begin
   Result:= mvarCal.Miladi(sdt);
end;

procedure TdmOrganizer.InitHolidays(Obj: TObject);
var
 i: integer;
begin
  for i:= 1 to 7 do
     if obj.ClassType = Tcal then begin
        TCal(obj).Holiday[i]:= Organizer.Holidays[i];
        TCal(obj).ShamsiDate := ShamsiDate;
     end
     else if obj.ClassType = TFDatePicker then begin
        TFdatePicker(obj).Holiday[i]:= Organizer.Holidays[i] ;
        TFdatePicker(obj).ShamsiDate := ShamsiDate;
     end;

end;

function TdmOrganizer.Datename(dt: TdateTime;
  fmt: TDateNameFormat): string;
begin
  Result:=mvarCal.DateName(dt, fmt);
end;

function TdmOrganizer.CountHolidays(dtStart_S, dtEnd_S: String; var Weekly,
  Events: integer): integer;
var
 Li : TList;
 i, commons : integer;
 dtStart, dtEnd : TdateTime;
begin
 dtStart := mvarCal.Miladi(dtStart_S);
 dtEnd   := mvarCal.Miladi(dtEnd_S);
 commons :=0;
 Weekly  :=0;
 Events  :=0;
 Li := getEvents(dtStart, dtEnd);
 for i:=0 to Li.Count-1 do
    With UEvents(Li[i]) do
       if IsHoliday() then begin
          inc(Events);
          if Holidays[DayOfWeek(EventDate) mod 7 + 1] then
             inc(commons);
       end;
 while dtStart <= dtEnd do begin
    if Holidays[DayOfWeek(dtStart) mod 7 + 1] then
       inc(Weekly);
    dtStart :=dtStart +1;
 end;
 Result:= Weekly + Events - Commons;
end;

procedure TdmOrganizer.ShowCalendarPad;
begin
 CalendarPad := TfrmCalendar.Create(Application);
 if TasksPad = nil then
    CreateTaskPad;
 with TasksPad do begin
      TasksPad.Parent := CalendarPad.pnlTasks;
      BorderStyle := bsNone;
      Panel1.Visible := false;
      StatusBar1.Visible:= false;
      align := alClient;
      update;
      Visible:= true;
  end;
  CalendarPad.onClose := CalendarPadClosed;
  CalendarPad.Show;
end;

procedure TdmOrganizer.CalendarPadClosed(S: TObject);
begin
  TasksPadClosed(S);
  CalendarPad:= nil;
end;


function TdmOrganizer.isHoliday(dt: TdateTime): boolean;
begin
 Result:= Holidays[dayofweek(dt) mod 7 +1]; 
end;

procedure TdmOrganizer.WriteDefaults;
var
 i, Hol : integer;
begin
 Hol := 0;
 for i:=1 to 7 do
    if Holidays[i] then
       Hol := Hol or trunc(power(2,i-1));
 with spDefaults_getSet  do begin
      ParamByName('@opCode').Value :=1; // set values
      ParamByName('@wend').Value   := Hol;
      ParamByName('@hrFrom').Value := WorkingStartHour ;
      ParamByName('@hrTo').Value   := WorkingEndHour;
      ExecProc;
      WorkingStartHour := Parambyname('@hrFrom').asDateTime;
      WorkingENdHour   := Parambyname('@hrTo').asDateTime;
 end;
end;

function TdmOrganizer.getNames(Value: integer): TDataSet;
begin
  spNames_Select.ParamByName('@NameType').Value := Value;
  spNames_Select.Open;
  Result:= spNames_Select ;
end;
//////////////////////////////////////////////////////////////////////
//////////////
procedure TdmOrganizer.ShowNotePad;
var
   i: integer;
begin
   if NotesPad <> nil then begin
      NotesPad.Show;
      exit;
   end;
   NotesPad:= TfrmNotesPad.Create(application);
   with TfrmNotesPad(NotesPad) do
   begin
        OnUpdate := UPdateNote;
        OnDelete := DeleteNote;
        OnClose  := NotesPadClosed;
   end;
   with UNoteItems  do
        for i:=0 to NotesList.count-1 do
            TfrmNotesPad(NotesPad).AttachTo(NotesList[i]);
    NotesPad.Show;
end;

procedure TdmOrganizer.DeleteNote(S: TObject);
  begin
     with UNote(S) do begin
          spNotes_Delete.ParamByName('@SysId').Value:= SysId;
          spNotes_Delete.ExecProc;
     end;
  end;

procedure TdmOrganizer.UpdateNote(S: TObject);
  var
    sp : TStoredProc;
  begin
    with UNote(S), sp do begin
        if SysId <> 0 then
           sp := spNotes_Update
        else begin
           sp := spNotes_insert;
           ParamByName('@UserId').Value   := mvarUserId;
        end;

        if Visible then
           ParamByName('@Hidden').Value  := 0
        else
           ParamByName('@Hidden').Value  := 1;
        ParamByName('@SysId').Value   := SysId;
        ParamByName('@Contents').Value := Contents;
        ParamByName('@Color').Value    := Color;
        ParamByName('@xPosition').Value:= position.x;
        ParamByName('@yPosition').Value:= position.y;
        ParamByName('@Category').Value := Categories;
        ExecProc;
        if SysId = 0 then begin
           SysId       := sp.ParamByName('@SysId').asinteger;
           DateCreated := sp.ParamByName('@CreationDate').AsDate;
        end;
   end;
  end;

procedure TdmOrganizer.DeleteMeeting(id: Integer);
begin
   spAppointment_DeleteMeeting.ParamByName('@MeetingId').Value := id;
   spAppointment_DeleteMeeting.ExecProc;
end;

function TdmOrganizer.getAttendies(id: Integer): TList;
var
 lst : TList;
 un : uAppMeeting;
begin
   lst := nil;

   with spAppointments_SelectMeeting  do begin
        ParamByName('@mid').Value := id;
        open;
        lst:= TList.Create;
        while not eof do begin
              un:= UAppMeeting.Create;
              un.Id:= FieldByName('UserId').asinteger;
              un.NameType:= FieldByName('IdType').asinteger;
              un.Required := (FieldByName('RequiredInMeeting').asinteger = 1);
              un.Text := FieldByName('Name').asstring;
              lst.Add(un);
              next;
        end;
        Close;
   end;
   Result:= lst;
end;

function TdmOrganizer.Category_Select: TDataSet;
begin
  spCategory_Select.ParamByName('@UserId').AsInteger:= mvarUserID;
  spCategory_Select.Open;
  Category_Select := spCategory_Select;
end;

procedure TdmOrganizer.Category_Insert;
begin
  spCategory_Insert.ParamByName('@UserId').Value:= mvarUserID;
  spCategory_Insert.execProc;
end;

procedure TdmOrganizer.CreateTaskList;
begin
   with spTask_Select do begin // Reading Task Rows
        ParamByName('@UserId').Value := mvarUserId;
        Open;
        while not Eof do begin
              CreateTaskItem(FieldbyName('SysId').asinteger);
              Next;
        end;
        Close;
   end;
end;

procedure TdmOrganizer.CreateNotesList;
var
  p: TPoint;
  mvarNoteItem : NoteItem;
begin
   with spNotes_Select do begin
        ParamByName('@UserId').AsInteger := mvarUserId ;
        open;
        while not Eof do begin
              mvarNoteItem := NoteItem.Create;
              with mvarNoteItem.Note do begin
                   mvarNoteItem.Note.Visible :=(FieldByName('Hidden').asinteger <> 1);
                   DateCreated:= FieldByName('Creationdate').AsDateTime;
                   Contents   := FieldByName('Contents').asstring;
                   Color      := FieldByName('Color').asinteger;
                   p.x        := FieldByName('xPosition').asinteger;
                   p.y        := FieldByName('yPosition').asinteger;
                   SysId      := FieldByName('SysId').AsInteger;
                   position   := p;
              end;
              mvarNoteItem.OnDelete := DeleteNote;
              mvarNoteItem.OnUpdate := UpDateNote;
              Next;
       end;
       Close;
    end;

end;

end.

