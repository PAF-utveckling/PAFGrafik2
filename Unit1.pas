unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvChartView,
  Data.DB, FireDAC.Comp.Client, Data.FMTBcd, Data.DBXMSSQL, Data.SqlExpr,
  DBAdvGrid, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, DBAdvChartView, AdvGDIPicture, DBAdvGDIPPicture,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, AdvChartViewGDIP, DBAdvChartViewGDIP;

type
  TForm1 = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
