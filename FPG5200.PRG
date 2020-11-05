/*

   FPG5200.prg  - R.N de Contra Cheque

*/
#include "inkey.ch"
altd(1)

telanum('SCE5200','FPG5200')

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG0300")
abrir("FPG1400")
abrir("FPG1500")
abrir("FPG2300")
abrir("FPG3100")
abrir("FPG5000")

X_ANO       := space(2)
X_MES       := space(2)
X_MATRIC    := space(5)
X_NUMFOLHA  := space(2)
X_TPFOLHA   := space(2)
X_CODEVENT  := space(3)
X_CODCARGO  := space(3)
X_L_IMP     := 0
X_L_MAX     := 10
X_P_VLR_TOT := 0.00
X_D_VLR_TOT := 0.00

if par_5200()

   if Dh_imprime()
      Imprime_5200()
   end

end

dh_impoff()

dbcloseall()

return

//--------------------------------------------------------------------------
procedure Imprime_5200()
//--------------------------------------------------------------------------

FPG5000->( Dbsetorder(1) )

if X_MATRIC = '99999'
   FPG5000->( Dbseek( X_CODEMP + X_ANO + X_MES + X_NUMFOLHA  ) )
else
   FPG5000->( Dbseek( X_CODEMP + X_ANO + X_MES + X_NUMFOLHA + X_MATRIC ) )
end

if FPG5000->( ! found() )
   Mensbeep(" Funcionario sem Eventos ")
   return
end

While  FPG5000->CODEMP   = X_CODEMP       .and. ;
       FPG5000->ANO      = X_ANO          .and. ;
       FPG5000->MES      = X_MES          .and. ;
       FPG5000->NUMFOLHA = X_NUMFOLHA     .and. ;
       FPG5000->( ! eof() )

       Cab5200("1")

       X_MATRIC_ATUAL := FPG5000->MATRIC
       WNLIN := 0

       While FPG5000->CODEMP   = X_CODEMP       .and. ;
             FPG5000->ANO      = X_ANO          .and. ;
             FPG5000->MES      = X_MES          .and. ;
             FPG5000->NUMFOLHA = X_NUMFOLHA     .and. ;
             FPG5000->MATRIC   = X_MATRIC_ATUAL .and. ;
             FPG5000->(! eof() )

             WNLIN := WNLIN + 1

             Det5200()

             if WNLIN > 14
                @ prow()+12 , 1 say ' '
                cab5200("2")
                WNLIN := 0
             end

             FPG5000->( Dbskip() )

       enddo

       WREC := FPG5000->( recno() )

       Roda5200()

       FPG5000->( dbgoto( WREC ) )

       if X_MATRIC != '99999'
          exit
       end

enddo

return
   
//---------------------------------------------------------------------------
 function par_5200()
//---------------------------------------------------------------------------
local WRET := .T.


@ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄ  Periodo de Impressao  ÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,15 say '³                                            ³'
@ 12,15 say '³ Ano.......:                                ³'
@ 13,15 say '³ Mes.......:                                ³'
@ 14,15 say '³ Num.Folha.:                                ³'
@ 15,15 say '³ Tipo......:                                ³'
@ 16,15 say '³ Matricula.:                                ³'
@ 17,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,29 get X_ANO      picture "99"
@ 13,29 get X_MES      picture "99"
@ 14,29 get X_NUMFOLHA picture "99"
@ 15,29 get X_TPFOLHA  picture "@!" valid tes_TPFOLHA(15,29,02,1)
@ 16,29 get X_MATRIC   picture "99999" valid X_MATRIC = '99999' .or. tes_matric(16,29)
read

X_ANO      := zerofill(X_ANO)
X_MES      := zerofill(X_MES)
X_NUMFOLHA := zerofill(X_NUMFOLHA)
X_MATRIC   := zerofill(X_MATRIC)


 if X_MATRIC = '99999'
    @ 16,37 say 'Todos Funcionarios'
 endif

READ

if lastkey() = K_ESC
   WRET := .F.
end

return WRET


//-----------------------------------------------------------------------------
Function Cab5200(P_TIT)
//-----------------------------------------------------------------------------

   X_L_IMP     := 0
   X_L_MAX     := 10
   X_P_VLR_TOT := 0.00
   X_D_VLR_TOT := 0.00
   X_L_VLR_TOT := 0.00
 
   FPG0100->(dbsetorder(1))
   FPG0100->(dbseek(X_CODEMP))
   @ prow()+2, 01 say FPG0100->RAZAO

   @ prow(), 50 say '(p.'+P_TIT+')'+mesextenso( X_MES )+'/'+X_ANO

   FPG0200->(dbsetorder(1))
   FPG0200->(dbseek(X_CODEMP+FPG5000->MATRIC))
   @ prow()+3, 01 say FPG0200->NOME

   FPG0300->(dbsetorder(1))
   FPG0300->(dbseek(FPG0200->CODCARGO))
   @ prow()  , 40 say FPG0300->DESCRICAO

   @ prow()+3, 01 say '  '
 
return

//-----------------------------------------------------------------------------
Procedure Det5200()
//-----------------------------------------------------------------------------

  FPG1500->(dbsetorder(1))
  FPG1500->(dbseek(X_CODEMP+FPG5000->CODEVENTO))

  if FPG1500->TIPO_EVENT = 'P' .and. FPG5000->VALOR > 0
     @ prow()+1, 04 say FPG1500->DESCEVENT
     @ prow()  , 40 say FPG5000->VALOR picture "@E 9999,999.99"
     X_P_VLR_TOT := X_P_VLR_TOT + FPG5000->VALOR
     X_L_IMP ++
  else
     if FPG1500->TIPO_EVENT = 'D' .and. FPG5000->VALOR > 0
        @ prow()+1, 04 say FPG1500->DESCEVENT
        @ prow()  , 55 say FPG5000->VALOR picture "@E 9999,999.99"
        X_D_VLR_TOT := X_D_VLR_TOT + FPG5000->VALOR
        X_L_IMP ++
     end
  end

  if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      FPG5000->( dbgobottom())
   end

return

//-----------------------------------------------------------------------------
Procedure Roda5200()
//-----------------------------------------------------------------------------

   X_L_IMP     := (X_L_MAX - X_L_IMP) + 7
   X_L_VLR_TOT := X_P_VLR_TOT - X_D_VLR_TOT

   @ prow()+ X_L_IMP , 40 say X_P_VLR_TOT picture "@E 9999,999.99"
   @ prow()          , 55 say X_D_VLR_TOT picture "@E 9999,999.99"
   @ prow()+2        , 55 say X_L_VLR_TOT picture "@E 9999,999.99"

   @ prow()+2        , 04 say ' '

   FPG1400->( dbsetorder(2) )
   FPG1500->( dbsetorder(2) )
   FPG3100->( dbsetorder(1) )
   FPG5000->( dbsetorder(1) )

   //
   // Salario Base
   //
   @ prow()  , 00 say FPG0200->SALARIO picture "@E 999,999.99"

   //
   //  INSS
   //
   FPG1400->( dbseek( X_CODEMP + "INSS" ) )
   FPG3100->( dbseek( X_CODEMP + X_ANO + X_MES + X_NUMFOLHA + FPG0200->MATRIC + FPG1400->CODBASE ))
   @ prow()  , 11 say FPG3100->VALOR picture "@E 999,999.99"

   //
   //  base FGTS
   //
   FPG1400->( dbseek( X_CODEMP+"FGTS" ) )
   FPG3100->( dbseek( X_CODEMP + X_ANO + X_MES + X_NUMFOLHA + FPG0200->MATRIC + FPG1400->CODBASE ))
   @ prow()  , 24 say FPG3100->VALOR picture "@E 999,999.99"

   //
   //  valor FGTS
   //
   FPG1500->( dbseek( X_CODEMP+"FGT" ) )
   FPG5000->( dbseek( X_CODEMP+X_ANO+X_MES+X_NUMFOLHA+FPG0200->MATRIC+FPG1500->CODEVENTO ) )
   @ prow()  , 35 say FPG5000->VALOR picture "@E 999,999.99"

   //
   //  IRRF
   //

   FPG1400->( dbseek( X_CODEMP+"IRRF" ) )
   FPG3100->( dbseek( X_CODEMP + X_ANO + X_MES + X_NUMFOLHA + FPG0200->MATRIC + FPG1400->CODBASE ))
   @ prow()  , 50 say FPG3100->VALOR picture "@E 999,999.99"

   @ prow()+4 , 1 say ' '

 
return

