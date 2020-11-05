/*

   FPG4000.PRG - Cadastro de Atividades

*/
#include "inkey.ch"
altd(1)

telanum('SCE4000','FPG4000')

abrir("FPG4000")

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR	     := W_COREDIT
private  TITULO      := " Tabela de Atividades "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "CODFPAS"          )
aadd( CAMPO	, "DESCRICAO"        )
aadd( CAMPO	, "FPAS"             )
aadd( CAMPO	, "PERC_CONT"        )
aadd( CAMPO	, "PERC_TERC"        )

aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@E 999.99"        )
aadd( MASCARA	, "@E 999.99"        )

aadd( CABECALHO , "Cod"              )
aadd( CABECALHO , "Descri‡„o"        )
aadd( CABECALHO , " FPAS"            )
aadd( CABECALHO , "% Contribuicao"   )
aadd( CABECALHO , "% Terceiros"      )

aadd( TAMANHO	, 03 )
aadd( TAMANHO	, 30 )
aadd( TAMANHO	, 06 )
aadd( TAMANHO	, 16 )
aadd( TAMANHO	, 14 )

setcolor(W_COREDIT)
tedite4000()

select FPG4000

TABELA := tabelanew( CAMPO	    , ;
		     MASCARA	    , ;
		     CABECALHO	    , ;
		     TAMANHO	    , ;
		     BESCAPE	    , ;
		     COR	    , ;
		     TITULO	    , ;
		     LININI	    , ;
		     LINFIM	    , ;
		     COLINI	    , ;
		     BLOCK_DISP     , ;
		     CAB_TITULO     , ;
		     BORDA	    , ;
		     COLFIM	      ;
		   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
	  if FPG4000->( !eof())
	     editae4000()
	  end
	  keyboard chr(1)

      case TEC = -2   && inclusao f3
	  insere4000()
	  keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if FPG4000->(!eof())
	     if pergunta("Confirma exclusao da Atividade (S/N) ?")
		while FPG4000->( ! rlock() ); end
		FPG4000->( dbdelete() )
		FPG4000->( dbunlock() )
		FPG4000->( dbskip()   )
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
function insere4000()
************************************

private X_CODFPAS,X_DESCRICAO,X_FPAS,X_PERC_CONT,X_PERC_TERC

setcursor(1)

while .t.

   telae4000()

   X_CODFPAS	   := space(2)
   X_DESCRICAO	   := space(30)
   X_FPAS	   := 0
   X_PERC_CONT	   := 000.00
   X_PERC_TERC	   := 000.00

   @ 04,27 get X_CODFPAS      picture "99" valid ! empty( X_CODFPAS )
   @ 06,27 get X_DESCRICAO    picture "@!"
   @ 08,27 get X_FPAS	      picture "999"
   @ 10,27 get X_PERC_CONT    picture "@E 999.99"
   @ 12,27 get X_PERC_TERC    picture "@E 999.99"
   read

   if lastkey()=27; exit; end

   X_CODFPAS	:= zerofill( X_CODFPAS )
   @ 04,33 say X_CODFPAS

   FPG4000->( dbsetorder(1))
   if FPG4000->( dbseek(X_CODFPAS))
      mensbeep("Atividade ja cadastrada")
      loop
   end

   if pergunta('Confirma inclusao da Atividade (S/N) ?')
      FPG4000->( dbappend() )
      repl FPG4000->CODFPAS	with X_CODFPAS
      repl FPG4000->DESCRICAO	with X_DESCRICAO
      repl FPG4000->FPAS	with X_FPAS
      repl FPG4000->PERC_CONT	with X_PERC_CONT
      repl FPG4000->PERC_TERC	with X_PERC_TERC
      scroll(09,27,19,54,1)
      FPG4000->( dbunlock() )
   end

end

************************************
function editae4000()
************************************
setcursor(1)

telae4000()

X_DESCRICAO  := FPG4000->DESCRICAO
X_FPAS	     := FPG4000->FPAS
X_PERC_CONT  := FPG4000->PERC_CONT
X_PERC_TERC  := FPG4000->PERC_TERC

@ 04,27 say FPG4000->CODFPAS
@ 06,27 get X_DESCRICAO  pict "@!"
@ 08,27 get X_FPAS	 pict "999"
@ 10,27 get X_PERC_CONT  pict "@E 999.99"
@ 12,27 get X_PERC_TERC  pict "@E 999.99"
read

while FPG4000->( ! rlock() ); end
FPG4000->DESCRICAO := X_DESCRICAO
FPG4000->FPAS	   := X_FPAS
FPG4000->PERC_CONT := X_PERC_CONT
FPG4000->PERC_TERC := X_PERC_TERC
FPG4000->( dbunlock() )

setcursor(0)

return nil

/*
-----------------------------------------------------------------------------
                      Funcao TES_CODFPAS
-----------------------------------------------------------------------------
*/
function tes_CODFPAS( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len( FPG4000->DESCRICAO ), TAM )

   X_CODFPAS := zerofill(X_CODFPAS)

   FPG4000->( dbsetorder(1) )
   FPG4000->( dbseek( X_CODFPAS ) )

   if FPG4000->( ! found() ) .or. X_CODFPAS = "00"
      m_tabelas("X_CODFPAS")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN	, COL	   say	left(FPG4000->DESCRICAO, TAM )
   else
      if LIN # NIL
	 @ LIN	   , COL	 say	    X_CODFPAS
	 @ LIN	   , COL     + 4 say '- ' + left(FPG4000->DESCRICAO, TAM )
      else
	 @ 16,26 say X_CODFPAS
	 @ 16,28 say left(FPG4000->DESCRICAO, TAM )
      end
   end

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe4000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite4000()
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
Procedimento .: TELAe4000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae4000()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo...............:                                                   '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao............:                                                   '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Codigo FPAS..........:                                                   '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' Perc. Contribuinte...:                                                   '
   @ 11,03 say '                                                                          '
   @ 12,03 say ' Perc. Terceiros......:                                                   '
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

