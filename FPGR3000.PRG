/*
   FPG - Folha de Pagamento
   FPGR2000.PRG - GRPS
*/
#include "inkey.ch"

telanum('FPGR3000','FPGR3000')

X_ANO          := '  '
X_MES          := '  '
WPAG           := 66
X_ANO          := SPACE(2)
X_MES          := SPACE(2)
X_NUMFOLHA     := SPACE(2)
X_CODEVENTO    := SPACE(3)
X_CODFPAS      := SPACE(2)
W_QTDFUNC      := 0
W_VLPROVENTO   := 0.00
W_VLTOT_8      := 0.00
W_VLEMPREGADOR := 0.00
W_VLSEGURADO   := 0.00
W_VLEMPRESA    := 0.00
W_VLTERCEIRO   := 0.00
W_VLDEDUCAO    := 0.00
W_VLTOT_25     := 0.00
X_MATRIC_ATUAL := space(5)
LINHA80        := replicate('-',132)

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG1500")
abrir("FPG5000")
abrir("FPG4000")
abrir("GER0400")
abrir("GER0500")

setcolor(W_COREDIT)
tela5000()

@ 05,10 get X_ANO      picture "99" valid ! empty( X_ANO )
@ 05,23 get X_MES      picture "99" valid ! empty( X_MES )
@ 05,50 get X_NUMFOLHA picture "99" valid ! empty( X_NUMFOLHA )
read

if lastkey()= K_ESC; return; end

X_ANO      := zerofill( X_ANO )
X_MES      := zerofill( X_MES )
X_NUMFOLHA := zerofill( X_NUMFOLHA )

@ 05,10 say X_ANO
@ 05,23 say X_MES
@ 05,50 say X_NUMFOLHA

if R3000_acessos()
   if dh_imprime(1)
      R3000_funcionarios()
      R3000_empregador  ()
      R3000_emp         ()
      R3000_terceiro    ()
      R3000_imprime     ()
   end
end

dh_impoff()

dbcloseall()

return

//------------------------------------------------------------------
function R3000_acessos ()
//------------------------------------------------------------------
local WRET := .T.

X_ANO :=  substr(X_ANO,1)
FPG0100->( dbsetorder(1) )
if !(FPG0100->( dbseek(X_CODEMP) ))
    mensbeep ('Empresa Nao Encontrada !')
    WRET := .F.
end

FPG4000->( dbsetorder(1) )
if !(FPG4000->( dbseek(FPG0100->CODFPAS)))
    mensbeep ('Atividade Nao Encontrada !')
    WRET := .F.
end

GER0400->( dbsetorder(1) )
if !(GER0400->( dbseek(X_CODEMP+X_ANO+X_MES)))
    mensbeep ('Retirada Pro-Labore Nao Encontrada !')
    WRET := .F.
end

GER0500->( dbsetorder(1) )
if !(GER0500->( dbseek ( X_CODEMP+X_ANO+X_MES ) ))
    mensbeep ('Honorario Contabil Nao Encontrado !')
    WRET := .F.
end

return WRET
//------------------------------------------------------------------
function R3000_funcionarios ()
//------------------------------------------------------------------
local WRET := .T.

FPG5000->( dbsetorder(1) )
FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA ) )

W_VLPROVENTO   := 0.00
W_VLDEDUCAO    := 0.00
W_VLSEGURADO   := 0.00
X_MATRIC_ATUAL := space(5)

while FPG5000->CODEMP   = X_CODEMP   .and. ;
      FPG5000->ANO      = X_ANO      .and. ;
      FPG5000->MES      = X_MES      .and. ;
      FPG5000->NUMFOLHA = X_NUMFOLHA .and. ;
      FPG5000->( ! eof() )

      if tes_status (FPG5000->MATRIC)

         if FPG5000->MATRIC != X_MATRIC_ATUAL
            X_MATRIC_ATUAL := FPG5000->MATRIC
            W_QTDFUNC  += 1
         end

         FPG1500->( dbsetorder(1) )
         FPG1500->( dbseek( X_CODEMP+FPG5000->CODEVENTO ) )

         if FPG1500->TIPO_EVENT = 'P'
            W_VLPROVENTO += FPG5000->VALOR
         end
         if FPG1500->MODO_CALC  = 'SFM'
            W_VLDEDUCAO  += FPG5000->VALOR
         end
         if FPG1500->MODO_CALC  = 'INS'
            W_VLSEGURADO += FPG5000->VALOR
         end

      end

      FPG5000->( dbskip() )

end

return WRET


//------------------------------------------------------------------
function R3000_empregador()
//------------------------------------------------------------------
local WRET := .T.

      W_VLEMPREGADOR := 0.00
      W_VLEMPREGADOR := GER0400->VALOR + GER0500->VALOR

return WRET

//------------------------------------------------------------------
function R3000_emp()
//------------------------------------------------------------------
local WRET := .T.

      W_VL        := 0.00
      W_VLEMPRESA := 0.00

      W_VL        := ( W_VLPROVENTO * FPG4000->PERC_CONT ) / 100
      W_VLEMPRESA := W_VL + ( 0.15 * W_VLEMPREGADOR )

return WRET

//------------------------------------------------------------------
function R3000_terceiro()
//------------------------------------------------------------------
local WRET := .T.

      W_VLTERCEIRO := 0.00
      W_VLTERCEIRO := ( W_VLPROVENTO * FPG4000->PERC_TERC ) / 100

return WRET

//------------------------------------------------------------------
function R3000_imprime ()
//------------------------------------------------------------------
local WRET := .T.

W_VLTOT_8  :=  0.00
W_VLTOT_25 :=  0.00

W_VLTOT_8  :=  W_VLPROVENTO + W_VLEMPREGADOR
W_VLTOT_25 := (W_VLSEGURADO + W_VLEMPRESA + W_VLTERCEIRO) - W_VLDEDUCAO

@ prow()  , 1  say ' '

if empty (FPG0100->CEI)
   @ prow()+3, 25 say FPG0100->CGC                      picture "@R 99.999.999/9999-99"
   @ prow()  , 73 say '1'
   @ prow()  ,100 say FPG0100->CGC                      picture "@R 99.999.999/9999-99"
else
   @ prow()+3, 25 say FPG0100->CEI
   @ prow()  , 73 say '2'
   @ prow()  ,100 say FPG0100->CEI
end

@ prow()+2, 21 say CHR(15)+FPG0100->RAZAO+CHR(18)
@ prow()  , 72 say FPG4000->FPAS
@ prow()+1, 12 say CHR(15)+FPG0100->ENDERECO+CHR(18)
@ prow()+1, 42 say substr(X_MES,1,1)  + '  ' +  substr(X_MES,2,1) + '  ' + ;
                   substr(X_ANO,1,1)  + '  ' +  substr(X_ANO,2,1)
@ prow()+1, 12 say CHR(15)+FPG0100->BAIRRO+CHR(18)
@ prow()  , 34 say CHR(15)+'CEP.:'+CHR(18)
@ prow()  , 41 say CHR(15)+transform(FPG0100->CEP,"99999-999") + CHR(18)
@ prow()+2, 12 say CHR(15)+FPG0100->ESTADO+CHR(18)

@ prow()  , 72 say     W_VLSEGURADO picture "@E 999,999,999.99"              //  SEGURADOS
@ prow()+2, 62 say     W_VLEMPRESA  picture "@E 999,999,999.99"               //  EMPRESA

@ prow()+1, 01 say CHR(15)+FPG0100->RAZAO+CHR(18)

if empty (FPG0100->CEI)
   @ prow()  , 74 say '0115'                      //  TERCEIROS
else
   @ prow()  , 74 say '0099'                      //  TERCEIROS
end

@ prow()  , 81 say W_VLTERCEIRO    picture "@E 999,999,999.99"  //  TERCEIROS


@ prow()+3, 01 say CHR(15)+FPG0100->ENDERECO+CHR(18)

@ prow()+2, 32 say CHR(15)+FPG0100->TELEFONE01+CHR(18)   // picture "@R 999-9999"

@ prow()+1, 62 say W_VLDEDUCAO picture "@E 999,999,999.99"                          // DEDUCOES FPAS

@ prow()+1, 01 say CHR(15)+transform(FPG0100->CEP,"99999-999") + CHR(18)
@ prow()  , 20 say 'RIO DE JANEIRO'
@ prow()  , 41 say 'RJ'

@ prow()+1, 62 say W_VLTOT_25  picture "@E 999,999,999.99"   //  TOTAL LIQUIDO

@ prow()+1, 24 say W_QTDFUNC

@ prow()+1, 71 say '0.00'                                //  ATUALIZACAO MONETARIA
@ prow()+1, 20 say W_VLPROVENTO   picture "@E 999,999,999.99"                       //  EMPREGADOS

@ prow()+1, 71 say '0.00'                                //  JUROS/MULTA
@ prow()+1, 20 say W_VLEMPREGADOR picture "@E 999,999,999.99"                       //  EMPREGADORES AUTONOMOS

@ prow()+1, 62 say W_VLTOT_25  picture "@E 999,999,999.99" //  TOTAL

@ prow()+09, 1  say ' '

return WRET

//------------------------------------------------------------------
function CONT_FUNC()     // CONTAGEM DOS EMPREGADOS
//------------------------------------------------------------------
local WRET := 0

FPG0200->( dbsetorder(1) )
FPG0200->( dbseek( X_CODEMP ) )

While FPG0200->( ! eof() ) .and. (X_CODEMP = FPG0200->CODEMP)
   if FPG0200->STATUS != "D"
      WRET := WRET + 1
   end
   FPG0200->(dbskip())
end

return WRET

