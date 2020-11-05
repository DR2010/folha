*****************************************************************************
*                                                                           *
* Arquivo  : Ct5002.Prg                Update : 21:30:15  7/26/1992         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Emissao do razao analitico                                     *
*                                                                           *
*****************************************************************************

Public SaveColor

SaveColor = SetColor()

E2_01_Inicializa()     && Inicializa parametros de processamento

E2_02_Processa()       && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function E2_01_Inicializa

Public Data,W_Livro,W_Pagina,W_Emp,W_Mes,W_Ano,W_Data,W_Hora,W_Empresa
Public W_TotDiaD,W_TotDiaC,W_TotPageD,W_TotPageC,W_TotD,W_TotC,W_DiaAnt
Public W_Conta,W_Grau1,W_Grau2,W_Grau3,W_Grau4,W_Grau5,W_Grau6,W_SaldoCalc
Public W_Dia, W_Ano, W_ContaAnt,W_SaldoAnt,CalledIni,CalledFim
Public W_MesAnt, W_AnoAnt

UseCtD001()
UseCtD002()
UseCtD003()
UseCtD004()
UseCtD005()
UseCtD015()

Select Empresa
Go Top
W_Empresa = A_Nome

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return ''

&&=========================================================================&&

Function E2_02_Processa

E2_03_Tela()

Do While LastKey() <> 27

   Set Device to Printer

   E2_Selecao()
   E2_04_Imprime()
*  E2_09_AtualizaSaldo()
   E2_TotConta()

   Eject

   Set Device to Screen

   E2_03_Tela()

EndDo

Return ''

&&=========================================================================&&

Function E2_03_Tela

L_Lin = 11
L_Col = 33

Titulo = ' Razao Analitico '

DrawShadow(L_Lin,L_Col,04,26,'W+/R+B','W/B',Titulo,'I/N')

@ L_Lin + 2, L_Col + 4  Say 'Mes:'
@ L_Lin + 2, L_Col +14  Say 'Ano:'

Do While .t.

  W_Mes = 0
  W_Ano = 0

  @ L_Lin+2,L_Col+08 Get W_Mes Pict '99'  Valid W_Mes#0
  @ L_Lin+2,L_Col+18 Get W_Ano Pict '99'  Valid W_Ano#0

  Read

  If LastKey() = 27
     Return ''
  EndIf

  Select Empresa
  Go Top
  W_Empresa = A_Nome

  If W_Mes = 1
     W_Aa = W_Ano - 1
     W_Mm = 12
  Else
     W_Aa = W_Ano
     W_Mm = W_Mes - 1
  EndIf

  W_AnoAnt = StrZero(W_Aa,2)
  W_MesAnt = StrZero(W_Mm,2)

  If W_Mes < 12
     W_Aa = W_Ano
     W_Mm = W_Mes + 1
  Else
     W_Aa = W_Ano + 1
     W_Mm = 1
  EndIf

  W_Aa = StrZero(W_Aa,2)
  W_Mm = StrZero(W_Mm,2)

  CalledFim = CtoD('01/' + W_Mm +'/'+ W_Aa)

  W_Ano = StrZero(W_Ano,2)
  W_Mes = StrZero(W_Mes,2)
  CalledIni = CtoD('01/' + W_Mes + '/' + W_Ano)

  Select Status

  Seek W_Ano + W_Mes

  If (.Not. Found()) .Or. (O_Status # 'F')
     Message('Nao foi efetuado fechamento deste periodo.')
     Loop
  EndIf

  Select Lancamento

  Set Order To 3

  Set SoftSeek On
  Seek CalledIni
  Set SoftSeek Off

  If Eof() .Or. D_Data >= CalledFim
     Message('Nao ha lancamento p/ este mes.')
     Loop
  EndIf

  Return ''

EndDo

Return ''

&&=========================================================================&&

Function E2_Selecao

  Sele 0
  Use Ctd013 Alias WorkConta

  Zap

  Select Lancamento

  Set Order To 3

  Go Top

  Set SoftSeek On
  Seek CalledIni
  Set SoftSeek Off

  Do While (.Not. Eof()) .And. (D_Data < CalledFim)
     W_Conta = D_Conta
     W_RecNo = RecNo()

     Select WorkConta
     Append Blank
     Replace M_Conta With W_Conta
     Replace M_RecNo With W_RecNo

     Select Lancamento
     Skip
  EndDo

  Select WorkConta

  Sort To Ctd014 On M_Conta

Return ''

&&=========================================================================&&

Function E2_04_Imprime

W_SaldoCalc = 0
W_TotDiaD   = 0
W_TotDiaC   = 0
W_TotPageD  = 0
W_TotPageC  = 0
W_TotD      = 0
W_TotC      = 0
W_Pagina    = 0
SetPrc()

Select WorkConta
Zap

Use Ctd014  Alias  WorkConta

Go Top

W_Pagina = W_Pagina + 1

E2_5_Cabecalho()

Do While .Not. Eof()

   W_ContaAnt = M_Conta

   W_Grupo = SubStr(M_Conta,1,1) + '0000000000'

   Select Conta
   Seek W_Grupo
   If Found()
      W_Natureza = B_Natureza
   Else
      W_Natureza = 'C'
      @ Prow()+1,0 Say 'Grupo nao cadastrado : ' + W_Grupo
   EndIf

   E2_07_Cabec_Conta()
   E2_10_Cabec()
   E2_SaldoAnt()

   Select WorkConta

   Do While (.Not. Eof()) .And. (M_Conta = W_ContaAnt)

      If (PRow() > 55)
         E2_TotFolha()
         Eject
         W_Pagina = W_Pagina + 1
         E2_5_Cabecalho()
         E2_07_Cabec_Conta()
         E2_10_Cabec()
         E2_11_Transporte()
      EndIf

      E2_MontaDetalhe()

      Select WorkConta
      Skip
   EndDo

   E2_TotConta()

   Select WorkConta

   If .Not. Eof()
      If Prow()+6 > 55
         Eject
         W_Pagina = W_Pagina + 1
         E2_5_Cabecalho()
      EndIf
   EndIf

EndDo

Return ''

&&=========================================================================&&

Function E2_MontaDetalhe

   Select WorkConta

   W_RecNo = M_RecNo

   Select Lancamento
   GoTo W_RecNo

   W_CodHist = D_CodHist
   W_Hist    = AllTrim(D_Complem)

   IF .Not. Empt(AllTrim(W_CodHist))
      Select Historico
      Seek W_CodHist
      If Found()
         W_Hist = AllTrim(C_Desc) + ' ' + W_Hist
      Else
         W_Hist = 'Codigo do Historico nao cadastrado : '+ W_CodHist
      EndIf
   EndIf

   Select Lancamento

   If D_DC = 'D'
      W_Db = D_Valor
      W_Cr = 0
   Else
      W_Db = 0
      W_Cr = D_Valor
   EndIf

   If W_Natureza = 'D'
      W_SaldoCalc = W_SaldoCalc + (W_Db - W_Cr)
   Else
      W_SaldoCalc = W_SaldoCalc + (W_Cr - W_Db)
   EndIf

   W_Valor = Transform(D_Valor,    '@E  99,999,999,999.99')
   W_Saldo = Transform(W_SaldoCalc,'@E 999,999,999,999.99')

   W_Data = SubStr(DtoC(D_Data),1,2)
   W_ArqDoc = AllTrim(D_Arquivo)

   IF D_DC = 'D'
      W_TotDiaD  = W_TotDiaD  + D_Valor
      C_Vl = 68
   Else
      W_TotDiaC  = W_TotDiaC  + D_Valor
      C_Vl = 88
   EndIF

   PRT( 01  , W_Data      , '.' )
   PRT( 04  , '-'         , '.' )
   PRT( 06  , W_Hist      , '.' )
   PRT( 54  , W_ArqDoc    , '.' )
   PRT( C_Vl, W_Valor     , '.' )
   PRT( 109 , W_Saldo     , '.' )

   @ Prow()+1,0

Return ''

&&=========================================================================&&

Function E2_5_Cabecalho

*          1         2         3         4         5         6         7         8         9         0         1         2
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*CTR04                         R  A  Z  A  O    A N A L I T I C O                                             Pag: 99999
*
*                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
*Referencia : XXXXXXXXXXX DE 19XX
*
*Conta : 9.9.99.99.99.999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
* 99 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99.999.999.999.99 99.999.999.999.99 99.999.999.999.99
*

L_Titulo = 'R A Z A O    A N A L I T I C O'

@ Prow()   ,0   Say  Chr(13) + 'CTR02'
@ Prow()   ,113 Say 'Pag: ' + StrZero(W_Pagina,5)
@ Prow()   , CalcCenter(0,132,Len(L_Titulo))  Say  L_Titulo
@ Prow()+2 , CalcCenter(0,132,Len(W_Empresa)) Say  W_Empresa
@ Prow()   , CalcCenter(0,132,Len(W_Empresa)) Say  W_Empresa
@ Prow()+2 ,0   Say 'Referencia : ' + StrMes(Val(W_Mes)) + ' DE 19' + W_Ano
@ Prow()+1 ,0

Return ''

&&=========================================================================&&

Function E2_TotConta

   For I=1 To 2
     PRT( 006 , 'T O T A I S   D A   C O N T A','.')
     W_Valor  = Transform(W_TotDiaD,  '@E  99,999,999,999.99')
     PRT( 069 , W_Valor  , '.' )
     W_Valor  = Transform(W_TotDiaC,  '@E  99,999,999,999.99')
     PRT( 089 , W_Valor  , '.' )
     W_Valor  = Transform(W_SaldoCalc,'@E 999,999,999,999.99')
     PRT( 109 , W_Valor  , '.' )
   Next
   @ Prow()+2,0
   W_TotPageD = W_TotPageD + W_TotDiaD
   W_TotPageC = W_TotPageC + W_TotDiaC
   W_TotDiaD  = 0
   W_TotDiaC  = 0

Return ''

&&=========================================================================&&

Function E2_07_Cabec_Conta

  Select WorkConta

  W_Conta = M_Conta

  W_G1 = SubStr(M_Conta,1,1)
  W_G2 = SubStr(M_Conta,2,1)
  W_G3 = SubStr(M_Conta,3,2)
  W_G4 = SubStr(M_Conta,5,2)
  W_G5 = SubStr(M_Conta,7,2)
  W_G6 = SubStr(M_Conta,9,3)

  W_Ct = W_G1+'.'+W_G2+'.'+W_G3+'.'+W_G4+'.'+W_G5+'.'+W_G6

  W_Conta = M_Conta

  Select Conta

  Seek W_Conta

  If .Not. Found()
     L_Desc = 'Conta nao cadastrada'
  Else
     L_Desc = B_Desc
  EndIf

  @ Prow()+1,0
  For I=1 To 2
    PRT(00,'Conta : ','.')
    PRT(09,W_Ct      ,'.')
    PRT(26,'-'       ,'.')
    PRT(28,L_Desc    ,'.')
  Next

Return ''

&&=========================================================================&&

Function E2_09_AtualizaSaldo

  Select SaldoCt
  Seek W_ContaAnt+W_Ano+W_Mes

  If .Not. Found()
     Append Blank
  EndIf

  Replace E_Conta    With  W_ContaAnt
  Replace E_Ano      With  W_Ano
  Replace E_Mes      With  W_Mes
  Replace E_SaldoAnt With  W_SaldoAnt
  Replace E_Debitos  With  W_TotDiaD
  Replace E_Creditos With  W_TotDiaC
  Replace E_SaldoAtu With  W_SaldoCalc

Return ''

&&=========================================================================&&

Function E2_10_Cabec

   @ Prow()+2,0

   PRT( 01  , 'Dia'         , '.' )
   PRT( 06  , 'Historico'   , '.' )
   PRT( 54  , 'Arquivo/Doc.', '.' )
   PRT( 80  , 'Debito'      , '.' )
   PRT( 99  , 'Credito'     , '.' )
   PRT( 122 , 'Saldo'       , '.' )
   PRT( 01  , '---'         , '.',1)
   PRT( 06  , '---------'   , '.' )
   PRT( 54  , '------------', '.' )
   PRT( 80  , '------'      , '.' )
   PRT( 99  , '-------'     , '.' )
   PRT( 122 , '-----'       , '.' )

   @ Prow()+1,0

Return ''

&&=========================================================================&&

Function E2_11_Transporte

   For I=1 To 2
     PRT( 006 , 'T R A N S P O R T E   D A   P A G I N A   A N T E R I O R')
     W_Valor  = Transform(W_TotDiaD,  '@E  99,999,999,999.99')
     PRT( 069 , W_Valor  , '.' )
     W_Valor  = Transform(W_TotDiaC,  '@E  99,999,999,999.99')
     PRT( 089 , W_Valor  , '.' )
     W_Valor  = Transform(W_SaldoCalc,'@E 999,999,999,999.99')
     PRT( 109 , W_Valor  , '.' )
   Next

   @ Prow()+1,0

Return ''

&&=========================================================================&&

Function E2_TotFolha

   @ Prow()+1,0

   For I=1 To 2
     PRT( 006 , 'S A L D O    A    T R A N S P O R T A R')
     W_Valor  = Transform(W_TotDiaD,   '@E 99,999,999,999.99')
     PRT( 069 , W_Valor  , '.' )
     W_Valor  = Transform(W_TotDiaC,   '@E 99,999,999,999.99')
     PRT( 089 , W_Valor  , '.' )
     W_Valor  = Transform(W_SaldoCalc,'@E 999,999,999,999.99')
     PRT( 109 , W_Valor  , '.' )
   Next

   @ Prow()+1,0

Return ''

&&=========================================================================&&

Function E2_SaldoAnt

  Select WorkConta

  W_Conta = M_Conta

  Select SaldoCt

  Seek W_Conta + W_AnoAnt + W_MesAnt

  If .Not. Found()
     W_SaldoCalc = 0
  Else
     W_SaldoCalc = E_SaldoAtu
  EndIf

  W_SaldoAnt = W_SaldoCalc

  For I=1 To 2
    PRT( 006 , 'S A L D O    A N T E R I O R','.')
    W_Valor  = Transform(W_SaldoCalc,'@E 999,999,999,999.99')
    PRT( 109 , W_Valor  , '.' )
  Next
  @ Prow()+1,0

Return ''

&&=========================================================================&&
