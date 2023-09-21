unit uorNItem;

interface

uses classes,sysutils,windows,graphics,comctrls,controls, Forms,
     uorNote, forNoteEdit, FCal;

type
  NoteItem = Class
     private
       mvarOnClose : TNOtifyEvent;
       mfrmNote : TForm;
       mNote: UNote;
       mListItem : TListItem;
       mListView : TCustomListView;
       mvarOnDelete : TNotifyEvent;
       mvarOnUpdate : TNotifyEvent;
       function get_Caption:string;
       function  getColor: integer;
       procedure setListItem( L: TlistItem);
       procedure NotifyUpdate(N: UNote);
       procedure OnNoteUpdate(S:TObject);
       procedure setVisible( V : Boolean);
       function getVisible: Boolean;
       procedure setColor(const Value: integer);
       procedure OnNoteClose( Sender: TObject);
       function getCreationDateTime:string;
     public
        property Caption :string read get_Caption;
        property OnDelete: TNotifyEvent read mvarOnDelete write mvarOnDelete;
        property OnUpdate: TNotifyEvent read mvarOnUpdate write mvarOnUpdate;

        procedure Edit;
        procedure setPosition(const x,y: integer);
        property Color : integer read getColor write setColor;
        property Note: UNote read mNote write mNote;
        property ListItem : TListItem read mListItem write setListItem;
        property CreationDate : string read getCreationDateTime;
        property Visible: Boolean read getVisible write setVisible;
        procedure Hide;
        procedure Delete;
        procedure Select;
        constructor Create;
  end;

  UNoteItems = Class(TList)
   public
      class function NotesList: TList;
      function FindFirst(s: string) : integer;
      function FindNext(s: string ;j: integer) : integer;
      destructor Destroy;override;
      class procedure NotesCreate;
  end;

const defNoteColor = clBlue;

var
 mvarNoteItems : UNoteItems;

implementation

uses
  dmOrgnzr;

var
  mvarNotes : UNotes;

class procedure UNoteItems.NotesCreate;
begin
  inherited;
  mvarNoteItems := UNoteItems.Create;
  mvarNotes := UNotes.Create(UNote);
end;

destructor UNoteItems.Destroy;
var
 i : integer;
begin
  for i:=mvarNotes.Count-1 downto 0 do
      UNote(mvarNotes.Items[i]).free;
  for i:=Count-1 downto 0 do
      NoteItem(Items[i]).free;
  mvarNotes.free;
  mvarNotes := nil;
  inherited;
end;

function UNoteItems.FindFirst(s: string): integer;
var
  i: integer;
begin
   for i:=0 to Count-1 do
       if (Pos(s, NoteItem(Items[i]).Note.Contents ) <> 0)  and (NoteItem(Items[i]).ListItem <> nil) then begin
          NoteItem(Items[i]).Select;
          Result:= i;
          exit;
       end;
   Result:= -1;
end;

function UNoteItems.FindNext(s: string; j: Integer): integer;
var
 i: integer;
begin
   for i:=j+1 to Count-1 do
         if (Pos(s, NoteItem(Items[i]).Note.Contents ) <> 0) and (NoteItem(Items[i]).ListItem <> nil) then begin
            NoteItem(Items[i]).Select;
            Result:= i;
            exit;
         end;
   Result:= -1;
end;
procedure NoteItem.OnNoteClose(Sender : TObject);
begin
  mfrmNote:= Nil;
end;

procedure NoteItem.Edit;
var
 f:TfrmEditNote;
begin
    if mfrmNote = nil then begin
       f:= TfrmEditNote.Create(application);
       f.Contents:= Note.Contents;
       f.OnUpdate := OnNoteUpdate;
       f.OnFormClose := OnNoteClose;
       f.DateName := CreationDate;
       mfrmNote := f;
    end;
    f:= TfrmEditNote(mfrmNote);
    with  f do begin
          case mNote.Color of
               0:begin
                  BaseColor := clAqua;
                end;
               1:   BaseColor:= clLime;
               2:   BaseColor:= clFuchsia;
               3:   BaseColor:= clYellow;
               4:   BaseColor:= clWhite;
               else BaseColor := clWhite;
          end;
          Organizer.ImgNotes.geticon(mNote.Color,icon);
          Show;
    end;

end;

procedure NoteItem.OnNoteUpdate(S:TObject);
begin
  Note.Contents := TfrmEditNote(s).Contents;
  if mListItem <> nil then
     mListItem.Caption := Caption;
  NotifyUpdate(Note);
end;

function NoteItem.get_Caption: string;
begin
   Result:= Copy(Note.Contents,0,15);
end;

procedure NoteItem.setColor(const Value: integer);
begin
  if mListItem <> nil then
     mListItem.ImageIndex := Value;
  mNote.Color:= Value;
  NotifyUpdate(Note);
end;

procedure NoteItem.setPosition(const x,y: integer);
var
  p: TPoint;
begin
  p.x := x;
  p.y := y;
  mNote.Position := p;
  if mListItem <> Nil then
     mListItem.Position:=p;
  NotifyUpdate(mNote);
end;

procedure NoteItem.Delete;
var
 i: integer;
begin
  if mListItem <> nil then
     mListItem.Owner.Delete(mListItem.Index);
  if assigned(OnDelete) then OnDelete(Note);
  i:= mvarNoteItems.IndexOf(self);
  mvarNoteItems.Delete(i);
  note.Free;
  self.Free;
end;

function NoteItem.getColor: integer;
begin
   if mNote <> nil then
      Result:= mNote.Color
   else
      Result:= defNoteColor;
end;

procedure NoteItem.setListItem(L: TlistItem);
  begin
     mListItem:= L;
     if mListItem = nil then
        exit;
     L.Caption := Caption;
     L.ImageIndex  := mNote.Color;
     L.Data := self;
     mListView:= L.ListView;
     if (mNote.Position.x > 0) or (mNote.Position.y > 0) then
         L.Position := mNote.Position;
  end;

constructor NoteItem.Create;
begin
 mvarNoteItems.Add(self);
 Note         := mvarNotes.Add;
 Note.Visible := true;
end;

procedure NoteItem.NotifyUpdate(N: UNote);
begin
   if assigned(OnUpdate) then OnUpdate(Note);
end;

procedure NoteItem.Hide;
begin
  mNote.visible:= False;
  NotifyUpdate(mNote);
  mListItem.Delete;
  mListItem:= nil;
end;

function NoteItem.getVisible: Boolean;
begin
  Result:= mNote.Visible;
end;


procedure NoteItem.setVisible(V: Boolean);
begin
   Note.Visible := V;
   NotifyUpdate(Note);
end;

procedure NoteItem.Select;
begin
   ListItem.Selected := true;
end;

function NoteItem.getCreationDateTime: string;

begin
   if Organizer.ShamsiDate then
      Result:= Organizer.DateName(mNote.DateCreated, dnWeekDay_DayMonth)+ ' ÓÇÚÊ  '+ TimeTostr(mNote.DateCreated)
   else
      Result:= FormatDateTime('hh:mm dddd, yyyy/mm/dd', mNote.DateCreated);
end;

class function UNoteItems.NotesList: TList;
begin
  Result:= mvarNoteItems;
end;

end.
