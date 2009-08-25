program ClearCore;

uses
  Forms,
  Windows,
  ArchiverUnit in 'ArchiverUnit.pas' {MainForm},
  SendMessageUnit in 'SendMessage\SendMessageUnit.pas' {SendMessageForm},
  ChatYESNOUnit in 'BChat\ChatYESNOUnit.pas' {ChatYESNOForm},
  TryChatUnit in 'BChat\TryChatUnit.pas' {TryChatForm},
  OptionsUnit in 'Options\OptionsUnit.pas' {OptionsForm},
  NewChatUnit in 'BChat\NewChatUnit.pas' {BChatForm};

{$R *.res}

//var
//  PrevWin: HWND;

function TryCreateMutex: Boolean;
var
  Mutex: THandle;
begin
  Result:=true;
  Mutex:=CreateMutex(nil,true,'����� �����');
  if GetLastError = ERROR_ALREADY_EXISTS then Result:=false;
  ReleaseMutex(Mutex);
end;

begin   {
  if not TryCreateMutex then begin
    PrevWin:=FindWindow('TMainForm','MainForm');
    SendMessage(PrevWin,UM_MYMESSSAGE,0,0);
  end
  else  
  begin     }
    Application.Initialize;
    Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSendMessageForm, SendMessageForm);
  Application.CreateForm(TChatYESNOForm, ChatYESNOForm);
  Application.CreateForm(TTryChatForm, TryChatForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TBChatForm, BChatForm);
  Application.Run;
  //end;
end.
