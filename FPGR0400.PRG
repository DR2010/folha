/*
   FPG - Folha de Pagamento
   FPGR0400.PRG - Listagem de Funcao
*/

#include "inkey.ch"
telanum('SCE0400','FPGR0400')

private linha134 := replicate('-',134)

abrir("FPG1200")

FPG1200->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1200->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0400_CAB (W_PAG)
         R0400_TIT (' Relatorio de Funcao ')
         W_LIN := 10
      end


      if FPG1200->CODEMP = X_CODEMP
         W_LIN++
         R0400_DET()
      end

      FPG1200->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R0400_CAB
-----------------------------------------------------------------------------
*/
procedure R0400_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0400','FPGR0400')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R0400_TIT
-----------------------------------------------------------------------------
*/
procedure R0400_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 09 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R0400_DET
-----------------------------------------------------------------------------
*/
procedure R0400_DET()

    @ prow()+1, 01 say FPG1200->CODFUNCAO
    @ prow()  , 09 say FPG1200->DESCRICAO

return





