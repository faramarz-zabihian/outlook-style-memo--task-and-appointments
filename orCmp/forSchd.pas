unit forSchd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FCal;

type
  UOnDrawRow = procedure (const row : integer; FromDate, ToDate : TdateTime; var Color: TColor; var State: boolean) of object;
  UPanel = Class(TPanel)
  private
    function getScheduledRows: integer;
     private
       mvarCal : TCal;
       mvarColumns : integer;
       mvarRows   : integer;
       PanelStartTime : TDateTime;
       mvarScheduledRows : integer;
       mvarOnDrawRow : UOnDrawRow;
       mvarAppStartTime, mvarAppEndTime   : TDateTime;
       property ScheduledRows : integer read getScheduledRows;
       function AddTime(hrs : integer): TDateTime;
     public
      property Columns : integer read mvarColumns write mvarColumns;
      property Rows : integer read mvarRows write mvarRows;
     protected
      procedure resize;override;
      procedure paint;override;
  end;
  TfrmSchd = class(TFrame)
    hs: TScrollBar;
    LSplit: TPanel;
    LSPImg: TImage;
    RSplit: TPanel;
    RSIMG: TImage;
    procedure hsScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure LSPImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LSplitMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure SplitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FrameResize(Sender: TObject);
  private
    tcp : UPanel;
    spl : TPanel;
    LastPosition : integer;
    function getAppEndTime: TDateTime;
    function getAppStartTime: TDateTime;
    procedure setAppEndTime(const Value: TDateTime);
    procedure setAppStartTime(const Value: TDateTime);
    procedure setShamsiDate(const Value: boolean);
    function getShamsiDate: boolean;
    procedure LSplitMouseMove(X : Integer);
    procedure RSplitMouseMove(X : Integer);
    procedure RepositionBars;
    procedure setIsWorkingHours(const Value: boolean);
    procedure setWorkEndHour(const Value: TdateTime);
    procedure setWorkStartHour(const Value: TdateTime);
    function getIsWorkingHours: boolean;
    function getWorkEndHour: TdateTime;
    function getWorkStartHour: TdateTime;
    function getScheduledRows: integer;
    procedure setScheduledRows(const Value: integer);
    function getOnDrawRow: UOnDrawRow;
    procedure setOnDrawRow(const Value: UOnDrawRow);
  public
    { Public declarations }
    NotifyDateTimeChange : procedure (AppStart, AppEnd : TdateTime) of object;
    property  OnDrawRow : UOnDrawRow read getOnDrawRow write setOnDrawRow;
    property  AppointmentStart : TDateTime read getAppStartTime write setAppStartTime;
    property  AppointmentEnd   : TDateTime read getAppEndTime write setAppEndTime;
    property  ShamsiDate : boolean read getShamsiDate write setShamsiDate;
    property  WorkStartHour : TdateTime read getWorkStartHour write setWorkStartHour;
    property  WorkEndHour   : TdateTime read getWorkEndHour   write setWorkEndHour;
    property  IsWorkingHours : boolean read getIsWorkingHours write setIsWorkingHours;
    property  ScheduledRows : integer read getScheduledRows write setScheduledRows;

    Constructor Create(AOwner : TComponent);override;
    destructor  Destroy;override;
  end;
procedure Register;
implementation

var
    mvarWorkStartHour, mvarWorkEndHour : TdateTime;
    mvarIsWorkingHours : boolean;
    SchStart, WrkLen : integer;
{$R *.DFM}

function UPanel.AddTime(hrs : integer): TDateTime;
var
 h, m , s, ms: Word;
 dt: TdateTime;
begin
  dt:= PanelStartTime;
  DecodeTime(dt, h, m, s, ms);
  h:= h - SchStart;
  dt:= dt + (h + (hrs div 2) - 1) div WrkLen;
  h:= (h + (hrs div 2)-1) Mod WrkLen +1 + SchStart;
  if hrs mod 2 > 0 then
     m := m+ 30;
  ReplaceTime(dt, EncodeTime(h, m , s, ms));
  Result := dt;
end;

function Conv(dt : TDateTime): integer;
var
 r : real;
begin
 r:= (frac(dt)- SchStart/24) * 24;
 if r < 0 then
    r:=0;
 if (frac(dt)- (SchStart/24 + WrkLen/24) ) > 0 then
    r:= WrkLen;
 Result:= round( (int(dt) * WrkLen + r) * 30);
end;

{ TFrame2 }

constructor TfrmSchd.Create(AOwner: TComponent);
begin
    inherited;
    tcp := UPanel.Create(self);
    tcp.mvarCal:= Tcal.Create(self);
    hs.BiDiMode := bdRightToLeft;
    with tcp do begin
       ParentFont := true;
       Parent:= self;
       Align := alClient;
       LSplit.Parent := tcp;
       RSplit.PArent := tcp;
    end;
    SchStart :=7;
    tcp.PanelStartTime := Date() + (SchStart+3)/24;
    WrkLen := 9;
    LastPosition := hs.Position ;
    AppointmentStart:= tcp.PanelStartTime + 2/ 24;
    AppointmentEnd  := AppointmentStart + 1/24;

end;

function UPanel.getScheduledRows: integer;
begin
  Result:= mvarScheduledRows;
end;

procedure UPanel.paint;
var
 hiPos,i, j: integer;
 h, m, s , ms : word;
 rc : TRect;
 sh : string;
 FirstTitle, State : boolean;
 SD, phour, nhour : TDateTime;
 bmp : Tbitmap;
 ps : integer;
 clr : TColor;
begin
 DecodeTime(PanelStartTime, h, m, s, ms);
 sd := PanelStartTime;
 h := h - SchStart+1;
 bmp:= Tbitmap.Create;
 bmp.Width := ClientWidth-2;
 bmp.Height:= ClientHeight-2;
 FirstTitle:= True;
 with bmp.Canvas do begin
      TextFlags := ETO_RTLREADING;
      brush.Color := clBtnFace;
      FillRect(ClipRect);
      if Scheduledrows > 0 then begin
         rc.top:= 34;
         rc.bottom:= 51;
         rc.left:= cliprect.left;
         rc.right:= cliprect.right;
         brush.Color := clGray;
         FillRect(rc);
      end;
      ps := Conv(PanelStartTime);
      rc.Right := Width- ((Conv(mvarAppStartTime))- ps);
      rc.left  := Width- (Conv(mvarAppEndTime)- ps);
      rc.top   := 34;
      rc.bottom:= cliprect.Bottom;
      brush.Color := clWhite;
      FillRect(rc);
      if Scheduledrows > 0 then begin
         for i:=0 to Scheduledrows-1 do begin
             rc.left:= cliprect.left;
             rc.right:= cliprect.right;
             rc.top:= 51 + i * 17;
             rc.bottom:= rc.top+17;
             brush.Style:= bsFDiagonal;
             brush.Color := clBlack;
             FillRect(rc);
             if assigned(mvarOnDrawRow) then begin
                State := False;
                mvarOnDrawRow(i+1, PanelStartTime, AddTime(Columns*2), clr, State);
                if State then begin
                   pHour:= PanelStartTime;
                   for j:=1 to Columns*2 do begin // every half an hour
                       nHour:= AddTime(j);
                       State := false;
                       clr:= clBlack;
                       mvarOnDrawRow(i+1, pHour, nHour, clr, State);
                       rc.Left := width- (Conv(nHour) -ps);
                       rc.Right:= width- (Conv(pHour) -ps);
                       brush.Color:= clr;
                       if State then
                          brush.Style:= bsSolid
                       else
                          brush.Style:= bsFDiagonal;
                       FillRect(rc);
                       pHour:= nHour;
                   end;
                end;
             end;
         end;
       end;
      brush.Style:= bsSolid;
      brush.Color := clBtnFace;
      Pen.Color := clGray;
      hiPos := 17;
      Pen.Color := clGray;
      moveto(0       , hiPos);
      LineTo(Width-1 , hiPos);
      inc(hiPos);
      Pen.Color := clWhite;
      moveto(0       , hiPos);
      LineTo(Width-1 , hiPos);
      Font := self.font;
      Font.Color := clBlack;
      for i:= 1 to Columns do begin
          if h mod WrkLen <> 0 then begin
              sh := inttostr(SchStart + (h-1) mod WrkLen+ 1 );
              TextOut(Width - 30 * i - 1,hiPos+1, '00:');
              TextOut(Width - 30 * i - 1 - TextWidth(sh),hiPos+1, sh);
          end else begin
             if not FirstTitle then
                if i > 1 then begin
                    sh:= mvarCal.DateName(sd,dnWeekDay_DayMonth);
                    TextOut(Width + + (WrkLen-i) * 30- 3 - TextWidth(sh), 1, sh);
                    FirstTitle:= true;
                    sd:= sd + 1;
                 end;

              sh:= mvarCal.DateName(sd,dnWeekDay_DayMonth);
              sd:= sd + 1;
              TextOut(Width - 30 * i - 3 - TextWidth(sh), 1, sh);
              Pen.Color := clBlack;
              Pen.Width :=2;
              moveto( Width - i * 30 , 0);
              LineTo( Width - i * 30 , 52);
              Pen.Color := clGray;
              LineTo( Width- i * 30 , Height);
          end;
          inc(h);
      end;
      Pen.Width :=1;

      hiPos := 34;
      Pen.Color := clBlack;
      for i:= 1 to 2 do begin
          moveto(0       , hiPos);
          LineTo(Width-1 , hiPos);
          inc(HiPos, 17);
      end;
      Pen.Color := clGray;
      for i:= 1 to Rows do begin
          moveto(0       , hiPos);
          LineTo(Width-1 , hiPos);
          inc(HiPos, 17);
      end;
      hiPos := 34;
      Pen.Color := clBlack;
      for i:= 1 to Columns do begin
          moveto( Width - i * 30  , hiPos-3);
          LineTo( Width - i * 30  , hiPos + 19);
      end;
      hiPos := Hipos + 17;
      Pen.Color := clGray;
      for i:= 1 to Columns do begin
          moveto( Width - i * 30 , hiPos);
          LineTo( Width - i * 30 , Height - 1);
      end;
      rc:= self.ClientRect;
      Frame3D(Canvas, rc,  clBlack, clWhite,1);
 end;
 Canvas.Draw(1,1, bmp);
 bmp.free;
 TfrmSchd(Parent).RepositionBars;
end;
procedure UPanel.resize;
begin
  inherited;
  Columns := ClientWidth div 30;
  Rows := (ClientHeight-51) div 17;
end;

procedure TfrmSchd.hsScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
var
 h, m, s, ms : word;
 hr : integer;
 sd : TdateTime;
begin

 sd := tcp.PanelStartTime;
 DecodeTime(sd , h, m, s, ms);
 h:= h - SchStart;
 case ScrollCode of
     scLineUp   :    if h < WrkLen-1 then
                        inc(h)
                     else begin
                        h:= 0;
                        sd  := sd+1; // advance one day
                     end;
     scLineDown :
                  if h > 0 then
                     dec(h)
                  else begin
                     h:= WrkLen-1;
                     sd := sd - 1;
                  end;

     scPageDown   : begin
                     hr := h - (16 Mod WrkLen);
                     sd := sd - (16 div WrkLen);
                     if hr < 0 then begin
                        hr:= WrkLen + hr;
                        sd := sd-1;
                     end;
                     h:= hr;
                     end;
     scPageUp : begin
                    h:=(WrkLen + ( h + 16-1) mod WrkLen) mod WrkLen+1;
                    sd:= sd + (16+h) div WrkLen;
                  end;
     scTrack :
                    if ScrollPos > LastPosition then
                       if h < WrkLen -1 then
                          inc(h)
                       else begin
                          h:=0;
                          sd := sd+1;
                       end
                    else if ScrollPos < LastPosition then
                         if h > 0 then
                            dec(h)
                         else begin
                            h:= WrkLen-1;
                            sd := sd-1;
                         end;
     scEndScroll :
           if ScrollPos < 20 * hs.Max /100 then
              ScrollPos := trunc(20 * hs.Max /100)
           else if ScrollPos > 80 * hs.Max/100 then
                 ScrollPos:= trunc(80 * hs.Max/100);
 end;
 ReplaceTime(sd, EncodeTime(SchStart + h, m, s, ms));
 tcp.PanelStartTime:= sd;
 LastPosition := ScrollPos;
 tcp.Repaint;
end;

procedure TfrmSchd.LSPImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  spl := TPanel(TImage(Sender).Parent);
  SetCaptureControl(SPL);
end;
procedure TfrmSchd.LSplitMouseMove(X : Integer);
var
 h, m, s, ms : word;
 dt1, dt2 : TDateTime;
begin
 if ( x > RSplit.Left- SPL.Width-2) then begin
     spl := RSplit;
     SetCaptureControl(RSplit);
     exit;
 end;
 if (x < 1) then
     x :=1;

 x:= tcp.ClientWidth- Round( (tcp.ClientWidth- x)/15) * 15;
 if x >= RSplit.Left then
     x:= RSplit.Left - 15;

  dt1 := tcp.PanelStartTime - SchStart / 24;
  ReplaceDate(dt1,0);
  decodeTime(dt1, h, m, s, ms);
  h:= h + (tcp.ClientWidth - x ) div 30;                   // hours
  m := m + (((tcp.ClientWidth - x) div 15) mod 2 )* 30;   // minutes
  h:= h + m div 60;
  dt2 := tcp.PanelStartTime;
  ReplaceTime(dt2,SchStart / 24);
  AppointmentEnd:=  dt2 + (h div WrkLen) + (h mod WrkLen) /24 + (m mod 60) / 1440;
  tcp.Repaint;
  LSplit.Repaint;
  if Assigned(NotifyDateTimeChange) then
     NotifyDateTimeChange(tcp.mvarAppStartTime, tcp.mvarAppEndTime);

end;

procedure TfrmSchd.RSplitMouseMove(X: Integer);
var
 h, m ,s, ms : Word;
 dt1, dt2 : TDateTime;
begin
  if (x < LSplit.Left + SPL.Width+2) then begin
       spl := LSplit;
       SetCaptureControl(LSplit);
       exit
  end;
  if (x > tcp.ClientWidth - RSplit.Width-1) then
      x := tcp.ClientWidth - RSplit.Width-1;
  x:= tcp.ClientWidth - Round((tcp.ClientWidth -x)/15) * 15;
  if x <= LSplit.Left then
     x:= LSplit.Left + 15;

  dt1 := tcp.PanelStartTime - SchStart / 24;
  ReplaceDate(dt1,0);
  decodeTime(dt1, h, m, s, ms);
  h:= h + (tcp.ClientWidth - x) div 30;                   // hours
  m := m + (((tcp.ClientWidth - x) div 15) mod 2 )* 30;   // minutes
  h:= h + m div 60;
  dt2 := tcp.PanelStartTime;
  ReplaceTime(dt2,SchStart / 24);
  AppointmentStart:=  dt2 + (h div WrkLen) + (h mod WrkLen) /24 + (m mod 60) / 1440;
  tcp.Repaint;
  RSplit.Repaint;
  if Assigned(NotifyDateTimeChange) then
     NotifyDateTimeChange(tcp.mvarAppStartTime, tcp.mvarAppEndTime);
end;


procedure TfrmSchd.LSplitMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;

end;
procedure TfrmSchd.SplitMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 tp : TPoint;
begin
 if not (ssLeft in Shift) then
    exit;
 tp := tcp.ScreenToClient(SPL.ClientToScreen(Point(x,y)));
 if (tp.y < 0) or (tp.y > tcp.ClientHeight) then
     exit;
 if SPL = LSplit then
     LSplitMouseMove(tp.x)
 else
     RSplitMouseMove(tp.x);
end;


procedure TfrmSchd.RepositionBars;
var
 pix : integer;
begin
  pix := Conv(AppointmentStart) - Conv(tcp.PanelStartTime);
  RSplit.Visible := (pix > 0) and (pix < tcp.ClientWidth);
  if RSplit.Visible then
     RSplit.Left := tcp.ClientWidth  - pix;
  pix := Conv(AppointmentEnd)   - Conv(tcp.PanelStartTime);
  LSplit.Visible := (pix > 0) and (pix < tcp.ClientWidth);
  if LSplit.Visible then
     LSplit.Left := tcp.ClientWidth  - pix;
end;


procedure TfrmSchd.FrameResize(Sender: TObject);
begin
  Width := (Width div 15) * 15; 
  LSplit.Height := tcp.ClientHeight - 34;
  RSplit.Height := LSplit.Height;
  LSplit.Top  := 34;
  RSplit.Top  := LSplit.Top;
end;
procedure Register;
begin
  RegisterComponents('Standard', [TfrmSchd]);
end;

function TfrmSchd.getAppEndTime: TDateTime;
begin
   Result:= tcp.mvarAppEndTime;
end;

function TfrmSchd.getAppStartTime: TDateTime;
begin
   Result:= tcp.mvarAppStartTime;
end;

procedure TfrmSchd.setAppEndTime(const Value: TDateTime);
var
 dt : TDateTime;
begin
   tcp.mvarAppEndTime:= Value;
   dt:= Value;
   ReplaceDate(dt,0);
   tcp.Repaint;
end;

procedure TfrmSchd.setAppStartTime(const Value: TDateTime);
var
 dt: TDateTime;
begin
   tcp.mvarAppStartTime:= Value;
   dt:= Value;
   ReplaceDate(dt,0);
   tcp.Repaint;
end;

destructor TfrmSchd.Destroy;
begin
  tcp.mvarCal.free;
  tcp.free;
  inherited;
end;

function TfrmSchd.getShamsiDate: boolean;
begin
  Result:= tcp.mvarCal.ShamsiDate;
end;

procedure TfrmSchd.setShamsiDate(const Value: boolean);
begin
 tcp.mvarCal.ShamsiDate := Value;
end;

procedure TfrmSchd.setIsWorkingHours(const Value: boolean);
begin
  mvarIsWorkingHours := Value;
  tcp.Repaint;
end;

procedure TfrmSchd.setWorkEndHour(const Value: TdateTime);
var
 h, m ,s , ms : word;
begin
  mvarWorkEndHour := Value;
  decodeTime(mvarWorkEndHour, h, m, s, ms);
  if h > SchStart then
     WrkLen := h - SchStart
  else
     WrkLen := 8;
end;

procedure TfrmSchd.setWorkStartHour(const Value: TdateTime);
var
 h, m ,s , ms : word;
begin
  mvarWorkStartHour := Value;
  decodeTime(Value, h, m, s, ms);
  SchStart := h;
  decodeTime(mvarWorkEndHour, h, m, s, ms);
  if h > SchStart then
     WrkLen := h - SchStart
  else
     WrkLen := 8;
  if int(Value) > 0 then begin
     tcp.PanelStartTime:= int(Value)- 1 + (WrkLen-1)/24 + EncodeTime(SchStart, 0,0,0);
  end;

  tcp.Repaint;
end;

function TfrmSchd.getIsWorkingHours: boolean;
begin
  Result:= mvarIsWorkingHours;
end;

function TfrmSchd.getWorkEndHour: TdateTime;
begin
  Result:= mvarWorkEndHour;
end;

function TfrmSchd.getWorkStartHour: TdateTime;
begin
  Result:= mvarWorkStartHour;
end;

function TfrmSchd.getScheduledRows: integer;
begin
  Result:= tcp.mvarScheduledRows;
end;

procedure TfrmSchd.setScheduledRows(const Value: integer);
begin
  tcp.mvarScheduledRows:=Value;
  tcp.repaint;
end;

function TfrmSchd.getOnDrawRow: UOnDrawRow;
begin
  Result:= tcp.mvarOnDrawRow;
end;

procedure TfrmSchd.setOnDrawRow(const Value: UOnDrawRow);
begin
  tcp.mvarOnDrawRow:= Value;
end;

end.
