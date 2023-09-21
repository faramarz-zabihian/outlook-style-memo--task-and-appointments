unit forMCtg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmMCategrory = class(TForm)
    lbMCat: TListBox;
    txtNew: TEdit;
    Label1: TLabel;
    cmdAdd: TButton;
    cmdDelete: TButton;
    cmdRest: TButton;
    cmdOk: TButton;
    cmdCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure txtNewEnter(Sender: TObject);
    procedure lbMCatEnter(Sender: TObject);
    procedure lbMCatExit(Sender: TObject);
    procedure cmdAddClick(Sender: TObject);
    procedure cmdDeleteClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure cmdRestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses dmorgnzr;
{$R *.DFM}

procedure TfrmMCategrory.FormShow(Sender: TObject);
begin
 lbMCat.Items.Clear; 
 with Organizer.Category_Select do begin       // adding (Standard/User) Items to list
      while not Eof do begin
            lbMCat.Items.Add(FieldByName('Name').Value);
            next;
      end;
      close;
 end;

end;

procedure TfrmMCategrory.txtNewEnter(Sender: TObject);
begin
  cmdAdd.Enabled := true;
end;

procedure TfrmMCategrory.lbMCatEnter(Sender: TObject);
begin
  cmdDelete.Enabled := true;
  cmdAddClick(Sender);

end;

procedure TfrmMCategrory.lbMCatExit(Sender: TObject);
begin
   cmdDelete.Enabled := lbMCat.itemindex>=0;
end;

procedure TfrmMCategrory.cmdAddClick(Sender: TObject);
var
 txt : string;
begin
   txt := txtNew.text;
   txtNew.text:='';
   cmdAdd.Enabled := false;

   if trim(txt) = '' then
      exit;
   if lbMCat.items.indexof(trim(txt)) >=0 then
      exit;
   Organizer.AddToCategory(txt,0);
   lbMCat.items.Add(txt); 
end;

procedure TfrmMCategrory.cmdDeleteClick(Sender: TObject);
var
i:integer;
begin
 for i:=lbMCat.Items.Count-1 downto 0 do
     if lbMCat.Selected[i] then begin
        Organizer.DelCategory(lbMCat.Items[i]);
        lbMCat.Items.Delete(i);
     end;
 cmdDelete.Enabled := (lbMCat.SelCount > 0);
end;

procedure TfrmMCategrory.cmdCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TfrmMCategrory.cmdOkClick(Sender: TObject);
begin
  ModalResult:= mrOk;
end;

procedure TfrmMCategrory.cmdRestClick(Sender: TObject);
begin
  Organizer.ResetCategory;
  FormShow(self);
end;

end.

