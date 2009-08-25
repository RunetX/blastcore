unit GroupInfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TGroupInfoForm = class(TForm)
    GrInfoListView: TListView;
    GetGIBtn: TButton;
    ClrGIBtn: TButton;
    DelayTimer: TTimer;
    procedure ClrGIBtnClick(Sender: TObject);
    procedure GetGIBtnClick(Sender: TObject);
    procedure DelayTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GroupInfoForm: TGroupInfoForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TGroupInfoForm.ClrGIBtnClick(Sender: TObject);
begin
  GrInfoListView.Clear;
end;

procedure TGroupInfoForm.GetGIBtnClick(Sender: TObject);
begin
    if(MainForm.ClientSocket1.Active)then
    begin
      GrInfoListView.Clear;
      DelayTimer.Enabled:=true;
    end
    else
      ShowMessage('��� ���������� [���. ������]!');
end;

procedure TGroupInfoForm.DelayTimerTimer(Sender: TObject);
var
    s: string;
    id: integer;

begin
      s := #0#0#3#5;

    MainForm.AlienInfo.UserName := MainForm.UserList.Items[DelayTimer.Tag].Caption;
    MainForm.AlienInfo.CompName := MainForm.UserList.Items[DelayTimer.Tag].SubItems[0];
    id := StrToInt(MainForm.UserList.Items[DelayTimer.Tag].SubItems[1]);
    s:=s + Char(id div 256)+ Char(id mod 256);
    if(MainForm.ClientSocket1.Active)then MainForm.ClientSocket1.Socket.SendBuf(s[1],length(s));
    DelayTimer.Enabled:=true;
    DelayTimer.Tag := DelayTimer.Tag + 1;
    if(DelayTimer.Tag>MainForm.UserList.Items.Count-1)then
    begin
      DelayTimer.Enabled:=false;
      DelayTimer.Tag:=2;
    end;
end;

procedure TGroupInfoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DelayTimer.Enabled:=false;
  DelayTimer.Tag:=2;
  GrInfoListView.Clear;
end;

end.
