unit OptionsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, StdCtrls, ExtCtrls, Buttons, ActnList,
  IniFiles, MMSystem, Registry, PngImage1;

type
  TOptionsForm = class(TForm)
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    GroupBox2: TGroupBox;
    StartMinChkBox: TCheckBox;
    MinSTChkBox: TCheckBox;
    WinpopupChkBox: TCheckBox;
    AutorunChkBox: TCheckBox;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    LabeledEdit7: TLabeledEdit;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Button4: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    ActionList1: TActionList;
    SaveOptions: TAction;
    Button5: TButton;
    Label3: TLabel;
    LabeledEdit8: TEdit;
    Label4: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    LabeledEdit2: TEdit;
    RoomCmbBox: TComboBox;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SaveOptionsExecute(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsForm: TOptionsForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TOptionsForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TOptionsForm.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage:=TabSheet1;

  // IPs
  LabeledEdit1.Text := MainForm.SpeekerSettings.MainServerIP;
  LabeledEdit2.Text := MainForm.SpeekerSettings.AltServerIP;

  // Sounds
  LabeledEdit4.Text := MainForm.SpeekerSettings.PrivateSound;
  LabeledEdit5.Text := MainForm.SpeekerSettings.GroupSound;
  LabeledEdit6.Text := MainForm.SpeekerSettings.ChatSound;

  // User Data
  LabeledEdit7.Text := MainForm.SpeekerSettings.UserName;
  LabeledEdit8.Text := MainForm.SpeekerSettings.CompName;
  if MainForm.SpeekerSettings.Faculty then
    ComboBox1.ItemIndex:= 0
  else
    ComboBox1.ItemIndex:= 1;
  if((StrToInt(MainForm.SpeekerSettings.Room)>=0)and
     (StrToInt(MainForm.SpeekerSettings.Room)<=RoomCmbBox.Items.Count-1))then
        RoomCmbBox.ItemIndex:=StrToInt(MainForm.SpeekerSettings.Room)
  else
        RoomCmbBox.ItemIndex:=0;

  Memo1.Text:=MainForm.SpeekerSettings.Info;
  StartMinChkBox.Checked  := MainForm.SpeekerSettings.OptStartmin;
  AutorunChkBox.Checked   := MainForm.SpeekerSettings.OptAutostart;
  WinpopupChkBox.Checked  := MainForm.SpeekerSettings.OptPopup;
  MinSTChkBox.Checked     := MainForm.SpeekerSettings.OptDelastmin;
end;

procedure TOptionsForm.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog1.Execute;
  LabeledEdit4.Text:= OpenDialog1.FileName;
end;

procedure TOptionsForm.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.Execute;
  LabeledEdit5.Text:= OpenDialog1.FileName;
end;

procedure TOptionsForm.SpeedButton3Click(Sender: TObject);
begin
  OpenDialog1.Execute;
  LabeledEdit6.Text:= OpenDialog1.FileName;
end;

procedure TOptionsForm.SpeedButton7Click(Sender: TObject);
begin
  LabeledEdit4.Text:='';
end;

procedure TOptionsForm.SpeedButton8Click(Sender: TObject);
begin
  LabeledEdit5.Text:='';
end;

procedure TOptionsForm.SpeedButton9Click(Sender: TObject);
begin
  LabeledEdit6.Text:='';
end;

procedure TOptionsForm.SaveOptionsExecute(Sender: TObject);
var
  sIniFile: TIniFile;
  Registry: TRegistry;
  s, ns, room, info: String;
  j: integer;
begin
// Save to varibles
  MainForm.SpeekerSettings.OptStartmin  := StartMinChkBox.Checked;
  MainForm.SpeekerSettings.OptAutostart := AutorunChkBox.Checked;
  MainForm.SpeekerSettings.OptPopup     := WinpopupChkBox.Checked;
  MainForm.SpeekerSettings.OptDelastmin := MinSTChkBox.Checked;

  Registry := TRegistry.Create;
  Registry.RootKey := hkey_current_user;
  Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true);
  if(AutorunChkBox.Checked)then
      Registry.WriteString('BlastCore', Application.ExeName)
  else
      Registry.DeleteValue('BlastCore');

  Registry.CloseKey;
  Registry.Free;

    // Sounds
  MainForm.SpeekerSettings.PrivateSound := LabeledEdit4.Text;
  MainForm.SpeekerSettings.GroupSound   := LabeledEdit5.Text;
  MainForm.SpeekerSettings.ChatSound    := LabeledEdit6.Text;

    // User Data
  MainForm.SpeekerSettings.UserName := LabeledEdit7.Text;
//  MainForm.SpeekerSettings.CompName := LabeledEdit8.Text;
  if(ComboBox1.ItemIndex=0)then MainForm.SpeekerSettings.Faculty := true
  else MainForm.SpeekerSettings.Faculty := false;
  MainForm.SpeekerSettings.Room := IntToStr(RoomCmbBox.ItemIndex);
  //SetLength(MainForm.SpeekerSettings.Room, 5);
  MainForm.SpeekerSettings.Info := Memo1.Text;

  // Send Info to Server (It's no cool do all this action without diff check)
  room:=OptionsForm.RoomCmbBox.Items[StrToInt(MainForm.SpeekerSettings.Room)];
  info:=MainForm.ClientProperties.Version+#13#10+MainForm.SpeekerSettings.Info;
  ns:= Char(Length(info))+info;
  ns:= room+ns+#98;//Версия
  if(MainForm.SpeekerSettings.Faculty)then
    ns:= #4+#1+ns
  else
    ns:= #4+#2+ns;
  j:=length(ns);
  ns:=#0+Char(j div 256)+Char(j mod 256)+ns;
  MainForm.ClientSocket1.Socket.SendBuf(ns[1],length(ns));

// Save to Ini
    if(not(DirectoryExists(MainForm.SpeekerSettings.UserAppdataDir)))then
        CreateDir(MainForm.SpeekerSettings.UserAppdataDir);

    sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');

    sIniFile.WriteString( 'User', 'UserName', LabeledEdit7.Text);
    sIniFile.WriteString( 'User', 'Room',     MainForm.SpeekerSettings.Room);
    sIniFile.WriteString( 'User', 'Info',     '"'+Memo1.Text+'"');
    sIniFile.WriteBool( 'User', 'Faculty',  MainForm.SpeekerSettings.Faculty);

    sIniFile.WriteString( 'Sounds', 'PrivateSound', LabeledEdit4.Text);
    sIniFile.WriteString( 'Sounds', 'GroupSound',   LabeledEdit5.Text);
    sIniFile.WriteString( 'Sounds', 'ChatSound',    LabeledEdit6.Text);

    sIniFile.WriteBool( 'Options', 'StartMinimized',  StartMinChkBox.Checked);
    sIniFile.WriteBool( 'Options', 'AutoStart',       AutorunChkBox.Checked);
    sIniFile.WriteBool( 'Options', 'WinPopup',        WinpopupChkBox.Checked);
    sIniFile.WriteBool( 'Options', 'MinimizeWhenDelast',  MinSTChkBox.Checked);
    sIniFile.Free;

end;

procedure TOptionsForm.Button3Click(Sender: TObject);
begin
    SaveOptions.Execute;
end;

procedure TOptionsForm.Button1Click(Sender: TObject);
begin
    SaveOptions.Execute;
    Close;
end;

procedure TOptionsForm.SpeedButton4Click(Sender: TObject);
begin
    PlaySound(PChar(LabeledEdit4.Text),0,SND_FILENAME);
end;

procedure TOptionsForm.SpeedButton5Click(Sender: TObject);
begin
    PlaySound(PChar(LabeledEdit5.Text),0,SND_FILENAME);
end;

procedure TOptionsForm.SpeedButton6Click(Sender: TObject);
begin
    PlaySound(PChar(LabeledEdit6.Text),0,SND_FILENAME);
end;

procedure TOptionsForm.Button5Click(Sender: TObject);
var
  sIniFile: TIniFile;
begin
  // IPs
  if(LabeledEdit1.Text<>LabeledEdit2.Text)then
    begin
      MainForm.SpeekerSettings.MainServerIP := LabeledEdit1.Text;
      MainForm.SpeekerSettings.AltServerIP  := LabeledEdit2.Text;
      sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');
      sIniFile.WriteString( 'Servers', 'MainServerIP',    LabeledEdit1.Text);
      sIniFile.WriteString( 'Servers', 'AltServerIP' ,    LabeledEdit2.Text);
      sIniFile.Free;
      MainForm.Reconnect;
    end
  else
    ShowMessage('Адреса основного и альтернативного сервера должны быть разными!');
end;

procedure TOptionsForm.Button4Click(Sender: TObject);
var
  sIniFile: TIniFile;
  toSend: string;
begin
  sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');
  sIniFile.WriteString( 'User', 'UserName', LabeledEdit7.Text);
  sIniFile.Free;
  toSend := #14 + Char(Length(LabeledEdit7.Text))+LabeledEdit7.Text;
  toSend := #0+Char(Length(toSend) div 256)+Char(Length(toSend) mod 256)+toSend;
  MainForm.ClientSocket1.Socket.SendBuf(toSend[1], Length(toSend));
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
var
  i, j: integer;
begin
  RoomCmbBox.Items.Add('     ');
  for i:=1 to 5 do
      for j:=1 to 38 do
          RoomCmbBox.Items.Add(IntToStr(i*100+j)+'  ');
  RoomCmbBox.Items.Add('304-а');
  RoomCmbBox.Items.Add('404-а');
  RoomCmbBox.Items.Add('204-а');
  RoomCmbBox.Items.Add('308-а');
  RoomCmbBox.Items.Add('308-б');
  RoomCmbBox.Items.Add('408-а');
  RoomCmbBox.Items.Add('408-б');
  RoomCmbBox.Items.Add('508-а');
  RoomCmbBox.Items.Add('508-б');
end;

end.
