unit forNoteSearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, uorNItem;

type
  TfrmNoteSearch = class(TForm)
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

{$R *.DFM}
var
  mvLastIndex : integer;
procedure TfrmNoteSearch.btnCancelClick(Sender: TObject);
begin
  hide;
end;

procedure TfrmNoteSearch.btnNextClick(Sender: TObject);
begin
  if mvLastIndex = -1 then
     mvLastIndex := mvarNoteItems.FindFirst(Edit1.Text)
  else
     mvLastIndex := mvarNoteItems.FindNext(Edit1.Text, mvLastIndex);

  if mvLastIndex <0 then
     beep;
//     showmessage('íÏÇ äÔÏ');
  Edit1.SetFocus;
end;

procedure TfrmNoteSearch.Edit1Change(Sender: TObject);
begin
   mvLastIndex:=-1;
   btnNext.Enabled :=trim(edit1.Text) <> ''
end;

end.
