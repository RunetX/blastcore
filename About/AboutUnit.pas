unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Htmlview, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, PngImage1, jpeg;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    OkBtn: TButton;
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
  '������������ ����:'+#13#10+
  '��������� �����������'+#13#10+#13#10+
  '���������������� � ������'+#13#10+
  'Peek aka [��� ����]'+#13#10+#13#10+
  '������������ � ������������'+#13#10+
  'Nuclight aka [�������� �����]'+#13#10+#13#10+
  '������������ � ����������'+#13#10+
  'Mishanya aka [������� ������]'+#13#10+#13#10+
  '������ ������������� ���� ���������'+#13#10+
  'Zebr� aka [���������� �����]';  }
  Caption:= Caption + MainForm.ClientProperties.Version;
end;

procedure TAboutForm.OkBtnClick(Sender: TObject);
begin
  Close;
end;

end.