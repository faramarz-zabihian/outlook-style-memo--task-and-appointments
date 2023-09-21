unit forPrvw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmPreview = class(TForm)
    re: TRichEdit;
    Panel1: TPanel;
    cmdCancel: TButton;
    cmdPrint: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrintOut;
  end;

var
  frmPreview: TfrmPreview;

implementation

{$R *.DFM}

procedure TfrmPreview.cmdCancelClick(Sender: TObject);
begin
 ModalResult:= mrCancel;
end;

procedure TfrmPreview.cmdPrintClick(Sender: TObject);
begin
 PrintOut;
 ModalResult:= mrOk;
end;

procedure TfrmPreview.PrintOut;
begin
 re.Print('');
end;

end.
