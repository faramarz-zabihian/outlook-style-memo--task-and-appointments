unit frmCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Fcal;

type
  TfrmDtPicker = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Calendar : TCal;
  end;

implementation

{$R *.DFM}

procedure TfrmDtPicker.FormCreate(Sender: TObject);
begin
  Calendar:= TCal.Create(nil);
  with CalenDar do begin
     Parent:= self;
     Left:=0;
     Top:=0;
     FooterType := [cbsToday, cbsNone];
     OnExit     := FormDeactivate;
     OnResize   := FormResize;
     ParentFont := true;
  end;
end;

procedure TfrmDtPicker.FormDeactivate(Sender: TObject);
begin
  hide;
end;

procedure TfrmDtPicker.FormResize(Sender: TObject);
begin
  width := Calendar.Width;
  Height:= Calendar.Height;
 
end;

end.
