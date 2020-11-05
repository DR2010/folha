/*

   FPG2300.PRG - Cadastro de Tipo de Folha

*/
#include "inkey.ch"
altd(1)

telanum('SCE2300','FPG2300')

abrir("FPG2300")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Tipo de Folha"
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "TPFOLHA"   )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05          )
aadd( TAMANHO   , 70          )

setcolor(W_COREDIT)
tedite2300()

select FPG2300

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
             editae2300()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere2300()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Tipo de Folha (S/N) ?")
                while FPG2300->( ! rlock() ); end
                FPG2300->( dbdelete() )
                FPG2300->( dbunlock() )
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
function insere2300()
************************************

private X_TPFOLHA,X_DESCRICAO

setcursor(1)

while .t.

   telae2300()

   X_TPFOLHA      := space(2)
   X_DESCRICAO    := space(30)

   @ 04,26 get X_TPFOLHA      picture "@!"  valid ! empty( X_TPFOLHA )
   @ 06,26 get X_DESCRICAO    picture "@!"
   read

   if lastkey()=27; exit; end

   if dbseek(X_TPFOLHA)
      mensbeep(" Tipo de Folha ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao da  Unidade Federal  (S/N) ?')
      FPG2300->( dbappend() )
      repl FPG2300->TPFOLHA    with X_TPFOLHA
      repl FPG2300->DESCRICAO  with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG2300->( dbunlock() )
   end

end

************************************
function editae2300()
************************************
setcursor(1)

telae2300()

@ 04,26 say    FPG2300->TPFOLHA
X_DESCRICAO := FPG2300->DESCRICAO

// tes_TPFOLHA (04,26)

@ 06,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG2300->( ! rlock() ); end
FPG2300->descricao := X_DESCRICAO
FPG2300->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe2300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite2300()
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
Procedimento .: TELAe2300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae2300()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Tipo de Folha.......:                                                    '
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




