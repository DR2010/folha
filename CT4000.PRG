*****************************************************************************
*                                                                           *
* Arquivo  : CT4000.Prg                Update : 19:48:26  8/1/1992          *
*                                                                           *
* Sistema  : Sistema integrado de afretamentos maritimos                    *
*                                                                           *
* Objetivo : Submenu do modulo de fechamento                                *
*                                                                           *
*****************************************************************************
Save Screen to SaveTela

mnt4000()

Do While LastKey() <> 27

   If LastKey() <> 27

      Do Case
         Case Opc4 = 1
              Do Ct4001      && Lancamentos
         Case Opc4 = 2
              Do Ct4002      && Apuracao de resultados
      EndCase
   EndIf

   Restor Screen From SaveTela

   mnt4000()

EndDo

Restor Screen From SaveTela

Return

&&=========================================================================&&

Function  mnt4000

DrawShadow(09,26,6,31,'W+/R+B','W/B',' Fechamento ','I/N')

Set Color TO W/B

InitMenu (10,27)
MakeMenu('  A - Fechamento Mensal       ')
MakeMenu('  B - Apuracao de Resultados  ')

Menu To Opc4

Return ('')

&&=========================================================================&&
