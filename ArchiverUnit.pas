unit ArchiverUnit;

interface

uses
  Windows, SysUtils, Controls, Forms, Dialogs, CoolTrayIcon, Menus,
  shellapi, ToolWin, ImgList, IniFiles, RichEdit, sListView,
  Classes, StdCtrls, ComCtrls, ExtCtrls, StdActns, Messages,
  Variants, Graphics, ScktComp, ActnList, Sockets, Registry,
  MMSystem, sSkinManager, sSkinProvider, sMemo, sEdit, sLabel,
  sSplitter, sPanel, sToolBar, sStatusBar, Winsock, NewChatUnit;

const
  UM_MYMESSSAGE = WM_USER+1;

// Server to client commands
  S2C_USERLIST 		      = 1;
	S2C_ADDUSER			      = 2;
	S2C_DELETEUSER		    = 3;
	S2C_MESSAGE			      = 4;
	S2C_PONG			        = 5;
	S2C_USERINFO		      = 6;
	S2C_CHATOK			      = 7;
	S2C_CHATCANCEL		    = 8;
	S2C_ARCHIVELINK		    = 9;
	S2C_USERMUTEYOU		    = 10;
	S2C_TOAWAY			      = 11;
	S2C_FROMAWAY		      = 12;
	S2C_CHANGEALTSERVERIP = 13;
	S2C_CHANGEUSERNAME	  = 14;

// Client to server commands
	C2S_USERCOMP		      = #1;
	C2S_MESSAGE			      = #2;
	C2S_PING			        = #3;
	C2S_USERINFO		      = #4;
	C2S_GIVEMEUSERINFO	  = #5;
	C2S_CHATOK			      = #7;
	C2S_CHATCANCEL		    = #8;
	C2S_GIVEMEARCHIVELINK = #9;
	C2S_IMUTEYOU		      = #10;
	C2S_TOAWAY			      = #11;
	C2S_FROMAWAY		      = #12;
	C2S_ICHANGENAME		    = #14;
	C2S_TOPRINTERS		    =	#15;
	C2S_FROMPRINTERS	    = #16;

// SEA lengths
	L_SEACOMMAND  = 1;
	L_SEAID		    = 2;
	L_SEASHORT	  = 1;
	L_SEALONG	    = 2;
	L_ULIST		    = 2;
	L_ISPRIVATE	  = 1;
	L_ISPRINTER	  = 2;
	L_FACULTY	    = 1;
	L_ROOM		    = 5;
	L_SEAVERSION  = 1;
	L_SEACHATBEEP = 8;
	L_ALTSERVERIP = 4;

// BlastCore states
  BC_STATE_RECONNECT      = -1;
  BC_STATE_GETID          = 1;
	BC_STATE_GETIPLEN       = 2;
	BC_STATE_GETIP          = 3;
	BC_STATE_GETLISTLEN     = 4;
	BC_STATE_GETUSERNAMELEN = 5;
	BC_STATE_GETUSERNAMEMY  = 6;
	BC_STATE_GETCOMPNAMELEN = 7;
	BC_STATE_GETCOMPNAME    = 8;
	BC_STATE_GETSEACOMMAND  = 9;
	BC_STATE_GETPRIVATE     = 10;
	BC_STATE_GETPRINTER     = 11;
	BC_STATE_GETMESLEN      = 12;
	BC_STATE_GETMESSAGE     = 13;
	BC_STATE_GETZERO        = 14;
	BC_STATE_GETFACULTY     = 15;
	BC_STATE_GETROOM        = 16;
	BC_STATE_GETVERSION     = 17;
	BC_STATE_GETINFOLEN     = 18;
	BC_STATE_GETINFO        = 19;
	BC_STATE_GETCHATMESLEN  = 20;
	BC_STATE_GETCHATMESSAGE = 21;
	BC_STATE_GETNEWALTIP    = 22;
	BC_STATE_GETLINKLENGTH  = 23;
	BC_STATE_GETLINK        = 24;

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
      Version:     string;
      LastChatHead: string;
      LastChatCont: string;
      UsernameLen: integer;
      CompnameLen: integer;
      ClientIPLen: integer;
      UserlistLen: integer;
      AddUserQuery:integer;
      AlienID:     integer;
      Listcount:   integer;
      Users:       integer;
      ownID:       integer;

      TCPUserlistNotReceived: Boolean;

// LastMessage
      Privat:      integer;
      Printer:     integer;
      Priority:    integer;
      Meslen:      integer;
      lenpbyte:    integer;
      Messag:      string;
// IgnoreList
      IgnoreList:  TListBox;
end;

  TProgSettings = class
  public
      UserAppdataDir: string;

      MainServerIP: string;
      AltServerIP:  string;
      UserName:     string;
      CompName:     string;
      Room:         string;
      Info:         string;
      Faculty:      boolean;
      PrintUser:    boolean;
      AwayStatus:   boolean;
      Debug:        boolean;
      Skinned:      boolean;
      Smiled:       boolean;
      OwnID:        integer;

// Program Sounds
      PrivateSound: string;
      GroupSound:   string;
      ChatSound:    string;
// Options
      OptStartmin, OptAutostart,
      OptPopup, OptDelastmin,
      OptJumpOwnMessage,
      OptShowpanel, OptEnablesounds:  boolean;
      OptUpdate:    boolean;
// Messages Font
      FontColor:     integer;
      FontSize:      integer;
      FontName:      string;
      FontBold:      boolean;
      FontItalic:    boolean;
      FontUnderline: boolean;
      FontStrikeOut: boolean;

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

  TRichEdit = class(ComCtrls.TRichEdit)
  private
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    procedure CreateWnd; override;
  end;

  TMainForm = class(TForm)
    ClientSocket1: TClientSocket;
    StatusBar1: TsStatusBar;
    TrayPopupMenu: TPopupMenu;
    ShowArchiver1: TMenuItem;
    Exit1: TMenuItem;
    ActionList: TActionList;
    ConDiscon: TAction;
    OpenSiteAction: TAction;
    OpenNETArchiver1: TMenuItem;
    ToolBar1: TsToolBar;
    IconsImageList: TImageList;
    DeleteAllMessages: TAction;
    DeleteAllChMessages: TAction;
    DeleteCurrentMessage: TAction;
    JumpToLast: TAction;
    JumpUp: TAction;
    JumpDown: TAction;
    JumpToFirst: TAction;
    ImageList1: TImageList;
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
    CoolTrayIcon: TCoolTrayIcon;
    ReplyAuthor: TAction;
    ReplyGroup: TAction;
    CreateChatWindow: TAction;
    UserListPM: TPopupMenu;
    Chat: TMenuItem;
    N1: TMenuItem;
    MainMenu1: TMainMenu;
    N2: TMenuItem;
    CloseProgamm1: TMenuItem;
    NewMesTB: TToolButton;
    ToolButton2: TToolButton;
    ReplyAuthorTB: TToolButton;
    ReplyGroupTB: TToolButton;
    ToolButton5: TToolButton;
    FirsmesToolButton: TToolButton;
    BackToolButton: TToolButton;
    ForwardToolButton: TToolButton;
    LastmesToolButton: TToolButton;
    ToolButton10: TToolButton;
    DelcurmesToolButton: TToolButton;
    DelchmesToolButton: TToolButton;
    DelallmesToolButton: TToolButton;
    ToolButton14: TToolButton;
    AwayTB: TToolButton;
    PrinterTB: TToolButton;
    ShowMesBaloon: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    NewMessage1: TMenuItem;
    ReplyAuthor1: TMenuItem;
    ReplyGroup1: TMenuItem;
    N12: TMenuItem;
    N14: TMenuItem;
    N1MessageBackward1: TMenuItem;
    N1MessageForward1: TMenuItem;
    N15: TMenuItem;
    DeleteCurrentMessage1: TMenuItem;
    DeleteAllMessages1: TMenuItem;
    GoToFromAway: TAction;
    GoToFromPrinter: TAction;
    ChatSoundTimer: TTimer;
    BigPanel: TsPanel;
    UserList: TsListView;
    MiddlePanel: TsPanel;
    MesnumberLabel: TsLabel;
    WhomEdit: TsEdit;
    MessageMemo2: TsMemo;
    DownPanel: TsPanel;
    MessagesListView: TsListView;
    ChatListView: TsListView;
    Splitter1: TsSplitter;
    toTray: TAction;
    UInfoPMU: TMenuItem;
    NewMessagePMU: TMenuItem;
    N21: TMenuItem;
    ActRCon: TAction;
    MutePMU: TMenuItem;
    GetGroupInfo: TAction;
    ActRCon1: TMenuItem;
    ReconnectTimer: TTimer;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N11: TMenuItem;
    N16: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    Pilingator: TTimer;
    N17: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    EnDisButtons: TAction;
    N13: TMenuItem;
    PingMSClientSocket: TClientSocket;
    PingMSTimer: TTimer;
    CheckSelected: TAction;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    WhomImage: TImage;
    DebugAction: TAction;
    BigImages: TImageList;
    OptionsTPM: TMenuItem;
    NewmessageTPM: TMenuItem;
    AWAY1: TMenuItem;
    N20: TMenuItem;
    SkinMgrMenuitem: TMenuItem;
    OpenSkinManager: TAction;
    SmilesImageList: TImageList;
    N5: TMenuItem;
    N24: TMenuItem;
    UpdateAct: TAction;
    UpdateClientSocket: TClientSocket;
    ToolButton1: TToolButton;
    PriorityTB: TToolButton;
    OnOffPriority: TAction;
////////////////////////////////////////////////////////////////////
procedure UMMymessage(var Message: TMessage); message UM_MYMESSSAGE;
procedure WMSysCommand(var Msg: TMessage); message WM_SYSCOMMAND;
procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
////////////////////////////////////////////////////////////////////
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
    procedure ConDisconToolBtnClick(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure DownPanelClick(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure CloseProgammExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ReplyAuthorExecute(Sender: TObject);
    procedure ReplyGroupExecute(Sender: TObject);
    procedure WriteNewMessageExecute(Sender: TObject);
    procedure UserListDblClick(Sender: TObject);
    procedure CreateChatWindowExecute(Sender: TObject);
    procedure ChatClick(Sender: TObject);
    procedure ShowMesBaloonClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure GoToFromAwayExecute(Sender: TObject);
    procedure GoToFromPrinterExecute(Sender: TObject);
    procedure UserListPMPopup(Sender: TObject);
    procedure ChatSoundTimerTimer(Sender: TObject);
    procedure toTrayExecute(Sender: TObject);
    procedure UInfoPMUClick(Sender: TObject);
    procedure CoolTrayIconMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ReconnectTimerTimer(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure MutePMUClick(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure PilingatorTimer(Sender: TObject);
    procedure EnDisButtonsExecute(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure TrayPopupMenuPopup(Sender: TObject);
    procedure PingMSTimerTimer(Sender: TObject);
    procedure PingMSClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure PingMSClientSocketError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure CheckSelectedExecute(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure DebugActionExecute(Sender: TObject);
    procedure OptionsTPMClick(Sender: TObject);
    procedure MessagesListViewClick(Sender: TObject);

    procedure MainMenu1Change(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure FormShow(Sender: TObject);
    procedure sSkinManager1AfterChange(Sender: TObject);
    procedure OpenSkinManagerExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure UpdateActExecute(Sender: TObject);
    procedure UpdateClientSocketRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UpdateClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure N5Click(Sender: TObject);
    procedure UpdateClientSocketError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure OnOffPriorityExecute(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  ClientProperties: TClientProperties;
  InBufer: TInBufer;
  SpeekerSettings: TProgSettings;
  AlienInfo: TAlienInfo;

  SendMessageFlag: integer;
  MessageMemo: TRichEdit;
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
     procedure GetChatMeslen();
     procedure GetChatMessage();
     procedure GetNewAltIP();
     procedure GetLinkLength();
     procedure GetLink();
     procedure ReceiveForProcessing(ReadyBufer: string);
     procedure SetUserAppDataDir;
     procedure NullVaribles;
     procedure Reconnect;
     procedure LogVariable(Varname, Variable: string);

     function  GetIniPath: String;
     function  GetIndexByID(ID: integer): integer;
     function  StringCompare(s1, s2: string): boolean;
     function  AssignIndex:integer;

     procedure SetMemoFont;
     procedure InsertSmiles;
     function  ExtractPlainText(Source: string): String;
     function  ExtractPlainTextFromSelected: String;
     function  ExtractRTF(Source: string): String;
     procedure  ExtractFile(Source: string);
  end;

var
  MainForm: TMainForm;
  tmpChatForm: array[0..9] of TBChatForm;
  noPong: boolean;

implementation

uses TryChatUnit, ChatYESNOUnit, OptionsUnit, SendMessageUnit,
  IgnorlistUnit, SentMesUnit, AboutUnit, DebugUnit, acSelectSkin, re_bmp,
  UpdateUnit;

{$R *.dfm}

//-----------------------------------------------------------------

procedure TMainForm.SetMemoFont;
begin  
  MessageMemo.Font.Color := 0;
  MessageMemo.Font.Size  := 8;
  MessageMemo.Font.Name  := 'MS Sans Serif';
  MessageMemo.Font.Style := [];

  with MessageMemo do
    begin
    Font.Color := SpeekerSettings.FontColor;
    Font.Size  := SpeekerSettings.FontSize;
    Font.Name  := SpeekerSettings.FontName;

    if SpeekerSettings.FontBold then
      Font.Style := Font.Style + [fsBold];
    if SpeekerSettings.FontItalic then
      Font.Style := Font.Style + [fsItalic];
    if SpeekerSettings.FontUnderline then
      Font.Style := Font.Style + [fsUnderline];
    if SpeekerSettings.FontStrikeOut then
      Font.Style := Font.Style + [fsStrikeOut];
    end;
end;

procedure TMainForm.UMMymessage(var Message: TMessage);
begin
  Application.Restore;
  Application.BringToFront;
end;

function TwoBytesToInt(twobytes: string): integer;
begin
   SetLength(twobytes, 2);
   result := 256*ord(twobytes[1])+ord(twobytes[2]);
end;

function FromEdit2Host(HostEdit: TEdit): Boolean;
begin

end;

//-----------------------------------------------------------------


//-----------------------------------------------------------------

procedure TMainForm.LogVariable(Varname, Variable: string);
var
  logfile: TextFile;
  logstring: string;
begin
  logstring:='['+DateToStr(Date)+']['+TimeToStr(Time)+'] '+Varname+' = '+Variable;
  DebugForm.DebugMemo.Lines.Add(logstring);
end;
//-----------------------------------------------------------------

procedure TInBufer.GetInputBytes(i: integer);
begin
  HowmanyNeedRec := HowmanyNeedRec - i;
  SetLength(tmpBufer, i);
  Bufer := Bufer + tmpBufer;
  if(HowmanyNeedRec=0) then
     isReadyForProc := true;
  if(HowmanyNeedRec>0) then
    begin
      // �� �� ��� ������� � ��������� ���������
      isReadyForProc := false;
    end;
end;

procedure   TInBufer.SetNextLength;
begin
  SetLength(tmpBufer, HowmanyNeedRec);
  Bufer:='';
end;

//-----------------------------------------------------------------

function  TMainForm.GetIndexByID(ID: integer): integer;
var
  Buf1: string;
  i:   integer;
begin
  result:=-1;
  for i:=0 to Userlist.Items.Count-1 do
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
procedure TMainForm.SetUserAppDataDir;
begin
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
end;

function TMainForm.GetIniPath: String;
begin
  if ParamStr(1) = '' then
    Result := SpeekerSettings.UserAppdataDir+'\Settings.ini'
  else
    Result := GetCurrentDir() + '\' + ParamStr(1);
end;

procedure TMainForm.NullVaribles;
var
  Ini: TIniFile;
  PanelState: boolean;
begin
  // TInBufer
  InBufer.HowmanyNeedRec   := 1;
  InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
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
   ClientProperties.LastChatHead:='';
   ClientProperties.LastChatCont:='';
   ClientProperties.Version:='BlastCore v0.45 RC1';

   ClientProperties.ownID := 0;

  // TProgSettings.ReadSettings;
  Ini := TIniFile.Create( GetIniPath );
  try
    SpeekerSettings.MainServerIP:= Ini.ReadString( 'Servers', 'MainServerIP','hostel.avtf.net');
    SpeekerSettings.AltServerIP := Ini.ReadString( 'Servers', 'AltServerIP' ,'109.123.180.129');

    if(SpeekerSettings.MainServerIP=SpeekerSettings.AltServerIP)then
        begin
        SpeekerSettings.MainServerIP:='hostel.avtf.net';
        SpeekerSettings.AltServerIP:='109.123.180.129';

        end;
    SpeekerSettings.UserName    := Ini.ReadString( 'User', 'UserName','');
    SpeekerSettings.CompName    := Ini.ReadString( 'User', 'CompName','');
    SpeekerSettings.Room        := Ini.ReadString( 'User', 'Room','0');
    SpeekerSettings.Info        := Ini.ReadString( 'User', 'Info', ClientProperties.Version);
    SpeekerSettings.Faculty     :=   Ini.ReadBool( 'User', 'Faculty', true);
    SpeekerSettings.PrintUser   :=   Ini.ReadBool( 'User', 'isPrinter', false);
    SpeekerSettings.Debug       :=   Ini.ReadBool( 'Programm', 'Debug',  false);
    SpeekerSettings.OptShowpanel :=  Ini.ReadBool( 'Programm', 'ShowPanel', false);
    SpeekerSettings.Skinned      :=  Ini.ReadBool( 'Programm', 'Skinned', false);
    SpeekerSettings.Smiled       :=  Ini.ReadBool( 'Programm', 'Smiled', false);

    sSkinManager1.SkinName      := Ini.ReadString( 'Programm', 'SkinName', 'Office2007 Blue');
    ShowMesBaloon.Checked       := Ini.ReadBool( 'Programm', 'ShowBalloon', false);

// Program Sounds
    SpeekerSettings.PrivateSound    := Ini.ReadString( 'Sounds', 'PrivateSound','Sounds\message.wav');
    SpeekerSettings.GroupSound      := Ini.ReadString( 'Sounds', 'GroupSound','Sounds\message.wav');
    SpeekerSettings.ChatSound       := Ini.ReadString( 'Sounds', 'ChatSound','Sounds\ringin.wav');
// Options
    SpeekerSettings.OptStartmin       := Ini.ReadBool( 'Options', 'StartMinimized',  false);
    SpeekerSettings.OptAutostart      := Ini.ReadBool( 'Options', 'AutoStart',  false);
    SpeekerSettings.OptPopup          := Ini.ReadBool( 'Options', 'WinPopup',  false);
    SpeekerSettings.OptDelastmin      := Ini.ReadBool( 'Options', 'MinimizeWhenDelast',  false);
//    SpeekerSettings.OptShowpanel    := Ini.ReadBool( 'Options', 'Debug',  false);
    SpeekerSettings.OptEnablesounds   := Ini.ReadBool( 'Options', 'EnableSounds',  false);
    SpeekerSettings.OptUpdate         := Ini.ReadBool( 'Options', 'Update',  false);
    SpeekerSettings.OptJumpOwnMessage := Ini.ReadBool( 'Options', 'JumpOwnMessages', false);

    SpeekerSettings.FontColor     := Ini.ReadInteger('Font', 'Color', clBlack);
    SpeekerSettings.FontSize      := Ini.ReadInteger('Font', 'Size', 9);
    SpeekerSettings.FontName      := Ini.ReadString('Font', 'Name', 'MS Sans Serif');
    SpeekerSettings.FontBold      := Ini.ReadBool('Font', 'Bold',      false);
    SpeekerSettings.FontItalic    := Ini.ReadBool('Font', 'Italic',    false);
    SpeekerSettings.FontUnderline := Ini.ReadBool('Font', 'Underline', false);
    SpeekerSettings.FontStrikeOut := Ini.ReadBool('Font', 'StrikeOut', false);

    PanelState := SpeekerSettings.OptShowpanel;
  finally
    Ini.Free;

  end;
  //----------------------------------------------------------------------------
  if SpeekerSettings.PrintUser then
  begin
    PrinterTB.Down:=true;
    GoToFromPrinterExecute(self);
  end;
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

// ������� �������� ���� �������� �����.
// �����������, ��������, ��� ������� ����������
procedure CloseAllChats;
var
  i: integer;
begin
  if(MainForm.ChatListView.Items.Count>0)then
    begin
        for i:=0 to MainForm.ChatListView.Items.Count-1 do
            tmpChatForm[i].Close;
        MainForm.ChatListView.Clear;
    end;
end;

procedure TMainForm.Reconnect;
begin
   CloseAllChats;
   ConDiscon.Execute;

end;
//-----------------------------------------------------------------

procedure TMainForm.GetID();  // 1
var
  Buf1, toBalloonHint: string;
  i, tmpIndex: integer;
  tmpListItem: TListItem;
begin
  ClientProperties.AlienID:=TwoBytesToInt(InBufer.Bufer);
  InBufer.isReadyForProc:=false;
  if SpeekerSettings.Debug then
      LogVariable('AlienID', IntToStr(ClientProperties.AlienID));

   if(InBufer.LastSEACommand = S2C_USERLIST)then
  begin
      InBufer.CurrentOperation := BC_STATE_GETIPLEN;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;

      with UserList do
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := ' ����';
        tmpListItem.StateIndex:=0;
        tmpListItem.Selected:=true;
        tmpListItem.SubItems.Add('[ALL]');
        tmpListItem.SubItems.Add(IntToStr(0));

        tmpListItem := Items.Add;
        tmpListItem.Caption := ' ���������';
        tmpListItem.StateIndex:=0;
        tmpListItem.SubItems.Add('[PRINTERS]');
        tmpListItem.SubItems.Add(IntToStr(65535));
    end;
       ClientProperties.ownID:=ClientProperties.AlienID;

  end
  else if(InBufer.LastSEACommand = S2C_ADDUSER)then
  begin
            InBufer.CurrentOperation := BC_STATE_GETUSERNAMELEN;
            InBufer.HowmanyNeedRec := 1;
            InBufer.SetNextLength;
  end
  else if(InBufer.LastSEACommand = S2C_DELETEUSER)then
  begin
      DelUserByID;
  end
  else if(InBufer.LastSEACommand = S2C_MESSAGE)then
  begin                         
      InBufer.CurrentOperation := BC_STATE_GETPRIVATE;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
  end
  else if(InBufer.LastSEACommand = S2C_CHATOK)then
      begin
         InBufer.CurrentOperation := BC_STATE_GETCHATMESLEN;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand = S2C_CHATCANCEL)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
            begin
            // ������� �������� ���� � ������
              if(ChatListView.Items.Count>0)then
                begin
                  for i:=0 to ChatListView.Items.Count-1 do
                    begin
                      Buf1 := ChatListView.Items[i].SubItems[0];
                      if(StrToInt(Buf1)=ClientProperties.AlienID) then
                        begin
                          break;
                        end;
                    end;
                    tmpChatForm[i].Close;
                end
            // ���� ������ �������� ����� ����,
            // �� ��������� ������ �� ������ "�������� �� ���?"
              else if(ChatYESNOForm.Visible)then
                begin
                  ChatYESNOForm.Close;
            //---------------------------------------------------------------
                  toBalloonHint:= 'Incoming chat request, you not answer and he hung up...';

                  with MessagesListView do
                    begin
                      tmpListItem := Items.Add;
                      tmpListItem.Caption := IntToStr(ClientProperties.AlienID);
                      tmpListItem.SubItems.Add('1');
                      tmpListItem.SubItems.Add('0');
                      tmpListItem.SubItems.Add('CHR');
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
              else if(TryChatForm.Visible)then
                begin
                  TryChatForm.Close;
                end;
            end
         else
            begin
              ClientSocket1.Socket.Close;
              MessageDlg('['+DateToStr(Date)+']['+TimeToStr(Time)+
                         '] ���������������� � ��������!'+#13#10+
            '������ ������������, ������������ SEA_CHAT_CANCEL, ����� �� �������.',mtWarning, [mbOK], 0);
            end;
         InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand = S2C_USERMUTEYOU)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
            begin
//---------------------------------------------------------------
   toBalloonHint:= '������������ ���������� ���� ���������.';
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
            begin
              ClientSocket1.Socket.Close;
              if SpeekerSettings.Debug then
                LogVariable('LastSEACommand', IntToStr(InBufer.LastSEACommand));
              MessageDlg('['+DateToStr(Date)+']['+TimeToStr(Time)+
                         '] ���������������� � ��������!'+#13#10+
            '������ ������������, ������� ��� ����������, ����� �� �������.',mtWarning, [mbOK], 0);
            end;

         InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand = S2C_TOAWAY)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
          begin
            UserList.Items[tmpIndex].StateIndex:=2;
            
          end
         else
          begin
            ClientSocket1.Socket.Close;
            MessageDlg('['+DateToStr(Date)+']['+TimeToStr(Time)+
            '] ���������������� � ��������!'+#13#10+
            '������ ������������, ������������ away, ����� �� �������.',mtWarning, [mbOK], 0);
          end;

         InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else  if(InBufer.LastSEACommand = S2C_FROMAWAY)then
      begin
         tmpIndex := GetIndexByID(ClientProperties.AlienID);
         if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
          begin
            UserList.Items[tmpIndex].StateIndex:=1;

          end
         else
          begin
            ClientSocket1.Socket.Close;
            MessageDlg('['+DateToStr(Date)+']['+TimeToStr(Time)+
            '] ���������������� � ��������!'+#13#10+
            '������ ������������, �������� away, ����� �� �������.',mtWarning, [mbOK], 0);
          end;

         InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand = S2C_CHANGEALTSERVERIP)then
      begin
        InBufer.CurrentOperation := BC_STATE_GETNEWALTIP;
        InBufer.HowmanyNeedRec := 4;
        InBufer.SetNextLength;
      end
  else if(InBufer.LastSEACommand = S2C_CHANGEUSERNAME)then
  begin
      InBufer.CurrentOperation := BC_STATE_GETUSERNAMELEN;
      InBufer.HowmanyNeedRec := 1;
      InBufer.SetNextLength;
  end
  else
  begin
      ClientSocket1.Socket.Close;
      MessageDlg('['+DateToStr(Date)+']['+TimeToStr(Time)+
            '] ���������������� � ��������!'+#13#10+
            '����������� SEA-�������.',mtWarning, [mbOK], 0);
  end;
end;

//-----------------------------------------------------------------

procedure TMainForm.GetIPLen();   // 2
begin
  ClientProperties.ClientIPLen := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('ClientIPLen', IntToStr(ClientProperties.ClientIPLen));
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation := BC_STATE_GETIP;
  InBufer.HowmanyNeedRec := ClientProperties.ClientIPLen;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetIP();      // 3
var
  s: string;
//  tmpListItem: TListItem;
begin
  InBufer.isReadyForProc:=false;
  if(InBufer.LastSEACommand = S2C_USERINFO)then
      begin
          AlienInfo.IPAddress := InBufer.Bufer;
          if SpeekerSettings.Debug then
            LogVariable('IPAddress', AlienInfo.IPAddress);
          InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
          InBufer.HowmanyNeedRec := 1;
          InBufer.SetNextLength;

          s:=  '��� ������������: ' + AlienInfo.UserName + #13#10;
          s:=s+'���������: '        + AlienInfo.CompName + #13#10;

          if(AlienInfo.Faculty=1)then
              s:=s+'���������: ���' + #13#10
          else
              s:=s+'���������: ��'  + #13#10;

          s:=s+'�������: '    + AlienInfo.Room    + #13#10;
          s:=s+'����������: ' + AlienInfo.Info    + #13#10;
          s:=s+'������: '     + AlienInfo.Version + #13#10;
          s:=s+'IP-����� : '  + AlienInfo.IPAddress;
          ShowMessage(s);

      end
  else
      begin
          ClientProperties.ClientIP := InBufer.Bufer;
          if SpeekerSettings.Debug then
            LogVariable('ClientIP', ClientProperties.ClientIP);
          StatusBar1.Panels[2].Text := '��� IP-�����: '+ClientProperties.ClientIP;
          InBufer.CurrentOperation := BC_STATE_GETLISTLEN;
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
  ClientProperties.TCPUserlistNotReceived := True;
  InBufer.isReadyForProc:=false;

  InBufer.CurrentOperation := BC_STATE_GETID;
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
  InBufer.CurrentOperation := BC_STATE_GETUSERNAMEMY;
  InBufer.HowmanyNeedRec := ClientProperties.UsernameLen;
  InBufer.SetNextLength;
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
  if(InBufer.LastSEACommand = S2C_CHANGEUSERNAME)then
      begin
          tmpIndex := GetIndexByID(ClientProperties.AlienID);
          UserList.Items[tmpIndex].Caption:=ClientProperties.Username;
          InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
      end
  else
      begin
          InBufer.CurrentOperation := BC_STATE_GETCOMPNAMELEN;
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
  InBufer.CurrentOperation := BC_STATE_GETCOMPNAME;
  InBufer.HowmanyNeedRec := ClientProperties.CompnameLen;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetCompname();// 8
var
  tmpListItem: TListItem;
  TCPUsrs: string;
  i: integer;
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
    if(ClientProperties.IgnoreList.Items.Count>0)then
        for i:=0 to  ClientProperties.IgnoreList.Items.Count-1 do
            if(ClientProperties.IgnoreList.Items[i]=(ClientProperties.Username+'['+
                                    ClientProperties.Compname+']'))then
                                    begin
                                        tmpListItem.StateIndex:=6;
                                        break;
                                    end;
        tmpListItem.SubItems.Add('['+ClientProperties.Compname+']');
        tmpListItem.SubItems.Add(IntToStr(ClientProperties.AlienID));
    end;

  if ClientProperties.AddUserQuery>0 then
      Dec(ClientProperties.AddUserQuery);
      
  Inc(ClientProperties.Users);
  StatusBar1.Panels[3].Text:='���������� �������������: '+IntToStr(ClientProperties.Users);

  if(ClientProperties.AddUserQuery>0)then
        begin
            InBufer.CurrentOperation := BC_STATE_GETID;
            InBufer.HowmanyNeedRec   := 2;
        end
      else
        begin
          if(ClientProperties.TCPUserlistNotReceived)then
            begin
              SetLength(TCPUsrs, 2);
              ClientSocket1.Socket.ReceiveBuf(TCPUsrs[1], 2);
              ClientProperties.TCPUserlistNotReceived := False;
            end;

            InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
            InBufer.HowmanyNeedRec   := 1;
        end;
   InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

procedure TMainForm.DelUserByID();
var
  //i, j,
  tmpIndex: integer;
begin
   tmpIndex := GetIndexByID(ClientProperties.AlienID);
   if SpeekerSettings.Debug then
      LogVariable('Index[DelUserByID]', IntToStr(tmpIndex));
   if((tmpIndex>1) and (tmpIndex<UserList.Items.Count))then
      begin
         //i:= UserList.Selected.Index;     // ������ ����������� ������������
         //j:= UserList.Items.Count-1;      // ��������� ��������� ������
         UserList.Items.Delete(tmpIndex); // ������� �������� � ����������� ��������
         Dec(ClientProperties.Users);
         StatusBar1.Panels[3].Text :='���������� �������������: '+ IntToStr(ClientProperties.Users);

         if(UserList.Selected = nil) then
         begin
            UserList.Items[tmpIndex-1].Selected:=true;
            UserList.Items[tmpIndex-1].Focused:=true;
         end;
         {
         if i<>j then
             UserList.Items[i].Selected:=true
         else
             UserList.Items[i-1].Selected:=true; }
         InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
         InBufer.HowmanyNeedRec := 1;
         InBufer.SetNextLength;
      end
   else
      begin
        ClientSocket1.Socket.Close;
        //ShowMessage('DelUserByID: ������ ����� �� �������! Index='+IntToStr(tmpIndex));
        InBufer.CurrentOperation := BC_STATE_RECONNECT;
        InBufer.HowmanyNeedRec := 1;
        InBufer.SetNextLength;
      end;
end;

//-----------------------------------------------------------------

procedure TMainForm.GETSEACommand(); // 9
begin
  InBufer.LastSEACommand := ord(InBufer.Bufer[1]);
if((InBufer.LastSEACommand>=1)and(InBufer.LastSEACommand<=14))then
begin
  if SpeekerSettings.Debug then
      LogVariable('LastSEACommand', IntToStr(InBufer.LastSEACommand));
  InBufer.isReadyForProc := false;

  if(InBufer.LastSEACommand = S2C_USERINFO)then
          begin
            InBufer.CurrentOperation := BC_STATE_GETFACULTY;
            InBufer.HowmanyNeedRec := 1;
          end
  else if(InBufer.LastSEACommand = S2C_PONG)then
          begin
            // ��� � ���, ��� ��� ��� ���� :)
            if SpeekerSettings.Debug then
              LogVariable('Ping?', 'Pong!');
            noPong := False;
            Pilingator.Enabled := False;
            Pilingator.Enabled := True;
            InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
            InBufer.HowmanyNeedRec   := 1;
          end
  else if(InBufer.LastSEACommand = S2C_ARCHIVELINK)then
          begin
            InBufer.CurrentOperation := BC_STATE_GETLINKLENGTH;
            InBufer.HowmanyNeedRec   := 1;
          end
  else if(InBufer.LastSEACommand = S2C_CHANGEALTSERVERIP)then
          begin
            InBufer.CurrentOperation := BC_STATE_GETNEWALTIP;
            InBufer.HowmanyNeedRec := 4;
          end
  else
          begin
            InBufer.CurrentOperation := BC_STATE_GETID;
            InBufer.HowmanyNeedRec := 2;
          end;
  InBufer.SetNextLength;
end
else
  Reconnect;
end;

procedure TMainForm.GetPrivate();    // 10
begin
  ClientProperties.Privat := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('Private', IntToStr(ClientProperties.Privat));
  if((ClientProperties.Privat=0)or(ClientProperties.Privat=1))then
    begin
      InBufer.isReadyForProc := false;
      InBufer.CurrentOperation := BC_STATE_GETPRINTER;
      InBufer.HowmanyNeedRec := 2;
      InBufer.SetNextLength;
    end
  else
    ClientSocket1.Socket.Close;
end;

//-----------------------------------------------------------------

procedure TMainForm.GetPrinter();    // 11
begin
  ClientProperties.Printer := ord(InBufer.Bufer[1]) mod 2;
  //��� �� - �������������� ���� �� ����������
  ClientProperties.lenpbyte:=ord(InBufer.Bufer[2]);
   if SpeekerSettings.Debug then
      LogVariable('lenprinterbyte', IntToStr(ClientProperties.lenpbyte));
  if SpeekerSettings.Debug then
      LogVariable('bufer', IntToStr(ord(InBufer.Bufer[1])));
  if SpeekerSettings.Debug then
      LogVariable('Printer', IntToStr(ClientProperties.Printer));
  ClientProperties.Priority:=(ord(InBufer.Bufer[1])div 2) mod 2;
  if SpeekerSettings.Debug then
      LogVariable('Priority', IntToStr(ClientProperties.Priority));
  if((ClientProperties.Printer=0)or(ClientProperties.Printer=1))then
    begin
      InBufer.isReadyForProc := false;
      InBufer.CurrentOperation := BC_STATE_GETMESLEN;
      InBufer.HowmanyNeedRec := 2;
      InBufer.SetNextLength;
    end
  else
    ClientSocket1.Socket.Close; //�����, ����������������
  end;

//-----------------------------------------------------------------

procedure TMainForm.GetMeslen();     // 12
begin
  ClientProperties.Meslen :=65536*ClientProperties.lenpbyte+TwoBytesToInt(InBufer.Bufer);
  if SpeekerSettings.Debug then
      LogVariable('Meslen', IntToStr(ClientProperties.Meslen));
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation := BC_STATE_GETMESSAGE;
  InBufer.HowmanyNeedRec := ClientProperties.Meslen;
  InBufer.SetNextLength;
end;

//-----------------------------------------------------------------

function FoundInIgnored(UserComp: string): boolean;
var
  i: integer;
begin
  result:=false;
  for i:=0 to MainForm.ClientProperties.IgnoreList.Items.Count-1 do
    if(MainForm.ClientProperties.IgnoreList.Items[i]=UserComp)then
      begin
        result:=true;
        break;
      end;
end;

procedure TMainForm.GetMessage();    // 13
var
   tmpListItem: TListItem;
   tmpIndex: integer;
   toBalloonHint, toSendIgn: string;
   MessageLen: integer;

begin

  EnDisButtons.Execute;

  ClientProperties.Messag := InBufer.Bufer;
  if SpeekerSettings.Debug then
      LogVariable('Message', ClientProperties.Messag);
  InBufer.isReadyForProc := false;
  InBufer.CurrentOperation := BC_STATE_GETZERO;
  InBufer.HowmanyNeedRec := 1;
  InBufer.SetNextLength;

  tmpIndex := GetIndexByID(ClientProperties.AlienID);
  if((tmpIndex>=0) and (tmpIndex<UserList.Items.Count))then
    begin
  if(not PriorityTB.Down or (ClientProperties.Priority=1) or  (ClientProperties.Printer=1) or (ClientProperties.Privat=1) ) then
    if(not(FoundInIgnored(UserList.Items[tmpIndex].Caption+
                          UserList.Items[tmpIndex].SubItems[0])))then
    // ���� �� ������ � ������������
      begin
        if(SpeekerSettings.OptPopup and not SpeekerSettings.AwayStatus)then CoolTrayIcon.ShowMainForm;
        if(SpeekerSettings.OptEnablesounds and not SpeekerSettings.AwayStatus)then
          if(ClientProperties.Privat=1)then
              PlaySound(PChar(SpeekerSettings.PrivateSound),0,SND_FILENAME)
          else
              PlaySound(PChar(SpeekerSettings.GroupSound),0,SND_FILENAME);

        with MessagesListView do          //TListView
          begin
            tmpListItem := Items.Add;
            tmpListItem.Caption := IntToStr(ClientProperties.AlienID);
            tmpListItem.SubItems.Add(IntToStr(ClientProperties.Privat));
            tmpListItem.SubItems.Add(IntToStr(ClientProperties.Printer+ClientProperties.Priority*2));
            tmpListItem.SubItems.Add(IntToStr(ClientProperties.Meslen));
            tmpListItem.SubItems.Add(ClientProperties.Messag);
            tmpListItem.SubItems.Add(TimeToStr(Time));
            tmpListItem.SubItems.Add(DateToStr(Date));
            tmpListItem.SubItems.Add(UserList.Items[tmpIndex].Caption);
            tmpListItem.SubItems.Add(UserList.Items[tmpIndex].SubItems[0]);
          end;
      if(MessagesListView.Items.Count=1)then
        begin
          if(MainForm.Visible)then
            begin
              MessagesListView.Items[0].Selected:=true;
              MessagesListView.Items[0].Checked:=true;
            end
          else
            begin
              MessagesListView.Items[0].Selected:=true;
              MessagesListView.Items[0].Checked:=false;
              CoolTrayIcon.IconIndex:=4;
            end;
        end;
        ExtractFile(ClientProperties.Messag);
      if(ShowMesBaloon.Checked and not SpeekerSettings.AwayStatus)then
        begin
          toBalloonHint:= ExtractPlainText(ClientProperties.Messag);
          MessageLen :=  Length(ExtractPlainText(ClientProperties.Messag));//  MessageLen := ClientProperties.Meslen;
          if MessageLen>255 then
            begin
              delete(toBalloonHint, 1, 256*(MessageLen div 256));
              toBalloonHint:='...'+#13#10+toBalloonHint;
            end;
          CoolTrayIcon.ShowBalloonHint(UserList.Items[tmpIndex].Caption+' '+
          UserList.Items[tmpIndex].SubItems[0], toBalloonHint, bitInfo, 10);
        end;
      end // if ignored condition end
    // ���� ������ � ������������
    else
      begin
        if(ClientProperties.Privat=1)then
          begin
            toSendIgn:=#10+Char(ClientProperties.AlienID div 256)+
                           Char(ClientProperties.AlienID mod 256);
            toSendIgn:=#0+Char(length(toSendIgn) div 256)+Char(length(toSendIgn) mod 256)+toSendIgn;
            ClientSocket1.Socket.SendBuf(toSendIgn[1], length(toSendIgn));
          end;
      end;

    if (ClientProperties.ownID = ClientProperties.AlienID) and SpeekerSettings.OptJumpOwnMessage then
      JumpToLast.Execute;
    //EnDisButtons.Execute;
    end
  else
    begin
      ClientSocket1.Socket.Close;
      ShowMessage('Index out of range [GetMessage]. AlienID='
      +IntToStr(ClientProperties.AlienID));
      if SpeekerSettings.Debug then
        LogVariable('Index out of range [GetMessage]. AlienID=', IntToStr(ClientProperties.AlienID));
    end;
end;

//-----------------------------------------------------------------
procedure TMainForm.GetZero(); // 14
begin
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
  InBufer.HowmanyNeedRec := 1;
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetFaculty();   // 15
begin
  AlienInfo.Faculty := ord(InBufer.Bufer[1]);
  if SpeekerSettings.Debug then
      LogVariable('Faculty', IntToStr(AlienInfo.Faculty));
  if((AlienInfo.Faculty=1)or(AlienInfo.Faculty=2))then
    begin
      InBufer.isReadyForProc := false;
      InBufer.CurrentOperation := BC_STATE_GETROOM;
      InBufer.HowmanyNeedRec := 5;
      InBufer.SetNextLength;
    end
  else
    ClientSocket1.Socket.Close;
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
  InBufer.CurrentOperation := BC_STATE_GETINFOLEN;
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
    InBufer.CurrentOperation:= BC_STATE_GETIPLEN;
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
      InBufer.CurrentOperation := BC_STATE_GETVERSION;
      InBufer.HowmanyNeedRec := 1;
    end
  else
    begin
      InBufer.CurrentOperation := BC_STATE_GETINFO;
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
    InBufer.CurrentOperation := BC_STATE_GETVERSION;
    InBufer.HowmanyNeedRec := 1;
    InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

//-----------------------------------------------------------------

procedure TMainForm.GetChatMeslen();  // 20
var
  onChat: string;
  Buf1: string;
  i:   integer;
begin
  InBufer.isReadyForProc := false;
  if(ord(InBufer.Bufer[1])=0)then
    begin
      if(ChatYESNOForm.Visible)then
        begin
          ChatYESNOForm.Close;
          
          CreateChatWindow.Execute;
        end
      else
        begin
          if(TryChatForm.Visible)then
            begin
              TryChatForm.Close;
              onChat:=#7+Char(ClientProperties.AlienID div 256)+
                         Char(ClientProperties.AlienID mod 256)+#0;
              onChat:=#0+Char(Length(onChat) div 256)+
                         Char(Length(onChat) mod 256)+onChat;
              ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
              CreateChatWindow.Execute;
            end
          else
            begin
              for i:=0 to ChatListView.Items.Count-1 do
              begin
                Buf1 := ChatListView.Items[i].SubItems[0];
                if(StrToInt(Buf1)=ClientProperties.AlienID) then
                  begin
                    break;
                  end;
              end;

              CoolTrayIcon.ShowMainForm;

              if(ChatListView.Items.Count>0)then
                begin
                  if(tmpChatForm[i]=nil)then
                    ChatYESNOForm.Show
                  else if(not(tmpChatForm[i].Visible))then ChatYESNOForm.Show;
                end
              else
                ChatYESNOForm.Show;

            end;
        end;
      InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
      InBufer.HowmanyNeedRec := 1;    
    end
  else
    begin
      if(ChatListView.Items.Count>0)then
        begin
          InBufer.CurrentOperation := BC_STATE_GETCHATMESSAGE;
          InBufer.HowmanyNeedRec := ord(InBufer.Bufer[1]);
        end
      else
        begin
          //InBufer.CurrentOperation:=21;
          //InBufer.HowmanyNeedRec := ord(InBufer.Bufer[1]);
          ClientSocket1.Socket.Close;
        end;
    end;
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------
procedure TMainForm.GetChatMessage(); // 21
var
  Buf1: string;
  i:   integer;
begin

  for i:=0 to ChatListView.Items.Count-1 do
  begin
    Buf1 := ChatListView.Items[i].SubItems[0];
    if(StrToInt(Buf1)=ClientProperties.AlienID) then
      begin
        break;
      end;
  end;
    // ����� ���� ���� �� ID
    // ��������� ��������� �� InBufer.Bufer
    // � Memo ���� � ������ ������������
    // i

    tmpChatForm[StrToInt(ChatListView.Items[i].Caption)].
    BChatMemo.Lines.Add('['+TimeToStr(Time)+']['+
    ChatListView.Items[i].SubItems[1]+'] '+InBufer.Bufer);
    InBufer.isReadyForProc:=false;
    InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
    InBufer.HowmanyNeedRec := 1;
    InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetNewAltIP(); // 22
var
  NewIP: String;
  sIniFile: TIniFile;
begin

    NewIP := Format ('%d.%d.%d.%d', [byte (ord(InBufer.Bufer[1])),
                                     byte (ord(InBufer.Bufer[2])),
                                     byte (ord(InBufer.Bufer[3])),
                                     byte (ord(InBufer.Bufer[4]))]);

    if(SpeekerSettings.MainServerIP <> NewIP) then
      begin
        SpeekerSettings.AltServerIP := NewIP;
        sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');
        sIniFile.WriteString( 'Servers', 'AltServerIP' ,  NewIP);
        sIniFile.Free;
      end
    else
      ShowMessage('������ ��������� � ��������������� ������� ������ ���� �������!');
    InBufer.isReadyForProc:=false;
    InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
    InBufer.HowmanyNeedRec := 1;
    InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetLinkLength();  // 23
begin
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation := BC_STATE_GETLINK;
  InBufer.HowmanyNeedRec   := ord(InBufer.Bufer[1]);
  InBufer.SetNextLength;
end;
//-----------------------------------------------------------------

procedure TMainForm.GetLink();       // 24
var
  wnd:HWND;
begin
  ShellExecute(wnd, 'open', PAnsiChar(InBufer.Bufer),
  NIL, NIL, SW_SHOWMAXIMIZED);
  InBufer.isReadyForProc:=false;
  InBufer.CurrentOperation := BC_STATE_GETSEACOMMAND;
  InBufer.HowmanyNeedRec   := 1;
  InBufer.SetNextLength;
end;

procedure TMainForm.ReceiveForProcessing(ReadyBufer: string);
begin
  if SpeekerSettings.Debug then
      LogVariable('Receive for processing', 'current operation ' + IntToStr(InBufer.CurrentOperation));
  if(InBufer.CurrentOperation=1)then GetID            else   // 1. GetID
  if(InBufer.CurrentOperation=2)then GetIPLen         else   // 2. GetIPLen
  if(InBufer.CurrentOperation=3)then GetIP            else   // 3. GetIP
  if(InBufer.CurrentOperation=4)then GetListLen       else   // 4. GetListLen
  if(InBufer.CurrentOperation=5)then GetUsernameLen   else   // 5. GetUsernameLen
  if(InBufer.CurrentOperation=6)then GetUsernameMy    else   // 6. GetUsernameMy
  if(InBufer.CurrentOperation=7)then GetCompnameLen   else   // 7. GetCompnameLen
  if(InBufer.CurrentOperation=8)then GetCompname      else   // 8. GetCompname
  if(InBufer.CurrentOperation=9)then GetSEACommand    else   // 9. GetSEACommand
  if(InBufer.CurrentOperation=10)then GetPrivate      else   // 10. GetPrivate
  if(InBufer.CurrentOperation=11)then GetPrinter      else   // 11. GetPrinter
  if(InBufer.CurrentOperation=12)then GetMeslen       else   // 12. GetMeslen
  if(InBufer.CurrentOperation=13)then GetMessage      else   // 13. GetMessage
  if(InBufer.CurrentOperation=14)then GetZero         else   // 14. GetZero
  if(InBufer.CurrentOperation=15)then GetFaculty      else   // 15. GetFaculty
  if(InBufer.CurrentOperation=16)then GetRoom         else   // 16. GetRoom
  if(InBufer.CurrentOperation=17)then GetVersion      else   // 17. GetVersion
  if(InBufer.CurrentOperation=18)then GetInfolen      else   // 18. GetInfoLen
  if(InBufer.CurrentOperation=19)then GetInfo         else   // 19. GetInfo
  if(InBufer.CurrentOperation=20)then GetChatMeslen   else   // 20. GetChatMeslen
  if(InBufer.CurrentOperation=21)then GetChatMessage  else   // 21. GetChatMessage
  if(InBufer.CurrentOperation=22)then GetNewAltIP     else   // 22. Change Alternative Server IP
  if(InBufer.CurrentOperation=23)then GetLinkLength   else   // 23. GetLinkLength
  if(InBufer.CurrentOperation=24)then GetLink         else   // 24. GetLink
  if((InBufer.CurrentOperation<1)or(InBufer.CurrentOperation>24))then
  begin
    if SpeekerSettings.Debug then
      LogVariable('CurrentOperation out of range', IntToStr(InBufer.CurrentOperation));

    ClientSocket1.Socket.Close;
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
  room:=OptionsForm.RoomCmbBox.Items[StrToInt(SpeekerSettings.Room)];
  info:=SpeekerSettings.Info;
  ns:= Char(Length(info))+info;
  ns:= room+ns+#102;//������
  if(SpeekerSettings.Faculty)then
    ns:= #4+#1+ns
  else
    ns:= #4+#2+ns;
  j:=length(ns);
  ns:=#0+Char(j div 256)+Char(j mod 256)+ns;
  Socket.SendBuf(ns[1],length(ns));

  if AwayTB.Down then
      begin
         s := #0#0#1#11;
         ClientSocket1.Socket.SendBuf(s[1],length(s));
      end;

  if  PrinterTB.Down then
      begin
         s := #0#0#1#15;
         ClientSocket1.Socket.SendBuf(s[1],length(s));
      end;
     {TClientSocket}

  if(ClientSocket1.Active)then
    begin
        BalloonMessage:='���������';
        StatusBar1.Panels[0].Text:='���������';
    end
  else
    begin
        BalloonMessage:='�����������';
        StatusBar1.Panels[0].Text:='�����������';

    end;
  

  if(ClientSocket1.Host=SpeekerSettings.AltServerIP)then
      begin
        //PingTimer.Enabled:=true;
        StatusBar1.Panels[0].Text:=StatusBar1.Panels[0].Text+' [��������������]';

        PingMSTimer.Enabled := true;
        if SpeekerSettings.Debug then
          LogVariable('Socket connect, pingMStimer', ' is on');
      end
  else
      begin
        StatusBar1.Panels[0].Text:=StatusBar1.Panels[0].Text+' [��������]';
      end;

  noPong := False;
  Pilingator.Enabled := True;
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

    if(not(DirectoryExists(MainForm.SpeekerSettings.UserAppdataDir)))then
        CreateDir(MainForm.SpeekerSettings.UserAppdataDir);
    sIniFile := TIniFile.Create(SpeekerSettings.UserAppdataDir + '\Settings.ini');

    sIniFile.WriteBool('Programm', 'ShowPanel', PanelState);
    sIniFile.Free;

  UserList.Clear;
  ClientProperties.Users:=0;
  StatusBar1.Panels[3].Text:='����� �������������: 0';
  if(ClientSocket1.Active)then
  begin
      BalloonMessage:='Connected';
      StatusBar1.Panels[0].Text:='���������';
  end
  else
  begin
      BalloonMessage:='�����������';
      StatusBar1.Panels[0].Text:='�����������';

      //Reconnect;
      //ConDiscon.Execute;
      ReconnectTimer.Enabled := True;
  end;

  //CoolTrayIcon.ShowBalloonHint('����������', BalloonMessage, bitInfo, 10);
  Pilingator.Enabled := false;
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
  if MessagesListView.Selected <> nil then
    MessagesListView.Items[MessagesListView.Selected.Index].Checked := true;

  if(MessagesListView.Items.Count=1)then
      begin
        MessagesListView.ItemIndex:=0;
        CoolTrayIcon.IconIndex:=5;
      end;
end;

procedure TMainForm.TrayPopupMenuPopup(Sender: TObject);
begin
  N13.Checked := SpeekerSettings.OptEnablesounds;
end;

//-----------------------------------------------------------------

procedure TMainForm.CoolTrayIconClick(Sender: TObject);
begin
  if not(MainForm.Visible) then
    begin
      CoolTrayIcon.ShowMainForm;
      sSkinManager1.Active := SpeekerSettings.Skinned;
      if (MessagesListView.Selected <> nil) then
        MessagesListView.Items[MessagesListView.Selected.Index].Checked := true;
        
      if(MessagesListView.Items.Count=1)then
        begin
          MessagesListView.ItemIndex:=0;
          CoolTrayIcon.IconIndex:=5;
        end;
    
    end
  else
    begin
      Application.Minimize;
    end;
end;
             
//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;
  ClientSocket1.Socket.Close;
  if SpeekerSettings.Debug then
      LogVariable('Main socket', 'connect error');
end;

//-----------------------------------------------------------------

procedure TMainForm.ClientSocket1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  MainForm.Cursor:=crHourGlass;
  StatusBar1.Panels[0].Text:='����������...';
end;

//-----------------------------------------------------------------

procedure TMainForm.ConDisconExecute(Sender: TObject);
var
  tmp:  DWORD;
  tmp2: String;
begin

  // �� ����������?
  if(ClientSocket1.Active)then
    begin
      // �����������!
      ClientSocket1.Socket.Close;

      // ����� ��� ������� ����� ������� ConDisconExecute
      //ReconnectTimer.Enabled := True;
    end
  // �� ����������
  else
    begin

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

      try
        if ClientSocket1.Host=SpeekerSettings.MainServerIP then
          begin
            ClientSocket1.Host := SpeekerSettings.AltServerIP;
            PingMSClientSocket.Host := SpeekerSettings.MainServerIP;
          end
        else
          ClientSocket1.Host := SpeekerSettings.MainServerIP;

        ClientSocket1.Open;
      except
        ClientSocket1.Close;
      end;
  end;
end;

//-----------------------------------------------------------------

//-----------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
    ignorfile: TextFile;
    Ini: TIniFile;
    BFWidth, BFHeight: Integer;
begin
  Application.ProcessMessages;
  Application.OnMessage := AppMessage;

  MessageMemo:=TRichEdit.Create(Self);
  with MessageMemo do begin
    Parent := MiddlePanel;
    Visible := True;
    Top:=27;
    Left:=2;
    Width:=MiddlePanel.Width-4;
    Height:=MiddlePanel.Height-Top-2;
    Align:= alCustom;
    Anchors:=[akTop, akRight, akBottom, akLeft];
    ScrollBars:=ssVertical;
    Color := clBtnFace;//clWhite;
    ReadOnly:=true;
    PopupMenu:=RichEditPopupMenu;
  end;

  sSkinManager1.SkinDirectory := ExtractFilePath(GetCurrentDir() + '\Skins\');

  SpeekerSettings:= TProgSettings.Create;
  ClientProperties:= TClientProperties.Create;
  InBufer:= TInBufer.Create;
  AlienInfo:= TAlienInfo.Create;
  SetUserAppDataDir;
  Ini := TIniFile.Create( GetIniPath );
  try
    BFHeight :=  Ini.ReadInteger('Programm', 'Height', 700);
    if BFHeight < 654 then
      MainForm.Height := 654
    else
      MainForm.Height := BFHeight;

    BFWidth  :=  Ini.ReadInteger('Programm', 'Width', 660);
    if BFWidth < 652 then
      MainForm.Width := 652
    else
      MainForm.Width := BFWidth;

    MainForm.Top  :=  Ini.ReadInteger('Programm', 'Top', 150);
    MainForm.Left :=  Ini.ReadInteger('Programm', 'Left', 360);

  finally
    Ini.Free;
  end;

  NullVaribles;
  Caption:=ClientProperties.Version;

  // Init update socket
  UpdateClientSocket.Host :=  SpeekerSettings.MainServerIP;
  UpdateAct.Execute;
  // Init end

  if(SpeekerSettings.OptStartmin)then WindowState:= wsMinimized;

  ClientProperties.IgnoreList := TListBox.Create(Self);
    with ClientProperties.IgnoreList do
        begin
          Parent := MainForm;
          Visible := false;
        end;
  if(FileExists(SpeekerSettings.UserAppdataDir+'\Ignorlist.txt'))then
  begin
    AssignFile(ignorfile, SpeekerSettings.UserAppdataDir+'\Ignorlist.txt');

      with ClientProperties.IgnoreList do
        begin
          try
            Items.LoadFromFile(SpeekerSettings.UserAppdataDir+'\Ignorlist.txt');
          except
            Rewrite(ignorfile);
          end;
        end;
  end;

  // Debug Time
  if SpeekerSettings.Debug then
      Caption := Caption + ' '+TimeToStr(Time)+' '+DateToStr(Date)+' [DEBUG MODE]';
  // Set Hints --------------

  FirsmesToolButton.Hint   := FirsmesToolButton.Hint+' (Alt + Left)';
  BackToolButton.Hint      := BackToolButton.Hint+' (Ctrl + Left)';
  ForwardToolButton.Hint   := ForwardToolButton.Hint+' (Ctrl + Right)';
  LastmesToolButton.Hint   := LastmesToolButton.Hint+' (Alt + Right)';

  //-------------------------

  CoolTrayIcon.IconIndex:=3;

  ConDiscon.Execute;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
//  SetMemoFont;
sSkinManager1.Active := SpeekerSettings.Skinned;
end;

//-----------------------------------------------------------------

procedure TMainForm.CoolTrayIconDblClick(Sender: TObject);
var
  isActive, BalloonMessage: string;
  AllMes, ReadMes: integer;
  i: integer;
begin
  ReadMes:=0;
  AllMes:=MessagesListView.Items.Count;
  if(ClientSocket1.Active)then isActive:='���������� �������'
  else isActive:='���������� �� �������';
  for i:=0 to AllMes-1 do
      if(MessagesListView.Items[i].Checked)then ReadMes:=ReadMes+1;
  BalloonMessage:='����������� ���������: '+IntToStr(ReadMes)
  +#13#10+'������������� ���������: '+IntToStr(AllMes-ReadMes)+#13#10+
  '����� ���������: '+IntToStr(AllMes);
  CoolTrayIcon.ShowBalloonHint(isActive, BalloonMessage, bitInfo, 10);
end;

//-----------------------------------------------------------------

procedure TMainForm.OpenSiteActionExecute(Sender: TObject);
var
  s: String;
begin
  s := #0#0#1#9;
  ClientSocket1.Socket.SendBuf(s[1],length(s));
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
  SetLength(InBufer.tmpBufer, InBufer.HowmanyNeedRec);
  i := Socket.ReceiveBuf(InBufer.tmpBufer[1], InBufer.HowmanyNeedRec);
    if i>0 then
    begin
      InBufer.GetInputBytes(i);
      if SpeekerSettings.Debug then
        LogVariable('�������� ����', IntToStr(i));
      if (InBufer.isReadyForProc) then
      begin
        if SpeekerSettings.Debug then
          LogVariable('���������� �� ��������� ���������� ������ ', InBufer.Bufer);
        ReceiveForProcessing(InBufer.Bufer);
      end;
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
  if (tmpListItem <> nil) then
  begin
      MessageMemo.Clear;
      SetMemoFont;
      EnDisButtons.Execute;
      MessageMemo.Text:= ExtractRTF(MessagesListView.Selected.SubItems[3]);

      //MessageMemo.SelStart:=Length(MessageMemo.Text);
      WhomEdit.Text := MessagesListView.Selected.SubItems[6]
                     + MessagesListView.Selected.SubItems[7];
      if(StrToInt(MessagesListView.Selected.SubItems[0])=1)then
        if(StrToInt(MessagesListView.Selected.SubItems[1])=0)then
          begin
            WhomEdit.Text := WhomEdit.Text + ' -> ' + SpeekerSettings.UserName;
            WhomImage.Picture := nil;
            if MessagesListView.Selected.SubItems[2]<>'CHR' then
              if MessagesListView.Selected.SubItems[2]<>'NA' then
                ImageList1.GetBitmap(1, WhomImage.Picture.Bitmap)
              else
                ImageList1.GetBitmap(7, WhomImage.Picture.Bitmap)
            else
              ImageList1.GetBitmap(8, WhomImage.Picture.Bitmap)

          end
        else
          begin
            WhomEdit.Text := WhomEdit.Text + ' ����������';
            WhomImage.Picture := nil;
            ImageList1.GetBitmap(0, WhomImage.Picture.Bitmap);
          end
      else
          begin
            WhomEdit.Text := WhomEdit.Text + ' ����';
            WhomImage.Picture := nil;
            ImageList1.GetBitmap(0, WhomImage.Picture.Bitmap);
          end;
      WhomEdit.Text := WhomEdit.Text+' � '+ MessagesListView.Selected.SubItems[4]+
      ', '+ MessagesListView.Selected.SubItems[5];
      //MessagesListView.Items[MessagesListView.Selected.Index].Checked:=true;
      MesnumberLabel.Caption:='�����.: '+IntToStr(MessagesListView.Selected.Index+1)+
                                    '/'+IntToStr(MessagesListView.Items.Count);
      CheckedNumber:=0;
      for i:=0 to MessagesListView.Items.Count-1 do
      begin
          if (MessagesListView.Items[i].Checked) then
              begin
                  CheckedNumber:=CheckedNumber+1;
              end;
      end;
      if CheckedNumber=MessagesListView.Items.Count then
          CoolTrayIcon.IconIndex:=5
      else
          CoolTrayIcon.IconIndex:=4;

      // ���� ��� "��������" ���������, ������ ������� ���������� ������ ����������
      if CheckedNumber=0 then
          DeleteAllChMessages.Enabled:=false
      else
          DeleteAllChMessages.Enabled:=true;

      //EnDisButtons.Execute;
  end
  else if(MessagesListView.Items.Count=0)then
  begin
      MesnumberLabel.Caption:='��� ���������';
      CoolTrayIcon.IconIndex:=3;
      if(SpeekerSettings.OptDelastmin)then Application.Minimize;
  end;
    StatusBar1.Panels[1].Text := '���������: '+IntToStr(MessagesListView.Items.Count);
  

  if(MainForm.Active and SpeekerSettings.Smiled) then InsertSmiles;
end;

procedure TMainForm.CheckAllMessagesBtnClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to MessagesListView.Items.Count-1 do
    MessagesListView.Items[i].Checked:=true;
end;
      // Action ��� �������� ���� ���������
procedure TMainForm.DeleteAllMessagesExecute(Sender: TObject);
begin
  MessagesListView.Clear;
  MessageMemo.Clear;
  WhomEdit.Text:='';
  MesnumberLabel.Caption:='��� ���������';
  CoolTrayIcon.IconIndex:=3;
  StatusBar1.Panels[1].Text := '���������: 0';
  if(SpeekerSettings.OptDelastmin)then Application.Minimize;
  EnDisButtons.Execute;
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
              MesnumberLabel.Caption:='��� ���������';
              CoolTrayIcon.IconIndex:=3;
              if(SpeekerSettings.OptDelastmin)then Application.Minimize;
        end;
        
  StatusBar1.Panels[1].Text := '���������: '+IntToStr(MessagesListView.Items.Count);
  CheckSelected.Execute;
  EnDisButtons.Execute;
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
    if MessagesListView.Selected <> nil then
      begin
        i:= MessagesListView.Selected.Index;
        j:= MessagesListView.Items.Count-1;
        MessagesListView.Items.Delete(i);

        if MessagesListView.Items.Count<>0 then
          if i=j then
            MessagesListView.Items[i-1].Selected:=true
          else
            MessagesListView.Items[i].Selected:=true;
      end
    else
      ShowMessage('�� ���� ��������� �� �������!');
  end;
  if MessagesListView.Items.Count=0 then
  begin
     MessageMemo.Clear;
     WhomEdit.Text:='';
     MesnumberLabel.Caption:='��� ���������';
     CoolTrayIcon.IconIndex:=3;
     StatusBar1.Panels[1].Text:='���������: 0';
     if(SpeekerSettings.OptDelastmin)then Application.Minimize;
  end;
  CheckSelected.Execute;
  EnDisButtons.Execute;
end;

procedure TMainForm.DelcurmesToolButtonClick(Sender: TObject);
begin
    DeleteCurrentMessage.Execute;
end;

procedure TMainForm.JumpUpExecute(Sender: TObject);
var
  LastIndex, UpIndex: integer;
begin
      if  (MessagesListView.Items.Count>1) and (MessagesListView.Selected<>nil) then
        begin
          LastIndex := MessagesListView.Items.Count-1;
          UpIndex   := MessagesListView.Selected.Index+1;
          if UpIndex <= LastIndex then
            MessagesListView.Items[UpIndex].Selected:=true;
        end;
        EnDisButtons.Execute;
        CheckSelected.Execute;
        //EnDisButtons.Execute;
end;

procedure TMainForm.JumpDownExecute(Sender: TObject);
var
    DownIndex: integer;
begin
 if  (MessagesListView.Items.Count>1) and (MessagesListView.Selected<>nil) then
  begin
  DownIndex := MessagesListView.Selected.Index-1;
  if DownIndex >= 0 then
      MessagesListView.Items[DownIndex].Selected:=true;
  end;
  EnDisButtons.Execute;
  CheckSelected.Execute;
  //EnDisButtons.Execute;
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

  EnDisButtons.Execute;
  CheckSelected.Execute;
  //EnDisButtons.Execute;
end;

procedure TMainForm.JumpToFirstExecute(Sender: TObject);
begin
  if  MessagesListView.Items.Count>1 then
      MessagesListView.Items[0].Selected:=true;

  EnDisButtons.Execute;
  CheckSelected.Execute;
  //EnDisButtons.Execute;
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



procedure TMainForm.ConDisconToolBtnClick(Sender: TObject);
begin
    ConDiscon.Execute;
end;

procedure TMainForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_SYSCOMMAND then
  begin
    case Msg.wParam of
      SC_CLOSE:
        begin
          Application.Minimize;
          Handled := True;
        end;
    end;
  end;
end;

procedure TMainForm.WMSYSCOMMAND(var msg: TMessage);
begin
  if (msg.WParam=SC_MINIMIZE) or (msg.WParam=SC_CLOSE) then
  begin
    //HideMainForm;  //  ��������������
    Application.Minimize;
    msg.result:=1;  //  � ������ ������ �� ������
    exit;
  end
  else inherited; //������, ��� ��������
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

    if(not(DirectoryExists(SpeekerSettings.UserAppdataDir)))then
        CreateDir(SpeekerSettings.UserAppdataDir);
    sIniFile := TIniFile.Create(SpeekerSettings.UserAppdataDir + '\Settings.ini');

    sIniFile.WriteBool('Programm', 'ShowPanel', PanelState);

    sIniFile.WriteInteger('Programm', 'Height', MainForm.Height);
    sIniFile.WriteInteger('Programm', 'Width',  MainForm.Width);
    sIniFile.WriteInteger('Programm', 'Top',    MainForm.Top);
    sIniFile.WriteInteger('Programm', 'Left',   MainForm.Left);
    sIniFile.WriteBool( 'User', 'isPrinter',   SpeekerSettings.PrintUser);
    sIniFile.Free;

    ClientProperties.IgnoreList.Items.SaveToFile(SpeekerSettings.UserAppdataDir + '\Ignorlist.txt');
    Close;

    //Application.Terminate;
end;

//---------------------------------------------------------------------


procedure TMainForm.FormResize(Sender: TObject);
begin
  StatusBar1.Panels[2].Width:=Width-482;
end;


procedure TMainForm.ReplyAuthorExecute(Sender: TObject);
var
    SendMessageForm: TSendMessageForm;
    foundIndex, id: integer;
    onChat: string;
begin
// ����� �� ���
  if ((MessagesListView.Selected<>nil)and(UserList.Selected<>nil)) then
    if(MessagesListView.Selected.SubItems[2]<>'CHR')then
      begin
        SendMessageFlag := 1;
        SendMessageForm := TSendMessageForm.Create(Self);
        SendMessageForm.Show;
      end
    else
      begin
        foundIndex:=SendMessageForm.FindUser;
        if(foundIndex>0)then
          begin
            UserList.ItemIndex:=foundIndex;
            id := StrToInt(UserList.Items[foundIndex].SubItems[1]);
            onChat:=#7+Char(id div 256)+
                       Char(id mod 256)+#0;
            onChat:=#0+Char(Length(onChat) div 256)+
                       Char(Length(onChat) mod 256)+onChat;
            ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
            TryChatForm.Show;
          end
        else
          begin
            Application.MessageBox('������������ �� ������. �� �� ������ ��� �����������.',
            '������������ �� ������.', MB_OK)
          end;
      end;

  EnDisButtons.Execute;
end;

procedure TMainForm.ReplyGroupExecute(Sender: TObject);
var
    SendMessageForm: TSendMessageForm;
begin
  if ((MessagesListView.Selected<>nil)and(UserList.Selected<>nil)) then
    if(MessagesListView.Selected.SubItems[2]<>'CHR')then
  begin
   SendMessageFlag := 2;
   SendMessageForm := TSendMessageForm.Create(Self);
   SendMessageForm.Show;
  end;

  EnDisButtons.Execute;
end;

procedure TMainForm.WriteNewMessageExecute(Sender: TObject);
var
    SendMessageForm: TSendMessageForm;
begin
  if(UserList.Items.Count > 0)then
    begin
      SendMessageFlag := 3;
      SendMessageForm := TSendMessageForm.Create(Self);
      SendMessageForm.Show;
    end
  else
    ShowMessage('�� ������� ������ ����!');
end;

procedure TMainForm.UserListDblClick(Sender: TObject);
begin
  if(UserList.Selected<>nil)then
    begin
      SendMessageFlag := 4;
      SendMessageForm := TSendMessageForm.Create(Self);
      SendMessageForm.Show;
    end
  else
    ShowMessage('�������� ������������ �� ������ ��� �������� ������ ���������!');
end;

function TMainForm.AssignIndex:integer;
var
  index: integer;
  i: integer;
  tmpListItem: TListItem;
begin

  index:=ChatListView.Items.Count;
  if ChatListView.Items.Count>0 then
      for i:=0 to ChatListView.Items.Count-1 do
        begin
          if(i<>StrToInt(ChatListView.Items[i].Caption))then
            begin
              index:=i;
              break;
            end;
        end
  else
      index := 0;

  if index<10 then
  begin
    result:=index;
    with ChatListView do          //TListView
    begin
        tmpListItem := Items.Add;
        tmpListItem.Caption := IntToStr(index);
        tmpListItem.SubItems.Add(IntToStr(ClientProperties.AlienID));
        tmpListItem.SubItems.Add(
        UserList.Items[GetIndexByID(ClientProperties.AlienID)].Caption);
    end;
  end
  else
    result:=-1;
end;

procedure TMainForm.CreateChatWindowExecute(Sender: TObject);
var
  tmpIndex: integer;
  UserlistIndex : integer;
begin
  tmpIndex := AssignIndex;
  if(tmpIndex<0)then
     ShowMessage('You don'+#39+'t create more than 9 chat windows.')
  else
    begin
      UserlistIndex := GetIndexByID(ClientProperties.AlienID);
      tmpChatForm[tmpIndex]:= TBChatForm.Create(Self);
      with tmpChatForm[tmpIndex] do
        begin
          Name:='ChatWindow'+IntToStr(tmpIndex);
          Tag:=ClientProperties.AlienID;
          //BChatEdit.Text:=IntToStr(tmpIndex);
          Number:=IntToStr(tmpIndex);
          Caption := Caption + ' with '+
          Userlist.Items[UserlistIndex].Caption+
          UserList.Items[UserlistIndex].SubItems[0];
          FormStyle:=fsStayOnTop;
          Show;
        end;
    end;
end;

procedure TMainForm.ChatClick(Sender: TObject);
var
  Buf1, onChat: string;
  i, id: integer;
  itsnotactive: Boolean;
begin

  itsnotactive := true;

  id := StrToInt(MainForm.UserList.Selected.SubItems[1]);

  for i:=0 to ChatListView.Items.Count-1 do
  begin
    Buf1 := ChatListView.Items[i].SubItems[0];
    if(StrToInt(Buf1)=id) then
      begin
        itsnotactive := false;
        break;
      end;
  end;

  if itsnotactive then
    begin
      onChat:=#7+Char(id div 256)+
                 Char(id mod 256)+#0;
      onChat:=#0+Char(Length(onChat) div 256)+
                 Char(Length(onChat) mod 256)+onChat;
      ClientSocket1.Socket.SendBuf(onChat[1],length(onChat));
      TryChatForm.Show;
    end
  else
    ShowMessage('��� � ���� ������������� ��� ����������!');
end;

procedure TMainForm.ShowMesBaloonClick(Sender: TObject);
begin
  ShowMesBaloon.Checked := not(ShowMesBaloon.Checked);
end;

procedure TMainForm.N13Click(Sender: TObject);
begin
  N13.Checked := not(N13.Checked);
  SpeekerSettings.OptEnablesounds := N13.Checked;
end;

procedure ShellExec(CmdStr: string);
var
  sei: TShellExecuteInfo;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.lpFile := PChar(CmdStr);
  sei.nShow := SW_SHOWNORMAL;
  ShellExecuteEx(@sei);
end;

procedure TRichEdit.CreateWnd; { �������� ��������� URL }
begin
  inherited;
  SendMessage(Handle, EM_AUTOURLDETECT, Integer(True), 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0,
              SendMessage(Handle, EM_GETEVENTMASK, 0,0) or ENM_LINK);
end;

procedure TRichEdit.CNNotify(var Message: TWMNotify); { ��� � URL � �������� }
type PENLink = ^TENLink;
var TR: TextRangeA;
begin
  if (Message.NMHdr^.code=EN_LINK) then
  begin
    if PENLink(Message.NMHdr).Msg = WM_LBUTTONDOWN then
    begin
      TR.chrg := PENLink(Message.NMHdr).chrg;
      GetMem(TR.lpstrText, TR.chrg.cpMax - TR.chrg.cpMin + 2);
      try
        SendMessage(Handle, EM_GETTEXTRANGE, 0, Integer(@TR));
        ShellExec(TR.lpstrText);
      finally
        FreeMem(TR.lpstrText);
      end;
    end;
    Message.Result := 0;
  end
  else inherited;
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  OptionsForm.Show;
end;

procedure TMainForm.GoToFromAwayExecute(Sender: TObject);
var
  s: string;
begin
     if SpeekerSettings.AwayStatus then
      begin
         s := #0#0#1#12;
         ClientSocket1.Socket.SendBuf(s[1],length(s));
         AwayTB.Down := false;
         AWAY1.Checked := false;
         SpeekerSettings.AwayStatus := false;
         AwayTB.Hint := '������� ������ �� "�� �������"';
      end
  else
      begin
         s := #0#0#1#11;
         ClientSocket1.Socket.SendBuf(s[1],length(s));
         AwayTB.Down := true;
         AWAY1.Checked := true;
         SpeekerSettings.AwayStatus := true;
         AwayTB.Hint := '������� ������ �� "�������"';
      end;
end;

procedure TMainForm.GoToFromPrinterExecute(Sender: TObject);
var
  s: string;
begin
   if  PrinterTB.Down then
      begin
         s := #0#0#1#15;
         ClientSocket1.Socket.SendBuf(s[1],length(s));
         PrinterTB.Hint := '����� �� ������ "���������"';
         SpeekerSettings.PrintUser:=true;
      end
  else
      begin
         s := #0#0#1#16;
         ClientSocket1.Socket.SendBuf(s[1],length(s));
         PrinterTB.Hint := '����� � ������ "���������"';
         SpeekerSettings.PrintUser:=false;
      end;
end;

function isIgnored(User: string): boolean;
var
  i: integer;
begin
  result:=false;
  for i:=0 to MainForm.ClientProperties.IgnoreList.Items.Count-1 do
  begin
      if(User=MainForm.ClientProperties.IgnoreList.Items[i])then
          begin
              result:=true;
              break;
          end;
  end;
end;

procedure TMainForm.UserListPMPopup(Sender: TObject);
begin
  if(UserList.Selected<>nil)then
    if((UserList.Selected.SubItems[1]<>'0')and(UserList.Selected.SubItems[1]<>'65535'))then
    begin
      if ClientProperties.ownID<>StrToInt(UserList.Selected.SubItems[1]) then
        Chat.Enabled:=true
      else
        Chat.Enabled:=false;

      NewMessagePMU.Enabled:=true;
      MutePMU.Enabled:=true;
      UInfoPMU.Enabled:=true;
      MutePMU.Checked:=isIgnored(UserList.Selected.Caption+UserList.Selected.SubItems[0]); // ��� �� �����?
    end
    else
    begin
      Chat.Enabled:=false;
      NewMessagePMU.Enabled:=true;
      MutePMU.Enabled:=false;
      UInfoPMU.Enabled:=false;
    end
  else
  begin
    Chat.Enabled:=false;
    NewMessagePMU.Enabled:=false;
    MutePMU.Enabled:=false;
    UInfoPMU.Enabled:=false;
  end;
end;

procedure TMainForm.ChatSoundTimerTimer(Sender: TObject);
begin
    PlaySound(PChar(SpeekerSettings.ChatSound),0,SND_FILENAME);
end;

procedure TMainForm.toTrayExecute(Sender: TObject);
begin
    Application.Minimize;
end;

procedure TMainForm.UInfoPMUClick(Sender: TObject);
var
    s: string;
    id: integer;
begin
  if(UserList.Selected<>nil)then
  begin
    s := #0#0#3#5;
    AlienInfo.UserName := UserList.Selected.Caption;
    AlienInfo.CompName := UserList.Selected.SubItems[0];
    id := StrToInt(UserList.Selected.SubItems[1]);

    s:=s + Char(id div 256)+
           Char(id mod 256);
    ClientSocket1.Socket.SendBuf(s[1],length(s));
  end
  else
      ShowMessage('�������� ������������!');
end;

procedure TMainForm.CoolTrayIconMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  BalloonMessage: string;
  AllMes, ReadMes: integer;
  i: integer;
begin
  ReadMes:=0;
  AllMes:=MessagesListView.Items.Count;
  for i:=0 to AllMes-1 do
      if(MessagesListView.Items[i].Checked)then ReadMes:=ReadMes+1;
  BalloonMessage:='����������� : '+IntToStr(ReadMes)
  +#13#10+'������������� : '+IntToStr(AllMes-ReadMes)+#13#10+
  '����� : '+IntToStr(AllMes);
  CoolTrayIcon.Hint:=ClientProperties.Version+#13#10+BalloonMessage;
end;

procedure TMainForm.ReconnectTimerTimer(Sender: TObject);
begin
  ReconnectTimer.Enabled := False;
  ConDiscon.Execute;
  if SpeekerSettings.Debug then
          LogVariable('Reconnect timer ', 'timer off and condiscon execute');
end;

procedure TMainForm.N3Click(Sender: TObject);
var
  tmpListItem: TListItem;
  ChatText: String;
begin
  if(FileExists(SpeekerSettings.UserAppdataDir+'\LastChat.txt'))then
      begin
          with TStringList.create do
            try
              LoadFromFile(SpeekerSettings.UserAppdataDir+'\LastChat.txt');
              ChatText:=text;
            finally
              Free;             
            end;

          with MessagesListView do
          begin
            tmpListItem := Items.Add;
            tmpListItem.Caption := 'NA';
            tmpListItem.SubItems.Add('1');
            tmpListItem.SubItems.Add('0');
            tmpListItem.SubItems.Add('CHR');
            tmpListItem.SubItems.Add(ChatText);
            tmpListItem.SubItems.Add(TimeToStr(Time));
            tmpListItem.SubItems.Add(DateToStr(Date));
            tmpListItem.SubItems.Add('��������� ');
            tmpListItem.SubItems.Add('���');
          end;

      if(MessagesListView.Items.Count=1)then
          if(MainForm.Visible)then
            begin
              MessagesListView.Items[0].Checked:=true;
            end
          else
            begin
              MessagesListView.Items[0].Checked:=false;
            end;
       if(MessagesListView.Items.Count>0)then
          MessagesListView.Items[MessagesListView.Items.Count-1].Selected:=true;

          EnDisButtons.Execute;
      end
  else
    ShowMessage('������ ���������� ���� �����������.');

end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  IgnorelistForm.Show;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  SentMesForm.Show;
end;

procedure TMainForm.MutePMUClick(Sender: TObject);
var
  i: integer;
begin
  MutePMU.Checked:=not(MutePMU.Checked);
  if(MutePMU.Checked)then // ���� ����� ��������, �� �������� ����� � ���������
    begin
      ClientProperties.IgnoreList.Items.Add(UserList.Selected.Caption+UserList.Selected.SubItems[0]);
      UserList.Selected.StateIndex:=6;
    end
  else
    begin
      for i:=0 to ClientProperties.IgnoreList.Items.Count-1 do
        if(ClientProperties.IgnoreList.Items[i]=
           UserList.Selected.Caption+UserList.Selected.SubItems[0])then
          begin
              ClientProperties.IgnoreList.Items.Delete(i);
              UserList.Selected.StateIndex:=1;
              break;
          end;
    end;
  ClientProperties.IgnoreList.Items.SaveToFile(SpeekerSettings.UserAppdataDir + '\Ignorlist.txt');
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
  AboutForm.Show;
end;

// Send "Ping" every 2 minutes
procedure TMainForm.PilingatorTimer(Sender: TObject);
var
  s: String;
begin
  if noPong then
    begin
      if SpeekerSettings.Debug then
          LogVariable('Pilingator ', 'Reconnect');
      Reconnect;
    end
  else
    begin
      s := #0#0#1#3;
      ClientSocket1.Socket.SendBuf(s[1],length(s));
      noPong := True;
      if SpeekerSettings.Debug then
          LogVariable('Pilingator ', 'Send Ping?');
    end;
end;

// Enable\Disable ToolButtons when receive or delete messages
procedure TMainForm.EnDisButtonsExecute(Sender: TObject);
begin
  //SetMemoFont;
  if MessagesListView.Selected <> nil then
    begin
      if MessagesListView.Items.Count=0 then
        begin
          ReplyAuthorTB.Enabled         := false;
          ReplyGroupTB.Enabled          := false;
          FirsmesToolButton.Enabled     := false;
          BackToolButton.Enabled        := false;
          ForwardToolButton.Enabled     := false;
          LastmesToolButton.Enabled     := false;
          DelcurmesToolButton.Enabled   := false;
          DelchmesToolButton.Enabled    := false;
          DelallmesToolButton.Enabled   := false;

          WhomImage.Picture := nil;
        end;
      if MessagesListView.Items.Count=1 then
        begin
          ReplyAuthorTB.Enabled         := true;
          ReplyGroupTB.Enabled          := true;
          FirsmesToolButton.Enabled     := false;
          BackToolButton.Enabled        := false;
          ForwardToolButton.Enabled     := false;
          LastmesToolButton.Enabled     := false;
          DelcurmesToolButton.Enabled   := true;
          DelchmesToolButton.Enabled    := true;
          DelallmesToolButton.Enabled   := true;
        end;
      if MessagesListView.Items.Count=2 then
        begin
          ReplyAuthorTB.Enabled         := true;
          ReplyGroupTB.Enabled          := true;
          DelcurmesToolButton.Enabled   := true;
          DelchmesToolButton.Enabled    := true;
          DelallmesToolButton.Enabled   := true;

          if MessagesListView.Selected.Index=0 then
            begin
              FirsmesToolButton.Enabled     := false;
              BackToolButton.Enabled        := false;
              ForwardToolButton.Enabled     := true;
              LastmesToolButton.Enabled     := true;
            end
          else
            begin
              FirsmesToolButton.Enabled     := true;
              BackToolButton.Enabled        := true;
              ForwardToolButton.Enabled     := false;
              LastmesToolButton.Enabled     := false;
            end;
        end;
      if MessagesListView.Items.Count>2 then
        begin
          ReplyAuthorTB.Enabled         := true;
          ReplyGroupTB.Enabled          := true;
          DelcurmesToolButton.Enabled   := true;
          DelchmesToolButton.Enabled    := true;
          DelallmesToolButton.Enabled   := true;

          if MessagesListView.Selected.Index=0 then
            begin
              FirsmesToolButton.Enabled     := false;
              BackToolButton.Enabled        := false;
              ForwardToolButton.Enabled     := true;
              LastmesToolButton.Enabled     := true;
            end;

          if MessagesListView.Selected.Index=MessagesListView.Items.Count-1 then
            begin
              FirsmesToolButton.Enabled     := true;
              BackToolButton.Enabled        := true;
              ForwardToolButton.Enabled     := false;
              LastmesToolButton.Enabled     := false;
            end;

          if (MessagesListView.Selected.Index>0) and
             (MessagesListView.Selected.Index<MessagesListView.Items.Count-1) then
            begin
              FirsmesToolButton.Enabled     := true;
              BackToolButton.Enabled        := true;
              ForwardToolButton.Enabled     := true;
              LastmesToolButton.Enabled     := true;
            end;
        end;
    end
  else
    begin
    // if selected = nil
      ReplyAuthorTB.Enabled         := false;
      ReplyGroupTB.Enabled          := false;
      FirsmesToolButton.Enabled     := false;
      BackToolButton.Enabled        := false;
      ForwardToolButton.Enabled     := false;
      LastmesToolButton.Enabled     := false;
      DelcurmesToolButton.Enabled   := false;
      DelchmesToolButton.Enabled    := false;
      DelallmesToolButton.Enabled   := false;

      WhomImage.Picture := nil;
    end;
end;

procedure TMainForm.PingMSTimerTimer(Sender: TObject);
begin
  PingMSClientSocket.Socket.Disconnect(PingMSClientSocket.Socket.SocketHandle);
  PingMSClientSocket.Open;
  if SpeekerSettings.Debug then
          LogVariable('Ping main server timer ', 'Try to connect...');
end;

procedure TMainForm.PingMSClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  PingMSTimer.Enabled := false;
  Socket.Close;
  ClientSocket1.Socket.Close;
  if SpeekerSettings.Debug then
      LogVariable('Ping MS server connect', 'timer off, sockets close');
end;

procedure TMainForm.PingMSClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  PingMSClientSocket.Socket.Disconnect(PingMSClientSocket.Socket.SocketHandle);
  //PingMSClientSocket.Close;

  if SpeekerSettings.Debug then
      LogVariable('Ping main server', 'socket error');
end;

procedure TMainForm.CheckSelectedExecute(Sender: TObject);
begin
  if MessagesListView.Selected <> nil then
    MessagesListView.Items.Item[MessagesListView.Selected.Index].Checked:=true;
end;

procedure TMainForm.N16Click(Sender: TObject);
var
  wnd:HWND;
begin
  ShellExecute(wnd, 'open', PAnsiChar('Help/index.html'), NIL, NIL, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.DebugActionExecute(Sender: TObject);
begin
  if DebugForm.Visible then
    DebugForm.Close
  else
    DebugForm.Show;
end;

procedure TMainForm.OptionsTPMClick(Sender: TObject);
begin
  OptionsForm.Show;
end;

procedure TMainForm.MessagesListViewClick(Sender: TObject);
begin
  if MessagesListView.Selected = nil then
    begin
      MessageMemo.Clear;
      WhomEdit.Text:='';
      if MessagesListView.Items.Count > 0 then
        MesnumberLabel.Caption:='�� �������';
    end;
  EnDisButtons.Execute;
end;

procedure TMainForm.MainMenu1Change(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  SkinMgrMenuitem.Enabled := sSkinManager1.Active;
end;

procedure TMainForm.sSkinManager1AfterChange(Sender: TObject);
var
  sIniFile: TIniFile;
begin
// Save to Ini
    if(not(DirectoryExists(MainForm.SpeekerSettings.UserAppdataDir)))then
        CreateDir(MainForm.SpeekerSettings.UserAppdataDir);

    sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');
    sIniFile.WriteString( 'Programm', 'SkinName', sSkinManager1.SkinName);
    sIniFile.Free;
end;

procedure TMainForm.OpenSkinManagerExecute(Sender: TObject);
var
  SkinName, Skindir : string;
begin
  SkinName := 'Office2007 Blue.asz';
  SkinDir := ExtractFilePath(GetCurrentDir() + '\Skins\');
  if SelectSkin(SkinName, SkinDir, stPacked) then begin
    sSkinManager1.SkinName := SkinName;
    sSkinManager1.UpdateSkin;
  end;
end;

procedure TMainForm.InsertSmiles;
var
  bmp:TBitmap;
  i, startpos, Position, endpos: integer;
  SearchText: String;
const
  SmilesArray: array[0..6] of string = (':)', ':(', ':|', ':!', '*narik*', '*wall*', '*crazy*');
begin

  //bmp.Transparent := True;
  //bmp.TransParentColor := bmp.canvas.pixels[50,50];

  for i:=0 to 6 do
    begin
      try
        bmp:=TBitmap.Create;
        SmilesImageList.GetBitmap(i, bmp);

        startpos := 0;
        SearchText := SmilesArray[i];

        with MessageMemo do
          begin
            endpos := Length(MessageMemo.Text);
            Lines.BeginUpdate;

            while FindText(SearchText, startpos, endpos, [stMatchCase])<>-1 do
              begin
                endpos   := Length(MessageMemo.Text) - startpos;
                Position := FindText(SearchText, startpos, endpos, [stMatchCase]);
                Inc(startpos, Length(SearchText));
                SetFocus;
                SelStart  := Position;
                SelLength := Length(SearchText);
                MessageMemo.clearselection;
                SelText := '';
                InsertBitmapToRE(MessageMemo.Handle,bmp.Handle);
                bmp.FreeImage;
              end;

            Lines.EndUpdate;
          end;
       finally
        bmp.Free;
       end;
    end;

end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  JumpUp.ShortCut               := TextToShortCut('Ctrl+Right');
  JumpDown.ShortCut             := TextToShortCut('Ctrl+Left');
  DeleteCurrentMessage.ShortCut := TextToShortCut('Ctrl+Del');
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  JumpUp.ShortCut               := TextToShortCut('(None)');
  JumpDown.ShortCut             := TextToShortCut('(None)');
  DeleteCurrentMessage.ShortCut := TextToShortCut('(None)');
end;

procedure TMainForm.UpdateActExecute(Sender: TObject);
begin
  if SpeekerSettings.OptUpdate then
    UpdateClientSocket.Active := true;
end;

procedure TMainForm.UpdateClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  UpdateForm.UpdateText.Text := UpdateForm.UpdateText.Text + Socket.ReceiveText;
end;

procedure TMainForm.UpdateClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
begin
  i := Pos(ClientProperties.Version, UpdateForm.UpdateText.Text);

  UpdateForm.sWebLabel1.Caption := UpdateForm.UpdateText.Lines[UpdateForm.UpdateText.Lines.Count-1];
  UpdateForm.sWebLabel1.URL := UpdateForm.UpdateText.Lines[UpdateForm.UpdateText.Lines.Count-1];

  if i <> 1 then
    begin
      UpdateForm.UpdateText.Text := Copy(UpdateForm.UpdateText.Text, 1, i-1);
      UpdateForm.Show;
    end
  else
    begin
      if UpdateClientSocket.Tag = 1 then
        begin
          UpdateClientSocket.Tag := 0;
          Application.MessageBox('�� ����������� ����� ��������� ������ BlastCore Sender',
            '���������� ����������.', MB_OK)
        end;
    end;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  UpdateClientSocket.Active := true;
  UpdateClientSocket.Tag := 1;
end;

procedure TMainForm.UpdateClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

//return everything before the first #0 ('\0' in C)
function TMainForm.ExtractPlainText(Source: string): String;
begin
  if Pos(#0, Source) > 0 then
    Result := Copy(Source, 1, Pos(#0, Source) - 1)
  else
    Result := Source;
end;

//source:='plain text' + #0'{\rtf part...}'+#0'some binary junk'
//return the '{\rtf' part or the plain text part if no RTF
function TMainForm.ExtractRTF(Source: string): String;
var
  fz,rp: Integer;
begin
  fz := Pos(#0, Source);        //first ASCII zero in string
  rp := Pos(#0'{\rtf', Source); //RTF signature position

  //the entire message is old good plain text
  if fz = 0 then
  begin
    Result := Source;
    Exit;
  end;

  //there is ASCIIZ but that is non-RTF junk, return plain text
  if (fz > 0) and (fz <> rp) then
  begin
    Result := Copy(Source, 1, fz - 1);
    Exit;
  end;

  //at this point, RTF part is present, delete everything before,
  //then task for any trailing garbage will be as for plain text
  Delete(Source, 1, rp);
  Result := ExtractPlainText(Source);
end;

procedure TMainForm.ExtractFile(Source: string);
var
fp,FileNameLen,i:integer;
filelen:longint;
filename:string;
tmpFile,debug:file;
tStr:TStringStream;
mStr:TMemoryStream;
begin
{assignfile(debug,'debug.txt');
ReWrite(debug,1);
Write(debug,Source);
CloseFile(tmpFile);
    fp := Pos(#0'FILE', Source); //������ ������ � ������
    if fp>0 then
      begin
        fp:=fp+5;// ���������� #0FILE
        fp:=fp+4;//��������� ����� ����������� ����� ����-���
        FileNameLen:= ord(fp);
        fp:=fp+1;  //������ ����� �����
        filename:=copy(Source, fp, ord(Source[FileNameLen]));//�������� ��� �����
        fp:=fp+FileNameLen;
        Delete(Source, 1, fp);
        if SpeekerSettings.Debug then
              LogVariable('source', source);
        filelen:=length(source);
        while(FileExists(filename))do
        begin
          i:=i+1;
          filename:=inttostr(i)+filename;
        end;
     }
end;

function TMainForm.ExtractPlainTextFromSelected: String;
begin
  Result := ExtractPlainText(MessagesListView.Selected.SubItems[3]);
end;

procedure TMainForm.OnOffPriorityExecute(Sender: TObject);
begin
     if  PriorityTB.Down then
        PriorityTB.Hint :='��������� ��� ���������'
     else
        PriorityTB.Hint := '��������� ��������� ������ � ������� �����������';
end;

end.
