/*
   GER   -
   GERR0100.PRG - Relatorio de DARF

*/
setcancel(.t.)
altd(1)
#include "inkey.ch"

abrir("FPG0100")
abrir("GER0200")
abrir("GER0300")

OLD_STATUS := savescreen(24,00,24,79)

//
// corpo do programa
//

X_PERIODO   := space(04)

if Par_G100()
   if dh_imprime()
      det_G100()
      dh_impoff()
   end
end

return

// fim do programa

//*****************
function PAR_G100()
//*****************
local WRET := .T.

@ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄ Parametro de Impressao ÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,15 say '³                                            ³'
@ 12,15 say '³ Periodo ..:                                ³'
@ 13,15 say '³ Empresa ..:                                ³'
@ 14,15 say '³                                            ³'
@ 15,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,29 get X_PERIODO  picture '9999'  valid ! empty(X_PERIODO)
@ 13,29 get X_CODEMP   picture '@!'    valid X_CODEMP='999' .or. tes_codemp()
read
if lastkey() = K_ESC
   WRET := .F.
end

return WRET

//******************
procedure DET_G100()
//******************

W_VL       := 0.00
W_VL_MULTA := 0.00
W_VL_JUROS := 0.00

FPG0100->( dbsetorder(1) )

if X_CODEMP = '999'
   GER0200->( dbsetorder(2) )
   GER0200->( dbseek(X_PERIODO) )
   BL_COND := {|| GER0200->PERIODO = X_PERIODO }
else
   GER0200->( dbsetorder(1) )
   GER0200->( dbseek(X_CODEMP+X_PERIODO) )
   BL_COND := {|| GER0200->CODEMP+GER0200->PERIODO = X_CODEMP+X_PERIODO }
end

select GER0200

do while eval( BL_COND )

   GER0300->( dbseek( GER0200->CODEMP ) )

   do while ( GER0300->CODEMP = GER0200->CODEMP ) .and. (GER0300->( ! eof() ) )

      W_VL       := 0.00
      W_VL_MULTA := 0.00
      W_VL_JUROS := 0.00

      FPG0100->( dbsetorder(1) )
      FPG0100->( dbseek( GER0200->CODEMP) )

      @ prow()  , 1  say ' '
      @ prow()  , 56 say GER0300->VENCIMENTO
      @ prow()+2, 56 say FPG0100->CGC         picture "@R 99.999.999/9999-99"
      @ prow()+2, 56 say GER0300->CODREC

      IF GER0300->PERCENTUAL > 0
         W_VL := (GER0200->VALOR * GER0300->PERCENTUAL) / 100
      end

      @ prow()+6, 01 say FPG0100->RAZAO
      @ prow()  , 42 say FPG0100->TELEFONE01  picture "@R 999-9999"
      @ prow()  , 56 say W_VL                 picture "@E 9999,999.99"

      if GER0300->MULTA > 0
         W_VL_MULTA := (W_VL * GER0300->MULTA ) / 100
         @ prow()+2, 56 say W_VL_MULTA        picture "@E 9999,999.99"
      else
         @ prow()+2, 56 say ' '
      end

      @ prow()+1, 01 say GER0300->DESCRICAO
      @ prow()+1, 01 say 'Valor Receita....: R$'
      @ prow()  , 20 say GER0200->VALOR       picture "@E 9999,999,999.99"

      if GER0300->JUROS > 0
         W_VL_JUROS := (W_VL * GER0300->JUROS ) / 100
         @ prow()  , 56 say W_VL_JUROS        picture "@E 9999,999.99"
      else
         @ prow()  , 56 say ' '
      end

      W_VL := W_VL + W_VL_MULTA + W_VL_JUROS

      @ prow()+2, 01 say GER0300->LIVRE1

      @ prow()  , 56 say W_VL                 picture "@E 9999,999.99"
      @ prow()+1, 01 say GER0300->LIVRE2
      @ prow()+1, 01 say GER0300->LIVRE3
      @ prow()+3, 01 say ' '
      @ prow()+1, 01 say ' '
      @ prow()+2, 01 say ' '

     GER0300->( dbskip() )

   end

   GER0200->( dbskip() )

enddo

return
