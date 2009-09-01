unit aceReg;
{$I sDefs.inc}

interface

uses
  Classes;

procedure Register;

implementation

uses Registry, acScrollPanel, acCheckComboBox, aceFloatPanel;

procedure Register;
begin
  RegisterComponents('AlphaExtra', [TacScrollPanel, TacCheckComboBox, TacFloatPanel]);
end;

end.
