unit Settings;

interface

uses
  IniFiles,
  Registry,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, AdvOfficePager, Vcl.StdCtrls,
  Vcl.DBCtrls, AsgLinks, AdvSmoothButton, Vcl.CheckLst, Vcl.ExtCtrls;

type
  TFSettings = class(TForm)
    PagerSettings: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    AdvOfficePager13: TAdvOfficePage;
    PafConnection: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    CheckEditLink1: TCheckEditLink;
    ProdList: TCheckListBox;
    OKBtn: TAdvSmoothButton;
    FDQuery2: TFDQuery;
    DataSource2: TDataSource;
    Splitter1: TSplitter;
    RemList: TCheckListBox;
    RemInfo: TDBAdvGrid;
    ProdInfo: TDBAdvGrid;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LoadList;
  private
    procedure WriteToRegistry;
    procedure ReadFromRegistry;
  public
    { Public declarations }
  end;

var
  FSettings: TFSettings;

implementation

{$R *.dfm}

procedure TFSettings.OKBtnClick(Sender: TObject);
begin
  WriteToRegistry;
  Close;
end;

procedure TFSettings.FormShow(Sender: TObject);
begin
  LoadList;
  ReadFromRegistry;
  Caption := 'Inställningar';
end;

procedure TFSettings.ReadFromRegistry;
var
  reg : TRegIniFile;
  i : Integer;
  Bool : Boolean;
begin
  reg := TRegIniFile.Create('PAFGRAFIK');

  for i := 0 to ProdList.Count-1 do
  begin
    Bool := reg.ReadBool('ProdList', ProdList.Items[i], Bool);
    ProdList.Checked[i] := Bool;
  end;

  for i := 0 to RemList.Count-1 do
  begin
    Bool := reg.ReadBool('RemList', RemList.Items[i], Bool);
    RemList.Checked[i] := Bool;
  end;

  FSettings.Top := Reg.ReadInteger('SettingsPos', 'Top', Top);
  FSettings.Left := Reg.ReadInteger('SettingsPos', 'Left', Left);
  Reg.Free;
end;

procedure TFSettings.WriteToRegistry;
var
  reg : TRegIniFile;
  i : Integer;
  Bool : Boolean;
begin
  reg := TRegIniFile.Create('PAFGRAFIK');

  for i := 0 to ProdList.Count-1 do
  begin
    if ProdList.Checked[i] then Bool := True else Bool := False;
    reg.WriteBool('ProdList', ProdList.Items[i], Bool);
  end;

  for i := 0 to RemList.Count-1 do
  begin
    if RemList.Checked[i] then Bool := True else Bool := False;
    reg.WriteBool('RemList', RemList.Items[i], Bool);
  end;

  Reg.WriteInteger('SettingsPos', 'Top', Top);
  Reg.WriteInteger('SettingsPos', 'Left', Left);
  Reg.Free;
end;

procedure TFSettings.LoadList;
var
  i : Integer;
begin
  ProdList.Items.Clear;
  for i := 1 to ProdInfo.RowCount - 1 do ProdList.Items.Add(ProdInfo.Cells[1, i]);
  ProdList.Invalidate;

  RemList.Items.Clear;
  for i := 1 to RemInfo.RowCount - 1 do RemList.Items.Add(RemInfo.Cells[2, i]);
  RemList.Invalidate;
end;

end.
