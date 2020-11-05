/*

   FPG2600.PRG - Tabela de Imposto de Renda

*/
#include "inkey.ch"
altd(1)

telanum('SCE2600','FPG2600')

abrir("FPG2600")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Imposto de Renda "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "FAIXA"             )
aadd( CAMPO     , "INIC_FAIXA"        )
aadd( CAMPO     , "FIM_FAIXA"         )
aadd( CAMPO     , "PERCENTUAL"        )
aadd( MASCARA   , "99"                )
aadd( MASCARA   , "@E 999,999,999.99" )
aadd( MASCARA   , "@E 999,999,999.99" )
aadd( MASCARA   , "999.99"            )
aadd( CABECALHO , "Faixa"             )
aadd( CABECALHO , "Inicio-Faixa"      )
aadd( CABECALHO , "Fim-Faixa"         )
aadd( CABECALHO , "Percentual"        )
aadd( TAMANHO   , 05                  )
aadd( TAMANHO   , 14                  )
aadd( TAMANHO   , 14                  )
aadd( TAMANHO   , 38                  )

setcolor(W_COREDIT)
tedite2600()

select FPG2600

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
             editae2600()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere2600()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Imposto de Renda (S/N) ?")
                while FPG2600->( ! rlock() ); end
                FPG2600->( dbdelete() )
                FPG2600->( dbunlock() )
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
function insere2600()
************************************

private X_FAIXA,X_INIC_FAIXA,X_FIM_FAIXA,X_PERCENTUAL

setcursor(1)

while .t.

   telae2600()

   X_FAIXA      := space(2)
   X_INIC_FAIXA := 0.00
   X_FIM_FAIXA  := 0.00
   X_PERCENTUAL := 0.00

   @ 04,26 get X_FAIXA       picture "99"  valid ! empty( X_FAIXA )
   @ 06,26 get X_INIC_FAIXA  picture "@E 999,999,999.99"
   @ 08,26 get X_FIM_FAIXA   picture "@E 999,999,999.99"
   @ 10,26 get X_PERCENTUAL  picture "999.99"
   read

   if lastkey()=27
      exit
   end

   X_FAIXA := zerofill( X_FAIXA )

   @ 04,26 say X_FAIXA

   if dbseek(X_FAIXA)
      mensbeep("Faixa ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao do Imposto de Renda (S/N) ?')
      FPG2600->( dbappend() )
      repl FPG2600->FAIXA      with X_FAIXA
      repl FPG2600->INIC_FAIXA with X_INIC_FAIXA
      repl FPG2600->FIM_FAIXA  with X_FIM_FAIXA
      repl FPG2600->PERCENTUAL with X_PERCENTUAL
      scroll(09,27,19,54,1)
      FPG2600->( dbunlock() )
   end

end

************************************
function editae2600()
************************************
setcursor(1)

telae2600()

@ 04,26 say     FPG2600->FAIXA
X_INIC_FAIXA := FPG2600->INIC_FAIXA

@ 06,26 get X_INIC_FAIXA pict "@E 999,999,999.99"
read

if empty(X_INIC_FAIXA) .or. lastkey()=27
   setcursor(0)
   return nil
end

X_FIM_FAIXA := FPG2600->FIM_FAIXA

   @ 08,26 get X_FIM_FAIXA pict "@E 999,999,999.99"
   read


if empty(X_FIM_FAIXA) .or. lastkey()=27

   setcursor(0)
   return nil
end

X_PERCENTUAL := FPG2600->PERCENTUAL
   @ 10,26 get X_PERCENTUAL pict "999.99"
   read


if empty(X_PERCENTUAL) .or. lastkey()=27
   setcursor(0)
   return nil

end

while FPG2600->( ! rlock() ); end
FPG2600->inic_faixa := X_INIC_FAIXA
FPG2600->fim_faixa  := X_FIM_FAIXA
FPG2600->percentual := X_PERCENTUAL
FPG2600->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe2600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite2600()
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
Procedimento .: TELAe2600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae2600()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo da Faixa.....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Inicio - Faixa......:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Fim - Faixa.........:                                                    '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' Percentual..........:                                                    '
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




