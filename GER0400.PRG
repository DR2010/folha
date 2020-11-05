/*
   GER   - Sistema Gerencial
   GER0400.PRG - Cadastro de Valor de Mensalidade
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('GER0400','GER0400')

setcolor(W_COREDIT)

abrir("GER0400")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| GER0400->CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Retirada Pro-Labore "
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
aadd( CAMPO     , "OBSERVACAO"         )
aadd( CAMPO     , "VALOR"              )

aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "9999,999.99"        )

aadd( CABECALHO , "Ano"                )
aadd( CABECALHO , "Mes"                )
aadd( CABECALHO , "Observacao"         )
aadd( CABECALHO , "Valor"              )

aadd( TAMANHO   , 04                   )
aadd( TAMANHO   , 04                   )
aadd( TAMANHO   , 39                   )
aadd( TAMANHO   , 12                   )

setcolor(W_COREDIT)

ted_ger0400()

select GER0400
GER0400->( dbsetorder(1) )
GER0400->( dbseek(X_CODEMP))

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
           if GER0400->(!eof())
              edi_ger0400()
           end
           select GER0400
           GER0400->( dbsetorder(1) )
           GER0400->( dbseek(X_CODEMP))
           tabela:refreshall()

      case TEC = -2   && inclusao f3
           ins_ger0400()
           select GER0400
           GER0400->( dbsetorder(1) )
           GER0400->( dbseek(X_CODEMP))
           tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if GER0400->(!eof())
             if pergunta("Confirma Exclusao dos Dados (S/N) ?")
                while GER0400->( ! rlock() ); end
                GER0400->( dbdelete() )
                GER0400->( dbunlock() )
                GER0400->(dbskip()    )
             end
           end
           select GER0400
           GER0400->( dbsetorder(1) )
           GER0400->( dbseek(X_CODEMP))
           tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function ins_ger0400()
************************************

private X_ANO,X_MES,X_OBSERVACAO,X_VALOR

setcursor(1)

while .T.

   tel_GER0400()

   X_ANO         := space(2)
   X_MES         := space(2)
   X_OBSERVACAO  := space(30)
   X_VALOR       := 0.00

   @ 04,17 get X_ANO         picture "99"       valid ! empty(X_ANO)
   @ 05,17 get X_MES         picture "99"       valid ! empty(X_MES)
   @ 06,17 get X_OBSERVACAO  picture "@!"
   @ 07,17 get X_VALOR       picture "@E 9999,999.99"
   read

   if lastkey()=27; exit; end

   GER0400->( dbsetorder(1))
   if GER0400->( dbseek(X_CODEMP+X_ANO+X_MES))
      mensbeep(" Retirada Ja Cadastrada !")
      loop
   end

   if pergunta('Confirma inclusao da Retirada (S/N) ?')
      GER0400->( dbappend() )
      repl GER0400->CODEMP     with X_CODEMP
      repl GER0400->ANO        with X_ANO
      repl GER0400->MES        with X_MES
      repl GER0400->OBSERVACAO with X_OBSERVACAO
      repl GER0400->VALOR      with X_VALOR
      scroll(09,27,19,54,1)
      GER0400->( dbunlock() )
   end

end

************************************
function edi_ger0400()
************************************
setcursor(1)

tel_ger0400()

@ 04,17 say    GER0400->ANO
@ 05,17 say    GER0400->MES

X_VALOR       := GER0400->VALOR
X_OBSERVACAO  := GER0400->OBSERVACAO

@ 06,17 get   X_OBSERVACAO
@ 07,17 get   X_VALOR

read

if lastkey()=27
   setcursor(0)
   return nil
end

while GER0400->( ! rlock() ); end
GER0400->OBSERVACAO := X_OBSERVACAO
GER0400->VALOR      := X_VALOR
GER0400->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TED_ger0400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure ted_ger0400()

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
Procedimento .: TEL_ger0400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tel_ger0400()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Ano.........:                                                            '
   @ 05,03 say ' Mes.........:                                                            '
   @ 06,03 say ' Observacao..:                                                            '
   @ 07,03 say ' Valor.......:                                                            '
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




