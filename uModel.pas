unit uModel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB;

type
  TfrmModel = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    edtLicense: TLabeledEdit;
    btnOk: TButton;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  frmModel: TfrmModel;

implementation

uses
  uMain;

{$R *.dfm}

procedure TfrmModel.FormCreate(Sender: TObject);
begin
  panel1.Caption := '';
  panel2.Caption := '';
  edtLicense.Text := frmMain.DLicense;
end;

end.
