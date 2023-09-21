unit uorNote;

interface
uses  Classes, windows;

Type
  UNote = Class(TCollectionItem)
     private
       mvarStorageId : Integer;
       mvarPosition : TPoint;
       mvarContents: ansistring;
       mvarCreated : TDateTime;
       mvarLastModified : string;
       mvarColor : integer;
       mvarCategories : string;
       mvarVisible : Boolean;
     public
       property Categories: string read mvarCategories write mvarCategories;
       property Color : integer read mvarColor write mvarColor;
       property Contents:string read mvarContents write mvarContents;
       property DateCreated : TDateTime read mvarCreated write mvarCreated;
       property LastModified : string read mvarLastModified;
       property SysId: Integer read mvarStorageId write mvarStorageId;

       property Visible: Boolean read mvarVisible write mvarVisible;
       property Position : TPoint read mvarPosition write mvarPosition;
     end;
     UNotes = Class(TCollection)
       public
         function Add: UNote;
     end;

implementation


function UNotes.Add: UNote;
  begin
     Result:= UNote(TCollection(self).Add);
  end;

end.
