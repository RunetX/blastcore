unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, jpeg, sButton, sPanel, sLabel,
  acPNG, sMemo;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    sPanel1: TsPanel;
    OkBtn: TsButton;
    sLabelFX1: TsLabelFX;
    sWebLabel1: TsWebLabel;
    sLabel6: TsLabel;
    sMemo1: TsMemo;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses ArchiverUnit;

{$R *.dfm}



procedure TAboutForm.FormCreate(Sender: TObject);
begin
{
  'Оригинальная Идея:'+#13#10+
  'Александр Александров'+#13#10+#13#10+
  'Программирование и Дизайн'+#13#10+
  'Peek aka [Тян Семён]'+#13#10+#13#10+
  'Консультации и Рекомендации'+#13#10+
  'Nuclight aka [Гончаров Вадим]'+#13#10+#13#10+
  'Тестирование и Эргономика'+#13#10+
  'Mishanya aka [Логинов Михаил]'+#13#10+#13#10+
  'Особая благодарность моей половинке'+#13#10+
  'Zebrе aka [Соловьёвой Марии]';  }
  Caption:= Caption + MainForm.ClientProperties.Version;
  sLabelFX1.Caption := MainForm.ClientProperties.Version;
end;

procedure TAboutForm.OkBtnClick(Sender: TObject);
begin
  Close;
end;

end.
