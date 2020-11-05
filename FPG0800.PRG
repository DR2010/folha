/*

   FPG0800.PRG - Cadastro de Agencias

*/
#include "inkey.ch"
altd(1)

telanum('SCE0800','FPG0800')

abrir("FPG0700")
abrir("FPG0800")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Agencias "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODBANCO"    )
aadd( CAMPO     , "CODAGENCIA"    )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "999"       )
aadd( MASCARA   , "9999"      )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Banco"     )
aadd( CABECALHO , "Agencia"   )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 07 )
aadd( TAMANHO   , 63 )

setcolor(W_COREDIT)
tedite800()

select FPG0800

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
             editae800()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere800()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do Banco (S/N) ?")
                while FPG0800->( ! rlock() ); end
                FPG0800->( dbdelete() )
                FPG0800->( dbunlock() )
                dbskip()
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
enddo

close data

return

************************************
function insere800()
************************************

private X_CODBANCO,X_CODAGENCIA,X_DESCRICAO

setcursor(1)

while .t.

   telae800()

   X_CODBANCO      := space(3)
   X_CODAGENCIA    := space(4)
   X_DESCRICAO     := space(30)

   @ 04,26 get X_CODBANCO      picture "999"  valid tes_codbanco (04,26) .and. ! empty( X_CODBANCO )
   @ 05,26 get X_CODAGENCIA    picture "9999" valid ! empty( X_CODAGENCIA )
   @ 07,26 get X_DESCRICAO     picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODAGENCIA := zerofill( X_CODAGENCIA )

   @ 04,26 say X_CODAGENCIA

   FPG0800->(dbsetorder(1))

   if FPG0800->(dbseek(X_CODBANCO+X_CODAGENCIA) )
      mensbeep(" Banco/Agencia ja cadastrado ")
      loop
   end

   if pergunta('Confirma inclusao da Agencia (S/N) ?')
      FPG0800->( dbappend() )
      repl FPG0800->CODBANCO      with X_CODBANCO
      repl FPG0800->CODAGENCIA    with X_CODAGENCIA
      repl FPG0800->DESCRICAO     with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG0800->( dbunlock() )
   end

end

************************************
function editae800()
************************************
setcursor(1)

telae800()

@ 04,26 say    FPG0800->CODBANCO
@ 05,26 say    FPG0800->CODAGENCIA
X_DESCRICAO := FPG0800->DESCRICAO

// tes_codbanco (04,26)
                   
@ 07,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG0800->( ! rlock() ); end
FPG0800->descricao := X_DESCRICAO
FPG0800->( dbunlock() )

setcursor(0)

return nil

/*
-----------------------------------------------------------------------------
                      Funcao TES_CODBANCO
-----------------------------------------------------------------------------
*/
function tes_CODBANCO( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG0700->DESCRICAO), TAM )

   X_CODBANCO      := zerofill(X_CODBANCO)

   FPG0700->( dbsetorder(1) )
   FPG0700->( dbseek( X_CODBANCO ) )

   if FPG0700->( ! found() ) .or. X_CODBANCO = "000"
      m_tabelas("X_CODBANCO")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if LIN # NIL
      @ LIN     , COL         say        X_CODBANCO
      @ LIN     , COL     + 4 say '- ' + left(FPG0700->DESCRICAO,TAM)
   else
      @ 04,26 say X_CODBANCO
      @ 04,28 say left(FPG0700->DESCRICAO,TAM)
  end

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe800
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite800()
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
Procedimento .: TELAe800
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae800()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Banco...............:                                                    '
   @ 05,03 say ' Agencia.............:                                                    '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Descricao ..........:                                                    '
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



