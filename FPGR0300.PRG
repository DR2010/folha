/*
   FPG - Folha de Pagamento
   FPGR0300.PRG - Listagem de Incidencias
*/

#include "inkey.ch"
telanum('SCE0300','FPGR0300')

private linha134 := replicate('-',134)

abrir("FPG1800")
abrir("FPG1400")
abrir("FPG1500")

FPG1800->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1800->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0300_CAB (W_PAG)
         R0300_TIT (' Relatorio de Incidencias ')
         W_LIN := 10
      end


      if FPG1800->CODEMP = X_CODEMP
         W_LIN++
         R0300_DET()
      end


      FPG1800->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
 ----------------------------------------------------------------------------
                      Procedimento R0300_CAB
 ----------------------------------------------------------------------------
*/
Procedure R0300_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0300','FPGR0300')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
 ----------------------------------------------------------------------------
                      Procedimento R0300_TIT
 ----------------------------------------------------------------------------
*/
Procedure R0300_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Base'
    @ prow()  , 33 say 'Operacao'
    @ prow()  , 43 say 'Evento'
    @ prow()  , 75 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
 ----------------------------------------------------------------------------
                      Procedimento R0300_DET
 ----------------------------------------------------------------------------
*/
Procedure R0300_DET()

    @ prow()+1, 01 say FPG1800->CODBASE
    @ prow()  , 33 say FPG1800->OPERACAO
    @ prow()  , 43 say FPG1800->CODEVENTO
    @ prow()  , 75 say FPG1800->DESCEVENT

return














