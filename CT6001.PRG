*****************************************************************************
*                                                                           *
* Arquivo  : Cp6001.Prg                Update : 15:50:09  11/23/1990        *
*                                                                           *
* Sistema  : Sistema de Contabilidade                                       *
*                                                                           *
* Objetivo : BackUp do arquivos de dados                                    *
*                                                                           *
*****************************************************************************

Message (' Tecle <Esc> para abortar ou outra tecla para continuar ')

If LastKey() = 27
   Return
EndIf

SvLin = ' '
SvLin = SaveScreen (24,0,24,79)
SvCor = SetColor()

Set Color to W/B

Mens = ' Compactando arquivos, aguarde... '

@ 24,00 Say Space(80)
@ 24,(80-Len(Mens))/2 Say Mens

&&Run Pkarc -a CtComp *.dbf>COMPACTA      && Compactando os arquivos de dados

Tone(500)

SetColor   (SvCor)
RestScreen (24,0,24,79,SvLin)

If LastKey() = 27
   Return
EndIf

Save Screen to SvTel
Clear

Run Backup \sistema\teste\CtComp.ARC a:

Restore Screen from SvTel

Message (' Backup terminado, tecle algo para retornar ')

Return
