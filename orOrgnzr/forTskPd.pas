unit forTskPd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, ExtCtrls, uorTask, StdCtrls, Menus, forSort, uorCtg;

type
  TfrmTaskPad = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    ItemPopup: TPopupMenu;
    ListPopup: TPopupMenu;
    Open1: TMenuItem;
    mnuPrint: TMenuItem;
    mnuTaskCompleted: TMenuItem;
    mnuCategory: TMenuItem;
    mnuDelete: TMenuItem;
    mnuNewItem: TMenuItem;
    mnuFieldDisp: TMenuItem;
    mnuSort: TMenuItem;
    mnuSearch: TMenuItem;
    img: TImage;
    ScrollBox1: TScrollBox;
    hc: THeaderControl;
    lv: TListView;

    procedure lvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvDblClick(Sender: TObject);
    procedure mnuNewItemClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure lvKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure mnuFieldDispClick(Sender: TObject);
    procedure mnuSortClick(Sender: TObject);
    procedure lvCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuCategoryClick(Sender: TObject);
    procedure mnuTaskCompletedClick(Sender: TObject);
    procedure mnuPrintClick(Sender: TObject);
    procedure lvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuSearchClick(Sender: TObject);
    procedure hcSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure lvDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure hcSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure lvDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure hcMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hcMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure hcMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hcSectionTrack(HeaderControl: THeaderControl;
      Section: THeaderSection; Width: Integer; State: TSectionTrackState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    mvarOnDelete : TNotifyEvent;
    mvarOnUpdate : TNotifyEvent;
    mvarOnClose  : TNotifyEvent;
    si: array [1..4] of SortItem;
    procedure SortRows;
    procedure ResizeScb;
  public
    procedure Search;
    procedure ResetListView;
    procedure Append(TI: UTaskItem);
    property OnUpdate:TNotifyEvent read mvarOnUpdate write mvarOnUpdate;
    property OnDelete:TNotifyEvent read mvarOnDelete write mvarOnDelete;
    property OnClose:TNotifyEvent read mvarOnClose write mvarOnClose;
    procedure AddColumn( tc: TaskCols; Pos: integer; ColWidth:Integer=ColumnHeaderWidth);

    procedure DeleteColumn(index: TaskCols);
    procedure SetIndex(index: TaskCols; ord :integer);
    function FindColIndex(tc :TaskCols): integer;
    procedure Rebuild;
  end;
implementation
uses dmOrgnzr, forField, forTSrch;
var
  mvarItemAtCursor : TListItem;
  frms: TfrmSearch;
  mvarDraggedSection, mvarDraggedSectionTo : THeaderSection;
  mvarMouseisDown: boolean;
  x: integer;
{$R *.DFM}


procedure TfrmTaskPad.lvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 p: TPoint;
begin
     mvarItemAtCursor := lv.GetItemAt(x,y);
     if (ssright in shift) then begin
           p:=lv.ClientToScreen(Point(-x,y));
           if mvarItemAtCursor <> nil then
              ItemPopup.Popup(p.x,p.y)
           else
              Listpopup.Popup(p.x,p.y);
         end
     else
         if (mvarItemAtCursor <> nil) and (lv.SortType = stNone) then begin
             mvarMouseisDown := true;
             img.tag:=1;
         end;
  end;

procedure TfrmTaskPad.lvDblClick(Sender: TObject);
var
 i: integer;
begin
   if lv.Selected <> nil then begin
      for i:= 0 to lv.items.Count -1 do
          if lv.Items[i].Selected then
             UTaskItem(lv.Items[i].Data).Edit;
   end else mnuNewItemClick(Sender);

end;

procedure TfrmTaskPad.mnuDeleteClick(Sender: TObject);
var
i: integer;
begin
   if lv.Selected <> nil then
      for i:=lv.items.Count-1 downto 0 do
          if lv.Items[i].Selected  then
             UTaskItem(lv.Items[i].Data).Delete;
   lv.Invalidate;
end;

procedure TfrmTaskPad.mnuNewItemClick(Sender: TObject);
var
  ti : UTaskItem;
begin
  ti:= UTaskItem.Create;
  ti.Task.dateCreated := now(); 
  ti.Edit;
  Append(ti);
end;

procedure TfrmTaskPad.lvKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if lv.Selected = nil then
      exit;
  case  key of
    13:  UTaskItem(lv.Selected.Data).Edit;
    46 : UTaskItem(lv.Selected.Data).Delete;
  end;

end;

procedure TfrmTaskPad.Append(TI: UTaskItem);
begin
  ti.List :=lv.Items.add;
end;

procedure TfrmTaskPad.FormCreate(Sender: TObject);
var
i:integer;
begin
 lv.Columns.Clear();
 hc.Sections.Clear();
 frms:= TfrmSearch.Create(self);
 hc.Images := Organizer.imgTasks;
 for i:=1 to 4 do
     si[i].SortId :=-1;
end;
procedure TfrmTaskPad.AddColumn(tc : TaskCols; pos: Integer; ColWidth: integer = ColumnHeaderWidth);
var
 hs: THeaderSection;
 col: TListColumn;
 maxw, minw, wd: integer;
begin

//   if FindColIndex(tc) >= 0 then
//      exit;

   hs := hc.Sections.Add;
   with hs do begin
      Text  := UTask.getCaption(tc);
      Alignment := taLeftJustify ;
      UTask.getWidth(tc, wd, maxw, minw);
      if (ColWidth <> ColumnHeaderWidth) then begin
         AutoSize:= False;
         Width:= ColWidth;
      end else
         if wd > 0 then begin
            AutoSize:= False;
            Width:= wd;
         end else begin
             AutoSize:= True;
             Width:= ColWidth;
         end;

      if maxw > -1 then
         MaxWidth := maxw;
      if minw > -1 then
         MinWidth := minw;
      if Pos >= 0 then
         Index := pos;
   end;
   lv.Columns.Add();

   lv.Columns[hs.Index].Width := hs.width;
   lv.Columns[hs.Index].MaxWidth := hs.maxwidth;
   lv.Columns[hs.Index].minwidth:= hs.minwidth;
   lv.Columns[hs.Index].Alignment := hs.Alignment;
   lv.Columns[hs.Index].AutoSize := hs.AutoSize;
   lv.Columns[hs.Index].Index :=  hs.Index;
   lv.Columns[hs.Index].tag := integer(tc);

   //col:= lv.Columns[lv.Columns.Count-1].;

   //col.Width := hs.width;
   //col.MaxWidth := hs.maxwidth;
   //col.minwidth:= hs.minwidth;
   //col.Alignment := hs.Alignment;
   //col.AutoSize := hs.AutoSize;
   //col.Index :=  hs.Index;
   //col.tag := integer(tc);

   ResizeScb;
end;

procedure TfrmTaskPad.SetIndex(index: TaskCols; ord :integer);
var
oi:integer;
begin
   oi:= FindColIndex(index);
   if oi<0 then
      exit;
   lv.Columns[oi].index  := ord;
end;

function TfrmTaskPad.FindColIndex(tc :TaskCols): integer;
var
 i: integer;
begin
   Result:= -1;
   for i:=1 to lv.Columns.count-1 do
       if lv.columns[i].tag = integer(tc) then begin
          Result:= i;
          exit;
       end;
end;

procedure TfrmTaskPad.DeleteColumn(index: TaskCols);
var
 i: integer;
begin
   i:= FindColIndex(index);
   if i >= 0 then begin
      lv.Columns.Delete(i);
   end;
end;


procedure TfrmTaskPad.mnuFieldDispClick(Sender: TObject);
var
 f: TfrmFieldsDisp;
begin
 f:= TfrmFieldsDisp.Create(application);
 f.showmodal;
 FreeAndNil(f);
end;

procedure TfrmTaskPad.Rebuild;
var
 i: integer;
begin
  for i:= 0 to lv.items.count-1 do
      UTaskItem(lv.items[i].Data).List := lv.Items[i];
end;

procedure TfrmTaskPad.mnuSortClick(Sender: TObject);
var
 fsort: TfrmSortRows;
begin
 fsort:= TfrmSortRows.Create(application);
 fsort.setSortColumns(si);
 if fsort.showmodal <> mrok then begin
    fsort.free;
    exit;
 end;
 TfrmSortRows(fsort).QuerySortColumns(si);
 fsort.free;
 SortRows;
end;

procedure TfrmTaskPad.SortRows;
var
 i,j: integer;
begin
 j:=0;
 for i:=1 to lv.Columns.count-1 do
     hc.sections[i].ImageIndex := -1;
 for i:= 1 to 4 do begin
     if si[i].sortid = -1 then
        break;
     j := FindColIndex(TaskCols(si[i].SortId));
     if j >= 0 then
        if si[i].Direction >= 0 then
           hc.sections[j].ImageIndex :=0
        else
           hc.sections[j].ImageIndex :=1
     else
        showmessage(' ” Ê‰ ' +
        Utask.getCaption(TaskCols(si[i].SortId))+
        ' œ— »Ì‰ ” Ê‰Â« ÊÃÊœ ‰œ«—œ ');
 end;
 lv.items.BeginUpdate;
 lv.SortType := stNone; // force Refresh
 if i> 1 then
    lv.SortType := stData;
 lv.items.EndUpdate;
 lv.SetFocus ;
end;

function CompareItems(s1, s2: String): integer;
begin
  if s1 < s2 then
     Result := -1
  else
     if s1 > s2 then
        Result := 1
     else
        Result := 0;
end;

procedure TfrmTaskPad.lvCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
  var
   it1, it2 : UTask;
   i: integer;
   tc: TaskCols;
  begin
    it1 := UtaskItem(Item1.Data).Task;
    it2 := UtaskItem(Item2.Data).Task;
    Compare := 0;
    for i:= 1 to 4 do
        if (si[i].SortId = -1) or (Compare <> 0) then
           break
        else begin
           tc      := TaskCols(si[i].SortId);
           Compare :=   si[i].Direction *
                      CompareItems(it1.getPropertyValue(tc), it2.getPropertyValue(tc));
        end;
  end;

procedure TfrmTaskPad.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 i: integer;
begin
 if (lv.selected = nil) and  (VK_INsert <> key ) then
    exit;
 case Key of
    VK_DELETE : mnuDeleteClick(Sender);
    VK_Return  : lvDblClick(Sender);
    VK_INsert : mnuNewItemClick(Sender);
 end;

end;

procedure TfrmTaskPad.mnuCategoryClick(Sender: TObject);
var
 ctg : UCategory;
 cat : string;
 i: integer;
begin
   if lv.Selected = nil then
      exit;
   if lv.SelCount > 1 then
      cat:=''
   else
      cat:= UTaskItem(lv.Selected.Data).Task.Categories;

   ctg := UCategory.Create;
   if ctg.Execute(cat) then
      for i:=0 to lv.Items.Count-1 do
          if lv.Items[i].selected then
             with UTaskItem(lv.Items[i].Data) do begin
                  Task.Categories:= cat;
                  Changed := true;
                  Save;
             end;
   ctg.free;
end;

procedure TfrmTaskPad.mnuTaskCompletedClick(Sender: TObject);
var
i: integer;
begin
   if lv.Selected <> nil then
      for i:=0 to lv.items.Count-1 do
          if lv.Items[i].Selected  then
             with UTaskItem(lv.Items[i].Data) do begin
                  Task.Status := tsCompleted;
                  Changed := true;
                  Save;
             end;
end;

procedure TfrmTaskPad.mnuPrintClick(Sender: TObject);
var
i: integer;
ar : UATaskItems;
begin
   ar:= nil;
   if lv.Selected<> nil then
      for i:=0 to lv.items.Count-1 do
          if lv.Items[i].Selected  then begin
             setLength(ar, high(ar)+2);
             ar[high(ar)]:= UTaskItem(lv.Items[i].Data);
          end;
   UTaskItem.PrintOut(ar);
end;

procedure TfrmTaskPad.lvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 i: integer;
begin
  if ord(key) = 65 then
     if ssCtrl in Shift then
        for i:= 0 to lv.items.count-1 do
            lv.Items[i].selected := true;
end;

procedure TfrmTaskPad.Search;
begin
  frms.Show;
end;

procedure TfrmTaskPad.mnuSearchClick(Sender: TObject);
begin
  Search;
end;
procedure TfrmTaskPad.ResizeScb;
begin
end;
procedure TfrmTaskPad.hcSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  lv.Invalidate;
  lv.Columns[section.Index].width:= section.Width;
  ResizeScb;
end;

procedure TfrmTaskPad.lvDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   Accept:= (sender= lv ) and (source=img) and (lv.GetItemAt(abs(x),y)<> nil) and (img.tag=1);
end;

procedure TfrmTaskPad.hcSectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
var
  tc : integer;
  i,j,d: integer;
  kbs: TKeyBoardState;
  ShiftDown : boolean;
begin
 tc:= lv.Columns[section.index].tag;
 if not UTask.CanSort(TaskCols(tc)) then begin
    showmessage('ê–«‘ ‰   — Ì» —ÊÌ «Ì‰ ” Ê‰ „„ﬂ‰ ‰Ì” ');
    exit;
 end;
 GetKeyboardState(kbs);
 ShiftDown := ssShift in KeyboardStateToShiftState(kbs);

 j:= -1;
 for i:= 1 to 4 do
    if tc = si[i].SortId then begin // find column
       j:=i;
       d := si[i].Direction;
       break;
    end;

 if not ShiftDown then
    for i:=1 to 4 do
        si[i].SortId :=-1;

 for i:=1 to 4 do
     if si[i].SortId = -1 then
        break;

 if (j <> -1) and ShiftDown then // column found just reverse it's sort order
    si[j].direction := - d
 else             // column not found or no-shiftdown
    if i <= 4 then begin   // if there is place to add another column
       si[i].SortId := tc;
       if j<> -1 then
          si[i].Direction := -d
       else
          si[i].Direction := 1;
    end;
 SortRows;
end;

procedure TfrmTaskPad.lvDragDrop(Sender, Source: TObject; X, Y: Integer);
var
Li, LiNext, LIPrev, cur, g : TListItem;
i: integer;
ar : array of TListItem;
begin
 Li := lv.GetItemAt(abs(x),y);
 LiNext:=lv.GetNextItem(Li, sdbelow, [isNone]);
 if LiNext <> nil then begin
    if y > ((liNext.Position.y + Li.Position.y) /2) then
       LI:= LiNext;
 end;

 if Li = nil then
    exit;

 for i:= 0 to lv.Items.count-1 do
     if lv.Items[i].Selected and (lv.Items[i] <> Li) then begin
        setLength(ar,high(ar)+2);
        ar[high(ar)] := lv.Items[i];
     end;
 lv.Items.BeginUpdate;
 for i:=0 to high(ar) do begin
      cur := ar[i];
      g   := lv.Items.Insert(lv.items.indexof(Li));
      g.Assign(cur);
      lv.items.Delete(lv.Items.indexof(cur));
 end;
 lv.Items.EndUpdate;
 setLength(ar,0);
end;

procedure TfrmTaskPad.lvMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if mvarMouseisDown and (ssLeft in Shift) then
     img.BeginDrag(true,-1)
  else
     mvarMouseisDown:= False;
end;

procedure TfrmTaskPad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frms.close;
  frms.Release;
  if assigned(OnClose) then
     OnClose(self);
  Release;   
end;

procedure TfrmTaskPad.hcMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   i : integer;
begin
   
   mvarDraggedSection := nil;
   mvarDraggedSectionTo:= nil;
   if ssLeft in Shift then
       for i:=1 to hc.Sections.count-1 do begin
       //for i:=0 to hc.Sections.count-1 do begin
           if (abs(x) > hc.sections[i].Left) and (abs(x) < hc.sections[i].Right) then begin
               mvarDraggedSection:=hc.sections[i];
               break
           end;
       end;
end;

procedure TfrmTaskPad.hcMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i : integer;
begin
   if not (ssLeft in Shift) then
      mvarDraggedSection:= nil;
   if mvarDraggedSection = nil then
      exit;
   mvarDraggedSectionTo:= nil;
   for i:=1 to hc.Sections.count-1 do begin
   //for i:=0 to hc.Sections.count-1 do begin
       if (abs(x) > hc.sections[i].Left) and (abs(x) < hc.sections[i].Right) then begin
           if (abs(x) < hc.sections[i].Left+hc.sections[i].Width/2) then
               mvarDraggedSectionTo:=hc.sections[i]
           else
               if i < hc.Sections.count-1 then
                  mvarDraggedSectionTo:=hc.sections[i+1];
           break
       end;
   end;
   if mvarDraggedSectionTo= nil then
      exit;
   //img.Left := hc.width - mvarDraggedSectionTo.Left - trunc(img.width /2)+ Panel2.Left;
   img.Left := hc.Left + hc.width - mvarDraggedSectionTo.Left - trunc(img.width /2)- ScrollBox1.Left;
   img.top := panel1.height- img.Height;
   img.visible := mvarDraggedSection<> nil;
end;

procedure TfrmTaskPad.hcMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
type
  RCol = Record
    tc: integer;
    wd: integer;
  end;
var
  hs : THeaderSection;
  wd, i, tc: integer;
  ar: array of RCol;
begin
   img.visible := false;
   if mvarDraggedSection = nil then
      exit;
   if mvarDraggedSectionTo= nil then
      exit;

   img.update;
   if (mvarDraggedSectionTo = mvarDraggedSection) or
      (mvarDraggedSectionTo.Index = mvarDraggedSection.Index+1) then begin
      mvarDraggedSection:= nil;
      mvarDraggedSectionTo:= nil;
      exit;
   end;
   setLength(ar, lv.Columns.Count);
   for i:=1 to high(ar) do begin
       ar[i].tc := lv.Columns[i].tag;
       ar[i].wd := lv.Columns[i].Width;
   end;
   tc:= ar[mvarDraggedSection.index].tc;
   wd:= ar[mvarDraggedSection.index].wd;
   if mvarDraggedSection.index < mvarDraggedSectionTo.index then begin
      for i:= mvarDraggedSection.index to mvarDraggedSectionTo.index-2 do
          ar[i]:= ar[i+1];
      ar[mvarDraggedSectionTo.index-1].tc:= tc;
      ar[mvarDraggedSectionTo.index-1].wd:= wd;
   end else begin
      for i:= mvarDraggedSection.index-1 downto mvarDraggedSectionTo.index do
          ar[i+1]:= ar[i];
      ar[mvarDraggedSectionTo.Index].tc:= tc;
      ar[mvarDraggedSectionTo.Index].wd:= wd;
   end;
   hc.Sections.BeginUpdate;
   lv.Columns.BeginUpdate;
   lv.Items.beginUpdate;
   ResetListView;
   for i:=1 to high(ar) do begin // regarding first Column
       AddColumn(TaskCols(ar[i].tc),i, ar[i].wd);
   end;
   Rebuild;
   hc.Sections.EndUpdate;
   lv.Columns.EndUpdate;
   lv.Items.EndUpdate;
   lv.realign;
   lv.invalidate;
   lv.update;
   setLength(ar, 0);
end;

procedure TfrmTaskPad.hcSectionTrack(HeaderControl: THeaderControl;
  Section: THeaderSection; Width: Integer; State: TSectionTrackState);
begin
  mvarDraggedSection := nil;
  img.visible := false;
end;

procedure TfrmTaskPad.FormResize(Sender: TObject);
begin
 //Farshad! panel2.Left := ClientWidth - panel2.width;
 //Farshad! scb.Position:=0;
 //Farshad! panel2.Refresh;
 //Farshad! ResizeScb;
end;


procedure TfrmTaskPad.FormShow(Sender: TObject);
var
 i: integer;
begin
 setWindowLong(lv.Handle, GWL_EXSTYLE, getWindowLong(lv.Handle, GWL_EXSTYLE) or $400000) ;
 setWindowLong(hc.Handle, GWL_EXSTYLE, getWindowLong(hc.Handle, GWL_EXSTYLE) or $400000) ;
end;

procedure TfrmTaskPad.ResetListView;
var
 hs : THeaderSection;
 col : TListColumn;
 i: integer;
begin
   lv.Columns.Clear;
   hc.Sections.Clear;
   lv.Columns.add;
   i := lv.Columns.Count-1;
   lv.Columns[i].MaxWidth:=1;
   lv.Columns[i].Width:=0;
   lv.Columns[i].Tag:=3;
   hs:=hc.Sections.add;
   hs.Width:=0;
   hs.MaxWidth:=1;
end;

end.

