unit forDefs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmDefaults = class(TForm)
    chk3: TCheckBox;
    chk2: TCheckBox;
    chk1: TCheckBox;
    chk0: TCheckBox;
    chk4: TCheckBox;
    chk5: TCheckBox;
    chk6: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cboStartHour: TComboBox;
    cboEndHour: TComboBox;
    cmdOk: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure cboStartHourClick(Sender: TObject);
  private
    { Private declarations }
     function getTime(sin: string): TDateTime;
  public
    { Public declarations }
  end;

implementation
uses
  dmorgnzr;
{$R *.DFM}

procedure TfrmDefaults.FormCreate(Sender: TObject);
begin
 with Organizer do begin
      generateTimeFrom(cboStartHour, 0);
      generateTimeFrom(cboEndHour ,WorkingStartHour);
      if Holidays[1] then
         chk0.Checked:= true;
      if Holidays[2] then
         chk1.Checked:= true;
      if Holidays[3] then
         chk2.Checked:= true;
      if Holidays[4] then
         chk3.Checked:= true;
      if Holidays[5] then
         chk4.Checked:= true;
      if Holidays[6] then
         chk5.Checked:= true;
      if Holidays[7] then
         chk6.Checked:= true;
      cboStartHour.Text := TimeToStr(WorkingStartHour);
      cboEndHour.Text := TimeToStr(WorkingEndHour);
 end;
end;

procedure TfrmDefaults.cmdCancelClick(Sender: TObject);
begin
    ModalResult:= mrCancel;
end;

procedure TfrmDefaults.cmdOkClick(Sender: TObject);
var
 dtStart, dtEnd : TDateTime;
 i: integer;
begin
   dtStart := getTime(cboStartHour.Text);
   if dtStart < 0 then begin
      showmessage('”«⁄  ‘—Ê⁄ ’ÕÌÕ ‰Ì” ');
      exit;
   end;
   dtEnd := getTime(cboEndHour.Text);
   if dtStart < 0 then begin
      showmessage('”«⁄  Å«Ì«‰ ’ÕÌÕ ‰Ì” ');
      exit;
   end;
   if dtStart >= dtEnd then begin
      showmessage('”«⁄  ‘—Ê⁄ ﬂ«— »«Ì” Ì ﬂ„ — «“ ”«⁄  Å«Ì«‰ ﬂ«— »«‘œ');
      exit;
   end;
   with Organizer do begin
        for i:=1 to 7 do
            Holidays[i]:= false;

        if chk0.checked then
           Holidays[1]:= true;
        if chk1.checked then
           Holidays[2]:= true;
        if chk2.checked then
           Holidays[3]:= true;
        if chk3.checked then
           Holidays[4]:= true;
        if chk4.checked then
           Holidays[5]:= true;
        if chk5.checked then
           Holidays[6]:= true;
        if chk6.checked then
           Holidays[7]:= true;
        WorkingStartHour := dtStart;
        WorkingEndHour   := dtEnd;
        WriteDefaults;
   end;
   ModalResult:= mrok;
end;

procedure TfrmDefaults.cboStartHourClick(Sender: TObject);
begin
   organizer.generateTimeFrom(cboEndHour, getTime(cboStartHour.Text)+ 1/48);
end;

function TfrmDefaults.getTime(sin: string): TDateTime;
var
 sout: string;
begin
  Result:= -1;
  if Organizer.getTime(sin, sout) then
     Result:= strtoTime(sout);
end;

end.
