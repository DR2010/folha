/*
   FPG - Folha de Pagamento
   FPGR1900.PRG - Listagem de Funcionarios
*/

#include "inkey.ch"
telanum('SCE1900','FPGR1900')

private linha134 := replicate('-',134)

abrir("FPG0200")

FPG0200->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while FPG0200->( ! eof() )

      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         R1900_CAB (W_PAG)
         R1900_TIT (' Relatorio de Funcionarios ')
         W_LIN := 10
      end

      if FPG0200->CODEMP = X_CODEMP
         W_LIN++
         R1900_DET()
      end


      FPG0200->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R1900_CAB
-----------------------------------------------------------------------------
*/
procedure R1900_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE1900','FPGR1900')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R1900_TIT
-----------------------------------------------------------------------------
*/
procedure R1900_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Matricula'
    @ prow()  , 12 say 'Nome'
    @ prow()  , 45 say 'Cargo'
    @ prow()  , 60 say 'Salario'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R1900_DET
-----------------------------------------------------------------------------
*/
procedure R1900_DET()

    @ prow()+1, 03 say FPG0200->MATRIC
    @ prow()  , 12 say FPG0200->NOME
    @ prow()  , 45 say FPG0200->CODCARGO
    @ prow()  , 60 say FPG0200->SALARIO

return






