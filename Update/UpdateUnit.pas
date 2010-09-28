unit UpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sMemo, sPanel, sLabel;

type
  TUpdateForm = class(TForm)
    UpdateText: TsMemo;
    sPanel1: TsPanel;
    Button1: TButton;
    sWebLabel1: TsWebLabel;
    sLabel1: TsLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;

implementation

{$R *.dfm}

procedure TUpdateForm.Button1Click(Sender: TObject);
begin
  UpdateText.Clear;
  Close;
end;

end.
