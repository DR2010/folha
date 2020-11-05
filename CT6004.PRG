*****************************************************************************
*                                                                           *
* Arquivo  : Ct6004.Prg                 Update : 9:48:07  12/11/1990        *
*                                                                           *
* Sistema  : Sistema de Contabilidade                                       *
*                                                                           *
* Objetivo : Limpeza dos arquivos                                           *
*                                                                           *
*****************************************************************************

Do Ct6004_Inicializa

Do Ct6004_Ponto

ClearKeyBoard()

Return

&&=========================================================================&&

Procedure Ct6004_Inicializa

Public SalvaTela

Set Score   Off
Set Delete  On
Set Confirm On

OpcLmp = 1

Return

&&=========================================================================&&

Procedure Ct6004_Ponto

Do Ct6004_FootKey

Save Screen To SalvaTela

Do While LastKey() <> 27

   DrawShadow (10,30,07,30,'W+/R+B','W/B',' Limpeza de Arquivo ','I/N')

   Set Color TO W/B

   InitMenu (11,31)
   MakeMenu ('      TODOS                  ')
   MakeMenu ('      Empresas               ',2)
   MakeMenu ('      Plano de Contas        ',0)
   MakeMenu ('      Historico Padrao       ',0)
   MakeMenu ('      Lancamentos            ',0)
   MakeMenu ('      Arquivos               ',0)

   Menu to OpcLmp

   Do Case

      Case OpcLmp = 1
           Do LimpaTodos

      Case OpcLmp = 2
           use ctd001
           pack
           index on a_Cod  to cti00101
           index on a_Nome to cti00102

      Case OpcLmp = 3
            use ctd002
            pack
            index on B_Conta    to cti00201
            index on B_Apelido  to cti00202

      Case OpcLmp = 4
           use ctd003
           Pack
           Index on C_CodHist to Cti00301

      Case OpcLmp = 5
           Use ctd004
           pack
           Index on D_Arquivo + StrZero(D_Seq,2)  To Cti00401
           Index on D_Conta   + DtoC(D_Data)      To Cti00402
           Index on D_Data                        To Cti00403

      Case OpcLmp = 6
           pack
           use ctd009
           pack
           index on I_Arquivo To Cti00901

   EndCase

   If LastKey() # 27
      Message (' Arquivo(s) limpo(s), tecle algo para retornar ')
      ClearKeyBoard()
   EndIf

   Use
   Restor Screen From SalvaTela

EndDo

Restor Screen From SalvaTela

Return

&&=========================================================================&&

Procedure Ct6004_FootKey

Set Color To W+/BG

@ 24,00 Say  Replicate (' ',80);

@ 24,01 Say  'Enter'
@ 24,25 Say  'Esc'

Set Color To /BG

@ 24,06 Say '-Seleciona Opcao'
@ 24,28 Say '-Fim'

Return

&&=========================================================================&&

Procedure LimpaTodos

use ctd001
pack
index on a_Cod  to cti00101
index on a_Nome to cti00102

use ctd002
pack
index on B_Conta    to cti00201
index on B_Apelido  to cti00202

Use ctd003
pack
Index on c_codhist to cti00301

Use ctd004
pack
Index on D_Arquivo + StrZero(D_Seq,2)  To Cti00401
Index on D_Conta   + DtoC(D_Data)      To Cti00402
Index on D_Data                        To Cti00403

use ctd005
pack
index on e_conta + e_ano + e_mes to cti00501
index on e_ano + e_mes + e_conta to cti00502

use ctd009
pack
index on I_Arquivo To Cti00901

use ctd012
pack
index on L_Conta To Cti01201

use ctd015
pack
index on O_Ano + O_Mes To Cti01501

use ctd017
pack
index on R_Conta To Cti017001

use ctd020
pack
index on T_Ano + T_Mes + T_Conta To Cti02001

Use

RestScreen(24,00,24,79,SalvaTela)

Return

&&=========================================================================&&
