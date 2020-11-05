*****************************************************************************
*                                                                           *
* Arquivo  : Ct5001.Prg                 Update : 18:50:07  8/1/1992         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Emissao do diario                                              *
*                                                                           *
*****************************************************************************

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Public SaveColor

SaveColor = SetColor()

E1_01_Inicializa()     && Inicializa parametros de processamento
E1_02_Processa()       && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function E1_01_Inicializa

Public Data,W_Livro,W_Pagina,W_Emp,W_Mes,W_Ano,W_Data,W_Hora,W_Empresa
Public W_TotDiaD,W_TotDiaC,W_TotPageD,W_TotPageC,W_TotD,W_TotC,W_DiaAnt
Public CalledIni, CalledFim

UseCtD001()
UseCtD003()
UseCtD004()

Select Empresa
Go Top

W_Empresa = AllTrim(A_Nome)
W_Pagina  = A_Folha
W_Livro   = A_Livro


Return ''

&&=========================================================================&&

Function E1_02_Processa

E1_03_Tela()

Do While LastKey() <> 27

   Set Device to Printer
*   Set Printer to Diario

   E1_04_Imprime()
*   E1_06_Total_Dia()
   E1_FechaFolha()
   E1_07_Total_Folha()
   E1_08_Total_Geral()
   E1_09_Atualiza()

   Eject

   Set Device to Screen

   E1_03_Tela()

EndDo

Return ''

&&=========================================================================&&

Function E1_03_Tela

L_Lin = 11
L_Col = 33

Titulo = ' Emissao do diario '

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

  w_aa = w_ano

  if w_mes < 12
     w_mm = w_mes + 1
  else
     w_mm = 01
     w_aa = w_ano + 1
  endif

  W_Ano  = StrZero(W_Ano,2)
  W_Mes  = StrZero(W_Mes,2)

  Called    = '01/' + W_Mes +'/'+ W_Ano
  CalledIni = CtoD('01/' + W_Mes +'/'+ W_Ano)
  CalledFim = CtoD('01/' + StrZero(W_Mm,2) +'/'+ StrZero(W_Aa,2))

  Select Lancamento

  Set Order To 3
  Go Top

  Set  SoftSeek On
  Seek CalledIni
  Set  SoftSeek Off

  If Eof() .or. D_Data >= CalledFim
     Message(' Nao ha lancamento nesta data ')
     Loop
  EndIf

  Return ''

EndDo

Return ''

&&=========================================================================&&

Function E1_04_Imprime

PrimeiraVez = .t.

W_TotDiaD   = 0
W_TotDiaC   = 0
W_TotPageD  = 0
W_TotPageC  = 0
W_TotD      = 0
W_TotC      = 0

If W_Pagina = 0
   W_Pagina = 1
EndIf

Select Lancamento

W_DiaAnt = SubStr(DtoC(D_Data),1,2)

Do While (.Not. Eof()) .And. (D_Data < CalledFim)

   If (PRow() > 58) .Or. PrimeiraVez
      If .Not. PrimeiraVez
         E1_07_Total_Folha()
         Eject
      EndIf
      PrimeiraVez = .f.
      W_Pagina    = W_Pagina + 1
      E1_05_Cabecalho()
   EndIf

   W_DiaAtu = SubStr(DtoC(D_Data),1,2)

   If W_DiaAtu <> W_DiaAnt
*      E1_06_Total_Dia()
      W_DiaAnt = W_DiaAtu
   EndIf

   IF .not. Empt(Alltrim(D_CodHist))
      Select Historico
      Seek   Lancamento->D_CodHist
      W_Hist = AllTrim(C_Desc) + ' ' + AllTrim(Lancamento->D_Complem)
      Select Lancamento
   Else
      W_Hist = AllTrim(D_Complem)
   EndIf

   W_Valor  = Transform(D_Valor,'99,999,999,999.99')
   W_Data   = DtoC(D_Data)
   W_Dia    = SubStr(W_Data,1,2)
   W_G1     = SubStr(D_Conta,1,1)
   W_G2     = SubStr(D_Conta,2,1)
   W_G3     = SubStr(D_Conta,3,2)
   W_G4     = SubStr(D_Conta,5,2)
   W_G5     = SubStr(D_Conta,7,2)
   W_G6     = SubStr(D_Conta,9,3)

   W_Conta  = W_G1+'.'+W_G2+'.'+W_G3+'.'+W_G4+'.'+W_G5+'.'+W_G6

   IF D_DC = 'D'
      W_TotDiaD  = W_TotDiaD  + D_Valor
      C_Vl       = 97
   Else
      W_TotDiaC  = W_TotDiaC  + D_Valor
      C_Vl       = 116
   EndIF

   PRT( 02  , W_Dia       , '.' )
   PRT( 08  , W_Conta     , '.' )
   PRT( 28  , W_Hist      , '.' )
   PRT( C_Vl, W_Valor     , '.' )

   @ Prow()+1,0

   Skip

EndDo

Return ''

&&=========================================================================&&

Function E1_05_Cabecalho

*          1         2         3         4         5         6         7         8
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*CTR04                  D  I  A  R  I  O              Livro: 9999    Pag: 99999
*
*Empresa : XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
*  D A T A      C O N T A        H I S T O R I C O           V A L O R   OP
*  --------  ----------------    -----------------           ---------   --
*
*  99/99/99  X.X.XX.XX.XX.XXX    X(60)                99.999.999.999,99   X

L_Titulo =  'D  I  A  R  I  O'

@ 1        ,0   Say 'CTR51'
@ Prow()   ,CalcCenter(0,132,Len(L_Titulo))  Say  L_Titulo
@ Prow()   ,98  Say 'Livro: ' + StrZero(W_Livro,3)
@ Prow()   ,121 Say 'Folha: ' + StrZero(W_Pagina,5)
@ Prow()+2 ,CalcCenter(0,132,Len(W_Empresa)) Say  W_Empresa
@ Prow()+2 ,00  Say 'Referencia : ' + StrMes(Val(W_Mes)) + ' DE 19' + W_Ano
@ Prow()+2 ,0   Say '  DIA      C O N T A        H I S T O R I C O'
@ Prow()   ,101 Say '  D E B I T O      C R E D I T O'
@ Prow()+1 ,0   Say '  ---   ----------------    -----------------'
@ Prow()   ,101 Say '  -----------      -------------'
@ Prow()+1 ,0

Return ''

&&=========================================================================&&

Function E1_06_Total_Dia

   @ Prow()+1,0

   For I=1 To 2

     PRT( 050 , 'T O T A I S   D O   D I A  '+W_DiaAnt+'  -->','.')
     W_Valor  = Transform(W_TotDiaD,'99,999,999,999.99')
     PRT( 097 , W_Valor  , '.' )
     W_Valor  = Transform(W_TotDiaC,'99,999,999,999.99')
     PRT( 116 , W_Valor  , '.' )

   Next

   @ Prow()+2,0
   W_TotPageD = W_TotPageD + W_TotDiaD
   W_TotPageC = W_TotPageC + W_TotDiaC
   W_TotDiaD  = 0
   W_TotDiaC  = 0

Return ''

&&=========================================================================&&

Function E1_07_Total_Folha

   @ Prow()+1,0

   For I=1 To 2

     PRT( 050 , 'T O T A I S   D A   F O L H A  -->','.')
     W_Valor  = Transform(W_TotDiaD,'99,999,999,999.99')
     PRT( 097 , W_Valor  , '.' )
     W_Valor  = Transform(W_TotDiaC,'99,999,999,999.99')
     PRT( 116 , W_Valor  , '.' )

   Next

   W_TotD     = W_TotD + W_TotDiaD
   W_TotC     = W_TotC + W_TotDiaC
   W_TotDiaD  = 0
   W_TotDiaC  = 0

Return ''

&&=========================================================================&&

Function E1_08_Total_Geral

   @ Prow()+1,0

   For I=1 To 2

     PRT( 050 , 'T O T A I S   D O   M E S   -->','.')
     W_Valor  = Transform(W_TotD,'99,999,999,999.99')
     PRT( 097 , W_Valor  , '.' )
     W_Valor  = Transform(W_TotC,'99,999,999,999.99')
     PRT( 116 , W_Valor  , '.' )

   Next

   W_TotD = 0
   W_TotC = 0

Return ''

&&=========================================================================&&

Function E1_09_Atualiza

  Select Empresa

  Replace A_Folha With W_Pagina

Return ''

&&=========================================================================&&

Function E1_FechaFolha

  AuxLin = 60 - Prow()

  If AuxLin < 3
     Return ''
  EndIf

  AuxLen  = 132 / AuxLin
  AuxFill = Replicate('=',AuxLen)
  AuxCol  = 0

  For I=1 To AuxLin
    @Prow(),AuxCol Say AuxFill
    @Prow()+1,0
    AuxCol = AuxCol + AuxLen
  Next

Return ''

&&=========================================================================&&

