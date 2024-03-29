unit ChatYESNOUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, MMSystem, ArchiverUnit, sButton, sLabel;

type
  TChatYESNOForm = class(TForm)
    Button1: TsButton;
    Button2: TsButton;
    Label1: TsLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  ChatYESNOForm: TChatYESNOForm;
  

implementation



{$R *.dfm}

procedure TChatYESNOForm.Button2Click(Sender: TObject);
var
  onChat: string;
begin
 onChat:=#8+Char(Tag div 256)+
            Char(Tag mod 256);
 onChat:=#0+Char(Length(onChat) div 256)+
            Char(Length(onChat) mod 256)+onChat;
 MainForm.ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
  Close;
end;



procedure TChatYESNOForm.Button1Click(Sender: TObject);
var
  onChat: string;

begin
 onChat:=#7+Char(Tag div 256)+
            Char(Tag mod 256)+#0;
 onChat:=#0+Char(Length(onChat) div 256)+
            Char(Length(onChat) mod 256)+onChat;
 MainForm.ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
end;

procedure TChatYESNOForm.FormShow(Sender: TObject);
var
  index: integer;
begin
  Tag:=MainForm.ClientProperties.AlienID;
  index := MainForm.GetIndexByID(Tag);
  Label1.Caption := '�� ������� �������� '+
  MainForm.UserList.Items[index].Caption +
  MainForm.UserList.Items[index].SubItems[0]+'?';
  if(MainForm.SpeekerSettings.OptEnablesounds)then
    begin
      PlaySound(PChar(MainForm.SpeekerSettings.ChatSound),0,SND_FILENAME);
      MainForm.ChatSoundTimer.Enabled := true;
    end;
end;

procedure TChatYESNOForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.ChatSoundTimer.Enabled := false;
end;

end.
