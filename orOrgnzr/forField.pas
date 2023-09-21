unit forField;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uorTask, Dmorgnzr, math, comctrls, Buttons ;

type
  TfrmFieldsDisp = class(TForm)
    lstFields: TListBox;
    lstDisp: TListBox;
    cmsAdd: TButton;
    cmdRemove: TButton;
    cmdOk: TButton;
    cmdCancel: TButton;
    Label1: TLabel;
    cmdUp: TBitBtn;
    cmdDown: TBitBtn;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure cmsAddClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure cmdUpClick(Sender: TObject);
    procedure cmdDownClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure lstFieldsDblClick(Sender: TObject);
    procedure lstDispDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.DFM}

procedure MoveItems(fromlb, tolb : TListBox);
var
 i,j, li: integer;
 ui : UItemData;

begin
    if fromlb.SelCount = 0 then
       exit;
    if tolb.SelCount = 0 then
       li := tolb.Items.count
    else
       for i:= tolb.Items.count-1 downto 0 do
           if tolb.Selected[i] then begin
              li := i+1;
              break;
           end;
    for i:= 0 to tolb.Items.count-1 do
           if tolb.Selected[i] then
              tolb.Selected[i]:= false;

    for i:= fromlb.Items.count-1 downto 0 do begin
        if fromlb.Selected[i] then begin
           ui:= UItemData(fromlb.items.Objects[i]);
           tolb.items.InsertObject(li,  ui.caption , ui);
           tolb.selected[li]:= true;
           fromlb.Items.Delete(i);
           j := min (i, fromlb.Items.count -1);
        end;
    end;
    if j>=0 then
       fromlb.Selected[j]:= true;
    fromlb.Invalidate;
    tolb.Invalidate;  
end;

procedure TfrmFieldsDisp.FormCreate(Sender: TObject);
var
 i,j: integer;
 ui : UItemData;
 booFound, boo : boolean;
 s: string;
begin

    lstFields.Clear;
    lstDisp.Clear;
    for i:=1 to Organizer.TasksPad.lv.Columns.count-1 do begin
        ui:= UItemData.Create;
        ui.ItemCol := TaskCols(Organizer.TasksPad.lv.Columns[i].tag);
        ui.Width   := Organizer.TasksPad.lv.Columns[i].Width;
        ui.Caption := utask.getCaption(ui.ItemCol);
        lstDisp.Items.AddObject(ui.caption, ui)
    end;

    for i:=0 to UTask.getPropertyCount-1 do begin
        booFound:= False;
        for j:=0 to lstDisp.items.count-1 do
            if UItemData(lstDisp.items.objects[j]).ItemCol = taskcols(i) then begin
               booFound := true;
               break;
            end;
        if not booFound then begin
          ui:= UItemData.Create;
          ui.ItemCol := TaskCols(i);
          ui.Width   := ColumnHeaderWidth;
          ui.Caption := utask.getCaption(TaskCols(i));
          lstFields.Items.AddObject(ui.caption, ui);
        end;
    end;
end;

procedure TfrmFieldsDisp.cmsAddClick(Sender: TObject);
begin
  MoveItems(lstFields, lstDisp);
end;

procedure TfrmFieldsDisp.cmdRemoveClick(Sender: TObject);
begin
   MoveItems(lstDisp, lstFields);
end;

procedure TfrmFieldsDisp.cmdUpClick(Sender: TObject);
var
 i: integer;
begin
  WITH lstDisp DO BEGIN
    if SelCount = 0 then
       exit;
    for i:= 1 to Items.count-1 do
        if selected[i] and (not selected[i-1]) then begin
              items.Exchange(i, i-1);
              selected[i-1]:= true;
        end;
  END;
end;

procedure TfrmFieldsDisp.cmdDownClick(Sender: TObject);
var
 i: integer;
begin
  WITH lstDisp DO BEGIN
    if SelCount = 0 then
       exit;
    for i:= Items.count-2 downto 0 do
        if selected[i] and (not selected[i+1]) then begin
           items.Exchange(i+1,i );
           selected[i+1]:= true;
        end;
  end;

end;

procedure TfrmFieldsDisp.cmdCancelClick(Sender: TObject);
var
 i: integer;
begin
 for i:= 0 to lstFields.items.count-1 do
     lstFields.items.objects[i].Destroy;
 for i:= 0 to lstDisp.items.count-1 do
     lstDisp.items.objects[i].Destroy;
 ModalResult := mrCancel;
end;

procedure TfrmFieldsDisp.cmdOkClick(Sender: TObject);
var
 i : integer;
 tc : TaskCols;
 col: TListColumn;
begin
 with Organizer.TasksPad do begin
       hc.Sections.BeginUpdate;
       lv.Columns.BeginUpdate;
       lv.Items.BeginUpdate;
       ResetListView;
       for i:=0 to lstDisp.items.count -1 do begin
           tc:= UItemData(lstDisp.items.objects[i]).ItemCol;
           AddColumn(tc,i+1, UItemData(lstDisp.items.objects[i]).Width); // regarding first Column
       end;
       Rebuild;
       lv.realign;
       lv.invalidate;
       hc.Sections.EndUpdate;
       lv.Columns.EndUpdate;
       lv.Items.EndUpdate;
       Organizer.TasksPadColumnsUpdate(Sender);
 end;
 ModalResult := mrOk;
end;

procedure TfrmFieldsDisp.lstFieldsDblClick(Sender: TObject);
begin
 cmsAddClick(Sender);
end;

procedure TfrmFieldsDisp.lstDispDblClick(Sender: TObject);
begin
  cmdRemoveClick(Sender);  
end;

end.
