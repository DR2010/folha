/*
   FPG   - Folha de Pagamento
   FPG9003.PRG - Relatorio de Contra Cheque

*/
setcancel(.t.)
altd(1)
#include "inkey.ch"

abrir("FPG0100")
abrir("FPG0200")
abrir("FPGB001")

OLD_STATUS := savescreen(24,00,24,79)

//
// corpo do programa
//

X_PERIODO   := space(20)
X_MATRIC    := space(05)
X_P_VLR_TOT := 0.00
X_D_VLR_TOT := 0.00
X_L_VLR_TOT := 0.00
X_L_IMP     := 0
X_L_MAX     := 10

if par_9003()
   dh_imprime()
   det_9003()
   dh_impoff()
end

return

// fim do programa

//*****************
function par_9003()
//*****************
local WRET := .T.

@ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄ Parametro de Impressao ÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,15 say '³                                            ³'
@ 12,15 say '³ Matricula..:                               ³'
@ 13,15 say '³ Referencia.:                               ³'
@ 14,15 say '³                                            ³'
@ 15,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,29 get X_MATRIC   picture '99999' valid tes_param (12,29,20)
@ 13,29 get X_PERIODO  picture '@!'    valid !empty (X_PERIODO)

if lastkey() = K_ESC
   WRET := .F.
end

read

return WRET

//*******************************//
function tes_param(lin,col,tam)
//*******************************//
local WRET := .T.

  if X_MATRIC != '99999'
     Tes_matric(lin,col,tam)
  else
     if X_MATRIC = '99999'
        @ 12,37 say 'Todos Funcionarios'
     endif
  endif

  if lastkey() = K_ESC
     WRET := .F.
  end

return WRET

//******************
procedure det_9003()
//******************

FPGB001->(dbsetorder(1))

if X_MATRIC = '99999'
   FPGB001->(dbseek(X_CODEMP))
else
   FPGB001->(dbseek(X_CODEMP+X_MATRIC))
end

do while (FPGB001->CODEMP  = X_CODEMP) .and. (FPGB001->(! eof()) )

   X_L_IMP     := 0
   X_L_MAX     := 10
   X_P_VLR_TOT := 0.00
   X_D_VLR_TOT := 0.00
   X_L_VLR_TOT := 0.00

   FPG0100->(dbsetorder(1))
   FPG0100->(dbseek(X_CODEMP))

   FPG0200->(dbsetorder(1))
   FPG0200->(dbseek(X_CODEMP+FPGB001->MATRIC))

   @ prow()+2, 01 say FPG0100->RAZAO
   @ prow()  , 45 say X_PERIODO
   @ prow()+3, 01 say FPGB001->MATRIC + ' - ' + FPG0200->NOME
   @ prow()  , 45 say FPGB001->CARGO
   @ prow()+3, 01 say '  '

   if FPGB001->P_VLR_1 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->P_DES_1
      @ prow()  , 40 say FPGB001->P_VLR_1 picture "@E 9999,999.99"
   end
   if FPGB001->P_VLR_2 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->P_DES_2
      @ prow()  , 40 say FPGB001->P_VLR_2 picture "@E 9999,999.99"
   end
   if FPGB001->P_VLR_3 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->P_DES_3
      @ prow()  , 40 say FPGB001->P_VLR_3 picture "@E 9999,999.99"
   end
   if FPGB001->P_VLR_4 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->P_DES_4
      @ prow()  , 40 say FPGB001->P_VLR_4 picture "@E 9999,999.99"
   end
   if FPGB001->P_VLR_5 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->P_DES_5
      @ prow()  , 40 say FPGB001->P_VLR_5 picture "@E 9999,999.99"
   end

   if FPGB001->D_VLR_1 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->D_DES_1
      @ prow()  , 55 say FPGB001->D_VLR_1 picture "@E 9999,999.99"
   end
   if FPGB001->D_VLR_2 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->D_DES_2
      @ prow()  , 55 say FPGB001->D_VLR_2 picture "@E 9999,999.99"
   end
   if FPGB001->D_VLR_3 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->D_DES_3
      @ prow()  , 55 say FPGB001->D_VLR_3 picture "@E 9999,999.99"
   end
   if FPGB001->D_VLR_4 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->D_DES_4
      @ prow()  , 55 say FPGB001->D_VLR_4 picture "@E 9999,999.99"
   end
   if FPGB001->D_VLR_5 > 0
      X_L_IMP ++
      @ prow()+1, 04 say FPGB001->D_DES_5
      @ prow()  , 55 say FPGB001->D_VLR_5 picture "@E 9999,999.99"
   end
   
   X_P_VLR_TOT := FPGB001->P_VLR_1 + FPGB001->P_VLR_2 + FPGB001->P_VLR_3 + FPGB001->P_VLR_4 + FPGB001->P_VLR_5
   X_D_VLR_TOT := FPGB001->D_VLR_1 + FPGB001->D_VLR_2 + FPGB001->D_VLR_3 + FPGB001->D_VLR_4 + FPGB001->D_VLR_5 

   X_L_VLR_TOT := X_P_VLR_TOT - X_D_VLR_TOT

   X_L_IMP     := (X_L_MAX - X_L_IMP) + 7

   @ prow()+ X_L_IMP , 40 say X_P_VLR_TOT picture "@E 9999,999.99"
   @ prow()          , 55 say X_D_VLR_TOT picture "@E 9999,999.99"
   @ prow()+2        , 55 say X_L_VLR_TOT picture "@E 9999,999.99"

   @ prow()+2        , 04 say ' '
 
   if FPGB001->SL_BASE > 0
      @ prow()  , 00 say FPGB001->SL_BASE picture "@E 9999,999.99"
   end
   if FPGB001->SL_INSS > 0
      @ prow()  , 11 say FPGB001->SL_INSS picture "@E 9999,999.99"
   end
   if FPGB001->SL_FGTS > 0
      @ prow()  , 24 say FPGB001->SL_FGTS picture "@E 9999,999.99"
   end
   if FPGB001->VL_FGTS > 0
      @ prow()  , 35 say FPGB001->VL_FGTS picture "@E 9999,999.99"
   end
   if FPGB001->SL_IRRF > 0
      @ prow()  , 50 say FPGB001->SL_IRRF picture "@E 9999,999.99"
   end
   if FPGB001->FX_IRRF > 0
      @ prow()  , 62 say FPGB001->FX_IRRF picture "@E 999.99"
   end

   @ prow()+4 , 1 say ' '

   if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      FPGB001->( dbgobottom())
   end

   if X_MATRIC = '99999'
      FPGB001->( dbskip())
   else
      exit
   end

enddo

return
