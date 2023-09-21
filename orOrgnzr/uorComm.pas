unit uorComm;
interface
uses  Classes, windows, forms, comctrls, Controls, dialogs, sysutils, graphics;
type
   UList = Class
     private
         mvarList : TList;
         mvarIdType, mvarUserId : integer;
         mvarOnDelete, mvarOnUpdate: TNotifyEvent;
     protected
         property  List : TList read mvarList write mvarList;
     public
         property  UserId: integer read mvarUserId write mvarUserId;
         property  IdType: integer read mvarIdType write mvarIdType;
         property  OnUpdate : TNotifyevent read mvarOnUpdate write mvarOnUpdate;
         property  OnDelete : TNotifyevent read mvarOnDelete write mvarOnDelete;
         procedure Update( obj : TObject);
         function  PreviousItem(obj : TObject): TObject;
         function  NextItem(obj : TObject) : TObject;
         procedure Sort(Compare: TListSortCompare);
         procedure   CloseAll; virtual;abstract;
         constructor Create(UpdateProc, DeleteProc:TNotifyEvent; Uid, uiType : integer); virtual;abstract;
         class function FindFirst(subj : string): integer; virtual;abstract;
         class function FindNext(subj : string; index: integer): integer; virtual;abstract;
  end;

implementation

procedure UList.Update(obj: TObject);
begin
  if assigned(mvarOnUpdate) then
     mvarOnUpdate(obj);
end;

function UList.PreviousItem(obj: TObject): TObject;
var
  index : integer;
begin
   index := mvarList.indexof(obj);
   if index > 0 then
      Result:= mvarList[index-1]
   else
      Result:= nil;
end;

function UList.NextItem(obj: TObject): TObject;
var
 index : integer;
begin
   index := mvarList.indexof(obj);
   if index < mvarlist.Count-1  then
      Result:= mvarList[index+1]
   else
      Result:= nil;
end;

procedure UList.Sort(Compare: TListSortCompare);
begin
   mvarList.Sort(Compare);
end;

end.




