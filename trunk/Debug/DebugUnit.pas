unit DebugUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TDebugForm = class(TForm)
    DebugMemo: TMemo;
    DebugPanel: TPanel;
    DebugClearBtn: TButton;
    DebugEdit: TEdit;
    DebugRunCmdBtn: TButton;
    procedure DebugClearBtnClick(Sender: TObject);
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

end.
