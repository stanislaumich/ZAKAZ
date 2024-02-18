unit DOSWIN;

interface
type
 TCoding = array[Char] of Char;
 TCounts = array[Char] of LongInt;

const
  DTW : TCoding=(//Dos - > Win
    #$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07,
    #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17,
    #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27,
    #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37,
    #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$41, #$42, #$43, #$44, #$45, #$46, #$47,
    #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F,
    #$50, #$51, #$52, #$53, #$54, #$55, #$56, #$57,
    #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
    #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
    #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7,
    #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7,
    #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7,
    #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
    #$80, #$81, #$82, #$83, #$84, #$C1, #$C2, #$C0,
    #$A9, #$85, #$86, #$87, #$88, #$A2, #$A5, #$89,
    #$8A, #$8B, #$8C, #$8D, #$8E, #$8F, #$E3, #$C3,
    #$90, #$93, #$94, #$95, #$96, #$97, #$98, #$A4,
    #$F0, #$D0, #$CA, #$CB, #$C8, #$D7, #$CD, #$CE,
    #$CF, #$99, #$9A, #$9B, #$9C, #$A6, #$CC, #$9D,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7,
    #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF,
    #$A8, #$B8, #$F7, #$BE, #$B6, #$A7, #$9F, #$B8,
    #$B0, #$A8, #$B7, #$B9, #$B3, #$B2, #$9E, #$A0);

  WTD: TCoding = (//Win - > Dos
    #$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07,
    #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17,
    #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27,
    #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37,
    #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$41, #$42, #$43, #$44, #$45, #$46, #$47,
    #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F,
    #$50, #$51, #$52, #$53, #$54, #$55, #$56, #$57,
    #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
    #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
    #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$B0, #$B1, #$B2, #$B3, #$B4, #$B5, #$B6, #$B7,
    #$B8, #$B9, #$BA, #$BB, #$BC, #$BD, #$BE, #$BF,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7,
    #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7,
    #$F0, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7,
    #$F1, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF,
    #$80, #$81, #$82, #$83, #$84, #$85, #$86, #$87,
    #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F,
    #$90, #$91, #$92, #$93, #$94, #$95, #$96, #$97,
    #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F,
    #$A0, #$A1, #$A2, #$A3, #$A4, #$A5, #$A6, #$A7,
    #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7,
    #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF);

var
  WinCounts: TCounts;
  DosCounts: TCounts;

procedure ClearCoding;// вызвать в первую очередь
procedure CalcString(const S: string);//накопление результата - можно подряд много строк
function TestWinCode: Boolean;// проверки на кодировку
function TestDosCode: Boolean;//

implementation

procedure ClearCoding;
var
  c: Char;
begin
  for c := #1 to #$FF do
  begin
    WinCounts[c] := 0;
    DosCounts[c] := 0;
  end;
end;

procedure CalcString(const S: string);
var
  i: LongInt;
begin
  for i := 1 to LenGth(s) do
  begin
    {Если в Delphi}
    Inc(WinCounts[S[i]]);
    Inc(DosCounts[DTW[S[i]]]);

    {Если в Turbo Pascal
    Inc(WinCounts[WTD[S[i]]]);
    Inc(DosCounts[S[i]]);
    }
  end;
end;

function TestWinCode: Boolean;
begin
  TestWinCode :=
    (WinCounts['О'] + WinCounts['Т'] + WinCounts['Е'] + WinCounts['H']) >=
    (DosCounts['О'] + DosCounts['Т'] + DosCounts['Е'] + DosCounts['H']);
end;

function TestDosCode: Boolean;
begin
  TestDosCode :=
    (WinCounts['О'] + WinCounts['Т'] + WinCounts['Е'] + WinCounts['H']) <
    (DosCounts['О'] + DosCounts['Т'] + DosCounts['Е'] + DosCounts['H']);
end;
begin
 ClearCoding;
end.
 