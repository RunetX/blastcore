unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Htmlview, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, PngImage1;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    AboutLabel: TLabel;
    Image1: TImage;
    Timer1: TTimer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;
  deltaX, deltaY: integer;

implementation

uses ArchiverUnit;

{$R *.dfm}



procedure TAboutForm.FormCreate(Sender: TObject);
begin
  AboutLabel.Caption:=
  'Оригинальная Идея:'+#13#10+
  'Александр Александров'+#13#10+#13#10+
  'Программирование и Дизайн'+#13#10+
  'Peek aka [Тян Семён]'+#13#10+#13#10+
  'Консультации и Рекомендации'+#13#10+
  'Nuclight aka [Гончаров Вадим]'+#13#10+#13#10+
  'Тестирование и Эргономика'+#13#10+
  'Mishanya aka [Логинов Михаил]'+#13#10+#13#10+
  'Особая Благодарность Моей Девушке'+#13#10+
  'Zebra aka [Соловьёва Мария]';
  Label1.Caption:=MainForm.ClientProperties.Version;
  deltaX:=3;
  deltaY:=1;
end;

procedure TAboutForm.Timer1Timer(Sender: TObject);
begin
  if((AboutLabel.Left<0)or(AboutLabel.Left+AboutLabel.Width>Width-10))then
    deltaX:=-deltaX;
  if((AboutLabel.Top<80)or(AboutLabel.Top+AboutLabel.Height>Height-30))then
    deltaY:=-deltaY;

  AboutLabel.Left:=AboutLabel.Left+deltaX;
  AboutLabel.Top:=AboutLabel.Top+deltaY;
end;

end.
