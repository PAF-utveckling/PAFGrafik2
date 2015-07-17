unit Data;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,Vcl.Graphics, Vcl.Controls, Vcl.Grids,

  System.Classes, System.IniFiles, Sysutils, System.DateUtils,
  Winapi.Windows, Winapi.Messages, System.Variants,
  Vcl.Forms, Vcl.Dialogs, W7Labels, W7Classes, W7Bars, AdvObj, BaseGrid, AdvGrid,
  DBAdvGrid, AdvGDIPicture, DBAdvGDIPPicture, FireDAC.Phys.ODBC,
  FireDAC.Phys.ODBCDef, Registry;

type
  TPafGraf =  object
    Timme, Remsum, UsSum, SignSum : Integer;
  end;
  TDVTGraf = object
    RegTid, UndSlutTid, Ledtid : TDateTime;
    LedDagar, LedTimmar, LedMinuter : Integer;
  end;

  TDataForm = class(TForm)
    DBPattab          : TDBAdvGrid;
    DBAdvGDIPPicture1 : TDBAdvGDIPPicture;
    InfoBar           : TW7InformationBar;
    ALableleft        : TW7ActiveLabel;
    ALableRight       : TW7ActiveLabel;
    FDQuery           : TFDQuery;
    DataSource1       : TDataSource;
    FDConnection1: TFDConnection;
    procedure Reset;
    procedure Update;                                // Den procedur som häntar data
    procedure FormCreate(Sender: TObject);
  private
    function GetPsw2(Psw1: string): String;
    procedure ReadFromIniFile;
    procedure WriteToInifile;
    procedure UpdateDayGraphArray;
    procedure UpdateDVTGraphArray;
  public
    ParamString, DatabasName, ServerName, Provider, user, password: String;
    Changed, DatabaseOK, AllOk: Boolean;
    Datum: TDate;
    Count: Integer;
    AntalTider: Integer;
    Remisser: Integer;
    DayGrafArray: array[0..23] of TPafGraf;
    DVTGrafArray: array[0..59] of TDVTGraf;
  end;

var
  DataForm: TDataForm;

implementation

{$R *.dfm}

procedure TDataForm.Reset;
var
  i : Integer;
begin
  for i := 0 to Length(DayGrafArray) do
  begin
    with DayGrafArray[i] do
    begin
    Timme:=0;
    Remsum:=0;
    UsSum:=0;
    SignSum:=0
    end;
  end;
  for i := 0 to Length(DVTGrafArray) do
  begin
    with DVTGrafArray[i] do
    begin
      RegTid:=0;
      Ledtid:=0;
      Undsluttid:=0;
      LedDagar:=0;
      LedTimmar:=0;
      LedMinuter:=0
    end;
  end;
end;

procedure TDataForm.FormCreate(Sender: TObject);
begin
  Datum:=Now;
  Caption := 'Tabeller';
end;

function TDataForm.GetPsw2(Psw1: string): String;
var
  I: Integer;
begin
  I := 1;
  Result := Psw1[12 + I] + Psw1[18 + I] + Psw1[2 + I] + Psw1[6 + I] + Psw1[11 + I] + Psw1[22 + I] + Psw1[8 + I] + Psw1[28 + I];
end;

procedure TDataForm.ReadFromIniFile;
var
  SettingFile, SettingFilePAF : TIniFile;
  I, SPos : Integer;
  PswKrypt, S, ts, bs, kol : String;
  ws : Widestring;
  Ch : Boolean;
begin
  // Det som Nicklas skrivit:
  S := 'Fel';
  ts:='';
  //SettingFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  AllOk := true;
  ParamString := '';

  if paramcount > 0 then
  begin // Data från inifil i parameterlista, trol paf.ini
    ParamString := ParamStr(1);
    if Sysutils.FileExists(ParamString) then
    begin
      SettingFilePAF := TIniFile.Create(ParamString);
      DatabasName    := SettingFilePAF.ReadString('common', 'database', S);
      ServerName     := SettingFilePAF.ReadString('common', 'server', S);
      Provider       := SettingFilePAF.ReadString('common', 'provider', S);
      PswKrypt       := SettingFilePAF.ReadString('common', 'sps', S);
      user           := SettingFilePAF.ReadString('common', 'User', 'pa');
      password := GetPsw2(PswKrypt);
      AllOk:=True;
      SettingFilePAF.Free;
    end
    else
    begin
      ts := 'Inifilen: ' + ParamString + ' kunde inte läsas.';
      Application.MessageBox(PWidechar(ts), 'Fel!', mb_OK);
      AllOk := False;
    end
  end
end;

procedure TDataForm.WriteToInifile;
var
  SettingFile: TIniFile;
begin

  // Spara till fil eller registry
  (*SettingFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try

  except
    SettingFile.Free;
  end;
  Changed := true;;   *)
end;

procedure TDataForm.UpdateDayGraphArray;
var
  i, Time, si, us, rg : Integer;
  S : String;
begin
  Time := 0;
  si := DBPatTab.ColumnByHeader('SIGNDATUMTID');
  us := DBPatTab.ColumnByHeader('UNDSLUTDATUMTID');
  rg := DBPatTab.ColumnByHeader('REGTID');
  i := 1;

  for i := 1 to DBPatTab.RowCount do
  begin

    S := DBPattab.GridCells[si, i];       // Signdatumtiden
    if S > '' then
    begin
      Time := StrToInt(S.Substring(11, 2));
      DayGrafArray[Time].SignSum := DayGrafArray[Time].SignSum + 1;
    end;

    S := DBPattab.GridCells[us, i];      // Undslutdatumtiden
    if S > '' then
    begin
      Time := StrToInt(S.Substring(11, 2));
      DayGrafArray[Time].UsSum := DayGrafArray[Time].UsSum + 1;
    end;

    S := DBPatTab.GridCells[rg, i];      // Regtiden
    if S > '' then
    begin
      Time := StrToInt(S.Substring(11, 2));
      DayGrafArray[Time].Remsum := DayGrafArray[Time].Remsum + 1;
    end;
  end;
end;

procedure TDataForm.UpdateDVTGraphArray;
var
  TotTime, RegTime, SignTime: TDateTime;
  i, j, si, tk, rt, us, pk : Integer;
  ProdKod, Sign, TurKlass : String;
begin
  si := DBPatTab.ColumnByHeader('SIGNDATUMTID');
  us := DBPatTab.ColumnByHeader('UNDSLUTDATUMTID');
  pk := DBPatTab.ColumnByHeader('PRODKOD');
  rt := DBPatTab.ColumnByHeader('REGTID');
  tk := DBPatTab.ColumnByHeader('TURKLASS');
  j:=0;

  for i := 1 to DBPatTab.RowCount do
  begin
    ProdKod := DBPattab.GridCells[pk, i];
    if ProdKod = '516' then
    begin
      Sign := DBPattab.GridCells[si, i];
      TurKlass := DBPattab.GridCells[tk, i];
      if (Sign > '') and (TurKlass='0') then
      begin
        SignTime := StrToDateTime(Sign);
        RegTime := StrToDateTime(DBPattab.GridCells[rt, i]);
        TotTime := SignTime - RegTime;

        DVTGrafArray[j].RegTid := RegTime;
        DVTGrafArray[j].Ledtid := TotTime;
        DVTGrafArray[j].LedDagar := trunc(TotTime);
        DVTGrafArray[j].LedTimmar := HoursBetween(RegTime,SignTime);
        DVTGrafArray[j].LedMinuter := MinutesBetween(RegTime,SignTime) - 60 * DVTGrafArray[j].LedTimmar;
        inc(j);
      end;
    end;
  end;
end;

procedure TDataForm.Update;
var
  S1 : String;
begin
  Formatsettings.create('');
  Reset;
  DBPattab.ClearAll;

  FDQuery.SQL.Clear;
    S1 := 'SELECT REMTAB.REGTID, PATTAB.VIKT, PATTAB.SIGNDATUMTID,' +
          ' PATTAB.UNDSLUTDATUMTID,'+
          ' REMTAB.PRODKOD, REMTAB.TURKLASS, PATTAB.REMISSNR'+
          ' FROM PATTAB INNER JOIN REMTAB ON '+
          ' PATTAB.REMISSNR = REMTAB.REMISSNR '+
          ' WHERE '+
          ' ((PATTAB.UNDSLUTDATUMTID > ' + QuotedStr(DateToStr(Datum)) + ') '+
          ' and (PATTAB.UNDSLUTDATUMTID < ' + QuotedStr(DateToStr(Datum+1)) +'))';
  FDQuery.SQL.Text := S1;
  FDQuery.Prepare;
  FDQuery.Open;

  UpdateDayGraphArray;
  UpdateDVTGraphArray;
end;

end.
