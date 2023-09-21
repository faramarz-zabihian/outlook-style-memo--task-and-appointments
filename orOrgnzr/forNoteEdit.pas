unit forNoteEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, ToolWin, ActnList, StdActns,
  ImgList;

type
  TfrmEditNote = class(TForm)
    reMemo: TRichEdit;
    sbStatus: TStatusBar;
    mnuSys: TPopupMenu;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuDash: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuClose: TMenuItem;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    ActionList1: TActionList;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    mnuPrint: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure reMemoChange(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure mnuPrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    mvOnFormClose : TNotifyEvent;
    mvarChanged  : Boolean;
    mvOnUpdate : TNotifyEvent;
    procedure UpdateView;
    procedure set_Contents(V:string);
    function get_Contents:string;
    procedure SetColor(V: TCOLOR);
    procedure SetDate(V: string);
    procedure NotifyClose;
  public
    property OnUpdate:TNotifyEvent read mvOnUpdate write mvOnUpdate;
    property OnFormClose:TNotifyEvent read mvOnFormClose write mvOnFormClose;
    property Contents: string read get_Contents write set_Contents;
    property BaseColor: TColor write SetColor;
    property DateName : string write setDate;


  end;

implementation

uses dmorgnzr;

{$R *.DFM}
{ TfrmEditNote }

procedure TfrmEditNote.UpdateView;
  begin
    if Assigned(OnUpdate) then OnUpdate(self);
  end;


procedure TfrmEditNote.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if mvarChanged then
     UpdateView;
  Release;
  NotifyClose;
end;

function TfrmEditNote.get_Contents: string;
begin
  Result:= reMemo.Text;
end;

procedure TfrmEditNote.set_Contents(V: string);
begin
  reMemo.Text := V;
end;

procedure TfrmEditNote.reMemoChange(Sender: TObject);
begin
 mvarChanged := true;
end;

procedure TfrmEditNote.SetColor(V: TCOLOR);
begin
 self.color := V;
 self.Brush.Color := V;
 Organizer.ImgNotes.geticon(v, icon);
end;

procedure TfrmEditNote.SetDate(V: string);
begin
   sbStatus.Panels[0].Text  := V;
end;


procedure TfrmEditNote.mnuCutClick(Sender: TObject);
begin
 reMemo.CutToClipboard ;
end;

procedure TfrmEditNote.mnuCopyClick(Sender: TObject);
begin
  reMemo.CopyToClipboard;
end;

procedure TfrmEditNote.mnuPasteClick(Sender: TObject);
begin
    rememo.PasteFromClipboard;
end;

procedure TfrmEditNote.mnuSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
      if MessageDlg(Format('OK to overwrite %s;', [SaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
    rememo.Lines.SaveToFile(SaveDialog.FileName);
    reMemo.Modified := False;
  end;

end;

procedure TfrmEditNote.mnuCloseClick(Sender: TObject);
begin
    close;
end;

procedure TfrmEditNote.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  EditCut.Enabled := reMemo.SelLength > 0;
  EditCopy.Enabled := EditCut.Enabled;
end;

procedure TfrmEditNote.mnuPrintClick(Sender: TObject);
begin
  if PrintDialog.Execute then
    reMemo.Print('');
end;

procedure TfrmEditNote.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
     mvarChanged := false;
     Close;
  end;
end;

procedure TfrmEditNote.NotifyClose;
begin
  if assigned(OnFormClose) then
     OnFormClose(self);
end;

end.
