/*

   FPG0900.PRG - Cadastro de Salario Minimo

*/
#include "inkey.ch"
altd(1)

telanum('SCE0900','FPG0900')

abrir("FPG0900")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela Salario "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "PERIODO"          )
aadd( CAMPO     , "VL_SALMIN"        )
aadd( MASCARA   , "9999"             )
aadd( MASCARA   , "@E 999,999.99"    )
aadd( CABECALHO , "Periodo"          )
aadd( CABECALHO , "Salario no Mes"   )
aadd( TAMANHO   , 07 )
aadd( TAMANHO   , 14 )

setcolor(W_COREDIT)
tedite900()

select FPG0900

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

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if !eof()
             editae900()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere900()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Salario (S/N) ?")
                while FPG0900->( ! rlock() ); end
                FPG0900->( dbdelete() )
                FPG0900->( dbunlock() )
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
function insere900()
************************************

private X_PERIODO,X_VL_SALMIN

setcursor(1)

while .t.

   telae900()

   X_PERIODO   := space(4)
   X_VL_SALMIN     := 0.00

   @ 04,26 get X_PERIODO        picture "9999" valid ! empty( X_PERIODO )
   @ 06,26 get X_VL_SALMIN      picture "@E 999,999.99" valid X_VL_SALMIN > 0
   read

   if lastkey()=27; exit; end

   X_PERIODO := zerofill( X_PERIODO )

   @ 04,26 say X_PERIODO

   if dbseek(X_PERIODO)
      mensbeep(" Salario ja cadastrado ")
      loop
   end

   if pergunta('Confirma inclusao do Salario (S/N) ?')
      FPG0900->( dbappend() )
      repl FPG0900->PERIODO       with X_PERIODO
      repl FPG0900->VL_SALMIN     with X_VL_SALMIN
      scroll(09,27,19,54,1)
      FPG0900->( dbunlock() )
   end

end

************************************
function editae900()
************************************
setcursor(1)

telae900()

@ 04,26 say    FPG0900->PERIODO
X_VL_SALMIN      := FPG0900->VL_SALMIN

@ 06,26 get X_VL_SALMIN pict "@!"
read

if empty(X_VL_SALMIN) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG0900->( ! rlock() ); end
FPG0900->VL_SALMIN     := X_VL_SALMIN
FPG0900->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe900
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite900()
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
Procedimento .: TELAe900
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae900()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Periodo ( Ano/Mes )..:                                                   '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Salario no Mes.......:                                                   '
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

