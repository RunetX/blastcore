unit UpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TUpdateForm = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;

implementation

{$R *.dfm}

procedure TUpdateForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
