*****************************************************************************
*                                                                           *
* Arquivo  : Ct3001.prg                Update : 9:40:50  7/22/1992          *
*                                                                           *
* Sistema  : Sistema de contabilidade                                       *
*                                                                           *
* Objetivo : Manutencao de lancamentos contabeis                            *
*                                                                           *
*****************************************************************************

C_Barra  = 'W/N'
C_Menu   = 'W/B'
C_Title  = 'W+/BG+'
C_Borda  = 'N/W,W/N'

F1       = '28'
F2       = '-1'
F3       = '-2'
F4       = '-3'
F5       = '-4'
F6       = '-5'
F7       = '-6'
F8       = '-7'
F9       = '-8'
F10      = '-9'

UseCTD002()   && Cadastro de Contas
UseCTD003()   && Cadastro de Historicos
UseCTD004()   && Lancamentos
UseCTD009()   && Cardastro de Arquivos

A03_Inicializa()

A03_Processa()

Close data

Release All

Return

&&=========================================================================&&

Function A03_Inicializa

Public  Called, W_Mes, W_Ano, G_Arquivo , W_Sd_ArqCr , W_Sd_ArqDb

Called      = '        '
G_Arquivo   = ' '
W_Mes       = 0
W_Ano       = 0
W_Sd_ArqCr  = 0
W_Sd_ArqDb  = 0

Set Date    Brit
Set Delete  On
Set Confirm On
Set Cursor  On
Set Score   Off

Return ''

&&=========================================================================&&

Function A03_Processa

A03_Tela1()

Do While LastKey() <> 27

   Select Arquivo

   Seek Called

   If .Not. Found()
      If MsgPrompt (' Arquivo nao existe. Deseja inclui-lo ? ',1)
         A03_08_Inclusao()
         If LastKey()  <>  27
            A03_LePlanilha()
         EndIf
      EndIf
   Else
      A03_12_Manutencao()
      A03_LePlanilha()
   EndIf

   A03_Tela1()

EndDo

Return ''

&&==========================================================================&&

Function A03_Tela1

Set Color To 7/1
Clear

A03_T01(1,1)

Set Key &F2 To A03_InqArq

Set Color To W/G+,W+/G

@ 02,11 Get Called Pict '@!' Valid .Not. Empt(AllTrim(Called))

Read

G_Arquivo = Called

Set Key &F2 To

Return ''

&&=========================================================================&&

Function  A03_T01

Parameters Lin,Col

SetColor (C_Borda)

InitScreen(Lin,Col)

ShowScreen ('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿',0)
ShowScreen ('³ Arquivo:           Mes:    Ano:                                            ³')
ShowScreen ('ÃÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´')
ShowScreen ('³DD³   Conta      ³  Historico   ³    D e b i t o    ³   C r e d i t o       ³')
ShowScreen ('ÃÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('³  ³              ³              ³                   ³                       ³')
ShowScreen ('ÃÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´')
ShowScreen ('³     Saldo do arquivo    >>     ³                   ³                       ³')
ShowScreen ('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')

MakeFoot ('W+/BG','/bg',' /Esc/-Sai  /F2/-Consulta Arquivos/');

Return ('')

&&=========================================================================&&
&& Implementa o modo de consulta dos arquivos

Function A03_InqArq

Declare Tab1[5],Tab2[5]

L_Lin    = 4
L_Col    = 7
L_NLin   = 15
L_NCol   = 55
L_D      = 'D'
L_C      = 'C'

Tab1 [1] = 'I_Arquivo'
Tab1 [2] = 'I_Mes'
Tab1 [3] = 'I_Ano'
Tab1 [4] = 'Rot_Db(I_Debito,L_D)'
Tab1 [5] = 'Rot_Cr(I_Credito,L_C)'

Tab2 [1] = ''
Tab2 [2] = '³'
Tab2 [3] = '³'
Tab2 [4] = '³'
Tab2 [5] = '³'

Select Arquivo

SaveTela = SaveScreen(L_Lin,L_Col,L_Lin+L_NLin+1,L_Col+L_NCol+2)
SaveHelp = SaveScreen(24,1,24,80)

MakeFoot ('W+/BG','/bg',' /Esc/-Sai  /Enter/-Seleciona Arquivo/');

Set Key &F2 To

DrawShadow(L_Lin,L_Col,L_NLin,L_NCol,'B/W','W+/B','Arquivo  MM AA              Debito             Credito','')

Go Top

DbEdit(L_Lin+1,L_Col+1,L_Lin+L_Nlin-1,L_Col+L_NCol-1,Tab1,'A03_Func02','','','',Tab2)

RestScreen(L_Lin,L_Col,L_Lin+L_NLin+1,L_Col+L_NCol+2,SaveTela)
RestScreen(24,1,24,80,SaveHelp)

Set Key &F2 To A03_InqArq

If .Not. Empty(AllTrim(Called))
   KeyBoard(Chr(13))
EndIf

Return ''

&&=========================================================================&&

Function A03_Func02

Parameters P_Mode, P_Field

  Do Case
    Case LastKey() = 27
         Called = '        '
         Return 0
    Case LastKey() = 13
         Called = I_Arquivo
         Return 0
  EndCase

Return 1

&&=========================================================================&&

Function A03_08_Inclusao

Do While .t.

  A03_10_LerTela()

  If LastKey() = 27
     If MsgPrompt (' Deseja abandonar este processo ? ',2)
        KeyBoard Chr(27)
        Exit
     EndIf
  Else
     If MsgPrompt (' Confirma inclusao ? ',1)
        Select Arquivo
        Append Blank
        Replace I_Arquivo With Called
        Replace I_Mes     With W_Mes
        Replace I_Ano     With W_Ano
        Replace I_Debito  With 0
        Replace I_Credito With 0
        Replace I_Status  With  ' '

        Exit
     EndIf
  EndIf
EndDo

Return ''

&&=========================================================================&&

Function A03_10_LerTela

  @ 2,26 Get W_Mes Pict '99'  Valid W_Mes > 0  .and.  W_Mes < 13
  @ 2,34 Get W_Ano Pict '99'  Valid W_Ano > 90

  Read

  W_Sd_ArqDb = 0
  W_Sd_ArqCr = 0


Return ''

&&=========================================================================&&

Function A03_LePlanilha


W_Mes          = I_Mes
W_Ano          = I_Ano
W_Dia          = 0
W_Data         = 0
W_Arquivo      = G_Arquivo
W_Seq          = 0
W_Conta        = ' '
W_CodHist      = ' '
W_Complem      = Replicate(' ',30)
W_Valor        = 0
W_DC           = ' '
W_SaveLancFoot = ' '

Declare Tab1[5],Tab2[5],Tab3[5]

Tab1 [1] = 'SubStr(DtoC(D_Data),1,2)'
Tab1 [2] = 'RotConta(D_Conta)'
Tab1 [3] = 'Rot_Hist(D_CodHist)'
Tab1 [4] = 'Rot_Db(D_Valor,D_DC)'
Tab1 [5] = 'Rot_Cr(D_Valor,D_DC)'

Tab2 [1] = 2
Tab2 [2] = 11
Tab2 [3] = 14
Tab2 [4] = 19
Tab2 [5] = 19

Tab3 [1] = ''
Tab3 [2] = '³'
Tab3 [3] = '³'
Tab3 [4] = '³'
Tab3 [5] = '³'

SaveTela1 = SaveScreen(1,1,24,80)

Select Lancamento

Seek G_Arquivo

Set Filter To D_Arquivo = G_Arquivo

Set Color To  N/W,W/N,,,W+/BG

MakeFoot ('W+/BG','/bg',' /Esc/-Sai  /F1/- Help  /F2/- Inclui Lanc. /F3/- Altera Lanc. /F8/- Exclui Lanc./')
W_SaveLancFoot = SaveScreen(24,1,24,80)

Set Key &F2 To A03_IncLanc()
Set Key &F3 To A03_ChgLanc()
Set Key &F8 To A03_DelLanc()

Do While LastKey() # 27

   A03_SdArq()
   ClearKeyBoard()
   Seek G_Arquivo
   Set Filter To D_Arquivo = G_Arquivo
   DbEdit (6,2,20,74,Tab1,'A03_Funcao','','','',Tab3)
   set filter to

   If W_Sd_ArqDb # W_Sd_ArqCr
      If MsgPrompt(' Saldo difere. Deseja realmente sair ? ',2)
         Set Key &F2 To A03_IncLanc()
         Set Key &F3 To A03_ChgLanc()
         Set Key &F8 To A03_DelLanc()
         Return ''
      EndIf
  EndIf

  If W_Sd_ArqDb = 0  .and.  W_Sd_ArqCr = 0
     Select Arquivo
     Delete
  EndIf

EndDo

Set Key &F2 To
Set Key &F3 To
Set Key &F8 To

Set Filter To

ClearKeyBoard()

RestScreen(1,1,24,80,SaveTela1)

Return ' '

&&=========================================================================&&

Function A03_12_Manutencao

  @ 02,26 Say I_Mes
  @ 02,34 Say I_Ano

  W_Sd_ArqDb = I_Debito
  W_Sd_ArqCr = I_Credito


Return ''

&&=========================================================================&&

Function A03_Funcao

Parameters Mode,FieldNum

  Tec = LastKey()

  @ 05,01 say 'ÃÄÄÅ'

  Do Case
     Case Tec = 27
          Return 0

     Case Tec = 28   && F1 (help)
          Do Case
             Case FieldNum = 2         && Conta
                  A03_ContaHelp()
             Case FieldNum = 3         && Historico
                  A03_HistHelp()
          EndCase

     Case Tec = 253                    && Atualiza Tela e reentra na edicao
          KeyBoard 'xa'
          Return 2

     Case Tec = 254                    && Atualiza Tela
          KeyBoard 'x'
          go top
          Return 2

     Case Tec = 255                    && Sai do DbEdit p/ depois entrar denovo
          Return 0

  EndCase


Return 1

&&=========================================================================&&

Function Rot_Db

  Parameters P_Valor, P_DC

  If P_DC  =  'D'
     Return Transform(P_Valor,"@E 9999,999,999,999.99")
  EndIf

Return '                   '

&&=========================================================================&&

Function Rot_Cr

  Parameters P_Valor, P_DC

  If P_DC  =  'C' .or.  P_DC  =  ' '
     Return Transform(P_Valor,"@E 9999,999,999,999.99")
  EndIf

Return '                   '

&&=========================================================================&&
&& Saldo do Arquivo . O saldo do bd e da memoria sempre sera igual

Function A03_SdArq

  @ 22,35 Say Transform(W_Sd_ArqDb ,"@E 9999,999,999,999.99")
  @ 22,55 Say Transform(W_Sd_ArqCr ,"@E 9999,999,999,999.99")

Return ''

&&=========================================================================&&

Function A03_IncLanc

  Private W_Ct, W_Cc, L_Lin, L_Col

  MakeFoot('W+/BG','/bg',' /Esc/-Sai/                     / M o d o  I n c l u s a o/ ')

  Set Key &F2 To
  Set Key &F3 To
  Set Key &F8 To
  Set Key 97  To

  L_Lin = 20
  L_Col = 1

  L_Conta   = '           '
  W_Ct      = '          '
  W_Hist    = '         '
  W_Complem = Replicate(' ',30)
  W_Db      = 0
  W_Cr      = 0

  LerDeNovo = .t.
  PassaBola = .f.

  Do While LerDeNovo

     LerDeNovo = .f.

     Set Cursor On

     @ L_Lin+00,L_Col+01 Get W_Dia  Pict '99'  Valid(W_Dia > 0 .and. W_Dia < 32)
     @ L_Lin+00,L_Col+04 Get W_Ct   Pict '@!'  Valid(A03_ContaInc())
     @ L_Lin+00,L_Col+19 Get W_Hist Pict '@!'  Valid(A03_HistInc())
     @ L_Lin+00,L_Col+34 Get W_Db   Pict '@E 9999,999,999,999.99' Valid(A03_DbValid())
     @ L_Lin+00,L_Col+54 Get W_Cr   Pict '@E 9999,999,999,999.99' Valid(A03_CrValid())

     Read

  EndDo

  If LastKey() = 27
     RestScreen(24,1,24,80,W_SaveLancFoot)
     Set Key &F2 To A03_IncLanc()
     Set Key &F3 To A03_ChgLanc()
     Set Key &F8 To A03_DelLanc()
     ClearKeyBoard()
     KeyBoard Chr(254)
     Return ''
  EndIf

  W_Conta   = L_Conta
  W_CodHist = W_Hist

  Select Lancamento

  W_Data = CtoD(StrZero(W_Dia,2)+'/'+StrZero(W_Mes,2)+'/'+StrZero(W_Ano,2))

  Append Blank

  Replace D_Data    With W_Data
  Replace D_Arquivo With W_Arquivo
  Replace D_Seq     With W_Seq
  Replace D_Conta   With W_Conta
  Replace D_CodHist With W_CodHist
  Replace D_Complem With W_Complem
  Replace D_Valor   With W_Valor
  Replace D_DC      With W_DC

  Select Arquivo

  If W_DC = 'D'
     W_Sd_ArqDb = W_sd_ArqDb               + W_Valor
     Replace      I_Debito With I_Debito   + W_Valor
  Else
     W_Sd_ArqCr = W_sd_ArqCr               + W_Valor
     Replace      I_Credito With I_Credito + W_Valor
  EndIf

  A03_SdArq()

  Select Lancamento

  Set Key 97 To A03_IncLanc()

  Keyboard Chr(253)

Return ''

&&=========================================================================&&

Function A03_ChgLanc

  Private W_Ct, W_Cc

  If D_Arquivo <> G_Arquivo
     KeyBoard Chr(254)
     Return ''
  EndIf

  MakeFoot ('W+/BG','/bg',' /Esc/-Sai/                    /M o d o  A l t e r a c a o/' );

  Set Key &F2 To
  Set Key &F3 To
  Set Key &F8 To

  L_Lin = 20
  L_Col = 1

  L_Conta = D_Conta

  Select Conta
  Set Order To 1

  Seek L_conta
  W_Ct = B_Apelido

  Select Lancamento

  W_Dia      = Val(SubStr(DtoC(D_Data),1,2))
  W_Hist     = D_CodHist
  W_Complem  = D_Complem
  W_Db       = 0
  W_Cr       = 0
  L_Db       = 0
  L_Cr       = 0

  Inter_Db   = 0

  If D_DC = 'D'
     W_Db  = D_Valor
     L_Db  = D_Valor
  Else
     W_Cr  = D_Valor
     L_Cr  = D_Valor
  EndIf

  LerDeNovo = .t.
  PassaBola = .f.

  Do While LerDeNovo

     LerDeNovo = .f.

     Set Cursor On

     @ L_Lin+00,L_Col+01 Get W_Dia  Pict '99'  Valid(W_Dia > 0 .and. W_Dia < 32)
     @ L_Lin+00,L_Col+04 Get W_Ct   Pict '@!'  Valid(A03_ContaInc())
     @ L_Lin+00,L_Col+19 Get W_Hist Pict '@!'  Valid(A03_HistInc())
     @ L_Lin+00,L_Col+34 Get W_Db   Pict '@E 9999,999,999,999.99' Valid(A03_DbValid())
     @ L_Lin+00,L_Col+54 Get W_Cr   Pict '@E 9999,999,999,999.99' Valid(A03_CrValid())

     Read

  EndDo

  If LastKey() = 27
     RestScreen(24,1,24,80,W_SaveLancFoot)
     Set Key &F2 To A03_IncLanc()
     Set Key &F3 To A03_ChgLanc()
     Set Key &F8 To A03_DelLanc()
     ClearKeyBoard()
     KeyBoard Chr(254)
     Return ''
  EndIf

  W_Conta   = L_Conta
  W_CodHist = W_Hist

  Select Lancamento

  W_Data = CtoD(StrZero(W_Dia,2)+'/'+StrZero(W_Mes,2)+'/'+StrZero(W_Ano,2))

  Replace D_Data    With W_Data
  Replace D_Conta   With W_Conta
  Replace D_CodHist With W_CodHist
  Replace D_Complem With W_Complem
  Replace D_Valor   With W_Valor
  Replace D_DC      With W_DC

  Select Arquivo

  Replace I_Debito  With  I_Debito  - L_Db
  Replace I_Credito With  I_Credito - L_Cr

  W_Sd_ArqDb = W_Sd_ArqDb - L_Db
  W_Sd_ArqCr = W_Sd_ArqCr - L_Cr

  If W_DC = 'D'
     W_Sd_ArqDb = W_sd_ArqDb          + W_Valor
     Replace I_Debito  With I_Debito  + W_Valor
  Else
     W_Sd_ArqCr = W_sd_ArqCr          + W_Valor
     Replace I_Credito With I_Credito + W_Valor
  EndIf

  A03_SdArq()

  Select Lancamento

  RestScreen(24,1,24,80,W_SaveLancFoot)

  Set Key &F2 To A03_IncLanc()
  Set Key &F3 To A03_ChgLanc()
  Set Key &F8 To A03_DelLanc()

  Keyboard Chr(254)

Return ''

&&=========================================================================&&

Function A03_DelLanc

  Set Key &F2 To
  Set Key &F3 To
  Set Key &F8 To

  If D_Arquivo <> G_Arquivo
     KeyBoard Chr(254)
     Return ''
  EndIf

  If .Not. MsgPrompt(' Confirma Exclusao ? ',1)
      Set Key &F2 To A03_IncLanc()
      Set Key &F3 To A03_ChgLanc()
      Set Key &F8 To A03_DelLanc()
      Keyboard Chr(254)
      Return ''
  Endif

  L_Db    = 0
  L_Cr    = 0
  D_valor = 0

  Select lancamento

  Set Filter to D_Arquivo = G_Arquivo

  If D_DC = 'D'
     L_Db  = D_Valor
  Else
     L_Cr  = D_Valor
  EndIf

  W_Sd_ArqDb = W_Sd_ArqDb - L_Db
  W_Sd_ArqCr = W_Sd_ArqCr - L_Cr

  Select Arquivo

  Replace I_Debito  With  I_Debito  - L_Db
  Replace I_Credito With  I_Credito - L_Cr

  A03_SdArq()

  Select Lancamento
  delete

  Set Key &F2 To A03_IncLanc()
  Set Key &F3 To A03_ChgLanc()
  Set Key &F8 To A03_DelLanc()

  Select Lancamento

  Set Filter to D_Arquivo = G_Arquivo

  Keyboard Chr(254)

Return ''

&&=========================================================================&&
&& Leitura da conta

Function A03_ContaInc

  If .Not. Empt(AllTrim(W_Ct))
     Select Conta
     Set Order To 2
     Seek W_Ct
     If Found()
        L_Conta = B_Conta
        Select Lancamento
        Return .t.
     EndIf
  EndIf

  Private  L_Lin, L_Col, L_SaveColor, L_SaveTela

  L_Lin = 8
  L_Col = 7

  L_SaveColor = SetColor()
  L_SaveTela  = SaveScreen(L_Lin,L_Col,L_Lin+7,L_Col+46)

  DrawShadow(L_Lin,L_Col,6,44,'B/W','B/W',' C o n t a ','')
  SetColor('B/W')
  @L_Lin+2,L_Col+2  Say 'Apelido:'
  @L_Lin+2,L_Col+21 Say 'Conta:'

  L_G1 = 0
  L_G2 = 0
  L_G3 = 0
  L_G4 = 0
  L_G5 = 0
  L_G6 = 0
  L_Apelido = W_Ct
  L_Desc    = Replicate(' ',40)

  Clear Gets

  Do While LastKey() # 27

     @L_Lin+2,L_Col+10 Get L_Apelido Pict '@!'  Valid A03_Apelido()
     @L_Lin+2,L_Col+27 Get L_G1      Pict '9'
     @L_Lin+2,L_Col+29 Get L_G2      Pict '9'
     @L_Lin+2,L_Col+31 Get L_G3      Pict '99'
     @L_Lin+2,L_Col+34 Get L_G4      Pict '99'
     @L_Lin+2,L_Col+37 Get L_G5      Pict '99'
     @L_Lin+2,L_Col+40 Get L_G6      Pict '999' Valid A03_Ct()
     Read

     If LastKey() = 27
        Loop
     EndIf

     @L_Lin+2,L_Col+10 Say B_Apelido Pict '@!'
     @L_Lin+2,L_Col+27 Say L_G1      Pict '9'
     @L_Lin+2,L_Col+29 Say L_G2      Pict '9'
     @L_Lin+2,L_Col+31 Say L_G3      Pict '99'
     @L_Lin+2,L_Col+34 Say L_G4      Pict '99'
     @L_Lin+2,L_Col+37 Say L_G5      Pict '99'
     @L_Lin+2,L_Col+40 Say L_G6      Pict '999'
     @L_Lin+4,L_Col+2  Say B_Desc    Pict '@!'

     If MsgPrompt(' Confirma esta conta ? ')
        KeyBoard Chr(27)
     EndIf

  EndDo

  ClearKeyBoard()

  W_Ct = L_Apelido

  Select Lancamento

  SetColor(L_SaveColor)
  RestScreen(L_Lin,L_Col,L_Lin+7,L_Col+46,L_SaveTela)

  LerDeNovo = .t.
  KeyBoard Chr(13)

Return ''

&&=========================================================================&&

Function A03_DbValid

  If W_Db > 0
     W_Valor   = W_Db
     W_DC      = 'D'
     KeyBoard Chr(13)
  EndIf

Return .t.

&&=========================================================================&&

Function A03_CrValid

  If LastKey() = 5    && Deixa usar up-arrow quando o campo e zero.
     Return .t.
  EndIf

  If W_Db = 0 .And. W_Cr = 0
     Message('Lancamento nao pode ter valor zerado.')
     Return .f.
  EndIf

  If W_Cr > 0
     W_Valor = W_Cr
     W_DC    = 'C'
  EndIf

Return .t.

&&=========================================================================&&

Function A03_Apelido

  If Empty(AllTrim(L_Apelido))
     Return .t.
  EndIf

  Select Conta

  Set Order To 2

  Seek L_Apelido

  If .Not. Found()
     Message(' Apelido nao encontrado ')
     Return .f.
  EndIf

  L_G1 = Val(SubStr(B_Conta,1,1))
  L_G2 = Val(SubStr(B_Conta,2,1))
  L_G3 = Val(SubStr(B_Conta,3,2))
  L_G4 = Val(SubStr(B_Conta,5,2))
  L_G5 = Val(SubStr(B_Conta,7,2))
  L_G6 = Val(SubStr(B_Conta,9,3))

  Clear Gets

Return .t.

&&=========================================================================&&

Function A03_Ct

  L_Conta = StrZero(L_G1,1)+StrZero(L_G2,1)+StrZero(L_G3,2)
  L_Conta = L_Conta + StrZero(L_G4,2)+StrZero(L_G5,2)+StrZero(L_G6,3)

  Select Conta

  Set Order To 1

  Seek L_Conta

  If .Not. Found()
     Message(' Conta nao cadastrada. ')
     Return .f.
  Else
     If B_Analitic # 'S'
        Message(' Conta informada nao e analitica. ')
        Return .f.
     Else
        L_Apelido = B_Apelido
        @L_Lin+2,L_Col+10 Say L_Apelido Pict '@!'
        Return .t.
     EndIf
  EndIf

Return .t.

&&=========================================================================&&
&& Leitura do historico

Function A03_HistInc

  If PassaBola
     PassaBola = .f.
     Return .t.
  EndIf

  Private  L_Lin, L_Col, L_SaveColor, L_SaveTela

  L_Lin = 8
  L_Col = 7

  L_SaveColor = SetColor()
  L_SaveTela  = SaveScreen(L_Lin,L_Col,L_Lin+7,L_Col+46)

  DrawShadow(L_Lin,L_Col,6,34,'B/W','B/W',' H i s t o r i c o ','')
  SetColor('B/W')
  @L_Lin+2,L_Col+2  Say 'Codigo:'

  L_CodHist  = W_Hist
  L_Desc     = Replicate(' ',30)
  L_Complem  = W_Complem

  Clear Gets

  Select Historico

  Seek L_CodHist
  If Found()
     @L_Lin+4,L_Col+2  Say C_Desc    Pict '@!'
  EndIf

  Do While LastKey() # 27

    @ L_Lin+2, L_Col+10 Get L_CodHist Pict '@!'  Valid A03_ValHist()
    @ L_Lin+5, L_Col+02 Get L_Complem Pict '@!'
    Read

    If LastKey() = 27
       Loop
    EndIf

    If MsgPrompt(' Confirma este historico ? ')
       KeyBoard Chr(27)
    EndIf

  EndDo

  ClearKeyBoard()

  W_Hist    = L_CodHist
  W_Complem = L_Complem

  Select Lancamento

  SetColor(L_SaveColor)
  RestScreen(L_Lin,L_Col,L_Lin+7,L_Col+46,L_SaveTela)

  LerDeNovo = .t.
  PassaBola = .t.
  KeyBoard Chr(13) + Chr(13) + Chr(13)

Return ''

&&=========================================================================&&

Function A03_ValHist

  If Empt(AllTrim(L_CodHist))
     Return .t.
  EndIf

  Select Historico

  Seek L_CodHist

  If .Not. Found()
     Message(' Codigo de historico nao cadastrado ')
     Return .f.
  Else
     @L_Lin+4,L_Col+2  Say C_Desc    Pict '@!'
  EndIf

Return .t.

&&=========================================================================&&
&& Expande a descricao da conta

Function A03_ContaHelp

  If Eof()
     Return ''
  EndIf

  L_Lin = 8
  L_Col = 7

  L_SaveColor = SetColor()
  L_SaveTela  = SaveScreen(L_Lin,L_Col,L_Lin+7,L_Col+46)

  DrawShadow(L_Lin,L_Col,6,44,'B/W','B/W',' C o n t a ','')
  SetColor('B/W')

  @L_Lin+2,L_Col+2  Say 'Conta:'
  @L_Lin+2,L_Col+26 Say 'Apelido:'

  L_Conta = D_Conta

  Select Conta

  Seek L_Conta

  If .Not. Found()
     Message(' Conta deletada.')
     Select Lancamento
     SetColor(L_SaveColor)
     RestScreen(L_Lin,L_Col,L_Lin+7,L_Col+46,L_SaveTela)
     Return ''
  EndIf

  L_G1 = SubStr(B_Conta,1,1)
  L_G2 = SubStr(B_Conta,2,1)
  L_G3 = SubStr(B_Conta,3,2)
  L_G4 = SubStr(B_Conta,5,2)
  L_G5 = SubStr(B_Conta,7,2)
  L_G6 = SubStr(B_Conta,9,3)

  @L_Lin+2,L_Col+8  Say L_G1
  @L_Lin+2,L_Col+10 Say L_G2
  @L_Lin+2,L_Col+12 Say L_G3
  @L_Lin+2,L_Col+15 Say L_G4
  @L_Lin+2,L_Col+18 Say L_G5
  @L_Lin+2,L_Col+21 Say L_G6
  @L_Lin+2,L_Col+34 Say B_Apelido
  @L_Lin+4,L_Col+2  Say B_Desc

  Message(' Tecle algo para retornar. ')

  Select Lancamento

  SetColor(L_SaveColor)
  RestScreen(L_Lin,L_Col,L_Lin+7,L_Col+46,L_SaveTela)

Return ''

&&=========================================================================&&
&& Help do historico

Function A03_HistHelp

  If Eof()
     Return .t.
  EndIf

  Private  L_Lin, L_Col, L_SaveColor, L_SaveTela

  L_Lin = 8
  L_Col = 7

  L_SaveColor = SetColor()
  L_SaveTela  = SaveScreen(L_Lin,L_Col,L_Lin+7,L_Col+46)

  DrawShadow(L_Lin,L_Col,6,34,'B/W','B/W',' H i s t o r i c o ','')
  SetColor('B/W')
  @L_Lin+2,L_Col+2  Say 'Codigo:'

  L_CodHist  = D_CodHist
  L_Desc     = Replicate(' ',30)
  L_Complem  = D_Complem

  @ L_Lin+2, L_Col+10 Say L_CodHist Pict '@!'

  If .Not. Empt(AllTrim(L_CodHist))
     Select Historico

     Seek L_CodHist
     If Found()
        @L_Lin+4,L_Col+2  Say C_Desc    Pict '@!'
     Else
        Message(' Codigo de historico deletado.')
        Select Lancamento
        SetColor(L_SaveColor)
        RestScreen(L_Lin,L_Col,L_Lin+7,L_Col+46,L_SaveTela)
        Return ''
     EndIf
  EndIf

  @ L_Lin+5, L_Col+02 Say L_Complem Pict '@!'

  Message(' Tecle algo para retornar. ')

  Select Lancamento

  SetColor(L_SaveColor)
  RestScreen(L_Lin,L_Col,L_Lin+7,L_Col+46,L_SaveTela)

Return ''

&&=======================================================================&&

Function A03_Inser

  Do While .t.

     WCod  = Space (08)
     WDesc = Space (30)

     @ 19,23 Say WCod
     @ 19,30 Say WDesc

     @ 19,23 Get WCod  pict "!!!!!!!!"
     Read

     If Empty(WCod) .or. LastKey()=27
        KeyBoard Chr(13)
        Return ('')
     EndIf

     @ 19,23 Say WCod

     Seek Wcod

     If .Not. Eof()
        message("Codigo ja existente")
        loop
     endif

     @ 19,30 Get WDesc pict "@!"
     Read

     If LastKey()=27
        KeyBoard Chr(13)
        Return ('')
     EndIf
     If MsgPrompt(' Confirma a inclusao ? ',1)
        Append Blank
        Replace C_CodHist With WCod
        Replace C_Desc    With WDesc
     EndIf

     Exit

  EndDo

Return ''

&&=========================================================================&&

Function RotConta

  Parameters P_Conta

  Select Conta

  Set Order To 1

  Seek P_Conta

  If .Not. Found()
     L_Ret = P_Conta
  Else
     If Empt(AllTrim(B_Apelido))
        L_Ret = SubStr(B_Desc,1,11)
     Else
        L_Ret = B_Apelido + ' '
     EndIf
  EndIf

  L_Ret = SubStr(L_Ret + Replicate(' ',4),1,14)

  Select Lancamento

Return L_Ret

&&=========================================================================&&

Function Rot_Hist

  Parameters P_CodHist

  L_Compl = D_Complem
  L_Hist  = ''

  If .Not. Empt(AllTrim(P_CodHist))
     Select Historico

     Seek P_CodHist

     If .Not. Found()
        Select Lancamento
        Return 'Nao Cadastrado'
     Else
        L_Hist = RTrim(C_Desc) + ' '
     EndIf
  EndIf

  L_Hist = SubStr(L_Hist + L_Compl + Replicate(' ',14),1,14)

  Select Lancamento

Return L_Hist

