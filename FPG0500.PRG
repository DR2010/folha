/*

   FPG0500.PRG - Cadastro de Setor
*/
#include "inkey.ch"
altd(1)

telanum('SCE0500','FPG0500')

abrir("FPG0100")
abrir("FPG0500")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| FPG0500->CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Setor "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODSETOR" )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "99"        )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 70 )

setcolor(W_COREDIT)
tedite500()

select FPG0500
FPG0500->( dbsetorder(1) )
FPG0500->( dbseek(X_CODEMP) )

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
             editae500()
          end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          insere500()
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Setor (S/N) ?")
                while FPG0500->( ! rlock() ); end
                FPG0500->( dbdelete() )
                FPG0500->( dbunlock() )
                dbskip()
             end
           end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end

   select FPG0500
   FPG0500->( dbsetorder(1) )


enddo

close data

return

************************************
function insere500()
************************************

private X_CODSETOR,X_DESCRICAO

setcursor(1)

while .t.

   telae500()

   X_CODSETOR    := space(2)
   X_DESCRICAO   := space(30)

   @ 04,26 get X_CODSETOR    picture "99" valid ! empty( X_CODSETOR )
   @ 06,26 get X_DESCRICAO   picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODSETOR := zerofill( X_CODSETOR )

   @ 04,26 say X_CODSETOR

   if dbseek(X_CODEMP+X_CODSETOR)
      mensbeep(" Setor ja cadastrado")
      loop
   end

   if pergunta('Confirma inclusao do Setor  (S/N) ?')
      FPG0500->( dbappend() )
      repl FPG0500->CODEMP      with X_CODEMP
      repl FPG0500->CODSETOR    with X_CODSETOR
      repl FPG0500->DESCRICAO   with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG0500->( dbunlock() )
   end

end

************************************
function editae500()
************************************
setcursor(1)

telae500()

@ 04,26 say    FPG0500->CODSETOR
X_DESCRICAO := FPG0500->DESCRICAO

@ 06,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG0500->( ! rlock() ); end
FPG0500->descricao := X_DESCRICAO
FPG0500->( dbunlock() )

setcursor(0)

return nil



/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite500()
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
Procedimento .: TELAe500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae500()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo do Setor.....:                                                    '
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


