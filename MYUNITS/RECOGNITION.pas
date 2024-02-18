unit RECOGNITION;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Math;

type
  TVar = set of char;

  procedure Preparation(var s: string; variables: TVar);
  function ChangeVar(s: string; c: char; value: extended): string;
  function Recogn(st: string; var Num: extended): boolean;

implementation


procedure Preparation(var s: string; variables: TVar);
const
  operators: set of char = ['+','-','*', '/', '^'];
var
  i: integer;
  figures: set of char;
begin
  figures := ['0','1','2','3','4','5','6','7','8','9', DecimalSeparator] + variables;

  // " "
  repeat
    i := pos(' ', s);
    if i <= 0 then
      break;
    delete(s, i, 1);
  until
    1 = 0;

  s := LowerCase(s);

  // ".", ","
  if DecimalSeparator = '.' then
  begin
    i := pos(',', s);
    while i > 0 do
    begin
      s[i] := '.';
      i := pos(',', s);
    end;
  end
  else
  begin
    i := pos('.', s);
    while i > 0 do begin
      s[i] := ',';
      i := pos('.', s);
    end;
  end;

  // Pi
  repeat
    i := pos('pi', s);
    if i <= 0 then
      break;
    delete(s, i, 2);
    insert(FloatToStr(Pi), s, i);
  until
    1 = 0;

  // ":"
  repeat
    i := pos(':', s);
    if i <= 0 then
      break;
    s[i] := '/';
  until
    1 = 0;

  // |...|
  repeat
    i := pos('|', s);
    if i <= 0 then
      break;
    s[i] := 'a';
    insert('bs(', s, i + 1);
    i := i + 3;
    repeat
      i := i + 1
    until
      (i > Length(s)) or (s[i] = '|');
    if s[i] = '|' then
      s[i] := ')';
  until
    1 = 0;

  // #...#
  i := 1;
  repeat
    if s[i] in figures then
    begin
      insert('#', s, i);
      i := i + 2;
      while (s[i] in figures) do
        i := i + 1;
      insert('#', s, i);
      i := i + 1;
    end;
    i := i + 1;
  until
    i > Length(s);
end;

function ChangeVar(s: string; c: char; value: extended): string;
var
  p: integer;
begin
  result := s;
  repeat
    p := pos(c, result);
    if p <= 0 then
      break;
    delete(result, p, 1);
    insert(FloatToStr(value), result, p);
  until
    1 = 0;
end;

function Recogn(st: string; var Num: extended): boolean;
const
  pogr = 1E-5;
var
  p, p1: integer;
  i, j: integer;
  v1, v2: extended;
  func: (fNone, fSin, fCos, fTg, fCtg, fArcsin, fArccos,
    fArctg, fArcctg, fAbs, fLn, fLg, fExp);
  Sign: integer;
  s: string;
  s1: string;

function FindLeftValue(p: integer; var Margin: integer;
  var Value: extended): boolean;
var
  i: integer;
begin
  i := p - 1;
  repeat
    i := i - 1
  until
    (i <= 0) or (s[i] = '#');
  Margin := i;
  try
    Value := StrToFloat(copy(s, i + 1, p - i - 2));
    result := true;
  except
    result := false
  end;
  delete(s, i, p - i);
end;

function FindRightValue(p: integer; var Value: extended): boolean;
var
  i: integer;
begin
  i := p + 1;
  repeat
    i := i + 1
  until
    (i > Length(s)) or (s[i] = '#');
  i := i - 1;
  s1 := copy(s, p + 2, i - p - 1);
  result := TextToFloat(PChar(s1), value, fvExtended);
  delete(s, p + 1, i - p + 1);
end;

procedure PutValue(p: integer; NewValue: extended);
begin
  insert('#' + FloatToStr(v1) + '#', s, p);
end;

begin
  Result := false;
  s := st;

  // ()
  p := pos('(', s);
  while p > 0 do
  begin
    i := p;
    j := 1;
    repeat
      i := i + 1;
      if s[i] = '(' then
        j := j + 1;
      if s[i] = ')' then
        j := j - 1;
    until
      (i > Length(s)) or (j <= 0);
    if i > Length(s) then
      s := s + ')';
    if Recogn(copy(s, p + 1, i - p - 1), v1) = false then
      Exit;
    delete(s, p, i - p + 1);
    PutValue(p, v1);

    p := pos('(', s);
  end;

  // sin, cos, tg, ctg, arcsin, arccos, arctg, arcctg, abs, ln, lg, log, exp
  repeat
    func := fNone;
    p1 := pos('sin', s);
    if p1 > 0 then
    begin
      func := fSin;
      p := p1;
    end;
    p1 := pos('cos', s);
    if p1 > 0 then
    begin
      func := fCos;
      p := p1;
    end;
    p1 := pos('tg', s);
    if p1 > 0 then
    begin
      func := fTg;
      p := p1;
    end;
    p1 := pos('ctg', s);
    if p1 > 0 then
    begin
      func := fCtg;
      p := p1;
    end;
    p1 := pos('arcsin', s);
    if p1 > 0 then
    begin
      func := fArcsin;
      p := p1;
    end;
    p1 := pos('arccos', s);
    if p1 > 0 then
    begin
      func := fArccos;
      p := p1;
    end;
    p1 := pos('arctg', s);
    if p1 > 0 then
    begin
      func := fArctg;
      p := p1;
    end;
    p1 := pos('arcctg', s);
    if p1 > 0 then
    begin
      func := fArcctg;
      p := p1;
    end;
    p1 := pos('abs', s);
    if p1 > 0 then
    begin
      func := fAbs;
      p := p1;
    end;
    p1 := pos('ln', s);
    if p1 > 0 then
    begin
      func := fLn;
      p := p1;
    end;
    p1 := pos('lg', s);
    if p1 > 0 then
    begin
      func := fLg;
      p := p1;
    end;
    p1 := pos('exp', s);
    if p1 > 0 then
    begin
      func := fExp;
      p := p1;
    end;
    if func = fNone then
      break;

    case func of
      fSin, fCos, fCtg, fAbs, fExp: i := p + 2;
      fArctg: i := p + 4;
      fArcsin, fArccos, fArcctg: i := p + 5;
      else
        i := p + 1;
    end;

    if FindRightValue(i, v1) = false then
      Exit;
    delete(s, p, i - p + 1);
    case func of
      fSin: v1 := sin(v1);
      fCos: v1 := cos(v1);
      fTg:
      begin
        if abs(cos(v1)) < pogr then
          Exit;
        v1 := sin(v1) / cos(v1);
      end;
      fCtg:
      begin
        if abs(sin(v1)) < pogr then
          Exit;
        v1 := cos(v1) / sin(v1);
      end;
      fArcsin:
      begin
        if Abs(v1) > 1 then
          Exit;
        v1 := arcsin(v1);
      end;
      fArccos:
      begin
        if abs(v1) > 1 then
          Exit;
        v1 := arccos(v1);
      end;
      fArctg: v1 := arctan(v1);
      // fArcctg: v1 := arcctan(v1);
      fAbs: v1 := abs(v1);
      fLn:
      begin
        if v1 < pogr then
          Exit;
        v1 := Ln(v1);
      end;
      fLg:
      begin
        if v1 < 0 then
          Exit;
        v1 := Log10(v1);
      end;
      fExp: v1 := exp(v1);
    end;
    PutValue(p, v1);
  until
    func = fNone;

  // power
  p := pos('^', s);
  while p > 0 do
  begin
    if FindRightValue(p, v2) = false then
      Exit;
    if FindLeftValue(p, i, v1) = false then
      Exit;
    if (v1 < 0) and (abs(Frac(v2)) > pogr) then
      Exit;
    if (abs(v1) < pogr) and (v2 < 0) then
      Exit;
    delete(s, i, 1);
    v1 := Power(v1, v2);
    PutValue(i, v1);
    p := pos('^', s);
  end;

  // *, /
  p := pos('*', s);
  p1 := pos('/', s);
  if (p1 > 0) and ((p1 < p) or (p <= 0)) then
    p := p1;
  while p > 0 do
  begin
    if FindRightValue(p, v2) = false then
      Exit;
    if FindLeftValue(p, i, v1) = false then
      Exit;
    if s[i] = '*' then
      v1 := v1 * v2
    else
    begin
      if abs(v2) < pogr then
        Exit;
      v1 := v1 / v2;
    end;
    delete(s, i, 1);
    PutValue(i, v1);

    p := pos('*', s);
    p1 := pos('/', s);
    if (p1 > 0) and ((p1 < p) or (p <= 0)) then
      p := p1;
  end;

  // +, -
  Num := 0;
  repeat
    Sign := 1;
    while (Length(s) > 0) and (s[1] <> '#') do
    begin
      if s[1] = '-' then
        Sign := -Sign
      else
      if s[1] <> '+' then
        Exit;
      delete(s, 1, 1);
    end;
    if FindRightValue(0, v1) = false then
      Exit;
    if Sign < 0 then
      Num := Num - v1
    else
      Num := Num + v1;
  until
    Length(s) <= 0;

  Result := true;
end;

end.


