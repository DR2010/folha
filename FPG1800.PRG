/*

   FPG1800.prg  - Incidencia

*/
#include "inkey.ch"
altd(1)

telanum('SCE1800','FPG1800')

private X_CODBASE   := SPACE(3) ,;
        X_CODEVENTO := SPACE(3) ,;
        X_OPERACAO  := SPACE(1) ,;
        X_DESCEVENT := SPACE(30)
        
abrir("FPG1400")
abrir("FPG1500")
abrir("FPG1600")
abrir("FPG1700")
abrir("FPG1800")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  W_FILE      := {}
private  BESCAPE     := {|| FPG1800->CODEMP = X_CODEMP .AND. FPG1800->CODBASE = X_CODBASE  }
private  COR         := W_COREDIT
private  TITULO      := " Incidencia "
private  LININI      := 06
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1
private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODBASE"   )
aadd( CAMPO     , "OPERACAO"  )
aadd( CAMPO     , "CODEVENTO" )
aadd( CAMPO     , "DESCEVENT" )

aadd( MASCARA   , "999"      )
aadd( MASCARA   , "!"        )
aadd( MASCARA   , "@!"       )
aadd( MASCARA   , "@!"       )

aadd( CABECALHO , "Base"       )
aadd( CABECALHO , "Operacao"   )
aadd( CABECALHO , "Evento"     )
aadd( CABECALHO , "Descricao"  )

aadd( TAMANHO   , 04 )
aadd( TAMANHO   , 8  )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 53 )

aadd( W_FILE   , 'FPG1800' )
aadd( W_FILE   , 'FPG1800' )
aadd( W_FILE   , 'FPG1800' )
aadd( W_FILE   , 'FPG1500' )

setcolor(W_COREDIT)
tela1800()

@ 05,23 get X_CODBASE picture "@!" valid tes_codbase( 05,23 )
read

if lastkey()= K_ESC; return; end


select FPG1800
FPG1800->( dbsetorder(1) )
FPG1800->( dbsetrelation( "FPG1500",{|| FPG1800->CODEMP + FPG1800->CODEVENTO } ))
FPG1800->( dbseek( X_CODEMP+X_CODBASE ))

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
                     COLFIM         , ;
                     W_FILE           ;
                   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui  / <F5> - Exclui')

   do case
      case TEC == 27 ; return 0
      case TEC = -2   && inclusao f3

          insere1800()
          select FPG1800
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5

          if FPG1800->( ! eof() )
             if pergunta("Confirma Exclusao (S/N) ?")
                exclui1800()
                tabela:refreshall()
             end
          end

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select FPG1800

enddo

close data

return

/*
---------------------------------------------------------------------------
                                  EXCLUI1800
---------------------------------------------------------------------------
*/
procedure EXCLUI1800

   while FPG1800->( ! rlock() ); end
   FPG1800->( dbdelete() )

return

/*
---------------------------------------------------------------------------
                                  INSERE1800
---------------------------------------------------------------------------
*/
function insere1800()
local SCR := savescreen(,,,,)
setcursor(1)

while .t.

   tedit1800()

   X_OPERACAO  := space(01)

   @ 11,33 say X_CODBASE

   @ 13,33 get X_CODEVENTO  picture "999" valid tes_codevento(13,33)
   @ 15,33 get X_OPERACAO   picture "!"   valid X_OPERACAO $ "+-"
   read

   if lastkey()=27; exit; end

   X_CODBASE   := zerofill( X_CODBASE )
   X_CODEVENTO := zerofill( X_CODEVENTO )

   FPG1800->( dbsetorder(1) )
   FPG1800->( dbseek( X_CODEMP + X_CODBASE + X_CODEVENTO) )

   if FPG1800->(  found() )
      while FPG1800->( ! rlock() );end
      FPG1800->OPERACAO := X_OPERACAO
      FPG1800->( dbunlock() )
   else
      FPG1800->( dbappend() )
      FPG1800->CODEMP      := X_CODEMP
      FPG1800->CODBASE     := X_CODBASE
      FPG1800->CODEVENTO   := X_CODEVENTO
      FPG1800->OPERACAO    := X_OPERACAO
      FPG1800->( dbunlock() )
   end

end

restscreen(,,,,SCR)

return .T.
/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT1800
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit1800()

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ Codigo Base ...:                          ³'
@ 12,14 say '³                                           ³'
@ 13,14 say '³ Codigo Evento .:                          ³'
@ 14,14 say '³                                           ³'
@ 15,14 say '³ Operacao ......:                          ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
Procedimento .: tela1800
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela1800()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say '                                                                          '
   @ 05,03 say ' Base de Calculo .:                                                       '
   @ 06,03 say '                                                                          '
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

return

