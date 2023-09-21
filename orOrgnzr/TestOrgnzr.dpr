program TestOrgnzr;

uses
  Forms,
  forTskPd in 'forTskPd.pas' {frmTaskPad},
  forTskEd in 'forTskEd.pas' {frmEditTask},
  forField in 'forField.pas' {frmFieldsDisp},
  forSort in 'forSort.pas' {frmSortRows},
  uorTask in 'uorTask.pas',
  forCtg in 'forCtg.pas' {frmCategory},
  forMCtg in 'forMCtg.pas' {frmMCategrory},
  dmorgnzr in 'dmorgnzr.pas' {dmOrganizer: TDataModule},
  Test_Orgnzr in 'Test_Orgnzr.pas' {frm_Test},
  uorCtg in 'uorCtg.pas',
  forTSrch in 'forTSrch.pas' {frmSearch},
  forPrvw in 'forPrvw.pas' {frmPreview},
  forRmnd in 'forRmnd.pas' {frmRemind},
  forEClnd in 'forEClnd.pas' {frmEditApp},
  uorCalnd in 'uorCalnd.pas',
  uorComm in 'uorComm.pas',
  forCalnd in 'forCalnd.pas' {frmCalendar},
  forGDate in 'forGDate.pas' {frmCalGetDate},
  forEvent in 'forEvent.pas' {frmEvent},
  forRecur in 'forRecur.pas' {frmRecurr},
  forDefs in 'forDefs.pas' {frmDefaults},
  forNetMt in 'forNetMt.pas' {frmNetMeet},
  uorNItem in 'uorNItem.pas',
  forNoteSearch in 'forNoteSearch.pas' {frmNoteSearch},
  fORNotesPad in 'forNotesPad.pas' {frmNotesPad},
  forNoteEdit in 'forNoteEdit.pas' {frmEditNote},
  uorNote in 'uorNote.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Test, frm_Test);
  Application.Run;
end.
