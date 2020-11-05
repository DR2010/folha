/*
   FPG - Folha de Pagamento
   FPGR1500.PRG - Listagem de INSS
*/

#include "inkey.ch"
telanum('SCE1500','FPGR1500')

private linha134 := replicate('-',134)

abrir("FPG1300")

FPG1300->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1300->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1500_CAB (W_PAG)
         R1500_TIT (' Relatorio de INSS ')
         W_LIN := 10
      end

      W_LIN++

      R1500_DET()

      FPG1300->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1500_CAB
-----------------------------------------------------------------------------
*/
procedure R1500_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1500','FPGR1500')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1500_TIT
-----------------------------------------------------------------------------
*/
procedure R1500_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Faixa'
    @ prow()  , 09 say 'Inicio-Faixa'
    @ prow()  , 24 say 'Fim-Faixa'
    @ prow()  , 37 say 'Percentual'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1500_DET
-----------------------------------------------------------------------------
*/
procedure R1500_DET()

    @ prow()+1, 02 say FPG1300->FAIXA
    @ prow()  , 10 say FPG1300->INIC_FAIXA
    @ prow()  , 24 say FPG1300->FIM_FAIXA
    @ prow()  , 41 say FPG1300->PERCENTUAL

return




