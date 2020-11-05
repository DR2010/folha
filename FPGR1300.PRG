/*
   FPG - Folha de Pagamento
   FPGR1300.PRG - Listagem Nacionalidade
*/

#include "inkey.ch"
telanum('SCE1300','FPGR1300')

private linha134 := replicate('-',134)

abrir("FPG1100")

FPG1100->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1100->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1300_CAB (W_PAG)
         R1300_TIT (' Relatorio de Nacionalidade ')
         W_LIN := 10
      end

      W_LIN++

      R1300_DET()

      FPG1100->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1300_CAB
-----------------------------------------------------------------------------
*/
procedure R1300_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1300','FPGR1300')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1300_TIT
-----------------------------------------------------------------------------
*/
procedure R1300_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 08 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1300_DET
-----------------------------------------------------------------------------
*/
procedure R1300_DET()

    @ prow()+1, 03 say FPG1100->CODNACIONA
    @ prow()  , 08 say FPG1100->DESCRICAO

return




