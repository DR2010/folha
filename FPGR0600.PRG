/*
   FPG - Folha de Pagamento
   FPGR0600.PRG - Listagem de Dependentes
*/

#include "inkey.ch"
telanum('SCE0600','FPGR0600')

private linha134 := replicate('-',134)

abrir("FPG1900")

FPG1900->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1900->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0600_CAB (W_PAG)
         R0600_TIT (' Relatorio de Dependentes ')
         W_LIN := 10
      end


      if FPG1900->CODEMP = X_CODEMP
         W_LIN++
         R0600_DET()
      end


      FPG1900->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R0600_CAB
-----------------------------------------------------------------------------
*/
procedure R0600_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0600','FPGR0600')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R0600_TIT
-----------------------------------------------------------------------------
*/
procedure R0600_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'M.Func'
    @ prow()  , 09 say 'Nome'
    @ prow()  , 42 say 'Dt.Nasc.'
    @ prow()  , 53 say 'Sexo'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R0600_DET
-----------------------------------------------------------------------------
*/
procedure R0600_DET()

    @ prow()+1, 01 say FPG1900->MATRIC
    @ prow()  , 09 say FPG1900->NOME_DEP
    @ prow()  , 42 say FPG1900->DT_NASCM
    @ prow()  , 54 say FPG1900->SEXO

return




