/*

   FPG1600.prg  - Variaveis Funcionario

*/
#include "inkey.ch"
altd(1)

telanum('SCE1600','FPG1600')

X_ANO    := '96'
X_MES    := '  '

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG1500")
abrir("FPG1600")
abrir("FPG1700")

empresa_ok()

private X_MATRIC    := SPACE(5),;
        X_CODEVENTO := SPACE(3),;
        X_VALOR     := 0.00

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  W_FILE      := {}
private  BESCAPE     := {|| FPG1600->CODEMP = X_CODEMP .AND. FPG1600->MATRIC = X_MATRIC  }
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

aadd( CAMPO     , "MATRIC"   )
aadd( CAMPO     , "VALOR"  )
aadd( CAMPO     , "CODEVENTO" )
aadd( CAMPO     , "DESCEVENT" )

aadd( MASCARA   , "99999"      )
aadd( MASCARA   , "@E 999,999,999.99" )
aadd( MASCARA   , "@!"       )
aadd( MASCARA   , "@!"       )

aadd( CABECALHO , "Matricula"  )
aadd( CABECALHO , "Valor"   )
aadd( CABECALHO , "Evento"     )
aadd( CABECALHO , "Descricao"  )

aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 45 )

aadd( W_FILE   , 'FPG1600' )
aadd( W_FILE   , 'FPG1600' )
aadd( W_FILE   , 'FPG1600' )
aadd( W_FILE   , 'FPG1500' )

setcolor(W_COREDIT)
tela1600()

WSCR1600 := savescreen(,,,,)
while .t.
   restscreen(,,,,WSCR1600)

   X_MATRIC := SPACE(5)
   @ 05,23 get X_MATRIC picture "@!" valid tes_matric(5,23)
   read

   if lastkey()= K_ESC; exit; end

   X_MATRIC := zerofill( X_MATRIC )
   @ 05,23 say X_MATRIC

   select FPG1600
   FPG1600->( dbsetorder(1) )
   FPG1600->( dbsetrelation( "FPG1500",{|| FPG1600->CODEMP+FPG1600->CODEVENTO } ))
   FPG1600->( dbseek(X_CODEMP+X_MATRIC ))

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

             insere1600()
             select FPG1600
             tabela:refreshall()

         case TEC = -4   &&  exclusao f5

             if FPG1600->( ! eof() )
                if pergunta("Confirma Exclusao (S/N) ?")
                   exclui1600()
                   tabela:refreshall()
                end
             end

         case TEC = K_ESC
            CONTINUA := .F.
      end
      select FPG1600

   enddo

end
close data

return

/*
---------------------------------------------------------------------------
                                  EXCLUI1600
---------------------------------------------------------------------------
*/
procedure EXCLUI1600

   while FPG1600->( ! rlock() ); end
   FPG1600->( dbdelete() )

return

/*
---------------------------------------------------------------------------
                                  INSERE1600
---------------------------------------------------------------------------
*/
function insere1600()
local SCR := savescreen(,,,,)
setcursor(1)

while .t.

   tedit1600()

   X_CODEVENTO := space(3)
   X_VALOR  := 0.00

   @ 11,33 say X_MATRIC
   tes_matric(11,33)

   @ 13,33 get X_CODEVENTO  picture "999" valid tes_codevento (13,33)
   read
   if lastkey()=27; exit; end

   FPG1500->( dbsetorder(1) )
   FPG1500->( dbseek(X_CODEMP+X_CODEVENTO) )

   WSHOW := ''
   do case
      case FPG1500->CLASSE = 'D'
         WSHOW := ' Dias .........: '
      case FPG1500->CLASSE = 'H'
         WSHOW := ' Horas.........: '
      case FPG1500->CLASSE = 'P'
         WSHOW := ' Percentual....: '
      case FPG1500->CLASSE = 'V'
         WSHOW := ' Valor.........: '
    end

   @ 15,15 say WSHOW
   @ 15,33 get X_VALOR      picture "999,999,999.99"
   read

   if lastkey()=27; exit; end

   X_CODEVENTO := zerofill( X_CODEVENTO )
   @ 13,33 say X_CODEVENTO

   FPG1600->( dbsetorder(1) )
   FPG1600->( dbseek( X_CODEMP+X_MATRIC+X_CODEVENTO ))

   if FPG1600->(  found() )
      while FPG1600->( ! rlock() );end
      FPG1600->VALOR := X_VALOR
      FPG1600->( dbunlock() )
   else
      FPG1600->( dbappend() )
      FPG1600->CODEMP     := X_CODEMP
      FPG1600->MATRIC     := X_MATRIC
      FPG1600->CODEVENTO  := X_CODEVENTO
      FPG1600->VALOR      := X_VALOR
      FPG1600->( dbunlock() )
   end

end

restscreen(,,,,SCR)

return .T.
/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT1600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit1600()

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ Matricula .....:                                                ³'
@ 12,14 say '³                                                                 ³'
@ 13,14 say '³ Codigo Evento .:                                                ³'
@ 14,14 say '³                                                                 ³'
@ 15,14 say '³ Qtde/Valor ....:                                                ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
Procedimento .: tela1600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela1600()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say '                                                                          '
   @ 05,03 say ' Matricula .......:                                                       '
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

