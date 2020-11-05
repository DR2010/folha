/*
   FPG - Folha de Pagamento
   FPGR2100.PRG - Ficha de Empresa
*/

#include "inkey.ch"
telanum('SCE2100','FPGR2100')

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
         R2100_CAB (W_PAG)
         R2100_TIT (' Ficha de Empresa ')
         W_LIN := 10
      end


      if FPG0100->CODEMP = X_CODEMP
         W_LIN++
         R2100_TIT()
      end
      

      FPG0100->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento R2100_CAB
-----------------------------------------------------------------------------
*/
procedure R2100_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE2100','FPGR2100')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R2100_TIT
-----------------------------------------------------------------------------
*/
procedure R2100_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Empresa:'
    @ prow()  , 10 say FPG0100->CODEMP
    @ prow()+1, 01 say 'Razao Social:'
    @ prow()  , 15 say FPG0100->RAZAO
    @ prow()+1, 01 say 'CGC:'
    @ prow()  , 06 say FPG0100->CGC
    @ prow()  , 25 say 'Inscricao Municipal:'
    @ prow()  , 46 say FPG0100->INSC_MUN
    @ prow()+1, 01 say 'Endereco:'
    @ prow()  , 11 say FPG0100->ENDERECO
    @ prow()  , 60 say 'CEP:'
    @ prow()  , 65 say FPG0100->CEP
    @ prow()+1, 01 say 'Bairro:'
    @ prow()  , 09 say FPG0100->BAIRRO
    @ prow()  , 25 say 'Estado:'
    @ prow()  , 33 say FPG0100->ESTADO
    @ prow()+1, 01 say 'DDD:'
    @ prow()  , 06 say FPG0100->DDD01
    @ prow()  , 11 say 'Telefone:'
    @ prow()  , 21 say FPG0100->TELEFONE01
    @ prow()  , 31 say 'Ramal:'
    @ prow()  , 38 say FPG0100->RAMAL01
    @ prow()  , 55 say 'Contato:'
    @ prow()  , 64 say FPG0100->CONTATO01
    @ prow()+1, 01 say 'DDD:'
    @ prow()  , 06 say FPG0100->DDDFAX01
    @ prow()  , 11 say 'Fax:'
    @ prow()  , 17 say FPG0100->FAX01

return

