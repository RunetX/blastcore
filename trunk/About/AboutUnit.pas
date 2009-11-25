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
    CreditsAnimTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CreditsAnimTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;
  Direction: Boolean;
  ScPosition: Integer;

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
  ScPosition := 13;
end;

procedure TAboutForm.OkBtnClick(Sender: TObject);
begin
  Close;
end;

procedure MemoScrollDown(Memo: TsMemo) ;
var
  ScrollMessage:TWMVScroll;
  i:integer;
begin
  if Direction then
    begin
      ScPosition := ScPosition + 1;
      ScrollMessage.ScrollCode:=sb_LineDown;
    end
  else
    begin
      ScPosition := ScPosition - 1;
      ScrollMessage.ScrollCode:=sb_LineUp;
    end;
  ScrollMessage.Msg:=WM_VScroll;
  ScrollMessage.Pos:=0;
  Memo.Dispatch(ScrollMessage) ;

  if ScPosition > 25 then Direction := False;
  if ScPosition < 13 then Direction := True;
end;

procedure TAboutForm.Image1Click(Sender: TObject);
begin
  CreditsAnimTimer.Enabled := not(CreditsAnimTimer.Enabled);
end;

procedure TAboutForm.CreditsAnimTimerTimer(Sender: TObject);
begin
  MemoScrollDown(sMemo1);
end;

end.
