unit NewChatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, sAlphaListBox, sEdit, sMemo,
  sPanel, sStatusBar, sButton, ActnList;

type
  TBChatForm = class(TForm)
    StatusBar1: TsStatusBar;
    Panel1: TsPanel;
    BChatMemo: TsMemo;
    Panel2: TsPanel;
    BChatEdit: TsEdit;
    ChatBufferLB: TsListBox;
    sButton1: TsButton;
    ActionList1: TActionList;
    Action1: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BChatEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Action1Execute(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    Number: string;
  end;

var
  BChatForm: TBChatForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TBChatForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  onChat: string;
  //strTag: string;
  i: integer;
begin
  //strTag:=IntToStr(Tag);
  BChatMemo.Lines.SaveToFile(MainForm.SpeekerSettings.UserAppdataDir+'\LastChat.txt');
  for i:=0 to MainForm.ChatListView.Items.Count-1 do
    if(Number=MainForm.ChatListView.Items[i].Caption)then
      begin
        break;
      end;
  
  onChat:=#8+Char(Tag div 256)+
            Char(Tag mod 256);
  onChat:=#0+Char(Length(onChat) div 256)+
            Char(Length(onChat) mod 256)+onChat;
  MainForm.ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));

  MainForm.ChatListView.Items.Delete(i);
  //MainForm.ClientProperties.LastChatHead:='��������� ��� ������ �';
  //MainForm.ClientProperties.LastChatCont:=BChatMemo.Text;

  Action:=caFree;
end;

procedure TBChatForm.FormShow(Sender: TObject);
begin
  //Tag:=MainForm.ClientProperties.AlienID;
end;

procedure TBChatForm.BChatEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if((Key = VK_UP)and(ChatBufferLB.ItemIndex<>-1))then
    if(ChatBufferLB.ItemIndex>0)then
      begin
        ChatBufferLB.ItemIndex := ChatBufferLB.ItemIndex - 1;
        BChatEdit.Text := ChatBufferLB.Items.Strings[ChatBufferLB.ItemIndex];
      end;
  if((Key = VK_DOWN)and(ChatBufferLB.ItemIndex<>-1))then
    if(ChatBufferLB.ItemIndex<ChatBufferLB.Items.Count-1)then
      begin
        ChatBufferLB.ItemIndex := ChatBufferLB.ItemIndex + 1;
        BChatEdit.Text := ChatBufferLB.Items.Strings[ChatBufferLB.ItemIndex];
      end;
end;



procedure TBChatForm.Action1Execute(Sender: TObject);
var
  ChatMessage: string;
  tmp: string;
begin
    if(Length(BChatEdit.Text)<>0)then
      begin
        tmp := BChatEdit.Text;
        BChatMemo.Lines.Add('['+TimeToStr(Time)+'] '+tmp);
        BChatEdit.Text:='';
        ChatMessage:=#7+Char(Tag div 256)+Char(Tag mod 256);
        ChatMessage:=ChatMessage+Char(Length(tmp) mod 256)+tmp;
        ChatMessage:=#0+Char(Length(ChatMessage) div 256)+
            Char(Length(ChatMessage) mod 256)+ChatMessage;
        MainForm.ClientSocket1.Socket.SendBuf(ChatMessage[1],length(ChatMessage));
        if(ChatBufferLB.Items.Count>99)then ChatBufferLB.Items.Delete(0);
        ChatBufferLB.Items.Add(tmp);
        ChatBufferLB.ItemIndex := ChatBufferLB.Items.Count-1;
      end
    else
      ShowMessage('You cannot send empty message!');
end;


end.
