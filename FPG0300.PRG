/*

   FPG0300.PRG - Cadastro de Cargo

*/
#include "inkey.ch"
altd(1)

telanum('SCE0300','FPG0300')

abrir("FPG0300")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Cargos "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODCARGO" )
aadd( CAMPO     , "DESCRICAO" )
aadd( CAMPO     , "CBO" )
aadd( MASCARA   , "99"        )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( CABECALHO , "CBO" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 62 )
aadd( TAMANHO   , 05 )

setcolor(W_COREDIT)
tedite300()

select FPG0300

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
             editae300()
          end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          insere300()
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Cargo (S/N) ?")
                while FPG0300->( ! rlock() ); end
                FPG0300->( dbdelete() )
                FPG0300->( dbunlock() )
                FPG0300->( dbskip()   )
             end
           end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function insere300()
************************************

private X_CODCARGO,X_DESCRICAO,X_CBO

setcursor(1)

while .t.

   telae300()

   X_CODCARGO    := space(2)
   X_DESCRICAO   := space(30)
   X_CBO         := space(05)

   @ 04,26 get X_CODCARGO      picture "99"
   @ 06,26 get X_DESCRICAO     picture "@!"
   @ 07,26 get X_CBO           picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODCARGO := zerofill( X_CODCARGO )

   @ 04,26 say X_CODCARGO

   if dbseek(X_CODCARGO)
      mensbeep("Cargo ja cadastrado")
      loop
   end

   if pergunta('Confirma inclusao do Cargo (S/N) ?')
      FPG0300->( dbappend() )
      repl FPG0300->CODCARGO     with X_CODCARGO
      repl FPG0300->DESCRICAO    with X_DESCRICAO
      repl FPG0300->CBO          with X_CBO
      scroll(09,27,19,54,1)
      FPG0300->( dbunlock() )
   end

end

************************************
function editae300()
************************************
setcursor(1)

telae300()

@ 04,26 say    FPG0300->CODCARGO
X_DESCRICAO := FPG0300->DESCRICAO
X_CBO       := FPG0300->CBO


@ 06,26 get X_DESCRICAO pict "@!"
@ 07,26 get X_CBO       pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG0300->( ! rlock() ); end
FPG0300->descricao := X_DESCRICAO
FPG0300->CBO       := X_CBO
FPG0300->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite300()
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
Procedimento .: TELAe300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae300()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo do Cargo.....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao ..........:                                                    '
   @ 07,03 say ' CBO.................:                                                    '
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

