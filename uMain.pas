unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ActnMan, System.UITypes,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  ShlObj, midaslib,
  Data.DB, Datasnap.DBClient,
  IniFiles, ShellAPI;

type
  TVerResourceKey = (
    vrComments,         // コメント
    vrCompanyName,      // 会社名
    vrFileDescription,  // 説明
    vrFileVersion,      // ファイルバージョン
    vrInternalName,     // 内部名
    vrLegalCopyright,   // 著作権
    vrLegalTrademarks,  // 商標
    vrOriginalFilename, // 正式ファイル名
    vrPrivateBuild,     // プライベートビルド情報
    vrProductName,      // 製品名
    vrProductVersion,   // 製品バージョン
    vrSpecialBuild);    // スペシャルビルド情報

type
  TfrmMain = class(TForm)
    ActionManager1: TActionManager;
    actExit: TAction;
    actBrowse: TAction;
    actRefer: TAction;
    actShowModel: TAction;

    btnFind: TButton;
    btnBrowse: TButton;
    btnModel: TButton;
    cdsModel: TClientDataSet;
    dsModel: TDataSource;
    edtApplication: TLabeledEdit;
    edtCallsign: TLabeledEdit;
    edtFileName: TLabeledEdit;
    edtLicense: TLabeledEdit;
    lblAbout: TLabel;
    mnuBar1: TMenuItem;
    mnuExit: TMenuItem;
    mnuRefer: TMenuItem;
    mnuOpen: TMenuItem;
    mnuShowModel: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtFileNameChange(Sender: TObject);
    procedure actReferExecute(Sender: TObject);
    procedure actBrowseExecute(Sender: TObject);
    procedure actShowModelExecute(Sender: TObject);
  private
    { Private 宣言 }
    AppFileName: string;
    AppName: string;
    AppDir: string;
    IniFileName: string;
    Ini: TMemIniFile;

    exPFileName: string;

    FCompanyName: string;
    FAppVersion: string;
    FUnitCount: integer;
    FUnitMaxNo: integer;
    FisOk: boolean;
    FDFileName: string;
    FDLicense: string;
    FPFileName: string;
    procedure SetFormFooting;
    procedure SetCompanyName(const Value: string);
    procedure SetAppVersion(const Value: string);
    procedure LoadModelTable(aStLicense: string);
    procedure CreateModelTable;
    procedure SaveModelTable(aStLicense: string);
    procedure SetUnitCount(const Value: integer);
    procedure SetUnitMaxNo(const Value: integer);
    procedure SetDFileName(const Value: string);
    procedure SetDLicense(const Value: string);
    function ExecXmlToPdf(Filename:string): Cardinal;
  public
    { Public 宣言 }
    property AppVersion: string read FAppVersion write SetAppVersion;
    property CompanyName: string read FCompanyName write SetCompanyName;
    property UnitCount: integer read FUnitCount write SetUnitCount;
    property UnitMaxNo: integer read FUnitMaxNo write SetUnitMaxNo;
    property isOk: boolean read FisOk;

    property DFileName: string read FDFileName write SetDFileName;
    property PFileName: string read FPFileName;
    property DLicense: string read FDLicense write SetDLicense;
  end;

function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;
function GetVersionInfo(ExeName: string; KeyWord: TVerResourceKey): string;
function ENumWindowsProc(hwindow: hWnd; lParam: LPARAM): bool; stdcall;
function RunExeFile(hWnd: HWND; AFile: String; AParameters: String;
   Verb: String): Cardinal;
//*
//* 定数用３項演算子 (TrueValue, FalseValue は常に評価されます)
//*
function IIf(const Condition: boolean; const TrueValue, FalseValue: string): string; overload;
function IIf(const Condition: boolean; const TrueValue, FalseValue: integer): integer; overload;
function IIf(const Condition: boolean; const TrueValue, FalseValue: cardinal): cardinal; overload;
function IIf(const Condition: boolean; const TrueValue, FalseValue: currency): currency; overload;
function IIf(const Condition: boolean; const TrueValue, FalseValue: TObject): TObject; overload;

var
  frmMain: TfrmMain;

const
  cShinseiName1: string = 'sinsei.xml';
  cShinseiName2: string = 'shinsei.xml';
  cExeName: string = 'DXmlToPdf.exe';
  cIniName: string = 'DXmlToPdf.ini';
  cJCodeName: string = 'JichitaiCode.txt';
  cKeyWordStr: array [TVerResourceKey] of String = (
        'Comments',
        'CompanyName',
        'FileDescription',
        'FileVersion',
        'InternalName',
        'LegalCopyright',
        'LegalTrademarks',
        'OriginalFilename',
        'PrivateBuild',
        'ProductName',
        'ProductVersion',
        'SpecialBuild');

implementation

uses uModel, uRecord;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FisOk := true;
  AppFileName     := Application.ExeName;
  AppName         := ChangeFileExt(ExtractFileName(AppFileName), '');
  AppDir          := ExtractFileDir(AppFileName);
  IniFileName     := ExpandFileName(cIniName);

  edtApplication.Clear;
  edtLicense.Clear;
  edtCallsign.Clear;
  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    Top     := Ini.ReadInteger('main', 'top', -1);
    Left    := Ini.ReadInteger('main', 'left', -1);
    if (top < 0) or (Top + Height > Screen.Height)
    or (Left < 0) or (Left + Width > Screen.Width) then
      begin
      Self.Top := (Screen.Height - Self.Height) div 2;
      Self.Left := (Screen.Width - Self.Width)  div 2;
      end;
    DFileName := Ini.ReadString('main', 'filename', '');
  finally
    FreeAndNil(Ini);
  end;
  CreateModelTable;
  AppVersion  := GetVersionInfo(AppFileName, vrFileVersion);
  CompanyName := GetVersionInfo(AppFileName, vrCompanyName);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  exPFileName := PFileName;
  EnumWindows(@EnumWindowsProc, 0);   // 現在開いているフォームを閉じる

  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    Ini.WriteInteger('main', 'top', Top);
    Ini.WriteInteger('main', 'left', Left);
    Ini.WriteString('main', 'filename', FDFileName);
  finally
    Ini.UpdateFile;
    FreeAndNil(Ini);
  end;
end;

procedure TfrmMain.CreateModelTable;
begin
  try
    cdsModel.Close;
    cdsModel.FieldDefs.Clear;
    cdsModel.FieldDefs.Add('UnitNo' ,ftWord);
    cdsModel.FieldDefs.Add('Model', ftWideString, 32);
    cdsModel.FieldDefs.Add('Comment', ftWideString, 32);
    cdsModel.IndexDefs.Add('UnitNo_IDX','UnitNo', [ixPrimary]);
    cdsModel.IndexName := 'UnitNo_IDX';  // インデックスの設定
    cdsModel.CreateDataSet;
    cdsModel.Close;
    cdsModel.Open;
  finally

  end;
end;

procedure TfrmMain.LoadModelTable(aStLicense: string);
var
  i,j: integer;
  s: string;
  wUnitNo: string;
  wModel: string;
  wComment: string;
  SL, SL1, SL2: TstringList;
begin
  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  SL   := TStringList.Create();
  SL1  := TStringList.Create();
  SL2  := TStringList.Create();
  try
    if not cdsModel.Active then
      cdsModel.Open;
    cdsModel.EmptyDataSet;

    Ini.ReadSectionValues(aStLicense, SL);
    for i := 0 to SL.Count - 1 do
      begin
      s := Copy(sl.Names[i], 1, 4);
      if s = 'unit' then
        sl1.Add(SL.Strings[i])
      else if s = 'comm' then
        sl2.Add(SL.Strings[i]);
      end;

    for i := 0 to sl1.Count - 1 do
      begin
      wUnitNo   :=  sl1.Names[i];
      wModel    :=  sl1.Values[wUnitNo];
      wComment  :=  '';
      s := StringReplace(wUnitNo, 'unit', 'comment', [rfReplaceAll, rfIgnoreCase]);
      j := sl2.IndexOfName(s);
      if i >= 0 then
        wComment  :=  sl2.ValueFromIndex[j];

      cdsModel.Append;
      s := Copy(wUnitNo, 5, 256);
      cdsModel.FieldByName('UnitNo').AsInteger  := strToInt(s);
      cdsModel.FieldByName('Model').AsString    := wModel;
      cdsModel.FieldByName('Comment').AsString  := wComment;
      cdsModel.Post;
      end;
    cdsModel.Fields[0].Alignment := taCenter;
    cdsModel.Fields[0].DisplayWidth := 6;
    cdsModel.Fields[1].DisplayWidth := 32;
    cdsModel.Fields[2].DisplayWidth := 32;
    cdsModel.First;
  finally
    FreeAndNil(Ini);
    FreeAndNil(SL);
    FreeAndNil(SL1);
    FreeAndNil(SL2);
  end;
end;

procedure TfrmMain.SaveModelTable(aStLicense: string);
var
  wUnitNo: integer;
  wUnitNoS: string;
  wModel: string;
  wComment: string;
begin
  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    if not cdsModel.Active then
      cdsModel.Open;
    ini.EraseSection(aStLicense);

    cdsModel.First;
    while not cdsModel.Eof do
      begin
      wUnitNo   :=  cdsModel.FieldByName('UnitNo').AsInteger;
      wUnitNoS  :=  IntToStr(wUnitNo);
      wModel    :=  cdsModel.FieldByName('Model').AsString;
      wComment  :=  cdsModel.FieldByName('Comment').AsString;
      if wUnitNo > 0 then
        begin
        Ini.WriteString(aStLicense, 'unit' + wUnitNos, wModel);
        if wComment <> '' then
          Ini.WriteString(aStLicense, 'comment' + wUnitNoS, wComment);
        end;
      cdsModel.Next;
      end;
  finally
    Ini.UpdateFile;
    FreeAndNil(Ini);
  end;
end;

procedure TfrmMain.actBrowseExecute(Sender: TObject);
var
  LExePath: string;
  LParams: string;
  LhInstance: Cardinal;
begin
    EnumWindows(@EnumWindowsProc, 0);   // 現在開いているフォームを閉じる

    if not FileExists(DFileName) then
      begin
      MessageDlg('ファイルが見つかりません', mtConfirmation, [mbOk], 0, mbYes);
      exit;
      end;

    if ExecXmlToPdf(DFileName) <= 32 then
      exit;

    if not FileExists(PFileName) then
      begin
      MessageDlg('PDFファイルが見つかりません', mtConfirmation, [mbOk], 0, mbYes);
      exit;
      end;

    LExePath   := '"' + PFileName + '"';    // 作成したPDFを表示する
    LParams   := '';
    LhInstance := RunExeFile(Handle, LExePath, LParams, '');
    if LhInstance <= 32 then begin
      MessageDlg('起動の失敗', mtConfirmation, [mbOk], 0, mbYes);
      exit;
    end;

    SetForegroundWindow(self.Handle);
    frmMain.FormStyle := fsStayOnTop;
    frmMain.FormStyle := fsNormal;

  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    DLicense := Ini.ReadString('main', 'license', '');
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TfrmMain.actReferExecute(Sender: TObject);
begin
  with OpenDialog1 do
    begin
    Title := 'Select file';
    if DFileName = '' then
      begin
      InitialDir := AppDir;
      FileName    := '';
      end
    else
      begin
      InitialDir  := ExtractFileDir(DFileName);
      FileName    := ExtractFileName(DFileName);
      end;
    if not Execute() then
      exit;
    DFileName := FileName;
    end;

  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    if ExecXmlToPdf(DFileName) > 32 then
      DLicense := Ini.ReadString('main', 'license', '');
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TfrmMain.actShowModelExecute(Sender: TObject);
var
  frmModel: TfrmModel;
begin
  LoadModelTable(DLicense);
  frmModel := TfrmModel.Create(self);
  try
    if frmModel.ShowModal = mrOk then
      begin
      SaveModelTable(DLicense)
      end
    else
  finally
    FreeAndNil(frmModel);
  end;
end;

procedure TfrmMain.edtFileNameChange(Sender: TObject);
begin
  if DFileName <> edtFileName.Text then
    DFileName := edtFileName.Text;
end;

function TfrmMain.ExecXmlToPdf(Filename: string): Cardinal;
var
  LExePath: string;
  LParams: string;
  LhInstance: Cardinal;
begin
  result := 0;
  try
    LExePath  := ExpandFileName(cExeName);        //　DXmlToPdf.exe起動ファイルの相対パス
    if not FileExists(LExePath) then
      begin
      MessageDlg('実行ファイルが見つかりません', mtConfirmation, [mbOk], 0, mbYes);
      exit;
      end;

    LExePath  := LExePath;   // DXmlToPdf.exeを実行する
    LParams   := '"' + FileName + '"';
    LhInstance := RunExeFile(Handle, LExePath, LParams, '');
    result  := LhInstance;
    if LhInstance <= 32 then begin
      MessageDlg('起動の失敗', mtConfirmation, [mbOk], 0, mbYes);
      exit;
    end;
  finally

  end;
end;

procedure TfrmMain.SetAppVersion(const Value: string);
begin
  FAppVersion := Value;
end;

procedure TfrmMain.SetCompanyName(const Value: string);
begin
  FCompanyName := value;
  SetFormFooting;
end;

procedure TfrmMain.SetDFileName(const Value: string);
var
  WFileName: string;
begin
  if Value <> FPFileName then
    exPFileName := FPFileName;    // 前回のファイル名
  FDFileName := Value;
  edtFileName.Text := FDFileName;
  Caption := AppName;
  actBrowse.Enabled := False;
  if FDFileName <> '' then
    begin
    Caption := AppName +  ' - ' + ExtractFilename(FDFileName);
    actBrowse.Enabled := True;
    end;
  FPFileName := ChangeFileExt(FDFileName, '.pdf');

  Ini  := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    edtApplication.Clear;
    edtLicense.Clear;
    edtCallsign.Clear;
    WFileName := Ini.ReadString('main', 'filename', '');
    if (FDFileName <> '') and (FDFileName = WFileName) then
      begin
      DLicense := Ini.ReadString('main', 'license', '');
      end;
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TfrmMain.SetDLicense(const Value: string);
begin
  FDLicense := Value;
  edtLicense.Text := FDLicense;
  actShowModel.Enabled := False;
  if FDLicense <> '' then
    actShowModel.Enabled := True;
  Ini := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    edtApplication.Text := Ini.ReadString('main', 'application', '');
    edtCallsign.Text    := Ini.ReadString('main', 'Callsign', '');
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TfrmMain.SetFormFooting;
var
  s: string;
begin
  s  := 'Ver. ' + FAppVersion;
  if FCompanyName <> '' then
    s := s + '(' + FCompanyName + ')';
  lblAbout.Caption := s;
end;

procedure TfrmMain.SetUnitCount(const Value: integer);
begin
  FUnitCount := Value;
end;

procedure TfrmMain.SetUnitMaxNo(const Value: integer);
begin
  FUnitMaxNo := Value;
end;

// Windowsの特殊フォルダを取得
function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;
var
  handle: HWnd;
  Buff: PChar;
begin
  handle := 0;
  GetMem(Buff, 2048);
  try
    ZeroMemory(Buff, 2048);
    SHGetSpecialFolderPath(handle , Buff, Folder, CanCreate);
    result  := Buff;
  finally
    FreeMem(Buff);
  end;
end;

function GetVersionInfo(ExeName: string; KeyWord: TVerResourceKey): string;
const
  Translation = '\VarFileInfo\Translation';
  FileInfo    = '\StringFileInfo\%0.4s%0.4s\';
var
  BufSize, HWnd: DWORD;
  VerInfoBuf: Pointer;
  VerData: Pointer;
  VerDataLen: Longword;
  PathLocale: String;
begin
  // 必要なバッファのサイズを取得
  BufSize := GetFileVersionInfoSize(PChar(ExeName), HWnd);
  if BufSize <> 0 then
  begin
    // メモリを確保
    GetMem(VerInfoBuf, BufSize);
    try
      GetFileVersionInfo(PChar(ExeName), 0, BufSize, VerInfoBuf);
      // 変数情報ブロック内の変換テーブルを指定
      VerQueryValue(VerInfoBuf, PChar(Translation), VerData, VerDataLen);
      if not (VerDataLen > 0) then
        raise Exception.Create('情報の取得に失敗しました');
      PathLocale := Format(FileInfo + cKeyWordStr[KeyWord],
        [IntToHex(Integer(VerData^) and $FFFF, 4),
         IntToHex((Integer(VerData^) shr 16) and $FFFF, 4)]);
      VerQueryValue(VerInfoBuf, PChar(PathLocale), VerData, VerDataLen);
      if VerDataLen > 0 then
      begin
        // VerDataはゼロで終わる文字列ではないことに注意
        result := '';
        SetLength(result, VerDataLen);
        StrLCopy(PChar(result), VerData, VerDataLen);
        result := Copy(result, 1, length(result)-1);
      end;
    finally
      // 解放
      FreeMem(VerInfoBuf);
    end;
  end;
end;

function ENumWindowsProc(hwindow: hWnd; lParam: LPARAM): bool; stdcall;
var
  PC: PChar;
  Len: integer;
  Name: string;
  PId: cardinal;
begin
  Result := false;
  if hWindow <> 0 then
    begin
    GetMem(PC, 100);
    GetWindowThreadProcessId(hWindow, PId);
    Len := GetWindowtext(hWindow, PC, 100);
    SetString(Name, PC, Len);

    if (Pos(ExtractFileName(frmMain.exPFileName), name) <> 0) and (Pos(frmMain.AppName, name) = 0) then
      begin
      PostMessage(hWindow, WM_CLOSE, 0, 0);
      result := False;
      end;
    result := True;
    end;
end;

//-----------------------------------------------------------------------------
//  ShellExecuteExで指定ファイルを実行
//  ShellExcuteExの使用にはusesにShellAPIが必要
//-----------------------------------------------------------------------------
function RunExeFile(hWnd: HWND; AFile: String; AParameters: String; Verb: String): Cardinal;
var
  LInfo : TShellExecuteInfo;
  LRet  : Cardinal;
begin
  FillChar(LInfo, SizeOf(LInfo), 0);
  LInfo.cbSize := SizeOf(LInfo);
  LInfo.Wnd    := hWnd;

  LInfo.fMask  := SEE_MASK_FLAG_DDEWAIT
               or SEE_MASK_FLAG_NO_UI
               or SEE_MASK_NOCLOSEPROCESS;
  LInfo.lpVerb := PChar(Verb);

  LInfo.lpFile       := PChar(AFile);
  LInfo.lpParameters := PChar(AParameters);
  LInfo.nShow        := SW_SHOW;

  ShellExecuteEx(@LInfo);

//  frmMain.ProcessID := 0;
  if LInfo.hInstApp >= 33 then    //ShellExecuteExは成功するとhInstAppに33以上の値を返す
    begin
    repeat                        //プロセスが生成されるまで待つ
      LRet := WaitForInputIdle(LInfo.hProcess, 50);
      Application.ProcessMessages;
    until LRet <> WAIT_TIMEOUT;
//    frmMain.ProcessID := Linfo.hProcess;    // 必ずしもProsessIdが得られるとは限らない　失敗
    CloseHandle(LInfo.hProcess);
  end;
  Result := LInfo.hInstApp;
end;


//*
//* 定数用３項演算子 (TrueValue, FalseValue は常に評価されます)
//*
function IIf(const Condition: boolean; const TrueValue, FalseValue: string): string;
begin
  if Condition then
    result := TrueValue
  else
    result := FalseValue;
end;

function IIf(const Condition: boolean; const TrueValue, FalseValue: integer): integer;
begin
  if Condition then
    result := TrueValue
  else
    result := FalseValue;
end;

function IIf(const Condition: boolean; const TrueValue, FalseValue: cardinal): cardinal;
begin
  if Condition then
    result := TrueValue
  else
    result := FalseValue;
end;

function IIf(const Condition: boolean; const TrueValue, FalseValue: currency): currency;
begin
  if Condition then
    result := TrueValue
  else
    result := FalseValue;
end;

function IIf(const Condition: boolean; const TrueValue, FalseValue: TObject): TObject;
begin
  if Condition then
    result := TrueValue
  else
    result := FalseValue;
end;

end.
