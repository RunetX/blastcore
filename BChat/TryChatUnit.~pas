unit TryChatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TTryChatForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TryChatForm: TTryChatForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TTryChatForm.Button1Click(Sender: TObject);
var
  onChat: string;
  ID: integer;
begin
  ID:=StrToInt(MainForm.UserList.Selected.SubItems[1]);
 onChat:=#8+Char(ID div 256)+
            Char(ID mod 256);
 onChat:=#0+Char(Length(onChat) div 256)+
            Char(Length(onChat) mod 256)+onChat;
 MainForm.ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
 Close;
end;

procedure TTryChatForm.FormShow(Sender: TObject);
begin
  Label2.Caption := MainForm.UserList.Selected.Caption+
  MainForm.UserList.Selected.SubItems[0];
  Label2.Alignment := taCenter;
end;

end.
