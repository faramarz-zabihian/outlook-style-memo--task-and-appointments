unit forGDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FDatePicker, ExtCtrls;

type
  TfrmCalGetDate = class(TForm)
    Panel1: TPanel;
    FDatePicker1: TFDatePicker;
    cmdOk: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses dmorgnzr;
{$R *.DFM}

procedure TfrmCalGetDate.FormCreate(Sender: TObject);
begin
  Organizer.InitHolidays(FDatePicker1);
end;

end.
