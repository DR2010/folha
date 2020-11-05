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

   Set device to print
   E1_Totaliza()
   set device to screen

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

go top

Do While (.Not. Eof())

   W_conta = D_Conta

   Select Conta

   Seek W_Conta

   If .Not. Found()
      @ prow()+1,0 say 'Lancamento p/ conta nao cadastrada : ' + w_conta
      @ prow()  ,Pcol()+2 say Lancamento->d_arquivo
      @ prow()  ,Pcol()+2 say Lancamento->d_bloco
   Else
      If B_Analitic # 'S'
         @ prow()+1,0 say 'Lancamento p/ conta sintetica : ' + w_conta
         @ prow()  ,Pcol()+2 say Lancamento->d_arquivo
         @ prow()  ,Pcol()+2 say Lancamento->d_bloco
      EndIf
   EndIf

   Select Lancamento

   Skip

EndDo

Return ''

&&=========================================================================&&
