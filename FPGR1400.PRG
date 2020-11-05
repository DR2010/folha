/*
   FPG - Folha de Pagamento
   FPGR1400.PRG - Listagem de Setor
*/

#include "inkey.ch"
telanum('SCE1400','FPGR1400')

private linha134 := replicate('-',134)

abrir("FPG0500")

FPG0500->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0500->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1400_CAB (W_PAG)
         R1400_TIT (' Relatorio de Setor ')
         W_LIN := 10
      end

      if FPG0500->CODEMP = X_CODEMP
         W_LIN++
         R1400_DET()
      end

      FPG0500->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1400_CAB
-----------------------------------------------------------------------------
*/
procedure R1400_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1400','FPGR1400')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1400_TIT
-----------------------------------------------------------------------------
*/
procedure R1400_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Setor'
    @ prow()  , 23 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1400_DET
-----------------------------------------------------------------------------
*/
procedure R1400_DET()

    @ prow()+1, 01 say FPG0500->CODSETOR
    @ prow()  , 23 say FPG0500->DESCRICAO

return






