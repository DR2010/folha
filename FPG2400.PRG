/*

   FPG2400.PRG - Cadastro de Competencia de Folha

*/
#include "inkey.ch"
altd(1)

telanum('SCE2400','FPG2400')

abrir("FPG2400")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| FPG2400->CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Competencia de Folha "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "ANO" )
aadd( CAMPO     , "MES" )
aadd( CAMPO     , "NUMFOLHA" )
aadd( CAMPO     , "FLAG_USO" )

aadd( MASCARA   , "99"        )
aadd( MASCARA   , "99"         )
aadd( MASCARA   , "99"         )
aadd( MASCARA   , "@!"         )

aadd( CABECALHO , "Ano"       )
aadd( CABECALHO , "Mes" )
aadd( CABECALHO , "Num.Folha" )
aadd( CABECALHO , "Uso (Aberto/Fechado)" )

aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 09 )
aadd( TAMANHO   , 60 )

setcolor(W_COREDIT)
tedite2400()

select FPG2400
FPG2400->( dbsetorder(1) )
FPG2400->( dbseek( X_CODEMP ))

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
          if FPG2400->( ! eof() )
             editae2400()

             select FPG2400
             FPG2400->( dbsetorder(1) )
             tabela:refreshall()
          end

      case TEC = -2   && inclusao f3
          insere2400()

          select FPG2400
          FPG2400->( dbsetorder(1) )
          FPG2400->( dbseek( X_CODEMP ))
             tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if FPG2400->( ! eof() )
             if pergunta("Confirma exclusao da Competencia (S/N) ?")
                while FPG2400->( ! rlock() ); end
                FPG2400->( dbdelete() )
                FPG2400->( dbunlock() )
                dbskip()

                select FPG2400
                FPG2400->( dbsetorder(1) )
                FPG2400->( dbseek( X_CODEMP ))
                tabela:refreshall()
             end
           end

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function insere2400()
************************************

private X_ANO,X_MES,X_NUMFOLHA,X_FLAG_USO

setcursor(1)

while .t.

   telae2400()

   X_ANO          := space(02)
   X_MES          := space(02)
   X_NUMFOLHA     := space(02)
   X_FLAG_USO     := space(01)

   @ 04,26 get X_ANO          picture "99" valid ! empty( X_ANO )
   @ 06,26 get X_MES          picture "99" valid ! empty( X_MES )
   @ 08,26 get X_NUMFOLHA     picture "99" valid ! empty( X_NUMFOLHA )
   @ 10,34 get X_FLAG_USO     picture "@!" valid ( X_FLAG_USO $ "A,F" )
   read

   if lastkey()=27; exit; end

   if dbseek(X_CODEMP+X_ANO+X_MES+X_NUMFOLHA)
      mensbeep(" Competencia ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao da  Competencia (S/N) ?')
      FPG2400->( dbappend() )
      REPL FPG2400->CODEMP     with X_CODEMP
      REPL FPG2400->ANO        with X_ANO
      REPL FPG2400->MES        with X_MES
      REPL FPG2400->NUMFOLHA   with X_NUMFOLHA
      REPL FPG2400->FLAG_USO   with X_FLAG_USO
      scroll(09,27,19,54,1)
      FPG2400->( dbunlock() )
   end

end

************************************
function editae2400()
************************************
setcursor(1)

telae2400()

X_FLAG_USO := 'A'
if FPG2400->FLAG_USO = 'A'
   X_FLAG_USO := 'F'
end
while FPG2400->( ! rlock() ); end
FPG2400->FLAG_USO  := X_FLAG_USO
FPG2400->( dbunlock() )
return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe2400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite2400()
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
Procedimento .: TELAe2400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae2400()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Ano.................:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Mes.................:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Numero da Folha.....:                                                    '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' Tipo de Uso(Aberto/Fechado).:        (A,F)                     '
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



