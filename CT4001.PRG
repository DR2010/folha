*****************************************************************************
*                                                                           *
* Arquivo  : Ct4001.Prg                Update : 22:43:02  7/27/1992         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Fechamento mensal dos saldos das contas.                       *
*                                                                           *
*****************************************************************************

Public SaveColor

SaveColor = SetColor()

UseCtD002()
UseCtD004()
UseCtD005()
UseCtD009()
UseCtD012()
UseCtD015()
UseCtD019()

D1_Inicializa()   && Inicializa parametros de processamento
D1_Processa()     && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function D1_Inicializa

Public Data,W_Livro,W_Pagina,W_Emp,W_Mes,W_Ano,W_Data,W_Hora,W_Empresa
Public W_TotDiaD,W_TotDiaC,W_TotPageD,W_TotPageC,W_TotD,W_TotC,W_DiaAnt
Public W_Conta,W_Grau1,W_Grau2,W_Grau3,W_Grau4,W_Grau5,W_Grau6,W_SaldoCalc
Public W_Dia, W_Ano, W_ContaAnt, W_AnoAnt, W_MesAnt, CalledIni, CalledFim
Public W_Arquivo

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return ''

&&=========================================================================&&

Function D1_Processa

D1_Tela()

Do While LastKey() <> 27

   D1_SaldoContas()
   D1_SaldoAtu()
   D1_Status()
   D1_Tela()

EndDo

Return ''

&&=========================================================================&&

Function D1_Tela

L_Lin = 11
L_Col = 33

Titulo = ' Fechamento Mensal '

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

  W_Arquivo = '@@@@' + W_Ano + W_Mes

  Select Status
  Seek W_Ano + W_Mes

  If Found() .And. O_Status = 'A'
     If .Not. MsgPrompt('Ja foi efetuada apuracao do exercicio, Deseja prosseguir?',2)
        Loop
     EndIf
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
&& Cria Arquivo de trabalho contendo as contas movimentadas no mes com os
&& respectivos valores de debito e credito.

Function D1_SaldoContas

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

Select SaldoInter

Zap

ReIndex

Select Lancamento

Set Order To 3
Go Top

Set  SoftSeek On
Seek CalledIni
Set  SoftSeek Off

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

Function D1_SaldoAtu

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

Function D1_Atualiza

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

Function D1_Status

   Select Status

   Seek W_Ano + W_Mes

   If .Not. Found()
      Append Blank
      Replace  O_Ano  With  W_Ano
      Replace  O_Mes  With  W_Mes
   EndIf

   Replace  O_Status With 'F'

Return ''

&&=========================================================================&&


