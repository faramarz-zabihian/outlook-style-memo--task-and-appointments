unit forRmnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TfrmRemind = class(TForm)
    lblSubject: TLabel;
    cmdDismiss: TBitBtn;
    cmdPostpone: TBitBtn;
    cmdOpen: TBitBtn;
    Bevel1: TBevel;
    Label2: TLabel;
    cboTime: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cboTimeClick(Sender: TObject);
    procedure cmdPostponeClick(Sender: TObject);
    procedure cmdDismissClick(Sender: TObject);
    procedure cmdOpenClick(Sender: TObject);

  private
      mvarDelay : longint;
    { Private declarations }
  public
     property Delay : longint read mvarDelay write mvarDelay;
    { Public declarations }
  end;

var
  frmRemind: TfrmRemind;

implementation

{$R *.DFM}

procedure TfrmRemind.FormCreate(Sender: TObject);
begin
  cboTime.Items.add('5 œﬁÌﬁÂ');
  cboTime.Items.add('10 œﬁÌﬁÂ');
  cboTime.Items.add('15 œﬁÌﬁÂ');
  cboTime.Items.add('30 œﬁÌﬁÂ');
  cboTime.Items.add('1 ”«⁄ ');
  cboTime.Items.add('2 ”«⁄ ');
  cboTime.Items.add('4 ”«⁄ ');
  cboTime.Items.add('8 ”«⁄ ');
  cboTime.Items.add('1 —Ê“');
  cboTime.Items.add('2 —Ê“');
  cboTime.Items.add('3 —Ê“');
  cboTime.Items.add('4 —Ê“');
  cboTime.Items.add('1 Â› Â');
  cboTime.itemindex:=0;
  cboTimeClick(cboTime);
end;

procedure TfrmRemind.cboTimeClick(Sender: TObject);
begin
  case cboTime.ItemIndex of
     0, 1, 2, 3 : Delay:= (cboTime.ItemIndex+1) *  5;     // 5 minute chunks
     4 : Delay := 60;                         // 60 per hour
     5 : Delay :=120;
     6 : Delay:= 240;
     7 : Delay:= 480;
     8,9,10,11 : Delay:= (cboTime.ItemIndex-7) * 1440;  // 24 * 60 per day
     12: Delay:= 7 * 1440; // one week delay
  end;
end;

procedure TfrmRemind.cmdPostponeClick(Sender: TObject);
begin
  ModalResult := 20;
end;

procedure TfrmRemind.cmdDismissClick(Sender: TObject);
begin
  ModalResult:= 10;
end;

procedure TfrmRemind.cmdOpenClick(Sender: TObject);
begin
  ModalResult:= 30;
end;

end.
