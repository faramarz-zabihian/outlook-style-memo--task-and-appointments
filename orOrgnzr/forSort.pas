unit forSort;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, uorTask;

type
  SortItem = Record
    SortId   : integer;
    Direction: integer;
  end;

  TfrmSortRows = class(TForm)
    Panel1: TPanel;
    cboSort1: TComboBox;
    radUp1: TRadioButton;
    radDown1: TRadioButton;
    cmdOk: TButton;
    cmdCancel: TButton;
    cmdClear: TButton;
    Panel2: TPanel;
    cboSort2: TComboBox;
    radUp2: TRadioButton;
    radDown2: TRadioButton;
    Panel3: TPanel;
    cboSort3: TComboBox;
    radUp3: TRadioButton;
    radDown3: TRadioButton;
    Panel4: TPanel;
    cboSort4: TComboBox;
    radUp4: TRadioButton;
    radDown4: TRadioButton;
    procedure cmdOkClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cboSort1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure ResetAll;
    procedure ComboState( cboOrder: integer; State : boolean);
    function setColumn(cbo: TComboBox; tc : TaskCols): integer;
  public
    { Public declarations }
    function QuerySortColumns(var sa : array of SortItem): integer;
    procedure setSortColumns(var sa : array of SortItem);
  end;
var
  frmSortRows: TfrmSortRows;

implementation
uses forTskPd;
{$R *.DFM}
procedure TfrmSortRows.cmdOkClick(Sender: TObject);
begin
  ModalResult := mrok;
end;

procedure TfrmSortRows.cmdCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSortRows.FormCreate(Sender: TObject);
var
 i: integer;
 uid : UItemData;
begin
  cboSort1.clear;
  cboSort1.Items.add('åíßÏÇã');
  for i:=0 to UTask.getPropertyCount-1 do begin
      if not UTask.CanSort(TaskCols(i)) then
         continue; 
      uid := UItemData.Create;
      uid.ItemCol := TaskCols(i);
      uid.Caption := UTask.getCaption(uid.ItemCol);
      cboSort1.Items.AddObject(uid.Caption, uid);
  end;
  cboSort2.items.Assign(cboSort1.Items);
  cboSort3.items.Assign(cboSort1.Items);
  cboSort4.items.Assign(cboSort1.Items);
  cboSort1.ItemIndex :=0;
  cboSort2.ItemIndex :=0;
  cboSort3.ItemIndex :=0;
  cboSort4.ItemIndex :=0;
  cboSort1Click(cboSort1);
end;

procedure TfrmSortRows.cmdClearClick(Sender: TObject);
begin
  ResetAll;
  cboSort1Click(cboSort1);
end;
procedure TfrmSortRows.ResetAll;
begin
  cboSort1.ItemIndex :=0;
  cboSort2.ItemIndex :=0;
  cboSort3.ItemIndex :=0;
  cboSort4.ItemIndex :=0;
  radUp1.Checked := true;
  radUp2.Checked := true;
  radUp3.Checked := true;
  radUp4.Checked := true;
end;

procedure TfrmSortRows.ComboState(cboOrder: integer; State: boolean);
var
 clColor : TColor;
begin
  if State then
     clColor := clWindow
  else
     clColor := color;

  case cboOrder of
     1:
        begin
          radUp1.Enabled := State;
          radDown1.enabled:= State;
        end;
      2 :
        begin
          cboSort2.Enabled := State;
          radUp2.Enabled := State;
          radDown2.enabled:= State;
          cboSort2.color := clColor;
          if not State then
             cboSort2.itemIndex:=0;
        end;
     3:
        begin
          cboSort3.Enabled := State;
          radUp3.Enabled := State;
          radDown3.Enabled:= State;
          cboSort3.color := clColor;
          if not State then
             cboSort3.itemIndex:=0;

        end;
     4:
        begin
          cboSort4.Enabled := State;
          radUp4.Enabled := State;
          radDown4.Enabled:= State;
          cboSort4.color := clColor;
          if not State then
             cboSort4.itemIndex:=0;
        end;
  end;
end;

procedure TfrmSortRows.cboSort1Click(Sender: TObject);
begin
  if Sender = cboSort1 then
     if cboSort1.itemIndex = 0 then begin
        ComboState(1, false);
        ComboState(2, false);
        ComboState(3, false);
        ComboState(4, false);
     end else begin
        ComboState(1, True);
        ComboState(2, True);
     end;

  if Sender = cboSort2 then
     if cboSort2.itemIndex = 0 then begin
        ComboState(3, false);
        ComboState(4, false);
     end else
        ComboState(3, True);

  if Sender = cboSort3 then
     if cboSort3.itemIndex = 0 then
        ComboState(4, false)
     else
        ComboState(4, True);
end;

procedure TfrmSortRows.FormDestroy(Sender: TObject);
var
 i: integer;
begin
  for i:=cboSort1.items.count-1 downto 0 do
      UItemData( cboSort1.Items.Objects[i]).free;
end;

function ColumnId(cbo : TComboBox) : integer;
begin
  result:= -1;
  if (cbo.itemindex =0) or (not cbo.Enabled) then
     exit;
  result:= integer(UItemData(cbo.items.objects[cbo.itemindex]).ItemCol);
end;

function TfrmSortRows.QuerySortColumns(var sa: array of SortItem): integer;
var
 j     : integer;
 ColId : integer;
begin

   for j:= 0 to 3 do begin
       sa[j].SortId :=-1;
       sa[j].Direction :=1;
   end;

   Result :=0;
//
   ColId := ColumnId(cboSort1);
   if ColId = -1 then
      exit;
   sa[Result].SortId := ColId;
   if not radUp1.Checked then
      sa[Result].Direction := -1;
   inc(Result);
//
   ColId := ColumnId(cboSort2);
   if ColId = -1 then
      exit;
   sa[Result].SortId := ColId;
   if not radUp2.Checked then
      sa[Result].Direction := -1;
   inc(Result);
//
   ColId := ColumnId(cboSort3);
   if ColId = -1 then
      exit;
    sa[Result].SortId := ColId;
   if not radUp3.Checked then
      sa[Result].Direction := -1;
   inc(Result);
//
   ColId := ColumnId(cboSort4);
   if ColId = -1 then
      exit;
   sa[Result].SortId := ColId;
   if not radUp4.Checked then
      sa[Result].Direction := -1;
   inc(Result);
end;

function TfrmSortRows.setColumn(cbo: TComboBox; tc : TaskCols): integer;
var
 i: integer;
begin
  Result:=0;
  for i:= 1 to cbo.Items.Count-1 do
      if UItemData(cbo.Items.objects[i]).ItemCol = tc then begin
           Result:=i;
           break;
      end;
end;

procedure TfrmSortRows.setSortColumns(var sa: array of SortItem);
var
 i: integer;
begin
    if sa[0].SortId = -1 then
       exit;
    cboSort1.itemindex := setColumn(cboSort1, TaskCols(sa[0].SortId));
    if cboSort1.itemindex > 0 then
       radup1.checked := sa[0].Direction <> -1;
    cboSort1Click(cboSort1);
    if sa[1].SortId = -1 then
       exit;
    cboSort2.itemindex := setColumn(cboSort2, TaskCols(sa[1].SortId));
    if cboSort2.itemindex > 0 then
       radup2.checked := sa[1].Direction <> -1;
    cboSort1Click(cboSort2);
    if sa[2].SortId = -1 then
       exit;
    cboSort3.itemindex := setColumn(cboSort3, TaskCols(sa[2].SortId));
    if cboSort3.itemindex > 0 then
       radup3.checked := sa[2].Direction <> -1;
    cboSort1Click(cboSort3);
    if sa[3].SortId = -1 then
       exit;
    cboSort4.itemindex := setColumn(cboSort4, TaskCols(sa[3].SortId));
    if cboSort4.itemindex > 0 then
       radup4.checked := sa[3].Direction <> -1;
    cboSort1Click(cboSort4);
end;

end.
