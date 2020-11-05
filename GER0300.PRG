/*
   GER   - Sistema Gerencial
   GER0300.PRG - Cadastro de Codigo de Receita
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('GER0300','GER0300')

setcolor(W_COREDIT)

abrir("FPG0100")
abrir("GER0300")

select GER0300

GER0300->( dbsetorder(1) )
GER0300->( dbseek(X_CODEMP) )

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Codigo de Receita "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODEMP"             )
aadd( CAMPO     , "CODREC"             )
aadd( CAMPO     , "DESCRICAO"          )
aadd( CAMPO     , "PERCENTUAL"         )
aadd( CAMPO     , "VENCIMENTO"         )

aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@!"                 )
aadd( MASCARA   , "@E 999.99"          )
aadd( MASCARA   , "99/99/99"           )

aadd( CABECALHO , "Empresa"            )
aadd( CABECALHO , "Receita"            )
aadd( CABECALHO , "Descricao"          )
aadd( CABECALHO , "Perc(%)"            )
aadd( CABECALHO , "Vencto"             )

aadd( TAMANHO   , 07                   )
aadd( TAMANHO   , 07                   )
aadd( TAMANHO   , 30                   )
aadd( TAMANHO   , 07                   )
aadd( TAMANHO   , 08                   )

setcolor(W_COREDIT)

ted_ger0300()

select GER0300
GER0300->( dbsetorder(1) )
GER0300->( dbseek(X_CODEMP) )

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
          if GER0300->( ! eof() )
             edi_ger0300()
          end
          GER0300->( dbsetorder(1) )
          GER0300->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          ins_ger0300()
          GER0300->( dbsetorder(1) )
          GER0300->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma Exclusao dos Dados (S/N) ?")
                while GER0300->( ! rlock() ); end
                GER0300->( dbdelete() )
                GER0300->( dbunlock() )
                GER0300->( dbskip()   )
             end
           end
           GER0300->( dbsetorder(1) )
           GER0300->( dbseek(X_CODEMP) )
           tabela:refreshall()

      case TEC = K_ESC
           CONTINUA := .F.
   end


enddo

close data

return

************************************
function ins_ger0300()
************************************

private X_CODREC,X_DESCRICAO,X_PERCENTUAL,X_VENCIMENTO,X_LIVRE1,X_LIVRE2

setcursor(1)

while .t.

   tel_GER0300()

   X_CODREC     := space(4)
   X_DESCRICAO  := space(30)
   X_PERCENTUAL := 0
   X_MULTA      := 0
   X_JUROS      := 0
   X_VENCIMENTO := ctod('')
   X_LIVRE1     := space(30)
   X_LIVRE2     := space(30)
   X_LIVRE3     := space(30)

   @ 04,17 get X_CODEMP     picture "999"        valid tes_codemp(4,17,30)
   @ 05,17 get X_CODREC     picture "9999"       valid ! empty(X_CODREC)

   @ 07,25 get X_DESCRICAO  picture "@!"
   @ 08,25 get X_PERCENTUAL picture "@E 999.99"
   @ 09,25 get X_MULTA      picture "@E 999.99"
   @ 10,25 get X_JUROS      picture "@E 999.99"
   @ 11,25 get X_VENCIMENTO
   @ 12,25 get X_LIVRE1     picture "@!"
   @ 13,25 get X_LIVRE2     picture "@!"
   @ 14,25 get X_LIVRE3     picture "@!"
   read

   X_CODREC := zerofill(X_CODREC)
   @ 04,17 say X_CODREC

   if lastkey()=27; exit; end

   if GER0300->( dbseek(X_CODEMP+X_CODREC))
      mensbeep(" Codigo de Receita da Empresa ja cadastrado ")
      loop
   end

   if pergunta('Confirma inclusao do Codigo (S/N) ?')
      GER0300->( dbappend() )
      repl GER0300->CODEMP     with X_CODEMP
      repl GER0300->CODREC     with X_CODREC
      repl GER0300->DESCRICAO  with X_DESCRICAO
      repl GER0300->PERCENTUAL with X_PERCENTUAL
      repl GER0300->MULTA      with X_MULTA
      repl GER0300->JUROS      with X_JUROS
      repl GER0300->VENCIMENTO with X_VENCIMENTO
      repl GER0300->LIVRE1     with X_LIVRE1
      repl GER0300->LIVRE2     with X_LIVRE2
      repl GER0300->LIVRE3     with X_LIVRE3
      scroll(09,27,19,54,1)
      GER0300->( dbunlock() )
   end

end

************************************
procedure edi_ger0300()
************************************
setcursor(1)

tel_ger0300()

@ 04,17 say    GER0300->CODEMP
@ 05,17 say    GER0300->CODREC

X_DESCRICAO  := GER0300->DESCRICAO
X_PERCENTUAL := GER0300->PERCENTUAL
X_MULTA      := GER0300->MULTA
X_JUROS      := GER0300->JUROS
X_VENCIMENTO := GER0300->VENCIMENTO
X_LIVRE1     := GER0300->LIVRE1
X_LIVRE2     := GER0300->LIVRE2
X_LIVRE3     := GER0300->LIVRE3

@ 07,25 get X_DESCRICAO  picture "@!"
@ 08,25 get X_PERCENTUAL picture "@E 999.99"
@ 09,25 get X_MULTA      picture "@E 999.99"
@ 10,25 get X_JUROS      picture "@E 999.99"
@ 11,25 get X_VENCIMENTO
@ 12,25 get X_LIVRE1     picture "@!"
@ 13,25 get X_LIVRE2     picture "@!"
@ 14,25 get X_LIVRE3     picture "@!"
read

if lastkey()<>27

   while GER0300->( ! rlock() ); end

   GER0300->DESCRICAO  := X_DESCRICAO
   GER0300->PERCENTUAL := X_PERCENTUAL
   GER0300->MULTA      := X_MULTA
   GER0300->JUROS      := X_JUROS
   GER0300->VENCIMENTO := X_VENCIMENTO
   GER0300->LIVRE1     := X_LIVRE1
   GER0300->LIVRE2     := X_LIVRE2
   GER0300->LIVRE3     := X_LIVRE3
   GER0300->( dbunlock() )

   setcursor(0)
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: TED_ger0300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure ted_ger0300()

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
Procedimento .: TEL_ger0300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tel_ger0300()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Cod.Empresa.:                                                            '
   @ 05,03 say ' Cod.Receita.:                                                            '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Descricao..........:                                                     '
   @ 08,03 say ' Percentual.........:                                                     '
   @ 09,03 say ' Multa..............:                                                     '
   @ 10,03 say ' Juros..............:                                                     '
   @ 11,03 say ' Data de Vencimento.:                                                     '
   @ 12,03 say ' Campo Livre........:                                                     '
   @ 13,03 say ' Campo Livre........:                                                     '
   @ 14,03 say ' Campo Livre........:                                                     '
   @ 15,03 say '                                                                          '
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '
   @ 22,03 say '                                                                          '
   @ 23,03 say '                                                                          '


/*
------------------------------------------------------------------------------
                      Funcao TES_CODREC
-----------------------------------------------------------------------------
*/
function tes_codrec( P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL, len( FPG0300->DESCRICAO ), P_TAM )

   X_CODREC := zerofill(X_CODREC)

   GER0300->( dbsetorder(1) )
   GER0300->( dbseek( X_CODREC ) )

   if GER0300->( ! found() )
      m_tabelas("X_CODREC")
   end

   @ P_LIN, P_COL say X_CODREC

   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left( GER0300->DESCRICAO, P_TAM )
   end

return WRET

/*
------------------------------------------------------------------------------
                      Funcao TES_PERIODO
-----------------------------------------------------------------------------
*/
function tes_periodo( P_LIN , P_COL )

   local WRET := .T.

   X_PERIODO := zerofill(X_PERIODO)

   GER0200->( dbsetorder(1) )
   GER0200->( dbseek( X_CODEMP+X_PERIODO ) )

   if GER0200->( ! found() )
      m_tabelas("X_PERIODO")
   end

   @ P_LIN, P_COL say X_PERIODO

return WRET


