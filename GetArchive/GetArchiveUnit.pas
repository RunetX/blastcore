unit GetArchiveUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Htmlview, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TGetArchiveForm = class(TForm)
    Panel1: TPanel;
    HTMLViewer1: THTMLViewer;
    IdHTTP1: TIdHTTP;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GetArchiveForm: TGetArchiveForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TGetArchiveForm.FormShow(Sender: TObject);
var
  webAnswer, Buffer: string;
  PAnsiBuffer: PAnsiChar;
  stream:TMemoryStream;
begin
  stream:=TMemoryStream.Create;
    try
      IdHTTP1.Get(MainForm.SpeekerSettings.ArchiveLink+'archive/index2.cgi', stream);
    except

    end;
    HTMLViewer1.LoadFromStream(stream);
    stream.Free;
end;

procedure TGetArchiveForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   HTMLViewer1.Clear;
end;

end.