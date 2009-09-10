unit DebugUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, sPanel, sDialogs, sEdit, sButton, sMemo;

type
  TDebugForm = class(TForm)
    DebugMemo: TsMemo;
    DebugPanel: TsPanel;
    DebugClearBtn: TsButton;
    DebugEdit: TsEdit;
    DebugRunCmdBtn: TsButton;
    DebugSaveToFileBtn: TsButton;
    SaveDebugInfo: TsSaveDialog;
    procedure DebugClearBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DebugSaveToFileBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebugForm: TDebugForm;

implementation

{$R *.dfm}

procedure TDebugForm.DebugClearBtnClick(Sender: TObject);
begin
  DebugMemo.Clear;
end;

procedure TDebugForm.FormCreate(Sender: TObject);
begin
  with SaveDebugInfo do
    begin
      InitialDir:=ExtractFilePath(Application.ExeName);
      Filter:='Text files (*.txt)|*.txt';
    end;
end;

procedure TDebugForm.DebugSaveToFileBtnClick(Sender: TObject);
begin
  SaveDebugInfo.FileName := 'ClearCore Log' + '['+DateToStr(Date)+']';

  if SaveDebugInfo.Execute then
    begin
      DebugMemo.Lines.SaveToFile(SaveDebugInfo.FileName + '.txt');
    end;

end;

end.
