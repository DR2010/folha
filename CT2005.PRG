*****************************************************************************
*                                                                           *
* Arquivo  : Ct2003.Prg                Update : 20:07:47  7/29/1990         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Listagem do cadastro de Historico                              *
*                                                                           *
*****************************************************************************

CT2005_Inicializa()

CT2005_Processa()

Close Data

Release All

Set Color to

Return

&&=========================================================================&&

Function CT2005_Inicializa

Sele 0
Use CTD003 Index CTI00301  alias Historico

Sele 0
Use Ctd001 Index Cti00101 alias Empresa

Public ContLin,ContPag,Cor,W_Data,W_Hora,W_Emp

Select Empresa
Go top

W_Emp   = A_Nome
W_Data  = Date()
W_Hora  = Time()

ContPag = 1
ContLin = 1

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Return("")

&&=========================================================================&&

Function CT2005_Processa

If .Not. MsgPrompt(" Confirma a impressao ? ",1)
    Return("")
EndIf

If .Not. IsPrinter()
    Message(" Prepare Impressora e Tecle < ENTER >")
Else
   Set Color to W/B
   @ 24,01 Say Space(80)
   @ 24,01 Say "Tecle <ESC> para abortar..."
   Set Color to &Cor
EndIf

Set Device  to Printer
*Set Printer to Hist

Select Historico

Do While (LastKey() <> 27) .And. (.Not. Eof())

   CT2005_Cabecalho()

   Do While (ContLin < 55) .And. (LastKey() <> 27) .And. (.Not. Eof())

      @ (PRow() + 1),20 Say "|  "+C_Codhist +" | "+C_Desc+ "   |  "

      Skip
      ContLin = ContLin + 1

   EndDo

   @ (PRow() + 1),20 Say "+-----------+----------------------------------+"

   Eject

EndDo

Set Device to Screen

Return("")

&&=========================================================================&&

Function CT2005_Cabecalho

*          1         2         3         4         5         6         7         8
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*CTR03                         CADASTRO DE HISTORICO          99/99/99  99:99          Pag: 99
*
*Empresa : XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*
@  Prow()     ,0  Say 'CTR05          Listagem de Historicos'
@  Prow()     ,51 Say W_Data
@  Prow()     ,61 Say W_Hora
@  Prow()     ,73 Say 'Pag: ' + StrZero(ContPag,3)
@  Prow() + 2 ,0  Say 'Empresa : ' + W_Emp
@  Prow() +2  ,25 Say '             CADASTRO DE HISTORICO  '
@ (Prow() + 2),20 Say "+-----------+----------------------------------+"
@ (Prow() + 1),20 Say "|    Cod    |            Descricao             |"
@ (Prow() + 1),20 Say "+-----------+----------------------------------+"

ContPag  = ContPag + 1
Contlin  = 1

Return("")


