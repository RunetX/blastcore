unit IgnorlistUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ActnList, ExtCtrls, sAlphaListBox, sButton,
  sLabel, sSpeedButton;

type
  TIgnorelistForm = class(TForm)
    SaveILBtn: TsButton;
    SpeedButton1: TsSpeedButton;
    Userlist: TsListBox;
    IgnoreList: TsListBox;
    SpeedButton2: TsSpeedButton;
    Label1: TsLabel;
    Label2: TsLabel;
    SpeedButton3: TsSpeedButton;
    CancelBtn: TsButton;
    OKBtn: TsButton;
    ActionList1: TActionList;
    SaveIL: TAction;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure SaveILBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveILExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DeleteIgnored;
  end;

var
  IgnorelistForm: TIgnorelistForm;

implementation

uses ArchiverUnit;

{$R *.dfm}

procedure TIgnorelistForm.DeleteIgnored;
var
  i, j, ItemsCount: integer;
begin
  for i:=0 to IgnoreList.Items.Count-1 do
  begin
    //for j:=0 to Userlist.Items.Count-1 do
    ItemsCount := Userlist.Items.Count-1;
    j := 0;
    while j<=ItemsCount do
    begin
      if IgnoreList.Items[i]=Userlist.Items[j] then
      begin
        Userlist.Items.Delete(j);
        ItemsCount := ItemsCount - 1;
      end;
      j := j + 1;
    end;
  end;
end;

procedure TIgnorelistForm.FormShow(Sender: TObject);
var
  i: integer;
  //sPath: string[60];
begin
  for i:=2 to MainForm.Userlist.Items.Count-1 do
    Userlist.Items.Add(MainForm.Userlist.Items[i].Caption+
                       MainForm.Userlist.Items[i].SubItems[0]);
  for i:=0 to MainForm.ClientProperties.IgnoreList.Items.Count-1 do
    IgnoreList.Items.Add(MainForm.ClientProperties.IgnoreList.Items[i]);
  DeleteIgnored;
end;

procedure TIgnorelistForm.SaveILBtnClick(Sender: TObject);
begin
  SaveIL.Execute;
end;

procedure TIgnorelistForm.SpeedButton1Click(Sender: TObject);
var
  SelectedItem : integer;
begin
  if Userlist.ItemIndex<>-1 then       
  begin
    SelectedItem:=Userlist.ItemIndex;
    IgnoreList.Items.Add(Userlist.Items[SelectedItem]);
    Userlist.DeleteSelected;
    if SelectedItem>0 then
      Userlist.ItemIndex:=SelectedItem-1
    else
      Userlist.ItemIndex:=SelectedItem+1;
  end
  else
    ShowMessage('Выберите пользователя!');
end;

procedure TIgnorelistForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Userlist.Clear;
  IgnoreList.Clear;
end;

procedure TIgnorelistForm.SpeedButton2Click(Sender: TObject);
var
  SelectedItem : integer;
begin
  if IgnoreList.ItemIndex<>-1 then
  begin
    SelectedItem:=IgnoreList.ItemIndex;
    Userlist.Items.Add(IgnoreList.Items[SelectedItem]);
    IgnoreList.DeleteSelected;
    if SelectedItem>0 then
      IgnoreList.ItemIndex:=SelectedItem-1
    else
      IgnoreList.ItemIndex:=SelectedItem+1;
  end
  else
    ShowMessage('Выберите пользователя!');
end;

procedure TIgnorelistForm.SpeedButton3Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to IgnoreList.Items.Count-1 do
  begin
    Userlist.Items.Add(IgnoreList.Items[i]);
  end;
  IgnoreList.Clear;
end;

procedure TIgnorelistForm.OKBtnClick(Sender: TObject);
begin
  SaveIL.Execute;
  Close;
end;

procedure TIgnorelistForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TIgnorelistForm.SaveILExecute(Sender: TObject);
var
  i, j: integer;
begin
  MainForm.ClientProperties.IgnoreList.Clear;
if(IgnoreList.Items.Count>0)then
 begin
  for j:=2 to MainForm.UserList.Items.Count-1 do
  begin
      for i:=0 to IgnoreList.Items.Count-1 do
      begin
        if(IgnoreList.Items[i]=(MainForm.UserList.Items[j].Caption+
          MainForm.UserList.Items[j].SubItems[0]))then
              begin
                MainForm.UserList.Items[j].StateIndex:=6;
                break;
              end
          else
              begin
                MainForm.UserList.Items[j].StateIndex:=1;
              end;
      end;
  end;
   for i:=0 to IgnoreList.Items.Count-1 do
      MainForm.ClientProperties.IgnoreList.Items.Add(IgnoreList.Items[i]);
 end
  {
  for i:=0 to IgnoreList.Items.Count-1 do
    begin
      MainForm.ClientProperties.IgnoreList.Items.Add(IgnoreList.Items[i]);
      for j:=2 to MainForm.UserList.Items.Count-1 do
          if(IgnoreList.Items[i]=(MainForm.UserList.Items[j].Caption+
          MainForm.UserList.Items[j].SubItems[0]))then
              begin
                MainForm.UserList.Items[j].StateIndex:=6;
                break;
              end
          else
              begin
                MainForm.UserList.Items[j].StateIndex:=1;
              end;
    end    }
else
  for j:=2 to MainForm.UserList.Items.Count-1 do
      MainForm.UserList.Items[j].StateIndex:=1;
      
  if(not(DirectoryExists(MainForm.SpeekerSettings.UserAppdataDir)))then
        CreateDir(MainForm.SpeekerSettings.UserAppdataDir);
  IgnoreList.Items.SaveToFile(MainForm.SpeekerSettings.UserAppdataDir+'\Ignorlist.txt');
end;

end.
