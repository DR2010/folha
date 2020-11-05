*****************************************************************************
*                                                                           *
* Arquivo  : Ct1004.Prg                Update : 11:56:37  7/20/1991         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Manutencao no cadastro de Contas                               *
*                                                                           *
*****************************************************************************

Title      = ' P l a n o   d e   C o n t a s  '

W_Conta    = 0
W_Grau1    = 0
W_Grau2    = 0
W_Grau3    = 0
W_Grau4    = 0
W_Grau5    = 0
W_Grau6    = 0

Sele 0
Use CtD002 Index CtI00201, Cti00202  Alias Conta

A04_00_Fields()            && Inicializa a estrutura dos campos

A04_01_Inicializa()        && Inicializa parametros de processamento

A04_02_Processa()          && Rotina de processamento

Close Data

Release All

Set Color To

Return

&&=========================================================================&&

Function A04_00_Fields

InitFields (05)

MakeStruct ('B_Apelido'  , 10 , 'C' , '@!' , 06 , 18 , 'A04_25')
MakeStruct ('B_Desc'     , 40 , 'C' , '@!' , 08 , 18 , 'A04_18')
MakeStruct ('B_Analitic' , 01 , 'C' , '@!' , 10 , 18 , 'A04_19')
MakeStruct ('B_Natureza' , 01 , 'C' , '@!' , 12 , 18 , 'A04_20')
MakeStruct ('B_Result'   , 01 , 'C' , '@!' , 14 , 18 , 'A04_21')

Return ''

&&=========================================================================&&

Function A04_01_Inicializa

Set Score   Off
Set Delete  On
Set Confirm off
Set Cursor  On

Return ''

&&=========================================================================&&

Function A04_02_Processa

A04_04_Tela1()

Do While LastKey() <> 27

   Select Conta

   Set Order To 1

   Seek W_Conta

   If .Not. Found()
      If MsgPrompt (' Conta nao existe. Deseja inclui-la ? ',1)
         A04_08_Inclusao()
      EndIf
   Else
      A04_12_Manutencao()
   EndIf

   A04_04_Tela1()

EndDo

Return ''

&&=========================================================================&&

Procedure A04_04_Tela1

W_Conta = 0

Set Color To 7/1
Clear

Set Color To W+W/R

@ 0,0 To 23,79  Double
@ 00,02 Say  '                                                                            '

Set Color To /W
@ 00,CalcCenter(00,79,Len(Title)) Say Title

Set Color To 7/1

A04_T01()  && Contem formato da tela

A04_05_Foot0()

A04_06_LimpaVar()

SetValid(.f.)

A04_07_Mostra()

SetValid(.t.)

*Set Key -1 To A04_16_Inquiry  && F2 consulta por Conta

Set Color To W/G+,W+/G

ContaOk = .f.

Do While (.Not. ContaOk)
   @ 03,18 Get W_Grau1 Pict '9'   Valid W_Grau1 # 0
   @ 03,20 Get W_Grau2 Pict '9'
   @ 03,22 Get W_Grau3 Pict '99'
   @ 03,25 Get W_Grau4 Pict '99'
   @ 03,28 Get W_Grau5 Pict '99'
   @ 03,31 Get W_Grau6 Pict '999'

   Read

   If LastKey() = 27
      Return
   EndIf

   ContaOk = A04_24(W_Grau1,W_Grau2,W_Grau3,W_Grau4,W_Grau5,W_Grau6)
EndDo

W_Conta = StrZero(W_Grau1,1)+StrZero(W_Grau2,1)
W_Conta = W_Conta +StrZero(W_Grau3,2)+StrZero(W_Grau4,2)+StrZero(W_Grau5,2)
W_Conta = W_Conta + StrZero(W_Grau6,3)

*Set Key -1 To                   && Desfaz assinalamento da F2

Return

&&=========================================================================&&

Function A04_T01
*                    1         2         3         4         5         6         7
*          01234567890123456789012345678901234567890123456789012345678901234567890123456789

@ 03,1 Say ' Conta         : _ _ __ __ __ ___'


@ 06,1 Say ' Apelido       : __________'

@ 08,1 Say ' Descricao     : ________________________________________'

@ 10,1 Say ' Analitica     : _   (S-Sim)'

@ 12,1 Say ' Natureza      : _   (C-Credora/D-Devedora)'

@ 14,1 Say ' Resultado     : _   (S_Sim)'

Return ''

&&=========================================================================&&

Function A04_05_Foot0

*MakeFoot ('w+/bg','/bg','F1/-Help  /F2/-Modo de consulta  /Esc/-Sai/')
MakeFoot ('w+/bg','/bg','F1/-Help  /Esc/-Sai/')

Return ''

&&=========================================================================&&

Function A04_06_LimpaVar

W_Grau1    = 0
W_Grau2    = 0
W_Grau3    = 0
W_Grau4    = 0
W_Grau5    = 0
W_Grau6    = 0

ClearFields()

Return ''

&&=========================================================================&&

Function A04_07_Mostra

Set Color To N/W,B/W,,,N/G

ShowFields()

Return ''

&&=========================================================================&&

Function A04_08_Inclusao

A04_09_Foot1()

ClearFields()

Do While .t.

  A04_10_LerTela()

  If LastKey() = 27
     If MsgPrompt (' Deseja abandonar este processo ? ',2)
        Exit
     EndIf
  Else
     If MsgPrompt (' Confirma inclusao ? ',1)
        Select Conta
        Append Blank
        Replace B_Conta   With W_Conta
        A04_11_MoveTo()
        Exit
     EndIf
  EndIf
EndDo

Return ''

&&=========================================================================&&

Function A04_09_Foot1

MakeFoot ('W+/BG','/bg','F1/-Help  /Esc/-Exit/');

Return ''

&&=========================================================================&&

Function A04_10_LerTela

Set Color To N/W,B/W,,,N/G

ReadFields()

Return ''

&&=========================================================================&&

Function A04_11_MoveTo

Select Conta

MoveToBank()

Return ''

&&=========================================================================&&

Function A04_12_Manutencao

A04_13_MoveFrom()

A04_07_Mostra()

A04_09_Foot1()

Set Color To W+/R,B/W

@ 24,50  Prompt  ' Consulta '
@ 24,60  Prompt  ' Alteracao '
@ 24,70  Prompt  ' Exclusao '

OpcManut = 1

Menu To OpcManut

Do Case

   Case OpcManut = 2
        A04_14_Alteracao()
   Case OpcManut = 3
        A04_15_Exclusao()

EndCase

KeyBoard Chr(0)

Return ''

&&=========================================================================&&

Function A04_13_MoveFrom

Select Conta

MoveFromBank()

Return ''

&&=========================================================================&&

Function A04_14_Alteracao

A04_09_Foot1()

Do While .t.

  A04_10_LerTela()

  If LastKey() = 27
     If MsgPrompt (' Deseja abandonar este processo ? ',2)
        Exit
     EndIf
  Else
     If MsgPrompt (' Confirma alteracao ? ',1)
        Select Conta
        Seek W_Conta
        A04_11_MoveTo()
        Exit
     EndIf
  EndIf
EndDo

Return ''

&&=========================================================================&&

Function A04_15_Exclusao

If MsgPrompt (' Confirma exclusao ? ',2)

   Select Conta
   Seek W_Conta
   Delete

EndIf

Return ''

&&=========================================================================&&

Function A04_16_Inquiry

Set Key -1 To

Declare Tab1[2],Tab2[2],Tab3[2]

private called

called = 0
Tab1 [1] = 'B_Conta'
Tab1 [2] = 'B_Desc'

Tab2 [1] = 11
Tab2 [2] = 40

Tab3 [1] = ''
Tab3 [2] = '   '

Save Screen To SalvaTela

DrawShadow(3,7,17,65,'B/W','W+/B')

A04_17_FootKey()

@ 3,09 Say '   Conta   '
@ 3,22 Say ' Descricao  '

Select Conta

Set Color To  W+/B,N/W+,,,W+/BG

Called = DbShow (5,8,14,63,Tab1,Tab2,Tab3,'B_Conta',' ')

If Called <> 0
   KeyBoard Chr(13)
   @ 18,16 say '** called ****'+called+'****'
   ?type('called')
   Wait '*******************' to aa
Else
   Called = 0
EndIf

Restor Screen From SalvaTela

Set Key -1 To A04_16_Inquiry

Return ' '

&&=========================================================================&&

Function A04_17_FootKey

MakeFoot ('W+/BG','/bg','F1/-help  /Enter/-Seleciona cliente  /Esc/-Sai/');

Return ''

&&=========================================================================&&

Function A04_18

Parameter  Campo

  If Empt(Campo)
     Return(.f.)
  EndIf

Return .t.

&&=========================================================================&&
&& Critica opcao de analitico

Function A04_19

Parameter  Campo

  If (Campo # ' ') .and.  (Campo # 'S')
     Message(' Informe (S) se for conta analitica ou deixe em branco ')
     Return(.f.)
  EndIf

Return .t.

&&=========================================================================&&
&& Critica opcao da natureza da conta

Function A04_20

Parameter  Campo

  If W_Grau2 # 0
     If Campo # ' '
        Message(' Este campo so deve ser informado p/ grupos. ')
        Return .f.
     EndIf
     Return .t.
  EndIf

  If (Campo # 'C') .and.  (Campo # 'D')
     Message(' Informe (C) Credora ou (D) devedora. ')
     Return(.f.)
  EndIf

Return .t.

&&=========================================================================&&
&& Critica opcao da conta de resultado

Function A04_21

Parameter  Campo

  If W_Grau2 # 0
     If Campo # ' '
        Message(' Este campo so deve ser informado p/ grupos. ')
        Return .f.
     EndIf
     Return .t.
  EndIf

  If (Campo # 'S') .and.  (Campo # ' ')
     Message(' Informe (S) Se for grupo de resultado ou deixe em branco ')
     Return(.f.)
  EndIf

Return .t.

&&=========================================================================&&

Function A04_24

Parameter  G1, G2, G3, G4, G5, G6

  Private Called, TabGrau[6], FlgZero, I

  TabGrau[1] = G1
  TabGrau[2] = G2
  TabGrau[3] = G3
  TabGrau[4] = G4
  TabGrau[5] = G5
  TabGrau[6] = G6

  FlgZero = .f.

  I = 1
  Do While I < 7
     If TabGrau[I] = 0
        FlgZero = .t.
     Else
        If FlgZero
           Message(' Grau superior nao informado : ' + StrZero(I,1))
           Return .f.
        EndIf
     EndIf
     I = I + 1
  EndDo

  IF     G6 > 0
         G6 = 0
  ElseIf G5 > 0
         G5 = 0
  ElseIf G4 > 0
         G4 = 0
  ElseIf G3 > 0
         G3 = 0
  ElseIf G2 > 0
         G2 = 0
  Else
         Return .t.
  EndIf

  Select Conta

  Called = StrZero(G1,1)+StrZero(G2,1)+StrZero(G3,2)+StrZero(G4,2)+StrZero(G5,2)+StrZero(G6,3)

  Seek Called

  If .Not. Found()
     Message(' Grau superior nao cadastrado. ')
     Return .f.
  EndIf

Return .t.

&&=========================================================================&&

Function A04_25

Parameter  Campo

  If Empt(Campo)
     Return .t.
  EndIf

  Select Conta

  Set Order To 2        && Aponta p/ apelido

  Set Filter To B_Conta # W_Conta

  Seek Campo

  Set Filter To

  If Found()
     Message(' Apelido ja utilizado p/ outra conta ')
     Set Order  To 1
     Return .f.
  EndIf

  Set Order To 1

Return .t.

&&=========================================================================&&


