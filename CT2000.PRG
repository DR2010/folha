*****************************************************************************
*                                                                           *
* Arquivo  : CT2000.Prg                Update : 16:52:00  5/17/1990         *
*                                                                           *
* Sistema  : Sistema integrado de afretamentos maritimos                    *
*                                                                           *
* Objetivo : Submenu do modulo de listagem dos cadastros                    *
*                                                                           *
*****************************************************************************
Save Screen to SaveTela

Opc2 = 1

MnT2000()

Do While LastKey() <> 27

   If LastKey() <> 27

      Do Case
         Case Opc2 = 1
&&            Do Ct2001      && Empresas
         Case Opc2 = 2
              Do Ct2004      && Plano de Contas
         Case Opc2 = 3
              Do Ct2005      && Historico Padrao
      EndCase
   EndIf

   Restor Screen From SaveTela

   MnT2000()

EndDo

Restor Screen From SaveTela

Return

&&=========================================================================&&

Function  MnT2000

DrawShadow (08,35,06,26,'W+/R+B','W/B',' Listagens ','I/N')

Set Color TO W/B

InitMenu (09,36)

MakeMenu ('  A - Empresas           ')
MakeMenu ('  B - Plano de Contas    ')
MakeMenu ('  C - Historico Padrao   ')

Menu To Opc2

Return ('')

&&=========================================================================&&
