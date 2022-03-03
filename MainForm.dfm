object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'JuPy4Delphi with Opus Translation Demo'
  ClientHeight = 599
  ClientWidth = 942
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Width = 942
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ResizeStyle = rsUpdate
    ExplicitTop = 201
    ExplicitWidth = 383
  end
  object Panel2: TPanel
    Left = 0
    Top = 400
    Width = 942
    Height = 199
    Align = alBottom
    TabOrder = 1
    object HeaderControl2: THeaderControl
      Left = 1
      Top = 1
      Width = 940
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Sections = <
        item
          Alignment = taCenter
          AutoSize = True
          ImageIndex = -1
          Text = 'Python Output'
          Width = 940
        end>
      ParentFont = False
    end
    object mePythonOutput: TMemo
      Left = 1
      Top = 27
      Width = 940
      Height = 171
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 3
    Width = 942
    Height = 391
    Align = alTop
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 26
      Width = 940
      Height = 364
      ActivePage = TabSheetJupyter
      Align = alClient
      TabOrder = 0
      object TabSheetJupyter: TTabSheet
        Caption = 'Jupyter  '
        object sePythonCode: TSynEdit
          Left = 0
          Top = 48
          Width = 932
          Height = 257
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          TabOrder = 0
          UseCodeFolding = False
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Consolas'
          Gutter.Font.Style = []
          Highlighter = SynPythonSyn
          Lines.Strings = (
            '# -*- coding: utf-8 -*-'
            '"""'
            'Created on Sat Feb  5 10:32:58 2022'
            ''
            '@author: KoRiF'
            '"""'
            
              '#https://stackoverflow.com/questions/54475896/interact-with-jupy' +
              'ter-notebooks-via-api'
            'import json'
            'import requests'
            'import datetime'
            'import uuid'
            '#from pprint import pprint'
            
              'from websocket import create_connection #https://pypi.org/projec' +
              't/websocket-client/'
            'import socket'
            ''
            #39#39#39'{'
            '"""%'
            '}'#39#39#39
            'from delphi_module import delphi_form'
            ''
            'notebook_path = delphi_form.jupyFilepath'
            'base = delphi_form.jupySocket #'#39'http://localhost:8888'#39
            'token = delphi_form.jupyToken'
            ''
            #39#39#39'{'
            '%"""'
            '}'#39#39#39
            ''
            ''
            #39#39#39'$'
            '# The token is written on stdout when you start the notebook'
            'notebook_path = '#39'/Untitled.ipynb'#39
            'base = '#39'http://localhost:8888'#39'#'#39'http://localhost:9999'#39
            'token = '#39'67383dec0de54d40908840a56d6589be26a2d28d5abd22b6'#39
            '$'#39#39#39
            ''
            'headers = {'#39'Authorization'#39': '#39'Token '#39' + token}'
            'url = base + '#39'/api/kernels'#39' #'
            'response = requests.post(url,headers=headers)'
            
              'kernel = json.loads(response.text) # get kernel info as json her' +
              'e'
            ''
            '# Load the notebook and get the code of each cell'
            'url = base + '#39'/api/contents'#39' + notebook_path'
            'response = requests.get(url,headers=headers)'
            
              'file = json.loads(response.text) #get notebook content as json h' +
              'ere'
            'filecontent = file['#39'content'#39']'
            'print(filecontent['#39'cells'#39'])'
            
              'code = [ c['#39'source'#39'] for c in file['#39'content'#39']['#39'cells'#39'] if len(c[' +
              #39'source'#39'])>0 ] # get the list of code text blocks'
            ''
            ''
            ''
            ''
            '# Execution request/reply is done on websockets channels'
            '##ws = socket.socket(socket.AF_INET, socket.SOCK_STREAM)'
            
              'ws = create_connection("ws://localhost:8888/api/kernels/"+kernel' +
              '["id"]+"/channels",'
            '     header=headers)'
            ''
            '#ws.connect(("localhost", 8888))'
            ''
            
              'def send_execute_request(code): # do not send anything really, j' +
              'ust create properly formatted request'
            '    msg_type = '#39'execute_request'#39';'
            '    content = { '#39'code'#39' : code, '#39'silent'#39':False }'
            '    hdr = { '#39'msg_id'#39' : uuid.uuid1().hex,'
            '        '#39'username'#39': '#39'test'#39','
            '        '#39'session'#39': uuid.uuid1().hex,'
            '        '#39'data'#39': datetime.datetime.now().isoformat(),'
            '        '#39'msg_type'#39': msg_type,'
            '        '#39'version'#39' : '#39'5.0'#39' }'
            '    msg = { '#39'header'#39': hdr, '#39'parent_header'#39': hdr,'
            '        '#39'metadata'#39': {},'
            '        '#39'content'#39': content }'
            '    return msg'
            ''
            'for piece in code:  # execute the codes cell by cell'
            '    delphi_form.addJupyCellCode(piece)'
            '    '#39#39#39'$'
            '    ws.send(json.dumps(send_execute_request(piece)))'
            '    $'#39#39#39
            ''
            #39#39#39'$'
            
              '# We ignore all the other messages, we just get the code executi' +
              'on output'
            
              '# (this needs to be improved for production to take into account' +
              ' errors, large cell output, images, etc.)'
            'for i in range(0, len(code)):'
            '    msg_type = '#39#39';'
            '    while msg_type != "stream":'
            '        rsp = json.loads(ws.recv())'
            '        msg_type = rsp["msg_type"]'
            '    print(rsp["content"]["text"])'
            ''
            'ws.close()'
            '$'#39#39#39)
        end
        object btnRun: TButton
          Left = 0
          Top = 308
          Width = 75
          Height = 25
          Align = alCustom
          Caption = 'Run'
          TabOrder = 1
          OnClick = btnRunClick
        end
        object LabeledEditJupyToken: TLabeledEdit
          Left = 0
          Top = 21
          Width = 201
          Height = 21
          EditLabel.Width = 118
          EditLabel.Height = 13
          EditLabel.Caption = 'Jupyter Notebook Token'
          TabOrder = 2
          Text = ''
        end
        object LabeledEditJupyFilePath: TLabeledEdit
          Left = 224
          Top = 21
          Width = 233
          Height = 21
          EditLabel.Width = 125
          EditLabel.Height = 13
          EditLabel.Caption = 'Jupyter Notebook filepath'
          TabOrder = 3
          Text = '/AnacondaProjects/OpusNotebook.ipynb'
        end
        object CheckBoxStripCellCode: TCheckBox
          Left = 104
          Top = 311
          Width = 185
          Height = 17
          Caption = 'Strip Cell Delphi Interaction Code'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      object TabSheetOpusTransformers: TTabSheet
        Caption = 'Opus Translaters'
        ImageIndex = 1
        object SynEditTranslators: TSynEdit
          Left = 0
          Top = -10
          Width = 911
          Height = 313
          Align = alCustom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          TabOrder = 0
          UseCodeFolding = False
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Consolas'
          Gutter.Font.Style = []
          Highlighter = SynPythonSyn
        end
      end
      object TabSheetTranslation: TTabSheet
        Caption = 'Translation'
        ImageIndex = 2
        object SpeedButton1: TSpeedButton
          Left = 265
          Top = 19
          Width = 23
          Height = 22
          OnClick = SpeedButton1Click
        end
        object LabeledEdit1: TLabeledEdit
          Left = 3
          Top = 20
          Width = 256
          Height = 21
          EditLabel.Width = 64
          EditLabel.Height = 13
          EditLabel.Caption = 'Translate File'
          TabOrder = 6
          Text = ''
        end
        object SynEditTranslation: TSynEdit
          Left = 294
          Top = -10
          Width = 625
          Height = 313
          Align = alCustom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          TabOrder = 0
          UseCodeFolding = False
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Consolas'
          Gutter.Font.Style = []
          Highlighter = SynPythonSyn
        end
        object ButtonClear: TButton
          Left = 3
          Top = 313
          Width = 105
          Height = 20
          Caption = 'Clear'
          TabOrder = 1
          OnClick = ButtonClearClick
        end
        object ButtonTranslate: TButton
          Left = 294
          Top = 313
          Width = 105
          Height = 20
          Caption = 'Translate!'
          TabOrder = 2
          OnClick = ButtonTranslateClick
        end
        object ComboBox1: TComboBox
          Left = 132
          Top = 312
          Width = 64
          Height = 21
          TabOrder = 3
          Text = 'from...'
          Items.Strings = (
            'en'
            'uk'
            'ru')
        end
        object Memo1: TMemo
          Left = 3
          Top = 47
          Width = 285
          Height = 259
          TabOrder = 4
        end
        object ComboBox2: TComboBox
          Left = 216
          Top = 312
          Width = 64
          Height = 21
          TabOrder = 5
          Text = 'To...'
          Items.Strings = (
            'en'
            'ru'
            'uk')
        end
        object CheckBoxTransformersOffline: TCheckBox
          Left = 424
          Top = 316
          Width = 185
          Height = 17
          Caption = 'Use Cached Offline Transformers'
          TabOrder = 7
        end
      end
    end
    object HeaderControl1: THeaderControl
      Left = 1
      Top = 1
      Width = 940
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Sections = <
        item
          Alignment = taCenter
          AutoSize = True
          ImageIndex = -1
          Text = 'Python Source code'
          Width = 940
        end>
      ParentFont = False
    end
  end
  object SynPythonSyn: TSynPythonSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 760
    Top = 32
  end
  object SynEditPythonBehaviour: TSynEditPythonBehaviour
    Editor = sePythonCode
    Left = 760
    Top = 80
  end
  object PythonEngine: TPythonEngine
    DllPath = 'c:\ProgramData\Anaconda3\envs\p_38_idera'
    OnBeforeLoad = PythonEngineBeforeLoad
    IO = PythonGUIInputOutput
    Left = 880
    Top = 32
  end
  object PythonGUIInputOutput: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = mePythonOutput
    Left = 880
    Top = 80
  end
  object PythonModule1: TPythonModule
    Engine = PythonEngine
    ModuleName = 'delphi_module'
    Errors = <>
    Left = 757
    Top = 149
  end
  object PyDelphiWrapper1: TPyDelphiWrapper
    Engine = PythonEngine
    Left = 877
    Top = 149
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    Left = 269
    Top = 53
  end
end
