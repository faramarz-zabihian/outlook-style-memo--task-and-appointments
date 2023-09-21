unit Test_Orgnzr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dmorgnzr, StdCtrls, ExtCtrls, FDatePicker;
type
  Tfrm_Test = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    btnCalendar: TButton;
    Notes: TButton;
    Events: TButton;
    Configure: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCalendarClick(Sender: TObject);
    procedure NotesClick(Sender: TObject);
    procedure EventsClick(Sender: TObject);
    procedure ConfigureClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Test: Tfrm_Test;
implementation

uses forEvent, forDefs;

{$R *.DFM}
procedure Tfrm_Test.FormCreate(Sender: TObject);
begin
  mvaruserId := 30000034 ;
  Organizer:= TdmOrganizer.Create(application);
//  Color:= clMaroon ;
end;

procedure Tfrm_Test.Button1Click(Sender: TObject);
begin
  Organizer.ShowTaskPad;
end;

procedure Tfrm_Test.btnCalendarClick(Sender: TObject);
begin
  Organizer.ShowCalendarPad;
end;

procedure Tfrm_Test.NotesClick(Sender: TObject);
begin
  Organizer.ShowNotePad;

end;

procedure Tfrm_Test.EventsClick(Sender: TObject);
var
 f : TfrmEvent;
begin
 f:= TfrmEvent.Create(application);
 f.CurrentDate := date();
 f.showmodal;
 f.Free;
end;

procedure Tfrm_Test.ConfigureClick(Sender: TObject);
var
  frmDef: TfrmDefaults;
begin
  frmDef:= TfrmDefaults.Create(application);
  frmDef.showmodal;
  frmDef.free;
end;

end.
