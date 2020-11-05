*****************************************************************************
*                                                                           *
* Arquivo  : CT1000.Prg                Update : 16:52:00  5/17/1990         *
*                                                                           *
* Sistema  : Sistema integrado de Contabilidade                             *
*                                                                           *
* Objetivo : Submenu de manutencao de cadastros                             *
*                                                                           *
*****************************************************************************

Save Screen To SaveTela

Opc1 = 1

MnT1000()

Do While LastKey() <> 27

   Do Case
      Case Opc1 = 1
           Do Ct1001     && Cadastro de empresas
      Case Opc1 = 2
           Do Ct1004     && Plano de Contas
      Case Opc1 = 3
           Do Ct1006     && Historicos Padrao
   EndCase

   Restor Screen From SaveTela

   MnT1000()

EndDo

Restor Screen From SaveTela

Return

&&=========================================================================&&

Function  MnT1000

DrawShadow (08,35,06,27,'W+/R+B','W/B',' Atualizacao ','I/N')

Set Color TO W/B

InitMenu (09,36)
MakeMenu ('   A - Empresas           ')
MakeMenu ('   B - Plano de Contas    ')
MakeMenu ('   C - Historico Padrao   ')

Menu To Opc1

Return ('')

&&=========================================================================&&
