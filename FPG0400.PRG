/*

   FPG0400.PRG - Cadastro de Unidade Federal

*/
#include "inkey.ch"
altd(1)

telanum('SCE0400','FPG0400')

abrir("FPG0400")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Unidade Federal"
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODUF" )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "99"        )
aadd( MASCARA   , "@!"         )
aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 70 )

setcolor(W_COREDIT)
tedite400()

select FPG0400

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
             editae400()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere400()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao da  Unidade Federal (S/N) ?")
                while FPG0400->( ! rlock() ); end
                FPG0400->( dbdelete() )
                FPG0400->( dbunlock() )
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
function insere400()
************************************

private X_CODUF,X_DESCRICAO

setcursor(1)

while .t.

   telae400()

   X_CODUF        := space(2)
   X_DESCRICAO    := space(02)

   @ 04,26 get X_CODUF        picture "99"  valid ! empty( X_CODUF )
   @ 06,26 get X_DESCRICAO    picture "@!"
   read

   if lastkey()=27; exit; end

   if dbseek(X_CODUF)
      mensbeep(" Unidade Federal ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao da  Unidade Federal  (S/N) ?')
      FPG0400->( dbappend() )
      repl FPG0400->CODUF      with X_CODUF
      repl FPG0400->DESCRICAO  with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG0400->( dbunlock() )
   end

end

************************************
function editae400()
************************************
setcursor(1)

telae400()

@ 04,26 say    FPG0400->CODUF
X_DESCRICAO := FPG0400->DESCRICAO

// tes_coduf (04,26)

@ 06,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG0400->( ! rlock() ); end
FPG0400->descricao := X_DESCRICAO
FPG0400->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite400()
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
Procedimento .: TELAe400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae400()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Unidade Federal ....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao ..........:                                                    '
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


