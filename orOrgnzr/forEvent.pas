unit forEvent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Menus, ExtCtrls, ImgList, FDatePicker, dmorgnzr;

type
  UEventName = (uenHoliday, uenBirth, uenDie);
  UEventNames = set of UEventName;
  usg = class(TStringGrid);
  TfrmEvent = class(TForm)
    sg: TStringGrid;
    popRow: TPopupMenu;
    newEvent: TMenuItem;
    mnuEdit: TMenuItem;
    mnuDelete: TMenuItem;
    img: TImageList;
    img1: TImageList;
    N5: TMenuItem;
    mnuEvents: TMenuItem;
    mnuHoliday: TMenuItem;
    mnuBirth: TMenuItem;
    mnuDeath: TMenuItem;
    N11: TMenuItem;
    mnuYear: TMenuItem;
    FDatePicker1: TFDatePicker;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgdblClick(Sender: TObject);
    procedure newEventClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuHolidayClick(Sender: TObject);
    procedure mnuBirthClick(Sender: TObject);
    procedure mnuDeathClick(Sender: TObject);
    procedure mnuEditClick(Sender: TObject);
    procedure sgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuYearxxClicked(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    mvarCurrentDate : TdateTime;
    mvarCurrentYear : integer;
    dtStart, dtEnd : TDateTime;
    procedure FreeTEdit(Sender: TObject);
    procedure FreeDatePicker(Sender: TObject);
    function NotEvent(i: integer; ev : UEventName): boolean;
    procedure setCurrentDate( Value : TDateTime);
    procedure FillGrid;
  public
    { Public declarations }
    property CurrentDate : TDateTime read mvarCurrentDate write setCurrentDate;
  end;
  UEvents = Class
    private
      mvarSysId : integer;
      mvarEvent : UEventNames;
      mvarEventDate: TDateTime;
      mvarDescription : string;
      procedure setEvent( b: UEventNames);
      procedure setDescription( s: string);
      procedure setEventDate( dt : TDateTime);
      procedure Save;
    public
      property SysId : integer read mvarSysId write mvarSysId;
      procedure DrawCheck(can: TCanvas;Rect: TRect; img : TImageList);
      property Event   : UEventNames read mvarEvent write setEvent;
      property Description : string read mvarDescription write setDescription;
      property EventDate : TdateTime read mvarEventDate write setEventDate;
      function isHoliday() : boolean;
  end;
var
  maxdate : TDateTime;
implementation

{$R *.DFM}

procedure TfrmEvent.FormCreate(Sender: TObject);
begin

  sg.Cells[0,0]:='ÊÇÑíÎ';
  sg.Cells[2,0]:='ÔÑÍ';
  sg.RowHeights[0]:= 50;
  sg.ColWidths[0]:= 100;
  sg.ColWidths[1]:= 63;
  FdatePicker1.SendToBack;
end;

procedure TfrmEvent.FormResize(Sender: TObject);
begin
  sg.ColWidths[2]:= sg.Clientwidth- sg.colwidths[0]- sg.colwidths[1]-3;
end;

{ UEvents }

procedure UEvents.setDescription(s: string);
begin
   mvarDescription := s;
end;

procedure UEvents.setEventDate(dt: TDateTime);
begin
  mvarEventDate := dt;
end;

procedure UEvents.setEvent( b: UEventNames);
begin
   mvarEvent := b;
end;

procedure TfrmEvent.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 evObj : UEvents;
 lp : HWND;
 begin
  if arow = 0  then
     case aCol of
        1 :
           begin
                img1.Draw(sg.canvas, Rect.Left+1,  1,0);
                img1.Draw(sg.canvas, Rect.Left+21, 1,1);
                img1.Draw(sg.canvas, Rect.Left+41, 1,2);
           end;
    end;
  if (arow >0)  and (sg.Objects[0,Arow] <> nil) then begin
     evObj := UEvents(sg.Objects[0,Arow]);
     case ACol of
        0 : begin
               FdatePicker1.Miladi := evobj.EventDate;
               FdatePicker1.width  := sg.ColWidths[0]-4;
               FdatePicker1.Height := sg.RowHeights[Arow]-4;
               FdatePicker1.PaintTo(usg(sg).GetDeviceContext(lp),Rect.Left+2,Rect.Top+2);
            end;
        1: evobj.DrawCheck(sg.Canvas, Rect, img);
        2: begin
             sg.Canvas.Font := Font;
             sg.Canvas.Font.Style := Font.Style;
             sg.Canvas.TextOut(Rect.right-4- sg.Canvas.TextWidth(trim(evObj.description)) , Rect.top + 2, evObj.DeScription);
           end;
     end;
  end;
end;

procedure UEvents.DrawCheck(can: TCanvas;Rect: TRect; img : TImageList);
  var
    x, y: integer;
    i: integer;
  begin
   x:= Trunc((Rect.Right - Rect.Left)/3);
   y:=  Rect.top +trunc(((Rect.Bottom - Rect.Top) - img.Height)/3);
   for i:= 0 to 2 do
        if UEventName(i) in mvarEvent then
           img.Draw(can, Rect.Left + i* x,y, i , true)
        else
           img.Draw(can, Rect.Left + i* x,y, 3 , true)
end;

procedure TfrmEvent.sgdblClick(Sender: TObject);
var
 uev : UEvents;
 ev : UEventName;
 cr : TRect;
 r,c : integer;
 pt : TPoint;
 dp : TFDatePicker;
begin
 pt := sg.ScreenToClient(Mouse.CursorPos);
 sg.mousetocell(pt.x,pt.y, c, r);
 if not (r >0) or not (c > -1) then
    exit;
 if (sg.objects[0,r]= nil) then
    exit;

 sg.row:= r;
 uev:=UEvents(sg.objects[0,r]);
 cr:=sg.CellRect(c, r);
 case c of
    0: begin
         sg.col:=0;
         dp:= TFDatePicker.Create(application);
         Organizer.InitHolidays(dp);  
         dp.Left := cr.left;
         dp.top  := cr.top ;
         dp.Height:= sg.DefaultRowHeight;
         dp.width:= Sg.ColWidths[0];
         dp.OnExit := FreeDatePicker;
         dp.Miladi := uev.EventDate;
         dp.ParentFont := false;
         dp.Parent := sg;
         dp.Setfocus;
       end;
    1: begin
         if pt.x > cr.left + (cr.Right- cr.Left) /3 then
            if pt.x > cr.left + 2* (cr.Right- cr.Left) /3 then
               ev:= uendie
            else
               ev:= uenBirth
         else
            ev:= uenHoliday;
         if ev in uev.Event then
            uev.Event := uev.Event - [ev]
         else
            uev.Event := uev.Event + [ev];
         uev.Save;
         sg.Invalidate ;
      end;
    2 :
       mnuEditClick(self);
 end;

end;

procedure TfrmEvent.FreeTEdit(Sender: TObject);
begin
  if sg.objects[0, sg.row] <> nil then
     with UEvents(sg.objects[0, sg.row]) do  begin
          Description := TEdit(sender).Text;
          Save;
     end;
  sender.free;
end;

procedure TfrmEvent.newEventClick(Sender: TObject);
var
 ev : UEvents;
begin
  if sg.Objects[0, sg.RowCount-1] <> nil then
     sg.RowCount := sg.rowCount  + 1;
  ev:= UEvents.Create;
  ev.Event :=  [ uenbirth];
  ev.Description := 'Èå ãäÇÓÈÊ';
  ev.EventDate := maxdate;
  ev.Save;
  sg.Objects[0, sg.RowCount-1] := ev;
  sg.Repaint;
  maxdate:= maxdate+1;
end;

procedure TfrmEvent.mnuDeleteClick(Sender: TObject);
var
 i: integer;
begin
  if sg.objects[0, sg.Row] = nil then
     exit;
  Organizer.EventDelete(sg.objects[0, sg.Row]);
  sg.objects[0, sg.Row].free;
  sg.objects[0, sg.Row] := nil;
  for i:= sg.row to sg.RowCount-2 do
      sg.objects[0, i] := sg.objects[0, i+1];
  if sg.RowCount > (sg.FixedRows + 1) then
     sg.RowCount := sg.RowCount-1;
  sg.Repaint;    
end;

function TfrmEvent.NotEvent(i: integer; ev : UEventName): boolean;
var
 evn: UEventNames;
begin
 if (sg.objects[0,i]= nil) then
    exit;
  evn:= UEvents(sg.Objects[0,i]).Event;
  if ev in evn then
     evn := evn - [ev]
  else
     evn := evn + [ev];
  UEvents(sg.Objects[0,i]).Event := evn;
  Result:= (ev in evn);
end;

procedure TfrmEvent.mnuHolidayClick(Sender: TObject);
begin
  NotEvent(sg.row, uenHoliday);
  sg.Invalidate;
end;

procedure TfrmEvent.mnuBirthClick(Sender: TObject);
begin
  NotEvent(sg.row, uenBirth);
  sg.Invalidate;
end;

procedure TfrmEvent.mnuDeathClick(Sender: TObject);
begin
  NotEvent(sg.row, uenDie);
  sg.Invalidate;
end;


procedure TfrmEvent.mnuEditClick(Sender: TObject);
var
 uev : UEvents;
 cr : TRect;
begin
 uev:=UEvents(sg.objects[0,sg.row]);
 cr := sg.CellRect(2, sg.row);
 with TEdit.Create(self) do begin
     Color := sg.Color;
     Left  := cr.left;
     Top   := cr.top;
     Width := sg.ColWidths[2];
     height := sg.DefaultRowHeight;
     AutoSize := false;
     Parent:= sg;
     Text:= uev.Description;
     onExit   := FreeTEdit;
     ParentBidiMode:= true;
     setfocus;
 end;
end;

procedure TfrmEvent.sgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 r, c : integer;
 pt : TPoint;
begin
 if Button <> mbRight then
    exit;
 sg.MouseToCell(x, y, c, r);
 if r > 0 then
    if sg.objects[0,r] = nil then
       r :=0;

 if  r > 0 then begin
     sg.row := r;
     sg.col:=2;
     mnuHoliday.Checked := not NotEvent(r, uenHoliday);
     NotEvent(r, uenHoliday); // Restore State
     mnuBirth.Checked  := not NotEvent(r, uenBirth);
     NotEvent(r, uenBirth); // Restore State
     mnuDeath.Checked := not NotEvent(r, uenDie);
     NotEvent(r, uenDie); // Restore State
 end;
  mnuEvents.Enabled  := r > 0 ;
  mnuEdit.Enabled := mnuEvents.Enabled;
  mnuDelete.Enabled := mnuEvents.Enabled;
  pt:= sg.ClientToScreen(Point(x,y));
  popRow.Popup(pt.x,pt.y);
end;

procedure TfrmEvent.FreeDatePicker(Sender: TObject);
var
 i: integer;
 dt : TDateTime;
begin
  if sg.objects[0, sg.row] <> nil then
     with UEvents(sg.objects[0, sg.row]) do  begin
          dt:= TFDatePicker(sender).Miladi;
          for i:=1 to sg.rowCount-1 do
              if UEvents(sg.objects[0, i]).EventDate = dt then
                 if i <> sg.row then begin
                    showmessage('Çíä ÊÇÑíÎ ÊßÑÇÑí ÇÓÊ');
                    break;
                 end;
          if i >= sg.rowCount then begin
             EventDate := dt;
             Save;
             if dt >= maxDate then
                maxDate:= dt +1;
          end;
     end;
  sender.free;
end;

procedure TfrmEvent.setCurrentDate(Value: TDateTime);
var
   s : string;
   mi : TMenuItem;
   i, ThisYear: integer;
begin
 mvarCurrentDate := Value;
 s:= FDatePicker1.Shamsi(Value);
 mvarCurrentYear :=  StrToint( Copy(s, 1, StrPos(pchar(s), '/') - pchar(s)));
 dtStart:= FDatePicker1.ToMiladi(inttostr(mvarCurrentYear)+'/01/01');
 dtEnd:= FDatePicker1.ToMiladi(inttostr(mvarCurrentYear+1)+'/01/01')-1;
 s:= FDatePicker1.Shamsi(Date());
 ThisYear:=StrToint( Copy(s, 1, StrPos(pchar(s), '/') - pchar(s)));
 mnuYear.Clear;
 for i:= mvarCurrentYear-3 to mvarCurrentYear+3 do begin
     mi := TMenuItem.Create(self);
     mi.Caption := inttostr(i);
     if i = mvarCurrentYear then
        mi.Checked:= true;
     if i = ThisYear then
        mi.Default := true;
     mi.tag := i;
     mi.OnClick := mnuYearxxClicked;
     mnuYear.Add(mi);
 end;
  FillGrid;
end;

procedure TfrmEvent.FillGrid;
var
  Li : TList;
  i: Integer;
begin
 for i:=0 to sg.rowCount-1 do
     if sg.objects[0,i] <> nil then
        sg.objects[0,i].free;
 sg.rowCount:=2;
 sg.FixedRows := 1;
 sg.objects[0,1]:= nil;
 maxDate := dtStart;
 Li:= Organizer.getEvents(dtStart, dtEnd);
 for i := 0 to li.Count-1 do begin
     sg.rowCount:= i+2;
     sg.objects[0,i+1]:= li[i];
     if Uevents(li[i]).EventDate >=  maxdate then
        maxdate:= Uevents(li[i]).EventDate+1;
 end;
 Li.free;
end;

procedure UEvents.Save;
begin
 Organizer.EventUpDate(self);
end;

procedure TfrmEvent.mnuYearxxClicked(Sender: TObject);
begin
 CurrentDate := FDatePicker1.ToMiladi(inttostr(TMenuItem(Sender).Tag)+'/01/01');
end;

procedure TfrmEvent.FormDestroy(Sender: TObject);
var
 i: integer;
begin
  for i:= 1 to sg.RowCount-1 do
      sg.objects[0,i].free;
end;

function UEvents.isHoliday: boolean;
begin
 result:= uenHoliday in Event;
end;

end.
