&&=========================================================================&&
&&                                                                         &&
&& Arquivo  : Lib2.Prg                   Update : 14/06/92                 &&
&&                                                                         &&
&&=========================================================================&&
&& Funcao : EditDb                                                         &&
&&                                                                         &&
&& Lin,Col       - Coordenadas iniciais                                    &&
&& Lines,Columns - Numero de linhas e colunas da janela                    &&
&& Fields        - Tabela contendo nome dos campos                         &&
&& Leng          - Tabela contendo tamanho de cada campo                   &&
&& Divisors      - Tabela contendo os divisores dos campos                 &&
&&

Function EditDb

Parameters Lin,Col,Lines,Columns,Fields,Leng,Divisors

Declare TabRec [Lines]

If (Len(Fields) <> Len(Leng)) .Or. (Len(Fields) <> Len(Divisors))
   @ 0,0 Say 'Numero de elementos das tabelas diferem'
   Wait
   Return(0)
EndIf

A = 1
B = 1

ClearKeyBoard()

Do While LastKey() <> 27

   Do Case
      Case LastKey() = 13
           Inter = TabKey [A]
           Do Case
              Case Type ('Inter') = 'C'
                   If Inter <> ' '
                      Return (Inter)
                   EndIf
              Case Type ('Inter') = 'N'
                   If Inter <> 0
                      Return (ZeroInter)
                   EndIf
           EndCase

      Case LastKey() = 3           && PgDn
           If .Not. Eof()
              RegLidos = Lib1EncheTab()
              A = 1
           EndIf

      Case LastKey() = 18          && PgUp
           Skip (Lines * -2)
           RegLidos = Lib1EncheTab()
           A = 1

      OtherWise
           RegLidos = Lib1EncheTab()

   EndCase

   A = Achoice (Lin,Col,Lin+Lines,Col+Columns,TabRec,.t.,'Lib1Special',A,A)

EndDo

Return (' ')

&&=========================================================================&&

Function  Lib1EncheTab

   Afill (TabRec,'')
   I=1
   Do While I<=Lines .And. (.Not. Eof())
      For J=1 To Len(Fields)
       Aux = Fields[J]
       AuxPar = &Aux
       TabRec[I] = TabRec[I] + Divisors[J] + Lib1GetStr(AuxPar,Leng[J])
      Next
      I=I+1
      Skip
   EndDo

Return (I-1)

&&=========================================================================&&

Function Lib1GetStr

Parameters Strg,Leng

Do Case
   Case Type ('Strg') = 'N'
        Strg = Str (Strg)
   Case Type ('Strg') = 'D'
        Strg = DToc (Strg)
EndCase

Strg = SubStr (Strg,1,Leng)
Strg = Strg + Replicate (' ',Leng - Len(Strg))

Return (Strg)

&&=========================================================================&&

Function Lib1Special

Parameter Prog,Line,Var

Do Case
   Case LastKey() = 27    && Escape
        Return (0)
   Case LastKey() = 13    && Enter
        Return (1)
   Case LastKey() = 24    && DwArrow
        Return (2)
   Case LastKey() = 5     && UpArrow
        Return (2)
   Case LastKey() = 18    && PgUp
        Return (1)
   Case LastKey() = 3     && PgDn
        Return (1)
   Case LastKey() = 1     && Home
        Return (2)
   Case LastKey() = 6     && End
        Return (2)

EndCase

Return (2)

&&=========================================================================&&

Function MsgPrompt
Parameters Msg,Conf,Idioma

If Type('Idioma') = 'U'
   Idioma = 1
EndIf

Do Case
   Case Idioma = 1          && Portugues
        Opt1 = '  SIM  '
        Opt2 = '  NAO  '
   Case Idioma = 2          && Ingles
        Opt1 = '  YES  '
        Opt2 = '  NO   '
EndCase

SalvaLinha = ' '
SalvaLinha = SaveScreen (24,0,24,79)
SalvaCor   = SetColor()

Set Color To W+/B,N/W+

@ 24,00  Say  Replicate (' ',80)
@ 24,(80-Len(Msg))/2  Say  Msg

@ 24,(80-Len(Msg))/2+Len(Msg)    Prompt  Opt1
@ 24,(80-Len(Msg))/2+Len(Msg)+6  Prompt  Opt2

Tone (500)

Menu To Conf

SetColor (SalvaCor)
RestScreen (24,0,24,79,SalvaLinha)

Return  (Conf = 1)

&&=========================================================================&&

Function Message
Parameters Msg

SalvaLinha = ' '
SalvaLinha = SaveScreen (24,0,24,79)
SalvaCor = SetColor()

Set Color To W/B

@ 24,00  Say  Replicate (' ',80)
@ 24,(80-Len(Msg))/2  Say  Msg

Tone (500)

InKey(0)

SetColor (SalvaCor)
RestScreen (24,0,24,79,SalvaLinha)

Return ('')

&&=========================================================================&&

Procedure DrawWindow
Parameters Lin,Col,Lines,Columns,ColorFrame,ColorFundo,Titulo,CorTitulo

Set Color To &ColorFrame

@ Lin,Col To Lin+Lines,Col+Columns Double

Set Color To &ColorFundo

@ Lin+1,Col+1 Clear To Lin+Lines-1,Col+Columns-1

If Type ('Titulo') = 'U'
   Return
EndIf

If Type ('CorTitulo') <> 'U'
   Set Color To &CorTitulo
EndIf

@ Lin,CalcCenter(Col,Col+Columns,Len(Titulo)) Say Titulo

Return

&&=========================================================================&&

Procedure DrawShadow

Parameters Lin,Col,Lines,Columns,ColorFrame,ColorFundo,Titulo,CorTitulo

Set Color To &ColorFrame

@ Lin,Col To Lin+Lines,Col+Columns Double

Set Color To &ColorFundo

@ Lin+1,Col+1 Clear To Lin+Lines-1,Col+Columns-1

If Type ('Titulo') = 'U'
   Return
EndIf

If Type ('CorTitulo') <> 'U'
   Set Color To &CorTitulo
EndIf

@ Lin,CalcCenter(Col,Col+Columns,Len(Titulo)) Say Titulo

Set Color To

@ Lin+Lines+1,Col+2   Clear To Lin+Lines+1,Col+Columns+2
@ Lin+1,Col+Columns+1 Clear To Lin+Lines+1,Col+Columns+2

Return

&&=========================================================================&&

Procedure Shadow

Parameters Lin,Col,Lines,Columns

Set Color To

@ Lin+Lines+1,Col+2   Clear To Lin+Lines+1,Col+Columns+2
@ Lin+1,Col+Columns+1 Clear To Lin+Lines+1,Col+Columns+2

Return

&&=========================================================================&&

//Function  ZeroFill
//
//Parameters Num,Leng
//
//Num = Replicate ('0',Leng - Len(Num)) + Num
//
//Return (Num)
//
&&=========================================================================&&

Function  CalcCenter

Parameters ColIni,ColFim,Tam

Return ((ColFim-ColIni-Tam)/2+ColIni+1)

&&=========================================================================&&

Function InitFields

Parameters Leng

Public TabCampos[Leng], TabTam   [Leng], TabTipo [Leng]
Public TabPict  [Leng], TabLin   [Leng], TabCol  [Leng]
Public TabValid [Leng], TabWork[Leng]
Public Indx
Public SetValid

Indx     = 0
SetValid = .t.

return('')

&&=========================================================================&&

Function ClearFields

For I=1 To Len (TabCampos)
  Do Case
     Case TabTipo [I] = 'C'
          TabWork [I] = Space (TabTam[I])
     Case TabTipo [I] = 'N'
          TabWork [I] = 0
     Case TabTipo [I] = 'D'
          TabWork [I] = CTod('  /  /  ')
  EndCase
Next

Return ('')

&&=========================================================================&&

Function SetValid

Parameters P_Bool

  SetValid = P_Bool

Return ''

&&=========================================================================&&

Function ShowFields

For I=1 To Len (TabCampos)
  @ TabLin[I],TabCol[I] Say TabWork[I] Pict TabPict[I]
  If SetValid
     AuxValid = 'InterValid'+'('+Str(I)+')'
     Aux=&AuxValid
  EndIf
Next

Return ('')

&&=========================================================================&&

Function ReadFields

For I=1 To Len (TabCampos)
  AuxValid = 'InterValid'+'('+Str(I)+')'
  @ TabLin[I],TabCol[I] Get TabWork [I] Pict TabPict [I] Valid &AuxValid
Next

Read

Return ('')

&&=========================================================================&&

Function InterValid

Parameters I

  If Empt (TabValid [I])
     Return (.t.)
  EndIf

  AuxPar = TabWork  [I]
  AuxRot = TabValid [I] + '(AuxPar)'
  AuxPar = &AuxRot

Return (AuxPar)

&&=========================================================================&&

Function MoveToBank

For I=1 To Len (TabCampos)
  Aux  = TabCampos [I]
  Aux1 = &Aux
  Aux2 = TabWork   [I]
  Do Case
     Case TabTipo [I] = 'N'
          Do Case
             Case Type('Aux1') = 'C'
                  Aux2 = StrZero(Aux2,Len(&Aux))
          EndCase
  EndCase
  Replace &Aux With Aux2
Next

Return ('')

&&=========================================================================&&

Function MoveFromBank

For I=1 To Len (TabCampos)
  Aux  = TabCampos[I]
  Aux1 = &aux
  Do Case
     Case Type('Aux1') = 'C'
          Do Case
             Case TabTipo [I] = 'N'
                  Aux1 = Val(Aux1)
          EndCase
  EndCase
  TabWork [I] = Aux1
Next

Return ('')

&&=========================================================================&&

Function MakeStruct

Parameters  Fi,Le,Ti,Pi,Li,Co,Vl

Indx = Indx + 1

TabCampos [Indx] = Fi
TabTam    [Indx] = Le
TabTipo   [Indx] = Ti
TabPict   [Indx] = Pi
TabLin    [Indx] = Li
TabCol    [Indx] = Co

If Type('Vl') <> 'U'
   TabValid [Indx] = Vl
Else
   TabValid [Indx] = ''
EndIf

Return ('')

&&=========================================================================&&

Function MakeMenu

Parameters Option,LineSum

If Type ('LineSum') = 'N'
   LineMenu = LineMenu + LineSum
Else
   LineMenu = LineMenu + 1
EndIf

@ LineMenu,ColMenu  Prompt  Option

Return ('')

&&=========================================================================&&

Function InitMenu

Parameters Line,Column

Public LineMenu,ColMenu

LineMenu = Line
ColMenu  = Column

Return ('')

&&=========================================================================&&

Function ShowScreen

Parameters Option,LineSum

If Type ('LineSum') = 'N'
   LineScreen = LineScreen + LineSum
Else
   LineScreen = LineScreen + 1
EndIf

@ LineScreen,ColScreen Say Option

Return ('')

&&=========================================================================&&

Function InitScreen

Parameters Line,Column

Public LineScreen,ColScreen

LineScreen = Line
ColScreen  = Column

Return ('')

&&=========================================================================&&

Function MakeFoot

Parameters Cor1,Cor2,Foot

Private SalvaCor

SalvaCor = SetColor()

Set Color To &Cor1

@ 24,00 Say  Replicate (' ',80);

PosIni = 1
PosFim = 1

@ 24,00 Say ''

Do While PosFim <> 0
   PosFim = Pos ('/',Foot,PosIni)
   If PosFim = 0
      Exit
   EndIf
   AuxStr = SubStr (Foot,PosIni,PosFim-PosIni)
   Set Color To &Cor1
   @ Row(),Col() Say AuxStr
   PosIni = PosFim + 1
   PosFim = Pos ('/',Foot,PosIni)
   If PosFim = 0
      Exit
   EndIf
   AuxStr = SubStr (Foot,PosIni,PosFim-PosIni)
   Set Color To &Cor2
   @ Row(),Col() Say AuxStr
   PosIni = PosFim + 1
EndDo

SetColor (SalVacor)

Return ('')

&&=========================================================================&&

Function Pos

Parameters A,B,C

L  = Len(B)
I  = 0
AA = SubStr (B,C+I,1)

Do While AA <> A
   I = I + 1
   If C+I > L
      Return (0)
   EndIf
   AA = SubStr (B,C+I,1)
EndDo

Return (C+I)

&&=========================================================================&&

Function Prt

Parameter Col,Campo,Conteudo,Salto

If Type('Conteudo') # 'U'
   If Empty(Campo)
      AuxCampo = Replicate(Conteudo,Len(Campo))
   Else
      AuxCampo = Campo
   EndIf
Else
   AuxCampo = Campo
EndIf

If Type('Salto') = 'U'
   Salto = 0
EndIf

@ PRow()+Salto,Col Say AuxCampo

Return ('')

&&=========================================================================&&

Function ClearKeyBoard

  KeyBoard Chr(0)
  InKey()

Return ('')

&&=========================================================================&&

Function Comp

Parameters Fator

@ PRow(),0 Say Chr(30)+Fator

Return ('')

&&=========================================================================&&

Function DayWeek

  Parameters Dia

  If Dow(Dia)     = 1
     Return('Domingo')
  ElseIf Dow(Dia) = 2
     Return('Segunda')
  ElseIf Dow(Dia) = 3
     Return('Terca')
  ElseIf Dow(Dia) = 4
     Return('Quarta')
  ElseIf Dow(Dia) = 5
     Return('Quinta')
  ElseIf Dow(Dia) = 6
     Return('Sexta')
  ElseIf Dow(Dia) = 7
     Return('Sabado')
  EndIf

&&=========================================================================&&

Function HoToSe

Parameters HoraMinu

WHora = SubStr(HoraMinu,1,2)
WMinu = SubStr(HoraMinu,3,2)

Return ((Val(WHora) * 60 + Val(WMinu)) * 60)

&&=========================================================================&&

Function ElapSegu

Parameters HoIni,HoFim

WSegIni = HoToSe(HoIni)
WSegFim = HoToSe(HoFim)
WResult = WSegFim - WSegIni
If WResult < 0
   WResult = WResult + (24 * 60 * 60)
EndIf

Return (SeToHo(WResult))

&&=========================================================================&&

Function SeToHo

Parameters WSec

NMin = Int(WSec / 60)
NHor = Int(NMin / 60)
NMin = NMin - (NHor * 60)

Return(StrZero(NHor,2,0)+StrZero(NMin,2,0))

&&=========================================================================&&

Function Compacta

  Parameters L_Fator

  @ Prow(),Pcol() Say Chr(30) + Str(L_Fator,1)

Return ''

&&=========================================================================&&

Function TaSetado

  Parameters P_Byte, P_Bit

  Private I

  For I=1 To (P_Bit - 1)
    If  P_Byte % 2 > 0
        P_Byte = P_Byte -1
    EndIf
    P_Byte = P_Byte / 2
  Next

  If P_Byte % 2 > 0
     Return .t.
  EndIf

Return .f.

&&=========================================================================&&
&& Converte variavel numerica contendo numero de minutos em hora e minutos &&
&& no formato HH:MM                                                        &&

Function MinToHour

  Parameters P_Min

  Private L_HH, L_MM, L_Sinal

  L_Sinal = ' '

  If P_Min < 0
     L_Sinal = '-'
     P_Min = P_Min * -1
  EndIf

  L_HH = StrZero(Int(P_Min / 60),3,0)
  L_MM = StrZero(P_Min % 60,2,0)

Return L_Sinal + L_HH + ':' + L_MM

&&=========================================================================&&
