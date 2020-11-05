/*
   FPG - Folha de Pagamento
   FPGR1700.PRG - Listagem de Grau de Intrucao
*/

#include "inkey.ch"
telanum('SCE1700','FPGR1700')

private linha134 := replicate('-',134)

abrir("FPG1700")

FPG1700->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1700->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1700_CAB (W_PAG)
         R1700_TIT (' Relatorio de Grau de Intrucao ')
         W_LIN := 10
      end

      W_LIN++

      R1700_DET()

      FPG1700->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1700_CAB
-----------------------------------------------------------------------------
*/
procedure R1700_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1700','FPGR1700')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1700_TIT
-----------------------------------------------------------------------------
*/
procedure R1700_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 08 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1700_DET
-----------------------------------------------------------------------------
*/
procedure R1700_DET()

    @ prow()+1, 03 say FPG1700->CODGRAU
    @ prow()  , 08 say FPG1700->DESCRICAO

return




