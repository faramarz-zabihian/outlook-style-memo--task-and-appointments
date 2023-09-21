unit fORNotesPad;

interface

uses  dialogs,Forms,windows, Menus, Graphics, ExtCtrls, Controls, StdCtrls, Classes, ComCtrls,
dmorgnzr, uorNItem, forNoteSearch;
type
  TfrmNotesPad = class(TForm)
    lv: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    ItemPopup: TPopupMenu;
    mnuOpen: TMenuItem;
    mnuColor: TMenuItem;
    mnuDelete: TMenuItem;
    mnuColorBlue: TMenuItem;
    mnuColorGreen: TMenuItem;
    mnuColorPink: TMenuItem;
    mnuColorYellow: TMenuItem;
    mnuColorWhite: TMenuItem;
    ListPopup: TPopupMenu;
    NewNote: TMenuItem;
    mnuAutoArrange: TMenuItem;
    mnuSortNotesByColor: TMenuItem;
    mnuSortNotesByText: TMenuItem;
    Image1: TImage;
    mnuHide: TMenuItem;
    mnuRestore: TMenuItem;
    mnuDahsh2: TMenuItem;
    mnuSearch: TMenuItem;
    mnuDahsh3: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    mnuSortByDate: TMenuItem;
    N4: TMenuItem;
    StatusBar1: TStatusBar;
    procedure lvDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuColorClick(Sender: TObject);
    procedure lvDblClick(Sender: TObject);
    procedure NewNoteClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuAutoArrangeClick(Sender: TObject);
    procedure mnuSortNotesByColorClick(Sender: TObject);
    procedure mnuSortNotesByTextClick(Sender: TObject);
    procedure lvCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure mnuHideClick(Sender: TObject);
    procedure mnuRestoreClick(Sender: TObject);
    procedure mnuSearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mnuSortByDateClick(Sender: TObject);
  private
    mvarOnDelete : TNotifyEvent;
    mvarOnUpdate : TNotifyEvent;
    mvarOnClose  : TNotifyEvent;
    procedure Rearrange;
  public
    procedure AttachTo( NI : NoteItem);
    property OnUpdate:TNotifyEvent read mvarOnUpdate write mvarOnUpdate;
    property OnDelete:TNotifyEvent read mvarOnDelete write mvarOnDelete;
    property OnClose:TNotifyEvent read mvarOnClose write mvarOnClose;
  end;


implementation


{$R *.DFM}
 type tsortorder = ( bydate, bycolor);
var
 frmSearch : TfrmNoteSearch;
 sorder : tsortorder;

procedure TfrmNotesPad.lvDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
  begin
      Accept:= ( sender = lv)
  end;

procedure TfrmNotesPad.lvDragDrop(Sender, Source: TObject; X, Y: Integer);
  var
   i, difx , dify : integer;
  begin
     if source <>  lv then
        exit;
     difx := x - NoteItem(lv.Selected.Data).Note.Position.X;
     dify := y - NoteItem(lv.Selected.Data).Note.position.y;
     for i:=lv.items.Count-1 downto 0 do
        if lv.items[i].Selected then
           with NoteItem(lv.items[i].Data) do
              setPosition(Note.position.x + difx, Note.position.y + dify);
     if mnuAutoArrange.checked then
        ReArrange;
  end;

procedure TfrmNotesPad.lvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
     mvarItem : TListItem;
  begin
     mvarItem :=lv.GetItemAt(x,y);
     if (ssright in shift) then begin
         if mvarItem <> nil then begin
              mnuHide.Checked := not NoteItem(mvarItem.Data).Visible;
              ItemPopup.Popup(self.left + x, self.top+y);
            end
         else
            Listpopup.Popup(self.left + x, self.top+y);
     end;
  end;

procedure TfrmNotesPad.mnuColorClick(Sender: TObject);
  var
    i : integer;
  begin
    for i:=0 to lv.items.Count-1 do
        if lv.items[i].Selected then begin
           NoteItem(lv.items[i].Data).Color:= TmenuItem(Sender).GroupIndex;
           if not NoteItem(lv.items[i].Data).Visible then
              lv.items[i].ImageIndex := lv.items[i].ImageIndex+5;
        end;
  end;

procedure TfrmNotesPad.lvDblClick(Sender: TObject);
  var
    i: integer;
  begin
    if  lv.SelCount > 0 then begin
        for i:=0 to lv.items.Count-1 do
            if lv.items[i].Selected then
               NoteItem(lv.items[i].Data).Edit;
    end else
        NewNoteClick(nil);  
  end;

procedure TfrmNotesPad.NewNoteClick(Sender: TObject);
  var
   mvarNoteItem : NoteItem;
  begin
     mvarNoteItem :=NoteItem.Create;
     mvarNoteItem.ListItem  := lv.items.add;
     if Assigned(onDelete) then
        mvarNoteItem.OnDelete := OnDelete;
     if Assigned(onUpdate) then
        mvarNoteItem.OnUpdate := OnUpdate;

     mvarNoteItem.OnUpdate(mvarNoteItem.Note);
     mvarNoteItem.Edit;
  end;

procedure TfrmNotesPad.mnuDeleteClick(Sender: TObject);
var
   i: integer;
begin
    for i:=lv.items.Count-1 downto 0 do
        if lv.items[i].Selected then
           NoteItem(lv.items[i].Data).Delete;
end;

procedure TfrmNotesPad.mnuAutoArrangeClick(Sender: TObject);
begin
  mnuAutoArrange.checked := not mnuAutoArrange.checked;
  if mnuAutoArrange.checked then
     ReArrange;
end;

procedure TfrmNotesPad.mnuSortNotesByColorClick(Sender: TObject);
begin
  sorder := bycolor; 
  lv.SortType := stData;
  ReArrange;
end;

procedure TfrmNotesPad.mnuSortNotesByTextClick(Sender: TObject);
begin
  lv.SortType := stText;
  ReArrange;
end;

procedure TfrmNotesPad.lvCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
 NI1, NI2: NoteItem;
begin
  NI1:= NoteItem(Item1.Data);
  NI2:= NoteItem(Item2.Data);
  if (NI1 = nil) or (NI2 = nil) then begin
     if (NI1 = nil) then
        Compare := -1
     else
        Compare := 1;
     exit;
  end;

  Compare:=0;
  if lv.SortType = stText then begin
          if NI1.Note.contents > NI2.Note.contents then
             Compare:=1
          else if NI1.Note.contents < NI2.Note.contents then
                  Compare:=-1;
     end
  else begin
     if sorder = bycolor then
        Compare:= NI1.Color - NI2.Color
     else if NI1.Note.DateCreated > NI2.Note.DateCreated then
             Compare:= 1
          else
             Compare := -1;
  end;
end;
procedure TfrmNotesPad.ReArrange;
var
 i:Integer;
 j: TSortType;
begin
   j:= lv.SortType;
   lv.SortType := stNone; // to force internal refresh
   lv.SortType := j;
   lv.arrange(arAligntop);
   for i:= 0 to lv.Items.count-1 do begin
       NoteItem(lv.Items[i].Data).setPosition(lv.Items[i].Position.x,lv.Items[i].Position.y);
   end;

end;

procedure TfrmNotesPad.lvKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case  key of
    VK_RETURN : lvDblClick(Sender);
    VK_DELETE : mnuDeleteClick(Sender);
  end;
end;
procedure TfrmNotesPad.AttachTo(NI: NoteItem);
begin
  if (ni.ListItem = nil) then
     if ni.Visible or mnuRestore.Checked then begin
        NI.ListItem :=lv.Items.add;
        if not ni.Visible then
           ni.ListItem.ImageIndex := ni.ListItem.ImageIndex + 5; // ghosted image
     end;
end;

procedure TfrmNotesPad.FormCreate(Sender: TObject);
begin
    lv.LargeImages  := Organizer.ImgNotes;
    mnuRestore.checked := false;
    frmSearch:= TfrmNoteSearch.Create(self);
end;

procedure TfrmNotesPad.mnuHideClick(Sender: TObject);
var
 i: integer;
 h : boolean;
begin
  h:= mnuHide.Checked;
  for i:=lv.items.Count-1 downto 0 do
      if lv.items[i].Selected then
         with  NoteItem(lv.items[i].Data) do begin
               Visible := h;
               lv.items[i].ImageIndex := lv.items[i].ImageIndex mod 5;
               if not Visible then
                  if not mnuRestore.Checked then
                       Hide
                  else
                     lv.items[i].ImageIndex := lv.items[i].ImageIndex+ 5;
         end;
end;

procedure TfrmNotesPad.mnuRestoreClick(Sender: TObject);
var
  i : integer;
  ni : NoteItem;
begin
  mnuRestore.checked := not mnuRestore.checked;
  for i := mvarNoteItems.Count-1 downto 0 do begin
      ni := NoteItem(mvarNoteItems.Items[i]);
      if mnuRestore.checked then begin
         if not ni.Visible  then begin
            AttachTo(ni);
         end;
      end else
        if not ni.Visible  then
           ni.Hide;
  end;
end;

procedure TfrmNotesPad.mnuSearchClick(Sender: TObject);
begin
  frmSearch.Show;
end;

procedure TfrmNotesPad.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i: integer;
begin
 frmSearch.Close;
 frmSearch.free;
 for i:= lv.items.count-1 downto 0 do begin
    NoteItem(lv.items[i].Data).ListItem := nil;
 end;
 Release;
 if assigned(OnClose) then
    OnClose(self);
end;

procedure TfrmNotesPad.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
   StatusBar1.Panels[0].Text := NoteItem(item.data).CreationDate;
end;

procedure TfrmNotesPad.mnuSortByDateClick(Sender: TObject);
begin
  sorder := bydate; 
  lv.SortType := stData;
  ReArrange;
end;

end.
