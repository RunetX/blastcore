unit OptionsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ToolWin, ComCtrls, StdCtrls, ExtCtrls, Buttons, ActnList, IniFiles, 
  MMSystem, Registry, sDialogs, sMemo, sComboBox, sCheckBox,
  sEdit, sButton, sLabel, sSpeedButton, sGroupBox, sPageControl, sFontCtrls,
  sTrackBar, sPanel, sColorSelect, sBitBtn, acPNG;

type
  TOptionsForm = class(TForm)
    OpenDialog1: TsOpenDialog;
    PageControl1: TsPageControl;
    TabSheet1: TsTabSheet;
    GroupBox1: TsGroupBox;
    LabeledEdit1: TLabeledEdit;
    GroupBox2: TsGroupBox;
    StartMinChkBox: TsCheckBox;
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
    SpeedButton7: TsSpeedButton;
    SpeedButton8: TsSpeedButton;
    SpeedButton9: TsSpeedButton;
    ActionList1: TActionList;
    SaveOptions: TAction;
    Label3: TsLabel;
    LabeledEdit8: TsEdit;
    Label4: TsLabel;
    Image1: TImage;
    Image2: TImage;
    LabeledEdit2: TsEdit;
    RoomCmbBox: TsComboBox;
    Label5: TsLabel;
    sTabSheet1: TsTabSheet;
    sFontComboBox1: TsFontComboBox;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    sLabelFX3: TsLabelFX;
    sTrackBar1: TsTrackBar;
    sColorSelect1: TsColorSelect;
    FontSetsMemo: TMemo;
    FontSetsResetBtn: TsButton;
    sGroupBox1: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    sGroupBox2: TsGroupBox;
    SoundsEnableChkBox: TsCheckBox;
    SkinOnChkBox: TsCheckBox;
    sGroupBox3: TsGroupBox;
    ShowPanelChkBox: TsCheckBox;
    WinpopupChkBox: TsCheckBox;
    MinSTChkBox: TsCheckBox;
    JmpownmesChkBox: TsCheckBox;
    BalloonTipChkBox: TsCheckBox;
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
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sFontComboBox1Change(Sender: TObject);
    procedure sTrackBar1Change(Sender: TObject);
    procedure sColorSelect1Change(Sender: TObject);
    procedure sCheckBox1Click(Sender: TObject);
    procedure sCheckBox2Click(Sender: TObject);
    procedure sCheckBox3Click(Sender: TObject);
    procedure sCheckBox4Click(Sender: TObject);
    procedure FontSetsResetBtnClick(Sender: TObject);
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

function ValidateUName(UName: String): Boolean;
Const
  A = ['a'..'z','A'..'Z','0'..'9','а'..'п','ё','Ё','р'..'я','А'..'Я'];
  B = A + ['!'..'~',chr(128)..chr(255)] - ['<','>','[','\',']'];
var
  i: Integer;
begin
  result := (length(UName) > 0) and (UName[1] in A);
  for i:=2 to length(UName) do  {Проверка ввода строки на недопустимые символы}
   begin
     if not (UName[i] in B) then
      begin
       result := false;
       exit;
      end;
   end;
end;

procedure TOptionsForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TOptionsForm.FormShow(Sender: TObject);
var
  i: Integer;
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
  SkinOnChkBox.Checked       := MainForm.sSkinManager1.Active;
  JmpownmesChkBox.Checked    := MainForm.SpeekerSettings.OptJumpOwnMessage;

  for i:=0 to sFontComboBox1.Items.Count-1 do
    begin
      if sFontComboBox1.Items[i] = MainForm.SpeekerSettings.FontName then break;
    end;

  sFontComboBox1.ItemIndex := i;

  sColorSelect1.ColorValue := MainForm.SpeekerSettings.FontColor;
  sTrackBar1.Position := MainForm.SpeekerSettings.FontSize;

  sCheckBox1.Checked := MainForm.SpeekerSettings.FontBold;
  sCheckBox2.Checked := MainForm.SpeekerSettings.FontItalic;
  sCheckBox3.Checked := MainForm.SpeekerSettings.FontUnderline;
  sCheckBox4.Checked := MainForm.SpeekerSettings.FontStrikeOut;

  FontSetsMemo.Font.Color := MainForm.SpeekerSettings.FontColor;
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
if ValidateUName(LabeledEdit7.Text) then
begin
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
  // Jump when receive own message
  MainForm.SpeekerSettings.OptJumpOwnMessage := JmpownmesChkBox.Checked;

  if MainForm.sSkinManager1.Active <> SkinOnChkBox.Checked then
    MainForm.sSkinManager1.Active := SkinOnChkBox.Checked;

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
  info:=MainForm.SpeekerSettings.Info;
  ns:= Char(Length(info))+info;
  ns:= room+ns+#100;//Версия
  if(MainForm.SpeekerSettings.Faculty)then
    ns:= #4+#1+ns
  else
    ns:= #4+#2+ns;
  j:=length(ns);
  ns:=#0+Char(j div 256)+Char(j mod 256)+ns;
  MainForm.ClientSocket1.Socket.SendBuf(ns[1],length(ns));

  MainForm.MessageMemo.Font.Color := FontSetsMemo.Font.Color;
  MainForm.MessageMemo.Font.Size  := FontSetsMemo.Font.Size;
  MainForm.MessageMemo.Font.Name  := FontSetsMemo.Font.Name;
  MainForm.MessageMemo.Font.Style := FontSetsMemo.Font.Style;

  MainForm.SpeekerSettings.FontColor := FontSetsMemo.Font.Color;
  MainForm.SpeekerSettings.FontSize  := FontSetsMemo.Font.Size;
  MainForm.SpeekerSettings.FontName  := FontSetsMemo.Font.Name;

// Save to Ini
    if(not(DirectoryExists(MainForm.SpeekerSettings.UserAppdataDir)))then
        CreateDir(MainForm.SpeekerSettings.UserAppdataDir);

    sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');

    sIniFile.WriteBool( 'Programm', 'ShowPanel', ShowPanelChkBox.Checked);
    sIniFile.WriteBool( 'Programm', 'Skinned',   SkinOnChkBox.Checked);

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
    sIniFile.WriteBool( 'Options', 'JumpOwnMessages',  JmpownmesChkBox.Checked);

    sIniFile.WriteString( 'Servers', 'MainServerIP',    LabeledEdit1.Text);
    sIniFile.WriteString( 'Servers', 'AltServerIP' ,    LabeledEdit2.Text);

    sIniFile.WriteInteger( 'Font', 'Color' ,    FontSetsMemo.Font.Color);
    sIniFile.WriteInteger( 'Font', 'Size' ,     FontSetsMemo.Font.Size);
    sIniFile.WriteString(  'Font', 'Name' ,     FontSetsMemo.Font.Name);

    if fsBold in FontSetsMemo.Font.Style then
      begin
        sIniFile.WriteBool( 'Font', 'Bold', true);
        MainForm.SpeekerSettings.FontBold := true;
      end
    else
      begin
        sIniFile.WriteBool( 'Font', 'Bold', false);
        MainForm.SpeekerSettings.FontBold := false;
      end;

    if fsItalic in FontSetsMemo.Font.Style then
      begin
        sIniFile.WriteBool( 'Font', 'Italic', true);
        MainForm.SpeekerSettings.FontItalic := true;
      end
    else
      begin
        sIniFile.WriteBool( 'Font', 'Italic', false);
        MainForm.SpeekerSettings.FontItalic := false;
      end;

    if fsUnderline in FontSetsMemo.Font.Style then
      begin
        sIniFile.WriteBool( 'Font', 'Underline', true);
        MainForm.SpeekerSettings.FontUnderline := true;
      end
    else
      begin
        sIniFile.WriteBool( 'Font', 'Underline', false);
        MainForm.SpeekerSettings.FontUnderline := false;
      end;

    if fsStrikeOut in FontSetsMemo.Font.Style then
      begin
        sIniFile.WriteBool( 'Font', 'StrikeOut', true);
        MainForm.SpeekerSettings.FontStrikeOut := true;
      end
    else
      begin
        sIniFile.WriteBool( 'Font', 'StrikeOut', false);
        MainForm.SpeekerSettings.FontStrikeOut := false;
      end;

    sIniFile.Free;

    if(MainForm.SpeekerSettings.MainServerIP <> LabeledEdit1.Text) or
    (MainForm.SpeekerSettings.AltServerIP  <> LabeledEdit2.Text) then
    begin
      if(LabeledEdit1.Text<>LabeledEdit2.Text)then
        begin
          MainForm.SpeekerSettings.MainServerIP := LabeledEdit1.Text;
          MainForm.SpeekerSettings.AltServerIP  := LabeledEdit2.Text;
          MainForm.Reconnect;
        end
      else
        ShowMessage('Адреса основного и альтернативного сервера должны быть разными!');
    end;
end
else
   ShowMessage('Новое имя содержит недопустимые символы!');
end;

procedure TOptionsForm.Button3Click(Sender: TObject);
begin
    SaveOptions.Execute;
end;

procedure TOptionsForm.Button1Click(Sender: TObject);
begin
    SaveOptions.Execute;
    if ValidateUName(LabeledEdit7.Text) then Close;
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

procedure TOptionsForm.Button4Click(Sender: TObject);
var
  sIniFile: TIniFile;
  toSend: string;
begin
  if ValidateUName(LabeledEdit7.Text) then
    begin
      sIniFile := TIniFile.Create(MainForm.SpeekerSettings.UserAppdataDir + '\Settings.ini');
      sIniFile.WriteString( 'User', 'UserName', LabeledEdit7.Text);
      sIniFile.Free;
      toSend := #14 + Char(Length(LabeledEdit7.Text))+LabeledEdit7.Text;
      toSend := #0+Char(Length(toSend) div 256)+Char(Length(toSend) mod 256)+toSend;
      MainForm.ClientSocket1.Socket.SendBuf(toSend[1], Length(toSend));
    end
  else
    ShowMessage('Новое имя содержит недопустимые символы!');  
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

procedure TOptionsForm.sFontComboBox1Change(Sender: TObject);
begin
  FontSetsMemo.Font.Name := sFontComboBox1.Items[sFontComboBox1.ItemIndex];
end;

procedure TOptionsForm.sTrackBar1Change(Sender: TObject);
begin
  FontSetsMemo.Font.Size := sTrackBar1.Position;
end;

procedure TOptionsForm.sColorSelect1Change(Sender: TObject);
begin
  FontSetsMemo.Font.Color := sColorSelect1.ColorValue;
end;

procedure TOptionsForm.sCheckBox1Click(Sender: TObject);
begin
  if sCheckBox1.Checked then
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style + [fsBold]
  else
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style - [fsBold];
end;

procedure TOptionsForm.sCheckBox2Click(Sender: TObject);
begin
  if sCheckBox2.Checked then
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style + [fsItalic]
  else
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style - [fsItalic];
end;

procedure TOptionsForm.sCheckBox3Click(Sender: TObject);
begin
  if sCheckBox3.Checked then
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style + [fsUnderline]
  else
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style - [fsUnderline];
end;

procedure TOptionsForm.sCheckBox4Click(Sender: TObject);
begin
  if sCheckBox4.Checked then
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style + [fsStrikeOut]
  else
    FontSetsMemo.Font.Style := FontSetsMemo.Font.Style - [fsStrikeOut];
end;

procedure TOptionsForm.FontSetsResetBtnClick(Sender: TObject);
var
  i: Integer;
begin

  for i:=0 to sFontComboBox1.Items.Count-1 do
    begin
      if sFontComboBox1.Items[i] = 'MS Sans Serif' then break;
    end;

  sFontComboBox1.ItemIndex := i;

  sColorSelect1.ColorValue := clWindowText;
  sTrackBar1.Position := 8;

  sCheckBox1.Checked := false;
  sCheckBox2.Checked := false;
  sCheckBox3.Checked := false;
  sCheckBox4.Checked := false;

  FontSetsMemo.Font.Name  := 'MS Sans Serif';
  FontSetsMemo.Font.Color := clWindowText;
  FontSetsMemo.Font.Size  := 8;
  FontSetsMemo.Font.Style := [];

end;

end.
