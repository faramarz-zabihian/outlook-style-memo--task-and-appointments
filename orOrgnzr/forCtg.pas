unit forCtg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst;

type
  TfrmCategory = class(TForm)
    cmdCancel: TButton;
    cmdOk: TButton;
    meCat: TMemo;
    cmdAdd: TButton;
    Label1: TLabel;
    lbCat: TCheckListBox;
    cmdMCategory: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure lbCatClickCheck(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure meCatEnter(Sender: TObject);
    procedure cmdAddClick(Sender: TObject);
    procedure lbCatEnter(Sender: TObject);
    procedure cmdMCategoryClick(Sender: TObject);
  private
    { Private declarations }
    procedure Parse(s: pchar);
    procedure buildMemo;
  public
    { Public declarations }
    CatString: string;
  end;

implementation
uses dmorgnzr, forMCtg;
var
 ar : array of string;



{$R *.DFM}

procedure TfrmCategory.cmdCancelClick(Sender: TObject);
begin
ModalResult:= mrCancel;
end;

procedure TfrmCategory.cmdOkClick(Sender: TObject);
begin
  ModalResult:= mrok;
end;

procedure TfrmCategory.lbCatClickCheck(Sender: TObject);
begin
   buildMemo;
end;

procedure TfrmCategory.Parse( s: pchar);
var
 pend,h: integer;
 p: pchar;
begin
   if trim(s) = '' then
      exit;
   while s[0] = ' ' do
         s:= s+1;

   h:=high(ar)+1;
   setLength(ar, h+1);
   h:=high(ar);
   p:= AnsistrScan(s, '¡');
   if p = nil then
      pend:= length(s)
   else
      pend:= p-s;
   setlength(ar[h], pend);
   ar[h]:= trim(copy(s,0, pend));
   if p <> nil then
      parse(p+1);
end;

procedure TfrmCategory.FormShow(Sender: TObject);
var
 i,j: integer;
begin
 setlength(ar,0);
 ar:= nil;
 mecat.Text:='';
 with Organizer.Category_Select do begin       // adding (Standard/User) Items to list
      while not Eof do begin
            lbCat.Items.Add(FieldByName('Name').Value);
            next;
      end;
      close;

 end;
 CatString:= trim(Catstring);
 Parse(pchar(CatString));
 for i:=0 to high(ar) do begin
     j:=lbcat.Items.IndexOf(ar[i]);
     if j <> -1 then
        lbcat.Checked[j]:= true
     else begin
        lbCat.Items.Add(ar[i]);
        lbcat.Checked[lbCat.Items.indexof(ar[i])]:= true;
     end;
 end;
 BuildMemo;
end;

procedure TfrmCategory.buildMemo;
var
 i: integer;
begin
   ar := nil;
   mecat.Text:='';
   for i:= 0 to lbcat.items.count-1 do
       if lbcat.Checked[i] then
          if mecat.Text <> '' then
             mecat.Text :=  mecat.Text+ '¡ '+ lbcat.items[i]
          else
             mecat.Text :=  lbcat.items[i];
   CatString := mecat.Text;

end;

procedure TfrmCategory.meCatEnter(Sender: TObject);
begin
 cmdAdd.Enabled := true; 
end;

procedure TfrmCategory.cmdAddClick(Sender: TObject);
var
i,j: integer;
begin
 cmdAdd.Enabled := False;
 Parse(pchar(meCat.text));
 for i:=0 to high(ar) do begin
     j:=lbcat.Items.IndexOf(ar[i]);
     if j <> -1 then
        lbcat.Checked[j]:= true
     else begin
        Organizer.AddToCategory(ar[i], 0); //Custom add to orCategory
        lbCat.Items.Add(ar[i]);
        lbcat.Checked[lbCat.Items.indexof(ar[i])]:= true;
     end;
 end;

 BuildMemo;


end;

procedure TfrmCategory.lbCatEnter(Sender: TObject);
begin
   cmdAddClick(Sender);
   cmdAdd.Enabled := false;
end;

procedure TfrmCategory.cmdMCategoryClick(Sender: TObject);
var
 frm : TfrmMCategrory;
begin
 frm:= TfrmMCategrory.Create(Application);
 frm.ShowModal;
 frm.free; 
end;

end.
