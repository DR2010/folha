/*

   FPG1200.PRG - Cadastro de Funcao

*/
#include "inkey.ch"
altd(1)

telanum('SCE1200','FPG1200')

abrir("FPG1200")

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| FPG1200->CODEMP = X_CODEMP }
private  COR	     := W_COREDIT
private  TITULO      := " Tabela de Funcao "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "CODFUNCAO  " )
aadd( CAMPO	, "DESCRICAO"   )
aadd( MASCARA	, "99"          )
aadd( MASCARA	, "@!"          )
aadd( CABECALHO , "Cod"         )
aadd( CABECALHO , "Descri‡„o"   )
aadd( TAMANHO	, 05 )
aadd( TAMANHO	, 72 )

setcolor(W_COREDIT)
tedite1200()

select FPG1200
FPG1200->(DBSETORDER(1))
FPG1200->(DBSEEK(X_CODEMP))

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
	  if !eof()
	     editae1200()
	  end
	  keyboard chr(1)
	  tabela:refreshall()

      case TEC = -2   && inclusao f3
	  insere1200()
	  keyboard chr(1)
	  tabela:refreshall()

      case TEC = -4   &&  exclusao f5
	  if !eof()
	     if pergunta("Confirma exclusao da Funcao (S/N) ?")
		while FPG1200->( ! rlock() ); end
		FPG1200->( dbdelete() )
		FPG1200->( dbunlock() )
		dbskip()
	     end
	   end
	  keyboard chr(1)
	  tabela:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.
   end

   select FPG1200
   FPG1200->(DBSETORDER(1))

enddo

close data

return

************************************
function insere1200()
************************************

private X_CODFUNCAO,X_DESCRICAO

setcursor(1)

while .t.

   telae1200()

   X_CODFUNCAO	    := space(2)
   X_DESCRICAO	    := space(30)

   @ 04,26 get X_CODFUNCAO	  picture "999" valid ! empty( X_CODFUNCAO   )
   @ 08,26 get X_DESCRICAO	  picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODFUNCAO	 := zerofill( X_CODFUNCAO   )

   @ 04,26 say X_CODFUNCAO

   if FPG1200->(dbseek(X_CODEMP+X_CODFUNCAO))
      mensbeep("Codigo ja cadastrado")
      loop
   end

   if pergunta('Confirma inclusao do Funcao (S/N) ?')
      FPG1200->( dbappend() )
      repl FPG1200->CODEMP	    with X_CODEMP
      repl FPG1200->CODFUNCAO	    with X_CODFUNCAO
      repl FPG1200->DESCRICAO	    with X_DESCRICAO
      scroll(09,27,19,54,1)
      FPG1200->( dbunlock() )
   end

end

************************************
function editae1200()
************************************
setcursor(1)

telae1200()

@ 04,26 say    FPG1200->CODFUNCAO

read

X_DESCRICAO  := FPG1200->DESCRICAO

@ 08,26 get X_DESCRICAO pict "@!"
read


if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG1200->( ! rlock() ); end
FPG1200->descricao := X_DESCRICAO
FPG1200->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1200()
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
Procedimento .: TELAe1200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae1200()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo da Funcao....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say '                                                                          '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Descricao...........:                                                    '
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



