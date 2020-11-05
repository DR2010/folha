/*

   FPG2500.PRG - Tabela de Parametros

*/
#include "inkey.ch"
altd(1)

telanum('SCE2500','FPG2500')

abrir("FPG2500")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Parametros "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "LIMIINSS"           )
aadd( CAMPO     , "LIMIIRRF"           )
aadd( MASCARA   , "@E 999,999,999.99"  )
aadd( MASCARA   , "@E 999,999,999.99"  )
aadd( CABECALHO , "Lim.INSS "          )
aadd( CABECALHO , "Lim.IRRF "          )
aadd( TAMANHO   , 15                   )
aadd( TAMANHO   , 58                   )

setcolor(W_COREDIT)
tedite2500()

select FPG2500

TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
                     CABECALHO      , ;
                     TAMANHO        , ;
                     BESCAPE        , ;
                     COR            , ;
                     TITULO         , ;
                     LININI         , ;
                     LINFIM         , ;
                     COLINI         , ;
                     BLOCK_DISP     , ;
                     CAB_TITULO     , ;
                     BORDA          , ;
                     COLFIM           ;
                   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

//    case TEC == -3   && alteracao f4
  //      if !eof()
    //       editae2500()
      //  end
        //  keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere2500()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do  Parametro (S/N) ?")
                while FPG2500->( ! rlock() ); end
                FPG2500->( dbdelete() )
                FPG2500->( dbunlock() )
                dbskip()
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function insere2500()
************************************

private X_LIMIINSS,X_LIMIIRRF

setcursor(1)

while .t.

   telae2500()

   X_LIMIINSS        := 0.00
   X_LIMIIRRF        := 0.00

   @ 04,26 get X_LIMIINSS        picture "@E 999,999,999.99"
   @ 06,26 get X_LIMIIRRF        picture "@E 999,999,999.99"
   read

   if lastkey()=27; exit; end

   if dbseek(X_LIMIINSS)
      mensbeep(" Parametro ja cadastrado")
      loop
   end

   if pergunta('Confirma inclusao do Parametro (S/N) ?')
      FPG2500->( dbappend() )
      repl FPG2500->LIMIINSS      with X_LIMIINSS
      repl FPG2500->LIMIIRRF      with X_LIMIIRRF
      scroll(09,27,19,54,1)
      FPG2500->( dbunlock() )
   end

end

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe2500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite2500()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TELAe2500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae2500()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Limite do INSS......:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Limite do IRRF......:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say '                                                                          '
   @ 09,03 say '                                                                          '
   @ 10,03 say '                                                                          '
   @ 11,03 say '                                                                          '
   @ 12,03 say '                                                                          '
   @ 13,03 say '                                                                          '
   @ 14,03 say '                                                                          '
   @ 15,03 say '                                                                          '
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '
   @ 22,03 say '                                                                          '



