/*

   FPG5500.prg  - Resultados

*/
#include "inkey.ch"
altd(1)

telanum('SCE5500','FPG5500')

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG2200")
abrir("FPG1400")
abrir("FPG1500")
abrir("FPG1600")
abrir("FPG1700")
abrir("FPG1800")
abrir("FPG3100")
abrir("FPG5000")

empresa_ok()

private X_MATRIC    := SPACE(5),;
        X_NUMFOLHA  := SPACE(2),;
        X_CODEVENTO := SPACE(3),;
        X_VALOR     := 0.00

setcolor(W_COREDIT)
tela5500()

X_ANO    := '96'
X_MES    := '  '

@ 05,10 get X_ANO      picture "99" valid ! empty( X_ANO )
@ 05,23 get X_MES      picture "99" valid ! empty( X_MES )
@ 05,50 get X_NUMFOLHA picture "99" valid ! empty( X_NUMFOLHA )
read

if lastkey()=K_ESC
   return
end

WSCR5500 := savescreen(,,,,)
while .t.
   restscreen(,,,,WSCR5500 )

   X_MATRIC := SPACE(5)

   @ 07,17 get X_MATRIC   picture "@!" valid tes_matric(7,17)
   read

   if lastkey()= K_ESC; exit; end

   if !tes_status (X_MATRIC)
      mensbeep("Funcionario Nao esta Ativo !")
      loop
   end

   X_ANO      := zerofill( X_ANO )
   X_MES      := zerofill( X_MES )
   X_MATRIC   := zerofill( X_MATRIC )
   X_NUMFOLHA := zerofill( X_NUMFOLHA )

   @ 05,10 say X_ANO
   @ 05,23 say X_MES
   @ 05,50 say X_NUMFOLHA
   @ 07,17 say X_MATRIC

   FPG0200->( dbseek( X_CODEMP + X_MATRIC ))

   while X_CODEMP+X_MATRIC = FPG0200->CODEMP+FPG0200->MATRIC  .and. ;
                             FPG0200->( ! eof() )

      @ 07,17 say FPG0200->MATRIC
      @ 07,23 say FPG0200->NOME

      resultado( FPG0200->MATRIC )
      FPG0200->( dbskip() )
      if lastkey()=K_ESC
         exit
      end
   end

end
return

/*
-------------------------------------------------------------------------------
Procedimento .: tela5500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela5500()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 02,02 say 'ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·'
   @ 03,02 say 'º                                                                           º'
   @ 04,02 say 'º                                                                           º'
   @ 05,02 say 'º Ano .:       Mes .:         Numero da Folha .:                            º'
   @ 06,02 say 'º                                                                           º'
   @ 07,02 say 'º Matricula ..:                                                             º'
   @ 08,02 say 'º                                                                           º'
   @ 09,02 say 'º ÚÄÄÄÄÄÄÄÄÄÄÄ Bases ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ÚÄÄÄÄÄÄÄÄÄÄÄ Eventos ÄÄÄÄÄÄÄÄÄÄÄÄÄ¿   º'
   @ 10,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 11,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 12,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 13,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 14,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 15,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 16,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 17,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 18,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 19,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 20,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 21,02 say 'º ³                                 ³ ³                                 ³   º'
   @ 22,02 say 'º ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ÀÄÄÄÄÄÄÄÄÄÄÄ Liquido :           ÄÙ   º'
   @ 23,02 say 'ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½'
return


function resultado( P_MATRICULA )

   private V_CODBASE := {},;
           V_VALBASE := {},;
           V_CODEVEN := {},;
           V_VALEVEN := {}

   X_MATRIC := P_MATRICULA

   FPG3100->( dbsetorder(1) )
   FPG3100->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC ) )

   while FPG3100->CODEMP   = X_CODEMP   .and.;
         FPG3100->ANO      = X_ANO      .and.;
         FPG3100->MES      = X_MES      .and.;
         FPG3100->NUMFOLHA = X_NUMFOLHA .and.;
         FPG3100->MATRIC   = X_MATRIC   .and.;
         FPG3100->( ! eof() )

         FPG1400->( dbsetorder(1) )
         FPG1400->( dbseek( X_CODEMP + FPG3100->CODBASE ) )

         aadd( V_CODBASE, FPG3100->CODBASE + ' '+ ;
                    left(FPG1400->DESCRICAO,15) +' '+;
               transform(FPG3100->VALOR, '999,999.99') )

         FPG3100->( dbskip() )
   end

   W_PROVENTO := 0
   W_DESCONTO := 0
   W_LIQUIDO  := 0

   FPG5000->( dbsetorder(1) )
   FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+X_MATRIC ) )

   while FPG5000->CODEMP   = X_CODEMP   .and.;
         FPG5000->ANO      = X_ANO      .and.;
         FPG5000->MES      = X_MES      .and.;
         FPG5000->NUMFOLHA = X_NUMFOLHA .and.;
         FPG5000->MATRIC   = X_MATRIC   .and.;
         FPG5000->( ! eof() )

         FPG1500->( dbsetorder(1) )
         FPG1500->( dbseek( X_CODEMP + FPG5000->CODEVENTO ) )

         aadd( V_CODEVEN, FPG5000->CODEVENTO+' '+;
                           left(FPG1500->DESCEVENT,15) +' '+;
                           transform(FPG5000->VALOR , '999,999.99') )

         if FPG1500->TIPO_EVENT = "P"
            W_PROVENTO += FPG5000->VALOR
         else
            if FPG1500->TIPO_EVENT = "D"
               W_DESCONTO += FPG5000->VALOR
            end
         end

         FPG5000->( dbskip() )
   end

   W_LIQUIDO := W_PROVENTO - W_DESCONTO

   @ 22,63 say W_LIQUIDO picture "@E 999,999.99"

   if len( V_CODBASE ) > 0
      keyboard chr(K_ENTER)
      ACHOICE( 10,05,21,36,V_CODBASE )
   end

   if len( V_CODEVEN ) > 0
      ACHOICE( 10,41,20,71,V_CODEVEN )
   end

return




