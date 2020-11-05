/*
   GER   -
   GERR0100.PRG - Relatorio de DARF

*/
setcancel(.t.)
altd(1)

telanum('GERR0100','GERR0100')

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

W_VL       := 0.0000
W_VL_MULTA := 0.0000
W_VL_JUROS := 0.0000

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

      W_VL       := 0.0000
      W_VL       := 0.0000
      W_VL       := 0.0000
      WVAR1      := 0.0000
      WVAR2      := 0.0000
      WVAR3      := 0.0000

      W_VL_MULTA := 0.0000
      W_VL_JUROS := 0.0000

      FPG0100->( dbsetorder(1) )
      FPG0100->( dbseek( GER0200->CODEMP) )

      @ prow()  , 1  say ' '
      @ prow()  , 30 say FPG0100->CGC                         picture "@R 99.999.999/9999-99"
      @ prow()  , 58 say GER0300->VENCIMENTO
      @ prow()+2, 29 say CHR(15)+FPG0100->RAZAO+CHR(18)
      @ prow()  , 58 say FPG0100->CGC                         picture "@R 99.999.999/9999-99"
      @ prow()+2, 29 say CHR(15)+FPG0100->ENDERECO+CHR(18)
      @ prow()  , 58 say GER0300->CODREC
      @ prow()+1, 29 say CHR(15)+FPG0100->BAIRRO+CHR(18)
      @ prow()  , 43 say CHR(15)+'CEP.:'+CHR(18)
      @ prow()  , 50 say CHR(15)+transform(FPG0100->CEP,"99999-999") + CHR(18)
      @ prow()+2, 29 say CHR(15)+FPG0100->ESTADO+CHR(18)

      IF GER0300->PERCENTUAL > 0
         W_VL := (GER0200->VALOR * GER0300->PERCENTUAL) / 100
      end

      @ prow()+3, 04 say FPG0100->RAZAO
      @ prow()  , 45 say FPG0100->TELEFONE01  picture "@R 999-9999"
      WVAR1 := int(W_VL*100)/100
      @ prow()  , 58 say WVAR1                picture "@E 9999,999.99"

      if GER0300->MULTA > 0
         W_VL_MULTA := (W_VL * GER0300->MULTA ) / 100
         WVAR2 := int(W_VL_MULTA*100)/100
         @ prow()+2, 58 say WVAR2        picture "@E 9999,999.99"
      else
         @ prow()+2, 58 say ' '
      end

      @ prow()+1, 04 say GER0300->DESCRICAO
      @ prow()+1, 04 say 'Valor Receita....: R$'
      @ prow()  , 20 say GER0200->VALOR       picture "@E 9999,999,999.99"

      if GER0300->JUROS > 0
         W_VL_JUROS := (W_VL * GER0300->JUROS ) / 100
         WVAR3 := int(W_VL_JUROS*100)/100

         @ prow()  , 58 say WVAR3             picture "@E 9999,999.99"
      else
         @ prow()  , 58 say ' '
      end

      W_VL := WVAR1+WVAR2+WVAR3

      @ prow()+2, 04 say GER0300->LIVRE1

      @ prow()  , 58 say W_VL                 picture "@E 9999,999.99"
      @ prow()+1, 04 say GER0300->LIVRE2
      @ prow()+1, 04 say GER0300->LIVRE3
      @ prow()+3, 04 say ' '
      @ prow()+1, 04 say ' '
      @ prow()+2, 04 say ' '

     GER0300->( dbskip() )

   end

   GER0200->( dbskip() )

enddo


return
