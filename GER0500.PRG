/*
   GER   - Sistema Gerencial
   GER0500.PRG - Cadastro de Honorario Contabil
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('GER0500','GER0500')

setcolor(W_COREDIT)

abrir("GER0500")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| GER0500->CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Honorario Contabil "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "ANO"                )
aadd( CAMPO     , "MES"                )
aadd( CAMPO     , "SERVICO"            )
aadd( CAMPO     , "OBSERVACAO"         )
aadd( CAMPO     , "VALOR"              )

aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "9999,999.99"        )

aadd( CABECALHO , "Ano"                )
aadd( CABECALHO , "Mes"                )
aadd( CABECALHO , "Servico"            )
aadd( CABECALHO , "Observacao"         )
aadd( CABECALHO , "Valor"              )

aadd( TAMANHO   , 04                   )
aadd( TAMANHO   , 04                   )
aadd( TAMANHO   , 07                   )
aadd( TAMANHO   , 30                   )
aadd( TAMANHO   , 12                   )

setcolor(W_COREDIT)

ted_ger0500()

select GER0500
GER0500->( dbsetorder(1) )
GER0500->( dbseek(X_CODEMP))

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
          if GER0500->(!eof())
             edi_ger0500()
          end
          select GER0500
          GER0500->( dbsetorder(1) )
          GER0500->( dbseek(X_CODEMP))
          tabela:refreshall()

      case TEC = -2   && inclusao f3
           ins_ger0500()
           select GER0500
           GER0500->( dbsetorder(1) )
           GER0500->( dbseek(X_CODEMP))
           tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if GER0500->(!eof())
             if pergunta("Confirma Exclusao dos Dados (S/N) ?")
                while GER0500->( ! rlock() ); end
                GER0500->( dbdelete() )
                GER0500->( dbunlock() )
                GER0500->(dbskip()    )
             end
           end
           select GER0500
           GER0500->( dbsetorder(1) )
           GER0500->( dbseek(X_CODEMP))
           tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function ins_ger0500()
************************************

private X_ANO,X_MES,X_OBSERVACAO,X_SERVICO,X_VALOR

setcursor(1)

while .t.

   tel_GER0500()

   X_ANO         := space(2)
   X_MES         := space(2)
   X_SERVICO     := space(2)
   X_OBSERVACAO  := space(30)
   X_VALOR       := 0.00

   @ 04,17 get X_ANO     picture "99"       valid ! empty(X_ANO)
   @ 05,17 get X_MES     picture "99"       valid ! empty(X_MES)
   @ 06,17 get X_SERVICO     picture "99"
   @ 07,17 get X_OBSERVACAO  picture "@!"
   @ 08,17 get X_VALOR       picture "@E 9999,999.99"
   read

   if lastkey()=27; exit; end

   GER0500->( dbsetorder(1))
   if GER0500->( dbseek(X_CODEMP+X_ANO+X_MES))
      mensbeep(" Honorario Contabil ja Cadastrado !")
      loop
   end

   if pergunta('Confirma inclusao do (S/N) ?')
      GER0500->( dbappend() )
      repl GER0500->CODEMP     with X_CODEMP
      repl GER0500->ANO        with X_ANO
      repl GER0500->MES        with X_MES
      repl GER0500->SERVICO    with X_SERVICO
      repl GER0500->OBSERVACAO with X_OBSERVACAO
      repl GER0500->VALOR      with X_VALOR
      scroll(09,27,19,54,1)
      GER0500->( dbunlock() )
   end

end

************************************
function edi_ger0500()
************************************
setcursor(1)

tel_ger0500()

@ 04,17 say    GER0500->ANO
@ 05,17 say    GER0500->MES

X_SERVICO     := GER0500->SERVICO
X_VALOR       := GER0500->VALOR
X_OBSERVACAO  := GER0500->OBSERVACAO

@ 06,17 get   X_SERVICO
@ 07,17 get   X_OBSERVACAO
@ 08,17 get   X_VALOR

read

if lastkey()=27
   setcursor(0)
   return nil
end

while GER0500->( ! rlock() ); end
GER0500->SERVICO    := X_SERVICO
GER0500->OBSERVACAO := X_OBSERVACAO
GER0500->VALOR      := X_VALOR
GER0500->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TED_ger0500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure ted_ger0500()

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
Procedimento .: TEL_ger0500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tel_ger0500()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Ano.........:                                                            '
   @ 05,03 say ' Mes.........:                                                            '
   @ 06,03 say ' Servico.....:                                                            '
   @ 07,03 say ' Obervacao...:                                                            '
   @ 08,03 say ' Valor.......:                                                            '
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



