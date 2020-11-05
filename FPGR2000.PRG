/*
   FPG - Folha de Pagamento
   FPGR2000.PRG - Resumo da folha
*/
#include "inkey.ch"

telanum('FPGR2000','FPGR2000')

X_ANO    := '96'
X_MES    := '  '
WPAG     := 66

LINHA80 := replicate('-',132)

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG0300")
abrir("FPG0900")
abrir("FPG1300")
abrir("FPG1500")
abrir("FPG1600")
abrir("FPG1700")
abrir("FPG1800")
abrir("FPG2200")
abrir("FPG2300")
abrir("FPG2500") // Valores basicos
abrir("FPG3100")
abrir("FPG5000")

empresa_ok()

private X_MATRIC    := SPACE(5),;
        X_NUMFOLHA  := SPACE(2),;
        X_CODEVENTO := SPACE(3),;
        X_TPFOLHA   := SPACE(2),;
        X_VALOR     := 0.00    ,;
        W_BASECALC  := 0.00

setcolor(W_COREDIT)
tela5000()

WSCR5000 := savescreen(,,,,)


X_MATRIC := SPACE(5)

restscreen(,,,,WSCR5000 )
@ 05,10 get X_ANO      picture "99" valid ! empty( X_ANO )
@ 05,23 get X_MES      picture "99" valid ! empty( X_MES )
@ 05,50 get X_NUMFOLHA picture "99" valid ! empty( X_NUMFOLHA )
@ 05,67 get X_TPFOLHA  picture "!!" valid ! empty( X_TPFOLHA ) .or. tes_TPFOLHA(05,67,11,1)
read

if lastkey()= K_ESC; return; end

X_ANO      := zerofill( X_ANO )
X_MES      := zerofill( X_MES )
X_MATRIC   := zerofill( X_MATRIC )
X_NUMFOLHA := zerofill( X_NUMFOLHA )

@ 05,10 say X_ANO
@ 05,23 say X_MES
@ 05,50 say X_NUMFOLHA
@ 05,67 say X_TPFOLHA

if dh_imprime(1)

   FPG0200->( dbsetorder(1) )
   FPG0200->( dbseek( X_CODEMP ))

   RELCAB( ++WPAG, 134)

   while FPG0200->CODEMP = X_CODEMP .and. FPG0200->( ! eof() )

      if tes_status ( FPG0200->MATRIC )
         proc_matricula()
      end

      FPG0200->( dbskip() )

   end

end

dh_impoff()


/*

    Linha detalhe 2000

*/
function det2000

    @ prow()+1, 01 say FPG5000->CODEVENTO
    @ prow()  , 10 say left( FPG1500->DESCEVENT, 20 )
    @ prow()  , 50 say FPG5000->VALOR picture '999,999.99'

return

//------------------------------------------------------------------
function Proc_matricula()
//------------------------------------------------------------------
local WRET := .T.

      @ prow()+2, 01 say LINHA80
      @ prow()+1, 01 say FPG0200->MATRIC + ' - '+ FPG0200->NOME
      @ prow()  , 70 say 'Cargo:'
      X_CODCARGO := FPG0200->CODCARGO
      TES_CODCARGO(PROW(),78,30,1)

      X_MATRIC := FPG0200->MATRIC

      FPG5000->( dbsetorder(1) )
      FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+FPG0200->MATRIC ) )

      W_PROVENTO := 0
      W_DESCONTO := 0
      W_LIQUIDO  := 0

      while FPG5000->CODEMP    +;
            FPG5000->ANO       +;
            FPG5000->MES       +;
            FPG5000->NUMFOLHA  +;
            FPG5000->MATRIC  = X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC

         FPG1500->( dbsetorder(1) )
         FPG1500->( dbseek( X_CODEMP+FPG5000->CODEVENTO ) )

         if FPG1500->TIPO_EVENT = "P"
            W_PROVENTO += FPG5000->VALOR
         else
            if FPG1500->TIPO_EVENT = "D"
               W_DESCONTO += FPG5000->VALOR
            end
         end

         if prow() > 55; RELCAB( ++WPAG, 134); end

         det2000()

         FPG5000->( dbskip() )

      end

      W_LIQUIDO := W_PROVENTO - W_DESCONTO

      if prow() > 55
         RELCAB( ++WPAG, 134)
      end

      @ prow()+2, 50 say 'Proventos : ' + transform( W_PROVENTO ,'@E 999,999.99' )
      @ prow()+1, 50 say 'Descontos : ' + transform( W_DESCONTO ,'@E 999,999.99' )
      @ prow()+1, 50 say 'Liquido   : ' + transform( W_LIQUIDO  ,'@E 999,999.99' )
      @ prow()+2, 90 say '----------------------------------------'
      @ prow()+1,105 say 'Assinatura'

return WRET

