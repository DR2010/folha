/*

   FPG1500.PRG - Cadastro de Eventos

*/
#include "inkey.ch"
altd(1)

telanum('SCE1500','FPG1500')

abrir("FPG1100")
abrir("FPG1400")
abrir("FPG1500")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| FPG1500->CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Eventos "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

private   X_CODEVENTO       := space(3)
private   X_DESCEVENT       := space(30)
private   X_MODO_CALC       := space(3)
private   X_TIPO_EVENT      := space(1)
private   X_CLASSE          := space(1)
private   X_FATOR           := 0.00
private   X_CODBASE         := space(3)
private   X_INTERNO         := space(1)
private   X_TPFOLHA         := space(2)
private   X_TPFOLHA2        := space(2)
private   X_TPFOLHA3        := space(2)
private   X_TPFOLHA4        := space(2)
private   X_TPFOLHA5        := space(2)
private   X_TPFOLHA6        := space(2)
private   X_SEQUENC         := 0.00

aadd( CAMPO     , "CODEVENTO" )
aadd( CAMPO     , "DESCEVENT" )
aadd( CAMPO     , "MODO_CALC" )
aadd( CAMPO     , "TIPO_EVENT" )
aadd( CAMPO     , "CLASSE" )
aadd( CAMPO     , "FATOR" )
aadd( CAMPO     , "CODBASE" )
aadd( CAMPO     , "INTERNO" )
aadd( CAMPO     , "TPFOLHA" )
aadd( CAMPO     , "TPFOLHA2" )
aadd( CAMPO     , "TPFOLHA3" )
aadd( CAMPO     , "TPFOLHA4" )
aadd( CAMPO     , "SEQUENC" )

aadd( MASCARA   , "999"       )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "999"       )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "999.99"    )
aadd( MASCARA   , "999"       )
aadd( MASCARA   , "!"         )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "999"       )

aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( CABECALHO , "Mod.Calc." )
aadd( CABECALHO , "Tp.Ev."    )
aadd( CABECALHO , "Classe"    )
aadd( CABECALHO , "Fator"     )
aadd( CABECALHO , "B.Calc"    )
aadd( CABECALHO , "I"         )
aadd( CABECALHO , "TpF"       )
aadd( CABECALHO , "Tp1"       )
aadd( CABECALHO , "Tp2"       )
aadd( CABECALHO , "Tp3"       )
aadd( CABECALHO , "Seq"       )

aadd( TAMANHO   , 3  )
aadd( TAMANHO   , 16 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 03 )

setcolor(W_COREDIT)
tedite1500()

select FPG1500
FPG1500->(DBSETORDER(1))
FPG1500->(DBSEEK(X_CODEMP))
                         
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
          if FPG1500->(! eof())
             editae1500()
          end
          select FPG1500
          FPG1500->( dbsetorder(1) )
          FPG1500->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          insere1500()
          select FPG1500
          FPG1500->( dbsetorder(1) )
          FPG1500->( dbseek(X_CODEMP) )
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if FPG1500->(!eof())
             if pergunta("Confirma exclusao do Evento (S/N) ?")
                while FPG1500->( ! rlock() ); end
                FPG1500->( dbdelete() )
                FPG1500->( dbunlock() )
             end
           end
          select FPG1500
          FPG1500->(DBSETORDER(1))
          FPG1500->(DBSEEK(X_CODEMP))
          tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end

enddo

close data

return

************************************
function insere1500()
************************************
setcursor(1)

while .t.

   telae1500()

   X_CODEVENTO       := space(3)
   X_DESCEVENT       := space(30)
   X_MODO_CALC       := space(3)
   X_TIPO_EVENT      := space(1)
   X_CLASSE          := space(1)
   X_FATOR           := 0.00
   X_CODBASE         := space(3)
   X_INTERNO         := space(1)
   X_TPFOLHA         := space(2)
   X_TPFOLHA2        := space(2)
   X_TPFOLHA3        := space(2)
   X_TPFOLHA4        := space(2)
   X_TPFOLHA5        := space(2)
   X_TPFOLHA6        := space(2)
   X_SEQUENC         := 0.00

   @ 04,26 get X_CODEVENTO     picture "999"  valid ! empty( X_CODEVENTO )
   read
   if lastkey()=27; exit; end

   X_CODEVENTO := zerofill( X_CODEVENTO )

   @ 04,26 say X_CODEVENTO

   f1500get()

   if lastkey()=27; exit; end

   FPG1500->(dbsetorder(1))

   if FPG1500->(dbseek(X_CODEMP+X_CODEVENTO) )
      mensbeep("Evento ja cadastrado")
      loop
   end

   if pergunta('Confirma inclusao do Evento (S/N) ?')
      FPG1500->( dbappend() )
      FPG1500->CODEMP     := X_CODEMP
      FPG1500->CODEVENTO  := X_CODEVENTO
      f1500grava()

      scroll(09,27,19,54,1)
      FPG1500->( dbunlock() )
   end

end

************************************
function editae1500()
************************************
setcursor(1)

telae1500()

@ 04,26 say    FPG1500->CODEVENTO
f1500atrib()
TES_CODBASE  (16,26)

f1500get()

if lastkey() <> K_ESC

   while FPG1500->( ! rlock() ); end
   f1500grava()

   FPG1500->DESCEVENT    := X_DESCEVENT
   FPG1500->MODO_CALC    := X_MODO_CALC
   FPG1500->TIPO_EVENT   := X_TIPO_EVENT
   FPG1500->CLASSE       := X_CLASSE
   FPG1500->FATOR        := X_FATOR
   FPG1500->CODBASE      := X_CODBASE
   FPG1500->INTERNO      := X_INTERNO
   FPG1500->TPFOLHA      := X_TPFOLHA
   FPG1500->SEQUENC      := X_SEQUENC
   FPG1500->( dbunlock() )

end
setcursor(0)

return nil


/*
-----------------------------------------------------------------------------
                      Funcao TES_CODBASE
-----------------------------------------------------------------------------
*/
function tes_CODBASE( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len( FPG1400->DESCRICAO ), TAM )

   X_CODBASE := zerofill(X_CODBASE)

   FPG1400->( dbsetorder(1) )
   FPG1400->( dbseek( X_CODEMP+X_CODBASE ) )

   if FPG1400->( ! found() ) .or. X_CODBASE = "000"
      m_tabelas("X_CODBASE")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL      say  left(FPG1400->DESCRICAO, TAM )
   else
      if LIN # NIL
         @ LIN     , COL         say        X_CODBASE
         @ LIN     , COL     + 4 say '- ' + left(FPG1400->DESCRICAO, TAM )
      else
         @ 16,26 say X_CODBASE
         @ 16,28 say left(FPG1400->DESCRICAO, TAM )
      end
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao TES_CODEVENTO
-----------------------------------------------------------------------------
*/
function tes_CODEVENTO( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len( FPG1500->DESCEVENT ), TAM )

   X_CODEVENTO := zerofill(X_CODEVENTO)

   FPG1500->( dbsetorder(1) )
   FPG1500->( dbseek( X_CODEMP+X_CODEVENTO ) )

   if FPG1500->( ! found() ) .or. X_CODEVENTO = "000"
      m_tabelas("X_CODEVENTO")
            if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if LIN # NIL
      @ LIN     , COL      say  left(FPG1500->DESCEVENT, TAM )
   else
      

      if LIN # NIL
         @ LIN     , COL         say        X_CODEVENTO
         @ LIN     , COL     + 4 say '- ' + left(FPG1500->DESCEVENT, TAM )
      else
         @ 16,26 say X_CODEVENTO
         @ 16,28 say left(FPG1500->DESCEVENT, TAM )
      end
   end

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1500()
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
Procedimento .: TELAe1500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae1500()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo do Evento....:                  Sequencia..:                      '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao...........:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Modulo de Calculo...:         ( FGT, INS, IRF, 13S, A13, . )             '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' Tipo de Evento......:         ( Provento/Desconto/Nulo)                  '
   @ 11,03 say '                                                                          '
   @ 12,03 say ' Classe..............:         ( Dias/Horas/Percentual/Valor )            '
   @ 13,03 say '                                                                          '
   @ 14,03 say ' Fator...............:         ( % )                                      '
   @ 15,03 say '                                                                          '
   @ 16,03 say ' Base de Calculo.....:                                                    '
   @ 17,03 say '                                                                          '
   @ 18,03 say ' Calculo Interno.....:         ( Sim/ Nao )                               '
   @ 19,03 say '                                                                          '
   @ 20,03 say ' Tipos de Folha .....:                                                    '
   @ 21,03 say '                               ( NOr/ADt/A1-Ad.13o./13o/REsc )            '
   @ 22,03 say '                                                                          '

return

function f1500get()

   @ 06,26 get X_DESCEVENT  picture "@!"
   @ 08,26 get X_MODO_CALC  picture "@!"
   @ 10,26 get X_TIPO_EVENT picture "@!"   valid ( X_TIPO_EVENT $ "PDN" )
   @ 12,26 get X_CLASSE     picture "@!"   valid ( X_CLASSE $ "DHPV" )
   @ 14,26 get X_FATOR      picture "999.99"
   @ 16,26 get X_CODBASE    picture "999"  valid tes_CODBASE(16,26)
   @ 18,26 get X_INTERNO    picture "!"    valid ( X_INTERNO $ "SN" )
   @ 20,26 get X_TPFOLHA    picture "@!"   valid ( X_TPFOLHA  $ "NO,AD,A1,13,CO,FE,RE,  " )
   @ 20,29 get X_TPFOLHA2   picture "@!"   valid ( X_TPFOLHA2 $ "NO,AD,A1,13,CO,FE,RE,  " )
   @ 20,32 get X_TPFOLHA3   picture "@!"   valid ( X_TPFOLHA3 $ "NO,AD,A1,13,CO,FE,RE,  " )
   @ 20,35 get X_TPFOLHA4   picture "@!"   valid ( X_TPFOLHA4 $ "NO,AD,A1,13,CO,FE,RE,  " )
   @ 20,38 get X_TPFOLHA5   picture "@!"   valid ( X_TPFOLHA5 $ "NO,AD,A1,13,CO,FE,RE,  " )
   @ 20,41 get X_TPFOLHA6   picture "@!"   valid ( X_TPFOLHA6 $ "NO,AD,A1,13,CO,FE,RE,  " )
   @ 04,56 get X_SEQUENC    picture "999"
   read

return  .t.

function f1500grava()

   FPG1500->DESCEVENT  := X_DESCEVENT
   FPG1500->MODO_CALC  := X_MODO_CALC
   FPG1500->TIPO_EVENT := X_TIPO_EVENT
   FPG1500->CLASSE     := X_CLASSE
   FPG1500->FATOR      := X_FATOR
   FPG1500->CODBASE    := X_CODBASE
   FPG1500->INTERNO    := X_INTERNO
   FPG1500->TPFOLHA    := X_TPFOLHA
   FPG1500->TPFOLHA2   := X_TPFOLHA2
   FPG1500->TPFOLHA3   := X_TPFOLHA3
   FPG1500->TPFOLHA4   := X_TPFOLHA4
   FPG1500->TPFOLHA5   := X_TPFOLHA5
   FPG1500->TPFOLHA6   := X_TPFOLHA6
   FPG1500->SEQUENC    := X_SEQUENC

return .t.

function f1500atrib

   X_DESCEVENT     := FPG1500->DESCEVENT
   X_MODO_CALC     := FPG1500->MODO_CALC
   X_TIPO_EVENT    := FPG1500->TIPO_EVENT
   X_CLASSE        := FPG1500->CLASSE
   X_FATOR         := FPG1500->FATOR
   X_CODBASE       := FPG1500->CODBASE
   X_INTERNO       := FPG1500->INTERNO
   X_TPFOLHA       := FPG1500->TPFOLHA
   X_TPFOLHA2      := FPG1500->TPFOLHA2
   X_TPFOLHA3      := FPG1500->TPFOLHA3
   X_TPFOLHA4      := FPG1500->TPFOLHA4
   X_TPFOLHA5      := FPG1500->TPFOLHA5
   X_TPFOLHA6      := FPG1500->TPFOLHA6
   X_SEQUENC       := FPG1500->SEQUENC

return .t.
