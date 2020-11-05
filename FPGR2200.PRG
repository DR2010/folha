/*
   FPG - Folha de Pagamento
   FPGR2200.PRG - Ficha do Funcionario
*/

#include "inkey.ch"
telanum('SCE2200','FPGR2200')

private linha134 := replicate('-',134)

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG0300")
abrir("FPG0400")
abrir("FPG0500")
abrir("FPG0600")
abrir("FPG1100")
abrir("FPG1700")
abrir("FPG2000")


X_MATRIC    := space(05)

FPG0200->( dbgotop() )


if par_2200()


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
            R2200_CAB (W_PAG)
            R2200_TIT (' Ficha do Funcionario ')
            W_LIN := 10
         end

         if FPG0200->CODEMP = X_CODEMP
            W_LIN++
         end

         FPG0200->( dbskip() )
      end
   end

end

   dh_impoff()


// fim do programa


//-----------------------------------------------------------------------------
                             function par_2200()
//-----------------------------------------------------------------------------

local WRET := .T.

@ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄ Parametro de Impressao ÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,15 say '³                                            ³'
@ 12,15 say '³ Matricula..:                               ³'
@ 13,15 say '³                                            ³'
@ 14,15 say '³                                            ³'
@ 15,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,29 get X_MATRIC   picture '99999' valid tes_param (12,29,20,1)

if lastkey() = K_ESC
   WRET := .F.
end

read

return WRET

//****************************************//
function tes_param(lin,col,tam,rel)
//****************************************//
local WRET := .T.

  if X_MATRIC != '99999'
     Tes_matric(lin,col,tam,rel)
  else
     if X_MATRIC = '99999'
        @ 12,37 say 'Todos Funcionarios'
     endif
  endif

  if lastkey() = K_ESC
     WRET := .F.
  end

return WRET


                               
/*
-----------------------------------------------------------------------------
                      Procedimento R2200_CAB
-----------------------------------------------------------------------------
*/
procedure R2200_CAB( P_PAG )

    @ prow()+1, 01 say telarel('SCE2200','FPGR2200')
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R2200_TIT
-----------------------------------------------------------------------------
*/
procedure R2200_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 01 say 'Matricula:'
    @ prow()  , 12 say FPG0200->MATRIC
    @ prow()  , 18 say '-'
    @ prow()  , 20 say FPG0200->NOME

    @ prow()+1, 01 say 'Cargo:'
    X_CODCARGO := FPG0200->CODCARGO
    TES_CODCARGO(PROW(),08,30,1)


    @ prow()  , 40 say 'Setor:'
    X_CODSETOR := FPG0200->CODSETOR
    TES_CODSETOR(PROW(),47,30,1)

    @ prow()+1, 01 say 'Salario:'
    @ prow()  , 10 say FPG0200->SALARIO
    @ prow()+1, 01 say 'D.S.R:'
    @ prow()  , 08 say FPG0200->DSR
    @ prow()  , 30 say 'Carga Horaria:'
    @ prow()  , 45 say FPG0200->CRGHORMES
    @ prow()+1, 01 say 'Data de Nascimento:'
    @ prow()  , 21 say FPG0200->DAT_NASCM
       
    @ prow()  , 40 say 'Grau de Instrucao:'
    X_CODGRAU := FPG0200->CODGRAU
    TES_CODGRAU(PROW(),59,30,1)

    @ prow()+1, 01 say 'Naturalidade:'
    X_CODNATURAL := FPG0200->CODNATURAL
    TES_CODNATURAL(PROW(),15,20,1)

    @ prow()  , 40 say 'Nacionalidade:'
    X_CODNACIONA := FPG0200->CODNACIONA
    TES_CODNACIONA(PROW(),55,15,1)

    @ prow()+1, 01 say 'Estado Civil:'
    X_CODCIVIL := FPG0200->CODCIVIL
    TES_CODCIVIL(PROW(),15,30,1)
                         
    @ prow()  , 47 say 'Dependentes:'
    @ prow()  , 61 say FPG0200->DEPENDENTE
    @ prow()+1, 01 say 'Filiacao    Pai:'
    @ prow()  , 18 say FPG0200->FIL_PAI
    @ prow()+1, 13 say 'Mae:'
    @ prow()  , 18 say FPG0200->FIL_MAE
    @ prow()+1, 01 say 'Endereco:'
    @ prow()  , 11 say FPG0200->ENDERECO
    @ prow()+1, 01 say 'Bairro:'
    @ prow()  , 09 say FPG0200->BAIRRO
    @ prow()  , 30 say 'Cidade:'
    @ prow()  , 39 say FPG0200->CIDADE

    @ prow()  , 55 say 'Unidade Federal:'
    X_CODCIVIL := FPG0200->CODCIVIL
    TES_CODCIVIL(PROW(),72,30,1)

    @ prow()+1, 01 say 'CEP:'
    @ prow()  , 06 say FPG0200->CEP
    @ prow()  , 20 say 'Telefone:'
    @ prow()  , 30 say FPG0200->TEL_CONTAT
    @ prow()+1, 01 say 'CPF:'
    @ prow()  , 06 say FPG0200->CPF
    @ prow()  , 30 say 'RG:'
    @ prow()  , 34 say FPG0200->IDENTIDADE
    @ prow()  , 50 say 'Expedicao:'
    @ prow()  , 61 say FPG0200->ORGAO
    @ prow()  , 75 say 'Data de Emissao:'
    @ prow()  , 92 say FPG0200->EMISSAO
    @ prow()+1, 01 say 'Tit.Eleitor:'
    @ prow()  , 14 say FPG0200->TIT_ELEIT
    @ prow()  , 25 say 'Zona:'
    @ prow()  , 31 say FPG0200->ZONA
    @ prow()  , 37 say 'Secao:'
    @ prow()  , 44 say FPG0200->SECAO
    @ prow()+1, 01 say 'C.Reservista:'
    @ prow()  , 15 say FPG0200->CERT_RESER
    @ prow()  , 30 say 'C.Profissional:'
    @ prow()  , 46 say FPG0200->CART_PROFS
    @ prow()  , 60 say 'Serie:'
    @ prow()  , 67 say FPG0200->SERIE
    @ prow()+1, 01 say 'Pis/Pasep:'
    @ prow()  , 12 say FPG0200->PIS
    @ prow()  , 30 say 'Data:'
    @ prow()  , 36 say FPG0200->DATA01
    @ prow()  , 50 say 'Banco:'
    @ prow()  , 57 say FPG0200->BANCO
    @ prow()  , 65 say 'Agencia:'
    @ prow()  , 75 say FPG0200->AGENCIA
    @ prow()+1, 01 say 'E Optante:'
    @ prow()  , 12 say FPG0200->OPCAO
    @ prow()  , 25 say 'Dt. Opcao:'
    @ prow()  , 36 say FPG0200->DT_OPCAO
    @ prow()  , 50 say 'Dt. Admissao:'
    @ prow()  , 65 say FPG0200->DT_ADM
return

