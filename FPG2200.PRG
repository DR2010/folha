/*

   FPG2200.prg  - Variaveis Empresa

*/
#include "inkey.ch"
altd(1)

telanum('SCE2200','FPG2200')

X_ANO    := '96'
X_MES    := '  '

abrir("FPG0100")
abrir("FPG1500")
abrir("FPG2200")

private X_CODEVENTO := SPACE(3)
private X_VALOR := 0.00

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  W_FILE      := {}
private  BESCAPE     := {|| FPG2200->CODEMP = X_CODEMP  }
private  COR         := W_COREDIT
private  TITULO      := " Incidencia "
private  LININI      := 05
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1
private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODEMP"   )
aadd( CAMPO     , "CODEVENTO" )
aadd( CAMPO     , "DESCEVENT" )
aadd( CAMPO     , "VALOR" )

aadd( MASCARA   , "999"        )
aadd( MASCARA   , "999"        )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "999,999.99" )

aadd( CABECALHO , "Empresa"    )
aadd( CABECALHO , "Evento"     )
aadd( CABECALHO , "Descricao"  )
aadd( CABECALHO , "Valor"      )

aadd( TAMANHO   , 07 )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 40 )
aadd( TAMANHO   , 13 )

aadd( W_FILE   , 'FPG2200' )
aadd( W_FILE   , 'FPG2200' )
aadd( W_FILE   , 'FPG1500' )
aadd( W_FILE   , 'FPG2200' )

setcolor(W_COREDIT)

select FPG2200
FPG2200->( dbsetorder(1) )
FPG2200->( dbsetrelation( "FPG1500",{|| FPG2200->CODEMP + FPG2200->CODEVENTO } ))
FPG2200->( dbseek( X_CODEMP ))

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

  mensagem('<F3> - Inclui / <F5> - Exclui')

   do case
      case TEC == 27 ; return 0
      case TEC = -2   && inclusao f3

          insere2200()
          select FPG2200
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5

          if FPG2200->( ! eof() )
             if pergunta("Confirma Exclusao (S/N) ?")
                exclui2200()
                tabela:refreshall()
             end
          end

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select FPG2200

enddo

close data

return

/*
---------------------------------------------------------------------------
                                  EXCLUI2200
---------------------------------------------------------------------------
*/
procedure EXCLUI2200

   while FPG2200->( ! rlock() ); end
   FPG2200->( dbdelete() )

return

/*
---------------------------------------------------------------------------
                                  INSERE2200
---------------------------------------------------------------------------
*/
function insere2200()
local SCR := savescreen(,,,,)
setcursor(1)

while .t.

   tedit2200()

   X_CODEVENTO := space(3)
   X_VALOR     := 0.00

   @ 11,33 say X_CODEMP
   @ 13,33 get X_CODEVENTO  picture "999" valid tes_codevento (13,33)
   @ 15,33 get X_VALOR      picture "@E 999,999.99"
   read
   if lastkey()=K_ESC; exit; end

   X_CODEVENTO := zerofill( X_CODEVENTO )
   @ 13,33 say X_CODEVENTO

   FPG2200->( dbsetorder(1) )
   FPG2200->( dbseek( X_CODEMP+X_CODEVENTO ))

   if FPG2200->( ! found() )
      FPG2200->( dbappend() )
      FPG2200->CODEMP     := X_CODEMP
      FPG2200->CODEVENTO  := X_CODEVENTO
      FPG2200->VALOR      := X_VALOR
      FPG2200->( dbunlock() )
   end

end

restscreen(,,,,SCR)

return .T.
/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT2200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit2200()

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ Empresa ...,...:                          ³'
@ 12,14 say '³                                           ³'
@ 13,14 say '³ Codigo Evento .:                          ³'
@ 14,14 say '³                                           ³'
@ 15,14 say '³ Valor/Qtde ....:                          ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

