unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, SynEdit, Vcl.StdCtrls,
  PythonEngine, PythonGUIInputOutput, SynEditPythonBehaviour,
  SynEditHighlighter, SynEditCodeFolding, SynHighlighterPython,
  WrapDelphi,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ExtDlgs;

type
  TForm1 = class(TForm)
    HeaderControl1: THeaderControl;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    HeaderControl2: THeaderControl;
    mePythonOutput: TMemo;
    SynPythonSyn: TSynPythonSyn;
    SynEditPythonBehaviour: TSynEditPythonBehaviour;
    PythonEngine: TPythonEngine;
    PythonGUIInputOutput: TPythonGUIInputOutput;
    btnRun: TButton;
    sePythonCode: TSynEdit;

    PageControl1: TPageControl;
    TabSheetJupyter: TTabSheet;
    TabSheetTranslation: TTabSheet;
    SynEditTranslators: TSynEdit;
    TabSheetOpusTransformers: TTabSheet;
    SynEditTranslation: TSynEdit;
    ButtonTranslate: TButton;
    ButtonClear: TButton;
    ComboBox1: TComboBox;
    LabeledEditJupyToken: TLabeledEdit;
    LabeledEditJupyFilePath: TLabeledEdit;
    PythonModule1: TPythonModule;
    PyDelphiWrapper1: TPyDelphiWrapper;
    CheckBoxStripCellCode: TCheckBox;
    Memo1: TMemo;
    ComboBox2: TComboBox;
    LabeledEdit1: TLabeledEdit;
    OpenTextFileDialog1: TOpenTextFileDialog;
    SpeedButton1: TSpeedButton;
    CheckBoxTransformersOffline: TCheckBox;
    procedure btnRunClick(Sender: TObject);
    procedure PythonEngineBeforeLoad(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonTranslateClick(Sender: TObject);

    procedure ButtonClearClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    const TAB_IX_TRANSLATE = 2;
  private
    { Private declarations }
    _TranslFilename: string;
    _TranslatedText: string;

    jupyCells: TDictionary<String, String>;
    function getJupyToken: string;


    function getJupyFilepath(): string;
    function getJupySocket(): string;

    function getSourceText(): string;
    function getFromLang(): string;
    function getToLang(): string;
    procedure setTranslatedText(text: string);

    function getUseCachedTransofmers(): boolean;
    procedure setUseCachedTransformers(Transformers_Offline: boolean);
  public
    { Public declarations }
    property TranslSource: string read getSourceText;
    property FromLang: string read getFromLang;
    property ToLang: string read getToLang;
    property TranslFilename: string read _TranslFilename;
    property TranslatedText: string write setTranslatedText;
    property UseCachedTransformers: boolean read getUseCachedTransofmers write setUseCachedTransformers;
    property jupyFilepath: string read getJupyFilepath;
    property jupyToken: string read getJupyToken;
    property jupySocket: string read getJupySocket;
    procedure addJupyCellCode(code: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  FileCtrl,
  WrapDelphiVCL,
  System.Rtti,
  System.Threading,
  System.Math,
  UnitPy4DUtils;

const
  defaultDir = 'c:\Users\KoRiF\Documents\Embarcadero\Studio\Projects\AI\ONNX\Zoo\models\vision\classification\mnist\model\mnist\';
  defaultHttpSocket = 'http://localhost:8888';

procedure TForm1.addJupyCellCode(code: string);
begin
  var celltext := code;
  var cellkey := extractJuPyCellKey(code);
  jupyCells.AddOrSetValue(cellkey, code);
end;

procedure TForm1.btnRunClick(Sender: TObject);
begin
  try
//PythonEngine.LoadDll;
    PythonEngine.ExecString(UTF8Encode(sePythonCode.Text));
    var codeTranslaterClasses := '';
    if jupyCells.TryGetValue('HuggingFace-based Opus translators', codeTranslaterClasses) then
    begin
      if CheckBoxStripCellCode.Checked then
        codeTranslaterClasses := includeDelphiInteraction(codeTranslaterClasses);
      SynEditTranslators.Text := codeTranslaterClasses;
    end;

    var codeTranslateApp := '';
    if jupyCells.TryGetValue('application', codeTranslateApp) then
    begin
      if CheckBoxStripCellCode.Checked then
        codeTranslateApp := includeDelphiInteraction(codeTranslateApp);
      SynEditTranslation.Text := codeTranslateApp;
    end;
    ShowMessage('Successfully attached to the Jupyter Notebook!');
    Self.PageControl1.ActivePageIndex := TAB_IX_TRANSLATE;
  except on Ex: EPySystemExit do
  end;
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
begin
  Memo1.Lines.Clear();
end;

procedure TForm1.ButtonTranslateClick(Sender: TObject);
var
  pictBytes : TBytesStream;
begin
  try
    PythonEngine.ExecString(UTF8Encode(SynEditTranslators.Text));
    PythonEngine.ExecString(UTF8Encode(SynEditTranslation.Text));

  except on Ex: EPySystemExit do
    begin
      var code := Ex.EValue;
      if (code='') or (code='0') then
      begin
        ShowMessage('Diagnostic success');
        exit;
      end
      else raise Ex;
    end;
  end;
  ShowMessage(Format('"%s" (%s) --> (%s) "%s"',  [self.TranslSource, getFromLang(), getToLang(), _TranslatedText]));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  var Py := PyDelphiWrapper1.Wrap(Form1);
  PythonModule1.SetVar('delphi_form', Py);
  PythonEngine.Py_DECREF(Py);

  jupyCells := TDictionary<String, String>.Create();
end;

function TForm1.getFromLang: string;
begin
  if (ComboBox1.ItemIndex <> -1) then
    RESULT := ComboBox1.Text
  else
    RESULT := '';
end;

function TForm1.getJupyFilepath: string;
begin
  RESULT := LabeledEditJupyFilePath.Text;
end;

function TForm1.getJupySocket: string;
begin
  RESULT := defaultHttpSocket;
end;

function TForm1.getJupyToken: string;
begin
  RESULT := LabeledEditJupyToken.Text;
end;

function TForm1.getSourceText: string;
begin
  RESULT := Memo1.Lines.Text;
end;

function TForm1.getToLang: string;
begin
  if (ComboBox2.ItemIndex <> -1) then
    RESULT := ComboBox2.Text
  else
    RESULT := '';
end;

function TForm1.getUseCachedTransofmers(): boolean;
begin
  RESULT := Self.CheckBoxTransformersOffline.Checked;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute() then
  begin
    LabeledEdit1.Text := OpenTextFileDialog1.FileName;
    Memo1.Lines.LoadFromFile(OpenTextFileDialog1.FileName);
  end;
end;

procedure TForm1.setTranslatedText(text: string);
begin
  _TranslatedText := text;
end;

procedure TForm1.setUseCachedTransformers(Transformers_Offline: boolean);
begin
 Self.CheckBoxTransformersOffline.Checked := Transformers_Offline;
end;

procedure TForm1.PythonEngineBeforeLoad(Sender: TObject);
begin
  PythonEngine.SetPythonHome('C:\ProgramData\Anaconda3\envs\p_38_idera');
end;


begin
  MaskFPUExceptions(True);
end.
