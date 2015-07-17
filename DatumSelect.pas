unit DatumSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, AdvSmoothEdit,
  AdvSmoothEditButton, AdvSmoothDatePicker, AeroButtons, Registry;

type
  TDatumForm = class(TForm)
    DatePicker: TAdvSmoothDatePicker;
    OKButton: TAeroButton;
    AvbrytButton: TAeroButton;
    procedure OKButtonClick(Sender: TObject);
    procedure AvbrytButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ReadPos;
    procedure WritePos;
  private
    { Private declarations }
  public
    TempDatum: TDate;
  end;

var
  DatumForm: TDatumForm;

implementation

{$R *.dfm}

procedure TDatumForm.OKButtonClick(Sender: TObject);
begin
  TempDatum := DatePicker.Date;
  Close;
  WritePos;
end;

procedure TDatumForm.AvbrytButtonClick(Sender: TObject);
begin
  Close;
  WritePos;
end;

procedure TDatumForm.FormShow(Sender: TObject);
begin
  DatePicker.Date := TempDatum;
  ReadPos;
  Caption := 'Datum';
end;

procedure TDatumForm.ReadPos;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create('PAFGRAFIK');
  DatumForm.Top := Reg.ReadInteger('DatumSelect', 'Top', Top);
  DatumForm.Left := Reg.ReadInteger('DatumSelect', 'Left', Left);
  Reg.Free;
end;

procedure TDatumForm.WritePos;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create('PAFGRAFIK');
  Reg.WriteInteger('DatumSelect', 'Top', Top);
  Reg.WriteInteger('DatumSelect', 'Left', Left);
  Reg.Free;
end;

end.
