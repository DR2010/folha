*****************************************************************************
*                                                                           *
* Arquivo  : Ct1001.Prg                Update : 12:37:31  4/23/1991         *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Manutencao no cadastro de clientes                             *
*                                                                           *
*****************************************************************************

Title      = ' E M P R E S A S '
Called     = '   '
SetValid   = .t.

Sele 1
Use CtD001 Index CtI00101 Alias Clientes

Do Ct001_00_Fields         && Inicializa a estrutura dos campos

Do Ct001_01_Inicializa     && Inicializa parametros de processamento

Do Ct001_02_Processa       && Rotina de processamento

Close Data

Release All

Set Color To

Clear

Return

&&=========================================================================&&

Procedure Ct001_00_Fields

InitFields (26)

MakeStruct ('A_Nome'      ,40 ,'C' ,'@!'             ,04 ,13,'CheioValid')
MakeStruct ('A_End'       ,40 ,'C' ,'@!'             ,05 ,13,'CheioValid')
MakeStruct ('A_Bairro'    ,30 ,'C' ,'@!'             ,06 ,13,'CheioValid')
MakeStruct ('A_Cidade'    ,30 ,'C' ,'@!'             ,07 ,13,'CheioValid')
MakeStruct ('A_Estado'    ,02 ,'C' ,'@!'             ,07 ,52,'CheioValid')
MakeStruct ('A_CEP'       ,08 ,'C' ,'99999999'       ,07 ,64,'CheioValid')
MakeStruct ('A_CGCNum'    ,08 ,'C' ,'99999999'       ,09 ,13 )
MakeStruct ('A_CGCFilial' ,04 ,'C' ,'9999'           ,09 ,22 )
MakeStruct ('A_CGCDig'    ,02 ,'C' ,'99'             ,09 ,27 )
MakeStruct ('A_InscEst'   ,15 ,'N' ,'999999999999999',10 ,13 )
MakeStruct ('A_InscMun'   ,15 ,'N' ,'999999999999999',11 ,13 )
MakeStruct ('A_DDD'       ,04 ,'C' ,'9999'           ,13 ,14 )
MakeStruct ('A_Tel1'      ,07 ,'C' ,'9999999'        ,13 ,21 )
MakeStruct ('A_Tel2'      ,07 ,'C' ,'9999999'        ,13 ,30 )
MakeStruct ('A_Tlx1'      ,12 ,'C' ,'999999999999'   ,13 ,48 )
MakeStruct ('A_Tlx2'      ,12 ,'C' ,'999999999999'   ,13 ,62 )
MakeStruct ('A_Contato1'  ,20 ,'C' ,'@!'             ,15 ,15 )
MakeStruct ('A_Cargo1'    ,20 ,'C' ,'@!'             ,15 ,46 )
MakeStruct ('A_Contato2'  ,20 ,'C' ,'@!'             ,16 ,15 )
MakeStruct ('A_Cargo2'    ,20 ,'C' ,'@!'             ,16 ,46 )
MakeStruct ('A_Resp'      ,30 ,'C' ,'@!'             ,18 ,15,'CheioValid')
MakeStruct ('A_Contador'  ,30 ,'C' ,'@!'             ,19 ,15 )
MakeStruct ('A_CRC'       ,08 ,'N' ,'99999999'       ,19 ,54 )
MakeStruct ('A_UF_CRC'    ,02 ,'C' ,'@!'             ,19 ,70 )
MakeStruct ('A_Livro'     ,04 ,'N' ,'9999'           ,20 ,15,'CheioValid')
MakeStruct ('A_Folha'     ,06 ,'N' ,'999999'         ,20 ,32,'CheioValid')

Return

&&=========================================================================&&

Procedure Ct001_01_Inicializa

Set Score   Off
Set Delete  On
Set Confirm On

Return

&&=========================================================================&&

Procedure Ct001_02_Processa

Do Ct001_04_Tela1

Do While LastKey() <> 27

   Select Clientes

   Seek Called

   If .Not. Found()
      If MsgPrompt (' Cliente nao existe. Deseja inclui-lo ? ',1)
         Do Ct001_08_Inclusao
      EndIf
   Else
      Do Ct001_12_Manutencao
   EndIf

   Do Ct001_04_Tela1

EndDo

Return

&&=========================================================================&&

Procedure Ct001_04_Tela1

Set Color To 7/1
Clear

Set Color To W+W/R
@ 0,0 To 23,79  Double
@ 00,02 Say  '                                                                            '

@ 00,02 Say Cliente
Set Color To /W
@ 00,CalcCenter(00,79,Len(Title)) Say Title

Set Color To 7/1

Do Ct001_T01   && Contem formato da tela

Do Ct001_05_Foot0
Do Ct001_06_LimpaVar
SetValid = .f.
Do Ct001_07_Mostra
SetValid = .t.

*Set Key -1 To Ct001_16_Inquiry  && F2 consulta por codigo

Set Color To W/G+,W+/G

Called = 0
@ 02,13 Get Called Pict '999' Valid Called # 0
Read

Called = StrZero(Called,3)

*Set Key -1 To                   && Desfaz assinalamento da F2

Return

&&=========================================================================&&

Procedure Ct001_T01
*                    1         2         3         4         5         6         7
*          01234567890123456789012345678901234567890123456789012345678901234567890123456789

@ 02,1 Say ' Codigo   : ___'

@ 04,1 Say ' Nome     : ________________________________________'
@ 05,1 Say ' Endereco : ________________________________________'
@ 06,1 Say ' Bairro   : ______________________________'
@ 07,1 Say ' Cidade   : ______________________________     UF: __     Cep: ________'

@ 09,1 Say ' CGC      : ________/____/__'
@ 10,1 Say ' Insc. Est: _______________'
@ 11,1 Say ' Insc. Mun: _______________'

@ 13,1 Say ' Telefone : (____)  _______  _______    Telex: ____________  ____________'

@ 15,1 Say ' Contatos : 1 ____________________   Cargo : ____________________'
@ 16,1 Say '            2 ____________________   Cargo : ____________________'

@ 18,1 Say ' Responsavel: ______________________________'
@ 19,1 Say ' Contador   : ______________________________    CRC: ________    UF: __'
@ 20,1 Say ' Livro      : ____     Pagina: ______'

Return

&&=========================================================================&&

Procedure Ct001_05_Foot0

*MakeFoot ('w+/bg','/bg','F1/-Help  /F2/-Modo de consulta  /Esc/-Sai/')
MakeFoot ('w+/bg','/bg','F1/-Help  /Esc/-Sai/')

Return

&&=========================================================================&&

Procedure Ct001_06_LimpaVar

ClearFields()

Return

&&=========================================================================&&

Procedure Ct001_07_Mostra

Set Color To N/W,B/W,,,N/G

ShowFields()

Return

&&=========================================================================&&

Procedure Ct001_08_Inclusao

Do Ct001_09_Foot1
Do Ct001_06_LimpaVar

Do While .t.
  Do Ct001_10_LerTela
  If LastKey() = 27
     If MsgPrompt (' Deseja abandonar este processo ? ',2)
        Exit
     EndIf
  Else
     If MsgPrompt (' Confirma inclusao ? ',1)
        Select Clientes
        Append Blank
        Replace A_Cod With Called
        Do Ct001_11_MoveTo
        Exit
     EndIf
  EndIf
EndDo

Return

&&=========================================================================&&

Procedure Ct001_09_Foot1

MakeFoot ('W+/BG','/bg','F1/-Help  /Esc/-Exit/');

Return

&&=========================================================================&&

Procedure Ct001_10_LerTela

Set Color To N/W,B/W,,,N/G

ReadFields()

Return

&&=========================================================================&&

Procedure Ct001_11_MoveTo

Select Clientes

MoveToBank()

Return

&&=========================================================================&&

Procedure Ct001_12_Manutencao

Do Ct001_13_MoveFrom
Do Ct001_07_Mostra

Do Ct001_09_Foot1

Set Color To W+/R,B/W

@ 24,50  Prompt  ' Consulta '
@ 24,60  Prompt  ' Alteracao '
@ 24,70  Prompt  ' Exclusao '

OpcManut = 1

Menu To OpcManut

Do Case
   Case OpcManut = 2
        Do Ct001_14_Alteracao
   Case OpcManut = 3
        Do Ct001_15_Exclusao
EndCase

KeyBoard Chr(0)

Return

&&=========================================================================&&

Procedure Ct001_13_MoveFrom

Select Clientes

MoveFromBank()

Return

&&=========================================================================&&

Procedure Ct001_14_Alteracao

Do Ct001_09_Foot1

Do While .t.
  Do Ct001_10_LerTela
  If LastKey() = 27
     If MsgPrompt (' Deseja abandonar este processo ? ',2)
        Exit
     EndIf
  Else
     If MsgPrompt (' Confirma alteracao ? ',1)
        Select Clientes
        Do Ct001_11_MoveTo
        Exit
     EndIf
  EndIf
EndDo

Return

&&=========================================================================&&

Procedure Ct001_15_Exclusao

If MsgPrompt (' Confirma exclusao ? ',2)
   Select Clientes
   Delete
EndIf

Return

&&=========================================================================&&

Procedure Ct001_16_Inquiry

Set Key -1 To

Declare Tab1[2],Tab2[2],Tab3[2]

Tab1 [1] = 'A_Cod'
Tab1 [2] = 'A_Nome'

Tab2 [1] = 8
Tab2 [2] = 40

Tab3 [1] = ''
Tab3 [2] = '  '

Save Screen To SalvaTela

DrawShadow (3,7,17,65,'B/W','W+/B')

Do Ct001_17_FootKey

@ 3,09 Say ' Codigo '
@ 3,19 Say ' Nome '

Select Clientes

Set Color To  W+/B,N/W+,,,W+/BG

Called = DbShow (5,8,14,63,Tab1,Tab2,Tab3,'A_Cod',' ')

If Called <> 0
   KeyBoard Chr(13)
Else
   Called = 0
EndIf

Restor Screen From SalvaTela

Set Key -1 To Ct001_16_Inquiry

Return


&&=========================================================================&&

Procedure Ct001_17_FootKey

MakeFoot ('W+/BG','/bg','F1/-help  /Enter/-Seleciona cliente  /Esc/-Sai/');

Return

&&=========================================================================&&

Function UfValid

Parameters Campo

If .Not. SetValid
   Return (.t.)
EndIf

Select UF

Seek Campo

If .Not. Found()
   Message (' Estado nao cadastrado ')
   Return (.f.)
EndIf


Return (.t.)

&&=========================================================================&&

Function CheioValid

Parameters Campo

If .Not. SetValid
   Return (.t.)
EndIf

If Empty(Campo)
   Message (' Campo vazio ')
   Return (.f.)
EndIf

Return (.t.)

