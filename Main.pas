unit Main;

interface

uses
  Data,  AdvChart, DatumSelect,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvChartView,
  Data.DB, FireDAC.Comp.Client, Data.FMTBcd, Data.DBXMSSQL, Data.SqlExpr,
  DBAdvGrid, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, DBAdvChartView, AdvGDIPicture, DBAdvGDIPPicture,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, AdvChartViewGDIP, DBAdvChartViewGDIP,
  AdvSmoothSpinner, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Menus,
  AdvMenus, AdvOfficeStatusBar, AdvOfficePager;

type
  TForm1 = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Timer1: TTimer;
    AdvPopupMenu1: TAdvPopupMenu;
    Vljdata1: TMenuItem;
    Sparasombild1: TMenuItem;
    Visatableert1: TMenuItem;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    AdvOfficePager13: TAdvOfficePage;
    Chart1: TAdvChartView;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    //procedure IWTimer1AsyncTimer(Sender: TObject; EventParams: TStringList);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Vljdata1Click(Sender: TObject);
    procedure Visatableert1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.FormActivate(Sender: TObject);
begin
 Timer1Timer(Sender);
 Caption:=DateToStr(Dataform.Datum)
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Chart1.Panes[0].Legend.left:=Chart1.Left + Chart1.Width-300;
  Chart1.Panes[0].Legend.top:=Chart1.Top+50;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var MaxY, i: Integer;
begin
  Dataform.Update;
  Caption:=DateToStr(Dataform.Datum);
  Chart1.beginupdate;
  Chart1.ClearPaneSeries;

  for i := 0 to 23 do
  begin
    Chart1.Panes[0].Series[2].AddSingleXYPoint(i,Dataform.GrafArray[i].SignSum);
    Chart1.Panes[0].Series[1].AddSingleXYPoint(i,Dataform.GrafArray[i].Remsum);
    Chart1.Panes[0].Series[0].AddSingleXYPoint(i,Dataform.GrafArray[i].UsSum);
  end;

  Chart1.Panes[0].Series[1].LineColor  :=RGB(255,50,50);
  Chart1.Panes[0].Series[1].LineWidth  :=3;
  Chart1.Panes[0].Series[1].legendtext :='Remisser / timme';
  Chart1.Panes[0].Series[1].ChartType  :=ctBar;
  Chart1.Panes[0].Series[1].Color      :=clBlue;

  Chart1.Panes[0].Series[2].LineColor:=RGB(120,25,27);
  Chart1.Panes[0].Series[2].LineWidth:=3;
  Chart1.Panes[0].Series[2].legendtext:='Signerade undersökningar / timme';
  Chart1.Panes[0].Series[2].ChartType:=ctLine;
  Chart1.Panes[0].Series[2].Color:=clBlue;

  Chart1.Panes[0].Series[0].ChartType:=ctBar;
  Chart1.Panes[0].Series[0].LegendText:='Utförda undersökningar / timme';
  Chart1.Panes[0].Series[0].Color:=clGreen;

  Chart1.Panes[0].Range.RangeTo:=19;
  Chart1.Panes[0].Range.Rangefrom:=7;
  //Chart1.Panes[0].XAxis.AutoSize:=True;
  //Chart1.Panes[0].YAxis.Autosize:=True;

  for i:= 0 to 2 do
  begin
    Chart1.Panes[0].Series[i].Minimum:=-1;
    Chart1.Panes[0].Series[i].Maximum:=20;
  end;
    Chart1.Endupdate;
end;

procedure TForm1.Visatableert1Click(Sender: TObject);
begin
   Dataform.Show
end;

procedure TForm1.Vljdata1Click(Sender: TObject);
begin

  Datumform.TempDatum:=Dataform.Datum;
  Datumform.ShowModal;
  DataForm.Datum:=DatumForm.TempDatum;

  Timer1Timer(Sender)
end;

end.
