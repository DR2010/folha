*****************************************************************************
*                                                                           *
* Arquivo  : Ct9002.Prg                 Update : 19:02:55  7/24/1992        *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Converte apelido da conta no numero da mesma, regravando no    *
*            arquivo de contas.                                             *
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

Public W_Arquivo

W_Arquivo = ''

UseCtD002()
UseCtD009()

Sele 0
Use CTD004 Index CTI00401    Alias Lancamento

Return ''

&&=========================================================================&&

Function E1_02_Processa

E1_Tela()

Do While LastKey() <> 27

   E1_Totaliza()

   E1_Tela()

EndDo

Return ''

&&=========================================================================&&

Function E1_Tela

  L_Lin = 7
  L_Col = 20

  Titulo = ' Conversao de Contas '

  DrawWindow (L_Lin,L_Col,04,36,'B/W','B/W',Titulo)

  @ L_Lin + 2, L_Col + 6  Say 'Arquivo:'


  W_Arquivo = '        '

  @ L_Lin+2,L_Col+14 Get W_Arquivo Pict '@!'  Valid  E1_Valid()

  Read

  If LastKey() = 27
     Return ''
  EndIf

Return ''

&&=========================================================================&&

Function E1_Valid

  Select Arquivo
  Seek W_Arquivo
  If .not. Found()
     Message('Arquivo nao existe.')
     Return .f.
  Endif

Return .t.

&&=========================================================================&&

Function E1_Totaliza

Select Lancamento

Set SoftSeek On
Seek W_Arquivo
Set SoftSeek Off

If D_Arquivo # W_Arquivo
   Message('Nao ha lancamentos para este arquivo.')
   Return ''
EndIf

Do While (.Not. Eof()) .And. (D_Arquivo = W_Arquivo)

   W_Apelido = D_Conta

   Select Conta
   Set Order To 2

   Seek W_Apelido

   If .Not. Found()
      Message('Apelido nao encontrado:'+W_Apelido)
   Else
      W_Conta = B_Conta
      Select Lancamento
      Replace D_Conta With W_Conta
   EndIf

   Select Lancamento

   Skip

EndDo

Return ''

&&=========================================================================&&
