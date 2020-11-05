*****************************************************************************
*                                                                           *
* Arquivo  : Ct5005.Prg                Update : 19:59:38  8/1/1992          *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Emissao do demonstrativo da apuracao.                          *
*                                                                           *
*****************************************************************************

Public SaveColor

SaveColor = SetColor()

UseCtD001()
UseCtD002()
UseCtD004()
UseCtD009()
UseCtD015()
UseCtD020()

E5_Inicializa()   && Inicializa parametros de processamento
E5_Processa()     && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function E5_Inicializa

Public Data,W_Livro,W_Pagina,W_Emp,W_Mes,W_Ano,W_Data,W_Hora,W_Empresa
Public W_TotDiaD,W_TotDiaC,W_TotPageD,W_TotPageC,W_TotD,W_TotC,W_DiaAnt
Public W_Conta,W_Grau1,W_Grau2,W_Grau3,W_Grau4,W_Grau5,W_Grau6,W_SaldoCalc
Public W_Dia, W_Ano, W_ContaAnt, W_AnoAnt, W_MesAnt, CalledIni, CalledFim
Public W_CtResult, W_HistResult, W_Arquivo, W_DataLanc, W_Livro, W_Folha

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return ''

&&=========================================================================&&

Function E5_Processa

E5_Tela()

Do While LastKey() <> 27

   Set Device to Printer

   UseCtD017()

   E5_FechaPeriodo()
   E5_Imprime()

   Select SaldoBalanco
   Zap
   Use

   Eject

   Set Device to Screen

   E5_Tela()

EndDo

Return ''

&&=========================================================================&&

Function E5_Tela

L_Lin = 11
L_Col = 33

Titulo = ' Demonstracao da Apuracao '

DrawShadow(L_Lin,L_Col,04,26,'W+/R+B','W/B',Titulo,'I/N')

@ L_Lin + 2, L_Col + 9  Say 'Mes:'
@ L_Lin + 2, L_Col +19  Say 'Ano:'

Do While .t.

  W_Mes = 0
  W_Ano = 0

  @ L_Lin+2,L_Col+13 Get W_Mes Pict '99'  Valid W_Mes#0
  @ L_Lin+2,L_Col+23 Get W_Ano Pict '99'  Valid W_Ano#0

  Read

  If LastKey() = 27
     Return ''
  EndIf

  Select Empresa
  Go Top
  W_Empresa = AllTrim(A_Nome)
  W_Livro   = A_Livro
  W_Folha   = A_Folha

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

  W_DataLanc = CtoD(LastDay(Val(W_Mes),Val(W_Ano))+'/'+W_Mes+'/'+W_Ano)
  W_Arquivo  = '@@@@' + W_Ano + W_Mes

  Select Status

  Seek W_Ano + W_Mes

  If (.Not. Found()) .Or. O_Status # 'A'
     Message('Nao foi efetuada apuracao do exercicio de ' + StrMes(Val(W_Mes)))
     Loop
  EndIf

  Return ''

EndDo

Return ''

&&=========================================================================&&

Function E5_Imprime

W_Pagina    = W_Folha
W_G1Atu     = ''
W_G1Ant     = ''

SetPrc()
@ 0,0 Say Chr(13)

Select SaldoBalanco
Sort To CtD018 On R_Conta
Use
Use CtD018 Alias SaldoBalanco

W_G1Atu = SubStr(R_Conta,1,1)

Do While (.Not. Eof())
   E5_Cabec()
   W_G1Ant = W_G1Atu
   Do While (.Not. Eof()) .And. (W_G1Atu = W_G1Ant)
      E5_Grau1Quebra()
      Select SaldoBalanco
      Skip
      W_G1Atu = SubStr(R_Conta,1,1)
   EndDo
   If .Not. Eof()
*      Eject
   EndIf
EndDo

Select Empresa

Replace A_Folha With W_Pagina

Return ''

&&=========================================================================&&

Function E5_Grau1Quebra

 Private W_Branco

   W_Conta = E5_MontaConta()
   W_Desc  = W_Branco + E5_NomeConta()

   Select SaldoBalanco

   If R_Saldo < 0
      L_Saldo = R_Saldo * -1
      L_Col = 112
   Else
      L_Saldo = R_Saldo
      L_Col = 87
   EndIf

   W_Valor = Transform(L_Saldo ,'@E 9999,999,999,999.99')

   If Prow() > 55
      Eject
      E5_Cabec()
   EndIf

   PRT( 07   , W_Conta     , '.' )
   PRT( 30   , W_Desc      , '.' )
   PRT( L_Col, W_Valor     , '.' )

   @ Prow()+1,0

Return ''

&&=========================================================================&&

Function E5_MontaConta

  W_G1  =  SubStr(R_Conta,01,1)
  W_G2  =  SubStr(R_Conta,02,1)
  W_G3  =  SubStr(R_Conta,03,2)
  W_G4  =  SubStr(R_Conta,05,2)
  W_G5  =  SubStr(R_Conta,07,2)
  W_G6  =  SubStr(R_Conta,09,3)

  If W_G2 = '0'
     W_Branco = ''
     Return W_G1
  EndIf
  If W_G3 = '00'
     W_Branco = '  '
     Return W_G1+'.'+W_G2
  EndIf
  If W_G4 = '00'
     W_Branco = '    '
     Return W_G1+'.'+W_G2+'.'+W_G3
  EndIf
  If W_G5 = '00'
     W_Branco = '      '
     Return W_G1+'.'+W_G2+'.'+W_G3+'.'+W_G4
  EndIf
  If W_G6 = '000'
     W_Branco = '        '
     Return W_G1+'.'+W_G2+'.'+W_G3+'.'+W_G4+'.'+W_G5
  EndIf

  W_Branco = '          '
  Return W_G1+'.'+W_G2+'.'+W_G3+'.'+W_G4+'.'+W_G5+'.'+W_G6

Return ''

&&=========================================================================&&

Function E5_NomeConta

  Select SaldoBalanco

  L_Conta = R_Conta

  Select Conta

  Seek L_Conta

  If .Not. Found()
     L_Desc = 'Conta nao cadastrada'
  Else
     L_Desc = B_Desc
  EndIf

Return L_Desc

&&=========================================================================&&

Function E5_Cabec

*          1         2         3         4         5         6         7         8         9         0         1         2         3
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*CTR55               DEMONSTRACAO DA APURACAO DO EXERCICIO                Pag: 99999
*
*                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
*                   PROCESSADO EM XX DE XXXXXXXXXXX DE XXXX
*
*                  RELATIVO AO PERIODO DE XX/XX/XX A XX/XX/XX
*
*                                                                               S A L D O
*     CONTA        T I T U L O
*
*9.9.99.99.99.999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX            9999.999.999.999,99

L_Titulo = 'DEMONSTRATIVO DA APURACAO DAS CONTAS DE RESULTADO'
L_Proc   = 'PROCESSADO EM ' + LastDay(Val(W_Mes),Val(W_Ano)) + ' DE ' + StrMes(Val(W_Mes)) + ' DE ' + '19' + W_Ano
L_Relat  = 'RELATIVO AO PERIODO DE ' + '01/01/'+W_Ano + ' A ' + LastDay(Val(W_Mes),Val(W_Ano))+'/'+W_Mes+'/'+W_Ano
W_Pagina = W_Pagina + 1

@      0   ,0   Say 'CTR55'
@ Prow()   ,CalcCenter(0,131,Len(L_Titulo))  Say  L_Titulo
@ Prow()   ,98  Say 'Livro: ' + StrZero(W_Livro,3)
@ Prow()   ,121 Say 'Folha: ' + StrZero(W_Pagina,5)
@ Prow()+2 ,CalcCenter(0,131,Len(W_Empresa))  Say  W_Empresa
@ Prow()+2 ,CalcCenter(0,131,Len(L_Proc))     Say  L_Proc
@ Prow()+2 ,CalcCenter(0,131,Len(L_Relat))    Say  L_Relat

@ Prow()+2 ,010 Say 'C O N T A'
@ Prow()   ,030 Say 'T I T U L O'
@ Prow()   ,95  Say 'D E B I T O'
@ Prow()   ,118 Say 'C R E D I T O'
@ Prow()+1 ,007 Say '----------------'
@ Prow()   ,030 Say '-----------'
@ Prow()   ,95  Say '-----------'
@ Prow()   ,118 Say '-------------'
@ Prow()+1 ,0

Return ''

&&=========================================================================&&

Function E5_FechaPeriodo

W_G1Atu = ''
W_G2Atu = ''
W_G3Atu = ''
W_G4Atu = ''
W_G5Atu = ''
W_G6Atu = ''
W_G1Ant = ''
W_G2Ant = ''
W_G3Ant = ''
W_G4Ant = ''
W_G5Ant = ''
W_G6Ant = ''
W_Debitos  = 0
W_Creditos = 0

Select SaldoBalanco
Zap

Select SaldoApuracao
Set SoftSeek On
Seek W_Ano + W_Mes
Set SoftSeek Off

If Eof() .Or. T_Ano # W_Ano .Or. T_Mes # W_Mes
   Message('Nao foi encontrado saldo na apuracao')
   Return ''
EndIf

Do While (.Not. Eof()) .And. T_Ano=W_Ano .And. T_Mes=W_Mes

   W_G1Atu   = SubStr(T_Conta,1,1)
   Select Conta
   Seek W_G1Atu + '0000000000'
   If .Not. Found()
      Message('Conta nao cadastrada : ' + W_G1Atu)
      Return ''
   EndIf
   If B_Result # 'S'
      Select SaldoApuracao
      Set SoftSeek On
      Seek W_Ano + W_Mes + StrZero(Val(W_G1Atu)+1,1)
      Set SoftSeek Off
      Loop
   EndIf

   W_Natureza = B_Natureza

   Select SaldoApuracao

   W_G1Ant   = W_G1Atu
   W_G1DB    = 0
   W_G1CR    = 0
   Do While (.Not. Eof()) .And. T_Ano=W_Ano .And. T_Mes=W_Mes .And. ;
            (W_G1Atu = W_G1Ant)
      E5_TrataG1()
      Select Saldoapuracao
   EndDo

   Select SaldoBalanco
   Append Blank
   Replace  R_Conta  With  W_G1Ant + '0000000000'
   Replace  R_Saldo  With  W_G1DB
   Select SaldoApuracao
EndDo

Return ''

&&=========================================================================&&
Function E5_TrataG1
W_G2Atu   = SubStr(T_Conta,2,1)
W_G2Ant   = W_G2Atu
W_G2DB    = 0
W_G2CR    = 0
W_GravouG3= 0
Do While (.Not. Eof()).And. T_Ano=W_Ano .And. T_Mes=W_Mes .And. ;
         (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant)
   E5_TrataG2()
   Select SaldoApuracao
EndDo
If W_G2Ant # '0'
   Select SaldoBalanco
   Append Blank
   Replace  R_Conta  With  W_G1Ant + W_G2Ant + '000000000'
   Replace  R_Saldo  With  W_G2DB
EndIf
W_G1DB    = W_G1DB    + W_G2DB
W_G1CR    = W_G1CR    + W_G2CR
Return ''
&&=========================================================================&&
Function E5_TrataG2
W_G3Atu   = SubStr(T_Conta,3,2)
W_G3Ant   = W_G3Atu
W_G3DB    = 0
W_G3CR    = 0
W_GravouG4= 0
Do While (.Not. Eof()).And. T_Ano=W_Ano .And. T_Mes=W_Mes .And. ;
         (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant)
   E5_TrataG3()
   Select SaldoApuracao
EndDo
If W_G3Ant # '00'
   Select SaldoBalanco
   Append Blank
   Replace  R_Conta  With  W_G1Ant + W_G2Ant + W_G3Ant + '0000000'
   Replace  R_Saldo  With  W_G3DB
EndIf
W_G2DB    = W_G2DB    + W_G3DB
W_G2CR    = W_G2CR    + W_G3CR
W_GravouG3= W_GravouG3+ W_GravouG4

Return ''
&&=========================================================================&&
Function E5_TrataG3
W_G4Atu   = SubStr(T_Conta,5,2)
W_G4Ant   = W_G4Atu
W_G4DB    = 0
W_G4CR    = 0
W_GravouG5= 0
Do While (.Not. Eof()).And. T_Ano=W_Ano .And. T_Mes=W_Mes .And. ;
   (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant).And.(W_G4Atu=W_G4Ant)
   E5_TrataG4()
   Select SaldoApuracao
EndDo
If W_G4Ant # '00'
   Select SaldoBalanco
   Append Blank
   Replace  R_Conta  With  W_G1Ant+W_G2Ant+W_G3Ant+W_G4Ant+'00000'
   Replace  R_Saldo  With  W_G4DB
EndIf
W_G3DB    = W_G3DB    + W_G4DB
W_G3CR    = W_G3CR    + W_G4CR
W_GravouG4= W_GravouG4+ W_GravouG5
Return ''
&&=========================================================================&&
Function E5_TrataG4
W_G5Atu   = SubStr(T_Conta,7,2)
W_G5Ant   = W_G5Atu
W_G5DB    = 0
W_G5CR    = 0
W_GravouG6= 0
Do While (.Not. Eof()).And. T_Ano=W_Ano .And. T_Mes=W_Mes .And. ;
   (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant).And.;
   (W_G4Atu=W_G4Ant).And.(W_G5Atu=W_G5Ant)
   E5_TrataG5()
   Select SaldoApuracao
EndDo
If W_G5Ant # '00'
   Select SaldoBalanco
   Append Blank
   Replace  R_Conta  With  W_G1Ant+W_G2Ant+W_G3Ant+W_G4Ant+W_G5Ant+'000'
   Replace  R_Saldo  With  W_G5DB
EndIf
W_G4DB    = W_G4DB    + W_G5DB
W_G4CR    = W_G4CR    + W_G5CR
W_GravouG5 = W_GravouG5 + W_GravouG6
Return ''
&&=========================================================================&&
Function E5_TrataG5
W_G6Atu   = SubStr(T_Conta,9,3)
W_G6Ant   = W_G6Atu
W_G6DB    = 0
W_G6CR    = 0
Do While (.Not. Eof()).And. T_Ano=W_Ano .And. T_Mes=W_Mes .And. ;
   (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant).And. ;
   (W_G4Atu=W_G4Ant).And.(W_G5Atu=W_G5Ant).And.(W_G6Atu=W_G6Ant)
   E5_TrataG6()
   W_G1Atu = SubStr(T_Conta,1,1)
   W_G2Atu = SubStr(T_Conta,2,1)
   W_G3Atu = SubStr(T_Conta,3,2)
   W_G4Atu = SubStr(T_Conta,5,2)
   W_G5Atu = SubStr(T_Conta,7,2)
   W_G6Atu = SubStr(T_Conta,9,3)
EndDo
If W_G6Ant # '000'
   Select SaldoBalanco
   Append Blank
   Replace  R_Conta  With  W_G1Ant+W_G2Ant+W_G3Ant+W_G4Ant+W_G5Ant+W_G6Ant
   Replace  R_Saldo  With  W_G6DB
   W_GravouG6 = W_GravouG6 + 1
EndIf
W_G5DB = W_G5DB + W_G6DB
W_G5CR = W_G5CR + W_G6CR
Return ''
&&=========================================================================&&
Function E5_TrataG6

 Select SaldoApuracao

 L_SaldoAtu = T_Saldo

 If L_SaldoAtu > 0
    If W_Natureza = 'C'
       L_SaldoAtu = L_SaldoAtu * -1
    EndIf
 Else
    If W_Natureza = 'C'
       L_SaldoAtu = L_SaldoAtu * -1
    EndIf
 EndIf

 W_G6DB = W_G6DB + L_SaldoAtu

 Skip

Return ''
&&=========================================================================&&

