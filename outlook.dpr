program outlook;

uses
  Forms,
  dmorgnzr in 'orOrgnzr\dmorgnzr.pas' {dmOrganizer: TDataModule},
  forCalnd in 'orOrgnzr\forCalnd.pas' {frmCalendar},
  forCtg in 'orOrgnzr\forCtg.pas' {frmCategory},
  forDefs in 'orOrgnzr\forDefs.pas' {frmDefaults},
  forEClnd in 'orOrgnzr\forEClnd.pas' {frmEditApp},
  forEvent in 'orOrgnzr\forEvent.pas' {frmEvent},
  forField in 'orOrgnzr\forField.pas' {frmFieldsDisp},
  forGDate in 'orOrgnzr\forGDate.pas' {frmCalGetDate},
  forMCtg in 'orOrgnzr\forMCtg.pas' {frmMCategrory},
  forNetMt in 'orOrgnzr\forNetMt.pas' {frmNetMeet},
  forNoteEdit in 'orOrgnzr\forNoteEdit.pas' {frmEditNote},
  forNoteSearch in 'orOrgnzr\forNoteSearch.pas' {frmNoteSearch},
  fORNotesPad in 'orOrgnzr\forNotesPad.pas' {frmNotesPad},
  forPrvw in 'orOrgnzr\forPrvw.pas' {frmPreview},
  forRecur in 'orOrgnzr\forRecur.pas' {frmRecurr},
  forRmnd in 'orOrgnzr\forRmnd.pas' {frmRemind},
  forSort in 'orOrgnzr\forSort.pas' {frmSortRows},
  forTskEd in 'orOrgnzr\forTskEd.pas' {frmEditTask},
  forTskPd in 'orOrgnzr\forTskPd.pas' {frmTaskPad},
  forTSrch in 'orOrgnzr\forTSrch.pas' {frmSearch},
  Morgnzr in 'orOrgnzr\Morgnzr.pas' {dmOrgnz: TDataModule},
  Test_Orgnzr in 'orOrgnzr\Test_Orgnzr.pas' {frm_Test},
  uorAppBr in 'orOrgnzr\uorAppBr.pas' {uorAppBar: TFrame},
  uorCalnd in 'orOrgnzr\uorCalnd.pas',
  uorComm in 'orOrgnzr\uorComm.pas',
  uorCtg in 'orOrgnzr\uorCtg.pas',
  uorNItem in 'orOrgnzr\uorNItem.pas',
  uorNote in 'orOrgnzr\uorNote.pas',
  uorTask in 'orOrgnzr\uorTask.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmNetMeet, frmNetMeet);
  Application.CreateForm(TfrmPreview, frmPreview);
  Application.CreateForm(TfrmRecurr, frmRecurr);
  Application.CreateForm(TfrmRemind, frmRemind);
  Application.CreateForm(TfrmSortRows, frmSortRows);
  Application.CreateForm(TdmOrgnz, dmOrgnz);
  Application.CreateForm(Tfrm_Test, frm_Test);
  Application.Run;
end.
