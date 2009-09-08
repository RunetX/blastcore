unit OptionsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ToolWin, ComCtrls, StdCtrls, ExtCtrls, Buttons, ActnList, IniFiles, 
  MMSystem, Registry, sDialogs, sMemo, sComboBox, sCheckBox,
  sEdit, sButton, sLabel, sSpeedButton, sGroupBox, sPageControl;

type
  TOptionsForm = class(TForm)
    OpenDialog1: TsOpenDialog;
    PageControl1: TsPageControl;
    TabSheet1: TsTabSheet;
    GroupBox1: TsGroupBox;
    LabeledEdit1: TLabeledEdit;
    GroupBox2: TsGroupBox;
    StartMinChkBox: TsCheckBox;
    MinSTChkBox: TsCheckBox;
    WinpopupChkBox: TsCheckBox;
    AutorunChkBox: TsCheckBox;
    TabSheet2: TsTabSheet;
    GroupBox3: TsGroupBox;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    Button1: TsButton;
    Button2: TsButton;
    Button3: TsButton;
    SpeedButton1: TsSpeedButton;
    SpeedButton2: TsSpeedButton;
    SpeedButton3: TsSpeedButton;
    LabeledEdit7: TLabeledEdit;
    SpeedButton4: TsSpeedButton;
    SpeedButton5: TsSpeedButton;
    SpeedButton6: TsSpeedButton;
    ComboBox1: TsComboBox;
    Label1: TsLabel;
    Button4: TsButton;
    Memo1: TsMemo;
    Label2: TsLabel;
    ShowPanelChkBox: TsCheckBox;
    SoundsEnableChkBox: TsCheckBox;
    SpeedButton7: TsSpeedButton;
    SpeedButton8: TsSpeedButton;
    SpeedButton9: TsSpeedButton;
    ActionList1: TActionList;
    SaveOptions: TAction;
    Button5: TsButton;
    Label3: TsLabel;
    LabeledEdit8: TsEdit;
    Label4: TsLabel;
    Image1: TImage;
    Image2: TImage;
    LabeledEdit2: TsEdit;
    RoomCmbBox: TsComboBox;
    Label5: TsLabel;
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
  StartMinChkBox.Checked     := MainForm.SpeekerSettings.OptStartmin;
  AutorunChkBox.Checked      := MainForm.SpeekerSettings.OptAutostart;
  WinpopupChkBox.Checked     := MainForm.SpeekerSettings.OptPopup;
  MinSTChkBox.Checked        := MainForm.SpeekerSettings.OptDelastmin;
  SoundsEnableChkBox.Checked := MainForm.SpeekerSettings.OptEnablesounds;
  ShowPanelChkBox.Checked    := MainForm.SpeekerSettings.OptShowpanel;
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
  ns, room, info: String;
  j: integer;
begin
// Save to variables

  // Start minimized
  MainForm.SpeekerSettings.OptStartmin  := StartMinChkBox.Checked;
  // Start program when Windows starts
  MainForm.SpeekerSettings.OptAutostart := AutorunChkBox.Checked;
  // Pop up when receive message
  MainForm.SpeekerSettings.OptPopup     := WinpopupChkBox.Checked;
  // Hide program to systray when delete last message
  MainForm.SpeekerSettings.OptDelastmin := MinSTChkBox.Checked;
  // Show\Hide Messages Panel
  MainForm.SpeekerSettings.OptShowpanel := ShowPanelChkBox.Checked;
  // Enable\Disable sounds
  MainForm.SpeekerSettings.OptEnablesounds := SoundsEnableChkBox.Checked;

  if MainForm.SpeekerSettings.OptShowpanel then
        MainForm.DownPanel.Height := 150
  else
        MainForm.DownPanel.Height := 4;

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
  ns:= room+ns+#98;//������
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

    sIniFile.WriteBool( 'Programm', 'ShowPanel', ShowPanelChkBox.Checked);

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
    sIniFile.WriteBool( 'Options', 'EnableSounds',  SoundsEnableChkBox.Checked);

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

      if(not(DirectoryExists(MainForm.SpeekerSettings.UserAppdataDir)))then
        CreateDir(MainForm.SpeekerSettings.UserAppdataDir);

      sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');
      sIniFile.WriteString( 'Servers', 'MainServerIP',    LabeledEdit1.Text);
      sIniFile.WriteString( 'Servers', 'AltServerIP' ,    LabeledEdit2.Text);
      sIniFile.Free;
      MainForm.Reconnect;
    end
  else
    ShowMessage('������ ��������� � ��������������� ������� ������ ���� �������!');
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
  RoomCmbBox.Items.Add('304-�');
  RoomCmbBox.Items.Add('404-�');
  RoomCmbBox.Items.Add('204-�');
  RoomCmbBox.Items.Add('308-�');
  RoomCmbBox.Items.Add('308-�');
  RoomCmbBox.Items.Add('408-�');
  RoomCmbBox.Items.Add('408-�');
  RoomCmbBox.Items.Add('508-�');
  RoomCmbBox.Items.Add('508-�');
end;

end.