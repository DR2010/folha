/*
   FPG - Folha de Pagamento
   FPGR1100.PRG - Listagem de Agencias
*/

#include "inkey.ch"
telanum('SCE1100','FPGR1100')

private linha134 := replicate('-',134)

abrir("FPG0800")

FPG0800->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0800->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1100_CAB (W_PAG)
         R1100_TIT (' Relatorio de Agencias ')
         W_LIN := 10
      end

       W_LIN++

       R1100_DET()


      FPG0800->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1100_CAB
-----------------------------------------------------------------------------
*/
procedure R1100_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1100','FPGR1100')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1100_TIT
-----------------------------------------------------------------------------
*/
procedure R1100_TIT( P_TITPROC )

    @ prow()+1, int (((136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Cod.Banco'
    @ prow()  , 12 say 'Cod.Agencia'
    @ prow()  , 24 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1100_DET
-----------------------------------------------------------------------------
*/
procedure R1100_DET()

    @ prow()+1, 04 say FPG0800->CODBANCO
    @ prow()  , 16 say FPG0800->CODAGENCIA
    @ prow()  , 24 say FPG0800->DESCRICAO

return





