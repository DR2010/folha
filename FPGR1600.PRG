/*
   FPG - Folha de Pagamento
   FPGR1600.PRG - Listagem de Base de Calculo
*/

#include "inkey.ch"
telanum('SCE1600','FPGR1600')

private linha134 := replicate('-',134)

abrir("FPG1400")

FPG1400->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1400->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1600_CAB (W_PAG)
         R1600_TIT (' Relatorio de Base de Calculo ')
         W_LIN := 10
      end

      if FPG1400->CODEMP = X_CODEMP
         W_LIN++
         R1600_DET()
      end


      FPG1400->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1600_CAB
-----------------------------------------------------------------------------
*/
procedure R1600_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1600','FPGR1600')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1600_TIT
-----------------------------------------------------------------------------
*/
procedure R1600_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 09 say 'Descricao'
    @ prow()  , 42 say 'Especial'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1600_DET
-----------------------------------------------------------------------------
*/
procedure R1600_DET()

    @ prow()+1, 02 say FPG1400->CODBASE
    @ prow()  , 09 say FPG1400->DESCRICAO
    @ prow()  , 42 say FPG1400->ESPECIAL

return





