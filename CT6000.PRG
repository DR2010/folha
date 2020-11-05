*****************************************************************************
*                                                                           *
* Arquivo  : Ct6000.Prg                 Update : 11:44:44  12/11/1990       *
*                                                                           *
* Sistema  : Sistema de Contabilidade                                       *
*                                                                           *
* Objetivo : Utilitarios do sistema                                         *
*                                                                           *
*****************************************************************************

Do Ct6000_Inicializa

Do Ct6000_Menu

Set Color To

Clear

Return

&&=========================================================================&&

Procedure Ct6000_Inicializa

Public Sistema,SalvaTela,SalvaCor,OpcUtil

Set Score   Off
Set Delete  On
Set Confirm On

OpcUtil   = 1

Return

&&=========================================================================&&

Procedure Ct6000_Menu

Clear Gets

Cor = SetColor()

Do Cp6000_FootKey

Save Screen To SalvaTela

Do While LastKey() <> 27

   DrawShadow (08,23,08,40,'W+/R+B','W/B',' Utilitarios ','I/N')

   Set Color TO W/B

   InitMenu (12,31)

   InitMenu (09,24)

   MakeMenu ('   A - Backup dos Arquivos de Dados    ',1)
   MakeMenu ('   B - Restaura Arquivos de Dados      ',1)
   MakeMenu ('   C - Indexacao dos Arquivos          ',1)
   MakeMenu ('   D - Limpeza dos Arquivos            ',1)

   Menu to OpcUtil

   Do Case
      Case OpcUtil = 1
&&           Do Ct6001
           ClearKeyBoard()
      Case OpcUtil = 2
&&          Do Ct6002
           ClearKeyBoard()
      Case OpcUtil = 3
           Do Ct6003
           ClearKeyBoard()
      Case OpcUtil = 4
           Do Ct6004
           ClearKeyBoard()
   EndCase

   Restore Screen From SalvaTela

EndDo

Restore Screen From SalvaTela

Return

&&=========================================================================&&

Procedure Cp6000_FootKey

Set Color To W+/BG

@ 24,00 Say  Replicate (' ',80);

@ 24,01 Say  'Enter'
@ 24,25 Say  'Esc'

Set Color To /BG

@ 24,06 Say '-Seleciona Opcao'
@ 24,28 Say '-Fim'

Return

&&=========================================================================&&
