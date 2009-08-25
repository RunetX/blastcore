unit ArchiverUnit;

interface

uses
  Windows,
  SysUtils,
  Controls,
  Forms,
  Dialogs,
  CoolTrayIcon,
  Menus,
  IdHTTP,
  shellapi,
  ToolWin,
  ImgList,
  IniFiles,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  Classes,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  StdActns,
  Messages,
  Variants,
  Graphics,
   ScktComp, ActnList, Sockets, Registry;

type

  TInBufer = class
  public
    	HowmanyNeedRec:   integer;
    	CurrentOperation: integer;
      LastSEACommand  : integer;
    	isReadyForProc:   boolean;
    	tmpBufer:         string;
    	Bufer:	          string;

      procedure   GetInputBytes(i: integer);
      procedure   SetNextLength;
  end;

  TClientProperties = class
  public
      ClientIP:    string;
      Username:    string;
      Compname:    string;
      UsernameLen: integer;
      CompnameLen: integer;
      ClientIPLen: integer;
      UserlistLen: integer;
      AddUserQuery:integer;
      AlienID:     integer;
      Listcount:   integer;
      Users:       integer;

// LastMessage
      Privat:      integer;
      Printer:     integer;
      Meslen:      integer;
      Messag:      string;

  end;

  TProgSettings = class
  public
      UserAppdataDir: string;

      MainServerIP: string;
      AltServerIP:  string;
      UserName:     string;
      CompName:     string;
      Debug:        boolean;

  end;

  TAlienInfo = class
  public
      UserName:     string;
      CompName:     string;
      Room:         string;
      Info:         string;
      Faculty:      integer;
      Version:      string;
      IPAddress:    string;

  end;


  TMainForm = class(TForm)
    ClientSocket1: TClientSocket;
    StatusBar1: TStatusBar;
    TrayPopupMenu: TPopupMenu;
    ShowArchiver1: TMenuItem;
    Exit1: TMenuItem;
    IdHTTPostMessage: TIdHTTP;
    ActionList: TActionList;
    ConDiscon: TAction;
    OpenSiteAction: TAction;
    OpenNETArchiver1: TMenuItem;
    ToolBar1: TToolBar;
    IconsImageList: TImageList;
    ToolButton1: TToolButton;
    FirsmesToolButton: TToolButton;
    BackToolButton: TToolButton;
    ForwardToolButton: TToolButton;
    LastmesToolButton: TToolButton;
    ToolButton11: TToolButton;
    DelcurmesToolButton: TToolButton;
    DelchmesToolButton: TToolButton;
    DeleteAllMessages: TAction;
    DeleteAllChMessages: TAction;
    DeleteCurrentMessage: TAction;
    JumpToLast: TAction;
    JumpUp: TAction;
    JumpDown: TAction;
    JumpToFirst: TAction;
    DelallmesToolButton: TToolButton;
    PingTimer: TTimer;
    Timer1: TTimer;
    ImageList1: TImageList;
    GlukTimer: TTimer;
    ToolButton15: TToolButton;
    ConDisconToolBtn: TToolButton;
    LogTimer: TTimer;
    CloseProgamm: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    RichEditPopupMenu: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    N7: TMenuItem;
    Splitter1: TSplitter;
    UserList: TListView;
    DownPanel: TPanel;
    MessagesListView: TListView;
    MiddlePanel: TPanel;
    MesnumberLabel: TLabel;
    WhomEdit: TEdit;
    CoolTrayIcon: TCoolTrayIcon;
    MessageMemo: TMemo;
    PingTcpClient: TTcpClient;
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Exit1Click(Sender: TObject);
    procedure ShowArchiver1Click(Sender: TObject);
    procedure CoolTrayIconClick(Sender: TObject);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Connecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ConDisconExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CoolTrayIconDblClick(Sender: TObject);
    procedure OpenSiteActionExecute(Sender: TObject);
    procedure OpenNETArchiver1Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure DelChMessagesBtnClick(Sender: TObject);
    procedure UncheckAllMessagesBtnClick(Sender: TObject);
    procedure DeleteAllMessagesBtnClick(Sender: TObject);
    procedure MessagesListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CheckAllMessagesBtnClick(Sender: TObject);
    procedure DeleteAllMessagesExecute(Sender: TObject);
    procedure DeleteAllChMessagesExecute(Sender: TObject);
    procedure DelchmesToolButtonClick(Sender: TObject);
    procedure DeleteCurrentMessageExecute(Sender: TObject);
    procedure DelcurmesToolButtonClick(Sender: TObject);
    procedure JumpUpExecute(Sender: TObject);
    procedure JumpDownExecute(Sender: TObject);
    procedure ForwardToolButtonClick(Sender: TObject);
    procedure BackToolButtonClick(Sender: TObject);
    procedure JumpToLastExecute(Sender: TObject);
    procedure JumpToFirstExecute(Sender: TObject);
    procedure LastmesToolButtonClick(Sender: TObject);
    procedure FirsmesToolButtonClick(Sender: TObject);
    procedure DelallmesToolButtonClick(Sender: TObject);
    procedure PingTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GlukTimerTimer(Sender: TObject);
    procedure ConDisconToolBtnClick(Sender: TObject);
    procedure LogTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Exit2Click(Sender: TObject);
    procedure DownPanelClick(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure CloseProgammExecute(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  ClientProperties: TClientProperties;
  InBufer: TInBufer;
  SpeekerSettings: TProgSettings;
  AlienInfo: TAlienInfo;
     procedure GetID();
	   procedure GetIPLen();
	   procedure GetIP();
	   procedure GetListLen();
	   procedure GetUsernameLen();
	   procedure GetUsernameMy();
	   procedure GetCompnameLen();
	   procedure GetCompname();
     procedure GetSEACommand();
     procedure DelUserByID();
     procedure GetPrivate();
     procedure GetPrinter();
     procedure GetMeslen();
     procedure GetMessage();
     procedure GetZero();
     procedure GetFaculty();
     procedure GetRoom();
     procedure GetVersion();
     procedure GetInfolen();
     procedure GetInfo();
     procedure ReceiveForProcessing(ReadyBufer: string);
     procedure NullVaribles;
     procedure Reconnect;
     procedure LogVariable(Varname, Variable: string);

     function  GetIndexByID(ID: integer): integer;
     function  StringCompare(s1, s2: string): boolean;
  end;

var
  MainForm: TMainForm;




implementation





{$R *.dfm}

function TwoBytesToInt(twobytes: string): integer;
begin
   SetLength(twobytes, 2);
   result := 256*ord(twobytes[1])+ord(twobytes[2]);
end;

//-----------------------------------------------------------------


//-----------------------------------------------------------------

procedure TMainForm.LogVariable(Varname, Variable: string);
var
  logfile: TextFile;
  logstring: string;
begin
  AssignFile(logfile, 'nawelog.txt');
  try
    Append(logfile);
  except
    Rewrite(logfile);
  end;
  logstring:='['+DateToStr(Date)+']['+TimeToStr(Time)+']'+Varname+'='+Variable;
  Writeln(logfile, logstring);
  CloseFile(logfile);
end;
//-----------------------------------------------------------------

procedure TInBufer.GetInputBytes(i: integer);
var
  kusok: integer;
begin
  HowmanyNeedRec := HowmanyNeedRec - i;
  SetLength(tmpBufer, i);
  Bufer := Bufer + tmpBufer;
  if(HowmanyNeedRec=0) then
     isReadyForProc := true;
  if(HowmanyNeedRec<0) then
    begin
      kusok := Length(Bufer)+HowmanyNeedRec;
      tmpBufer := copy(Bufer, kusok, 0-HowmanyNeedRec);
      SetLength(Bufer, kusok);
      isReadyForProc := true;
    end;
end;

procedure   TInBufer.SetNextLength;
begin
  SetLength(tmpBufer, HowmanyNeedRec);
  Bufer:='';
end;

//-----------------------------------------------------------------

procedure TMainForm.NullVaribles;
var
  Ini: TIniFile;
  PanelState: boolean;
  ProgramDirectory: string;
begin
  // TInBufer
  InBufer.HowmanyNeedRec   := 1;
  InBufer.CurrentOperation := 9;
  InBufer.LastSEACommand   := -1;
  InBufer.isReadyForProc := false;
  InBufer.SetNextLength;

  // TClientProperties
   ClientProperties.ClientIP:= '';
   ClientProperties.Username:= '';
   ClientProperties.Compname:= '';
   ClientProperties.UsernameLen:= 0;
   ClientProperties.CompnameLen:= 0;
   ClientProperties.ClientIPLen:= 0;
   ClientProperties.UserlistLen:= 0;
   ClientProperties.AddUserQuery:=0;
   ClientProperties.AlienID:=     0;
   ClientProperties.Listcount:=   0;
   ClientProperties.Users:=       0;
      ClientProperties.Privat:=   0;
      ClientProperties.Printer:=  0;
      ClientProperties.Meslen:=   0;
      ClientProperties.Messag:=  '';

////////////////////////////////////////////////////////////////////////////////
 with TRegistry.Create do
 try
   RootKey := HKEY_CURRENT_USER;
   OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', True);
   SpeekerSettings.UserAppdataDir:=ReadString('AppData');
 finally
   CloseKey;
   Free;
 end;
 if (SpeekerSettings.UserAppdataDir<>'') and
    (SpeekerSettings.UserAppdataDir[length(SpeekerSettings.UserAppdataDir)]<>'\')
    then SpeekerSettings.UserAppdataDir:=SpeekerSettings.UserAppdataDir+'\';
 SpeekerSettings.UserAppdataDir := SpeekerSettings.UserAppdataDir+'BlastCore';
////////////////////////////////////////////////////////////////////////////////

  // TProgSettings.ReadSettings;
    ProgramDirectory := SpeekerSettings.UserAppdataDir;
    Ini := TIniFile.Create( ProgramDirectory+'\Settings.ini' );
  try
    SpeekerSettings.MainServerIP:= Ini.ReadString( 'Servers', 'MainServerIP','82.117.64.184');
    SpeekerSettings.AltServerIP := Ini.ReadString( 'Servers', 'AltServerIP' ,'82.117.64.157');

    SpeekerSettings.UserName := Ini.ReadString( 'User', 'UserName','');
    SpeekerSettings.CompName := Ini.ReadString( 'User', 'CompName','');
    SpeekerSettings.Debug      := Ini.ReadBool( 'Programm', 'Debug',  false);

    PanelState :=  Ini.ReadBool( 'Programm', 'ShowPanel', false);
  finally
    Ini.Free;
  end;
  //----------------------------------------------------------------------------

  if PanelState then
        DownPanel.Height := 150
  else
        DownPanel.Height := 4;

  // TAlienInfo  ---------------------------------------------------------------
    AlienInfo.UserName := '';
    AlienInfo.CompName := '';
    AlienInfo.Room     := '';
    AlienInfo.Info     := '';
    AlienInfo.Faculty  := 1;
    AlienInfo.Version  := '';
    AlienInfo.IPAddress:= '127.0.0.1';

end;

procedure TMainForm.Reconnect;
begin
   ConDiscon.Execute;
   Timer1.Enabled:=true;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetID();  // 1
var
  onChat, toBalloonHint: string;
  tmpIndex: integer;
  tmpListItem: TListItem;
begin
  ClientProperties.AlienID:=TwoBytesToInt(InBufer.Bufer);
  InBufer.isReadyForProc:=false;
  if SpeekerSettings.Debug then
      LogVariable('AlienID', IntToStr(ClientProperties.AlienID));

   if(InBufer.LastSEACommand=1)then
  begin
      InBufer.CurrentOperation:=2;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;

      with UserList do
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := ' АВТФ';
        tmpListItem.StateIndex:=0;
        tmpListItem.Selected:=true;
        tmpListItem.SubItems.Add('[ALL]');
        tmpListItem.SubItems.Add(IntToStr(0));

        tmpListItem := Items.Add;
        tmpListItem.Caption := ' Печатники';
        tmpListItem.StateIndex:=0;
        tmpListItem.SubItems.Add('[PRINTERS]');
        tmpListItem.SubItems.Add(IntToStr(-1));
    end;


  end
  else if(InBufer.LastSEACommand=2)then
  begin
            InBufer.CurrentOperation := 5;
            InBufer.HowmanyNeedRec := 1;
            InBufer.SetNextLength;
  end
  else if(InBufer.LastSEACommand=3)then
  begin
      DelUserByID;
      InBufer.CurrentOperation:=9;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
  end
  else if(InBufer.LastSEACommand=4)then
  begin
      InBufer.CurrentOperation:=10;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
  end
  else if(InBufer.LastSEACommand=7)then
      begin
 onChat:=#8+Char(ClientProperties.AlienID div 256)+
            Char(ClientProperties.AlienID mod 256);
 onChat:=#0+Char(Length(onChat) div 256)+
            Char(Length(onChat) mod 256)+onChat;
 ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
 ClientSocket1.Socket.ReceiveBuf(onChat[1], 1);
         InBufer.CurrentOperation:=9;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand=8)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
            begin

//---------------------------------------------------------------
   toBalloonHint:= 'Вы не ответили на пользователю на чат-запрос...';
   with MessagesListView do
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := IntToStr(ClientProperties.AlienID);
        tmpListItem.SubItems.Add('1');
        tmpListItem.SubItems.Add('0');
        tmpListItem.SubItems.Add('NA');
        tmpListItem.SubItems.Add(toBalloonHint);
        tmpListItem.SubItems.Add(TimeToStr(Time));
        tmpListItem.SubItems.Add(DateToStr(Date));
        tmpListItem.SubItems.Add(UserList.Items[tmpIndex].Caption);
        tmpListItem.SubItems.Add(UserList.Items[tmpIndex].SubItems[0]);
    end;
  CoolTrayIcon.ShowBalloonHint(UserList.Items[tmpIndex].Caption+' '+
  UserList.Items[tmpIndex].SubItems[0], toBalloonHint, bitWarning, 10);
  MessagesListView.Items[MessagesListView.Items.Count-1].Selected:=true;
//---------------------------------------------------------------

            end
         else
            //ShowMessage('Com11: Индекс вышел за границы!');
            Reconnect;

         InBufer.CurrentOperation:=9;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand=10)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
            begin
//---------------------------------------------------------------
   toBalloonHint:= 'Пользователь игнорирует Ваши сообщения.';
   with MessagesListView do
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := IntToStr(ClientProperties.AlienID);
        tmpListItem.SubItems.Add('1');
        tmpListItem.SubItems.Add('0');
        tmpListItem.SubItems.Add('NA');
        tmpListItem.SubItems.Add(toBalloonHint);
        tmpListItem.SubItems.Add(TimeToStr(Time));
        tmpListItem.SubItems.Add(DateToStr(Date));
        tmpListItem.SubItems.Add(UserList.Items[tmpIndex].Caption);
        tmpListItem.SubItems.Add(UserList.Items[tmpIndex].SubItems[0]);
    end;
  CoolTrayIcon.ShowBalloonHint(UserList.Items[tmpIndex].Caption+' '+
  UserList.Items[tmpIndex].SubItems[0], toBalloonHint, bitWarning, 10);
  MessagesListView.Items[MessagesListView.Items.Count-1].Selected:=true;
//---------------------------------------------------------------
            end
         else
            //ShowMessage('Com11: Индекс вышел за границы!');
            Reconnect;

         InBufer.CurrentOperation:=9;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand=11)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
          begin
            UserList.Items[tmpIndex].StateIndex:=2;
            
          end
         else
            //ShowMessage('Com11: Индекс вышел за границы!');
            Reconnect;

         InBufer.CurrentOperation:=9;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else  if(InBufer.LastSEACommand=12)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
          begin
            UserList.Items[tmpIndex].StateIndex:=1;

          end
         else
            //ShowMessage('Com12: Индекс вышел за границы!');
            Reconnect;

         InBufer.CurrentOperation:=9;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand=13)then
      begin
        InBufer.CurrentOperation:=22;
        InBufer.HowmanyNeedRec := 4;
        InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand=14)then
  begin
      InBufer.CurrentOperation:=5;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
  end
  else
  begin
      //ClientSocket1.Socket.ReceiveBuf(InBufer.Bufer,
      //ClientSocket1.Socket.ReceiveLength);
      Reconnect;
      {
      InBufer.CurrentOperation:=9;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
      }
  end;
end;

//-----------------------------------------------------------------

procedure TMainForm.GetIPLen();   // 2
begin
  ClientProperties.ClientIPLen := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('ClientIPLen', IntToStr(ClientProperties.ClientIPLen));
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation:=3;
  InBufer.HowmanyNeedRec := ClientProperties.ClientIPLen;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetIP();      // 3
var
  s: string;
begin
  InBufer.isReadyForProc:=false;
  if(InBufer.LastSEACommand=6)then
      begin
          AlienInfo.IPAddress := InBufer.Bufer;
          if SpeekerSettings.Debug then
            LogVariable('IPAddress', AlienInfo.IPAddress);
          InBufer.CurrentOperation:=9;
          InBufer.HowmanyNeedRec := 1;
          InBufer.SetNextLength;

          s:='User Name: '+AlienInfo.UserName+#13#10;
          s:=s+'Computer Name: '+AlienInfo.CompName+#13#10;

          if(AlienInfo.Faculty=1)then
              s:=s+'Faculty: АВТ'+#13#10
          else
              s:=s+'Faculty: МС'+#13#10;

          s:=s+'Room: '+AlienInfo.Room+#13#10;
          s:=s+'Info: '+AlienInfo.Info+#13#10;
          s:=s+'Version: '+AlienInfo.Version+#13#10;
          s:=s+'IP Address : '+AlienInfo.IPAddress;
          ShowMessage(s);

      end
  else
      begin
          ClientProperties.ClientIP := InBufer.Bufer;
          if SpeekerSettings.Debug then
            LogVariable('ClientIP', ClientProperties.ClientIP);
          StatusBar1.Panels[2].Text := 'Ваш IP-адрес: '+ClientProperties.ClientIP;
          InBufer.CurrentOperation:=4;
          InBufer.HowmanyNeedRec := 2;
          InBufer.SetNextLength;
      end;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetListLen(); // 4
begin
  ClientProperties.UserlistLen := TwoBytesToInt(InBufer.Bufer);
  if SpeekerSettings.Debug then
      LogVariable('UserlistLen', IntToStr(ClientProperties.UserlistLen));
  ClientProperties.AddUserQuery := ClientProperties.UserlistLen;
  InBufer.isReadyForProc:=false;

  InBufer.CurrentOperation:=1;
  InBufer.LastSEACommand := 2;
  InBufer.HowmanyNeedRec := 2;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetUsernameLen();//5
begin
  ClientProperties.UsernameLen := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('UsernameLen', IntToStr(ClientProperties.UsernameLen));
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation:=6;
  InBufer.HowmanyNeedRec := ClientProperties.UsernameLen;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

function  TMainForm.GetIndexByID(ID: integer): integer;
var
  Buf1: string;
  i:   integer;
begin
  result:=-1;
  for i:=2 to Userlist.Items.Count-1 do
  begin
    Buf1 := Userlist.Items[i].SubItems[1];
    if(StrToInt(Buf1)=ID) then
      begin
        result:=i;
        break;
      end;
  end;
  if SpeekerSettings.Debug then
      LogVariable('GetIndexByID', IntToStr(result));
end;

//-----------------------------------------------------------------
procedure TMainForm.GetUsernameMy();// 6
var
  tmpIndex: integer;
begin
  ClientProperties.Username := InBufer.Bufer;
  if SpeekerSettings.Debug then
      LogVariable('Username', ClientProperties.Username);
  InBufer.isReadyForProc:=false;
  if(InBufer.LastSEACommand=14)then
      begin
          tmpIndex := GetIndexByID(ClientProperties.AlienID);
          UserList.Items[tmpIndex].Caption:=ClientProperties.Username;
          InBufer.CurrentOperation:=9;
      end
  else
      begin
          InBufer.CurrentOperation:=7;
      end;

  InBufer.HowmanyNeedRec := 1;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetCompnameLen();//7
begin
  ClientProperties.CompnameLen := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('CompnameLen', IntToStr(ClientProperties.CompnameLen));
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation:=8;
  InBufer.HowmanyNeedRec := ClientProperties.CompnameLen;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetCompname();// 8
var
  tmpListItem: TListItem;
  TCPUsrs: string;
begin
        ClientProperties.Compname := InBufer.Bufer;
        if SpeekerSettings.Debug then
          LogVariable('Compname', ClientProperties.Compname);
        InBufer.isReadyForProc:=false;

  with UserList do
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := ClientProperties.Username;
        tmpListItem.StateIndex:=1;
        tmpListItem.SubItems.Add('['+ClientProperties.Compname+']');
        tmpListItem.SubItems.Add(IntToStr(ClientProperties.AlienID));
    end;

  if ClientProperties.AddUserQuery>0 then
      Dec(ClientProperties.AddUserQuery);
      
  Inc(ClientProperties.Users);
  StatusBar1.Panels[3].Text:='Количество пользователей: '+IntToStr(ClientProperties.Users);

  if(ClientProperties.AddUserQuery>0)then
        begin
            InBufer.CurrentOperation := 1;
            InBufer.HowmanyNeedRec   := 2;
        end
      else
        begin

            SetLength(TCPUsrs, 2);
            ClientSocket1.Socket.ReceiveBuf(TCPUsrs[1], 2);
            InBufer.CurrentOperation := 9;
            InBufer.HowmanyNeedRec   := 1;

        end;
   InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

procedure TMainForm.DelUserByID();
var
  i, j, tmpIndex: integer;
begin
   tmpIndex := GetIndexByID(ClientProperties.AlienID);
   if SpeekerSettings.Debug then
      LogVariable('Index[DelUserByID]', IntToStr(tmpIndex));
   if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
      begin
         i:= UserList.Selected.Index;
         j:= UserList.Items.Count-1;
         UserList.Items.Delete(tmpIndex);
         Dec(ClientProperties.Users);
         StatusBar1.Panels[3].Text :='Количество пользователей: '+ IntToStr(ClientProperties.Users);

          if i<>j then
              UserList.Items[i].Selected:=true
          else
              UserList.Items[i-1].Selected:=true;
      end
   else
       Reconnect;
       //ShowMessage('DelUserByID: Индекс вышел за границы! Index='+IntToStr(tmpIndex));
end;

//-----------------------------------------------------------------

procedure TMainForm.GETSEACommand(); // 9
begin
  InBufer.LastSEACommand := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('LastSEACommand', IntToStr(InBufer.LastSEACommand));
  InBufer.isReadyForProc := false;
  if(InBufer.LastSEACommand<>6)then
      begin
          InBufer.CurrentOperation:=1;
          InBufer.HowmanyNeedRec := 2;
      end
  else
      begin
          InBufer.CurrentOperation:=15;
          InBufer.HowmanyNeedRec := 1;
      end;
  InBufer.SetNextLength;
end;

procedure TMainForm.GetPrivate();    // 10
begin
  ClientProperties.Privat := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('Privat', IntToStr(ClientProperties.Privat));
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation:=11;
  InBufer.HowmanyNeedRec := 2;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

procedure TMainForm.GetPrinter();    // 11
begin
  ClientProperties.Printer := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('Printer', IntToStr(ClientProperties.Printer));
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation:=12;
  InBufer.HowmanyNeedRec := 2;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

procedure TMainForm.GetMeslen();     // 12
begin
  ClientProperties.Meslen := TwoBytesToInt(InBufer.Bufer);
  if SpeekerSettings.Debug then
      LogVariable('Meslen', IntToStr(ClientProperties.Meslen));
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation:=13;
  InBufer.HowmanyNeedRec := ClientProperties.Meslen+1;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

procedure TMainForm.GetMessage();    // 13
var
   tmpListItem: TListItem;
   tmpIndex: integer;
   toSaveString: string;
   toSavePOST: TStringList;
//   toBalloonHint: string;
//   MessageLen: integer;
   POSTScript: string;
begin
  ClientProperties.Messag := InBufer.Bufer;
  if SpeekerSettings.Debug then
      LogVariable('Messag', ClientProperties.Messag);
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation:=9;
  InBufer.HowmanyNeedRec := 1;
  InBufer.SetNextLength;

  tmpIndex := GetIndexByID(ClientProperties.AlienID);
  if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
  begin
   with MessagesListView do          //TListView
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := IntToStr(ClientProperties.AlienID);
        tmpListItem.SubItems.Add(IntToStr(ClientProperties.Privat));
        tmpListItem.SubItems.Add(IntToStr(ClientProperties.Printer));
        tmpListItem.SubItems.Add(IntToStr(ClientProperties.Meslen));
        tmpListItem.SubItems.Add(ClientProperties.Messag);
        tmpListItem.SubItems.Add(TimeToStr(Time));
        tmpListItem.SubItems.Add(DateToStr(Date));
        tmpListItem.SubItems.Add(UserList.Items[tmpIndex].Caption);
        tmpListItem.SubItems.Add(UserList.Items[tmpIndex].SubItems[0]);
    end;
  {toBalloonHint:= ClientProperties.Messag;
  MessageLen := ClientProperties.Meslen;
  if MessageLen>255 then
  begin
      delete(toBalloonHint, 1, 256*(MessageLen div 256));
      toBalloonHint:='...'+#13#10+toBalloonHint;
  end;

  CoolTrayIcon.ShowBalloonHint(UserList.Items[tmpIndex].Caption+' '+
  UserList.Items[tmpIndex].SubItems[0], toBalloonHint, bitInfo, 10);}

  // POST request  -----------------------------
  if(ClientProperties.Privat=0)then
     POSTScript:= 'http://hostel.avtf.net/~peek/archive/savemessage.pl'
  else
     POSTScript:= 'http://hostel.avtf.net/~peek/archive/private/savemessage.pl';

  toSaveString:=TimeToStr(Time)+'||**||'+UserList.Items[tmpIndex].Caption+
  UserList.Items[tmpIndex].SubItems[0]+'||**||'
  +StringReplace(ClientProperties.Messag, #13#10, '[BR]', [rfReplaceAll])
  +#13#10;

  toSavePOST := TStringList.Create;
  toSavePOST.Add('tosave='+toSaveString);  //TIdHTTP  try
  try
    IdHTTPostMessage.Post(POSTScript, toSavePOST);
  except
    //begin end;
  end;
  toSavePOST.Free;

  //--------------------------------------------
  //HTMLViewer1.LoadFromString(ClientProperties.Messag);
  MessagesListView.Items[MessagesListView.Items.Count-1].Selected:=true;
  end
  else
    begin
      Reconnect;
      {ShowMessage('Index out of range [GetMessage]. AlienID='
      +IntToStr(ClientProperties.AlienID));}
    end;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetZero(); // 14
begin
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation:=9;
  InBufer.HowmanyNeedRec := 1;
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetFaculty();   // 15
begin                                    //TApplication
  AlienInfo.Faculty := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('Faculty', IntToStr(AlienInfo.Faculty));
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation:=16;
  InBufer.HowmanyNeedRec := 5;
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetRoom();      //16
var
  posic: integer;
begin
  AlienInfo.Room := InBufer.Bufer;
  if SpeekerSettings.Debug then
      LogVariable('Room', AlienInfo.Room);
  posic := pos(#0, AlienInfo.Room);
  while(posic<>0) do
  begin
    delete(AlienInfo.Room, posic, 1);
    posic := pos(#0, AlienInfo.Room);
  end;

  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation:=18;
  InBufer.HowmanyNeedRec := 1;
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetVersion();   // 17
var ver: byte;
begin
    ver:=ord(InBufer.Bufer[1]);
    if SpeekerSettings.Debug then
      LogVariable('ver', IntToStr(ver));
    AlienInfo.Version := chr(48 + ver div 100) + '.' +
                         chr(48 + (ver mod 100) div 10) + '.' +
                         chr(48 + ver mod 10);
    InBufer.isReadyForProc:=false;
    InBufer.CurrentOperation:= 2;
    InBufer.HowmanyNeedRec  := 1;
    InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetInfolen();   // 18
begin
  InBufer.isReadyForProc := false;

  if(ord(InBufer.Bufer[1])=0)then
    begin
      AlienInfo.Info := '';
      InBufer.CurrentOperation:=17;
      InBufer.HowmanyNeedRec := 1;
    end
  else
    begin
      InBufer.CurrentOperation:=19;
      InBufer.HowmanyNeedRec := ord(InBufer.Bufer[1]);
      if SpeekerSettings.Debug then
          LogVariable('Infolen', IntToStr(InBufer.HowmanyNeedRec));
    end;
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetInfo();      // 19
begin
    AlienInfo.Info := InBufer.Bufer;
    if SpeekerSettings.Debug then
          LogVariable('Info', AlienInfo.Info);
    InBufer.isReadyForProc:=false;
    InBufer.CurrentOperation:=17;
    InBufer.HowmanyNeedRec := 1;
    InBufer.SetNextLength;
end;
//-----------------------------------------------------------------


//-----------------------------------------------------------------

procedure TMainForm.ReceiveForProcessing(ReadyBufer: string);
begin
  if(InBufer.CurrentOperation=1)then             // 1. GetID
    begin
      GetID;
    end
  else if(InBufer.CurrentOperation=2)then        // 2. GetIPLen
    begin
      GetIPLen;
    end
  else if(InBufer.CurrentOperation=3)then        // 3. GetIP
    begin
      GetIP;
    end
  else if(InBufer.CurrentOperation=4)then        // 4. GetListLen
    begin
      GetListLen;
    end
  else if(InBufer.CurrentOperation=5)then        // 5. GetUsernameLen
    begin
      GetUsernameLen;
    end
  else if(InBufer.CurrentOperation=6)then        // 6. GetUsernameMy
    begin
      GetUsernameMy;
    end
  else if(InBufer.CurrentOperation=7)then        // 7. GetCompnameLen
    begin
      GetCompnameLen;
    end
  else if(InBufer.CurrentOperation=8)then        // 8. GetCompname
    begin
      GetCompname;
    end
  else if(InBufer.CurrentOperation=9)then        // 9. GetSEACommand
    begin
      GetSEACommand;
    end
  else if(InBufer.CurrentOperation=10)then        // 10. GetPrivate
    begin
      GetPrivate;
    end
  else if(InBufer.CurrentOperation=11)then        // 11. GetPrinter
    begin
      GetPrinter;
    end
  else if(InBufer.CurrentOperation=12)then        // 12. GetMeslen
    begin
      GetMeslen;
    end
  else if(InBufer.CurrentOperation=13)then        // 13. GetMessage
    begin
      GetMessage;
    end
  else if(InBufer.CurrentOperation=14)then        // 14. GetZero
    begin
      GetZero;
    end
  else if(InBufer.CurrentOperation=15)then        // 15. GetFaculty
    begin
      GetFaculty;
    end
  else if(InBufer.CurrentOperation=16)then        // 16. GetRoom
    begin
      GetRoom;
    end
  else if(InBufer.CurrentOperation=17)then        // 17. GetVersion
    begin
      GetVersion;
    end
  else if(InBufer.CurrentOperation=18)then        // 18. GetInfoLen
    begin
      GetInfolen;
    end
  else if(InBufer.CurrentOperation=19)then        // 19. GetInfo
    begin
      GetInfo;
    end
  else if(InBufer.CurrentOperation=22)then        // 22. #13
    begin
      ShowMessage(InBufer.Bufer);
      InBufer.isReadyForProc := false;
      InBufer.CurrentOperation:=9;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
    end
  else
    begin
      Reconnect;
      {ShowMessage('Unknown command!');
      InBufer.isReadyForProc := false;
      InBufer.CurrentOperation:=9;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;}
    end;
end;

//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  s:string;
  ns:string;
  BalloonMessage: string;
  i:integer;
  j:integer;
  
  room,
  info:string;
begin


  if(ClientSocket1.Address=SpeekerSettings.AltServerIP)then
      PingTimer.Enabled:=true
  else
      PingTimer.Enabled:=false;      
      
  MainForm.Cursor:=crDefault;
  {UserName}
  s:=Char(Length(SpeekerSettings.UserName))+SpeekerSettings.UserName;
  {CompName}
  s:=s+Char(Length(SpeekerSettings.CompName))+SpeekerSettings.CompName;
  s:=#1+s;
  i:=length(s);
  {Three bytes of length}
  s:=#0+Char(i div 256)+Char(i mod 256)+s;
  {HueMoe}
  Socket.SendBuf(s[1],length(s));
  room:='119-a';
  info:='';
  ns:= Char(Length(info))+info;
  ns:= room+ns+#92;//Версия
  ns:= #4+#1+ns;
  j:=length(ns);
  ns:=#0+Char(j div 256)+Char(j mod 256)+ns;
  Socket.SendBuf(ns[1],length(ns));
     {TClientSocket}

  if(ClientSocket1.Active)then
    begin
        BalloonMessage:='Соединено';
        StatusBar1.Panels[0].Text:='Соединено';
    end
  else
    begin
        BalloonMessage:='Разъединено';
        StatusBar1.Panels[0].Text:='Разъединено';
        Reconnect;
    end;
  CoolTrayIcon.ShowBalloonHint('Соединение', BalloonMessage, bitInfo, 10);
end;

//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  BalloonMessage: string;
  PanelState: boolean;
  sIniFile: TIniFile;
begin
    if DownPanel.Height=150 then
        PanelState:=true
    else
        PanelState:=false;

    sIniFile := TIniFile.Create(SpeekerSettings.UserAppdataDir + '\Settings.ini');

    sIniFile.WriteBool('Programm', 'ShowPanel', PanelState);
    sIniFile.Free;

  UserList.Clear;
  ClientProperties.Users:=0;
  StatusBar1.Panels[3].Text:='Число пользователей: 0';
  if(ClientSocket1.Active)then
  begin
      BalloonMessage:='Connected';
      StatusBar1.Panels[0].Text:='Соединено';
  end
  else
  begin
      BalloonMessage:='Разъединено';
      StatusBar1.Panels[0].Text:='Разъединено';
  end;
  CoolTrayIcon.ShowBalloonHint('Соединение', BalloonMessage, bitInfo, 10);
end;

//-----------------------------------------------------------------

procedure TMainForm.Exit1Click(Sender: TObject);
begin
    CloseProgamm.Execute;
end;

//-----------------------------------------------------------------

procedure TMainForm.ShowArchiver1Click(Sender: TObject);
begin
  CoolTrayIcon.ShowMainForm;
end;

//-----------------------------------------------------------------

procedure TMainForm.CoolTrayIconClick(Sender: TObject);
var
  BalloonMessage: string;
begin
  if(ClientSocket1.Active)then BalloonMessage:=ClientSocket1.Address
  else BalloonMessage:='Разъединено';
  CoolTrayIcon.ShowBalloonHint('Сокет соединение', BalloonMessage, bitInfo, 10);
end;
             
//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;

  if(ClientSocket1.Address=SpeekerSettings.MainServerIP)then
  begin
    ClientSocket1.Close;
    ClientSocket1.Address:=SpeekerSettings.AltServerIP;
  try
    ClientSocket1.Open;
  except
    ClientSocket1.Close;
  end;
  end
  else if(ClientSocket1.Address=SpeekerSettings.AltServerIP)then
  begin
    ClientSocket1.Close;
    ClientSocket1.Address:=SpeekerSettings.MainServerIP;
  try
    ClientSocket1.Open;
  except
    ClientSocket1.Close;
  end;
  end;
end;

//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  MainForm.Cursor:=crHourGlass;
  StatusBar1.Panels[0].Text:='Соединение...';
end;

//-----------------------------------------------------------------

procedure TMainForm.ConDisconExecute(Sender: TObject);
var
  tmp:  DWORD;
  tmp2: String;
begin


    if(ClientSocket1.Active)then
  begin
    ClientSocket1.Close;
    ConDisconToolBtn.ImageIndex:=14;
  end
  else
  begin
  try
    NullVaribles;
    if Length(SpeekerSettings.UserName)=0 then
    begin
      tmp:= 32767;
      SetLength(tmp2, tmp);
      GetUserName(PChar(tmp2), tmp);
      SpeekerSettings.UserName := tmp2;
      SetLength(SpeekerSettings.UserName,(pos(#0, tmp2)-1));
    end;
  if Length(SpeekerSettings.CompName)=0 then
    begin
      tmp:= 32767;
      SetLength(tmp2, tmp);
      GetComputerName(PChar(tmp2), tmp);
      SpeekerSettings.CompName := tmp2;
      SetLength(SpeekerSettings.CompName,(pos(#0, tmp2)-1));
    end;

    ClientSocket1.Address:=SpeekerSettings.MainServerIP;
    ClientSocket1.Open;
    ConDisconToolBtn.ImageIndex:=13;
  except
    ClientSocket1.Close;
    ConDisconToolBtn.ImageIndex:=14;
  end;
  end;
end;

//-----------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin 
  Caption := Caption + ' '+TimeToStr(Time)+' '+DateToStr(Date);
  // Set Hints --------------

  FirsmesToolButton.Hint   := FirsmesToolButton.Hint+#13#10+'ctrl+PgUp';
  BackToolButton.Hint      := BackToolButton.Hint+#13#10+'ctrl+<-';
  ForwardToolButton.Hint   := ForwardToolButton.Hint+#13#10+'ctrl+->';
  LastmesToolButton.Hint   := LastmesToolButton.Hint+#13#10+'ctrl+PgDwn';
  DelcurmesToolButton.Hint := DelcurmesToolButton.Hint+#13#10+'ctrl+Del';
  DelchmesToolButton.Hint  := DelchmesToolButton.Hint+#13#10+'ctrl+C';
  DelallmesToolButton.Hint := DelallmesToolButton.Hint+#13#10+'ctrl+A';
  ConDisconToolBtn.Hint    := ConDisconToolBtn.Hint+#13#10+'ctrl+Q';

  //-------------------------

  CoolTrayIcon.IconIndex:=3;

  InBufer:= TInBufer.Create;
  ClientProperties:= TClientProperties.Create;
  SpeekerSettings:= TProgSettings.Create;
  AlienInfo:= TAlienInfo.Create;
  NullVaribles;
  if SpeekerSettings.Debug then
      LogTimer.Enabled:=true;
  ConDiscon.Execute;
end;

//-----------------------------------------------------------------

procedure TMainForm.CoolTrayIconDblClick(Sender: TObject);
begin
  CoolTrayIcon.ShowMainForm;
end;

//-----------------------------------------------------------------

procedure TMainForm.OpenSiteActionExecute(Sender: TObject);
  var wnd:HWND;
begin
  ShellExecute(wnd, 'open', 'http://hostel.avtf.net/~peek/archive/',
  NIL, NIL, SW_SHOWMAXIMIZED);
end;

//-----------------------------------------------------------------

procedure TMainForm.OpenNETArchiver1Click(Sender: TObject);
begin
  OpenSiteAction.Execute;
end;

//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: integer;
begin
  i := Socket.ReceiveBuf(InBufer.tmpBufer[1], InBufer.HowmanyNeedRec);
    if i>0 then
    begin
      InBufer.GetInputBytes(i);
      if (InBufer.isReadyForProc) then
        ReceiveForProcessing(InBufer.Bufer);
    end;
end;

procedure TMainForm.DelChMessagesBtnClick(Sender: TObject);
begin
    DeleteAllChMessages.Execute;
end;

procedure TMainForm.UncheckAllMessagesBtnClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to MessagesListView.Items.Count-1 do
    MessagesListView.Items[i].Checked:=false;
end;

procedure TMainForm.DeleteAllMessagesBtnClick(Sender: TObject);
begin
  DeleteAllMessages.Execute;
end;

procedure TMainForm.MessagesListViewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  tmpListItem: TListItem;
  CheckedNumber: integer;
  i: integer;
begin
  tmpListItem := MessagesListView.Selected;
  if tmpListItem <> nil then
  begin
      MessageMemo.Clear;
      MessageMemo.Text:= MessagesListView.Selected.SubItems[3];
      MessageMemo.SelStart:=Length(MessageMemo.Text);
      MessageMemo.Perform(WM_VScroll, SB_LINEDOWN,0);
      WhomEdit.Text := MessagesListView.Selected.SubItems[6]
                     + MessagesListView.Selected.SubItems[7];
      if(StrToInt(MessagesListView.Selected.SubItems[0])=1)then
        if(StrToInt(MessagesListView.Selected.SubItems[1])=0)then
            WhomEdit.Text := WhomEdit.Text + ' -> ' + SpeekerSettings.UserName
        else
            WhomEdit.Text := WhomEdit.Text + ' Печатникам'
      else
            WhomEdit.Text := WhomEdit.Text + ' Всем';
      WhomEdit.Text := WhomEdit.Text+' в '+ MessagesListView.Selected.SubItems[4]+
      ', '+ MessagesListView.Selected.SubItems[5];
      MessagesListView.Items[MessagesListView.Selected.Index].Checked:=true;
      MesnumberLabel.Caption:='Сообщение: '+IntToStr(MessagesListView.Selected.Index+1)+
                                    '/'+IntToStr(MessagesListView.Items.Count);
      CheckedNumber:=0;
      for i:=0 to MessagesListView.Items.Count-1 do
          if MessagesListView.Items[i].Checked then
              CheckedNumber:=CheckedNumber+1;
      if CheckedNumber=MessagesListView.Items.Count then
          CoolTrayIcon.IconIndex:=5
      else
          CoolTrayIcon.IconIndex:=4; 
  end
  else if(MessagesListView.Items.Count=0)then
  begin
      MesnumberLabel.Caption:='Нет сообщений';
      CoolTrayIcon.IconIndex:=3;
      Application.Minimize;
  end;
    StatusBar1.Panels[1].Text := 'Сообщений: '+IntToStr(MessagesListView.Items.Count);
end;

procedure TMainForm.CheckAllMessagesBtnClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to MessagesListView.Items.Count-1 do
    MessagesListView.Items[i].Checked:=true;
end;
      // Action для удаления всех сообщений
procedure TMainForm.DeleteAllMessagesExecute(Sender: TObject);
begin
  MessagesListView.Clear;
  MessageMemo.Clear;
  WhomEdit.Text:='';
  MesnumberLabel.Caption:='Нет сообщений';
  CoolTrayIcon.IconIndex:=3;
  StatusBar1.Panels[1].Text := 'Сообщений: 0';
  Application.Minimize;
end;

procedure TMainForm.DeleteAllChMessagesExecute(Sender: TObject);
var
  k: integer;
  l: integer;
begin
  if MessagesListView.Items.Count<>0 then
  begin
  l := MessagesListView.Items.Count;
  k := 0;
  while k<l do
  begin
      if MessagesListView.Items[k].Checked then
      begin
          MessagesListView.Items.Delete(k);
          //MessagesListView.Items[k].Free;
          Dec(l);
      end
      else
          Inc(k);
  end;

  if MessagesListView.Items.Count<>0 then
        MessagesListView.Items[MessagesListView.Items.Count-1].Selected:=true
  else
        begin
              MessageMemo.Clear;
              WhomEdit.Text:='';
              MesnumberLabel.Caption:='Нет сообщений';
              CoolTrayIcon.IconIndex:=3;
              Application.Minimize;
        end;
        
  StatusBar1.Panels[1].Text := 'Сообщений: '+IntToStr(MessagesListView.Items.Count);

  end;
end;

procedure TMainForm.DelchmesToolButtonClick(Sender: TObject);
begin
    DeleteAllChMessages.Execute;
end;

procedure TMainForm.DeleteCurrentMessageExecute(Sender: TObject);
var
  i, j: integer;
begin
  if MessagesListView.Items.Count<>0 then
  begin
    i:= MessagesListView.Selected.Index;
    j:= MessagesListView.Items.Count-1;
    MessagesListView.Items.Delete(i);
    //MessagesListView.Items[i].Free;
    if MessagesListView.Items.Count<>0 then
        if i=j then
          MessagesListView.Items[i-1].Selected:=true
        else
          MessagesListView.Items[i].Selected:=true;
  end;
  if MessagesListView.Items.Count=0 then
  begin
     MessageMemo.Clear;
     WhomEdit.Text:='';
     MesnumberLabel.Caption:='Нет сообщений';
     CoolTrayIcon.IconIndex:=3;
     StatusBar1.Panels[1].Text:='Сообщений: 0';
     Application.Minimize;
  end;
end;

procedure TMainForm.DelcurmesToolButtonClick(Sender: TObject);
begin
    DeleteCurrentMessage.Execute;
end;

procedure TMainForm.JumpUpExecute(Sender: TObject);
var
  LastIndex, UpIndex: integer;
begin
 if  MessagesListView.Items.Count>1 then
  begin
  LastIndex := MessagesListView.Items.Count-1;
  UpIndex   := MessagesListView.Selected.Index+1;
  if UpIndex <= LastIndex then
      MessagesListView.Items[UpIndex].Selected:=true;
  end;
end;

procedure TMainForm.JumpDownExecute(Sender: TObject);
var
    DownIndex: integer;
begin
 if  MessagesListView.Items.Count>1 then
  begin
  DownIndex := MessagesListView.Selected.Index-1;
  if DownIndex >= 0 then
      MessagesListView.Items[DownIndex].Selected:=true;
  end;
end;

procedure TMainForm.ForwardToolButtonClick(Sender: TObject);
begin
   JumpUp.Execute;
end;

procedure TMainForm.BackToolButtonClick(Sender: TObject);
begin
  JumpDown.Execute;
end;

procedure TMainForm.JumpToLastExecute(Sender: TObject);
begin
  if  MessagesListView.Items.Count>1 then
      MessagesListView.Items[MessagesListView.Items.Count-1].Selected:=true;
end;

procedure TMainForm.JumpToFirstExecute(Sender: TObject);
begin
  if  MessagesListView.Items.Count>1 then
      MessagesListView.Items[0].Selected:=true;
end;

procedure TMainForm.LastmesToolButtonClick(Sender: TObject);
begin
    JumpToLast.Execute;
end;

procedure TMainForm.FirsmesToolButtonClick(Sender: TObject);
begin
    JumpToFirst.Execute;
end;

procedure TMainForm.DelallmesToolButtonClick(Sender: TObject);
begin
  DeleteAllMessages.Execute;
end;

procedure TMainForm.PingTimerTimer(Sender: TObject);
begin
  try
    PingTcpClient.RemotePort := '8732';
    PingTcpClient.RemoteHost := SpeekerSettings.MainServerIP;
    PingTcpClient.Active:=true;
    if PingTcpClient.Connect then
        begin
          PingTcpClient.Close;
          Reconnect;
        end;
    PingTcpClient.Close;
  except
    on E:Exception do
      begin
        ShowMessage('Exception: ' + E.Message);
      end; // end on do begin
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  ConDiscon.Execute;
end;

function TMainForm.StringCompare(s1, s2: string): boolean;
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



procedure TMainForm.GlukTimerTimer(Sender: TObject);
begin
    Reconnect;
end;

procedure TMainForm.ConDisconToolBtnClick(Sender: TObject);
begin
    ConDiscon.Execute;
end;

procedure TMainForm.LogTimerTimer(Sender: TObject);
var
  logfile: TextFile;
begin
  AssignFile(logfile, 'log.txt');
  try
    Append(logfile);
  except
    Rewrite(logfile);
  end;
  Writeln(logfile, 'Caption: '+Caption);
  Writeln(logfile, 'Date: '+DateToStr(Date));
  Writeln(logfile, 'Time: '+TimeToStr(Time));
  Writeln(logfile, 'HowmanyNeedRec '+IntToStr(InBufer.HowmanyNeedRec));
  Writeln(logfile, 'CurrentOperation '+IntToStr(InBufer.CurrentOperation));
  Writeln(logfile, 'LastSEACommand '+IntToStr(InBufer.LastSEACommand));
  Writeln(logfile, 'isReadyForProc '+BoolToStr(InBufer.isReadyForProc));
  Writeln(logfile, 'tmpBufer '+InBufer.tmpBufer);
  Writeln(logfile, 'Bufer '+InBufer.Bufer);

  Writeln(logfile, 'ClientIP '+ClientProperties.ClientIP);
  Writeln(logfile, 'Username '+ClientProperties.Username);
  Writeln(logfile, 'Compname '+ClientProperties.Compname);
  Writeln(logfile, 'UsernameLen '+IntToStr(ClientProperties.UsernameLen));
  Writeln(logfile, 'CompnameLen '+IntToStr(ClientProperties.CompnameLen));
  Writeln(logfile, 'ClientIPLen '+IntToStr(ClientProperties.ClientIPLen));
  Writeln(logfile, 'UserlistLen '+IntToStr(ClientProperties.UserlistLen));
  Writeln(logfile, 'AddUserQuery '+IntToStr(ClientProperties.AddUserQuery));
  Writeln(logfile, 'AlienID '+IntToStr(ClientProperties.AlienID));
  Writeln(logfile, 'Listcount '+IntToStr(ClientProperties.Listcount));
  Writeln(logfile, 'Users '+IntToStr(ClientProperties.Users));
  Writeln(logfile, 'Privat '+IntToStr(ClientProperties.Privat));
  Writeln(logfile, 'Printer '+IntToStr(ClientProperties.Printer));
  Writeln(logfile, 'Meslen '+IntToStr(ClientProperties.Meslen));
  Writeln(logfile, 'Messag '+ClientProperties.Messag);

  Writeln(logfile, 'MainServerIP '+SpeekerSettings.MainServerIP);
  Writeln(logfile, 'AltServerIP '+SpeekerSettings.AltServerIP);
  Writeln(logfile, 'UserName '+SpeekerSettings.UserName);
  Writeln(logfile, 'CompName '+SpeekerSettings.CompName);

  Writeln(logfile, 'UserName '+AlienInfo.UserName);
  Writeln(logfile, 'CompName '+AlienInfo.CompName);
  Writeln(logfile, 'Room '+AlienInfo.Room);
  Writeln(logfile, 'Info '+AlienInfo.Info);
  Writeln(logfile, 'Faculty '+IntToStr(AlienInfo.Faculty));
  Writeln(logfile, 'Version '+AlienInfo.Version);
  Writeln(logfile, 'IPAddress '+AlienInfo.IPAddress);

  Writeln(logfile, '----------------------------------------------------------------------');

  CloseFile(logfile);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose:=false;
    Application.Minimize;
end;

procedure TMainForm.Exit2Click(Sender: TObject);
begin
    CloseProgamm.Execute;
end;

procedure TMainForm.DownPanelClick(Sender: TObject);
begin
    if DownPanel.Height=150 then
        DownPanel.Height:=4
    else
        DownPanel.Height:=150;
end;

procedure TMainForm.GroupBox1Click(Sender: TObject);
begin
    if DownPanel.Height=150 then
        DownPanel.Height:=4
    else
        DownPanel.Height:=150;
end;

procedure TMainForm.CloseProgammExecute(Sender: TObject);
var
  PanelState: boolean;
  sIniFile: TIniFile;
begin
    if DownPanel.Height=150 then
        PanelState:=true
    else
        PanelState:=false;

    sIniFile := TIniFile.Create(SpeekerSettings.UserAppdataDir + '\Settings.ini');
    sIniFile.WriteBool('Programm', 'ShowPanel', PanelState);
    sIniFile.Free;
    Application.Terminate;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin

end;
//---------------------------------------------------------------------


procedure TMainForm.FormResize(Sender: TObject);
begin
  StatusBar1.Panels[2].Width:=Width-452;
end;


end.
