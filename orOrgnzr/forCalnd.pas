unit forCalnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, ComCtrls, Menus, ImgList, forEClnd, uorCalnd,
  FCal, math, Mask, uorCtg, forDefs;

type
  TP = class(TPanel)
  public
    property Canvas;
  end;

  TfrmCalendar = class(TForm)
    Panel4: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlAll: TPanel;
    Panel6: TPanel;
    Label1: TLabel;
    lblCalendarDate: TLabel;
    imgCalendar: TImage;
    Panel5: TPanel;
    pnlDocRight: TPanel;
    pnlGrid: TPanel;
    pnlGridTitle: TPanel;
    sg: TStringGrid;
    sgScroll: TScrollBar;
    popTimeBar: TPopupMenu;
    mnuTB60: TMenuItem;
    mnuTB30: TMenuItem;
    mnuTB15: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    mnuTBNewAppointment: TMenuItem;
    mnuTBNewEvent: TMenuItem;
    mnuTBNewRecurrAppointment: TMenuItem;
    mnuTBNewRecurrEvent: TMenuItem;
    ImageList1: TImageList;
    popCalend: TPopupMenu;
    mnuSgNewAppointment: TMenuItem;
    mnuSgNewEvent: TMenuItem;
    MenuItem4: TMenuItem;
    mnuSgNewRecurrAppointment: TMenuItem;
    mnuSgNewRecurrEvent: TMenuItem;
    MenuItem8: TMenuItem;
    mnuSelectToday: TMenuItem;
    mnuSelectDate: TMenuItem;
    Panel1: TPanel;
    Panel7: TPanel;
    pnlTasks: TPanel;
    Cal1: TCal;
    pnlEvents: TPanel;
    Panel9: TPanel;
    popItem: TPopupMenu;
    mnuOpen: TMenuItem;
    mnuPrint: TMenuItem;
    mnuPrivate: TMenuItem;
    mnuCategory: TMenuItem;
    mnuDelete: TMenuItem;
    mnuRemind: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure pnlGridResize(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgScrollChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuTB60Click(Sender: TObject);
    procedure mnuTB30Click(Sender: TObject);
    procedure mnuTB15Click(Sender: TObject);
    procedure Cal1DateChange(Shamsi: String; miladi: TDateTime);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgDblClick(Sender: TObject);
    procedure sgTopLeftChanged(Sender: TObject);
    procedure mnuSelectTodayClick(Sender: TObject);
    procedure mnuSelectDateClick(Sender: TObject);
    procedure pnlEventsDblClick(Sender: TObject);
    procedure mnuSgNewAppointmentClick(Sender: TObject);
    procedure mnuSgNewEventClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuPrintClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure Cal1SpecialDay(dt: TDateTime; var fs: TFontStyles;
      var fc: TColor);
    procedure Cal1MonthPageChange(year,mon: integer);
    procedure sgDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure sgDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure mnuCategoryClick(Sender: TObject);
    procedure mnuPrivateClick(Sender: TObject);
    procedure mnuRemindClick(Sender: TObject);
    procedure mnuSgNewRecurrAppointmentClick(Sender: TObject);
    procedure mnuSgNewRecurrEventClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    mvarOnClose : TNotifyEvent;
    UserEventsList : TList;
    dayEvents : UAAppointmentItems;
    mvarMonthEvents : TDateTimeArray;
    mvarSYSTimeSegment : UTimeSegment;
    procedure CalRefresh;
    function  NewAppointment: UAppointmentItem;
    procedure setSYSTimeSegment(seg : UTimeSegment);
    procedure RestorePanelColors(Sender: TWinControl);
    procedure GotoWorkingHour(dt: TDateTime);
    function InterSectCount( st, et: TDateTime): integer;
    procedure Recalculate;
    property SYSTimeSegment : UTimeSegment read mvarSYSTimeSegment write setSYSTimeSegment default ts60m;
    { Private declarations }
  public
    { Public declarations }
    property  onClose : TNotifyEvent read mvarOnClose write mvaronClose;
    procedure RefreshView;
  end;

var
  WorkendTime, WorkStartTime: TDateTime;
  SelItem: UAppointmentItem;
  maxcnt : integer;

implementation

uses uorTask, dbTables, forTskPd, dmorgnzr, forGDate, forEvent;
var
 PageDate : TDateTime;

{$R *.DFM}

procedure TfrmCalendar.FormCreate(Sender: TObject);
begin
  RestorePanelColors(TWinControl(Sender));
  WorkStartTime:= organizer.WorkingStartHour ;
  WorkendTime:= organizer.WorkingEndHour;
  sg.Color:= clBtnFace;
  sg.Col:=2;
  sg.Row:=0;
  PageDate:=0;
  Organizer.InitHolidays(Cal1);
  mnuSelectTodayClick(nil);
end;

procedure TfrmCalendar.RestorePanelColors(Sender: TWinControl);
var
i: integer;
begin
  with Sender do
    for i:=0 to ControlCount-1 do
        if Controls[i].ClassType = TPanel then begin
           if Controls[i].tag <> 1 then
              TPanel(Controls[i]).Color := clbtnFace;
           RestorePanelColors(TWinControl(Controls[i]));
        end;
end;


procedure TfrmCalendar.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with sg.Canvas do begin
      if Acol = 2 then begin
         if (UTimeStamp(Sg.Objects[0,ARow]).Time <= WorkendTime) and (UTimeStamp(Sg.Objects[0,ARow]).Time >= WorkStartTime) then
             brush.Color:= clWhite
         else
             brush.Color:= clbtnFace;
         if Arow = sg.Row then
            brush.Color:= clMaroon;
         pen.Width :=1;
         Rect.Bottom:= Rect.Bottom+1;
         Pen.Color:= clGray;
         Rectangle(Rect);
         exit;
      end;
      if ACol = 1 then begin
         Moveto(Rect.Left,Rect.Top);
         LineTo(Rect.Left, Rect.Bottom);
         Moveto(Rect.Right,Rect.Top);
         LineTo(Rect.Right,Rect.Bottom);

         exit;
      end;

       brush.Color := clBtnFace;
       brush.style := bsSolid;
       pen.Color   := clBtnText;

       FillRect(Rect);
       case SYSTimeSegment of
             ts60m :
                 begin
                      MoveTo( Rect.Left +  6, Rect.Top );
                      Lineto( Rect.Left + 48, Rect.Top);
                      Font.Size:=8;
                      TextOut(Rect.Left+ 20 - TextWidth(UTimeStamp(sg.Objects[0,ARow]).HourText),Rect.Top+1, UTimeStamp(sg.Objects[0,ARow]).HourText+':00');
                 end;
             ts30m :
                 begin
                    MoveTo( Rect.Left +  6, Rect.Top );
                    if Arow mod 2 <> 0 then
                       Lineto( Rect.Left + 21 , Rect.Top)
                    else
                       Lineto( Rect.Left + 48 , Rect.Top);
                    if (Arow mod 2) = 0 then
                       TextOut(Rect.Left+6,Rect.Top+5,'00');
                    Font.Size:= 12;
                    Font.Style :=  [fsBold];
                    TextOut(Rect.Left+ 48 - TextWidth(UTimeStamp(sg.Objects[0,ARow]).HourText)-1,Rect.Top - (Arow mod 2) * 18+ 6, UTimeStamp(sg.Objects[0,ARow]).HourText);
                 end;

             ts15m :
                 begin
                    MoveTo( Rect.Left +  6, Rect.Top );
                    if Arow mod 4 <> 0 then
                       Lineto( Rect.Left + 21 , Rect.Top)
                    else
                       Lineto( Rect.Left + 48 , Rect.Top);
                    if (Arow mod 4) = 0 then
                       TextOut(Rect.Left+6,Rect.Top+5,'00');
                    Font.Size:= 12;
                    Font.Style:= [fsBold];
                    TextOut(Rect.Left+ 48 - TextWidth(UTimeStamp(sg.Objects[0,ARow]).HourText)-1,Rect.Top - (Arow mod 4) * 18+ 6, UTimeStamp(sg.Objects[0,ARow]).HourText);
                 end;

       end;
  end;
end;

procedure TfrmCalendar.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect:=  ACol =2;
  if CanSelect then
     sgScroll.Position := arow;
end;

procedure TfrmCalendar.GotoWorkingHour(dt: TDateTime);
var
i,r: integer;

begin
  r:=0;
  for i:=0 to sg.rowCount -1 do
      if UTimeStamp(sg.Objects[0,i]).Time <= dt then
         r :=i;
  sg.toprow:=0;
  sg.row:=r;
  sgTopLeftChanged(sg);
  sg.Repaint;
end;

procedure TfrmCalendar.setSYSTimeSegment(seg: UTimeSegment);
 var
 i,j: integer;
 utm : UTimeStamp;
//  tpstart, tpend : TDateTime;
 tp: UAppointmentItem;
 st, et, dt ,rt1: TDateTime;
 dx,h : real;
 list : TList;
 apis : ^UAAppointmentItems;
begin
   // Save Last Hour or Row ,  we were in
   if sg.objects[0,sg.Row] <> nil then
      dt:=  UTimeStamp(sg.objects[0,sg.Row]).Time
   else
      dt := PageDate + WorkStartTime;

   // Free Memory and Previously allocated Edit Controls
   for i:=0 to sg.RowCount-1 do
       if sg.objects[0,i] <> nil then begin
           UTimeStamp(sg.objects[0,i]).Free;
           sg.objects[0,i] := nil;
       end;

   List := mvarAppList.getlist;
   for i:=0 to list.Count-1 do
       UAppointmentItem(List[i]).FreeEditControl;

   setlength(DayEvents,0);
   mvarSYSTimeSegment := seg;
   case seg of
      ts60m : sg.RowCount:= 24;
      ts30m : sg.RowCount:= 48;
      ts15m : sg.RowCount:= 96;
   end;
   for i:=0 to sg.RowCount-1 do begin
      utm:= UTimeStamp.Create;
      utm.setHour(i,seg);
      sg.Objects[0,i]:= utm;
   end;
   dx := UTimeStamp(sg.Objects[0,1]).Time  - UTimeStamp(sg.Objects[0,0]).Time- 1/864000; // -1/10 second
   Recalculate;
   for i:= 0 to list.Count-1 do begin
       tp := UAppointmentItem(List[i]);
       if not tp.Appointment.OccuresAt(PageDate+1/86400, st, et) then
          Continue;
       if not tp.Appointment.AllDayEvent then begin
          for j:=0 to sg.RowCount-1 do begin
                 rt1 := PageDate + UTimeStamp(sg.Objects[0,j]).Time;
                 if (st >= rt1) and (st < rt1 + dx) then begin
                    apis := @UTimeStamp(sg.objects[0,j]).Appointments;
                    setlength(apis^, high(apis^)+2);
                    apis^[high(apis^)] := tp;

                    tp.EditControl := TorEdit.Create(self);
                    tp.StartRow := j;
                    h := ( et - st) /dx;
                    if h < 1 then
                       h:=1
                    else
                       h:= round(h);
                    tp.Rows := trunc(h);
                    tp.Height := trunc(H * sg.DefaultRowHeight);
                    tp.EditControl.Parent := sg;
                    break;
                 end;
         end; // end for j
     end else  // all day event
       if tp.Appointment.OccuresAt(PageDate, st, et) then
          if (st <= PageDate+1-1/86400 ) and (et >= PageDate) then begin
                tp.EditControl := TorEdit.Create(self);
                setlength(DayEvents, high(DayEvents)+2);
                DayEvents[high(DayEvents)]:= tp;
                tp.EditControl.Parent := pnlEvents;
                tp.EditControl.Top := 5;
                tp.EditControl.left := 5;
                tp.EditControl.width := sg.ColWidths[2] - 10;
                tp.EditControl.Height := sg.RowHeights[0];
                tp.EditControl.Visible := true;
                TorEdit(tp.EditControl).text := tp.Appointment.subject;
                if high(DayEvents) > 0 then
                   with DayEvents[high(DayEvents)-1] do
                        tp.EditControl.Top := EditControl.top + EditControl.Height + 5;
         end;

  end; // end for i
  i:=16+(high(DayEvents)+1) * (sg.DefaultRowHeight+5);
  pnlEvents.Height := i + (pnlGrid.Height - i) mod sg.DefaultRowHeight ;
  sgScroll.min:=0;
  sgScroll.max:= sg.RowCount-1;
  GoToWorkingHour(StrToTime(TimeToStr(dt)));
  Cal1.Repaint;
end;


procedure TfrmCalendar.sgScrollChange(Sender: TObject);
begin
 sg.row:= sgscroll.Position;
end;
procedure TfrmCalendar.CalRefresh;
var
 sh : string;
begin
  if Organizer.ShamsiDate then begin
     sh := cal1.Shamsi(PageDate);
     Cal1MonthPageChange(strToInt(Copy(sh,1,2)),strToInt(Copy(sh,4,2)));
  end
  else begin
     sh := FormatDateTime('yyyy/mm/dd', PageDate);
     Cal1MonthPageChange(strToInt(Copy(sh,1,4)),strToInt(Copy(sh,6,2)));
  end;

  Cal1.Repaint;
end;

procedure TfrmCalendar.FormShow(Sender: TObject);
begin
  SYSTimeSegment:=SYSTimeSegment; // force refresh
  sg.SetFocus;
end;

procedure TfrmCalendar.sgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 ac, ar : integer;
 p: TPoint;
 ai : UAppointmentItem;
 ctrl : TControl;
 begin
  if button <>  mbRight then
     exit;
  ai:= nil;
  ctrl := sg.ControlAtPos(Point(x,y),true, true);
  if ctrl <> nil then
     if ctrl.ClassType = TorEdit then
        ai:=TorEdit(ctrl).AppointmentItem;

  sg.MouseToCell(x,y, ac ,ar);
  p:=sg.clientToScreen(POINT(x,y));
  if ai <> nil then begin
     mnuPrivate.checked := ai.Appointment.Privacy;
     popItem.Popup(p.x,p.y);
     selItem := ai;
  end else
      if ac = 0 then
         popTimeBar.Popup(p.x,p.y)
      else
         popCalend.Popup(p.x,p.y);

  sg.row := ar;
end;

procedure TfrmCalendar.mnuTB60Click(Sender: TObject);
begin
  SYSTimeSegment := ts60m;
  mnuTB60.Checked := true;
end;

procedure TfrmCalendar.mnuTB30Click(Sender: TObject);
begin
  SYSTimeSegment := ts30m;
  mnuTB30.Checked := true;
end;

procedure TfrmCalendar.mnuTB15Click(Sender: TObject);
begin
   SYSTimeSegment := ts15m;
   mnuTB15.Checked := true;
end;

procedure TfrmCalendar.Cal1DateChange(Shamsi: String; miladi: TDateTime);
var
  sdate : string;
  i: integer;
begin
 if Copy(Shamsi,0,6) <> Copy(Cal1.Shamsi(PageDate),0,6) then begin
    sdate := Copy(Shamsi, 0, strrscan(pchar(Shamsi), '/') - pchar(Shamsi))+'/01';
 end;
 PageDate := miladi;
 lblCalendarDate.Caption := Cal1.DateName(PageDate, dnDayMonthYear);
 pnlgridtitle.caption    := Cal1.DateName(PageDate, dnWeekDay_DayMonth);
 if UserEventsList <> nil then
     for i:= 0 to UserEventsList.Count-1 do
           with UEvents(UserEventsList[i]) do
                if EventDate = PageDate then
                   pnlgridtitle.caption := pnlgridtitle.caption + ' '+ Description;


 SYSTimeSegment:=SYSTimeSegment; // force refresh
end;


procedure TfrmCalendar.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  if UserEventsList <> nil then begin
     for i:= 0 to UserEventsList.Count-1 do
         UEvents(UserEventsList[i]).free;
     UserEventsList.free;
  end;
  setLength(mvarMonthEvents,0);
  setlength(DayEvents,0);
  Release;
  if Assigned(onClose) then
      OnClose(self);
end;

procedure TfrmCalendar.sgDblClick(Sender: TObject);
var
  ai: UAppointmentItem;
  ctrl : TControl;
begin
  ai:= nil;
  ctrl := sg.ControlAtPos(sg.ScreenTOClient(Mouse.CursorPos),true, true);
  if ctrl <> nil then
     if ctrl.ClassType = TorEdit then
        ai:=TorEdit(ctrl).AppointmentItem;
  if ai = nil then
     ai:= NewAppointment();
  ai.edit(PageDate);
end;

procedure TfrmCalendar.Recalculate;
var
 i,j,k, cnt: integer;
 at : array of integer;
 dif: real;
 dt1, dt2, st, et : TdateTime;
 list : TList;
begin
   List := mvarAppLIst.getList;
   maxcnt :=0;
   dif := UTimeStamp(sg.Objects[0, 1]).Time - UTimeStamp(sg.Objects[0, 0]).Time- 1/86400; // minus 1 second
   for i:=0 to sg.rowCount-1 do begin
       st:= PageDate + UTimeStamp(sg.Objects[0, i]).Time;
       et:= st + dif;
       cnt := InterSectCount(st, et);
       if cnt > maxcnt then
          maxcnt:= cnt;
   end;
   for i:=0 to List.Count-1 do
       with UAppointmentItem(List[i]) do
             LeftPos := -1; // not Calculated state
   setlength(at,maxcnt);
   for i:=0 to sg.rowCount-1 do begin
       st:= PageDate + UTimeStamp(sg.Objects[0, i]).Time;
       et:= st + dif;
       for j:=0 to high(at) do
           at[j]:= j; // filling Width array for each calculation

       for j:= 0 to List.count-1 do
           with UAppointmentItem(List[j]) do
                if (not Appointment.AllDayEvent) and (LeftPos <> -1) then
                    if Appointment.OccuresAt(PageDate,dt1, dt2) then
                       if (dt1 <= et ) and  ( dt2 >= st ) then
                          at[LeftPos] := -1; // Position is Reservered

       for j:= 0 to List.count-1 do
           with UAppointmentItem(List[j]) do
                if (not Appointment.AllDayEvent) and (LeftPos = -1) then
                   if Appointment.OccuresAt(PageDate,dt1, dt2) then
                       if (dt1 <= et ) and  ( dt2 >= st ) then
                          for k:= 0 to high(at) do
                             if at[k] <> -1 then begin
                                LeftPos := k;
                                at[k]:=-1; // fill the Position
                                break;
                             end;
   end;
   setlength(at,0);
end;

function TfrmCalendar.InterSectCount(st, et: TDateTime): integer;
var
 i,cnt: integer;
 List : TList;
 dt, dt1, dt2 : TDateTime;
begin
   List:= mvarAppList.getList;
   cnt:=0;
   dt := int(st); // st and et are in the same day
   for i:=0 to List.count - 1 do
       with UAppointmentItem(List[i]).Appointment do
            if (not AllDayEvent) then
                if OccuresAt(dt, dt1, dt2) then
                   if ( dt1 <= et ) and  ( dt2 > st ) then
                       inc(cnt);
   result:= cnt;
end;

procedure TfrmCalendar.sgTopLeftChanged(Sender: TObject);
var
 apis: ^UAAppointmentItems;
 i,j, cnt: integer;
 nw : integer;
 tr: TRect;
begin
   if sg.objects[0,0] = nil then
      exit;
   cnt:= sg.TopRow + sg.VisibleRowCount-1;
   for j:=0 to sg.RowCount -1 do begin
       apis := @UTimeStamp(sg.objects[0,j]).Appointments;
       if (high(apis^) >=0) then begin
          for i:=0 to high(apis^) do
              with apis^[i] do begin
                  EditControl.Visible :=((StartRow+ Rows-1) >= sg.TopRow) and (StartRow <= cnt);
                  if EditControl.Visible then
                     if StartRow = j then begin
                       if j < sg.toprow then begin
                          tr := sg.CellRect(2,sg.toprow);
                          tr.top := tr.top - (tr.Bottom - tr.top)* (sg.toprow-j);
                       end else
                         tr := sg.CellRect(2,j);
                       EditControl.top   := tr.top+1;
                       EditControl.Height := Height;
                       EditControl.Text  := Appointment.Subject;

                       nw:= trunc((tr.Right- tR.Left) / maxcnt);
                       EditControl.Width := nw;
                       EditControl.Left := tr.Right - nw * (LeftPos+1) + 7 - tr.Left;
                     end else EditControl.Invalidate;
           end;
       end;
   end;
end;

procedure TfrmCalendar.RefreshView;
begin
  CalRefresh;
  SYSTimeSegment:= SYSTimeSegment;
end;

procedure TfrmCalendar.mnuSelectTodayClick(Sender: TObject);
begin
  if Cal1.ShamsiDate then
     cal1.InitialDate := Cal1.Shamsi(date())
  else
     cal1.InitialDate := DateToStr(Date());
end;

procedure TfrmCalendar.mnuSelectDateClick(Sender: TObject);
var
 gd : TfrmCalGetDate;
begin
 gd:= TfrmCalGetDate.Create(self);
 gd.FDatePicker1.Miladi := PageDate;
 gd.showmodal;
 if gd.ModalResult = mrok then
   if Cal1.ShamsiDate then
     Cal1.InitialDate := Cal1.Shamsi(gd.FDatePicker1.Miladi)
   else
     Cal1.InitialDate := DateToStr(gd.FDatePicker1.Miladi);
 gd.free;
end;

procedure TfrmCalendar.pnlGridResize(Sender: TObject);
var
 i: integer;
 List : TList;
 nw : integer;
 tr : TRect;
begin
 sg.ColWidths[2]:= pnlGrid.Width -59;
 for i:= 0 to high(DayEvents) do
     DayEvents[i].EditControl.Width:= sg.ColWidths[2] - 10;
 tr := sg.CellRect(2,0);  // Subject Column Rectangle
 List := mvarAppList.getList;
 for i:= 0 to List.Count-1 do
     with UAppointmentItem(List[i]) do
       if not Appointment.AllDayEvent then
          if EditControl <> nil then
              If EditControl.Visible then begin
                 nw:= trunc((tr.Right- tR.Left) / maxcnt);
                 EditControl.Width := nw;
                 EditControl.Left := tr.Right - nw * (LeftPos+1) + 7 - tr.Left;
              end;
end;

procedure TfrmCalendar.pnlEventsDblClick(Sender: TObject);
var
  ctrl : TControl;
begin
  ctrl := pnlEvents.ControlAtPos(pnlEvents.ScreenTOClient(Mouse.CursorPos),true, true);
  if ctrl <> nil then
     if ctrl.ClassType = TorEdit then begin
        TorEdit(ctrl).AppointmentItem.edit(PageDate);
     end;
end;

procedure TfrmCalendar.mnuSgNewAppointmentClick(Sender: TObject);
begin
  NewAppointment.edit(PageDate);
end;

function TfrmCalendar.NewAppointment: UAppointmentItem;
var
 ai: UAppointmentItem;
begin
   ai:=UAppointmentItem.Create;
   with ai.Appointment do begin
        StartTime := PageDate+UTimeStamp(Sg.Objects[0,sg.Row]).Time;
        case SYSTimeSegment of
            ts60m : EndTime := ai.StartTime + 60/1440;
            ts30m : EndTime := ai.StartTime + 30/1440;
            ts15m : EndTime := ai.StartTime + 15/1440;
        end;
        AppType := ctnBusy;
   end;
   Result:= ai;
end;
procedure TfrmCalendar.mnuSgNewEventClick(Sender: TObject);
begin
  with NewAppointment do begin
       Appointment.AllDayEvent := true;
       edit(PageDate);
  end;
end;

procedure TfrmCalendar.FormDestroy(Sender: TObject);
var
 List : TList;
 i: integer;
begin
   List := mvarAppList.getList;
   for i:=0 to list.Count-1 do
       UAppointmentItem(List[i]).FreeEditControl;
   setLength(mvarMonthEvents,0);
end;

procedure TfrmCalendar.mnuOpenClick(Sender: TObject);
begin
 SelItem.Edit(PageDate);
end;

procedure TfrmCalendar.mnuPrintClick(Sender: TObject);
var
i: integer;
ar : UAAppointmentItems;
begin
   ar:= nil;
   if SelItem <> nil then begin
      setLength(ar, high(ar)+2);
      ar[high(ar)]:= SelItem;
      UAppointmentItem.PrintOut(ar);
   end;
end;

procedure TfrmCalendar.mnuDeleteClick(Sender: TObject);
begin
   SelItem.Delete;
   CalRefresh; 
end;

procedure TfrmCalendar.Cal1SpecialDay(dt: TDateTime; var fs: TFontStyles;
  var fc: TColor);
var
  i, cnt: integer;
begin
  cnt := high(mvarMonthEvents);
  for i := 0 to cnt  do begin
      if dt = TdateTime(mvarMonthEvents[i]) then begin
          fs:= [fsbold, fsitalic];
          break;
      end;
  end;
  if UserEventsList <> nil then
      for i:= 0 to UserEventsList.Count-1 do
         with UEvents(UserEventsList[i]) do begin
              if dt = EventDate then
                 if isHoliday() then begin
                    fc:= clRed;
                    break;
                 end else begin
                    fc:= clBlue;
                    break;
                 end;
        end;
end;

procedure TfrmCalendar.Cal1MonthPageChange(year,mon: integer);
var
 hrFr, Hrto, dts, dte : TDateTime;
 i : integer;
 LI, List : TList;
 begin
  if Cal1.ShamsiDate then
     dts := Cal1.Miladi(StringReplace(Format('%2d/%2d/%2d',[year, mon, 1]),' ','0', [rfReplaceAll]))
  else
     dts := EncodeDate(Year, Mon, 1);

  dte := cal1.IncrementMonth(dts,1) -1;

  setLength(mvarMonthEvents,0);
  if UserEventsList <> nil then begin
     for i:=0 to UserEventsList.count-1 do
         UEvents(UserEventsList[i]).free;
     UserEventsList.free
  end;

  UserEventsList := Organizer.getEvents(dts, dte);
  List := mvarAppList.getList;
  while dts <= dte do begin
    for i:= 0 to List.Count - 1 do
        if  UAppointmentItem(List[i]).Appointment.OccuresAt(dts+1/86400, hrFr, hrto) then  begin
            setLength(mvarMonthEvents,high(mvarMonthEvents)+2);
            mvarMonthEvents[high(mvarMonthEvents)]:= dts;
            break;
        end;
    dts := dts +1;
  end;
end;

procedure TfrmCalendar.sgDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:= (Source= Organizer.TasksPad.img);
end;

procedure TfrmCalendar.sgDragDrop(Sender, Source: TObject; X, Y: Integer);
var
 i,r,c: integer;
 ai: UAppointmentItem;
 ti : UTaskItem;
 pt: TPoint;
begin
  sg.MouseToCell(x,y, c, r);
  if (c <0 ) or (r <0) then
      exit;
  sg.row := r;
  with Organizer.TasksPad do
       for i:= 0 to lv.Items.count-1 do
           if lv.Items[i].Selected then begin
              ai:=NewAppointment;
              ti:= UTaskItem(lv.Items[i].Data);
              ai.Appointment.Subject:= ti.Task.Subject;
              ai.Appointment.Attachments := ti.Task.Attachments;
              ai.Appointment.Categories := ti.Task.Categories;
              ai.Appointment.Privacy := ti.Task.Privacy;
              ai.Appointment.ReminderTime :=0;
              ai.Edit(PageDate);
              TfrmEditApp(ai.Form).AppChange := true; 
           end;

end;

procedure TfrmCalendar.mnuCategoryClick(Sender: TObject);
var
 ctg : UCategory;
 cat : string;
begin
   if SelItem = nil then
      exit;
   cat:= SelItem.Appointment.Categories;

   ctg := UCategory.Create;
   if ctg.Execute(cat) then begin
      SelItem.appointment.Categories:= cat;
      SelItem.Save;
   end;
   ctg.free;
end;

procedure TfrmCalendar.mnuPrivateClick(Sender: TObject);
begin
   if SelItem = nil then
      exit;
   SelItem.Appointment.Privacy := not SelItem.Appointment.Privacy;
   SelItem.Save;
end;

procedure TfrmCalendar.mnuRemindClick(Sender: TObject);
begin
   if SelItem = nil then
      exit;
   SelItem.Appointment.ReminderTime  := SelItem.Appointment.StartTime - 15/1440;
   SelItem.Save;

end;

procedure TfrmCalendar.mnuSgNewRecurrAppointmentClick(Sender: TObject);
var
 ai: UAppointmentItem;
 rw : UReccWeekly;
begin
  rw:= UReccWeekly.Create;
  ai:= NewAppointment;
  ai.Appointment.Recurrence := rw;
  with rw do begin
       id :=0;
       StartDate := PageDate;
       StartHour := frac(ai.appointment.StartTime);
       Duration  := ai.appointment.EndTime - ai.appointment.StartTime;
       Every_N_Weeks :=1;
       WeekDays := 1;
  end;
  ai.edit(PageDate);

end;

procedure TfrmCalendar.mnuSgNewRecurrEventClick(Sender: TObject);
var
 ai: UAppointmentItem;
 rw : UReccWeekly;
begin
  rw:= UReccWeekly.Create;
  ai:= NewAppointment;
  ai.Appointment.Recurrence := rw;
  with rw do begin
       id :=0;
       StartDate := PageDate;
       StartHour := frac(ai.appointment.StartTime);
       Duration  := ai.appointment.EndTime - ai.appointment.StartTime;
       Every_N_Weeks :=1;
       WeekDays := 1;
  end;
  ai.Appointment.AllDayEvent := true;
  ai.edit(PageDate);
end;

procedure TfrmCalendar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 113) then begin
     Organizer.ShamsiDate := not Organizer.ShamsiDate;
     Cal1.ShamsiDate := Organizer.ShamsiDate;
     CalRefresh;
  end;
end;

end.



