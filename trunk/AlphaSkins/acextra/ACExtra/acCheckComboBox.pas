unit acCheckComboBox;
{$I sDefs.inc}

interface

uses
  Classes, sMaskEdit, sCustomComboEdit, sComboEdit,  sAlphaListBox, sCheckListBox,
  Forms, Controls, SysUtils, {$IFDEF DELPHI7UP}Types, {$ENDIF}Windows;

type
  TacCustomCheckComboBox = class;

  TacCustomPopupForm = class(TForm)
  private
    fCheckComboBox: TacCustomCheckComboBox;
    fCheckListBox: TsCheckListBox;
    procedure UpdateCheckList;
    procedure OnClickCheck(Sender: TObject);
  protected
    procedure DoExit; override;
    procedure Deactivate; override;
    procedure DoClose(var Action: TCloseAction); override;
  public
    constructor Create(aOwner: TComponent); override;
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

  TCheckListItem = class(TCollectionItem)
  private
    fShortCaption: string;
    fCaption: string;
    fChecked: boolean;
    procedure SetCaption(const Value: string);
    procedure SetChecked(const Value: boolean);
    procedure SetShortCaption(const Value: string);
  protected
    function GetDisplayName: string; override;  
  public
  published
    property Caption: string read fCaption write SetCaption;
    property ShortCaption: string read fShortCaption write SetShortCaption;
    property Checked: boolean read fChecked write SetChecked;
  end;

  TCheckListCollection = class(TOwnedCollection)
  protected
    procedure Update(Item: TCollectionItem); override;
  end;

  TacCustomCheckComboBox = class(TsComboEdit)
  private
    fItems: TCheckListCollection;
    fTextAllChecked: string;
    fTextEmpty: string;
    FDivider: string;
    fShowShortCaption: boolean;
    procedure SetItems(const Value: TCheckListCollection);
    procedure SetTextAllChecked(const Value: string);
    procedure SetTextEmpty(const Value: string);
    function GetAsInteger: integer;
    procedure SetAsInteger(const Value: integer);
    procedure SetDivider(const Value: string);
    procedure SetShowShortCaption(const Value: boolean);
  protected
    procedure PopupWindowShow; override;
    procedure PopupWindowClose; override;
    procedure CreatePopup;
    procedure UpdateDisplayText;
  public
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;

    property Items: TCheckListCollection read FItems write SetItems;
    property DirectInput;

    property ShowShortCaption: boolean read fShowShortCaption write SetShowShortCaption default True;
    property Divider: string read fDivider write SetDivider;
    property TextEmpty: string read fTextEmpty write SetTextEmpty;
    property TextAllChecked: string read fTextAllChecked write SetTextAllChecked;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
  end;

  TacCheckComboBox = class(TacCustomCheckComboBox)
  published
    property Alignment;
    property AsInteger;
    property CharCase;
    property ClickKey;
    property Divider;
    property EditMask;
    property Enabled;
    property Font;
    property HideSelection;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property ImeMode;
    property ImeName;
    property Items;    
    property MaxLength;
    property OEMConvert;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property ShowShortCaption;
    property TabOrder;
    property TabStop;
    property Text;
    property TextAllChecked;
    property TextEmpty;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnContextPopup;
    property OnEndDock;
    property OnStartDock;

    property AutoSelect;
    property HelpContext;
    property PasswordChar;
    property Hint;

    property DragCursor;
    property OnEnter;
    property OnExit;
  end;


implementation

uses
  sConst, Math;

{ TacCustomPopupForm }

procedure TacCustomPopupForm.AfterConstruction;
begin
  inherited;
  fCheckListBox := TsCheckListBox.Create(Self);
  fCheckListBox.Parent := Self;
  fCheckListBox.Align := alClient;
  fCheckListBox.OnClickCheck := OnClickCheck;
  Visible := False;
  BorderStyle := bsNone;
end;

constructor TacCustomPopupForm.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

end;

procedure TacCustomPopupForm.Deactivate;
begin
  inherited;
  Visible := False;
end;

destructor TacCustomPopupForm.Destroy;
begin
  fCheckComboBox.fPopupWindow := nil;
  inherited;
end;

procedure TacCustomPopupForm.DoClose(var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TacCustomPopupForm.DoExit;
begin
  inherited;
  Visible := False;
end;

procedure TacCustomPopupForm.OnClickCheck(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to fCheckComboBox.fItems.Count - 1 do
    TCheckListItem(fCheckComboBox.fItems.Items[i]).fChecked := fCheckListBox.Checked[i];

  fCheckComboBox.UpdateDisplayText;
end;

type
  TsCheckListBoxAccess = class(TsCheckListBox);

procedure TacCustomPopupForm.UpdateCheckList;
var
  i, m, k: Integer;
  vItem: TCheckListItem;
begin
  fCheckListBox.Items.BeginUpdate;
  try
    fCheckListBox.Items.Clear;
    for i := 0 to fCheckComboBox.fItems.Count - 1 do
    begin
      vItem := TCheckListItem(fCheckComboBox.fItems.Items[i]);
      fCheckListBox.Checked[fCheckListBox.Items.Add(vItem.fCaption)] := vItem.fChecked;
    end;
    Self.ClientHeight := fCheckListBox.ItemHeight * fCheckListBox.Items.Count + 4;

    m := 0;
    for i := 0 to fCheckListBox.Count-1 do
    begin
      k := fCheckListBox.Canvas.TextWidth(fCheckListBox.Items[i]);
      if m < k then m := k;
    end;
    Self.ClientWidth := m + TsCheckListBoxAccess(fCheckListBox).GetCheckWidth + 8;
    Self.fCheckComboBox.PopupWidth := Max(Width, Self.fCheckComboBox.Width);
    Self.fCheckComboBox.PopupAlign := sConst.pwaLeft;
  finally
    fCheckListBox.Items.EndUpdate;
  end;
end;

{ TCheckListItem }

function TCheckListItem.GetDisplayName: string;
begin
  if fCaption <> ''
    then Result := fCaption
    else
      if fShortCaption <> ''
        then Result := fShortCaption
        else Result := inherited GetDisplayName
end;

procedure TCheckListItem.SetCaption(const Value: string);
begin
  if fCaption <> Value then
  begin
    fCaption := Value;
    Changed(False);
  end;
end;

procedure TCheckListItem.SetChecked(const Value: boolean);
begin
  if fChecked <> Value then
  begin
    fChecked := Value;
    Changed(False);
  end;
end;

procedure TCheckListItem.SetShortCaption(const Value: string);
begin
  if fShortCaption <> Value then
  begin
    fShortCaption := Value;
    Changed(False);
  end;
end;

{ TacCustomCheckComboBox }

constructor TacCustomCheckComboBox.Create(aOwner: TComponent);
begin
  inherited;
  fItems := TCheckListCollection.Create(Self, TCheckListItem);
  fShowShortCaption := True;
  fDivider := ',';
  DirectInput := False;
end;

procedure TacCustomCheckComboBox.CreatePopup;
var
  vForm: TacCustomPopupForm;
begin
  if not Assigned(fPopupWindow) then begin
    vForm := TacCustomPopupForm.CreateNew(nil);
    vForm.Tag := ExceptTag;
    vForm.fCheckComboBox := Self;
    SetClassLong(vForm.Handle, GCL_STYLE, GetClassLong(vForm.Handle, GCL_STYLE) or CS_DROPSHADOW);
    fPopupWindow := vForm;
  end;
  TacCustomPopupForm(fPopupWindow).UpdateCheckList;
end;

destructor TacCustomCheckComboBox.Destroy;
begin
  FreeAndNil(fPopupWindow);
  fItems.Free;
  inherited;
end;

function TacCustomCheckComboBox.GetAsInteger: integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to fItems.Count - 1 do if TCheckListItem(fItems.Items[i]).Checked then Result := Result or (1 shl i);
end;

procedure TacCustomCheckComboBox.PopupWindowClose;
begin
  inherited;
end;

procedure TacCustomCheckComboBox.PopupWindowShow;
var
  P: TPoint;
  Y: Integer;
  Form : TCustomForm;
begin
  if not (ReadOnly or DroppedDown) then begin
    CreatePopup;
    FPopupWindow.Visible := False;
    FPopupWindow.Width := PopupWidth;
    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;

    if Y + FPopupWindow.Height > Screen.DesktopHeight then Y := P.Y - FPopupWindow.Height;
    case PopupAlign of
      pwaRight: begin
        Dec(P.X, FPopupWindow.Width - Width);
        if P.X < Screen.DesktopLeft then Inc(P.X, FPopupWindow.Width - Width);
      end;
      pwaLeft: begin
        if P.X + FPopupWindow.Width > Screen.DesktopWidth then Dec(P.X, FPopupWindow.Width - Width);
      end;
    end;
    if P.X < Screen.DesktopLeft then P.X := Screen.Desktopleft else if P.X + FPopupWindow.Width > Screen.DesktopWidth then P.X := Screen.DesktopWidth - FPopupWindow.Width;

    Form := GetParentForm(Self);
    if Form <> nil then begin
      if (FPopupWindow is TForm) and (TForm(Form).FormStyle = fsStayOnTop) then TForm(FPopupWindow).FormStyle := fsStayOnTop;
      SetWindowPos(FPopupWindow.Handle, GetNextWindow(Form.Handle, GW_HWNDPREV), P.X, Y, FPopupWindow.Width, FPopupWindow.Height, SWP_SHOWWINDOW or SWP_NOACTIVATE);
    end;
    FPopupWindow.Visible := True;
  end;
end;

procedure TacCustomCheckComboBox.SetTextAllChecked(const Value: string);
begin
  if fTextAllChecked <> Value then
  begin
    fTextAllChecked := Value;
    UpdateDisplayText;
  end;
end;

procedure TacCustomCheckComboBox.SetAsInteger(const Value: integer);
var
  i: Integer;
begin
  for i := 0 to fItems.Count - 1 do
    TCheckListItem(fItems.Items[i]).Checked := (Value and (1 shl i)) <> 0;
end;

procedure TacCustomCheckComboBox.SetDivider(const Value: string);
begin
  if fDivider <> Value then
  begin
    fDivider := Value;
    UpdateDisplayText;
  end;
end;

procedure TacCustomCheckComboBox.SetTextEmpty(const Value: string);
begin
  if fTextEmpty <> Value then
  begin
    fTextEmpty := Value;
    UpdateDisplayText;
  end;
end;

procedure TacCustomCheckComboBox.SetItems(const Value: TCheckListCollection);
begin
  fItems.Assign(Value);
end;  

procedure TacCustomCheckComboBox.SetShowShortCaption(const Value: boolean);
begin
  if fShowShortCaption <> Value then
  begin
    fShowShortCaption := Value;
    UpdateDisplayText;
  end;
end;

procedure TacCustomCheckComboBox.UpdateDisplayText;
var
  s: string;
  i, vCheckCount: integer;
begin
  s := '';
  vCheckCount := 0;

  for i := 0 to fItems.Count - 1 do
    if TCheckListItem(fItems.Items[i]).fChecked then
    begin
      if vCheckCount = 0
        then begin
          if fShowShortCaption
            then s := TCheckListItem(fItems.Items[i]).fShortCaption
            else s := TCheckListItem(fItems.Items[i]).fCaption
        end else begin
          if fShowShortCaption
            then s := s + fDivider + TCheckListItem(fItems.Items[i]).fShortCaption
            else s := s + fDivider + TCheckListItem(fItems.Items[i]).fCaption
        end;
      inc(vCheckCount);
    end;

  if vCheckCount = 0
    then begin
      if fTextEmpty <> '' then s := fTextEmpty
    end else
      if vCheckCount = fItems.Count
        then begin
          if fTextAllChecked <> '' then s := fTextAllChecked
        end;

  if Text <> s then
  begin
    Text := s;
    SkinData.Invalidate;
    if Assigned(OnChange) then OnChange(Self);
  end;
end;

{ TCheckListCollection }

procedure TCheckListCollection.Update(Item: TCollectionItem);
begin
  inherited;
{$IFDEF DELPHI7UP}
  TacCustomCheckComboBox(Owner).UpdateDisplayText;
{$ENDIF}
end;

end.
