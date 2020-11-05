/*

   FPG1400.PRG - Cadastro de Base de Calculo

*/
#include "inkey.ch"
altd(1)

telanum('SCE1400','FPG1400')

abrir("FPG1400")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Base de Calculo "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODBASE" )
aadd( CAMPO     , "DESCRICAO" )
aadd( CAMPO     , "ESPECIAL" )

aadd( MASCARA   , "999"        )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )

aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( CABECALHO , "Especial" )

aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 32 )
aadd( TAMANHO   , 38 )

setcolor(W_COREDIT)
tedite1400()

select FPG1400
FPG1400->(DBSETORDER(1))
FPG1400->(DBSEEK(X_CODEMP))

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
             editae1400()
          end
          select FPG1400
          FPG1400->( dbsetorder(1) )
          FPG1400->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          insere1400()
          select FPG1400
          FPG1400->( dbsetorder(1) )
          FPG1400->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao da Base de Calculo (S/N) ?")
                while FPG1400->( ! rlock() ); end
                FPG1400->( dbdelete() )
                FPG1400->( dbunlock() )
             end
           end
          select FPG1400
          FPG1400->( dbsetorder(1) )
          FPG1400->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end

enddo

close data

return

************************************
function insere1400()
************************************

private X_CODBASE,X_DESCRICAO,X_ESPECIAL

setcursor(1)

while .t.

   telae1400()

   X_CODBASE   := space(3)
   X_DESCRICAO := space(30)
   X_ESPECIAL  := space(4)

   @ 04,33 get X_CODBASE     picture "999" valid ! empty( X_CODBASE )
   @ 06,33 get X_DESCRICAO   picture "@!"
   @ 08,33 get X_ESPECIAL    picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODBASE := zerofill( X_CODBASE )

   @ 04,33 say X_CODBASE

   if dbseek(X_CODEMP+X_CODBASE)
      mensbeep("Base de calculo ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao da Base de Calculo (S/N) ?')
      FPG1400->( dbappend() )
      repl FPG1400->CODEMP     with X_CODEMP
      repl FPG1400->CODBASE    with X_CODBASE
      repl FPG1400->DESCRICAO  with X_DESCRICAO
      repl FPG1400->ESPECIAL   with X_ESPECIAL
      scroll(09,27,19,54,1)
      FPG1400->( dbunlock() )
   end

end

************************************
function editae1400()
************************************
setcursor(1)

telae1400()

@ 04,33 say    FPG1400->CODBASE
X_DESCRICAO := FPG1400->DESCRICAO
X_ESPECIAL  := FPG1400->ESPECIAL

@ 06,33 get X_DESCRICAO pict "@!"
@ 08,33 get X_ESPECIAL  pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG1400->( ! rlock() ); end
FPG1400->descricao := X_DESCRICAO
FPG1400->ESPECIAL  := X_ESPECIAL
FPG1400->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1400()
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
Procedimento .: TELAe1400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae1400()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo da Base de Calculo..:                                             '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao..................:                                             '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Especial ..................:                                             '
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



