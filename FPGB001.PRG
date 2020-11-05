/*
   FPG   - Folha de Pagamento
   FPGB001.PRG - Cadastro de Vencimentos
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

setcolor(W_COREDIT)

X_MATRIC  := space(05)
X_NOME    := space(50)

X_CARGO   := space(30)
X_P_DES_1 := space(30)
X_P_DES_2 := space(30)
X_P_DES_3 := space(30)
X_P_DES_4 := space(30)
X_P_DES_5 := space(30)
X_P_VLR_1 := 0.00
X_P_VLR_2 := 0.00
X_P_VLR_3 := 0.00
X_P_VLR_4 := 0.00
X_P_VLR_5 := 0.00

X_D_DES_1 := space(30)
X_D_DES_2 := space(30)
X_D_DES_3 := space(30)
X_D_DES_4 := space(30)
X_D_DES_5 := space(30)
X_D_VLR_1 := 0.00
X_D_VLR_2 := 0.00
X_D_VLR_3 := 0.00
X_D_VLR_4 := 0.00
X_D_VLR_5 := 0.00

X_SL_BASE := 0.00
X_SL_INSS := 0.00
X_SL_FGTS := 0.00
X_VL_FGTS := 0.00
X_SL_IRRF := 0.00
X_FX_IRRF := 0.00

// --> Inicio

abrir("FPG0100")
abrir("FPG0200")
abrir("FPGB001")

While .T.

   tela_b001()
   zera_b001()

   if !(Empresa_ok())
      loop
   end

   @ 04,19 get X_MATRIC picture "@!"  valid tes_matric(04,19,40)
   read

   if lastkey()=K_ESC
      exit
   end

   FPGB001->( dbsetorder(1) )
   FPGB001->( dbseek(X_CODEMP+X_MATRIC) )

   if FPGB001->( found() )
      atribui_b001()
      show_b001()

      W_RESP := esp_alt()

      do case

      case W_RESP = "*"
         exit

      case W_RESP = "A"
         while .t.
            if get_b001()
               if Pergunta('Confirma Dados (S/N) ?')
                  grava_b001('A')
                  exit
               end
            else
               exit
            end
         end

      case W_RESP = "E"
         if Pergunta( 'Confirma Exclusao (S/N) ?')
            FPGB001->( dbdelete() )
         end
      end
   else
      while .t.
         get_b001()
         if lastkey() = K_ESC
            if Pergunta('Abandona Alteracoes (S/N) ?')
               exit
            end
         end
         if Pergunta('Confirma Dados (S/N) ?')
            grava_b001('I')
            exit
         end
      end
   end
end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_b001()

   Cab_emp_tela()

   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³  Matricula...:                                                           ³'
   @ 05,02 say '³  Cargo.......:                                                           ³'
   @ 06,02 say 'ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ P R O V E N T O S ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ'
   @ 07,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 08,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 09,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 10,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 11,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 12,02 say 'ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ D E S C O N T O S ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ'
   @ 13,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 14,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 15,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 16,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 17,02 say '³  Descricao...:                                 Valor :                   ³'
   @ 18,02 say 'ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ'
   @ 19,02 say '³  Sl. Base....:                               Vl.FGTS.:                   ³'
   @ 20,02 say '³  Sl. INSS....:                               Sl.IRRF.:                   ³'
   @ 21,02 say '³  Sl. FGTS....:                               Fx.IRRF.:                   ³'
   @ 22,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 23,02 say '³                                                                          ³'
   @ 24,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
                      Funcao GET_b001
-----------------------------------------------------------------------------
*/
function get_b001()
   local WRET := .T.

  @ 05,19 Get X_CARGO        picture "@!"

  @ 07,19 Get X_P_DES_1   picture "@!"
  @ 07,59 Get X_P_VLR_1   picture "@E 9999,999.99"
  @ 08,19 Get X_P_DES_2   picture "@!"
  @ 08,59 Get X_P_VLR_2   picture "@E 9999,999.99"
  @ 09,19 Get X_P_DES_3   picture "@!"
  @ 09,59 Get X_P_VLR_3   picture "@E 9999,999.99"
  @ 10,19 Get X_P_DES_4   picture "@!"
  @ 10,59 Get X_P_VLR_4   picture "@E 9999,999.99"
  @ 11,19 Get X_P_DES_5   picture "@!"
  @ 11,59 Get X_P_VLR_5   picture "@E 9999,999.99"

  @ 13,19 Get X_D_DES_1   picture "@!"
  @ 13,59 Get X_D_VLR_1   picture "@E 9999,999.99"
  @ 14,19 Get X_D_DES_2   picture "@!"
  @ 14,59 Get X_D_VLR_2   picture "@E 9999,999.99"
  @ 15,19 Get X_D_DES_3   picture "@!"
  @ 15,59 Get X_D_VLR_3   picture "@E 9999,999.99"
  @ 16,19 Get X_D_DES_4   picture "@!"
  @ 16,59 Get X_D_VLR_4   picture "@E 9999,999.99"
  @ 17,19 Get X_D_DES_5   picture "@!"
  @ 17,59 Get X_D_VLR_5   picture "@E 9999,999.99"

  @ 19,19 get X_SL_BASE   picture "@E 9999,999.99"
  @ 20,19 get X_SL_INSS   picture "@E 9999,999.99"
  @ 21,19 get X_SL_FGTS   picture "@E 9999,999.99"
  @ 19,59 get X_VL_FGTS   picture "@E 9999,999.99"
  @ 20,59 get X_SL_IRRF   picture "@E 9999,999.99"
  @ 21,59 get X_FX_IRRF   picture "@E 999.99"

  read

  if lastkey() = K_ESC
     WRET := .F.
  end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao SHOW_b001
-----------------------------------------------------------------------------
*/
procedure SHOW_b001()

   @ 04,19 say X_MATRIC       picture "@!"
   @ 05,19 Say X_CARGO        picture "@!"

   @ 07,19 Say X_P_DES_1   picture "@!"
   @ 07,59 Say X_P_VLR_1   picture "@E 9999,999.99"
   @ 08,19 Say X_P_DES_2   picture "@!"
   @ 08,59 Say X_P_VLR_2   picture "@E 9999,999.99"
   @ 09,19 Say X_P_DES_3   picture "@!"
   @ 09,59 Say X_P_VLR_3   picture "@E 9999,999.99"
   @ 10,19 Say X_P_DES_4   picture "@!"
   @ 10,59 Say X_P_VLR_4   picture "@E 9999,999.99"
   @ 11,19 Say X_P_DES_5   picture "@!"
   @ 11,59 Say X_P_VLR_5   picture "@E 9999,999.99"

   @ 13,19 Say X_D_DES_1   picture "@!"
   @ 13,59 Say X_D_VLR_1   picture "@E 9999,999.99"
   @ 14,19 Say X_D_DES_2   picture "@!"
   @ 14,59 Say X_D_VLR_2   picture "@E 9999,999.99"
   @ 15,19 Say X_D_DES_3   picture "@!"
   @ 15,59 Say X_D_VLR_3   picture "@E 9999,999.99"
   @ 16,19 Say X_D_DES_4   picture "@!"
   @ 16,59 Say X_D_VLR_4   picture "@E 9999,999.99"
   @ 17,19 Say X_D_DES_5   picture "@!"
   @ 17,59 Say X_D_VLR_5   picture "@E 9999,999.99"

   @ 19,19 say X_SL_BASE   picture "@E 9999,999.99"
   @ 20,19 say X_SL_INSS   picture "@E 9999,999.99"
   @ 21,19 say X_SL_FGTS   picture "@E 9999,999.99"
   @ 19,59 say X_VL_FGTS   picture "@E 9999,999.99"
   @ 20,59 say X_SL_IRRF   picture "@E 9999,999.99"
   @ 21,59 say X_FX_IRRF   picture "@E 999.99"

return

/*
-----------------------------------------------------------------------------
                      Funcao ZERA_b001
-----------------------------------------------------------------------------
*/
procedure zera_b001()

X_MATRIC  := space(05)

X_NOME    := space(50)

X_CARGO   := space(30)

X_P_DES_1 := space(30)
X_P_DES_2 := space(30)
X_P_DES_3 := space(30)
X_P_DES_4 := space(30)
X_P_DES_5 := space(30)
X_P_VLR_1 := 0.00
X_P_VLR_2 := 0.00
X_P_VLR_3 := 0.00
X_P_VLR_4 := 0.00
X_P_VLR_5 := 0.00

X_D_DES_1 := space(30)
X_D_DES_2 := space(30)
X_D_DES_3 := space(30)
X_D_DES_4 := space(30)
X_D_DES_5 := space(30)
X_D_VLR_1 := 0.00
X_D_VLR_2 := 0.00
X_D_VLR_3 := 0.00
X_D_VLR_4 := 0.00
X_D_VLR_5 := 0.00

X_SL_BASE := 0.00
X_SL_INSS := 0.00
X_SL_FGTS := 0.00
X_VL_FGTS := 0.00
X_SL_IRRF := 0.00
X_FX_IRRF := 0.00

return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI_b001
-----------------------------------------------------------------------------
*/
procedure atribui_b001()

   X_MATRIC     := FPGB001->MATRIC

   X_CARGO      := FPGB001->CARGO

   X_P_DES_1 := FPGB001->P_DES_1
   X_P_VLR_1 := FPGB001->P_VLR_1
   X_P_DES_2 := FPGB001->P_DES_2
   X_P_VLR_2 := FPGB001->P_VLR_2
   X_P_DES_3 := FPGB001->P_DES_3
   X_P_VLR_3 := FPGB001->P_VLR_3
   X_P_DES_4 := FPGB001->P_DES_4
   X_P_VLR_4 := FPGB001->P_VLR_4
   X_P_DES_5 := FPGB001->P_DES_5
   X_P_VLR_5 := FPGB001->P_VLR_5

   X_D_DES_1 := FPGB001->D_DES_1
   X_D_VLR_1 := FPGB001->D_VLR_1
   X_D_DES_2 := FPGB001->D_DES_2
   X_D_VLR_2 := FPGB001->D_VLR_2
   X_D_DES_3 := FPGB001->D_DES_3
   X_D_VLR_3 := FPGB001->D_VLR_3
   X_D_DES_4 := FPGB001->D_DES_4
   X_D_VLR_4 := FPGB001->D_VLR_4
   X_D_DES_5 := FPGB001->D_DES_5
   X_D_VLR_5 := FPGB001->D_VLR_5

   X_SL_BASE := FPGB001->SL_BASE
   X_SL_INSS := FPGB001->SL_INSS
   X_SL_FGTS := FPGB001->SL_FGTS
   X_VL_FGTS := FPGB001->VL_FGTS
   X_SL_IRRF := FPGB001->SL_IRRF
   X_FX_IRRF := FPGB001->FX_IRRF

return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_b001()
-----------------------------------------------------------------------------
*/
procedure GRAVA_b001( MODO )

   if MODO = "I"
      FPGB001->( dbappend() )
   else
      while FPGB001->( ! rlock() ); end
   end

   FPGB001->CODEMP  := X_CODEMP
   FPGB001->MATRIC  := X_MATRIC
   FPGB001->CARGO   := X_CARGO

   FPGB001->P_DES_1 := X_P_DES_1
   FPGB001->P_VLR_1 := X_P_VLR_1
   FPGB001->P_DES_2 := X_P_DES_2
   FPGB001->P_VLR_2 := X_P_VLR_2
   FPGB001->P_DES_3 := X_P_DES_3
   FPGB001->P_VLR_3 := X_P_VLR_3
   FPGB001->P_DES_4 := X_P_DES_4
   FPGB001->P_VLR_4 := X_P_VLR_4
   FPGB001->P_DES_5 := X_P_DES_5
   FPGB001->P_VLR_5 := X_P_VLR_5

   FPGB001->D_DES_1 := X_D_DES_1
   FPGB001->D_VLR_1 := X_D_VLR_1
   FPGB001->D_DES_2 := X_D_DES_2
   FPGB001->D_VLR_2 := X_D_VLR_2
   FPGB001->D_DES_3 := X_D_DES_3
   FPGB001->D_VLR_3 := X_D_VLR_3
   FPGB001->D_DES_4 := X_D_DES_4
   FPGB001->D_VLR_4 := X_D_VLR_4
   FPGB001->D_DES_5 := X_D_DES_5
   FPGB001->D_VLR_5 := X_D_VLR_5

   FPGB001->SL_BASE := X_SL_BASE
   FPGB001->SL_INSS := X_SL_INSS
   FPGB001->SL_FGTS := X_SL_FGTS
   FPGB001->VL_FGTS := X_VL_FGTS
   FPGB001->SL_IRRF := X_SL_IRRF
   FPGB001->FX_IRRF := X_FX_IRRF

return
