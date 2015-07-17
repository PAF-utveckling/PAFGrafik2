unit MainNew;
{ $ define debug}
interface

uses
  Settings, AdvChart, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, Vcl.ExtCtrls, Vcl.Menus, AdvMenus,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, AdvChartView, AdvChartViewGDIP,
  AdvOfficeStatusBar, AdvOfficePager, System.Classes,
  Vcl.Graphics, Vcl.StdCtrls, Vcl.Samples.Spin, Registry, AdvSmoothCalendar;

type
  TMainform = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;

    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    AdvOfficePager12: TAdvOfficePage;
    AdvOfficePager13: TAdvOfficePage;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    AdvPopupMenu1: TAdvPopupMenu;
    Vljdata1: TMenuItem;
    Sparasombild1: TMenuItem;
    Visatableert1: TMenuItem;
    Timer1: TTimer;
    DebugStandarddatum1: TMenuItem;
    AdvGDIPChartView1: TAdvGDIPChartView;
    ChartDay: TAdvGDIPChartView;
    N1: TMenuItem;
    Instllningar1: TMenuItem;
    ChartDVT: TAdvGDIPChartView;
    DVTValjSkala: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Starttid: TListBox;
    Undtid: TListBox;
    Calendar: TAdvSmoothCalendar;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Vljdata1Click(Sender: TObject);
    procedure Visatableert1Click(Sender: TObject);
    procedure DebugStandarddatum1Click(Sender: TObject);
    procedure Instllningar1Click(Sender: TObject);
    procedure DVTSkala;
    procedure DVTValjSkalaChange(Sender: TObject);
    procedure WriteMain;
    procedure ReadMain;
    procedure FormExit(Sender: TObject);
    procedure CalendarChange(Sender: TObject);
  private
    procedure UpdateDay;
    procedure UpdateDVT;
  public
    DVTMax : Integer;
    TempDatum : TDateTime;
  end;

var
  Mainform: TMainform;

implementation

{$R *.dfm}

uses DatumSelect, Data;

procedure TMainform.DebugStandarddatum1Click(Sender: TObject);
begin
  DataForm.Datum := StrTodate('2014-10-07');
  Timer1Timer(Sender)
end;

procedure TMainform.FormActivate(Sender: TObject);
begin
  DVTMax := DVTValjSkala.Value;
  DVTSkala;

  Application.HintPause := 50;
  Application.HintHidePause := 30000;

  Timer1Timer(Sender);
  Caption := DateToStr(DataForm.Datum);
  ReadMain;
end;

procedure TMainform.FormResize(Sender: TObject);
begin
  ChartDay.Panes[0].Legend.left := ChartDay.left + ChartDay.Width - 300;
  ChartDay.Panes[0].Legend.top := ChartDay.top + 50;
end;

procedure TMainform.Instllningar1Click(Sender: TObject);
begin
  FSettings.ShowModal;
end;

procedure TMainform.DVTValjSkalaChange(Sender: TObject);
begin
  DVTMax := DVTValjSkala.Value;
  DVTSkala;
end;

procedure TMainForm.DVTSkala;
var
  i : Integer;
begin  
  ChartDVT.BeginUpdate;
  for i := 0 to 2 do
  ChartDVT.Panes[0].Series[i].Maximum := DVTMax; 
  ChartDVT.EndUpdate;
end;

procedure TMainform.Visatableert1Click(Sender: TObject);
begin
  DataForm.Show;
end;

procedure TMainform.UpdateDay;
var
  i: Integer;
begin
  Caption := DateToStr(DataForm.Datum);
  ChartDay.beginupdate;
  ChartDay.ClearPaneSeries;
  for i := 0 to 23 do
  begin
    ChartDay.Panes[0].Series[2].AddSingleXYPoint(i,DataForm.DayGrafArray[i].SignSum);
    ChartDay.Panes[0].Series[1].AddSingleXYPoint(i,DataForm.DayGrafArray[i].Remsum);
    ChartDay.Panes[0].Series[0].AddSingleXYPoint(i,DataForm.DayGrafArray[i].UsSum);
  end;
  ChartDay.Panes[0].Range.RangeTo := 19;
  ChartDay.Panes[0].Range.Rangefrom := 7;
  for i := 0 to 2 do
  begin
    ChartDay.Panes[0].Series[i].Maximum := 20;
    ChartDay.Panes[0].Series[i].Minimum := -1;
  end;
  ChartDay.Endupdate;
end;

procedure TMainform.UpdateDVT;
var
  R : TRect;
  i, Minutes, Hours : Integer;
  tid : Double;
  Reg : String;
begin
  ChartDVT.beginupdate;
  ChartDVT.ClearPaneSeries;
  Starttid.Clear;
  Undtid.Clear;
  i := 0;
  repeat
    Hours := DataForm.DVTGrafArray[i].LedTimmar;
    Minutes := DataForm.DVTGrafArray[i].LedMinuter;
    tid := Hours + Minutes/60;
    Reg := DateTimeToStr(DataForm.DVTGrafArray[i].RegTid);
    Reg := Reg.Substring(11,8);
    ChartDVT.Panes[0].Series[0].AddSinglePoint(DataForm.DVTGrafArray[i].LedTimmar+DataForm.DVTGrafArray[i].LedMinuter/60, Reg);
    if DataForm.DVTGrafArray[i].LedDagar > 0 then ChartDVT.Panes[0].Series[1].AddSinglePoint(DataForm.DVTGrafArray[i].LedTimmar+DataForm.DVTGrafArray[i].LedMinuter/60,Reg)
    else ChartDVT.Panes[0].Series[1].AddSinglePoint(0,Reg);
    inc(i);
    ChartDVT.Panes[0].Range.RangeTo := i-2;
    if tid <> 0 then
    begin
      Starttid.Items.Add(Reg);
      if Minutes<10 then Undtid.Items.Add(' ' + IntToStr(Hours) + ':0' + IntToStr(Minutes))
      else Undtid.Items.Add(' ' + IntToStr(Hours) + ':' + IntToStr(Minutes));
    end;
  until tid = 0;
  i:=i-1;
  Starttid.Height :=  2 + i*19;
  Undtid.Height := 2 + i*19;
  ChartDVT.Endupdate;
end;

procedure TMainform.Vljdata1Click(Sender: TObject);
begin
  DatumForm.TempDatum := DataForm.Datum;
  //Calendar.Top := 15;
  //Calendar.Left := 60;
  //Calendar.Visible := True;
  //Calendar.SelectDate := StrToDate(Caption);
  //Calendar.SelectedDate := StrToDate(Caption);

  Datumform.ShowModal;

  DataForm.Datum := DatumForm.TempDatum;

  DataForm.Update;
  UpdateDay;
  UpdateDVT;
end;

procedure TMainform.CalendarChange(Sender: TObject);
begin
  TempDatum := Calendar.SelectedDate;
  DataForm.Datum := TempDatum;
end;

procedure TMainform.Timer1Timer(Sender: TObject);
begin
  DataForm.Update;
  UpdateDay;
  UpdateDVT;
end;

procedure TMainForm.WriteMain;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create('PAFGRAFIK');
  Reg.WriteInteger('MainNew', 'Top', Top);
  Reg.WriteInteger('MainNew', 'Left', Left);
  Reg.WriteInteger('MainNew', 'Width', Width);        // Sparar applikationsstorleken
  Reg.WriteInteger('MainNew', 'Height', Height);
  Reg.Free;
end;

procedure TMainForm.ReadMain;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create('PAFGRAFIK');
  MainForm.Top := Reg.ReadInteger('MainNew', 'Top', Top);
  MainForm.Left := Reg.ReadInteger('MainNew', 'Left', Left);
  MainForm.Width := Reg.ReadInteger('MainNew', 'Width', Width);         // Läser in applikationsstorleken
  MainForm.Height := Reg.ReadInteger('MainNew', 'Height', Height);
  Reg.Free;
end;

procedure TMainForm.FormExit(Sender: TObject);
begin
  WriteMain;
end;

end.
