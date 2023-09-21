unit Morgnzr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Menus, ActnList;

type
  TdmOrgnz = class(TDataModule)
    popupAccess: TPopupMenu;
    imgLarge: TImageList;
    imgSmall: TImageList;
    ActionList1: TActionList;
    AccessRight: TMenuItem;
    oaNotes: TMenuItem;
    Action1: TAction;
    orTasks: TMenuItem;
    oaCalendar: TMenuItem;
    procedure oaNotesClick(Sender: TObject);
    procedure orTasksClick(Sender: TObject);
    procedure oaCalendarClick(Sender: TObject);
  end;

var
  dmOrgnz: TdmOrgnz;

implementation
uses dmorgnzr ;
{$R *.DFM}

procedure TdmOrgnz.oaNotesClick(Sender: TObject);
begin
  Organizer.ShowNotePad;
end;

procedure TdmOrgnz.orTasksClick(Sender: TObject);
begin
  Organizer.ShowTaskPad;
end;

procedure TdmOrgnz.oaCalendarClick(Sender: TObject);
begin
  Organizer.ShowCalendarPad;
end;

end.
