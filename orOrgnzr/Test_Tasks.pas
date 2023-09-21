unit Test_Tasks;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dmorgnzr, StdCtrls, ExtCtrls, FDatePicker;
type
  Tfrm_Test = class(TForm)
    Button1: TButton;
    btnCalendar: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCalendarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Test: Tfrm_Test;
implementation

{$R *.DFM}
procedure Tfrm_Test.FormCreate(Sender: TObject);
begin
  Organizer:= TdmOrganizer.Create(application);
  Color:= clMaroon ;
end;

procedure Tfrm_Test.Button1Click(Sender: TObject);
begin
   Organizer.ShowTaskPad;
end;

procedure Tfrm_Test.btnCalendarClick(Sender: TObject);
begin
   Organizer.ShowCalendarPad;
end;

procedure Tfrm_Test.Button2Click(Sender: TObject);
begin
Organizer.ShowNotePad;
end;

end.
