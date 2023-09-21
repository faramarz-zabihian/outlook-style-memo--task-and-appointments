unit uorCalnd;

interface
uses  Classes, windows, forms, comctrls, Controls, dialogs, sysutils, graphics, uorComm, grids, stdCtrls, extctrls, uorAppbr, imgList, Fcal, math, forNetMt;

Type
  TDateTimeArray = array of TDateTime;
  CalAppType = (ctnFree, ctnTentative, ctnBusy, ctnOut);
  UTimeSegment = ( ts60m, ts30m, ts15m);
  UAppointmentItem = Class;
  URecurrBase = (rbDaily, rbWeekly, rbMonthly);
  UReccPattern = class
     private
        function getRecurrenceType : URecurrBase;
        function getText: string;
     public
       Id : integer;
       StartHour, StartDate, EndDate : TDateTime;
       Duration : real;
       After_N_Ocuur : integer;
       property Text : string read getText;
       procedure Delete;
       procedure UpdatePattern;
       property RecurrenceType : URecurrBase read getRecurrenceType;
       function OccuresAt(dt: TdateTime ; var hrFrom, hrTo : TdateTime) : boolean;virtual;abstract;
  end;
  UReccDaily = class( UReccPattern)
    Every_N_Days : integer;
    EveryWeekDay: boolean;
    function OccuresAt(dt: TdateTime ; var hrFrom, hrTo : TdateTime): boolean;override;
  end;
  UReccWeekly = class( UReccPattern)
    Every_N_Weeks : integer;
    WeekDays: integer;
    function OccuresAt(dt: TdateTime ; var hrFrom, hrTo : TdateTime): boolean;override;
  end;
  UReccMonthly = class( UReccPattern)
    DayOfMonth : integer;
    EveryNMonth : integer;
    WeekDay : integer;
    MonthWeek : integer;
    function OccuresAt(dt: TdateTime ; var hrFrom, hrTo : TdateTime): boolean;override;
  end;

  TOrEdit = class(TPanel)
     private
        mvarEdit : TEdit;
        mvarAppointmentItem : UAppointmentItem;
        mvarRecurring : boolean;
        function getText: string;
        procedure setText(const Value: string);
        procedure setWidth(const Value: integer);
        procedure setHeight(const Value: integer);
        function getHeight: integer;
        function getRecurring : boolean;
     public
        property AppointmentItem: UAppointmentItem read mvarAppointmentItem write mvarAppointmentItem;
        procedure Invalidate;override;
        property Text : string read getText write setText;
        property Width : integer write setWidth;
        property Height : integer read getHeight write setHeight;
        constructor Create(AOwner : TComponent);override;
        procedure Paint;override;
        property Recurring : boolean read getRecurring;
  end;
  UAppointment = Class
     private
       mvarMeetingId : integer;
       mvarIdType, mvarUserId, mvarSysId : integer;
       mvarRequiredInMeeting : boolean;
       mvarSubject, mvarLocation : string;
       mvarStartTime, mvarEndTime : TDateTime;
       mvarAppTYpe : CalAppType;
       mvarCategories: string;
       mvarPrivacy : boolean;
       mvarAttachments : string;

       mvarReminder : TTime;
       mvarChanged, mvarAllDayEvent: Boolean;
       mvarRecurrencePt : UReccPattern;
       procedure setSubject(const Value: string);
       procedure setStartTime(const Value: TDateTime);
       procedure setEndTime(const Value: TDateTime);
       procedure setAppType(const Value: CalAppType);
       procedure setCategories(const Value: string);
       procedure setPrivacy(const Value: Boolean);
       procedure setAttachments(const Value: string);
       procedure setReminder(const Value: TTime);
       procedure setLocation(const Value: string);
       procedure setAllDayEvent(const Value: boolean);
       procedure setRecurrencePt(const Value : UReccPattern);
     public
       property RequiredInMeeting : boolean read mvarRequiredInMeeting write mvarRequiredInMeeting;
       property MeetingId : integer read mvarMeetingId write mvarMeetingId;
       property IdType: integer read mvarIdType write mvarIdType;
       property UserId: integer read mvarUserId write mvarUserId;
       property SysId : integer read mvarSysId write mvarSysId;
       property AllDayEvent : boolean read mvarAllDayEvent write setAllDayEvent;
       property Subject : string read mvarSubject write setSubject;
       property Location : string read mvarLocation write setLocation;
       property StartTime : TDateTime read mvarStartTime write setStartTime;
       property EndTime   : TDateTime read mvarEndTime   write setEndTime;
       property Attachments : string read mvarAttachments write setAttachments;
       property AppType: CalAppType read mvarAppType write setAppType;
       property ReminderTime : TTime read mvarReminder write setReminder;
       property Categories: string read mvarCategories write setCategories;
       property Privacy : Boolean read mvarPrivacy write setPrivacy;
       property Changed:Boolean read mvarChanged write mvarChanged;
       property Recurrence : UReccPattern read mvarRecurrencePt write setRecurrencePt;
       function OccuresAt(dt: TdateTime ; var hrFrom, hrTo : TdateTime) : boolean;
  end;

  UAppointmentList = Class(UList)
     public
         procedure CloseAll;override;
         constructor Create(UpdateProc, DeleteProc:TNotifyEvent; Uid, uiType : integer);override;
         procedure SortByDateTime;
  end;

  UAppList = Class
    private
       mvarOnUpdate, mvarOnDelete : TNotifyEvent;
       mvarList : TList;
       mvarCurrentList : UAppointmentList;
       function FindList(UserId, idType : integer): integer;
    public
       property    CurrentList: UAppointmentList read mvarCurrentList;
       function    getList: TList;
       procedure   NewList(UserId, idType: integer);
       procedure   DelList(UserId, idType: integer);
       procedure   setList(UserId, idType: integer);
       constructor Create(UpdateProc, DeleteProc:TNotifyEvent);
       destructor  Destroy;override;
  end;

  UAAppointmentItems = array of UAppointmentItem;
  UAppointmentItem = Class
     private
        mvarList : TListItem;
        mvarChanged : Boolean;
        mvarRow: TListItem;
        mvarfrmAppointment : TForm;
        mvarAppointment : UAppointment;
        mvarParent : UAppointmentList;
        mvarEditControl : TorEdit;
        mvarLeftPos :integer;
        mvarStartRow, mvarRows : integer;
        mvarHeight : integer;
        procedure UpdateView;
        procedure setChanged( status : boolean);
        procedure setStartTime(dt : TDateTime);
        procedure setEndTime(dt : TDateTime);
        function  getStartTime:TDateTime;
        function  getEndTime:TDateTime;
        procedure setEditControl( ec : TorEdit);
     public
        property  Form : TForm read mvarfrmAppointment;
        property  Height : integer read mvarHeight write mvarHeight;
        property  EditControl: TorEdit read mvarEditControl write setEditControl;
        property  StartRow : integer read mvarStartRow write mvarStartRow;
        property  Rows : integer read mvarRows write mvarRows;
        property  LeftPos: integer read mvarLeftPos write mvarLeftPos;
        property  Parent : UAppointmentList read mvarParent;
        property  Changed : Boolean read mvarChanged write setChanged;
        property  Appointment : UAppointment read mvarAppointment write mvarAppointment;
        property  StartTime : TDateTime read getStartTime write setStartTime;
        property  EndTime : TDateTime read getEndTime write setEndTime;
        procedure Edit(dt : TDateTime);
        procedure Save;overload;
        procedure Save(appm : UAppMeeting);overload;
        procedure Delete;
        procedure FreeEditControl;
        procedure ReleaseForm;
        function  PreviousItem: UAppointmentItem;
        function  NextItem : UAppointmentItem;
        class procedure PrintOut(ar : UAAppointmentItems);
        class function Find(id: integer) : UAppointmentItem;
        constructor Create;
        destructor Destroy;override;
   end;
  UTimeStamp = class
     mvarTime : TDateTime;
     mvarSegNo : integer ;
     mvarHourText: string;
     mvarAfternoon : boolean;
     mvarApps : UAAppointmentItems;
     procedure setHour(const Value : integer; Seg: UTimeSegment);
  public
     property Appointments : UAAppointmentItems read mvarApps write mvarApps;
     property HourText : string read mvarHourText;
     property Time : TDateTime read mvarTime;
     property isAfternoon : boolean read mvarAfterNoon;
     destructor Destroy;override;
  end;


var
  mvarAppList: UAppList;

implementation
uses forTskEd, dmorgnzr, forTskPd, forPrvw, forEclnd ;

destructor UTimeStamp.Destroy;
begin
  setLength(mvarApps,0);
  inherited destroy;
end;

procedure UTimeStamp.setHour(const Value:integer; Seg: UTimeSegment);
var
 mHr,mMin, mSec, mmSec: Word;
begin
  case seg of
     ts60m : mvarTime := Value / 24; // 24 hour per day
     ts30m : mvarTime := Value /48; // 48 half hour per day
     ts15m : mvarTime := Value /96; // 96 quarters per day;
  end;
  DecodeTime(mvarTime, mHr, mMin, mSec, mmSec);
  mvarAfternoon:= mhr > 12;

  if mhr mod 12 = 0 then
     mvarHourText:= '12'
  else
     mvarHourText:= inttostr(mHr mod 12);

end;

procedure UAppointmentItem.Delete;
begin
  ReleaseForm;
  if assigned(Parent.onDelete) then
     Parent.OnDelete(self);            // delete From DataBase 
  Free;
  Organizer.CalendarPad.RefreshView;
end;

class procedure UAppointmentItem.PrintOut(ar: UAAppointmentItems);
var
 fpv: TfrmPreview;
 ti : UAppointmentItem;
 i: integer;
 tab : char;
begin
 if ar = nil then
    exit;
 tab:= chr(9);
 fpv:= TfrmPreview.Create(application);
 with fpv.re do begin
     Lines.Clear;
     for i:= 0 to high(ar) do begin
         ti:= ar[i];
         if i > 0 then
            Lines.Add(stringofchar('-',100));
         SelAttributes.Style := [fsbold];
         Lines.Add('ãæÖæÚ :');
         SelAttributes.Style := [];
         Lines.Add(tab+ti.Appointment.Subject);

         SelAttributes.Style := [fsbold];
         Lines.Add('ÔÑÍ :');

         SelAttributes.Style := [];
         Lines.Add(tab+ti.Appointment.Attachments);
     end;
     fpv.PrintOut; 
 end;
 fpv.free;
// to be implemented
end;

procedure UAppointmentItem.Save;
begin
  Parent.Update(self);
  if Organizer.CalendarPad  <> nil then
     UpdateView;
end;


procedure UAppointmentItem.UpdateView;
begin
  Organizer.CalendarPad.RefreshView;
end;

procedure UAppointment.setAttachments(const Value: string);
begin
   mvarAttachments:= Value;
   changed:= true;
end;

procedure UAppointment.setCategories(const Value: string);
begin
  mvarCategories := Value;
  changed:= true;
end;

procedure UAppointment.setStartTime(const Value: TDateTime);
begin
  mvarStartTime := Value;
  Changed := true;
end;

procedure UAppointment.setLocation(const Value: string);
begin
  mvarLocation := Value;
  Changed := true;
end;

procedure UAppointment.setPrivacy(const Value: Boolean);
  begin
    mvarPrivacy := Value;
    changed := true;
  end;

procedure UAppointment.setReminder(const Value: TTime);
begin
   mvarReminder:= Value;
   changed := true;
end;

procedure UAppointment.setEndTime(const Value: TDateTime);
  begin
    mvarEndTime := Value;
    changed := true;
  end;

procedure UAppointment.setAppType(const Value: CalAppType);
begin
 mvarAppTYpe := Value;
 changed := true;
end;

procedure UAppointment.setSubject(const Value: string);
  begin
    mvarSubject := Value;
    changed := true;
  end;

procedure UAppointmentItem.Edit(dt : TdateTime);
var
 f: TfrmEditApp;
begin
    if mvarfrmAppointment = nil then begin
       f := TfrmEditApp.Create(application);
       mvarfrmAppointment := f;
       f.CallingDate := dt;
       f.AppItem := self;
       f.Visible   := true;
    end;
    mvarfrmAppointment.show;
end;

constructor UAppointmentItem.Create;
begin
   Appointment:= UAppointment.Create;
   mvarAppList.CurrentList.List.Add(self);
   mvarParent := mvarAppList.CurrentList;
   Appointment.UserId := mvarParent.UserId ;
   Appointment.IdType := mvarParent.IdType ;
   mvarEditControl := nil;
end;

procedure UAppointmentItem.ReleaseForm;
begin
   if mvarfrmAppointment <> nil then
      mvarfrmAppointment.Release;
   mvarfrmAppointment := nil;
end;

procedure UAppointmentList.CloseAll;
var
 i: integer;
begin
  for i:=0 to List.Count -1 do
      UAppointmentItem(List[i]).ReleaseForm;
end;

constructor UAppointmentList.Create(UpdateProc, DeleteProc:TNotifyEvent; Uid, uiType : integer);
begin
  OnUpdate := UpdateProc;
  OnDelete := DeleteProc;
  UserId   := uid;
  IdType   := uiType;
  List     := TList.Create;

end;



function UAppointmentItem.NextItem: UAppointmentItem;

begin
 Parent.SortByDateTime;
 Result:= UAppointmentItem(Parent.NextItem(self));
end;

function UAppointmentItem.PreviousItem: UAppointmentItem;
begin
 Parent.SortByDateTime;
 Result:= UAppointmentItem(Parent.PreviousItem(self));
end;

function getDateName(dt:Tdate): string;
begin
  if dt = 0 then
     Result:= ''
  else
     Result:= FormatDateTime('dddd¡ yyyy/mm/dd',dt);
end;




procedure UAppointmentItem.setChanged(status: boolean);
begin
  mvarChanged := true;
end;

class function UAppointmentItem.Find(id: integer): UAppointmentItem;
var
i: integer;
begin
 Result:= nil;
 for i:=0 to mvarAppList.CurrentList.List.count-1 do
     if UAppointmentItem(mvarAppList.CurrentList.List[i]).Appointment.SysId = id then begin
        Result:= UAppointmentItem(mvarAppList.CurrentList.List[i]);
        exit;
     end;
end;

function UAppointmentItem.getEndTime: TDateTime;
begin
    Result:= Appointment.EndTime
end;

function UAppointmentItem.getStartTime: TDateTime;
begin
    Result:= Appointment.StartTime
end;

procedure UAppointmentItem.setEndTime(dt: TDateTime);
begin
  Appointment.EndTime := dt;
  if mvarfrmAppointment <> nil then
     TfrmEditApp(mvarfrmAppointment).dpEndDate.Miladi := dt;
end;

procedure UAppointmentItem.setStartTime(dt: TDateTime);
begin
  Appointment.StartTime := dt;
  if mvarfrmAppointment <> nil then
     TfrmEditApp(mvarfrmAppointment).dpEndDate.miladi := dt;
end;

procedure UAppointmentItem.setEditControl(ec: TorEdit);
begin
  //
  mvarEditControl:= ec;
  if ec = nil then
     exit;
  ec.Visible := false;
  ec.AppointmentItem := self;
  ec.enabled := false;
end;

procedure UAppointment.setAllDayEvent(const Value: boolean);
begin
  mvarAllDayEvent:= Value;
  changed:= true;
end;

{ TOrEdit }

constructor TOrEdit.Create(AOwner: TComponent);
begin
  inherited;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  mvarEdit := TEdit.Create(self);
  mvarEdit.Parent:= self;
  mvarEdit.top:=1;
  mvarEdit.Left:=1;
  mvarEdit.Color := $00DEDEE2;
  Color := clBlack;
  mvarEdit.BorderStyle := bsnone;
end;

function TOrEdit.getText: string;
begin
  Result:=mvarEdit.Text;
end;

procedure TOrEdit.Invalidate;
begin
  inherited;
  if mvarEdit <> nil then
     mvarEdit.Invalidate;
end;

procedure TOrEdit.setHeight(const Value: integer);
begin
   TPanel(self).Height := Value;
   mvarEdit.Height := Value-2;
end;

function TOrEdit.getHeight: integer;
begin
   Result:= TPanel(self).height;
end;

procedure TOrEdit.setText(const Value: string);
begin
  mvarEdit.Text:= Value;
end;

procedure TOrEdit.setWidth(const Value: integer);
begin
 TPanel(self).Width := Value;
 with AppointmentItem.Appointment do begin
    if AllDayEvent then
       if Recurring then
          mvarEdit.Width := Value - 16
       else
          mvarEdit.Width := Value
    else
       if Recurring then
          mvarEdit.Width := Value - 23
       else
          mvarEdit.Width := Value - 7;
 end;
end;

procedure TOrEdit.Paint;
var
 rc : TRect;
 clr : TColor;
 recPos : integer;
begin
  inherited;
  if mvarEdit <> nil then
     mvarEdit.Invalidate;
  with Canvas do begin
    FrameRect(ClientRect);
    rc.BottomRight := ClientRect.BottomRight;
    rc.TopLeft     := ClientRect.TopLeft;
    RecPos :=0;
    inc(rc.top);
    dec(rc.bottom);
    if not mvarAppointmentItem.Appointment.AllDayEvent then begin
       RecPos := rc.Right- 22;
       rc.left := RecPos;
       brush.Color := mvarEdit.Color;
       FillRect(rc);
       rc.left := rc.right-6;
    end else begin
       rc.left := rc.right-1;
       RecPos  := rc.right-16;
    end;
    inc(rc.Left);
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
    if Recurring then begin
  //      clr := Organizer.imgTasks.BkColor;
//        Organizer.imgTasks.BkColor := mvarEdit.Color;
        Organizer.imgTasks.Draw(Canvas, RecPos, 1,2);
//        Organizer.imgTasks.BkColor:= clr;
    end;
  end;

end;

destructor UAppointmentItem.Destroy;
begin
  Parent.List.Remove(self);
  if mvarEditControl  <> nil then
     mvarEditControl.free;
  if mvarAppointment <> nil then
     mvarAppointment.free;
  inherited Destroy;
end;

procedure UAppointmentItem.FreeEditControl;
begin
  if mvarEditControl <> nil then begin
     mvarEditControl.free;
     mvarEditControl:= nil;
  end;
end;

procedure UAppointment.setRecurrencePt(const Value: UReccPattern);
begin
  mvarRecurrencePt := Value;
  Changed := true;
end;

function TOrEdit.getRecurring: boolean;
begin
  result:= AppointmentItem.Appointment.Recurrence <> nil;
end;

{ UReccPattern }

procedure UReccPattern.Delete;
begin
 Organizer.DeleteRecurrence(self);
end;

function UReccPattern.getRecurrenceType: URecurrBase;
begin
  if (ClassType = UReccDaily) then
     Result:= rbDaily
  else if ClassType = UReccWeekly then
     Result:= rbWeekly
  else if ClassType = UReccMonthly then
     Result:= rbMonthly;
end;

function WeekDayName(day : integer): string;
begin
   case day of
      1: Result:= 'ÔäÈå';
      2: Result:= 'íßÔäÈå';
      3: Result:= 'ÏæÔäÈå';
      4: Result:= 'Óå ÔäÈå';
      5: Result:= 'åÇÑÔäÈå';
      6: Result:= 'äÌÔäÈå';
      7: Result:= 'ÌãÚå';
   end;
end;

function UReccPattern.getText: string;
var
 i, cnt: integer;

begin
   if ClassType = UReccDaily then
      with UReccDaily(self) do begin
          if EveryWeekDay  then
             Result:= 'ÞÑÇÑ ÑæÒÇäå ÏÑ Øæá åÝÊå'
          else if Every_N_Days = 1 then
             Result:='ÞÑÇÑ ÑæÒÇäå'
          else Result:= 'ÞÑÇÑ ÑæÒÇäå åÑ ' +inttostr(Every_N_Days-1)+ ' ÑæÒÏÑãíÇä ';
      end
   else if ClassType = UReccWeekly then
         with UReccWeekly(self) do begin
             Result:= '';
             cnt := 0;
             for i:= 1 to 7 do
                if (WeekDays and trunc(power(2,i-1)) ) > 0 then begin
                    if cnt > 0 then
                       Result := Result + ' æ ';
                    cnt := cnt + 1;
                    Result:= Result + WeekDayname(i);
                end;
             Result := Result + ' ';
             if cnt = 1 then
                Result:= ' ÑæÒ ' + Result
             else
                Result:= ' ÑæÒåÇí ' + Result;
             if Every_N_Weeks = 1 then
                Result := Result + ' åÑ åÝÊå '
             else
                Result := Result + 'åÑ '+inttostr(Every_N_Weeks-1) +' åÝÊå ÏÑ ãíÇä'
      end
   else  if ClassType = UReccMonthly then
      with UreccMonthly(Self) do begin
           if DayOfMonth > 0 then begin
              Result := ' ÑæÒ ' + inttostr(DayOfMonth) +' Çã ';
              if EveryNMonth = 1 then
                 Result := Result + ' åÑ ãÇå '
              else
                 Result := Result + ' åÑ ãÇå '+inttostr(EveryNMonth-1)+' ãÇå ÏÑ ãíÇä'
           end else begin
              case MonthWeek of
                 0 : Result := 'Çæáíä';
                 1 : Result := 'Ïæãíä';
                 2 : Result := 'Óæãíä';
                 3 : Result := 'åÇÑãíä';
              end;
              Result := Result + ' ' + WeekDayName(WeekDay+1) +' åÑ ãÇå ';
           end;
      end
   else Result:= 'ÞÑÇÑ ÊßÑÇÑ í äÇãÔÎÕ';
   Result:= Result + ' ÇÒ ÓÇÚÊ '+TimeToStr(StartHour)+' ÊÇ '+TimeToStr(StartHour + Duration);
   Result := Result+ ' ÇÒ ' + Organizer.Shamsi(StartDate);
   if EndDate > 0 then
      Result := Result + ' ÊÇ ' + Organizer.Shamsi(EndDate)
   else if After_N_Ocuur > 0 then
      Result := Result + ' ÈÑÇí '+ inttostr(After_N_Ocuur)+' ÌáÓå '
   else
      Result:= Result + ' Èå ÈÚÏ ';

end;

function UReccDaily.OccuresAt(dt: TdateTime; var hrFrom,
  hrTo: TdateTime): boolean;
var
 st, et : TdateTime;
 cnt : integer;
begin
   Result:= false;
   st := StartDate;
   et := int(StartDate + StartHour + Duration);
   cnt := 0;
      while true do begin
          cnt := cnt +1;
          if (After_N_Ocuur > 0) then begin
             if (cnt > After_N_Ocuur) then
                 break;
          end
          else if EndDate > 0 then begin
                  if et > EndDate then
                     break;
               end
          else if st > dt then // endless Reccuring Appointment
                  break;

          if (st <= dt) and (et >= dt) then
             if not (EveryWeekDay and Organizer.isHoliday(dt)) then begin
                Result:= true;
                if st < dt then
                   hrFrom := dt
                else
                   hrFrom:=  dt + StartHour;
                if et > dt then
                   hrTo := dt + 1 - 1/86400
                else
                   hrTo := dt+ frac(StartHour + Duration);
                break;
            end;
          if Every_N_Days > 0 then begin
             st := st + Every_N_Days;
             et := et + Every_N_Days;
          end else begin // else if EvereyWeekDay
             // make shure this is not holiday // to be completed
             st := st + 1;
             et := et + 1;
          end;
      end;

end;

procedure UReccPattern.UpdatePattern;
begin
   Organizer.UpdateRecurrence(self);
end;

{ UReccMonthly }

function UAppointment.OccuresAt(dt: TdateTime ; var hrFrom, hrTo : TdateTime): boolean;
begin
   //  look to see wether  this appointment occuring at a specified date
   //  also looking to see if this appointment is a Recurring one
     Result:= False;
     if Recurrence = nil then begin
         Result := (StartTime <= dt+1-1/86400) and (EndTime >= dt);
         if Result then begin
            if StartTime > dt then
               hrFrom := StartTime
            else
               hrFrom:=dt;
            if EndTime < dt+1 then
               hrTo := EndTime
            else
               hrTo := dt+ 1 - 1/86400;
         end;
     end else if dt >= Recurrence.StartDate then
                  if (Recurrence.EndDate <> 0) then begin
                     if dt <=Recurrence.EndDate  then
                        Result:= Recurrence.OccuresAt(dt, hrFrom, hrTo);
                  end else
                        Result:= Recurrence.OccuresAt(dt, hrFrom, hrTo);
end;

{ UReccMonthly }
procedure MonthData(dt : TDateTime ; var mon, day, MonthDays : integer; var  dtNextMonth, dtNMonth : TDateTime; NMonth: integer; var  FDayofWeek: integer );
var
 s1, s2, sDate: string;
 year, m : integer;
 dt1 : TdateTime;
begin
 sDate := Organizer.Shamsi(dt);
 day := StrToInt(Copy(sDate,7,2));
 mon   := StrToInt(Copy(sDate,4,2));
 year := StrToInt(Copy(sDate,1,2));
 s1 := StringReplace(Format('%2d/%2d/%2d',[year, mon, 1]),' ','0', [rfReplaceAll]);
 m := mon;
 if m = 12 then
    year := year +1;
 m := m mod 12 + 1;
 s2 := StringReplace(Format('%2d/%2d/%2d',[year, m, 1]),' ','0', [rfReplaceAll]);
 dt1:= Organizer.miladi(s1);
 FDayofWeek := DayofWeek(dt1) mod 7 + 1;
 MonthDays := trunc(Organizer.Miladi(s2)- dt1);
 dtNextMonth := Organizer.Miladi(StringReplace(Format('%2d/%2d/%2d',[year, m, 1]),' ','0', [rfReplaceAll]));
 year := year + (NMonth div 12);
 m := (mon+ NMonth-1) mod 12 + 1;
 dtNMonth := Organizer.Miladi(StringReplace(Format('%2d/%2d/%2d',[year, m, 1]),' ','0', [rfReplaceAll]));
end;



function UReccMonthly.OccuresAt(dt: TdateTime; var hrFrom,
  hrTo: TdateTime): boolean;
var
 dtEndofMonth, dtNextMonth, dtNMonth, st, et, edate : TdateTime;
 dif, dowm, cnt, mwd, dow : integer;
 dtadv : integer;
 dayst, monst, daydt, mondt, monthDays, maxDay : integer;
begin
   Result:= false;
   st := StartDate;
   et := int(StartDate + StartHour + Duration);
   cnt := 0;
   MonthData(dt,mondt, daydt, monthDays, dtNextMonth, dtNMonth,EveryNMonth, dowm);
   dow := DayOfWeek(dt);
   if DayOfMonth <= 0 then begin
      if (WeekDay+1) >= dowm then
         dif := (WeekDay+1) - dowm
      else
         dif := 7 + ((WeekDay+1) - dowm);
      if WeekDay =0 then    // Convert to Christian Style
         mwd := 7
      else
         mwd := WeekDay;
   end;

   while true do begin
         cnt := cnt +1;
         if (After_N_Ocuur > 0) then begin
             if (cnt > After_N_Ocuur) then
                 break;
         end
         else if EndDate > 0 then begin
                 if et > EndDate then
                    break;
                 end
         else if st > dt then // endless Reccuring Appointment
                 break;
         MonthData(st,monst, dayst, monthDays,  dtNextMonth, dtNMonth,EveryNMonth, dowm);
         if DayOfMonth > 0 then begin // Example: 14th of each Month
            if (dt >= st) and (dt < dtNextMonth) then begin
               if DayOfMonth > monthDays then
                  maxday := monthDays
               else
                  maxDay := DayOfMonth;
                if  (daydt >= maxday) and  (daydt <=  maxday + Duration) then begin
                     Result:= true;
                     if Daydt > maxday  then
                        hrFrom := dt
                     else
                        hrFrom:=  dt + StartHour;

                     if Daydt < trunc(maxday + Duration) then
                        hrTo := dt + 1 - 1/86400
                     else
                        hrTo := dt+ frac(StartHour + Duration);
                     break;
                end;
            end;
         end  else if dt >= st then begin
                         // Example: The Third Monday of Every Month
                         // First Check to seek if the day is Monday
                         // or is in the range of Monday+Duration
                         // * weekday  0= Saturday, ..., 7= Friday
                        if WeekDay =0 then    // Convert to Christian Style
                           mwd := 7
                        else
                           mwd := WeekDay;
                        if (dow >= mwd) and ( dow <= mwd + duration) then begin // it is Monday or Monday + Duration
                           // Find Date and day of First Monday in the month
                           if (daydt-dif >= MonthWeek * 7 +1) and (daydt-dif < (MonthWeek+1) * 7 +1) then begin
                              Result:= true;
                             if Dow > mwd  then
                                hrFrom := dt
                             else
                                hrFrom:=  dt + StartHour;

                             if Dow < trunc(mwd + Duration) then
                                hrTo := dt + 1 - 1/86400
                             else
                                hrTo := dt+ frac(StartHour + Duration);
                             break;
                           end;
                        end;
             end;

         if EveryNMonth > 1 then begin
            st := dtNMonth;
            et := st + Duration + StartHour;
         end else begin
            st := dtNextMonth;
            et := int(st + Duration + StartHour);
         end;

  end;
end;

{ UReccWeekly }

function UReccWeekly.OccuresAt(dt: TdateTime; var hrFrom,
  hrTo: TdateTime): boolean;
var
 st, et : TdateTime;
 cnt : integer;
 dtadv : integer;
 dow,k : integer;
begin
   Result:= false;
   st := StartDate;
   et := int(StartDate + StartHour + Duration);
   cnt := 0;
   if Every_N_Weeks > 0 then
      dtadv := Every_N_Weeks * 7
   else
      dtadv := 7;
   while true do begin
         cnt := cnt +1;
         if (After_N_Ocuur > 0) then begin
             if (cnt > After_N_Ocuur) then
                 break;
         end
         else if EndDate > 0 then begin
                 if et > EndDate then
                    break;
                 end
         else if st > dt then // endless Reccuring Appointment
                 break;
         if (st <= dt)  and (dt < et + 7) then begin
            k :=0;
            while k < Duration do begin
                 dow := DayOfWeek(dt-k);
                 if ((WeekDays and 1 > 0  ) and (dow = 7) ) or
                    ((WeekDays and 2 > 0  ) and (dow = 1) ) or
                    ((WeekDays and 4 > 0  ) and (dow = 2) ) or
                    ((WeekDays and 8 > 0  ) and (dow = 3) ) or
                    ((WeekDays and 16 > 0 ) and (dow = 4) ) or
                    ((WeekDays and 32 > 0 ) and (dow = 5) ) or
                    ((WeekDays and 64 > 0 ) and (dow = 6) ) then begin
                      Result:= true;
                      if k> 0 then
                         hrFrom := dt
                      else
                         hrFrom:=  dt + StartHour;

                      if k < trunc(Duration) then
                         hrTo := dt + 1 - 1/86400
                      else
                         hrTo := dt+ frac(StartHour + Duration);
                      break;
                  end;
                  k:= k+1;
            end;
            exit;
          end;
          st := st + dtAdv;
          et := et + dtAdv;
  end;
end;


procedure UAppointmentItem.Save(appm : UAppMeeting);
var
  sid, uid, idt: integer;
  rim : boolean;
begin
  uid := Appointment.UserId;
  if appm.Id  = uid then begin
     Save;
     exit;
  end;
  sid := Appointment.SysId;
  idt := Appointment.IdType;
  rim := Appointment.RequiredInMeeting;

  Appointment.mvarSysId:= 0;
  Appointment.IdType := appm.NameType;
  Appointment.UserId:= appm.id;
  Appointment.RequiredInMeeting := appm.Required; 
  Save;
  Appointment.mvarSysId:= sid;
  Appointment.UserId:= uid;
  Appointment.IdType := idt;
  Appointment.RequiredInMeeting := rim;
end;

{ UAppList }

constructor UAppList.Create(UpdateProc, DeleteProc: TNotifyEvent);
begin
   mvarList := TList.Create;
   mvarOnUpdate := UpDateProc;
   mvarOnDelete := DeleteProc;
   mvarCurrentList := nil;
end;

procedure UAppList.DelList(UserId, idType: integer);
var
 i: integer;
 cl: UAppointmentList;
begin
   i :=FindList(UserId, idType);
   if i = -1 then
      exit;
   cl:= UAppointmentList(mvarList[i]);
   mvarList.Delete(i);
   with cl do begin
        CloseAll;
        for i:=  List.Count -1 downto 0 do
            UAppointmentItem(List[i]).Free;
        List.Clear;
        List.free;
        free;
   end;
end;

destructor UAppList.Destroy;
var
 i: integer;
begin
 for i:= mvarList.Count-1 downto 0 do
     DelList(UAppointmentList(mvarList[i]).UserId, UAppointmentList(mvarList[i]).IdType);
 inherited;
end;

function UAppList.FindList(UserId, idType: integer): integer;
var
 i: integer;
begin
  result:= -1;
  for i:= 0 to mvarList.Count-1 do
      if (UAppointmentList(mvarList[i]).UserId = UserId) and
         (UAppointmentList(mvarList[i]).IdType = IdType) then begin
         result:= i;
         break;
      end;
end;

function UAppList.getList: TList;
begin
   Result:= CurrentList.List;
end;

procedure UAppList.NewList(UserId, idType: integer);
var
 ail : UAppointmentList;
begin
  ail:= UAppointmentList.Create(mvarOnUpdate, mvaronDelete, UserId, idType);

  mvarList.Add(ail);
end;

procedure UAppList.setList(UserId, idType: integer);
var
 cl : UAppointmentList;
 i : integer;
begin
 i:= FindList(UserID, idType);
 if i<> -1  then
    mvarCurrentList := mvarList[i]
 else
    showmessage('Internal error(UAppList.setList('+ inttostr(UserId)+')');
end;
function appSort(Item1, Item2 : pointer): integer;
begin
  Result:= 0;
  if UAppointmentItem(Item1).StartTime < UAppointmentItem(Item2).StartTime then
     Result :=-1
  else if UAppointmentItem(Item1).StartTime > UAppointmentItem(Item2).StartTime then
     Result := 1;
end;

procedure UAppointmentList.SortByDateTime;
begin
  Sort( appSort);
end;

end.
