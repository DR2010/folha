*****************************************************************************
*                                                                           *
* Arquivo  : CT5000.Prg                Update : 16:52:00  5/17/1990         *
*                                                                           *
* Sistema  : Sistema Contabilidae                                           *
*                                                                           *
* Objetivo : Submenu do modulo de relatorios                                *
*                                                                           *
*****************************************************************************

Opc5 = 0

Save Screen to SaveTela

MnT5000()

Do While LastKey() <> 27

   If LastKey() <> 27

      Do Case
         Case Opc5 = 1
               Do Ct5001      && Diario
         Case Opc5 = 2
               Do Ct5002      && Razao analitico
         Case Opc5 = 3
               Do Ct5004      && Balancete de conferencia
         Case Opc5 = 4
               Do Ct5005      && Demonstracao da apuracao
         Case Opc5 = 5
               Do Ct5006      && Balanco patrimonial
      EndCase
   EndIf

   Restor Screen From SaveTela

   MnT5000()

EndDo

Restor Screen From SaveTela

Return

&&=========================================================================&&

Function  MnT5000

DrawShadow (9,30,09,33,'W+/R+B','W/B',' Relatorios ','I/N')

Set Color TO W/B

InitMenu (10,31)

MakeMenu (' A -  Diario                    ')
MakeMenu (' B -  Razao Analitico           ')
MakeMenu (' C -  Balancete                 ')
MakeMenu (' D -  Demontrativo de Apuracao  ')
MakeMenu (' E -  Balanco Patrimonial       ')

Menu To Opc5

Return ''

&&=========================================================================&&
