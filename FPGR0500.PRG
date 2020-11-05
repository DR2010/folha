/*
   FPG - Folha de Pagamento
   FPGR0500.PRG - Listagem de Eventos
*/

#include "inkey.ch"
telanum('SCE0500','FPGR0500')

private linha134 := replicate('-',134)

abrir("FPG1500")

FPG1500->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG1500->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R0500_CAB (W_PAG)
         R0500_TIT (' Relatorio de Eventos ')
         W_LIN := 10
      end


      if FPG1500->CODEMP = X_CODEMP
         W_LIN++
         R0500_DET()
      end


      FPG1500->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R0500_CAB
-----------------------------------------------------------------------------
*/
procedure R0500_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE0500','FPGR0500')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R0500_TIT
-----------------------------------------------------------------------------
*/
procedure R0500_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Codigo'
    @ prow()  , 09 say 'Descricao'
    @ prow()  , 42 say 'Mod.Calc'
    @ prow()  , 52 say 'Tp.Ev.'
    @ prow()  , 60 say 'Classe'
    @ prow()  , 68 say 'Fator'
    @ prow()  , 79 say 'B.Calc'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R0500_DET
-----------------------------------------------------------------------------
*/
procedure R0500_DET()

    @ prow()+1, 02 say FPG1500->CODEVENTO
    @ prow()  , 09 say FPG1500->DESCEVENT
    @ prow()  , 44 say FPG1500->MODO_CALC
    @ prow()  , 54 say FPG1500->TIPO_EVENT
    @ prow()  , 63 say FPG1500->CLASSE
    @ prow()  , 69 say FPG1500->FATOR
    @ prow()  , 80 say FPG1500->CODBASE
return






