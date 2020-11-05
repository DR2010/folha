*****************************************************************************
*                                                                           *
* Arquivo  : Ct5004.Prg                Update : 11:24:05  7/25/1992         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Emissao do balancete de verificacao.                           *
*                                                                           *
*****************************************************************************

Public SaveColor

SaveColor = SetColor()

UseCtD001()
UseCtD002()
UseCtD004()
UseCtD005()
UseCtD015()

E4_Inicializa()   && Inicializa parametros de processamento
E4_Processa()     && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function E4_Inicializa

Public Data,W_Livro,W_Pagina,W_Emp,W_Mes,W_Ano,W_Data,W_Hora,W_Empresa
Public W_TotDiaD,W_TotDiaC,W_TotPageD,W_TotPageC,W_TotD,W_TotC,W_DiaAnt
Public W_Conta,W_Grau1,W_Grau2,W_Grau3,W_Grau4,W_Grau5,W_Grau6,W_SaldoCalc
Public W_Dia, W_Ano, W_ContaAnt, W_AnoAnt, W_MesAnt, CalledIni, CalledFim

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return ''

&&=========================================================================&&

Function E4_Processa

E4_Tela()

Do While LastKey() <> 27

   Set Device to Printer
*  Set Printer to RazaSin

   E4_Imprime()

   Eject

   Set Device to Screen

   E4_Tela()

EndDo

Return ''

&&=========================================================================&&

Function E4_Tela

L_Lin = 11
L_Col = 33

Titulo = ' Emissao do balancete '

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

  w_aa = w_ano

  if w_mes < 12
     w_mm = w_mes + 1
  else
     w_mm = 01
     w_aa = w_ano + 1
  endif

  If W_Mes = 1
     W_AnoAnt = W_Ano - 1
     W_MesAnt = 12
  Else
     W_AnoAnt = W_Ano
     W_MesAnt = W_Mes - 1
  EndIf

  W_AnoAnt = StrZero(W_AnoAnt,2)
  W_MesAnt = StrZero(W_MesAnt,2)

  W_Ano  = StrZero(W_Ano,2)
  W_Mes  = StrZero(W_Mes,2)

  Called    = '01/' + W_Mes +'/'+ W_Ano
  CalledIni = CtoD('01/' + W_Mes +'/'+ W_Ano)
  CalledFim = CtoD('01/' + StrZero(W_Mm,2) +'/'+ StrZero(W_Aa,2))

  Select Status

  Seek W_Ano + W_Mes

  If (.Not. Found()) .Or. (O_Status # 'F' .And. O_Status # 'A')
     Message('Nao foi efetuado fechamento deste periodo.')
     Loop
  EndIf

  Select Lancamento

  Set Order To 3
  Go Top

  Set  SoftSeek On
  Seek CalledIni
  Set  SoftSeek Off

  If Eof() .or. D_Data >= CalledFim
     Message('Nao ha lancamento neste mes.')
     Loop
  EndIf

  Return ''

EndDo

Return ''

&&=========================================================================&&

Function E4_Imprime

PrimeiraVez = .t.
PrimaConta  = .t.
W_Pagina    = 0
W_G1Atu     = ''
W_G2Atu     = ''
W_G1Ant     = ''
W_G2Ant     = ''
W_TotG1Ant  = 0
W_TotG1Db   = 0
W_TotG1Cr   = 0
W_TotG1Atu  = 0
W_TotG2Ant  = 0
W_TotG2Db   = 0
W_TotG2Cr   = 0
W_TotG2Atu  = 0

SetPrc()
@ 0,0 Say Chr(13)

Select SaldoCt

Set Order To 2

Go Top

Set SoftSeek On
Seek W_Ano + W_Mes + ' '
Set SoftSeek Off

Do While (.Not. Eof()) .And. (E_Ano = W_Ano) .And. (E_Mes = W_Mes)

   If PrimaConta
      PrimaConta = .f.
      W_Pagina = W_Pagina + 1
      E4_Cabecalho()
      W_G1Atu = SubStr(E_Conta,1,1)
      W_G2Atu = SubStr(E_Conta,2,1)
      W_G1Ant = W_G1Atu
      W_G2Ant = W_G2Atu
      E4_IniG1Quebra()
      @ Prow()+1,0
      E4_IniG2Quebra()
   EndIf

   E4_Entra()

   Select SaldoCt

   Skip

EndDo

@ Prow()+1,0
E4_TotSubGrupo()
@ Prow()+2,0
E4_TotGrupo()

Return ''

&&=========================================================================&&

Function E4_IniG1Quebra

  Select Conta

  Seek W_G1Atu + '0000000000'

  If .Not. Found()
     L_Desc = 'Grupo nao cadastrado :' + W_G1Atu
  Else
     L_Desc = B_Desc
  EndIf

  If Prow()+5 > 55
     W_Pagina = W_Pagina + 1
     Eject
     E4_Cabecalho()
  EndIf

  @ Prow()+1,0 Say 'GRUPO : ' + L_Desc
  @ Prow()  ,0 Say 'GRUPO : ' + L_Desc
  @ Prow()+0,0

Return ''

&&=========================================================================&&

Function E4_IniG2Quebra

  Select Conta

  Seek W_G1Atu + W_G2Atu + '000000000'

  If .Not. Found()
     L_Desc = 'Sub-Grupo nao cadastrado :' + W_G2Atu
  Else
     L_Desc = B_Desc
  EndIf

  If Prow()+3 > 55
     W_Pagina = W_Pagina + 1
     Eject
     E4_Cabecalho()
  EndIf

  @ Prow()+0,4 Say 'SUB-GRUPO : ' + L_Desc
  @ Prow()  ,4 Say 'SUB-GRUPO : ' + L_Desc
  @ Prow()+2,0

Return ''

&&=========================================================================&&

Function E4_Entra

   If (PRow() > 55)
      W_Pagina = W_Pagina + 1
      Eject
      E4_Cabecalho()
   EndIf

   Select SaldoCt

   W_Conta = E4_MontaConta()

   W_Ct = W_Grau1+'.'+W_Grau2+'.'+W_Grau3+'.'+W_Grau4+'.'+W_Grau5+'.'+W_Grau6

   Select Conta
   Seek W_Conta
   W_Hist = B_Desc

   Select SaldoCt

   W_G1Atu = SubStr(E_Conta,1,1)
   W_G2Atu = SubStr(E_Conta,2,1)

   If W_G1Atu # W_G1Ant
      @ Prow()+1,0
      E4_TotSubGrupo()
      @ Prow()+2,0
      E4_TotGrupo()
      @ Prow()+2,0
      E4_IniG1Quebra()
      @ Prow()+1,0
      E4_IniG2Quebra()
   Else
      If W_G2Atu # W_G2Ant
         @ Prow()+1,0
         E4_TotSubGrupo()
         @ Prow()+2,0
         E4_IniG2Quebra()
      EndIf
   EndIf

   Select SaldoCt

   W_TotG2Ant = W_TotG2Ant + E_SaldoAnt
   W_TotG2Db  = W_TotG2Db  + E_Debitos
   W_TotG2Cr  = W_TotG2Cr  + E_Creditos
   W_TotG2Atu = W_TotG2Atu + E_SaldoAtu

   If E_Debitos = 0 .And. E_Creditos = 0 .And. E_SaldoAnt = 0
      Return ''
   EndIf

   W_SaldoAnt = Transform(E_SaldoAnt ,'@E 9999,999,999,999.99')
   W_Debitos  = Transform(E_Debitos  ,'@E  999,999,999,999.99')
   W_Creditos = Transform(E_Creditos ,'@E  999,999,999,999.99')
   W_SaldoAtu = Transform(E_SaldoAtu ,'@E 9999,999,999,999.99')

   PRT( 00  , W_Ct        , '.' )
   PRT( 18  , W_Hist      , '.' )
   PRT( 58  , W_SAldoAnt  , '.' )
   PRT( 77  , W_Debitos   , '.' )
   PRT( 97  , W_Creditos  , '.' )
   PRT( 116 , W_SaldoAtu  , '.' )

   @ Prow()+1,0

Return ''

&&=========================================================================&&

Function E4_Cabecalho

*          1         2         3         4         5         6         7         8         9         0         1         2         3
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*CTR06                  B A L A N C E T E               MES/ANO : MM/AA                              Pag: 99999
*
*Empresa : XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
*   C O N T A      T I T U L O                                  SALDO ANTERIOR           DEBITOS          CREDITO         SALDO ATUAL
*
*9.9.99.99.99.999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999.999.99 99.999.999.999.99 99.999.999.999.99 999.999.999.999.99
*

L_Titulo = 'B A L A N C E T E    DE    C O N F E R E N C I A'

@      0   ,0   Say 'CTR06'
@ Prow()   ,CalcCenter(0,132,Len(L_Titulo))  Say  L_Titulo
@ Prow()   ,120 Say 'Pag: ' + StrZero(W_Pagina,5)
@ Prow()+2 ,CalcCenter(0,132,Len(W_Empresa))  Say  W_Empresa
@ Prow()+2 ,0   Say 'Referencia: ' + StrMes(Val(W_Mes)) + ' DE 19' + W_Ano
@ Prow()+2 ,0
@ Prow()   ,003 Say 'C O N T A'
@ Prow()   ,018 Say 'T I T U L O'
@ Prow()   ,063 Say 'SALDO ANTERIOR'
@ Prow()   ,089 Say 'DEBITOS'
@ Prow()   ,108 Say 'CREDITOS'
@ Prow()   ,124 Say 'SALDO ATUAL'
@ Prow()+1 ,0
@ Prow()   ,003 Say '---------'
@ Prow()   ,018 Say '-----------'
@ Prow()   ,063 Say '--------------'
@ Prow()   ,089 Say '-------'
@ Prow()   ,108 Say '--------'
@ Prow()   ,124 Say '-----------'
@ Prow()+1 ,0

Return ''

&&=========================================================================&&

Function E4_MontaConta

  W_Grau1  =  SubStr(E_Conta,01,1)
  W_Grau2  =  SubStr(E_Conta,02,1)
  W_Grau3  =  SubStr(E_Conta,03,2)
  W_Grau4  =  SubStr(E_Conta,05,2)
  W_Grau5  =  SubStr(E_Conta,07,2)
  W_Grau6  =  SubStr(E_Conta,09,3)

Return (W_Grau1+W_Grau2+W_Grau3+W_Grau4+W_Grau5+W_Grau6)

&&=========================================================================&&

Function E4_TotSubGrupo

  Select Conta

  Seek W_G1Ant + W_G2Ant + '000000000'

  If .Not. Found()
     W_Desc = 'Sub-Grupo deletado'
  Else
     W_Desc = B_Desc
  EndIf


  L_Titulo = 'Total do Sub-Grupo : ' + W_Desc

  W_SaldoAnt = Transform(W_TotG2Ant ,'@E 9999,999,999,999.99')
  W_Debitos  = Transform(W_TotG2Db  ,'@E  999,999,999,999.99')
  W_Creditos = Transform(W_TotG2Cr  ,'@E  999,999,999,999.99')
  W_SaldoAtu = Transform(W_TotG2Atu ,'@E 9999,999,999,999.99')

  PRT( 00  , ' '         , ' ' )
  PRT( 04  , L_Titulo    , '.' )
  PRT( 58  , W_Saldoant  , '.' )
  PRT( 77  , W_Debitos   , '.' )
  PRT( 97  , W_Creditos  , '.' )
  PRT( 116 , W_SaldoAtu  , '.' )

  PRT( 00  , ' '         , ' ' )
  PRT( 04  , L_Titulo    , '.' )
  PRT( 58  , W_Saldoant  , '.' )
  PRT( 77  , W_Debitos   , '.' )
  PRT( 97  , W_Creditos  , '.' )
  PRT( 116 , W_SaldoAtu  , '.' )

  W_TotG1Ant = W_TotG1Ant + W_TotG2Ant
  W_TotG1Db  = W_TotG1Db  + W_TotG2Db
  W_TotG1Cr  = W_TotG1Cr  + W_TotG2Cr
  W_TotG1Atu = W_TotG1Atu + W_TotG2Atu

  W_TotG2Ant = 0
  W_TotG2Db  = 0
  W_TotG2Cr  = 0
  W_TotG2Atu = 0

  W_G2Ant = W_G2Atu

Return ''

&&=========================================================================&&

Function E4_TotGrupo

  Select Conta

  Seek W_G1Ant + '0000000000'

  If .Not. Found()
     W_Desc = 'Grupo deletado'
  Else
     W_Desc = B_Desc
  EndIf


  L_Titulo = 'Total do Grupo : ' + W_Desc

  W_SaldoAnt = Transform(W_TotG1Ant ,'@E 9999,999,999,999.99')
  W_Debitos  = Transform(W_TotG1Db  ,'@E  999,999,999,999.99')
  W_Creditos = Transform(W_TotG1Cr  ,'@E  999,999,999,999.99')
  W_SaldoAtu = Transform(W_TotG1Atu ,'@E 9999,999,999,999.99')

  PRT( 00  , L_Titulo    , '.' )
  PRT( 58  , W_Saldoant  , '.' )
  PRT( 77  , W_Debitos   , '.' )
  PRT( 97  , W_Creditos  , '.' )
  PRT( 116 , W_SaldoAtu  , '.' )

  PRT( 00  , L_Titulo    , '.' )
  PRT( 58  , W_Saldoant  , '.' )
  PRT( 77  , W_Debitos   , '.' )
  PRT( 97  , W_Creditos  , '.' )
  PRT( 116 , W_SaldoAtu  , '.' )

  W_TotG1Ant = 0
  W_TotG1Db  = 0
  W_TotG1Cr  = 0
  W_TotG1Atu = 0

  W_G1Ant = W_G1Atu

Return ''

&&=========================================================================&&

