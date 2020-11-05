/*
               C:\SISTEMA\FOLHA\CALCULO.PRG
*/

/*

FPG0200 - Funcionario
FPG1500 - Tipo de Evento
FPG1600 - Incidencia Funcionario
FPG2200 - Incidencia Empresa
FPG3100 - Temporario que armazena os valores das bases de calculo
FPG5000 - Resultados do funcionario

*/

/*

   Faz o calculo de um funcionario

*/

function calcula( P_MATRICULA )
   private V_EVENTO := V_QTDE := {}

   abrir("FPG0200")
   abrir("FPG1500")
   abrir("FPG1600")
   abrir("FPG2200")
   abrir("FPG3100")
   // abrir("FPG5000")

   //
   // Posiciona ponteiro em funcionario
   //
   FPG0200->( dbsetorder(1) )
   FPG0200->( dbseek( X_CODEMP + P_MATRICULA ) )

   //
   //  Preenche vetor com eventos definidos para o funcionario
   //
   FPG1600->( dbseek( X_CODEMP+P_MATRICULA ) )
   while ( FPG1600->CODEMP + FPG1600->MATRICULA = X_CODEMP + X_MATRICULA )
      aadd( V_EVENTO, FPG01600->CODEVENTO )
      aadd( V_QTDE,   FPG01600->VALOR     )

      FPG1600->( dbskip() )
   end

   //
   //  Preenche vetor com eventos definidos para empresa
   //
   FPG0220->( dbseek( X_CODEMP ) )
   while FPG0220->CODEMP = X_CODEMP
      aadd( V_EVENTO, FPG0220->CODEVENTO )

      FPG0220->( dbskip() )
   end

   for X := 1 to len( V_EVENTO )
      FPG1500->( dbseek( V_EVENTO[X] ) )
      if FPG1500->CLASSE = 'C'
         W_VALOR := calceveint( FPG1500->CODEVENTO, V_VALOR[X] )
      else
         W_VALOR := calceveusu( FPG1500->CODEVENTO, V_VALOR[X] )
      end
      if W_VALOR <> 0
         aadd( V_RESEVE, V_EVENTO[X])
         aadd( V_RESVAL, V_VALOR[X])
      end
   next
   cls
   for X:= 1 to len( V_RESEVE )
      ? V_RESEVE[X]
      ?? '->'
      ?? V_RESVAL[X]
   next
   inkey(0)
return

/*

   CALCEVEINT - Calcula evento definido com calculo interno

*/
function calceveint( P_CODEVENTO, P_QUANTIDADE )

FPG1500->( dbsetorder(1) )
FPG1500->( dbseek( P_CODEVENTO ) )

do case
   case FPG1500->MODO_CALC = 'INS'  // INSS
   case FPG1500->MODO_CALC = 'IRF'  // IRRF
   case FPG1500->MODO_CALC = 'PNS'  // PENSAO
endcase

return WRET


/*

   CALCEVEUSU - Calcula evento definido pelo usuario

*/
function calceveusu( P_CODEVENTO, P_VALOR )

   FPG1500->( dbsetorder(1) )
   FPG1500->( dbseek( P_CODEVENTO ) )
   if FPG1500->( found() )

      do case
         case FPG1500->CODBASE = '999' // Salario Atual
            W_BASECALC := FPG0100->SALARIO
         case FPG1500->CODBASE = '998' // Salario Anterior
            W_BASECALC := FPG0100->SALANT
         case FPG1500->CODBASE = '997' // Salario Minimo
            // W_BASECALC := FPG0100->SALANT
         otherwise
            FPG3100->( dbsetorder(1) )
            FPG3100->( dbseek( P_MATRICULA+FPG1500->CODBASE ) )
            W_BASECALC := FPG3100->VALOR

      endcase

      do case
         case FPG1500->CLASSE = 'V'
            WRETVAL := P_VALOR
         case FPG1500->CLASSE = 'P'
            WRETVAL := P_VALOR * W_BASECALC
         case FPG1500->CLASSE = 'D'
            WRETVAL := P_VALOR * W_VALORDIA * ( (FPG1500->FATOR/100) )
         case FPG1500->CLASSE = 'H'
            WRETVAL := P_VALOR * W_VALORHORA * ( (FPG1500->FATOR/100) )
      endcase
   end

   atualbase( P_CODEVENTO, WRETVAL )

return WRETVAL


/*

   ATUALBASE -> Atualiza bases de calculo

*/
procedure ATUALBASE( P1_CODEVENTO, P1_VALOR)

   FPG1800->( dbsetorder(2) ) // CODEVENTO + CODBASE
   FPG1800->( dbseek( P1_CODEVENTO ))

   while FPG1800->CODEVENTO = P1_CODEVENTO .and. FPG1800->( ! eof() )
      if FPG1800->OPERACAO = '+'
         P1_VALOR := P1_VALOR
      else
         P1_VALOR := -P1_VALOR
      end

      FPG3100->( dbsetorder(1) )
      FPG3100->( dbseek( X_FUNCIONARIO+P1_CODEVENTO ) )
      if FPG3100->( found() )
         FPG3100->VALOR := FPG3100->VALOR + P1_VALOR
      else
         FPG3100->( dbappend() )
         FPG3100->MATRICULA := X_MATRICULA
         FPG3100->CODEVENTO := P1_CODEVENTO
         FPG3100->VALOR     := P1_VALOR
      end

      FPG1800->( dbskip() )
   end

return


