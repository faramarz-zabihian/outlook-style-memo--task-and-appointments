unit FCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, Grids, StdCtrls;

type
  TMonthPageChange = procedure ( Year,Mon : integer) of object;
  TCalSpecialDay = procedure (dt : TdateTime; var fs : TFontStyles; var fc : TColor ) of object;
  TCalButton = (cbsNone,cbsToday);
  TCalButtonSet = set of TCalButton;
  TDateNameFormat = (dnWeekDay_DayMonth, dnDayMonthYear, dnMonthYear);
  TDayEv = (deNone, deToday, deSelectedDate, deHoliday, deEvent, deThisMonth);
  TDayEvent = set of TDayEv;
  TDateChange = procedure(Shamsi:string; miladi : TDateTime) of object;
  TCal = class(TFrame)
    pnlOutter: TPanel;
    pnlInner: TPanel;
    pnlTitle: TPanel;
    imgNextMonth: TImage;
    imgPrevMonth: TImage;
    pnlFooter: TPanel;
    OverLine: TShape;
    btnToday: TSpeedButton;
    btnNone: TSpeedButton;
    tg: TStringGrid;
    pnlHeader: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    procedure imgNextMonthClick(Sender: TObject);
    procedure imgPrevMonthClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure btnNoneClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure tgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure tgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure tgClick(Sender: TObject);
    procedure tgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
     mvarShamsiDate : boolean;
     mvaronSpecialDay: TCalSpecialDay;
     mvarHolidays: array[1..7] of boolean;
     Days_Flag : Array[0..6,0..5] of TDayEvent;
     mvarFooterType : TCalbuttonset;
     mvarPageDate : TdateTime;
     mvarDate :String;
     mvarLastMonth : integer;
     mvarOnMonthPageChange: TMonthPageChange;
     mvarOnDateChange: TDateChange;
     mvarOnMouseUp : TMouseEvent;
     function  LeapYear4(year : integer): boolean;
     function  Kabisehyear4( year : integer): boolean;
     Function TodayF:string;
     function  getToday: string;
     function MonthName(Month: Integer): String;
     procedure RaiseDateChange(sh: string; mi : TDateTime);
     property Today: string read getToday;
     procedure setInitialDate(const Value: string);
     procedure SetCurrentDate(const Value: String);
     property  CurrentDate: String Read mvarDate Write SetCurrentDate;
     procedure setSelected(booState : boolean);
     Procedure RepaintGrid(dt : TdateTime);
     procedure setFooterType( ft : TCalButtonSet);
     function getHoliday( day : integer) : boolean;
     procedure setHoliday( day : integer; hol : boolean);
     Function Farsi_Day(Latin_Day:Byte):Byte;
     procedure  MonthChange(dt : TDateTime);
     function MonthOf(dt : TDateTime): integer;
     function YearOf(dt : TdateTime): integer;
  public
     function Miladi(DateF: string): TDateTime;
     function Shamsi(MIL : TDateTime): string;
     function ValidDate(DBE:String):Boolean;
     function DateName(dt: TDateTime; fm: TDateNameFormat): string;
     Constructor Create(AOwner: TComponent); override;
     procedure Repaint;override;
     Property Holiday[day : integer]: boolean read getHoliday write setHoliday;
     function IncrementMonth(dt : TdateTime; Count : integer): TdateTime;
     procedure setShamsiDate(state : boolean);
  published
    property ShamsiDate : boolean read mvarShamsiDate write setShamsiDate;
    property FooterType : TCalButtonSet read mvarFooterType write setFooterType default [cbsToday];
    property InitialDate: string write setInitialDate;
    property OnMonthPageChange: TMonthPageChange read mvarOnMonthPageChange write mvarOnMonthPageChange;
    property OnDateChange : TDateChange read mvarOnDateChange write mvarOnDateChange;
    property onSpecialDay: TCalSpecialDay read mvaronSpecialDay write mvaronSpecialDay;
    property OnMouseUp : TMouseEvent read mvarOnMouseup write mvarOnMouseUp;

  end;
procedure Register;
implementation
uses frmMonth;
{$R *.DFM}
const WeekDays : array[ 1..7] of string = (
'����',
'������',
'������',
'�� ����',
'���� ����',
'��� ����',
'����'
);
const MNames : array [1..12] of string = (
       '��������',
       '��������',
       '��������',
       '��������',
       '��������',
       '��������',
       '��������',
       '��������',
       '   ���  ',
       '    ��  ',
       ' ������ ',
       '��������' ) ;

const MNamesL : array [1..12] of string = (
       '������',
       ' �����',
       ' ���� ',
       ' �����',
       '   �� ',
       '  ��� ',
       ' ����� ',
       '  ��� ',
       'Ӂ�����',
       ' ����� ',
       ' ������',
       ' ������' ) ;

function strtodateMiladi(st : string): TDateTime;
var
  Old: string;
begin
    old := ShortDateFormat;
    ShortDateFormat := 'yy/mm/dd';
    Result := StrToDate(st);
    ShortDateFormat :=old ;
end;

function TCal.MonthName(Month: Integer): String;
begin
  if ShamsiDate then
     Result:= trim(MNames[month])
  else
     Result:= trim(MNamesL[month])
end;




constructor TCal.Create(AOwner: TComponent);
begin
  inherited;
  mvarShamsiDate := true;
  CurrentDate := Today;
  mvarLastMonth :=-1;
end;

procedure TCal.imgNextMonthClick(Sender: TObject);
begin
 mvarPageDate := IncrementMonth(mvarPageDate,1);
 MonthChange(mvarPageDate);
 RepaintGrid(mvarPageDate);
end;

procedure TCal.imgPrevMonthClick(Sender: TObject);
begin
 mvarPageDate := IncrementMonth(mvarPageDate,-1);
 MonthChange(mvarPageDate);
 RepaintGrid(mvarPageDate);
end;


procedure TCal.btnTodayClick(Sender: TObject);
begin
   CurrentDate := Today;
   setSelected(true);
end;

procedure TCal.btnNoneClick(Sender: TObject);
begin
 setSelected(False);
end;

procedure TCal.tgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 if ShamsiDate then
    CurrentDate:= TG.Cells[Acol,Arow]
 else begin
    CurrentDate:= Shamsi(strTodateMiladi(TG.Cells[Acol,Arow]));
 end;
end;

procedure TCal.FrameResize(Sender: TObject);
begin
   Width :=145;
   if pnlFooter.Visible then
      Height:= 161
   else
      Height:= 161 - pnlFooter.height;
end;

procedure TCal.tgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 fColor, bColor: TColor;
 day : string;
 spcStyle : TFontStyles;
 dt : TDateTime;
begin
  if ShamsiDate then
     dt := Miladi(Tg.cells[ACol,ARow])
  else
     dt :=strToDateMiladi(Tg.cells[ACol,ARow]);

  if Holiday[Farsi_Day(DayOfWeek(dt))] then
     fColor:= clRed
  else
     fColor:=ClBlack;

  if not (deThisMonth in Days_Flag[ACol,ARow]) then
     fColor:=clGrayText;

// we need to know where is Selected-Date and Today-Date
// Selected Date Should be Painted with BackColor and Today Should Have Focus Rect
// Holidays Should be Painted Red
// and Special Days should be Painted Bold

  with tg.Canvas do begin
    if deSelectedDate in Days_Flag[ACol,ARow] then begin
       bColor:= brush.color;
       brush.color :=  clHighlight;
       FillRect(Rect);
       brush.color := bColor;
       brush.style := bsClear;
       fColor := clHighlightText;     // I don't like this
    end else
       FillRect(Rect);

    spcStyle := [];
    if Assigned(onSpecialDay) then
       onSpecialDay(dt, spcStyle, fColor);

    day := Trim(intTostr(StrToInt(Copy(Tg.cells[ACol,ARow],7,2))));
    Font := tg.Font;
    Font.Style:= spcStyle;
    Font.Color:= fColor;
    TextOut(Rect.Right - TextWidth(day)- 2 , Rect.Top + 2 , day);
    if deToDay in Days_Flag[ACol,ARow] then
       DrawFocusRect(Rect);
    brush.style := bsSolid;
  end;
end;
//
Function TCal.Farsi_Day(Latin_Day:Byte):Byte; { ����� ��� ����}
    Begin
     Farsi_Day:=1;
     Case Latin_Day of
       1..6:Farsi_Day:=Latin_Day+1;
     End;
    End;

Procedure TCal.RepaintGrid(dt : TdateTime);
var
  ThisMonth, Day_Of_Week, K,Col,Row : Byte;
  Date_St : string;
  PageStart, Miladi_Month_Start : TDateTime;
  DateF : string;
  y, m, d : word;
Begin
//  mvarToday := Today;
  decodedate(dt , y, m, d);
  // extract Current Month in Shamsi or Christian ' m may be <> ThisMonth
  ThisMonth := MonthOf(dt);
  if ShamsiDate then
     Miladi_Month_Start := Miladi(StringReplace(Format('%2d/%2d/%2d',[yearof(dt), ThisMonth, 1]),' ','0', [rfReplaceAll]))
  else
     Miladi_Month_Start := EncodeDate(y, m , 1);

  // extract Current Day of week in Shamsi Week Days From Miladi Week Days
  Day_Of_Week := Farsi_Day(DayOfWeek(Miladi_Month_Start));
  K:=0;
  PageStart := Miladi_Month_Start- Day_Of_Week;

  For Row:=1 to 6 do
      For Col:=1 to 7 do begin
          K:=K+1;
          DateF := Shamsi(PageStart + K );
          if ShamsiDate then
             Date_St := DateF
          else
             Date_St := FormatDateTime('yy/mm/dd',PageStart + K); // Miladi(Date_F)


          TG.Cells[7-Col,Row-1]:= Date_St;
          Days_Flag[7-Col,Row-1]:=[];

          if (StrToInt(Copy(Date_St,4,2)) = ThisMonth) then
             Days_Flag[7-Col,Row-1]:= [deThisMonth];

          if (PageStart + k)  = Date() then
             Days_Flag[7-Col,Row-1]:= Days_Flag[7-Col,Row-1] + [deToday];

          if DateF = CurrentDate  then begin
             Days_Flag[7-Col,Row-1]:= Days_Flag[7-Col,Row-1] + [deSelectedDate];
          end;
  End;
  pnlTitle.Caption := MonthName(ThisMonth) + ' ' + inttostr(YearOf(dt));
End;

procedure TCal.SetCurrentDate(const Value: String);
begin
  mvarDate := Value;
  mvarPageDate := Miladi(Value);
  RepaintGrid(mvarPageDate);
end;
procedure TCal.setInitialDate(const Value: string);
begin
  if ValidDate(Value) then begin
     if ShamsiDate then
        CurrentDate := Value
     else
        CurrentDate := Shamsi(StrToDate(Value));
     RaiseDateChange(CurrentDate,Miladi(CurrentDate));
  end;
end;
procedure TCal.setSelected(booState : boolean);
begin
  if booState then
     RaiseDateChange(CurrentDate,Miladi(CurrentDate))
  else
     RaiseDateChange('',0);
end;

procedure TCal.RaiseDateChange(sh: string; mi : TDateTime);
begin
  if mi <> 0 then
    MonthChange(mi);
  if Assigned(mvarOnDateChange) then
     OnDateChange(sh, mi );
end;

function TCal.getToday: string;
begin
  Result:= Todayf;
end;
function TCal.TodayF: string;
begin
 Result:= Shamsi(Date);
end;

function TCal.Miladi(DateF: string): TDateTime;
var
  d,E: array[1..12] of integer;
  DifFirstDay,YearL,MontL,DayL:integer;
  YearF,MontF,DayF,Cal,i,j:integer;
  MontSt,DaySt:String[2];
  YearSt:String[4];
begin
 DifFirstDay:=79;
 Cal:=0;
 d[1] :=31;  d[2] :=31;  d[3] :=31;   d[4] :=31;    d[5] :=31;   d[6] :=31;
 d[7] :=30;  d[8] :=30;  d[9] :=30;   d[10]:=30;    d[11]:=30;   d[12]:=29;
 e[1] :=31;  e[2]:=28;   e[3]:=31;    e[4] :=30;    e[5] :=31;   e[6] :=30;
 e[7] :=31;  e[8]:=31;   e[9]:=30;    e[10]:=31;    e[11]:=30;   e[12]:=31;
 YearF:=StrToInt(Copy(DateF,1,2));
 MontF:=StrToInt(Copy(DateF,4,2));
 DayF :=StrToInt(Copy(DateF,7,2));
 YearL:=YearF+21;
 if Kabisehyear4(YearF) then d[12]:=30;
 for j:=1 to MontF-1 do Cal:=Cal+D[j];
 Cal:=Cal+DifFirstDay+DayF;
 if Cal>365 then begin
    if (Cal=366) and (not LeapYear4(YearL+1900)) then begin
         YearL:=YearL+1;
         Cal:=Cal-365;
    end;
    if (Cal>366) then begin
         YearL:=YearL+1;
         Cal:=Cal-365;
         if LeapYear4(YearL+1900-1) then Cal:=Cal-1
    end;
 end;
 if LeapYear4(YearL+1900) then e[2]:=29;
 i:=1;
 MontL:=0;
 while (Cal>e[i]) and (i<=12) do
 begin
  Cal:=Cal-E[i];
  MontL:=i;
  inc(i)
 end;
 DayL:=Cal;
 if DayL=0 then DayL:=e[i-1] else inc(MontL);
 if Datef>'78/10/10' then
    YearSt:='20'+Copy(IntToStr(YearL),2,2)
 else
    YearSt:='19'+IntToStr(YearL);
 if MontL<10 then MontSt:='0'+IntToStr(MontL) else MontSt:=IntToStr(MontL);
 if DayL <10 then DaySt :='0'+IntToStr(DayL)  else DaySt :=IntToStr(DayL);
 Result:= EncodeDate( strtoint(YearSt), strtoint(MontSt), strtoint(DaySt));
// Result:=DaySt+'/'+MontSt+'/'+YearSt;

end;

function TCal.Shamsi(MIL : TDateTime): string;
var
  DateL: string;
  D,E: array[1..12] of Integer;
  DifFirstDay,YearL,MontL,DayL:integer;
  YearF,MontF,DayF,Cal,i:integer;
  YearSt,MontSt,DaySt:String[2];
begin
  DateL:=FormatDateTime('dd/mm/yy', Mil);
  Cal:=0;
  DifFirstDay:=286;
  d[1] :=31; d[2] :=28;  d[3] :=31;   d[4] :=30;    d[5] :=31;   d[6] :=30;
  d[7] :=31; d[8] :=31;  d[9] :=30;   d[10]:=31;    d[11]:=30;   d[12]:=31;
  e[1] :=31; e[2] :=31;  e[3] :=31;   e[4] :=31;    e[5] :=31;   e[6] :=31;
  e[7] :=30; e[8] :=30;  e[9] :=30;   e[10]:=30;    e[11]:=30;   e[12]:=29;
  YearL:=StrToInt(Copy(DateL,7,2));
  if Yearl<60 then
     Yearl:=Yearl+100; //�� ���� ��� 2000
  MontL:=StrToInt(Copy(DateL,4,2));
  DayL :=StrToInt(Copy(DateL,1,2));
  YearF:=YearL-22;
 if LeapYear4(YearL+1900) then D[2]:=29;
 for i:=1 to MontL-1 do Cal:=Cal+D[i];
 Cal:=Cal+DifFirstDay+DayL;
 if Cal>365 then begin
    if (Cal=366) then begin
         YearF:=YearF+1;
         Cal:=Cal-365;
    end;
    if (Cal>366) then begin
         YearF:=YearF+1;
         Cal:=Cal-365;
    end;
 end else if (Cal>=DifFirstDay+1) and (LeapYear4(YearL+1900-1)) then
              Cal:=Cal+1;
 if Kabisehyear4(YearF) then e[12]:=30;
 i:=1; MontF:=0;
 while (Cal>e[i]) and (i<=12) do begin
  Cal:=Cal-E[i];  MontF:=i;  inc(i)
 end;
 DayF:=Cal;
 if DayF=0 then DayF:=e[i-1] else inc(MontF);
 YearSt:=IntToStr(YearF);
 if MontF<10 then MontSt:='0'+IntToStr(MontF) else MontSt:=IntToStr(MontF);
 if DayF <10 then DaySt :='0'+IntToStr(DayF)  else DaySt :=IntToStr(DayF);
 Result := YearSt+'/'+MontSt+'/'+DaySt;
end;

function TCal.LeapYear4(year: integer): boolean;
begin
   Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function TCal.Kabisehyear4(year: integer): boolean;
begin
  Result:=((Year<=70) and ((70-Year)mod 4=0)) or ((Year>=75) and ((Year-75)mod 4=0));
end;

function TCal.ValidDate(DBE: String): Boolean;
 var
    YY,MM,DD:String;
    dt : TDateTime;
 begin
   if (dbe= '') or (DBE='  /  /  ') then begin
      Result:= False;
      exit;
   end;
   if not ShamsiDate then begin
      try
        dt := 0;
        dt := strToDate(dbe);
      except
      end;
      Result:= dt <> 0;
      exit;
   end;
   YY:=copy(DBE,1,2);
   MM:=copy(DBE,4,2);
   DD:=copy(DBE,7,2);    
   if (length(YY)<2) or (length(MM)<2)or (length(DD)<2)
      then begin
             Result:=False;
             exit;
           end;

   if (StrToInt(MM)>12) or (StrToInt(MM)<1) or
      (StrToInt(DD)>31) or (StrToInt(DD)<1) or
      ((StrToInt(MM)>6) and (StrToInt(DD)=31))
      then begin
             Result:=False;
           end
   else Result:=True;
end;

procedure Register;
begin
  RegisterComponents('Standard', [TCal]);
end;

function TCal.DateName(dt: TDateTime; fm: TDateNameFormat): string;
var
 sh: string;
 syear, smonth, sday, sweekday: string;
begin
 sh:= Shamsi(dt);
 syear  := Copy(sh, 1, strScan(PChar(sh), '/') - pchar(sh));
 sMonth := MonthName(strtoint(Copy(sh, length(sYear)+2,
            strRScan(PChar(sh), '/') - length(sYear)-1-pchar(sh))));
 sday   := inttostr(Strtoint(Copy(strRScan(PChar(sh), '/')+1,1,2)));
 sweekday := WeekDays[DayOFWeek(dt) mod 7 + 1];
 Result:= sh;
 if ShamsiDate then
   case fm of
      dnWeekDay_DayMonth: Result:= sweekday + ' , ' + sday + '  '+ sMonth;
      dnDayMonthYear : Result:= sday + '  ' + sMonth + '  '+ sYear;
      dnMonthYear : Result := sMonth + ' '+ sYear;
   end
 else
   case fm of
      dnWeekDay_DayMonth: Result:= FormatDateTime('dddd, dd mmmm', dt);
      dnDayMonthYear    : Result:= FormatDateTime('dd mmmm yyyy', dt);
      dnMonthYear       : Result:= FormatDateTime('mmmm yyyy', dt);
   end
end;

procedure TCal.setFooterType(ft: TCalButtonSet);
var
 btn : TSpeedButton;
 cnt:integer;
begin
  mvarFooterType := ft;
  btnToday.Visible :=  cbsToday in ft;
  btnNone.Visible  :=  cbsNone  in ft;

  cnt:=2;
  if not (cbsToday in ft) then
     dec(cnt);
  if not (cbsNone  in ft) then
     dec(cnt);
  pnlFooter.Visible:= cnt > 0;
  if pnlFooter.Visible then begin
     if cnt =1 then begin //one button
        if btnNone.Visible then
           btn:= btnNone
        else
           btn:= btnToday;
        btn.Left := Trunc(OverLine.left + (OverLine.Width- btn.Width)/2);
     end else begin // two buttons
          btnNone.left := overline.Left;
          btnToday.left := overline.Left+ overLine.Width- btnToday.width ;
     end;
  end;
  Resize;
end;

procedure TCal.tgClick(Sender: TObject);
begin
 setSelected(true);
end;

procedure TCal.tgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  if Assigned(OnMouseup) then begin
     p:= ScreenTOClient(tg.ClientToScreen(Point(x,y)));
     OnMouseUp(Sender, Button, Shift, p.x,p.Y);
  end;
end;

function TCal.getHoliday(day: integer): boolean;
begin
 Result:=mvarHolidays[day];
end;

procedure TCal.setHoliday(day: integer; hol: boolean);
begin
 mvarHolidays[day]:= hol;
 RepaintGrid(Miladi(CurrentDate));
end;

procedure TCal.MonthChange( dt : TDateTime);
var
 mMonth : integer;
begin
 mMonth := Monthof(dt);
 if mMonth <> mvarLastMonth then begin
    mvarLastMonth := mMonth;
    if Assigned(OnMonthPageChange) then
       OnMonthPageChange(Yearof(dt), mMonth);
    tg.Repaint;
 end;
end;

procedure TCal.Repaint;
begin
  inherited;
  tg.Repaint;
end;

procedure TCal.pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 fmonth : TFrmMonthCal;
 pt : TPoint;
 dt : TdateTime;
begin
 fMonth := TFrmMonthCal.Create(self);
 fMonth.Cal := self;
 fMonth.font := Font;
 pt.x := pnlTitle.Left + imgPrevMonth.Width+3;
 pt.y := pnlTitle.top;
 pt := ClientToScreen(pt);
 fMonth.Left := pt.x;
 fMonth.Top := trunc(pt.y - 3* fMonth.Height /7 );
 fMonth.InitialDate := Miladi(CurrentDate);
 fMonth.ShowModal;
 dt := fMonth.SelectedMonth;
 fMonth.free;
 if dt <> 0 then begin
    mvarPageDate := dt;
    RepaintGrid(mvarPageDate);
    MonthChange(mvarPageDate);
 end;
end;

function TCal.IncrementMonth(dt: TdateTime; Count: integer): TdateTime;
var
 year, m, mon : integer;
 sDate : string;

begin
 if not ShamsiDate then
    Result := incMonth(dt,Count)
 else begin
       sDate := Shamsi(dt);
       mon   := StrToInt(Copy(sDate,4,2));
       year  := StrToInt(Copy(sDate,1,2));
       if Count >= 0 then begin
          m := (mon+ Count-1) mod 12 + 1;
          year := Year + ((mon + Count-1) div 12);
       end else begin
          m := (12 + ( mon + Count-1) mod 12) mod 12+1;
          if -Count mod 12 < mon then
             Year := Year + Count div 12
          else
             Year := Year + Count div 12 - 1;
       end;
       Result := Miladi(StringReplace(Format('%2d/%2d/%2d',[year, m, 1]),' ','0', [rfReplaceAll]));
 end;
end;

procedure TCal.setShamsiDate(state: boolean);
begin
  mvarShamsiDate := State;
  RepaintGrid(Miladi(CurrentDate));
end;

function  TCal.MonthOf(dt: TdateTime): integer;
var
 y,m,d : word;
begin
 if ShamsiDate then
    Result := strToInt(Copy(Shamsi(dt),4,2))
 else
    begin
      decodeDate(dt,y, m, d);
      Result:= m;
    end;
end;

function  TCal.YearOf(dt: TdateTime): integer;
var
 y,m,d : word;
begin
 if ShamsiDate then
    Result := strtoint(Copy(Shamsi(dt),1,2))
 else
    begin
      decodeDate(dt,y, m, d);
      Result:= y;
    end;

end;



end.
