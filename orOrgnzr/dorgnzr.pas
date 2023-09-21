unit dorgnzr;

interface
uses
  windows, SysUtils, Classes,  Forms, Controls, ImgList, Db, DBTables, forTskPd,
  ExtCtrls, uorTask, uorCalnd,forCalnd, dialogs, stdCtrls, FCal, FDatePicker, math, uorNItem,
  DBWrap;

type
  TdmOrganizer = class(TDataModule)
    imgNotes: TImageList;
    qNoteQuery: TQuery;
    qNoteSysId: TStoredProc;
    qGetDateTime: TStoredProc;
    spTaskSysId: TStoredProc;
    qTaskQuery: TQuery;
    imgTasks: TImageList;
    qCategoryAdd: TQuery;
    qCategoryReset: TQuery;
    spTaskCategory: TStoredProc;
    spDeleteCategory: TStoredProc;
    qTaskColumns: TQuery;
    tmrReminder: TTimer;
    qAppQuery: TQuery;
    qAppTaskColumns: TQuery;
    spAppointmentSysId: TStoredProc;
    qAppDelete: TQuery;
    qAppUpdate: TQuery;
    qAppInsert: TQuery;
    qEvents: TQuery;
    qEvDelete: TQuery;
    qEvInsert: TQuery;
    qEvUpdate: TQuery;
    spEventSysId: TStoredProc;
    qRecurr: TQuery;
    qRecInsert: TQuery;
    spRecSysId: TStoredProc;
    qRecUpdate: TQuery;
    qRecDelete: TQuery;
    spGetSetDefaults: TStoredProc;
    spGetNames: TStoredProc;
    DbWrapper1: TDbWrapper;
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
       procedure NotesPadClosed(S: TObject);
       procedure UpdateTask(S: TObject);
       procedure DeleteTask(S: TObject);
       procedure TasksPadClosed(S: TObject);
       procedure CalendarPadClosed(S: TObject);
       function ReadTasks: TQuery;
       Procedure SaveColumns;
       Procedure SaveAppTaskColumns;
       function RestoreColumns:TQuery;
       function CreateTaskItem(id: integer): UTaskItem;

       procedure UpdateAppointment(S: TObject);
       procedure DeleteAppointment(S: TObject);
       function RestoreAppTaskColumns:TQuery;
       function CreateAppointmentItem(id: integer): UAppointmentItem;
       function getHoliday( day : integer) : boolean;
       procedure setHoliday( day : integer; hol : boolean);
  public
       property ShamsiDate : boolean read mvarShamsiDate write mvarShamsiDate;
       procedure ShowNotePad;
       procedure UpdateNote(S: TObject);
       procedure DeleteNote(S: TObject);
       function getNames(Value : integer): TDataSet;
       property WorkingStartHour : TdateTime read mvarWorkingStartHour write mvarWorkingStartHour;
       property WorkingEndHour : TdateTime   read mvarWorkingEndHour   write mvarWorkingEndHour;
       property Holidays[day : integer]: boolean read getHoliday       write setHoliday;
       procedure WriteDefaults;
       function  CountHolidays(dtStart_S, dtEnd_S: String; var Weekly, Events : integer): integer;
       function Datename(dt : TdateTime; fmt: TDateNameFormat): string;
       procedure InitHolidays( Obj : TObject);
       function Shamsi( dt: TDateTime) : string;
       function Miladi( sdt: string) : TDateTime;
       function isHoliday(dt : TdateTime): boolean;

       procedure UpdateRecurrence(Rec : UReccPattern);
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
end;


var
 Organizer : TdmOrganizer;
implementation
{$R *.DFM}
uses forRmnd, forEvent, forNotesPad, uorNote;

function TdmOrganizer.getHoliday( day : integer) : boolean;
begin
   Result:=mvarHoliday[day];
end;

procedure TdmOrganizer.setHoliday( day : integer; hol : boolean);
begin
 mvarHoliday[day]:= hol;
end;

var
  mvarUserId: Integer;
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
          qTaskQuery.Locate('SysId',SysId,[]);
          qTaskQuery.Delete;
     end;
  end;

procedure TdmOrganizer.DataModuleCreate(Sender: TObject);
var
 hol : integer;
 i: integer;
begin
 ShamsiDate := true; 
 mvarUserId :=1;
 mvarCal := TCal.Create(self);
 mvarAppList := UAppList.Create(UpdateAppointment , DeleteAppointment);
 ReadAppointments(mvarUserId,0);
 UTaskList.Create(UpdateTask, DeleteTask, mvarUserId,0);
 spTaskCategory.ParamByName('@p1').Value:= 1;
 qCategoryAdd.ParamByName('UserId').Value:= 1;
 ReadTasks;  // in case user didn't started TaskPad

 spGetSetDefaults.ParamByName('@opCode').Value :=0;
 spGetSetDefaults.ExecProc;
 Hol := spGetSetDefaults.Parambyname('@wend').asinteger;
 for i:=1 to 7 do
    if Hol and trunc(power(2,i-1)) > 0 then
       Holidays[i]:= true;
 WorkingStartHour := spGetSetDefaults.Parambyname('@hrFrom').asDateTime;
 WorkingENdHour   := spGetSetDefaults.Parambyname('@hrTo').asDateTime;
end;

procedure TdmOrganizer.DataModuleDestroy(Sender: TObject);
begin
 mvarCal.free;
 if NotesPad <> nil then begin
    NotesPad.Close;
    NotesPad.Free;
 end;
 if TasksPad <> nil then begin
    TasksPad.Close;
    TasksPad.Free;
 end;
 mvarAppList.free;
 Organizer := nil
end;

procedure TdmOrganizer.NotesPadClosed(S: TObject);
begin
  NotesPad := nil;
end;

procedure TdmOrganizer.TasksPadClosed(S: TObject);
begin
  SaveColumns;
  TasksPad := nil;
end;

procedure TdmOrganizer.ShowTaskPad;
var
   mvarTaskItem : UTaskItem;
   qcols : TQuery;
begin
   TasksPad:= TfrmTaskPad.Create(application);
   qCols := RestoreColumns;
   if qCols <> nil then begin
      while not qCols.eof do begin
         TasksPad.AddColumn(TaskCols(qCols.FieldByName('ColumnId').asinteger),-1 );
         qCols.next;
      end;
      qCols.Active:= false;
   end
   else begin
       TasksPad.AddColumn(tcSubject,-1 );
       TasksPad.AddColumn(tcStartDate,-1);
       TasksPad.AddColumn(tcImportance,-1);
   end;

   TasksPad.OnClose :=  TasksPadClosed;
   ReadTasks; // opens qTaskQuery
   while not qTaskQuery.Eof do begin
        mvarTaskItem:= CreateTaskItem(qTaskQuery.FieldbyName('SysId').asinteger);
        TasksPad.Append(mvarTaskItem);
        qTaskQuery.Next;
   end;
   TasksPad.Show;
end;

procedure TdmOrganizer.UpdateTask(S: TObject);
  var
    appmode : boolean;
    qUpdate :  TQuery;
    spSysId : TStoredProc;
  begin
    appmode := false;
    qUpdate := qTaskQuery;
    spSysId := spTaskSysId;

    with UTaskItem(S).Task do begin
        appmode := (SysId = 0);
        if appmode then
           qUpdate.Append
        else begin
             qUpdate.Locate('SysId',SysId,[]);
             qUpdate.Edit;
        end;

        with qUpdate do begin
             FieldByName('CreationDate').Value        := DateCreated;
             FieldByName('LastModifyDate').Value     := LastModifyDate;
             FieldByName('Subject').Value            := Subject;
             FieldByName('DueDate').Value            := DueDate;
             FieldByName('StartDate').Value          := StartDate;
             FieldByName('Status').Value             := Status;
             FieldByName('Importance').Value         := Importance;
             FieldByName('PercentCompleted').Value   := PercentCompleted;
             if FieldByName('ReminderDate').Value  <> ReminderDate then begin
                FieldByName('PostReminderDate').Value := ReminderDate;
             end;
             FieldByName('ReminderDate').Value := ReminderDate;
             FieldByName('ReminderDate').Value       := ReminderDate;
             FieldByName('Attachments').Value        := Attachments;
             FieldByName('Categories').Value         := Categories;
             if Privacy then
                FieldByName('Privacy').Value            := 1
             else
                FieldByName('Privacy').Value            := 0;

             FieldByName('DateCompleted').Value      := DateCompleted;
             FieldByName('ActualWork').Value         := ActualWork;
             FieldByName('TotalWork').Value          := TotalWork;
             FieldByName('Contacts').Value           := Contacts;
             FieldByName('BillingInformation').Value := BillingInformation;
             FieldByName('Companies').Value          := Companies;
             FieldByName('Mileage').Value            := Mileage;
        end;
        if appmode then begin
          qGetDateTime.ExecProc;
          spSysId.ExecProc;
          SysId := spSysid.ParamByName('@p').asinteger;
          DateCreated := qGetDateTime.ParamByName('@p').AsDate;
          qUpdate.FieldByName('Sysid').Value :=  SysId;
          qUpdate.FieldByName('UserId').Value := mvarUserId;
       end;
       qTaskQuery.post;
       qTaskQuery.close;
       qTaskQuery.Open;
   end;
  end;
procedure TdmOrganizer.AddToCategory(Name: string; Status: integer);
begin
  qCategoryAdd.ParamByName('Name').Value:= Name;
  qCategoryAdd.ParamByName('Status').Value:= Status;
  qCategoryAdd.ParamByName('UserId').Value:= mvarUserId;
  qCategoryAdd.ExecSQL;
end;

procedure TdmOrganizer.DelCategory(Name: string);
begin
    spDeleteCategory.ParamByName('@PName').Value := Name;
    spDeleteCategory.ParamByName('@UserId').Value := mvarUserId;
    spDeleteCategory.execProc;
end;

procedure TdmOrganizer.ResetCategory;
begin
    qCategoryReset.ParamByName('UserId').Value:= mvarUserId;
    qCategoryReset.ExecSQL;
end;

function TdmOrganizer.RestoreColumns: TQuery;
begin
 with qTaskColumns do begin
     ParamByName('UserId').Value := mvarUserId;
     Active := true;
     if eof then begin
        Active := False;
        Result:= nil;
     end else
           Result:= qTaskColumns;
 end;
end;

function TdmOrganizer.RestoreAppTaskColumns: TQuery;
begin
 with qAppTaskColumns  do begin
     ParamByName('UserId').Value := mvarUserId;
     Active := true;
     if eof then begin
        Active := False;
        Result:= nil;
     end else
           Result:= qAppTaskColumns;
 end;
end;

procedure TdmOrganizer.SaveColumns;
var
 i:integer;
begin
 with qTaskColumns do begin
   ParamByName('UserId').Value := mvarUserId;
   Active := true;
   while not eof do
     Delete;
   Active := False;
   Active := True;
   for i:= 1 to TasksPad.lv.Columns.count-1 do begin
       append;
       FieldByName('UserId').Value := mvarUserId;
       FieldByName('ColumnId').Value := TasksPad.lv.Columns[i].Tag;
       FieldByName('RowNo').Value := i;
       post;
   end;
   Active := False;
 end;
end;

function TdmOrganizer.ReadTasks: TQuery;
begin
   qTaskQuery.active:= false;
   qTaskQuery.ParamByName('UserId').Value := mvarUserId;
   qTaskQuery.Active := true;
   Result:= qTaskQuery;
end;

procedure TdmOrganizer.ReadAppointments(uid, idType : integer);
var
 ci : UAppointmentItem;
begin
   qAppQuery.active:= false;
   qAppQuery.ParamByName('UserId').Value := uid;
   qAppQuery.ParamByName('IdType').Value := idType;
   qAppQuery.ParamByName('StartDate').Value := 0;
   qAppQuery.ParamByName('EndDate').Value   := Date() + 1000;// dt+31;
   qAppQuery.Active := true;
   mvarAppList.DelList(uid, idType);
   mvarAppList.NewList(uid, idType);
   mvarAppList.setList(uid, idType);
   while not qAppQuery.Eof do begin
        ci := CreateAppointmentItem(qAppQuery.FieldbyName('SysId').asinteger);
        qAppQuery.Next;
   end;
   qAppQuery.Close;
end;

procedure TdmOrganizer.tmrReminderTimer(Sender: TObject);
var
 f: TfrmRemind;
 t1,t2: TSystemTime;
 i, sid : integer;
 ti : UTaskItem;
 List : TList;
begin


   with qTaskQuery do begin
       if not Active then
          exit;
       First;
       while not eof do begin
           DateTimeToSystemTime(FieldByName('PostReminderDate').asDateTime, t1);
           DateTimeToSystemTime(now(), t2);
           if (t1.wYear = t2.wyear) and (t1.wMonth  = t2.wmonth) and
              (t1.wday = t2.wday) and   (t1.wHour  = t2.wHour) and
                                     (t1.wMinute   = t2.wMinute) then
              if not mvarInTimer then begin
                 mvarInTimer:=true;
                 sid:= FieldByName('SysId').Value;
                 f:= TfrmRemind.Create(application);
                 f.lblSubject.Caption := FieldByName('Subject').Value;
                 tmrReminder.Enabled := false;
                 Locate('SysId',sid,[]);
                 case f.showmodal of
                    10 : begin         // don't remind again
                            edit;
                            FieldByName('ReminderDate').Value := 0;
                            FieldByName('PostReminderDate').Value :=0;
                            post;
                        end;
                    20 : begin         // postpone
                            edit;
                            FieldByName('PostReminderDate').Value:= FieldByName('PostReminderDate').Value +
                                    (f.Delay * 60)/ SecsPerDay;
                            post;
                         end;
                    30 : begin       // open
                            edit;
                            FieldByName('PostReminderDate').Value:= 0;
                            FieldByName('ReminderDate').Value :=0;
                            post;
                            ti:= UTaskItem.Find(sid);
                            if ti = nil then
                               ti:= CreateTaskItem(sid);
                            ti.Task.ReminderDate :=0; // no need to remind again
                            ti.edit;
                         end;
                 end;

                 f.free;
                 sid:=-1;
                 mvarInTimer:= False;
                 tmrReminder.Enabled := true;
              end else if sid <> FieldByName('SysId').Value then
                       begin
                         // delay other requests for 5 seconds
                         t1.wSecond := t1.wSecond + 5;
                         edit;
                         FieldByName('PostReminderDate').Value:= SystemTimeToDateTime(t1);
                         post;
                       end;
           next;
       end;
  end;
  if mvarInTimer or (CalendarPad = nil) then
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
end;

function TdmOrganizer.CreateAppointmentItem(id: integer): UAppointmentItem;
begin
   Result:= nil;
   with qAppQuery do begin
        if id <> FieldbyName('SysId').asinteger then
           Locate('SysId',Id,[]);
        if eof then
           exit;
        Result:= UAppointmentItem.Create;
        with Result.Appointment do begin
           SysId              := id;
           if FieldByName('RecurrenceId').asinteger <> 0 then
              Recurrence := GetRecurrPat(FieldByName('RecurrenceId').asinteger)
           else
              Recurrence := nil;
           Subject            := FieldByName('Subject').Value;
           Location           := FieldByName('Location').Value;
           StartTime          := FieldByName('StartTime').AsDateTime;
           EndTime            := FieldByName('EndTime').AsDateTime;
           AppType            := CalAppType(FieldByName('AppType').AsInteger);
           ReminderTime       := FieldByName('ReminderTime').AsDateTime;
           Attachments        := FieldByName('Attachments').Value;
           Categories         := FieldByName('Categories').Asstring;
           Privacy            := FieldByName('Privacy').Asinteger <> 0;
           AllDayEvent        := FieldByName('AllDayEvent').asinteger <>0 ;
           UserId             := FieldByName('UserId').asinteger;
           IdType             := FieldByName('IdType').asinteger;
        end;
    end;
end;

function TdmOrganizer.CreateTaskItem(id: integer): UTaskItem;
begin
   Result:= nil;
    with qTaskQuery do begin
        if id <> FieldbyName('SysId').asinteger then
           Locate('SysId',Id,[]);
        if eof then
           exit;
           Result:= UTaskItem.Create;
        with Result.task do begin
           SysId              := id;
           DateCreated        := FieldByName('CreationDate').AsDateTime;
           LastModifyDate     := FieldByName('LastModifyDate').AsDateTime;
           Subject            := FieldByName('Subject').Value;
           DueDate            := FieldByName('DueDate').AsDateTime;
           StartDate          := FieldByName('StartDate').AsDateTime;
           Status             := TaskStatus(FieldByName('Status').AsInteger);
           Importance         := TaskImportance(FieldByName('Importance').asinteger);
           PercentCompleted   := FieldByName('PercentCompleted').AsInteger;
           ReminderDate       := FieldByName('ReminderDate').AsDateTime;
           Attachments        := FieldByName('Attachments').Value;
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
    end;
end;


procedure TdmOrganizer.DeleteAppointment(S: TObject);
begin
     with UAppointmentItem(S).Appointment do begin
          if Recurrence <> nil then
             Recurrence.Delete; 
          qAppDelete.ParamByName('SysId').Value := SysId;
     end;
     qAppDelete.ExecSQL;
end;

procedure TdmOrganizer.UpdateAppointment(S: TObject);
  var
    appmode : boolean;
    qUpdate : TQuery;
    spSysId : TStoredProc;
  begin
    spSysId := spAppointmentSysId;
    appmode := (UAppointmentItem(S).Appointment.SysId = 0);
    if appmode then
       qUpdate := qAppInsert
    else
       qUpdate := qAppUpdate;

    with UAppointmentItem(S).Appointment,qUpDate do begin
       ParamByName('Subject').Value        := Subject;
       ParamByName('Location').Value       := Location;
       ParamByName('StartTime').Value      := StartTime;
       ParamByName('EndTime').Value        := EndTime;
       ParamByName('AppType').Value        := ord(AppType);
       ParamByName('ReminderTime').Value   := ReminderTime;
       ParamByName('Attachments').Value    := Attachments;
       ParamByName('Categories').Value     := Categories;
       if Recurrence <> nil then
          ParamByName('RecurrenceId').Value   := Recurrence.Id
       else
          ParamByName('RecurrenceId').Value   :=0;
          
       if Privacy then
          ParamByName('Privacy').Value     := 1
       else
          ParamByName('Privacy').Value     := 0;

       if AllDayEvent then
          ParamByName('AllDayEvent').Value     := 1
       else
          ParamByName('AllDayEvent').Value     := 0;

       if appmode then begin
          ParamByName('UserId').Value :=  UserId;
          ParamByName('IdType').Value :=  idType;
          qGetDateTime.ExecProc;
          spSysId.ExecProc;
          SysId := spSysid.ParamByName('@p').asinteger;
          if UserId = 0 then
             UserId := mvarUserId;
          ParamByName('SysId').Value  :=  SysId;
       end else
          ParamByName('SysId').Value := SysId;
       ExecSQL;
   end;
end;


function TdmOrganizer.getEvents(dtFrom, dtTo: TDateTime): TList;
var
 li : TList;
 ev : UEvents;
 attr : integer;
begin
   Li := TList.Create;
   with qEvents do begin
        ParamByName('FromDate').Value := dtFrom;
        ParamByName('ToDate').Value := dtTo;
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
  With qEvDelete, UEvents(S) do begin
       ParamByName('SysId').Value := SysId;
       ExecSQL;
  end;
end;

procedure TdmOrganizer.EventUpdate(S: Tobject);
var
    appmode : boolean;
    qUpdate : TQuery;
    spSysId : TStoredProc;
    ev : UEvents;
    attr : integer;
begin
  ev:=UEvents(S);
  spSysId := spEventSysId;
  appmode := (ev.SysId = 0);
  if appmode then
     qUpdate := qEvInsert
  else
     qUpdate := qEvUpdate;


 with ev, qUpdate do begin
      ParamByName('Description').Value := Description;
      ParamByName('EventDate').Value := EventDate;

      attr :=0;
      if uenHoliday in Event then
         attr := attr or 1;
      if uenBirth in Event then
         attr := attr or 2;
      if uenDie in Event then
         attr := attr or 4;

      ParamByName('Attributes').Value := attr;
      if appmode then begin
          spSysId.ExecProc;
          SysId := spSysid.ParamByName('@p').asinteger;
      end;
      ParamByName('SysId').Value  :=  SysId;
      try
        ExecSQL;
      except
        showmessage('œ— À»   «—ÌŒ «Ì‰ „‰«”»  „‘ﬂ·Ì ÊÃÊœ œ«—œ');
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
            s:= s + ' ’»Õ'
         else
            s:= s + ' ⁄’—';
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
   with qRecurr do begin
        ParamByName('RecId').Value := id;
        Active := true;
        if RecordCount = 0 then begin
           Active := false;
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
         qRecurr.Active := False;
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
  qQuery : TQuery;
begin
   if Rec.Id = 0 then begin
      spRecSysId.ExecProc;
      Rec.Id := spRecSysId.ParamByName('@p').asinteger;
      qQuery := qRecInsert;
   end else
    qQuery := qRecUpdate;

   with  qQuery do begin
        ParamByName('RecId').Value := Rec.Id;
        ParamByName('Type').Value :=  Rec.RecurrenceType;
        ParamByName('StartHour').Value := Rec.StartHour;
        ParamByName('StartDate').Value := Rec.StartDate;
        ParamByName('EndDate').Value := Rec.EndDate;
        ParamByName('Duration').Value := Rec.Duration;
        ParamByName('Times').Value := Rec.After_N_Ocuur;
        ParamByName('Attr3').Value := 0;
        ParamByName('Attr4').Value := 0;

        case rec.RecurrenceType of
           rbDaily : with UReccDaily(Rec) do begin
                         ParamByName('Attr1').Value := Every_N_Days;
                         ParamByName('Attr2').Value := EveryWeekDay;
                     end;
           rbWeekly : with UReccWeekly(Rec) do begin
                         ParamByName('Attr1').Value := Every_N_Weeks ;
                         ParamByName('Attr2').Value := WeekDays;
                      end;
           rbMonthly :with UReccMonthly(Rec) do begin
                         ParamByName('Attr1').Value := DayOfMonth ;
                         ParamByName('Attr2').Value := EveryNMonth ;
                         ParamByName('Attr3').Value := WeekDay;
                         ParamByName('Attr4').Value := MonthWeek;
                      end;
        end;
        qQuery.ExecSQL;
   end;
end;

procedure TdmOrganizer.DeleteRecurrence(rec: UReccPattern);
begin
  qRecDelete.ParamByName('RecId').Value := Rec.id;
  qRecDelete.ExecSQL;
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
var
 ti : UTaskItem;
 qcols : TQuery;
begin
 CalendarPad := TfrmCalendar.Create(Application);
 if TasksPad <> nil then begin
    TasksPad.Close; // make sure form is closed and TaskPad is nil
    TasksPad.Free;
 end;
 TasksPad:= TfrmTaskPad.Create(application);
 qCols := RestoreAppTaskColumns;
 if qCols <> nil then begin
      while not qCols.eof do begin
         TasksPad.AddColumn(TaskCols(qCols.FieldByName('ColumnId').asinteger),-1 );
         qCols.next;
      end;
      qCols.Active:= false;
   end
   else begin
       TasksPad.AddColumn(tcSubject,-1 );
   end;

   ReadTasks; // opens qTaskQuery
   while not qTaskQuery.Eof do begin
        ti := CreateTaskItem(qTaskQuery.FieldbyName('SysId').asinteger);
        TasksPad.Append(ti);
        qTaskQuery.Next;
   end;

   with TasksPad do begin
      Panel1.Visible := false;
      StatusBar1.Visible:= false;
      align := alClient;
      BorderStyle := bsNone;
      Visible:= true;
      TasksPad.Parent := CalendarPad.pnlTasks;
   end;
   CalendarPad.onClose := CalendarPadClosed;
   CalendarPad.Show;
end;

procedure TdmOrganizer.CalendarPadClosed(S: TObject);
begin
//  SaveAppTaskColumns;
  TasksPad.free;
  TasksPad := nil;
  CalendarPad:= nil;
end;

procedure TdmOrganizer.SaveAppTaskColumns;
var
 i:integer;
begin
 with qAppTaskColumns do begin
   ParamByName('UserId').Value := mvarUserId;
   Active := true;
   while not eof do
     Delete;
   Active := False;
   Active := True;
   for i:= 1 to TasksPad.lv.Columns.count-1 do begin
       append;
       FieldByName('UserId').Value := mvarUserId;
       FieldByName('ColumnId').Value := TasksPad.lv.Columns[i].Tag;
       FieldByName('RowNo').Value := i;
       post;
   end;
   Active := False;
 end;
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
 with spGetSetDefaults do begin
      ParamByName('@opCode').Value :=1; // set values
      ParamByName('@wend').Value   := Hol;
      ParamByName('@hrFrom').Value := WorkingStartHour ;
      ParamByName('@hrTo').Value   := WorkingEndHour;
      ExecProc;
 end;
 WorkingStartHour := spGetSetDefaults.Parambyname('@hrFrom').asDateTime;
 WorkingENdHour   := spGetSetDefaults.Parambyname('@hrTo').asDateTime;

end;

function TdmOrganizer.getNames(Value: integer): TDataSet;
begin
    with spGetNames do begin
       ParamByName('@NameType').Value := Value;
       spGetNames.Open;
       Result:= spGetNames;
    end;
end;
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////
procedure TdmOrganizer.ShowNotePad;
var
   p: TPOint;
   mvarNoteItem : NoteItem;
begin
   if NotesPad <> nil then begin
      NotesPad.Show;
      exit;
   end;
   NotesPad:= TfrmNotesPad.Create(nil);
   with TfrmNotesPad(NotesPad) do begin
        OnUpdate := UPdateNote;
        OnDelete := DeleteNote;
        OnClose  := NotesPadClosed;
   end;
   with qNoteQuery do begin
        if active then
           active:= false;
        SQL.Clear;
        SQL.Add( 'select * from  org.orNotes where UserId=' + inttostr(mvarUserId));
        Active := true;
        First;
   end;
   while not qNoteQuery.Eof do begin
          mvarNoteItem := NoteItem.Create;
          with mvarNoteItem.Note do begin
               mvarNoteItem.Note.Visible :=(qNoteQuery.FieldByName('Hidden').asinteger <> 1);
               DateCreated:= qNoteQuery.FieldByName('Creationdate').AsDateTime;
               Contents   := qNoteQuery.FieldByName('Contents').asstring;
               Color      := qNoteQuery.FieldByName('Color').asinteger;
               p.x        := qNoteQuery.FieldByName('xPosition').asinteger;
               p.y        := qNoteQuery.FieldByName('yPosition').asinteger;
               SysId      := qNoteQuery.FieldByName('SysId').AsInteger;
               position   := p;
          end;
          mvarNoteItem.OnDelete := DeleteNote;
          mvarNoteItem.OnUpdate := UpDateNote;
          TfrmNotesPad(NotesPad).AttachTo(mvarNoteItem);
          qNoteQuery.Next;
   end;
   NotesPad.Show;
end;

procedure TdmOrganizer.DeleteNote(S: TObject);
  begin
     with UNote(S) do begin
          qNoteQuery.Locate('SysId',SysId,[locaseinsensitive]);
          qNoteQuery.Delete;
     end;
  end;

procedure TdmOrganizer.UpdateNote(S: TObject);
  var
    appmode : boolean;
  begin
    appmode := false;
    with UNote(S) do begin
        if SysId <> 0 then begin
             qNoteQuery.Locate('SysId',SysId,[locaseinsensitive]);
             qNoteQuery.Edit;
           end
        else begin
               qNoteQuery.Append;
               appmode := true;
        end;
       if Visible then
          qNoteQuery.FieldByName('Hidden').Value  := 0
       else
          qNoteQuery.FieldByName('Hidden').Value  := 1;
       qNoteQuery.FieldByName('Contents').Value := Contents;
       qNoteQuery.FieldByName('Color').Value    := Color;
       qNoteQuery.FieldByName('UserId').Value   := mvarUserId;
       qNoteQuery.FieldByName('xPosition').Value:= position.x;
       qNoteQuery.FieldByName('yPosition').Value:= position.y;
       qNoteQuery.FieldByName('Category').Value := Categories;
       if appmode then begin
          qNoteSysid.ExecProc;
          qGetDateTime.ExecProc; 
          SysId := qNoteSysid.ParamByName('@p').asinteger;
          DateCreated := qGetDateTime.ParamByName('@p').AsDate;
          qNoteQuery.FieldByName('Creationdate').Value := DateCreated;
          qNoteQuery.FieldByName('Sysid').Value :=  SysId;
       end;
       qNoteQuery.post;
   end;
  end;

end.
