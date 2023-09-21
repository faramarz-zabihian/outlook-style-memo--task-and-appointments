unit forNetMt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, db;

type
  UAppMeeting = class
   public
     Text : string;
     Id   : integer;
     NameType : integer;
     Required : boolean;

  end;
  TfrmNetMeet = class(TForm)
    Bevel1: TBevel;
    txtName: TEdit;
    Label1: TLabel;
    lbNames: TListBox;
    cmdReq: TButton;
    cmdOpt: TButton;
    lbReq: TListBox;
    lbOpt: TListBox;
    rdUsers: TRadioButton;
    rdResources: TRadioButton;
    Bevel2: TBevel;
    cmdOk: TButton;
    cmdCancel: TButton;
    rdManComp: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure rdUsersClick(Sender: TObject);
    procedure lbNamesClick(Sender: TObject);
    procedure txtNameChange(Sender: TObject);
    procedure cmdReqClick(Sender: TObject);
    procedure cmdOptClick(Sender: TObject);
    procedure lbReqKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbOptKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbNamesDblClick(Sender: TObject);
  private
    procedure FillNames;
    procedure FreeNames;
    function CopyObject(obj : TObject): UAppMeeting;
    { Private declarations }
  public
    List : TList;
    { Public declarations }
  end;

var
  frmNetMeet: TfrmNetMeet;

implementation
uses
 dmorgnzr;
{$R *.DFM}
procedure TfrmNetMeet.FillNames;
var
 ds : TDataSet;
 nm : UAppMeeting;
 NameType : integer;
begin
  txtName.Text:= '';
  if rdUsers.Checked then
    NameType:= AppIdType_User
  else if rdResources.Checked then
    NameType:= AppIdType_Resource
  else
    NameType:= AppIdType_ManComp ;
  ds:= Organizer.GetNames(NameType);
  FreeNames;
  lbnames.Items.beginupdate;
  while not ds.Eof do begin
     nm := UAppMeeting.Create;
     nm.Text := ds.FieldValues['Name'];
     nm.Id   := ds.FieldValues['Id'];
     nm.NameType :=NameType;
     nm.Required := false;
     lbnames.Items.AddObject(nm.Text, nm);
     ds.Next;
  end;
  ds.Close;
  lbnames.Items.endupdate;
end;

procedure TfrmNetMeet.FormCreate(Sender: TObject);
begin
  FillNames;
end;

procedure TfrmNetMeet.FreeNames;
var
 i: integer;
begin
  with lbNames.items do
       for i:=0 to count-1 do begin
           Objects[i].free;
       end;
  lbNames.Items.Clear;
end;

procedure TfrmNetMeet.rdUsersClick(Sender: TObject);
begin
  FillNames;
end;

procedure TfrmNetMeet.lbNamesClick(Sender: TObject);
begin
  txtName.Text := lbNames.Items[lbNames.ItemIndex];
  cmdReq.Enabled:= lbNames.ItemIndex > -1;
  cmdOpt.Enabled:= lbNames.ItemIndex > -1;
end;

procedure TfrmNetMeet.txtNameChange(Sender: TObject);
var
 i, Ln: integer;
 s : string;
begin
  s:= trim(txtName.Text);
  ln:= Length(s);
  lbNames.ItemIndex:=-1;
  for i:=0 to lbNames.Items.Count-1 do
      if trim(Copy(lbNames.Items[i],1, ln))  = s then begin
         lbNames.ItemIndex:=i;
         break;
      end;
  cmdReq.Enabled:= lbNames.ItemIndex > -1;
  cmdOpt.Enabled:= lbNames.ItemIndex > -1;
end;

procedure TfrmNetMeet.cmdReqClick(Sender: TObject);
var
 nm : UAppMeeting;
 i: integer;
begin
 for i:= 0 to lbReq.Items.COunt-1 do
    if lbReq.Items[i] = lbNames.Items[lbNames.ItemIndex] then
       exit;

 nm:= UAppMeeting.Create;
 with UAppMeeting(lbNames.Items.Objects[lbNames.ItemIndex]) do begin
      nm.Text := Text;
      nm.Id := id;
      nm.NameType := NameType;
      nm.Required := true;
      lbReq.Items.AddObject(nm.Text, nm);
 end;
end;
procedure TfrmNetMeet.cmdOptClick(Sender: TObject);
var
 nm : UAppMeeting;
 i: integer;
begin
 for i:= 0 to lbOpt.Items.Count-1 do
    if lbOpt.Items[i] = lbNames.Items[lbNames.ItemIndex] then
       exit;

 nm:= UAppMeeting.Create;
 with UAppMeeting(lbNames.Items.Objects[lbNames.ItemIndex]) do begin
      nm.Text := Text;
      nm.Id := id;
      nm.NameType := NameType;
      nm.Required := False;
      lbOpt.Items.AddObject(nm.Text, nm);
 end;
end;

procedure TfrmNetMeet.lbReqKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_DELETE then
      if lbReq.ItemIndex > -1 then begin
         lbReq.Items.Objects[lbReq.ItemIndex].free;
         lbReq.Items.Delete(lbReq.ItemIndex);
      end;
end;

procedure TfrmNetMeet.lbOptKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_DELETE then
      if lbOpt.ItemIndex > -1 then begin
         lbOpt.Items.Objects[lbOpt.ItemIndex].free;
         lbOpt.Items.Delete(lbOpt.ItemIndex);
      end;

end;

procedure TfrmNetMeet.cmdCancelClick(Sender: TObject);
begin
  FreeNames;
  ModalResult:= mrCancel;
end;

procedure TfrmNetMeet.cmdOkClick(Sender: TObject);
var
 i: integer;
begin
 if List = nil then
    List:= TList.Create
 else begin
    for i:=0 to List.Count-1 do
        TObject(List[i]).free;
    List.Clear;
 end;
 for i:=0 to lbReq.Items.Count-1 do
    List.Add(lbReq.Items.Objects[i]);
 for i:=0 to lbOpt.Items.Count-1 do
    List.Add(lbOpt.Items.Objects[i]);
 FreeNames;
 ModalResult:= mrOk;
end;

function TfrmNetMeet.CopyObject(obj : TObject): UAppMeeting;
var
 cp : UAppMeeting;
begin
 cp:=UAppMeeting.Create;
 with UAppMeeting(obj) do begin
      cp.Text := Text;
      cp.Id := id;
      cp.NameType := NameType;
      cp.Required := Required;
 end;
 Result:= cp;
end;

procedure TfrmNetMeet.FormShow(Sender: TObject);
var
 i,j: integer;
 txt : string;
 un, ua : UAppMeeting; 
begin
   if List = nil then
      exit;
   for i:= 0 to List.Count-1 do
       with UAppMeeting(List[i]) do begin
           txt := '';
           for j:=0 to lbnames.items.Count-1 do begin
               un := UAppMeeting(lbnames.Items.Objects[j]);
               if (un.Id = Id) and (un.NameType = NameType) then begin
                  txt := un.Text;
                  break;
               end;
           end;
            if Required then
               lbReq.Items.addObject(txt,CopyObject(List[i]))
            else
               lbOpt.Items.addObject(txt,CopyObject(List[i]));
       end;
end;

procedure TfrmNetMeet.lbNamesDblClick(Sender: TObject);
var
 nm : UAppMeeting;
 i: integer;
begin
 for i:= 0 to lbReq.Items.COunt-1 do
    if lbReq.Items[i] = lbNames.Items[lbNames.ItemIndex] then
       exit;

 nm:= UAppMeeting.Create;
 with UAppMeeting(lbNames.Items.Objects[lbNames.ItemIndex]) do begin
      nm.Text := Text;
      nm.Id := id;
      nm.NameType := NameType;
      nm.Required := true;
      lbReq.Items.AddObject(nm.Text, nm);
 end;

end;

end.


