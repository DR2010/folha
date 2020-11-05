/*
   FPG - Folha de Pagamento
   FPGR0200.PRG - Listagem de Empresas
*/

#include "inkey.ch"
telanum('SCE0200','FPGR0200')

private linha134 := replicate('-',134)

abrir("FPG0100")

FPG0100->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0100->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0200_CAB (W_PAG)
         R0200_TIT (' Relatorio de Empresas ')
         W_LIN := 10
      end

      W_LIN++

      R0200_DET()

      FPG0100->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R0200_CAB
-----------------------------------------------------------------------------
*/
procedure R0200_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0200','FPGR0200')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R0200_TIT
-----------------------------------------------------------------------------
*/
procedure R0200_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 08 say 'Razao'
    @ prow()  , 52 say 'CGC'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R0200_DET
-----------------------------------------------------------------------------
*/
procedure R0200_DET()

    @ prow()+1, 03 say FPG0100->CODEMP
    @ prow()  , 08 say FPG0100->RAZAO
    @ prow()  , 52 say FPG0100->CGC

return



