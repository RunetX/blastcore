unit GroupInfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TGroupInfoForm = class(TForm)
    GrInfoListView: TsListView;
    GetGIBtn: TsButton;
    ClrGIBtn: TsButton;
    procedure ClrGIBtnClick(Sender: TObject);
    procedure GetGIBtnClick(Sender: TObject);
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
var
    s: string;
    i, id: integer;
begin
    if(MainForm.ClientSocket1.Active)then
    begin
      GrInfoListView.Clear;

      for i:=2 to MainForm.Userlist.Items.Count-1 do
        begin
          s := #0#0#3#5;
          MainForm.AlienInfo.UserName := MainForm.UserList.Items[i].Caption;
          MainForm.AlienInfo.CompName := MainForm.UserList.Items[i].SubItems[0];
          id := StrToInt(MainForm.UserList.Items[i].SubItems[1]);
          s:=s + Char(id div 256)+ Char(id mod 256);
          if(MainForm.ClientSocket1.Active)then MainForm.ClientSocket1.Socket.SendBuf(s[1],length(s));
        end;
      ShowMessage(IntToStr(i));
    end
    else
      ShowMessage('��� ���������� [���. ������]!');
end;

procedure TGroupInfoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  GrInfoListView.Clear;
end;

end.
