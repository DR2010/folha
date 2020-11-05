/*
   GER   - Sistema Gerencial
   GERB002.PRG - Empresa & Receitas
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('GER0200','GER0200')

setcolor(W_COREDIT)

abrir("FPG0100")
abrir("GER0200")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Empresa & Receitas "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODEMP"             )
aadd( CAMPO     , "PERIODO"            )
aadd( CAMPO     , "VALOR"              )
aadd( CAMPO     , "OBS"                )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@E 999,999,999.99"  )
aadd( MASCARA   , "@!"                 )
aadd( CABECALHO , "Empresa"            )
aadd( CABECALHO , "Periodo"            )
aadd( CABECALHO , "Receita"            )
aadd( CABECALHO , "Observacao"         )
aadd( TAMANHO   , 07                   )
aadd( TAMANHO   , 07                   )
aadd( TAMANHO   , 14                   )
aadd( TAMANHO   , 43                   )

setcolor(W_COREDIT)

ted_ger0200()

select GER0200

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
             wscr := savescreen(,,,,)
             edi_ger0200()
             TABELA:refreshall()
             select GER0200
             restscreen(,,,,wscr)
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
           wscr := savescreen(,,,,)
           ins_ger0200()
           TABELA:refreshall()
           select GER0200
           restscreen(,,,,wscr)
           keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao da Receita (S/N) ?")
                while GER0200->( ! rlock() ); end
                GER0200->( dbdelete() )
                GER0200->( dbunlock() )
                dbskip()
             end
           end
           TABELA:refreshall()
           keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function ins_ger0200()
************************************

private X_PERIODO,X_VALOR,X_OBS

setcursor(1)

while .t.

   tel_GER0200()

   X_CODEMP  := space(3)
   X_PERIODO := space(4)
   X_OBS     := space(30)
   X_VALOR   := 0.00


   @ 04,17 get X_CODEMP     picture "999"  valid tes_codemp(04,17,20)
   @ 05,17 get X_PERIODO    picture "9999" valid ! empty( X_PERIODO )
   @ 07,25 get X_VALOR      picture "@E 999,999,999.99" valid X_VALOR > 0
   @ 09,25 get X_OBS        picture "@!"
   read

   X_PERIODO := zerofill(X_PERIODO)

   if lastkey()=27; exit; end

   if GER0200->( dbseek(X_CODEMP+X_PERIODO))
      mensbeep(" Receita ja cadastrada para o Periodo")
      loop
   end

   if pergunta('Confirma inclusao da Receita (S/N) ?')
      GER0200->( dbappend() )
      repl GER0200->CODEMP     with X_CODEMP
      repl GER0200->PERIODO    with X_PERIODO
      repl GER0200->VALOR      with X_VALOR
      repl GER0200->OBS        with X_OBS
      scroll(09,27,19,54,1)
      GER0200->( dbunlock() )
   end

end

************************************
function edi_ger0200()
************************************
setcursor(1)

tel_ger0200()

@ 04,17 say    GER0200->CODEMP
@ 05,17 say    GER0200->PERIODO

X_CODEMP := GER0200->CODEMP
X_VALOR  := GER0200->VALOR
X_OBS    := GER0200->OBS

tes_codemp(04,17,20)

@ 07,25 get X_VALOR pict "@E 999,999,999.99" valid X_VALOR > 0
@ 09,25 get X_OBS   pict "@!"
read

if X_VALOR = 0 .or. lastkey()=27
   setcursor(0)
   return nil
end

while GER0200->( ! rlock() ); end
GER0200->VALOR := X_VALOR
GER0200->OBS   := X_OBS
GER0200->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TED_ger0200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure ted_ger0200()

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
Procedimento .: TEL_ger0200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tel_ger0200()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Empresa...:                                                              '
   @ 05,03 say ' Periodo...:                                                              '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Valor da receita..:                                                      '
   @ 08,03 say '                                                                          '
   @ 09,03 say ' Observacao........:                                                      '
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









