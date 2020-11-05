/*
   FPG - Folha de Pagamento
   FPGR1000.PRG - Listagem de Bancos
*/

#include "inkey.ch"
telanum('SCE1000','FPGR1000')

private linha134 := replicate('-',134)

abrir("FPG0700")

FPG0700->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0700->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1000_CAB (W_PAG)
         R1000_TIT (' Relatorio de Bancos ')
         W_LIN := 10
      end

       W_LIN++

       R1000_DET()


      FPG0700->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1000_CAB
-----------------------------------------------------------------------------
*/
procedure R1000_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1000','FPGR1000')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1000_TIT
-----------------------------------------------------------------------------
*/
procedure R1000_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 08 say 'Descricao'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1000_DET
-----------------------------------------------------------------------------
*/
procedure R1000_DET()

    @ prow()+1, 03 say FPG0700->CODBANCO
    @ prow()  , 08 say FPG0700->DESCRICAO

return





