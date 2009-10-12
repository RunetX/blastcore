unit SendMessageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ActnList, ComCtrls, sButton, sMemo, StrUtils;

const
  REPLY_TO_AUTHOR     = 1;
  REPLY_TO_GROUP      = 2;
  NEWMESSAGE_GROUP    = 3;
  NEWMESSAGE_PRIVATE  = 4;


type
  TSendMessageForm = class(TForm)
    Memo1: TsMemo;
    Button4: TsButton;
    ActionList1: TActionList;
    SendMessage: TAction;
    SendMesCmbBox: TComboBoxEx;
    Button1: TsButton;
    FillComboBox: TAction;
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SendMessageExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FillComboBoxExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InsertLastName;

    function  FindUser(): integer;
    function  StringCompare(s1, s2: string): boolean;

  end;

var
  SendMessageForm: TSendMessageForm;


implementation

uses ArchiverUnit, SentMesUnit;



{$R *.dfm}

function TSendMessageForm.StringCompare(s1, s2: string): boolean;
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

procedure  TSendMessageForm.InsertLastName;
var
  index, j: integer;
  tmpShift, Shift, LinesEndIndex: integer;
  flag: integer;
  Text2Quote, MText, Delimiter, AuthorName: string;

begin
  flag := 0;
  Delimiter  := '-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-';
  Memo1.Text := MainForm.MessageMemo.Text;
  AuthorName := MainForm.MessagesListView.Selected.SubItems[6];
  MText := Memo1.Text;

  if Length(MText) > 2000 then
    begin
      delete(MText, 1, Length(MText)-2000);
      MText:='...' + #13#10 + MText;
    end;

  tmpShift := PosEx(Delimiter, MText, 1);
  Shift := tmpShift;

  while tmpShift <> 0 do
    begin
      Shift := tmpShift + Length(Delimiter) + 2;
      tmpShift := PosEx(Delimiter, MText, Shift);
    end;

  if Shift = 0 then Shift := 1;

  Text2Quote := Copy(MText, Shift, Length(MText)-Shift+1);
  Delete(MText, Shift, Length(MText)-Shift+1);

  Text2Quote := AuthorName + '> ' + stringReplace(Text2Quote, #13#10,
       #13#10 + AuthorName + '> ', [rfReplaceAll]);

  Memo1.Text := MText + Text2Quote + #13#10 + Delimiter + #13#10;
end;

function  TSendMessageForm.FindUser(): integer;
var
  i: integer;
  ccNumber: integer;
  tmpWhomID, MeslistCompname, UserlistCompname: string;
  ccIndexes: array[1..3] of integer;

begin
  ccNumber:=0;
  Result := -1;

  MeslistCompname  := MainForm.MessagesListView.Selected.SubItems[7];

  // ѕробегаем по всему списку пользователей
  for i:=0 to MainForm.UserList.Items.Count-1 do
    begin
      UserlistCompname := MainForm.UserList.Items[i].SubItems[0];
      // —равниваем им€ компьютера автора сообщени€ (поле в списке сообщений)
      // с именем компьютера текущего пользовател€ из списка
      if(StringCompare(MeslistCompname, UserlistCompname))then
      begin
        // ¬ случае совпадени€ увеличиваем количество найденных на 1
        // и заносим найденный индекс в массив
        // при условии, что количество найденных меньше 4
        if(ccNumber<4)then
        begin
          ccNumber:=ccNumber+1;
          ccIndexes[ccNumber]:=i;
        end;
      end;
    end;

  if(ccNumber=0)then
  begin
      result:=-1;
  end
  else if(ccNumber=1)then
  // ≈сли найденных 1, то возвращаем первый элемент
  // из массива найденных элементов
  begin
      result:=ccIndexes[1];
  end
  else if((ccNumber>1) and (ccNumber<4))then
  begin
  // ≈сли найденных больше одного, то пытаемс€ найти автора по ID
      for i:=1 to ccNumber do
      begin
        tmpWhomID:=MainForm.MessagesListView.Selected.Caption;
        if(StringCompare(tmpWhomID, MainForm.UserList.Items[ccIndexes[i]].SubItems[1]))then
        begin
           Result := ccIndexes[i];
           break;
        end;
      end;
      if(Result=-1)then Result:= ccIndexes[1];
  end;
end;

procedure TSendMessageForm.Button4Click(Sender: TObject);
begin
  SendMessage.Execute;
end;

procedure TSendMessageForm.FormShow(Sender: TObject);
var
  foundIndex: integer;
begin

  if(MainForm.SendMessageFlag < 3)then
    begin
      InsertLastName;

      if(MainForm.SendMessageFlag = REPLY_TO_AUTHOR)then
        begin
          foundIndex:=FindUser;

          if((foundIndex>0)and(foundIndex<MainForm.UserList.Items.Count))then
            MainForm.UserList.Items[foundIndex].Selected:=true
          else
            begin
              // insert dialog 'Answer to Group?'
              if(Application.MessageBox('ѕользователь не найден. ќтветить всем?',
                  'ѕользователь не найден.', MB_YESNO)=IDYES)then
                MainForm.UserList.Items[0].Selected:=true
              else
                Close;
            end;
        end
      else if(MainForm.SendMessageFlag = REPLY_TO_GROUP)then
        begin
          MainForm.UserList.Items[0].Selected:=true;
        end;
    end
  else if MainForm.SendMessageFlag = NEWMESSAGE_GROUP then
    begin
      MainForm.UserList.Items[0].Selected:=true;
    end;
  FillComboBox.Execute;
  Memo1.SelStart:=Length(Memo1.Text);
  Memo1.Perform(WM_VScroll, SB_BOTTOM,0);
  Memo1.SetFocus;
end;

procedure TSendMessageForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Memo1.Clear;
  Action:=caFree;
end;

procedure TSendMessageForm.SendMessageExecute(Sender: TObject);
var
  tmpListItem: TListItem;
  s{, tmpStr}:string;
  i:integer;
  id:integer;
  index:integer;
begin

  s := Memo1.Lines.Text;

  s:=Char(Length(s) div 256) + Char(Length(s) mod 256) + s;


  id := StrToInt(String(SendMesCmbBox.ItemsEx[SendMesCmbBox.ItemIndex].Data));
  s:=#2+Char(id div 256)+
        Char(id mod 256)+#0#0+s;
  i:=length(s);
  s:=#0+Char(i div 256)+Char(i mod 256)+s;
  MainForm.ClientSocket1.Socket.SendBuf(s[1],length(s));

  index := MainForm.GetIndexByID(id);
  if index <> -1 then
      with SentMesForm.SentMesLV do
          begin
            tmpListItem := Items.Add;
            tmpListItem.Caption:=DateToStr(Date);
            tmpListItem.SubItems.Add(TimeToStr(Time));
            tmpListItem.SubItems.Add(MainForm.UserList.Items[index].Caption);
            tmpListItem.SubItems.Add(MainForm.UserList.Items[index].SubItems[0]);
            tmpListItem.SubItems.Add(Memo1.Text);
            tmpListItem.SubItems.Add(MainForm.UserList.Items[index].SubItems[1]);
          end;

  Memo1.Clear;
  Close;
end;

procedure TSendMessageForm.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.SetFocus;
end;

procedure TSendMessageForm.FillComboBoxExecute(Sender: TObject);
var
  i: integer;
  ImageIndex: integer;
  caption: string;
  uID: Pointer;
begin

if Visible then
  begin
  SendMesCmbBox.Clear;
  for i:=0 to MainForm.UserList.Items.Count-1 do
  begin
     caption:= MainForm.UserList.Items[i].Caption+' '+
     MainForm.UserList.Items[i].SubItems[0];
     ImageIndex:=MainForm.UserList.Items[i].StateIndex;
     uID := Pointer(MainForm.UserList.Items[i].SubItems[1]);
     SendMesCmbBox.ItemsEx.AddItem(caption,
     ImageIndex, ImageIndex, -1, 0, uID);
  end;
  SendMesCmbBox.ItemIndex:=MainForm.UserList.Selected.Index;
  end;
end;

end.
