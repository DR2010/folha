*****************************************************************************
*                                                                           *
* Arquivo  : Ct2004.Prg                Update : 18:08:38  7/28/1990         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Listagem do plano de contas                                    *
*                                                                           *
*****************************************************************************

Public SaveColor

SaveColor = SetColor()

B4_Inicializa()

B4_Processa()

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function B4_Inicializa

Public Data,Contlin,ContPag,W_Emp,W_Data,W_Hora

UseCtD001()
UseCtD002()

Select Empresa
Go top

W_Emp     = A_Nome
W_Data    = Date()
W_Hora    = Time()

ContPag   = 1
Contlin   = 1

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return ''

&&=========================================================================&&

Function B4_Processa

If .Not. MsgPrompt(" Confirma a impressao ? ",1)
    Return("")
EndIf

If .Not. IsPrinter()
    Message(" Prepare Impressora e tecle <ENTER>")
Else
   Set Color to W/B
   @ 24,01 Say Space(80)
   @ 24,01 Say "Tecle <ESC> para abortar..."
   Set Color to &Cor
EndIf

Set Device  to Printer

Select Conta

Do While (LastKey() <> 27) .And. (.Not. Eof())

   B4_Cabecalho()

   Do While (ContLin < 55) .And. (LastKey() <> 27) .And. (.Not. Eof())

      W_Grau1 = SubStr (B_Conta,1,1)
      W_Grau2 = SubStr (B_Conta,2,1)
      W_Grau3 = SubStr (B_Conta,3,2)
      W_Grau4 = SubStr (B_Conta,5,2)
      W_Grau5 = SubStr (B_Conta,7,2)
      W_Grau6 = SubStr (B_Conta,9,3)
      W_DV    = '0'

      Do case
         Case W_grau6 <> '000'
              C = 46
         Case W_grau5 <> '00'
              C = 44
         Case W_grau4 <> '00'
              C = 42
         Case W_grau3 <> '00'
              C = 40
         Case W_grau2 <> '0'
              C = 38
         Case W_grau1 <> '0'
              C = 36
      EndCAse

      PRT( 00  , W_Grau1     , '.' )
      PRT( 02  , W_Grau2     , '.' )
      PRT( 04  , W_Grau3     , '.' )
      PRT( 07  , W_Grau4     , '.' )
      PRT( 10  , W_Grau5     , '.' )
      PRT( 13  , W_Grau6     , '.' )
      PRT( 17  , B_Analitic  , '.' )
      PRT( 20  , B_Result    , '.' )
      PRT( 23  , B_Apelido   , '.' )
      PRT( C   , B_Desc      , '.' )

      @ Prow()+1,0

      Skip

      ContLin = ContLin + 1

   EndDo

   Eject

EndDo

Set Device to Screen

Return ''

&&=========================================================================&&

Function B4_Cabecalho

*          1         2         3         4         5         6         7         8
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*CTR2004         Listagem do plano de contas         99/99/99  99:99       Pag: 99
*
*Empresa : XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
*   C O N T A     A  R  APELIDO   D E S C R I C A O
*---------------- -  -  -------   -----------------
*
*   X.X.XX.XX.XX.XXX   XXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

L_Titulo = 'Plano de Contas'

@ Prow()   ,0  Say 'CTR2004'
@ Prow()   , CalcCenter(0,79,Len(L_Titulo))  Say  L_Titulo
@ Prow()   ,71 Say 'Pag: ' + StrZero(ContPag,3)
@ Prow()+2 , CalcCenter(0,79,Len(W_Emp)) Say W_Emp
@ Prow()+2 ,00 Say 'Referencia : '+ DtoC(W_Data) +'   '+ W_Hora
@ Prow()+2 ,0  Say '   C O N T A     A  R   APELIDO     D E S C R I C A O'
@ Prow()+1 ,0  Say '---------------- -  -  ----------   -----------------'
@ Prow()+2 ,0

ContPag  = ContPag + 1
ContLin  = 1

Return ''

&&=========================================================================&&

