/*

   FPG1700.PRG - Cadastro de Grau de Instrucao

*/
#include "inkey.ch"
altd(1)

telanum('SCE1700','FPG1700')

abrir("FPG1700")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Grau de Instrucao "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODGRAU" )
aadd( CAMPO     , "DESCRICAO" )

aadd( MASCARA   , "99"        )
aadd( MASCARA   , "@!"         )

aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )

aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 70 )

setcolor(W_COREDIT)
tedite1700()

select FPG1700

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
             editae1700()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere1700()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Grau de Instrucao (S/N) ?")
                while FPG1700->( ! rlock() ); end
                FPG1700->( dbdelete() )
                FPG1700->( dbunlock() )
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
function insere1700()
************************************

private X_CODGRAU,X_DESCRICAO

setcursor(1)

while .t.

   telae1700()

   X_CODGRAU    := space(2)
   X_DESCRICAO  := space(28)

   @ 04,33 get X_CODGRAU      picture "99" valid ! empty( X_CODGRAU )
   @ 06,33 get X_DESCRICAO    picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODGRAU := zerofill( X_CODGRAU )
   @ 04,33 say X_CODGRAU

   if dbseek(X_CODGRAU)
      mensbeep("Grau de Instrucao ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao do Grau de Instrucao (S/N) ?')
      FPG1700->( dbappend() )
      repl FPG1700->CODGRAU     with X_CODGRAU
      repl FPG1700->DESCRICAO   with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG1700->( dbunlock() )
   end

end

************************************
function editae1700()
************************************
setcursor(1)

telae1700()

@ 04,33 say    FPG1700->CODGRAU
X_DESCRICAO := FPG1700->DESCRICAO

@ 06,33 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG1700->( ! rlock() ); end
FPG1700->descricao := X_DESCRICAO
FPG1700->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1700
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1700()
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
Procedimento .: TELAe1700
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae1700()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo do Grau de Instrucao:                                            '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao..................:                                             '
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





