/*

   FPG5100.prg  - Consulta Folha por Funcionario

*/
#include "inkey.ch"
altd(1)

telanum('SCE5100','FPG5100')

abrir("FPG0200")
abrir("FPG1400")
abrir("FPG1500")
abrir("FPG5000")
abrir("FPG3100")

X_MATRIC    := space(05)
X_PROXIMO   := space(05)
X_ANOFOLHA  := '96'
X_MESFOLHA  := '01'
X_NUMFOLHA  := '01'

cab_5100()
tela_5100()

While .T.

   clearKeyboard()

   if !empty(X_PROXIMO)
      If pergunta ("Consulta Proximo Funcionario ? (S/N)")
         X_MATRIC := X_PROXIMO
         @ 03,18 get X_MATRIC picture "@!" valid tes_matric(03,18)
         keyboard chr(13)
         read
      else
         X_PROXIMO := space(5)
         loop
      end
   else
      @ 03,18 get X_MATRIC picture "@!" valid tes_matric(03,18)
      read
   end

   if lastkey()=K_ESC; exit; end

   tela_5100()

   eventos_5100()

   bases_5100()

end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                      Funcao EVENTOS_5100
-----------------------------------------------------------------------------
*/
procedure EVENTOS_5100()
local LIN := 6
X_PROXIMO := space(5)

FPG5000->( dbsetorder(1) )
FPG5000->( dbseek(X_ANOFOLHA+X_MESFOLHA+X_NUMFOLHA+X_CODEMP+X_MATRIC) )

if FPG5000->( !found() )
   Mensbeep(" Funcionario Sem Eventos ")
end

while (FPG5000->ANOFOLHA = X_ANOFOLHA .and. ;
       FPG5000->MESFOLHA = X_MESFOLHA .and. ;
       FPG5000->NUMFOLHA = X_NUMFOLHA .and. ;
       FPG5000->CODEMP   = X_CODEMP   .and. ;
       FPG5000->MATRIC   = X_MATRIC   .and. ;
       FPG5000->(! eof())                   )

       X_CODEVENTO := FPG5000->CODEVENTO

       @ LIN,06 say X_CODEVENTO
       tes_codevento(LIN,6)
       @ LIN,45 say FPG5000->VALOR

       FPG5000->( dbskip() )
       LIN := LIN + 1
enddo

if FPG5000->(!found())           .and. ;
  FPG5000->ANOFOLHA = X_ANOFOLHA .and. ;
  FPG5000->MESFOLHA = X_MESFOLHA .and. ;
  FPG5000->NUMFOLHA = X_NUMFOLHA .and. ;
  FPG5000->CODEMP   = X_CODEMP
  X_PROXIMO := FPG5000->MATRIC
end

return

/*
-----------------------------------------------------------------------------
                      Funcao BASES_5100
-----------------------------------------------------------------------------
*/
procedure BASES_5100()
local LIN := 18

FPG3100->( dbsetorder(1) )
FPG3100->( dbseek(X_ANOFOLHA+X_MESFOLHA+X_NUMFOLHA+X_CODEMP+X_MATRIC) )

if FPG3100->( !found() )
   Mensbeep(" Funcionario Sem Base ")
end

while (FPG3100->ANOFOLHA = X_ANOFOLHA .and. ;
       FPG3100->MESFOLHA = X_MESFOLHA .and. ;
       FPG3100->NUMFOLHA = X_NUMFOLHA .and. ;
       FPG3100->CODEMP   = X_CODEMP   .and. ;
       FPG3100->MATRIC   = X_MATRIC   .and. ;
       FPG3100->(! eof())                   )

       X_CODBASE   := FPG3100->CODBASE

       @ LIN,06 say X_CODBASE
       tes_codbase  (LIN,6)
       @ LIN,45 say FPG3100->VALOR

       FPG3100->( dbskip() )
       LIN := LIN + 1
enddo

return

//=============================================================================//
procedure cab_5100()
//=============================================================================//

   setcolor( W_COREDIT )
   @ 02,02 say 'ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ'
   @ 03,02 say 'ณ Matricula...:                                                          ณ'
   @ 04,02 say 'ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต'

return

//=============================================================================//
procedure tela_5100()
//=============================================================================//

   @ 05,02 say 'ณ Evento  Descricao                                   Valor              ณ'
   @ 06,02 say 'ณ                                                                        ณ'
   @ 07,02 say 'ณ                                                                        ณ'
   @ 08,02 say 'ณ                                                                        ณ'
   @ 09,02 say 'ณ                                                                        ณ'
   @ 10,02 say 'ณ                                                                        ณ'
   @ 11,02 say 'ณ                                                                        ณ'
   @ 12,02 say 'ณ                                                                        ณ'
   @ 13,02 say 'ณ                                                                        ณ'
   @ 14,02 say 'ณ                                                                        ณ'
   @ 15,02 say 'ณ                                                                        ณ'
   @ 16,02 say 'ณ                                                                        ณ'
   @ 17,02 say 'ณ  Base   Descricao                                   Valor              ณ'
   @ 18,02 say 'ณ                                                                        ณ'
   @ 19,02 say 'ณ                                                                        ณ'
   @ 20,02 say 'ณ                                                                        ณ'
   @ 21,02 say 'ณ                                                                        ณ'
   @ 22,02 say 'ณ                                                                        ณ'
   @ 23,02 say 'ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ'

return

