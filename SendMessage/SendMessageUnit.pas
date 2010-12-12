unit SendMessageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ActnList, ComCtrls, sButton, sMemo, StrUtils,
  sRichEdit, ImgList, acAlphaImageList, ToolWin, sToolBar,RichEdit,
  ExtCtrls, sComboBoxes, sPanel, sComboBox, sDialogs;

const
  REPLY_TO_AUTHOR     = 1;
  REPLY_TO_GROUP      = 2;
  NEWMESSAGE_GROUP    = 3;
  NEWMESSAGE_PRIVATE  = 4;


type


   TSendMessageForm = class(TForm)
    send: TsButton;
    ActionList1: TActionList;
    SendMessage: TAction;
    SendMesCmbBox: TComboBoxEx;
    clear: TsButton;
    FillComboBox: TAction;
    Priority: TCheckBox;
    RichEdit1: TsRichEdit;
    EditToolBar: TsToolBar;
    boldTB: TToolButton;
    spaser: TToolButton;
    italicTB: TToolButton;
    underluneTB: TToolButton;
    spaser1: TToolButton;
    centerTB: TToolButton;
    leftTB: TToolButton;
    rightTB: TToolButton;
    Pleft: TAction;
    PCenter: TAction;
    PRight: TAction;
    ToolButton1: TToolButton;
    setButtons: TAction;
    SizeBox: TsComboBox;
    sColorBox1: TsColorBox;
    EditorImageList: TImageList;
    sFontBox: TsComboBox;
    sToolBar1: TsToolBar;
    procedure sendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SendMessageExecute(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure FillComboBoxExecute(Sender: TObject);
    procedure PriorityClick(Sender: TObject);
    procedure boldTBClick(Sender: TObject);
    procedure underluneTBClick(Sender: TObject);
    procedure italicTBClick(Sender: TObject);
    procedure PleftExecute(Sender: TObject);
    procedure PCenterExecute(Sender: TObject);
    procedure PRightExecute(Sender: TObject);
    procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure setButtonsExecute(Sender: TObject);
    procedure sColorBox1Change(Sender: TObject);
    procedure SizeBoxChange(Sender: TObject);
    procedure sFontBoxChange(Sender: TObject);
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
  CHBXpriority:boolean;

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
  tmpShift, Shift: integer;
  Text2Quote, MText, Delimiter, AuthorName: string;

begin

  Delimiter  := '-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-==-';
  RichEdit1.Text := MainForm.MessageMemo.Text;
  AuthorName := MainForm.MessagesListView.Selected.SubItems[6];
  MText := RichEdit1.Text;

  if Length(MText) > 1000 then
    begin
      delete(MText, 1, Length(MText)-1000);
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

  RichEdit1.Text := MText + Text2Quote + #13#10 + Delimiter + #13#10;
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

  // Пробегаем по всему списку пользователей
  for i:=0 to MainForm.UserList.Items.Count-1 do
    begin
      UserlistCompname := MainForm.UserList.Items[i].SubItems[0];
      // Сравниваем имя компьютера автора сообщения (поле в списке сообщений)
      // с именем компьютера текущего пользователя из списка
      if(StringCompare(MeslistCompname, UserlistCompname))then
      begin
        // В случае совпадения увеличиваем количество найденных на 1
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
  // Если найденных 1, то возвращаем первый элемент
  // из массива найденных элементов
  begin
      result:=ccIndexes[1];
  end
  else if((ccNumber>1) and (ccNumber<4))then
  begin
  // Если найденных больше одного, то пытаемся найти автора по ID
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

procedure TSendMessageForm.sendClick(Sender: TObject);
var
tmpStr,s:string;
StringStream:TStringStream;
begin
StringStream:=TStringStream.Create('');
  try
  RichEdit1.Lines.SaveToStream(StringStream);
  tmpStr:=StringStream.DataString;
  finally
  StringStream.destroy;
  end;

  s:= richedit1.Lines.Text;

if length(s)=0 then
  ShowMessage('Нельзя отправить пустое сообщение!')
 else
  if length(s)> 32768 then   ShowMessage('Слишком длинное сообщение!')
   else
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
              if(Application.MessageBox('Пользователь не найден. Ответить всем?',
                  'Пользователь не найден.', MB_YESNO)=IDYES)then
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
  sFontBox.Items:= Screen.Fonts;
  FillComboBox.Execute;
  RichEdit1.SelStart:=Length(RichEdit1.Text);
  RichEdit1.Perform(WM_VScroll, SB_BOTTOM,0);
  RichEdit1.SetFocus;

  end;

procedure TSendMessageForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RichEdit1.Clear;
  Action:=caFree;
end;

procedure TSendMessageForm.SendMessageExecute(Sender: TObject); // c2s #2
var
  tmpListItem: TListItem;
  s, tmpStr,messageLen:string;
  i,il,id,index:integer;
   StringStream:TStringStream;
begin
  StringStream:=TStringStream.Create('');
  try
  RichEdit1.Lines.SaveToStream(StringStream);
  tmpStr:=StringStream.DataString;
  finally
  StringStream.destroy;
  end;
 // REGetTextRange(richedit1,0,richedit1.MaxLength);
  richedit1.PlainText:=true;
  s:= richedit1.Lines.Text;
  if length(s)+length(tmpStr)+10< 65536 then
        messageLen:=Char(Length(s+#0+tmpStr) div 65536) + Char((Length(s+#0+tmpStr) mod 65536) div 256) + Char(Length(s+#0+tmpStr) mod 256)
       else
        messageLen:=Char(Length(s) div 65536) + Char((Length(s) mod 65536) div 256) + Char(Length(s) mod 256);
  s:=messageLen + s + #0 + tmpStr;
  id := StrToInt(String(SendMesCmbBox.ItemsEx[SendMesCmbBox.ItemIndex].Data));
  if CHBXpriority then
      s:=#2+Char(id div 256)+ Char(id mod 256)+#2+s     //  #2|sea user id|priority_0|#0|2 bytes message length | message
     else
      s:=#2+Char(id div 256)+ Char(id mod 256)+#0+s;
  i:=Length(s);
  //сообщение длинной 3 байта
  il:=i div 256;
  //|SEA Package Lenght|#2|sea user id|priority0|#0|2 bytes message length | message
  s:=Char(il div 256)+ Char(il mod 256) + Char(i mod 256) + s;  //s:=#0+Char(i div 256)+Char(i mod 256)+s;
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
            tmpListItem.SubItems.Add(RichEdit1.Text);
            tmpListItem.SubItems.Add(MainForm.UserList.Items[index].SubItems[1]);
          end;

  RichEdit1.Clear;
  Close;
end;

procedure TSendMessageForm.clearClick(Sender: TObject);
begin
  RichEdit1.Clear;
  RichEdit1.SetFocus;
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
  CHBXpriority:=false;
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
//
procedure TSendMessageForm.PriorityClick(Sender: TObject);
begin
CHBXpriority:= not CHBXpriority;
end;
//меняет выделенный текст на жирный
procedure TSendMessageForm.boldTBClick(Sender: TObject);
begin
   RichEdit1.SetFocus;
    if fsBold in Richedit1.SelAttributes.Style then
      Richedit1.SelAttributes.Style :=Richedit1.SelAttributes.Style - [fsBold]
    else
      Richedit1.SelAttributes.Style :=Richedit1.SelAttributes.Style + [fsBold];
    RichEdit1.SetFocus;
end;
//меняет выделенный текст на курсивный
procedure TSendMessageForm.italicTBClick(Sender: TObject);
begin
RichEdit1.SetFocus;
  if fsItalic in Richedit1.SelAttributes.Style then
    Richedit1.SelAttributes.Style :=Richedit1.SelAttributes.Style - [fsItalic]
  else
    Richedit1.SelAttributes.Style :=Richedit1.SelAttributes.Style + [fsItalic];
  RichEdit1.SetFocus;
end;
//меняет выделенный текст на подчеркнутый
procedure TSendMessageForm.underluneTBClick(Sender: TObject);
begin
RichEdit1.SetFocus;
  if fsUnderline in Richedit1.SelAttributes.Style then
    Richedit1.SelAttributes.Style :=Richedit1.SelAttributes.Style - [fsUnderline]
  else
    Richedit1.SelAttributes.Style :=Richedit1.SelAttributes.Style + [fsUnderline];
  RichEdit1.SetFocus;
end;
//paragrph to left
procedure TSendMessageForm.PleftExecute(Sender: TObject);
begin
   RichEdit1.Paragraph.Alignment:=taLeftJustify;
   Pleft.Checked:=true;
   setButtonsExecute(sender);
end;
//paragrph to center
procedure TSendMessageForm.PCenterExecute(Sender: TObject);
begin
   RichEdit1.Paragraph.Alignment:=taCenter;
   PCenter.Checked:=true;
   setButtonsExecute(sender);
end;
//paragrph to right
procedure TSendMessageForm.PRightExecute(Sender: TObject);
begin
  RichEdit1.Paragraph.Alignment:=taRightJustify;
  PRight.Checked:=true;
  setButtonsExecute(sender);
end;

procedure TSendMessageForm.RichEdit1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     setButtonsExecute(sender);
end;

procedure TSendMessageForm.setButtonsExecute(Sender: TObject);
begin
    richEdit1.SetFocus;
    PLeft.Checked:=false;
    LeftTB.Down:=false;
    PCenter.Checked:=false;
    CenterTB.Down:=false;
    PRight.Checked:=false;
    RightTB.Down:=false;
  case (RichEdit1.Paragraph.Alignment) of
  taLeftJustify:   begin
                    PLeft.Checked:=true;
                    LeftTB.Down:=true;
                   end;
  taCenter:        begin
                    PCenter.Checked:=true;
                    CenterTB.Down:=true;
                   end;
  taRightJustify:  begin
                    PRight.Checked:=true;
                    RightTB.Down:=true;
                   end
    end;
end;


procedure TSendMessageForm.sColorBox1Change(Sender: TObject);
begin
     richEdit1.SetFocus;
     RichEdit1.SelAttributes.Color:=sColorBox1.Selected;
     richEdit1.SetFocus;
end;

procedure TSendMessageForm.SizeBoxChange(Sender: TObject);
var
i:integer;
begin
  richEdit1.SetFocus;
  RichEdit1.SelAttributes.Size:= strtoint(SizeBox.Items[SizeBox.ItemIndex]);
  richEdit1.SetFocus;
  end;
procedure TSendMessageForm.sFontBoxChange(Sender: TObject);
begin
  richEdit1.SetFocus;
  RichEdit1.SelAttributes.Name:=sFontBox.Items[sFontBox.ItemIndex];
  richEdit1.SetFocus;
end;



{
procedure TSendMessageForm.ToolButton2Click(Sender: TObject);
var
line:string;
p:Tpoint;
begin
    RichEdit1.SetFocus;
    p:=richedit1.caretpos;
    p.x:=p.x+1;
    line:=richEdit1.Lines[richedit1.caretpos.y];
    richedit1.Lines.Delete(richedit1.caretpos.y);
    //преобразуем line
    Insert(':)',line,p.x);
    p.x:=p.x+1;
    richEdit1.Lines.Insert(richedit1.caretpos.y, line);
    richedit1.caretpos:=p;
    RichEdit1.SetFocus;
end;
}
end.


