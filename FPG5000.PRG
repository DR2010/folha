/*

   FPG5000.prg  - Calculo da folha

*/
#include "inkey.ch"
altd(1)

telanum('SCE5000','FPG5000')

X_ANO    := '96'
X_MES    := '  '

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG0900")
abrir("FPG1300")
abrir("FPG1500")
abrir("FPG1600")
abrir("FPG1700")
abrir("FPG1800")
abrir("FPG2200")
abrir("FPG2300")
abrir("FPG2400")
abrir("FPG2500") // Valores basicos
abrir("FPG3100")
abrir("FPG5000")

empresa_ok()

private X_MATRIC    := SPACE(5),;
        X_NUMFOLHA  := SPACE(2),;
        X_CODEVENTO := SPACE(3),;
        X_TPFOLHA   := SPACE(2),;
        X_VALOR     := 0.00    ,;
        W_BASECALC  := 0.00

setcolor(W_COREDIT)
tela5000()

WSCR5000 := savescreen(,,,,)
while .t.
   X_MATRIC := SPACE(5)

   restscreen(,,,,WSCR5000 )
   @ 05,10 get X_ANO      picture "99" valid ! empty( X_ANO )
   @ 05,23 get X_MES      picture "99" valid ! empty( X_MES )
   @ 05,50 get X_NUMFOLHA picture "99" valid ! empty( X_NUMFOLHA )
   @ 05,67 get X_TPFOLHA  picture "@!" valid ! empty( X_TPFOLHA ) .or. tes_TPFOLHA(05,67,5)
   @ 07,17 get X_MATRIC   picture "@!" valid X_MATRIC = '99999' .or. tes_matric(08,17)
   read

   if lastkey()= K_ESC; exit; end

   X_ANO      := zerofill( X_ANO )
   X_MES      := zerofill( X_MES )
   X_MATRIC   := zerofill( X_MATRIC )
   X_NUMFOLHA := zerofill( X_NUMFOLHA )

   @ 05,10 say X_ANO
   @ 05,23 say X_MES
   @ 05,50 say X_NUMFOLHA
   @ 05,67 say X_TPFOLHA
   @ 07,17 say X_MATRIC

   FPG2400->( dbsetorder(1))
   FPG2400->( dbseek( X_CODEMP + X_ANO + X_MES + X_NUMFOLHA ) )
   if FPG2400->( ! found() )
      mensbeep("Folha nao cadastrada !")
      loop
   end

   if FPG2400->FLAG_USO = 'F'
      mensbeep("Folha fechada !")
      loop
   end

   if X_MATRIC = '99999'

      //
      // Posiciona ponteiro em funcionario
      //

      FPG0200->( dbsetorder(1) )
      FPG0200->( dbseek( X_CODEMP ) )

      while FPG0200->CODEMP = X_CODEMP .and. FPG0200->( ! eof() )
         if tes_status( FPG0200->MATRIC )
            calcula( FPG0200->MATRIC )
         end
         FPG0200->( dbskip() )
      end

   else
      if ! tes_status( X_MATRIC )
         mensbeep("Funcionario Nao esta Ativo !")
         loop
      end
      calcula( X_MATRIC )
   end

end

return

/*
-------------------------------------------------------------------------------
Procedimento .: tela5000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela5000()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 02,02 say 'ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·'
   @ 03,02 say 'º                                                                          º'
   @ 04,02 say 'º                                                                          º'
   @ 05,02 say 'º Ano .:       Mes .:         Numero da Folha .:     Tipo Folha :          º'
   @ 06,02 say 'º                                                                          º'
   @ 07,02 say 'º Matricula ..:       - ( Informe 99999 para todos os funcionarios )       º'
   @ 08,02 say 'º                                                                          º'
   @ 09,02 say 'º                                                                          º'
   @ 10,02 say 'º                                                                          º'
   @ 11,02 say 'º                                                                          º'
   @ 12,02 say 'º                                                                          º'
   @ 13,02 say 'º                                                                          º'
   @ 14,02 say 'º                                                                          º'
   @ 15,02 say 'º                                                                          º'
   @ 16,02 say 'º                                                                          º'
   @ 17,02 say 'º                                                                          º'
   @ 18,02 say 'º                                                                          º'
   @ 19,02 say 'º                                                                          º'
   @ 20,02 say 'º                                                                          º'
   @ 21,02 say 'º                                                                          º'
   @ 22,02 say 'º                                                                          º'
   @ 23,02 say 'ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½'
return

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
   private V_EVENTO := {}, V_QTDE := {}
   private V_RESEVE := {}, V_RESVAL := {}, V_NAOCALC := {}

   X_MATRIC := P_MATRICULA

   //
   // Posiciona ponteiro em funcionario
   //
   FPG0200->( dbsetorder(1) )
   FPG0200->( dbseek( X_CODEMP + X_MATRIC ) )

   //
   //  Zerar valores das bases
   //
   zerarbase()

   //
   //  Zerar valores calculados
   //
   zerarresu()

   //
   //  Calcular valores basicos
   //
   X_CRGHORMES := FPG0200->CRGHORMES

   W_SALARIO   := FPG0200->SALARIO
   W_VALORDIA  := FPG0200->SALARIO/30
   W_VALORHORA := FPG0200->SALARIO/X_CRGHORMES

   //
   //  Preenche vetor com eventos definidos para o funcionario
   //
   FPG1600->( dbsetorder(1) )
   FPG1600->( dbseek( X_CODEMP + X_MATRIC ) )
   while ( FPG1600->CODEMP + FPG1600->MATRIC = X_CODEMP + X_MATRIC )

      // Busca evento, para verificar em que folha roda...

      FPG1500->( dbsetorder(1) )
      FPG1500->( dbseek(  X_CODEMP + FPG1600->CODEVENTO ))

      X_ALLFOLHA := FPG1500->TPFOLHA  + '/'+ ;
                    FPG1500->TPFOLHA2 + '/'+ ;
                    FPG1500->TPFOLHA3 + '/'+ ;
                    FPG1500->TPFOLHA4 + '/'+ ;
                    FPG1500->TPFOLHA5 + '/'+ ;
                    FPG1500->TPFOLHA6

      if X_TPFOLHA $ X_ALLFOLHA
         if FPG1600->VALOR = -1
            aadd( V_NAOCALC, FPG1600->CODEVENTO )
         else
            aadd( V_EVENTO, FPG1600->CODEVENTO )
            aadd( V_QTDE,   FPG1600->VALOR     )
         end
      end

      FPG1600->( dbskip() )
   end

   //
   //  Preenche vetor com eventos definidos para empresa
   //
   FPG2200->( dbseek( X_CODEMP ) )
   while FPG2200->CODEMP = X_CODEMP
      // Busca evento, para verificar em que folha roda...

      FPG1500->( dbsetorder(1) )
      FPG1500->( dbseek(  X_CODEMP + FPG2200->CODEVENTO ))

      X_ALLFOLHA := FPG1500->TPFOLHA  + '/'+ ;
                    FPG1500->TPFOLHA2 + '/'+ ;
                    FPG1500->TPFOLHA3 + '/'+ ;
                    FPG1500->TPFOLHA4 + '/'+ ;
                    FPG1500->TPFOLHA5 + '/'+ ;
                    FPG1500->TPFOLHA6

      if X_TPFOLHA $ X_ALLFOLHA
         aadd( V_EVENTO, FPG2200->CODEVENTO )
         aadd( V_QTDE,   FPG2200->VALOR     )
      end

      FPG2200->( dbskip() )
   end

   //
   //  Calcula eventos
   //

   FPG1500->( dbsetorder(1) )

   for X := 1 to len( V_EVENTO )
      FPG1500->( dbseek( X_CODEMP + V_EVENTO[X] ) )
      if FPG1500->INTERNO = 'S'
         W_VALOR := calceveint( FPG1500->CODEVENTO, V_QTDE[X] )
      else
         W_VALOR := calceveusu( FPG1500->CODEVENTO, V_QTDE[X] )
      end
      if W_VALOR <> 0
         aadd( V_RESEVE, V_EVENTO[X])
         aadd( V_RESVAL, W_VALOR)
      end
   next

   //
   // Calcula eventos predefinidos obrigatorios - Folha NORMAL
   // 

   if X_TPFOLHA = 'NO'

      // Adiantamento

      FPG5000->( dbsetorder(3) )
      FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_MATRIC+'AD' ) )

      WVALOR := 0
      while FPG5000->CODEMP   +;
            FPG5000->ANO      +;
            FPG5000->MES      +;
            FPG5000->MATRIC   +;
            FPG5000->TPFOLHA  =;
                     X_CODEMP+X_ANO+X_MES+X_MATRIC+'AD' .and. FPG5000->(!eof())

         WVALOR := WVALOR + FPG5000->VALOR
         FPG5000->( dbskip() )
      end

      //
      //  Adiantamento
      //
      if WVALOR > 0
         FPG1500->( dbsetorder(2) )
         FPG1500->( dbseek( X_CODEMP + "ADD" ) )

         if FPG1500->( found() )
            aadd( V_RESEVE, FPG1500->CODEVENTO )
            aadd( V_RESVAL, WVALOR )
         end

      end

   end

   //
   // Calcula eventos predefinidos obrigatorios - Folha de DECIMO TERCEIRO
   // 

   if X_TPFOLHA = '13'

      // Busca Adiantamento 13

      FPG1500->( dbsetorder(2) )
      FPG1500->( dbseek( X_CODEMP + "A13" ) )

      FPG5000->( dbsetorder(4) )
      FPG5000->( dbseek( X_CODEMP+X_MATRIC+FPG1500->CODEVENTO ) )

      WVALOR := 0
      if FPG5000->( found() )
         WVALOR :=  FPG5000->VALOR
      end

      //
      //  Adiantamento
      //
      if WVALOR > 0
         FPG1500->( dbsetorder(2) )
         FPG1500->( dbseek( X_CODEMP + "D13" ) )

         if FPG1500->( found() )
            aadd( V_RESEVE, FPG1500->CODEVENTO )
            aadd( V_RESVAL, WVALOR )
         end

      end

   end

   //
   // Armazena resultados do vetor
   //

   for X:= 1 to len( V_RESEVE )

      F_CALCULA := .T.
      for Y := 1 to len( V_NAOCALC )
         if V_RESEVE[X]=V_NAOCALC[Y]
            F_CALCULA := .F.
         end
      next

      if F_CALCULA
         FPG5000->( dbsetorder(1) )
         FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC+V_RESEVE[X] ) )
         while FPG5000->( ! rlock() ); end
         if FPG5000->( found() )
            FPG5000->VALOR     := V_RESVAL[X]
         else
            FPG5000->( dbappend() )
            FPG5000->CODEMP    := X_CODEMP
            FPG5000->ANO       := X_ANO
            FPG5000->MES       := X_MES
            FPG5000->TPFOLHA   := X_TPFOLHA
            FPG5000->NUMFOLHA  := X_NUMFOLHA
            FPG5000->MATRIC    := X_MATRIC
            FPG5000->CODEVENTO := V_RESEVE[X]
            FPG5000->VALOR     := V_RESVAL[X]
         end
         FPG5000->( dbunlock())
      end
   next

return

/*
----------------------------------------------------------------------------

   CALCEVEINT - Calcula evento definido com calculo interno

----------------------------------------------------------------------------
*/
function calceveint( P_CODEVENTO, P_QUANTIDADE )
local WRET := 0
//  Eventos predefinidos
//  A13 - Adiantamento 13
//  IRF - Imposto de Renda
//  INS - INSS
//  VLT - Vale Transporte
//
//  Eventos automaticos
//  ADT - Adiantamento provento
//  ADD - Adiantamento desconto
//  D13 - Desconto 13
//
//

FPG1500->( dbsetorder(1) )
FPG1500->( dbseek( X_CODEMP + P_CODEVENTO ) )

do case
   case FPG1500->MODO_CALC = 'A13'  // Adiantamento de 13

      // Verifica data de admissao do funcionario
      WRET := DIF := 0
      if year( FPG0200->DT_ADM ) = ( 1900 + val( X_ANO ) )
         DIF := 12 - MONTH( FPG0200->DT_ADM )
         if day( FPG0200->DT_ADM ) >= 17
            DIF := DIF - 1
         end
         if DIF < 0
            DIF = 0
         end
         WRET := (DIF * FPG0200->SALARIO) / 12
         WRET := WRET * ( P_QUANTIDADE / 100 )
      else
         WRET := FPG0200->SALARIO
         WRET := WRET * ( P_QUANTIDADE / 100 )
      end

   case FPG1500->MODO_CALC = 'IRF'  // IRRF

      // Valor isencao IRRF
      FPG2500->( dbgotop() )

      // Valor da base de IRRF
      FPG3100->( dbsetorder(1) )
      FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC+FPG1500->CODBASE ) )
      FPG1300->( dbsetorder(1) )
      FPG1300->( dbgotop() )

      // Verifica o limite
      if FPG3100->VALOR >= FPG2500->LIMIIRRF
         while FPG1300->( ! eof() )
            WRET := FPG2500->LIMIIRRF * ( FPG1300->PERCENTUAL/100 )
            FPG1300->( dbskip() )
         end
      else
         // Verifica em que faixa se encontra

         while FPG1300->( ! eof() )
            if FPG3100->VALOR >= FPG1300->INIC_FAIXA .and.;
               FPG3100->VALOR <  FPG1300->FIM_FAIXA
               WRET := ( FPG1300->PERCENTUAL/100 ) * FPG3100->VALOR
               exit
            end
            FPG1300->( dbskip() )
         end
      end

   case FPG1500->MODO_CALC = 'INS'  // INSS

      // Valor isencao INSS
      FPG2500->( dbgotop() )

      // Valor da base de INSS

      FPG3100->( dbsetorder(1) )
      FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC+FPG1500->CODBASE ) )
      FPG1300->( dbsetorder(1) )
      FPG1300->( dbgotop() )

      // Verifica o limite
      if FPG3100->VALOR >= FPG2500->LIMIINSS
         while FPG1300->( ! eof() )
            WRET := FPG2500->LIMIINSS * ( FPG1300->PERCENTUAL/100 )
            FPG1300->( dbskip() )
         end
      else
         // Verifica em que faixa se encontra

         while FPG1300->( ! eof() )
            if FPG3100->VALOR >= FPG1300->INIC_FAIXA .and.;
               FPG3100->VALOR <  FPG1300->FIM_FAIXA
               WRET := ( FPG1300->PERCENTUAL/100 ) * FPG3100->VALOR
               exit
            end
            FPG1300->( dbskip() )
         end
      end


   case FPG1500->MODO_CALC = 'VLT'  // VALE TRANSPORTE

      FPG3100->( dbsetorder(1) )
      FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC+FPG1500->CODBASE ) )

      WRET := ( W_VALORDIA * P_QUANTIDADE ) * 0.06

   case FPG1500->MODO_CALC = 'PNS'  // PENSAO
endcase

return WRET


/*
----------------------------------------------------------------------------

            CALCEVEUSU - Calcula evento definido pelo usuario

----------------------------------------------------------------------------
*/
function calceveusu( P_CODEVENTO, P_VALOR )

   FPG1500->( dbsetorder(1) )
   FPG1500->( dbseek( X_CODEMP + P_CODEVENTO ) )
   if FPG1500->( found() )

      do case
         case FPG1500->CODBASE = '999' // Salario Atual
            W_BASECALC  := FPG0200->SALARIO

         case FPG1500->CODBASE = '998' // Salario Anterior
            W_BASECALC := FPG0200->SALANT

         case FPG1500->CODBASE = '997' // Salario Minimo
            FPG0900->( dbsetorder(1) )
            FPG0900->( dbseek( X_ANO + X_MES ) )
            W_BASECALC := FPG0900->VL_SALMIN

         otherwise
            FPG3100->( dbsetorder(1) )
            FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC+FPG1500->CODBASE ) )
            W_BASECALC := FPG3100->VALOR

      endcase

      W_VALORDIA  := W_BASECALC/30
      W_VALORHORA := W_BASECALC/X_CRGHORMES

      do case
         case FPG1500->CLASSE = 'V'
            WRETVAL := P_VALOR
         case FPG1500->CLASSE = 'P'
            WRETVAL := ( P_VALOR * W_BASECALC )/100
         case FPG1500->CLASSE = 'D'
            WRETVAL := P_VALOR * W_VALORDIA * ( (FPG1500->FATOR/100) )
         case FPG1500->CLASSE = 'H'
            WRETVAL := P_VALOR * W_VALORHORA * ( (FPG1500->FATOR/100) )
      endcase
   end

   atualbase( P_CODEVENTO, WRETVAL )

return WRETVAL


/*
----------------------------------------------------------------------------

   ATUALBASE -> Atualiza bases de calculo

----------------------------------------------------------------------------
*/
procedure ATUALBASE( P1_CODEVENTO, P1_VALOR)

   FPG1800->( dbsetorder(2) ) // CODEVENTO + CODBASE
   FPG1800->( dbseek( X_CODEMP + P1_CODEVENTO ))

   while FPG1800->CODEMP + FPG1800->CODEVENTO = X_CODEMP + P1_CODEVENTO;
                     .and. FPG1800->( ! eof() )

      if FPG1800->OPERACAO = '+'
         P1_VALOR := P1_VALOR
      else
         P1_VALOR := -P1_VALOR
      end

      FPG3100->( dbsetorder(1) )
      FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC+FPG1800->CODBASE ) )
      while FPG3100->( ! rlock() ); end
      if FPG3100->( found() )
         FPG3100->VALOR := FPG3100->VALOR + P1_VALOR
      else
         FPG3100->( dbappend() )
         FPG3100->CODEMP    := X_CODEMP
         FPG3100->ANO       := X_ANO
         FPG3100->MES       := X_MES
         FPG3100->NUMFOLHA  := X_NUMFOLHA
         FPG3100->MATRIC    := X_MATRIC
         FPG3100->CODBASE   := FPG1800->CODBASE
         FPG3100->VALOR     := P1_VALOR
      end
      FPG3100->( dbunlock())
      FPG1800->( dbskip() )
   end

return

/*
----------------------------------------------------------------------------

   zerarbase ->

----------------------------------------------------------------------------
*/
procedure ZERARBASE()

   FPG3100->( dbsetorder(1) )
   FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC ) )

   while FPG3100->CODEMP   = X_CODEMP   .and.;
         FPG3100->ANO      = X_ANO      .and.;
         FPG3100->MES      = X_MES      .and.;
         FPG3100->NUMFOLHA = X_NUMFOLHA .and.;
         FPG3100->MATRIC   = X_MATRIC   .and.;
         FPG3100->( ! eof() )

         while FPG3100->( ! rlock() ); end
         FPG3100->( dbdelete() )
         FPG3100->( dbunlock())
         FPG3100->( dbskip() )
   end

return

/*
----------------------------------------------------------------------------

   zerarresu ->

----------------------------------------------------------------------------
*/

procedure  zerarresu()

   FPG5000->( dbsetorder(1) )
   FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC ) )
   while FPG5000->CODEMP+FPG5000->ANO+FPG5000->MES+FPG5000->NUMFOLHA+FPG5000->MATRIC =;
                  X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC
      while FPG5000->( ! rlock() ); end
      FPG5000->( dbdelete() )
      FPG5000->( dbunlock() )
      FPG5000->( dbskip() )
   end

return

/*
-----------------------------------------------------------------------------
                      Funcao TES_TPFOLHA
-----------------------------------------------------------------------------
*/
function tes_TPFOLHA( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len( FPG2300->DESCRICAO ), TAM )

   X_TPFOLHA := zerofill(X_TPFOLHA)

   FPG2300->( dbsetorder(1) )
   FPG2300->( dbseek( X_CODEMP+X_TPFOLHA ) )

   if FPG2300->( ! found() ) .or. X_TPFOLHA = "00"
      m_tabelas("X_TPFOLHA")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL      say  left(FPG2300->DESCRICAO, TAM )
   else
      if LIN # NIL
         @ LIN     , COL         say        X_TPFOLHA
         @ LIN     , COL     + 4 say '- ' + left(FPG2300->DESCRICAO, TAM )
      else
         @ 16,26 say X_TPFOLHA
         @ 16,28 say left(FPG2300->DESCRICAO, TAM )
      end
   end

return WRET


