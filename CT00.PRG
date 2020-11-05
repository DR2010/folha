*****************************************************************************
*                                                                           *
* Arquivo  : CT00.Prg                  Update : 16:52:00  5/17/1990         *
*                                                                           *
* Sistema  : Sistema integrado de Contabilidade                             *
*                                                                           *
* Objetivo : Menu principal do sistema                                      *
*                                                                           *
*****************************************************************************

Use Ctd001  Alias  Empresa

CT00_Inicializa()

CT00_Menu()

Set Color To

Clear

Return

&&=========================================================================&&

Function CT00_Inicializa

Public Sistema,Cliente,SalvaTela,SalvaCor,Opc0,Opc1,Opc2,Opc3,Opc4,Opc5

Sistema = ' S I S T E M A    D E    C O N T A B I L I D A D E '

Go Top

Cliente = Ltrim(Rtrim(A_Nome))

Close

Opc0 = 1
Opc1 = 1
Opc2 = 1
Opc3 = 1
Opc4 = 1
Opc5 = 1

Return ''

&&=========================================================================&&

Function CT00_Menu

Clear

DrawWindow (0,0,23,79,'W+/R+B','W/B')

SetColor('W+/R+B')

@ 2,0 Say 'Ì'+Replicate('Í',78)+'¹'
@ 1,CalcCenter(0,79,Len(Sistema)) Say Sistema
@ 4,CalcCenter(0,79,Len(Cliente)) Say Cliente

Do CT00_FootKey

Save Screen To SalvaTela

Do While .t.

   DrawShadow(06,18,11,42,'W+/R+B','W/B',' Menu Principal ','I/N')

   Set Color to W/B,I/N,N,N,I/N

   InitMenu (07,19)

   MakeMenu ('      A - Atualizacao de Cadastros       ',1)
   MakeMenu ('      B - Listagem de Cadastros          ',1)
   MakeMenu ('      C - Lancamentos Contabeis          ',1)
   MakeMenu ('      D - Fechamentos                    ',1)
   MakeMenu ('      E - Relatorios                     ',1)
   MakeMenu ('      F - Utilitarios                    ',1)
   MakeMenu ('      X - Termino                        ',2)

   Menu To Opc0

   If LastKey() = 27
      Opc0 = 7
   EndIf

   Do Case
      Case Opc0 = 1
           Call Ct1000               && Atualizacao
      Case Opc0 = 2
           Call Ct2000               && Listagens
      Case Opc0 = 3
           Call Ct3001               && Lancamentos
      Case Opc0 = 4
           Call Ct4000               && Fechamento
      Case Opc0 = 5
           Call Ct5000               && Relatorios
      Case Opc0 = 6
           Call Ct6000               && Utilitarios
      Case Opc0 = 7
           If MsgPrompt(' Deseja abandonar o sistema ?',2)
              Return ''
           EndIf
   EndCase

   ClearKeyBoard()

   Restore Screen From SalvaTela

EndDo

Restore Screen From SalvaTela

Return ''

&&=========================================================================&&

Procedure CT00_FootKey

Set Color To W+/BG

@ 24,00 Say  Replicate (' ',80)

@ 24,01 Say  'Enter'
@ 24,25 Say  'Esc'

Set Color To /BG

@ 24,06 Say '-Seleciona Opcao'
@ 24,28 Say '-Fim'

Return

&&=========================================================================&&

