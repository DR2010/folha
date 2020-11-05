/*
   FPG - Folha de Pagamento
   FPGR1800.PRG - Listagem Naturalidade
*/

#include "inkey.ch"
telanum('SCE1800','FPGR1800')

private linha134 := replicate('-',134)

abrir("FPG2000")

FPG2000->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG2000->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1800_CAB (W_PAG)
         R1800_TIT (' Relatorio de Naturalidade ')
         W_LIN := 10
      end

      W_LIN++

      R1800_DET()

      FPG2000->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1800_CAB
-----------------------------------------------------------------------------
*/
procedure R1800_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1800','FPGR1800')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1800_TIT
-----------------------------------------------------------------------------
*/
procedure R1800_TIT( P_TITPROC )

    @ prow()+1, int (((136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 08 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1800_DET
-----------------------------------------------------------------------------
*/
procedure R1800_DET()

    @ prow()+1, 03 say FPG2000->CODNATURAL
    @ prow()  , 08 say FPG2000->DESCRICAO

return





