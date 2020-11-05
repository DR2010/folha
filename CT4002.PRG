*****************************************************************************
*                                                                           *
* Arquivo  : Ct4002.Prg                Update : 20:01:59  8/1/1992          *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Efetuar a apuracao de resultado.                               *
*                                                                           *
*****************************************************************************

Public SaveColor

SaveColor = SetColor()

UseCtD001()
UseCtD002()
UseCtD004()
UseCtD005()
UseCtD009()
UseCtD012()
UseCtD015()
UseCtD019()
UseCtD020()

D2_Inicializa()   && Inicializa parametros de processamento
D2_Processa()     && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function D2_Inicializa

Public Data,W_Livro,W_Pagina,W_Emp,W_Mes,W_Ano,W_Data,W_Hora,W_Empresa
Public W_TotDiaD,W_TotDiaC,W_TotPageD,W_TotPageC,W_TotD,W_TotC,W_DiaAnt
Public W_Conta,W_Grau1,W_Grau2,W_Grau3,W_Grau4,W_Grau5,W_Grau6,W_SaldoCalc
Public W_Dia, W_Ano, W_ContaAnt, W_AnoAnt, W_MesAnt, CalledIni, CalledFim
Public W_CtResult, W_HistResult, W_Arquivo, W_DataLanc

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return ''

&&=========================================================================&&

Function D2_Processa

D2_Tela()

Do While LastKey() <> 27

   D2_FechaPeriodo()
   D2_SaldoContas()
   D2_SaldoAtu()
   D2_Status()

   D2_Tela()

EndDo

Return ''

&&=========================================================================&&

Function D2_Tela

Titulo = ' Apuracao do Resultado '

L_Lin = 11
L_Col = 33

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
  W_Empresa = AllTrim(A_Nome)

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

  If (.Not. Found()) .Or. (O_Status # 'F')
     Message('Nao foi efetuado fechamento do mes de ' + StrMes(Val(W_Mes)))
     Loop
  EndIf

  If (O_Status = 'A')
     Message('Ja foi efetuada Apuracao do mes de ' + StrMes(Val(W_Mes)))
     Loop
  EndIf

  Select Parametro
  Go Top

  W_CtResult   = S_CtResult
  W_HistResult = S_Hist

  Select Conta
  Seek W_CtResult

  If .Not. Found()
     Message('Conta definida p/ apuracao nao cadastrada.')
     Loop
  EndIf

  Return ''

EndDo

Return ''

&&=========================================================================&&

Function D2_FechaPeriodo

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

Select SaldoApuracao
Set SoftSeek On
Seek W_Ano + W_Mes
Set SoftSeek Off

Do While (.Not. Eof()) .And. T_Ano = W_Ano .And. T_Mes = W_Mes
   Delete
   Skip
EndDo

Select Lancamento
Set Order To 1
Set SoftSeek On
Seek W_Arquivo
Set SoftSeek Off

Do While (.Not. Eof()) .And. D_Arquivo = W_Arquivo
   Delete
   Skip
EndDo

Select Arquivo

Seek W_Arquivo

If Found()
   Delete
EndIf

Select SaldoCt
Set Order To 2
Go Top

Set SoftSeek On
Seek W_Ano + W_Mes + ' '
Set SoftSeek Off

If E_Ano # W_Ano .Or. E_Mes # W_Mes
   Message('Nao foi encontrado saldo p/ o mes de ' + StrMes(Val(W_Mes)))
   Return ''
EndIf

Do While (.Not. Eof()) .And. E_Ano = W_Ano .And. E_Mes = W_Mes

   W_G1Atu   = SubStr(E_Conta,1,1)
   Select Conta
   Seek W_G1Atu + '0000000000'
   If .Not. Found()
      Message('Conta nao cadastrada : ' + W_G1Atu)
      Return ''
   EndIf
   If B_Result # 'S'
      Select SaldoCt
      Set SoftSeek On
      Seek W_Ano + W_Mes + StrZero(Val(W_G1Atu)+1,1)
      Set SoftSeek Off
      Loop
   EndIf

   W_Natureza = B_Natureza

   Select SaldoCT

   W_G1Ant   = W_G1Atu
   W_G1Saldo = 0
   Do While (.Not. Eof()) .And. E_Ano = W_Ano .And. E_Mes = W_Mes .And. ;
            (W_G1Atu = W_G1Ant)
      D2_TrataG1()
      Select SaldoCt
   EndDo

   If W_G1Saldo # 0
      Select Lancamento
      Append Blank
      Replace D_Data     With  W_DataLanc
      Replace D_Arquivo  With  W_Arquivo
      Replace D_Seq      With  000
      Replace D_Conta    With  W_CtResult
      Replace D_Complem  With  W_HistResult

      If W_G1Saldo > 0
         If W_Natureza = 'C'
            Replace D_Valor    With  W_G1Saldo
            Replace D_Dc       With  'C'
         Else
            Replace D_Valor    With  W_G1Saldo
            Replace D_Dc       With  'D'
         EndIf
      Else
         If W_Natureza = 'C'
            Replace D_Valor    With  W_G1Saldo * -1
            Replace D_Dc       With  'D'
         Else
            Replace D_Valor    With  W_G1Saldo * -1
            Replace D_Dc       With  'C'
         EndIf
      EndIf
   EndIf

   Select SaldoCt
EndDo

If W_Debitos # 0 .Or. W_Creditos # 0
   Select Arquivo
   Append Blank
   Replace I_Arquivo  With  W_Arquivo
   Replace I_Mes      With  Val(W_Mes)
   Replace I_Ano      With  Val(W_Ano)
   Replace I_Debito   With  W_Debitos
   Replace I_Credito  With  W_Creditos
EndIf

Return ''

&&=========================================================================&&
Function D2_TrataG1
W_G2Atu   = SubStr(E_Conta,2,1)
W_G2Ant   = W_G2Atu
W_G2Saldo = 0
W_GravouG3= 0
Do While (.Not. Eof()).And. E_Ano = W_Ano .And. E_Mes = W_Mes .And. ;
         (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant)
   D2_TrataG2()
   Select SaldoCt
EndDo
W_G1Saldo = W_G1Saldo + W_G2Saldo
Return ''
&&=========================================================================&&
Function D2_TrataG2
W_G3Atu   = SubStr(E_Conta,3,2)
W_G3Ant   = W_G3Atu
W_G3Saldo = 0
W_GravouG4= 0
Do While (.Not. Eof()).And. E_Ano = W_Ano .And. E_Mes = W_Mes .And. ;
         (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant)
   D2_TrataG3()
   Select SaldoCt
EndDo
W_G2Saldo = W_G2Saldo + W_G3Saldo
W_GravouG3= W_GravouG3+ W_GravouG4

Return ''
&&=========================================================================&&
Function D2_TrataG3
W_G4Atu   = SubStr(E_Conta,5,2)
W_G4Ant   = W_G4Atu
W_G4Saldo = 0
W_GravouG5= 0
Do While (.Not. Eof()).And. E_Ano = W_Ano .And. E_Mes = W_Mes .And. ;
   (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant).And.(W_G4Atu=W_G4Ant)
   D2_TrataG4()
   Select SaldoCt
EndDo
W_G3Saldo = W_G3Saldo + W_G4Saldo
W_GravouG4= W_GravouG4+ W_GravouG5
Return ''
&&=========================================================================&&
Function D2_TrataG4
W_G5Atu   = SubStr(E_Conta,7,2)
W_G5Ant   = W_G5Atu
W_G5Saldo = 0
W_GravouG6= 0
Do While (.Not. Eof()).And. E_Ano = W_Ano .And. E_Mes = W_Mes .And. ;
   (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant).And.;
   (W_G4Atu=W_G4Ant).And.(W_G5Atu=W_G5Ant)
   D2_TrataG5()
   Select SaldoCt
EndDo
W_G4Saldo = W_G4Saldo + W_G5Saldo
W_GravouG5 = W_GravouG5 + W_GravouG6
Return ''
&&=========================================================================&&
Function D2_TrataG5
W_G6Atu   = SubStr(E_Conta,9,3)
W_G6Ant   = W_G6Atu
W_G6Saldo = 0
Do While (.Not. Eof()).And. E_Ano = W_Ano .And. E_Mes = W_Mes .And. ;
   (W_G1Atu=W_G1Ant).And.(W_G2Atu=W_G2Ant).And.(W_G3Atu=W_G3Ant).And. ;
   (W_G4Atu=W_G4Ant).And.(W_G5Atu=W_G5Ant).And.(W_G6Atu=W_G6Ant)
   D2_TrataG6()
   W_G1Atu = SubStr(E_Conta,1,1)
   W_G2Atu = SubStr(E_Conta,2,1)
   W_G3Atu = SubStr(E_Conta,3,2)
   W_G4Atu = SubStr(E_Conta,5,2)
   W_G5Atu = SubStr(E_Conta,7,2)
   W_G6Atu = SubStr(E_Conta,9,3)
EndDo
If W_G6Ant # '000' .And. W_G6Saldo # 0
   W_GravouG6 = W_GravouG6 + 1
EndIf
W_G5Saldo = W_G5Saldo + W_G6Saldo
Return ''
&&=========================================================================&&
Function D2_TrataG6

 Select SaldoCt

 W_G6Saldo = W_G6Saldo + E_SaldoAtu

 If E_SaldoAtu # 0
    L_Conta    = E_Conta
    L_SaldoAtu = E_SaldoAtu

    Select SaldoApuracao
    Append Blank
    Replace T_Ano      With  W_Ano
    Replace T_Mes      With  W_Mes
    Replace T_Conta    With  L_Conta
    Replace T_Saldo    With  L_SaldoAtu

    Select Lancamento
    Append Blank
    Replace D_Data     With  W_DataLanc
    Replace D_Arquivo  With  W_Arquivo
    Replace D_Seq      With  000
    Replace D_Conta    With  L_Conta
    Replace D_Complem  With  W_HistResult

    If L_SaldoAtu > 0
       If W_Natureza = 'C'
          Replace D_Valor    With  L_SaldoAtu
          Replace D_Dc       With  'D'
          W_Creditos = W_Creditos + L_SaldoAtu
       Else
          Replace D_Valor    With  L_SaldoAtu
          Replace D_Dc       With  'C'
          W_Creditos = W_Creditos + L_SaldoAtu
       EndIf
    Else
       If W_Natureza = 'C'
          Replace D_Valor    With  L_SaldoAtu * -1
          Replace D_Dc       With  'C'
          W_Debitos  = W_Debitos  + (L_SaldoAtu * -1)
       Else
          Replace D_Valor    With  L_SaldoAtu * -1
          Replace D_Dc       With  'D'
          W_Debitos  = W_Debitos  + (L_SaldoAtu * -1)
       EndIf
    EndIf
 EndIf

 Select SaldoCt

 Skip

Return ''

&&=========================================================================&&
&& Cria Arquivo de trabalho contendo as contas movimentadas no mes com os
&& respectivos valores de debito e credito.

Function D2_SaldoContas

Select SaldoInter

Zap

ReIndex

Select Lancamento
Set Order To 3
Set SoftSeek On
Seek CalledIni
Set SoftSeek Off

Do While (.Not. Eof()) .And. (D_Data < CalledFim)

   W_Conta = D_Conta

   If D_Dc = 'D'
      W_Db   = D_Valor
      W_Cr   = 0
   Else
      W_Db   = 0
      W_Cr   = D_Valor
   EndIf

   Select SaldoInter

   Seek W_Conta

   If .Not. Found()
      Append Blank
      Replace L_Conta With W_Conta
   EndIf

   Replace L_Debito  With  L_Debito  + W_Db
   Replace L_Credito With  L_Credito + W_Cr

   Select Lancamento

   Skip

EndDo

Return ''

&&=========================================================================&&

Function D2_SaldoAtu

Select SaldoCt

Set Order To 1

Select Conta

Go Top

W_GrupoAtu = SubStr(B_Conta,1,1)

Do While .Not. Eof()

   W_GrupoAnt = W_GrupoAtu

   W_Natureza = B_Natureza

   Do While (.Not. Eof()) .And. (W_GrupoAtu = W_GrupoAnt)

      Do While (.Not. Eof()) .And. (B_Analitic # 'S') .And. (W_GrupoAtu = W_GrupoAnt)
         Skip
         W_GrupoAtu = SubStr(B_Conta,1,1)
      EndDo

      If W_GrupoAtu = W_GrupoAnt .And. (.Not. Eof())
         D1_Atualiza()

         Select Conta
         Skip

         W_GrupoAtu = SubStr(B_Conta,1,1)
      EndIf
   EndDo

EndDo

Return ''

&&=========================================================================&&

Function D2_Atualiza

   W_Conta = B_Conta

   Select SaldoInter

   Seek W_Conta

   If .Not. Found()
      W_Db = 0
      W_Cr = 0
   Else
      W_Db = L_Debito
      W_Cr = L_Credito
   EndIf

   W_SaldoAnt = 0

   Select SaldoCt

   Seek W_Conta + W_AnoAnt + W_MesAnt

   If Found()
      W_SaldoAnt = E_SaldoAtu
   EndIf

   Seek W_Conta + W_Ano + W_Mes

   If .Not. Found()
      Append Blank
      Replace E_Conta With W_Conta
      Replace E_Ano   With W_Ano
      Replace E_Mes   With W_Mes
   EndIf

   Replace E_SaldoAnt  With  W_SaldoAnt
   Replace E_Debitos   With  W_Db
   Replace E_Creditos  With  W_Cr

   If W_Natureza = 'D'
      Replace E_SaldoAtu  With  W_SaldoAnt + (W_Db - W_Cr)
   Else
      Replace E_SaldoAtu  With  W_SaldoAnt + (W_Cr - W_Db)
   EndIf

Return ''

&&=========================================================================&&

Function D2_Status

   Select Status

   Seek W_Ano + W_Mes

   If .Not. Found()
      Append Blank
      Replace  O_Ano  With  W_Ano
      Replace  O_Mes  With  W_Mes
   EndIf

   Replace  O_Status With 'A'

Return ''

&&=========================================================================&&


