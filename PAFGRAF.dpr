program PAFGRAF;

uses
  Vcl.Forms,
  Data in 'Data.pas' {DataForm},
  DatumSelect in 'DatumSelect.pas' {DatumForm},
  Vcl.Themes,
  Vcl.Styles,
  MainNew in 'MainNew.pas' {Mainform},
  Settings in 'Settings.pas' {FSettings};

{FSettings}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'PAF grafik';
  Application.CreateForm(TMainform, Mainform);
  Application.CreateForm(TDataForm, DataForm);
  Application.CreateForm(TDatumForm, DatumForm);
  Application.CreateForm(TFSettings, FSettings);
  Application.Run;
end.
