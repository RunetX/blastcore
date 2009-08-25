unit ChatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TChatForm = class(TForm)
    ChatEdit: TEdit;
    ChatMemo: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChatForm: TChatForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TChatForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainForm.ClientProperties.LastChatHead:='Последний чат закрыт в'+
    TimeToStr(Time)+', '+DateToStr(Date);
    MainForm.ClientProperties.LastChatCont:=ChatMemo.Text;
    ShowMessage('!');
    Action:=caFree;
end;

procedure TChatForm.FormShow(Sender: TObject);
var
    CurrentScreen: TScreen;
begin
    Top:=Round((CurrentScreen.Height-Height)/2);
    Left:=Round((CurrentScreen.Width-Width)/2);
end;

end.
