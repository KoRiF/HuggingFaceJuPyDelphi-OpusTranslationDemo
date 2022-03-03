unit UnitPy4DUtils;

interface

type
  TPythonCodeAdapter = Class
  End;

  function includeDelphiInteraction(pythoncode: string): string;
  function excludeDelphiInteraction(pythoncode: string): string;
  procedure rewrapping(var code: string; commentline, comment2line: string; wrap: boolean);


  function extractTopLine(text: string): string;
  function extractJuPyCellKey(celltext: string): string;
implementation
uses SysUtils, StrUtils;
const
  PYTHONLONGCOMMENT = '####';
  CELLKEY = '$';

  PYLONGMULTYDOCSTRING0 = '"""';
  PYLONGMULTYDOCSTRING1 = '''''''';

  PYCOMMENT0BEGIN = PYLONGMULTYDOCSTRING0 + '%';
  PYCOMMENT0END =   '%' + PYLONGMULTYDOCSTRING0;

  PYCOMMENT1BEGIN = PYLONGMULTYDOCSTRING1 + '$';
  PYCOMMENT1END =   '$' + PYLONGMULTYDOCSTRING1;


  //TODO: switch between UNIX/WINDOWS/MACOS endlines
  PYDELPHIONLYBEGIN = PYLONGMULTYDOCSTRING1 + '{' + #$A
               + PYCOMMENT0BEGIN + #$A + '}'
               + PYLONGMULTYDOCSTRING1;
  PYDELPHIONLYEND = PYLONGMULTYDOCSTRING1 + '{' + #$A
               + PYCOMMENT0END + #$A + '}'
               + PYLONGMULTYDOCSTRING1;
  PYNODELPHIBEGIN = PYLONGMULTYDOCSTRING0 + '{' + #$A
             + PYCOMMENT1BEGIN + #$A + '}'
             + PYLONGMULTYDOCSTRING0;

  PYNODELPHIEND = PYLONGMULTYDOCSTRING0 + '{' + #$A
             + PYCOMMENT1END + #$A + '}'
             + PYLONGMULTYDOCSTRING0;


procedure setDelphiInteraction(var pythoncode: string; active: boolean);
begin
  rewrapping(pythoncode, PYCOMMENT0BEGIN, PYDELPHIONLYBEGIN, active);
  rewrapping(pythoncode, PYCOMMENT0END, PYDELPHIONLYEND, active);
end;

procedure setNativePyInteraction(var pythoncode: string; active: boolean);
begin
  rewrapping(pythoncode, PYCOMMENT1BEGIN, PYNODELPHIBEGIN, active);
  rewrapping(pythoncode, PYCOMMENT1END, PYNODELPHIEND, active);
end;


function includeDelphiInteraction(pythoncode: string): string;
begin
  setDelphiInteraction(pythoncode, true);   //wrap commenting
  setNativePyInteraction(pythoncode, false);   //unwrap commenting
  RESULT := pythoncode;
end;
function excludeDelphiInteraction(pythoncode: string): string;
begin
  setNativePyInteraction(pythoncode, true);
  setDelphiInteraction(pythoncode, false);
  RESULT := pythoncode;
end;
procedure rewrapping(var code: string; commentline, comment2line: string; wrap: boolean);
var orig, target: string;
begin
  if wrap then
  begin
    orig := commentline;
    target := comment2line;
  end
  else
  begin
    orig := comment2line;
    target := commentline;
  end;

  code := StringReplace(code, orig, target, [rfReplaceAll]);
end;


function extractTopLine(text: string): string;
begin
  var posRET := StrUtils.PosEx(#$A, text);
  if posRET > 0 then
    RESULT := text.Substring(0, posRET - 1)
  else
    RESULT := text;
end;



function extractJuPyCellKey(celltext: string): string;
begin
  RESULT := '';
  if not celltext.StartsWith(PYTHONLONGCOMMENT + CELLKEY) then
    exit;

  var line := extractTopLine(celltext);
  if not line.EndsWith(CELLKEY + PYTHONLONGCOMMENT) then
    exit;

  var Lcloses := Length(PYTHONLONGCOMMENT)+1;
  var LL := Length(line);

  RESULT := Trim( line.Substring(Lcloses, LL - 2 * Lcloses - 1) );

end;

end.
