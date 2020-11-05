/*

   FPG1100.PRG - Cadastro de Nacionalidade

*/
#include "inkey.ch"
altd(1)

telanum('SCE1100','FPG1100')

abrir("FPG1100")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Nacionalidade "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODNACIONA" )
aadd( CAMPO     , "DESCRICAO"  )
aadd( MASCARA   , "99"         )
aadd( MASCARA   , "@!"         )
aadd( CABECALHO , "Cod"        )
aadd( CABECALHO , "Descri‡„o"  )
aadd( TAMANHO   , 05           )
aadd( TAMANHO   , 70           )

setcolor(W_COREDIT)
tedite1100()

select FPG1100

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
             editae1100()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere1100()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao da Nacionalidade (S/N) ?")
                while FPG1100->( ! rlock() ); end
                FPG1100->( dbdelete() )
                FPG1100->( dbunlock() )
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
function insere1100()
************************************

private X_CODNACIONA,X_DESCRICAO

setcursor(1)

while .t.

   telae1100()

   X_CODNACIONA    := space(2)
   X_DESCRICAO := space(17)

   @ 04,32 get X_CODNACIONA      picture "99" valid ! empty( X_CODNACIONA )
   @ 06,32 get X_DESCRICAO  picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODNACIONA := zerofill( X_CODNACIONA )

   @ 04,32 say X_CODNACIONA

   if dbseek(X_CODNACIONA)
      mensbeep("Nacionalidade ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao da Nacionalidade (S/N) ?')
      FPG1100->( dbappend() )
      repl FPG1100->CODNACIONA     with X_CODNACIONA
      repl FPG1100->DESCRICAO with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG1100->( dbunlock() )
   end

end

************************************
function editae1100()
************************************
setcursor(1)

telae1100()

@ 04,32 say    FPG1100->CODNACIONA
X_DESCRICAO := FPG1100->DESCRICAO

@ 06,32 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG1100->( ! rlock() ); end
FPG1100->descricao := X_DESCRICAO
FPG1100->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1100()
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
Procedimento .: TELAe1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae1100()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo da Nacionalidade..:                                               '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao ...............:                                                '
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


