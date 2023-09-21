unit forTSrch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmSearch = class(TForm)
    Label1: TLabel;
    btnCancel: TBitBtn;
    Edit1: TEdit;
    btnNext: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
implementation

uses uorTask;
var
  mvLastIndex : integer;
{$R *.DFM}

procedure TfrmSearch.btnCancelClick(Sender: TObject);
begin
  hide;
end;

procedure TfrmSearch.btnNextClick(Sender: TObject);
begin
  if mvLastIndex = -1 then
     mvLastIndex := UTaskList.FindFirst(Edit1.Text)
  else
     mvLastIndex := UTaskList.FindNext(Edit1.Text, mvLastIndex);

  if mvLastIndex <0 then begin
     beep;
     showmessage('íÏÇ äÔÏ');
  end;
  Edit1.SetFocus;
end;

procedure TfrmSearch.Edit1Change(Sender: TObject);
begin
   mvLastIndex:=-1;
   btnNext.Enabled :=trim(edit1.Text) <> ''
end;

end.
end.
