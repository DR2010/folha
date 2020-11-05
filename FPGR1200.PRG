/*
   FPG - Folha de Pagamento
   FPGR1200.PRG - Listagem de Salario
*/

#include "inkey.ch"
telanum('SCE1200','FPGR1200')

private linha134 := replicate('-',134)

abrir("FPG0900")

FPG0900->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0900->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1200_CAB (W_PAG)
         R1200_TIT (' Relatorio de Salario ')
         W_LIN := 10
      end

      W_LIN++

      R1200_DET()

      FPG0900->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1200_CAB
-----------------------------------------------------------------------------
*/
procedure R1200_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1200','FPGR1200')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1200_TIT
-----------------------------------------------------------------------------
*/
procedure R1200_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Periodo'
    @ prow()  , 15 say 'Salario Base'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1200_DET
-----------------------------------------------------------------------------
*/
procedure R1200_DET()

    @ prow()+1, 02 say FPG0900->PERIODO
    @ prow()  , 15 say FPG0900->VL_SALMIN

return




