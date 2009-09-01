unit aceFloatPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, sPanel, Messages, Windows;

const
  acDefBordWidth = 3;

type
  TacBordersSizes = class(TPersistent)
  protected
    FTop : integer;
    FLeft : integer;
    FBottom : integer;
    FRight : integer;
  public
    constructor Create;
  published
    property Top : integer read FTop write FTop default acDefBordWidth;
    property Left : integer read FLeft write FLeft default acDefBordWidth;
    property Bottom : integer read FBottom write FBottom default acDefBordWidth;
    property Right : integer read FRight write FRight default acDefBordWidth;
  end;

  TacFloatPanel = class(TsPanel)
  private
    FIsFloat: boolean;
    FMouseBorderWidth: TacBordersSizes;
  protected
    function HTProcess(var Message : TWMNCHitTest) : integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure WndProc (var Message: TMessage); override;
  published
    property IsFloat : boolean read FIsFloat write FIsFloat default True;
    property MouseBorderWidth : TacBordersSizes read FMouseBorderWidth write FMouseBorderWidth;
  end;

implementation

uses acntUtils;

{ TacFloatPanel }

constructor TacFloatPanel.Create(AOwner: TComponent);
begin
  inherited;
  FMouseBorderWidth := TacBordersSizes.Create;
  FIsFloat := True;
end;

destructor TacFloatPanel.Destroy;
begin
  FreeAndNil(FMouseBorderWidth);
  inherited;
end;

function TacFloatPanel.HTProcess(var Message: TWMNCHitTest): integer;
var
  p : TPoint;
begin
  p := ScreenToClient(Point(Message.XPos, Message.YPos));
  Result := HTCLIENT;
  if (p.Y < FMouseBorderWidth.Top) then Result := HTTOP;
  if (p.Y > Height - FMouseBorderWidth.Bottom) then Result := HTBOTTOM;
  if (p.X < FMouseBorderWidth.Left) then if Result = HTTOP then Result := HTTOPLEFT else if Result = HTBOTTOM then Result := HTBOTTOMLEFT else Result := HTLEFT;
  if (p.X > Width - FMouseBorderWidth.Right) then if Result = HTTOP then Result := HTTOPRIGHT else if Result = HTBOTTOM then Result := HTBOTTOMRIGHT else Result := HTRIGHT;
end;

procedure TacFloatPanel.WndProc(var Message: TMessage);
begin
  if not (csDesigning in ComponentState) then case Message.Msg of
    WM_NCHITTEST : if FMouseBorderWidth.Left + FMouseBorderWidth.Top + FMouseBorderWidth.Right + FMouseBorderWidth.Bottom > 0 then begin
      Message.Result := HTProcess(TWMNCHitTest(Message));
      Exit;
    end;
    WM_LBUTTONDOWN : if IsFloat then begin
      Message.Result := 0;
      ReleaseCapture;
      Perform(WM_SYSCOMMAND, $F012, 0);
      Exit;
    end;
  end;
  inherited;
end;

{ TacBordersSizes }

constructor TacBordersSizes.Create;
begin
  FTop := acDefBordWidth;
  FLeft := acDefBordWidth;
  FBottom := acDefBordWidth;
  FRight := acDefBordWidth;
end;

end.
