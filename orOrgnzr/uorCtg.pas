unit uorCtg;

interface
uses Controls, Forms, uorTask, forCtg;
type
   UCategory = class
     private
     public
       function Execute( var CatStr: String): boolean;
   end;
implementation

{ UCategory }

function UCategory.Execute(var catstr: string): Boolean;
var
frm : TfrmCategory;
begin
 frm:= TfrmCategory.Create(application);
 frm.CatString := CatStr;
 Result:= (frm.showmodal() = mrOk);
 if Result then
    Catstr := frm.CatString;
 frm.free;
end;

end.
