/*
   FPG - Folha de Pagamento
   FPGR0800.PRG - Listagem de Estado Civil
*/

#include "inkey.ch"
telanum('SCE0800','FPGR0800')

private linha134 := replicate('-',134)

abrir("FPG0600")

FPG0600->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0600->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0800_CAB (W_PAG)
         R0800_TIT (' Relatorio de Estado Civil ')
         W_LIN := 10
      end
      
       W_LIN++

       R0800_DET()

      FPG0600->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R0800_CAB
-----------------------------------------------------------------------------
*/
procedure R0800_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0800','FPGR0800')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R0800_TIT
-----------------------------------------------------------------------------
*/
procedure R0800_TIT( P_TITPROC )

    @ prow()+1, int (((136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 09 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R0800_DET
-----------------------------------------------------------------------------
*/
procedure R0800_DET()

    @ prow()+1, 03 say FPG0600->CODCIVIL
    @ prow()  , 09 say FPG0600->DESCRICAO

return





