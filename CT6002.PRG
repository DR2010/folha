*****************************************************************************
*                                                                           *
* Arquivo  : Ct6002.Prg                 Update : 14:49:32  12/11/1990      *
*                                                                           *
* Sistema  : Sistema de  Contabilidae                                     *
*                                                                           *
* Objetivo : Restaura os arquivos                                           *
*                                                                           *
*****************************************************************************

Message (' Tecle <Esc> para abortar ou outra tecla para continuar  ')

If LastKey() = 27
   Return
EndIf

Save Screen to SvTel
Clear

Run Restore a: c:

Restore Screen from SvTel

SvLin = ' '
SvLin = SaveScreen (24,0,24,79)
SvCor = SetColor()

Set Color to W/B

Mens = ' Descompactando arquivos, aguarde... '

@ 24,00 Say Space(80)
@ 24,(80-Len(Mens))/2 Say Mens

If LastKey() = 27
   Return
EndIf

Run Pkxarc -r CtComp > Descomp     && Compactando os arquivos de dados

Tone(500)

SetColor   (SvCor)
RestScreen (24,0,24,79,SvLin)

Message (' Restauracao terminada, tecle algo para retornar ')

Return
