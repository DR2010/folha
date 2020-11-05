/*
   FPG - Folha de Pagamento
   FPGR0700.PRG - Listagem de Unidade Federal
*/

#include "inkey.ch"
telanum('SCE0700','FPGR0700')

private linha134 := replicate('-',134)

abrir("FPG0400")

FPG0400->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0400->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0700_CAB (W_PAG)
         R0700_TIT (' Relatorio de Unidade Federal ')
         W_LIN := 10
      end

       W_LIN++

       R0700_DET()
      
      FPG0400->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R0700_CAB
-----------------------------------------------------------------------------
*/
procedure R0700_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0700','FPGR0700')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R0700_TIT
-----------------------------------------------------------------------------
*/
procedure R0700_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Unid.Federal'
    @ prow()  , 14 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R0700_DET
-----------------------------------------------------------------------------
*/
procedure R0700_DET()

    @ prow()+1, 06 say FPG0400->CODUF
    @ prow()  , 14 say FPG0400->DESCRICAO

return





