unit SentMesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ActnList, sButton, sListView,
  sPanel;

type
  TSentMesForm = class(TForm)
    Panel1: TsPanel;
    SentMesLV: TsListView;
    ActionList1: TActionList;
    ReSend: TAction;
    Button1: TsButton;
    Button2: TsButton;
    Button3: TsButton;
    procedure ReSendExecute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function  StringCompare(s1, s2: string): boolean;
    function  FindUser(Comp, ID: string): integer;
  end;

var
  SentMesForm: TSentMesForm;

implementation

uses ArchiverUnit, SendMessageUnit;

{$R *.dfm}

function TSentMesForm.StringCompare(s1, s2: string): boolean;
var
  Len1, Len2, index: integer;
begin
  Len1 := Length(s1);
  Len2 := Length(s2);
  if Len1<>Len2 then
    result:=false
  else
  begin
    result:=true;
    for index:=1 to Len1 do
      if(s1[index]<>s2[index])then
      begin
          result:=false;
          break;
      end;
  end;
end;

function  TSentMesForm.FindUser(Comp, ID: string): integer;
var
  i: integer;
  ccNumber: integer;
  tmpWhomID: string;
  ccIndexes: array[1..3] of integer;

begin
  ccNumber:=0;
  Result := -1;
  for i:=0 to MainForm.UserList.Items.Count-1 do
      if(StringCompare(Comp, MainForm.UserList.Items[i].SubItems[0]))then
      begin
        if(ccNumber<4)then
        begin
          ccNumber:=ccNumber+1;
          ccIndexes[ccNumber]:=i;
        end;
      end;
  if(ccNumber=0)then
  begin
      result:=-1;
  end
  else if(ccNumber=1)then
  begin
      result:=ccIndexes[1];
  end
  else if((ccNumber>1) and (ccNumber<4))then
  begin
      for i:=1 to ccNumber do
      begin
        tmpWhomID:=ID;
        if(StringCompare(tmpWhomID, MainForm.UserList.Items[ccIndexes[i]].SubItems[1]))then
        begin
           Result := ccIndexes[i];
           break;
        end;
      end;
      if(Result=-1)then Result:= ccIndexes[1];
  end;
end;

procedure TSentMesForm.ReSendExecute(Sender: TObject);
var
    foundIndex: integer;
begin
    if((SentMesLV.Selected<>nil)and(MainForm.UserList.Selected<>nil))then
        begin
          foundIndex:=FindUser(SentMesLV.Selected.SubItems[2], SentMesLV.Selected.SubItems[4]);
          if(foundIndex>=0)then
            begin
              MainForm.UserList.Items[foundIndex].Selected:=true;
              MainForm.SendMessageFlag := 4;
              SendMessageForm := TSendMessageForm.Create(Self);
              SendMessageForm.RichEdit1.lines.Text:=SentMesLV.Selected.SubItems[3];
              SendMessageForm.Show;
            end
          else
            begin
              if(Application.MessageBox('Пользователь не найден. Ответить всем?',
            'Пользователь не найден.', MB_YESNO)=IDYES)then
                begin
                  MainForm.UserList.Items[0].Selected:=true;
                  MainForm.SendMessageFlag := 3;
                  SendMessageForm := TSendMessageForm.Create(Self);
                  SendMessageForm.RichEdit1.lines.Text:=SentMesLV.Selected.SubItems[3];
                  SendMessageForm.Show;
                end
              else
                Close;
            end;
        end;
end;

procedure TSentMesForm.Button2Click(Sender: TObject);
begin
  SentMesLV.Clear;
end;

procedure TSentMesForm.Button3Click(Sender: TObject);
begin
  Close;
end;

end.
