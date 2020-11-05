/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>    AD       Consultoria  <<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  FPG0000   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | Sistema:								      |
  |---------------------------------------------------------------------------|
  | Descricao..: Modulo principal de controle dos Menus.		      |
  |---------------------------------------------------------------------------|
  | Cliente....: Layout                     | Ultima Alteracao                |
  | Analista...:			    | Autor :			      |
  | Programador:			    | Dt/Hr :			      |
  | Inicio.....:			    | Motivo:			      |
  |					    |				      |
  +---------------------------------------------------------------------------+
*/
local getlist:={}
#include "inkey.ch"
#include "sic.ch"

altd(1)
public  C_USUARIO := space(8), C_ACESSO := "C", C_MODULO := "C",;
        X_CODEMP  := space(3), X_RAZAO  := space(40)
public  W_PDCOR, W_CORGET, W_CORPERG, W_CORWIND, W_CORWG, PADRAO
public  P_LIN, P_COL, SCR_BASICO,X_DIRCONT := space(05)
public  T_BIT := .F., T_LARG := .F. , PATH_FOLHA, PATH_CONT, PATH_GER

// variaveis contabilidade
Public Sistema,Cliente,SalvaTela,SalvaCor,Opc0,Opc1,Opc2,Opc3,Opc4,Opc5

private W_MENU000:={}, W_OPCAO000
private W_MENU001:={} ,;
        W_MENU002:={} ,;
        W_MENU003:={} ,;
        W_MENU004:={} ,;
        W_MENU005:={} ,;
        W_ABAND:=.F.  ,;
        W_MSG:={}     ,;
        W_ACESSO


C_MONITOR := getenv("ADMONO")

if asc( C_MONITOR ) = 0
   W_PDCOR     := "W/B   , B/W    ,B, N, N     "       // Cor padrao
   W_CORSOMBRA := "N/BG  , B/W    ,B, N, N     "       // Cor da sombra
   W_CORWIND   := "W/B   , W/R    ,B, N, W/GR  "       // Cor janela sem get's
   W_CORGET    := "N/BG  , N/W    ,B, N, N/BG  "       // Cor gets com fundo basico
   W_COREDIT   := "N/BG  , BG/RB+ ,B, N, N/BG  "       // Cor gets com fundo basico
   W_CORWG     := "RB/W  , N/G    ,B, N, RB/W  "       // Cor window com gets
   W_CORPERG   := "N/G   , B/G    ,B, N, W/B+  "       // Cor das perguntas
   W_CORMENS   := "N/W   , GR+/G  ,B, N, W/B+  "       // Cor das perguntas
   W_CORMENU   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos Menus
   W_CORSUBM   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos sub-menus
   W_BACKMENU  := "W/B   , B/W    ,B, N, W/N   "       // Cor do back menu
   W_BOTOES    := "R/W   , G/N    ,B, N, W/N   "       // Cor de botoes
   W_PUSHBOT   := "W/B   , G/N    ,B, N, W/N   "       // Cor do botao push
   W_FIRSTLET  := "B+/W  , G/N    ,B, N, W/N   "       // Cor primeira letra
   W_CORSHOW   := "B/BG  , G/N    ,B, N, W/N   "       // Cor de show
   //               |       |      |      +--> get inativo
   //               |       |      +---------> borda
   //               |       +----------------> get ativo
   //               +------------------------> say
else
   W_PDCOR     := "W/N   , N/W    ,N, N, W/N   "       // Cor padrao
   W_CORSOMBRA := "W/N   , N/W    ,N, N, W/N   "       // Cor da sombra
   W_CORWIND   := "W/N   , N/W    ,N, N, W/N   "       // Cor janela sem get's
   W_CORGET    := "W/N   , N/W    ,N, N, W/N   "       // Cor gets com fundo basico
   W_COREDIT   := "W/N   , N/W    ,N, N, W/N   "       // Cor gets com fundo basico
   W_CORWG     := "W/N   , N/W    ,N, N, W/N   "       // Cor window com gets
   W_CORPERG   := "W/N   , N/W    ,N, N, W/N   "       // Cor das perguntas
   W_CORMENS   := "W/N   , N/W    ,N, N, W/N   "       // Cor das perguntas
   W_CORMENU   := "W/N   , N/W    ,N, N, W/N   "       // Cor dos Menus
   W_CORSUBM   := "W/N   , N/W    ,N, N, W/N   "       // Cor dos sub-menus
   W_BACKMENU  := "W/N   , N/W    ,N, N, W/N   "       // Cor do back menu
   W_BOTOES    := "W/N   , N/W    ,N, N, W/N   "       // Cor de botoes
   W_PUSHBOT   := "W/N   , N/W    ,N, N, W/N   "       // Cor do botao push
   W_FIRSTLET  := "W/N   , N/W    ,N, N, W/N   "       // Cor primeira letra
   W_CORSHOW   := "W/N   , N/W    ,N, N, W/N   "       // Cor de show
end

/*

 Testa padrao de cor
W_PDCOR     := "W/B   , B/W    ,B, N, N     "       // Cor padrao
W_CORSOMBRA := "N/BG  , B/W    ,B, N, N     "       // Cor da sombra
W_CORWIND   := "W/B   , W/R    ,B, N, W/GR  "       // Cor janela sem get's
//W_CORWIND   := "GR/B+  , W/BG   ,G, N, W/GR  "       // Cor janela sem get's
W_CORGET    := "W+/BG , N/W    ,B, N, N/BG  "       // Cor gets com fundo basico
W_COREDIT   := "N/BG  , BG/RB+ ,B, N, N/BG  "       // Cor gets com fundo basico
W_CORWG     := "RB/W  , N/G    ,B, N, RB/W  "       // Cor window com gets
W_CORPERG   := "N/G   , B/G    ,B, N, W/B+  "       // Cor das perguntas
W_CORMENS   := "N/W   , GR+/G  ,B, N, W/B+  "       // Cor das perguntas
W_CORMENU   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos Menus
W_CORSUBM   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos sub-menus
W_BACKMENU  := "W/B   , B/W    ,B, N, W/N   "       // Cor do back menu
W_BOTOES    := "R/W   , G/N    ,B, N, W/N   "       // Cor de botoes
W_PUSHBOT   := "W/B   , G/N    ,B, N, W/N   "       // Cor do botao push
W_FIRSTLET  := "B+/W  , G/N    ,B, N, W/N   "       // Cor primeira letra
W_CORSHOW   := "B/BG  , G/N    ,B, N, W/N   "       // Cor de show

//		 |	 |	|      +--> get inativo
//		 |	 |	+---------> borda
//		 |	 +----------------> get ativo
//               +------------------------> say
*/

// Configuracao do diretorio de trabalho, atual
W_DIR := ""

// Mostra tela principal
setcolor( W_PDCOR )
cls

// Define ambiente

//PATH_FOLHA := getenv("DIRFOLHA")
//PATH_GER   := getenv("DIRFOLHA")

//if empty( PATH_FOLHA )
//   ? 'Diretorio da folha nao declarado.'
//   ? 'Ex. SET DIRFOLHA=\FOLHA       '
//   quit
//end

//SET PATH TO &PATH_FOLHA
telamain()

// --------------------------------------
set date british
set scoreboard off
set wrap on
set deleted on
set confirm on
set intensity on
set message to 24

// spv_dec() // verifica existencia dos dbfs

reorg() // verifica existencia dos indices

W_ABAND := .T.

// Paragrafo 1
// ----------------------------------------------------------------------
// Define menu principal

PRIVATE WOPC01,WOPC02,WOPC03,WOPC04,WOPC05,WOPC06,WOPC011,WOPC016

W_MENU000:={}
W_MENU100:={}
W_MENU110:={}
W_MENU120:={}
W_MENU121:={}
W_MENU122:={}
W_MENU130:={}
W_MENU140:={}
W_MENU300:={}
W_MENU200:={}
W_MENU400:={}
W_MENU500:={}

aadd( W_MSG, 'Folha de Pagamento                  <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Sistema Contabil                    <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Sistema Gerencial                   <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Cadastros                           <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Utilitarios                         <ENTER>-Acessa <ESC>-Retorna.')

aadd( W_MENU000, ' Folha ' )
aadd( W_MENU000, ' Contabilidade ' )
aadd( W_MENU000, ' Gerencia ' )
aadd( W_MENU000, ' Cadastros ' )
aadd( W_MENU000, ' Utilitarios ' )


// Folha de Pagamento

aadd( W_MENU100, { ' 1 - Tabelas             ', 'M10001'  } )
aadd( W_MENU100, { ' 2 - Cadastros           ', 'M10002'  } )
aadd( W_MENU100, { ' 3 - Competencia da Folha', 'FPG2400' } )
aadd( W_MENU100, { ' 4 - Calcular Folha      ', 'FPG5000' } )
aadd( W_MENU100, { ' 5 - Resultados          ', 'FPG5500' } )
aadd( W_MENU100, { ' 6 - Relatorios          ', 'R10002'  } )
aadd( W_MENU100, { ' 7 - Rescisao            ', 'FPG6000' } )

// Contabilidade

//aadd( W_MENU200, { ' 1 - Cadastros      ', 'Ct1000'   } )
//aadd( W_MENU200, { ' 2 - Listagens      ', 'Ct2000'   } )
//aadd( W_MENU200, { ' 3 - Lancamentos    ', 'Ct3001'   } )
//aadd( W_MENU200, { ' 4 - Fechamentos    ', 'Ct4000'   } )
//aadd( W_MENU200, { ' 5 - Relatorios     ', 'Ct5000'   } )
//aadd( W_MENU200, { ' 6 - Utilitarios    ', 'Ct6000'   } )

// Gerencia

aadd( W_MENU300, { ' 1 - Gerencia             ','GER0100'  } )
aadd( W_MENU300, { ' 2 - Honorarios           ','GER0500'  } )
aadd( W_MENU300, { ' 3 - Empresa & Receitas   ','GER0200'  } )
aadd( W_MENU300, { ' 4 - Codigo Receita       ','GER0300'  } )
aadd( W_MENU300, { ' 5 - Impressao - Darf     ','GERR0100' } )
aadd( W_MENU300, { ' 6 - Retirada Pro-Labore  ','GER0400'  } )


// Cadastros Gerais

aadd( W_MENU400, { ' 1 - Empresas          ', 'FPG0100' } )
aadd( W_MENU400, { ' 2 - Bancos            ', 'FPG0700' } )
aadd( W_MENU400, { ' 3 - Agencias          ', 'FPG0800' } )
aadd( W_MENU400, { ' 4 - Cargo             ', 'FPG0300' } )
aadd( W_MENU400, { ' 5 - Unidade Federal   ', 'FPG0400' } )
aadd( W_MENU400, { ' 6 - Nacionalidade     ', 'FPG1100' } )
aadd( W_MENU400, { ' 7 - Naturalidade      ', 'FPG2000' } )
aadd( W_MENU400, { ' 8 - Salario Minimo    ', 'FPG0900' } )
aadd( W_MENU400, { ' 9 - INSS              ', 'FPG1300' } )
aadd( W_MENU400, { '10 - Estado Civil      ', 'FPG0600' } )
aadd( W_MENU400, { '11 - Grau de Instrucao ', 'FPG1700' } )
aadd( W_MENU400, { '12 - Tipo de Folha     ', 'FPG2300' } )
aadd( W_MENU400, { '13 - Atividades FPAS   ', 'FPG4000' } )
aadd( W_MENU400, { '14 - Relatorios        ', 'R10003'  } )

// utilitarios

aadd( W_MENU500, { ' 1 - Indexar Arqs ','FPGI0000' } )

setcolor( W_PDCOR )
cls

//RUN &PATH_FOLHa
//SET PATH TO &PATH_FOLHA
telamain()

//RUN &PATH_FOLHa
//SET PATH TO &PATH_FOLHA
abrir("FPG0100")

private WTL0000 := savescreen() ; WCOR0000 := setcolor()

If ! Login_Emp()
   return
end

keyboard chr(13)
while .T.
   setcolor( W_PDCOR )

   telamain()

   telanum('SCR000','MEN000')

   mensagem("Tecle <ENTER> e mova as setas.")
   setcolor(W_CORMENU)

   @ 04, 05 prompt W_MENU000[1]
   @ 04, 12 prompt W_MENU000[2]
   @ 04, 27 prompt W_MENU000[3]
   @ 04, 37 prompt W_MENU000[4]
   @ 04, 61 prompt W_MENU000[5]
 
   menu to WOPC0000

   if WOPC0000 > 0
      setcolor(W_PDCOR)
      mensagem(W_MSG[WOPC0000])
      setcolor(W_CORSUBM)
   end

   WOPC00 := '   '

   DO CASE

      CASE WOPC0000 = 1   // Folha
         while ! WOPC00 $ '000ESQDIR'
            WOPC00 := menu( W_MENU100, 07, 03, ' Folha de Pagamento ' )
         end

      CASE WOPC0000 = 2  // Contabilidade
         ini_contabil()
         Use Ctd001  Alias  Empresa
         Cliente = Ltrim(Rtrim(A_Nome))
         while ! WOPC00 $ '000ESQDIR'
            WOPC00 := menu( W_MENU200, 07, 14, ' Sistema Contabil ' )
         end

      CASE WOPC0000 = 3   //  Sistema Gerencial
         while ! WOPC00 $ '000ESQDIR'
            WOPC00 := menu( W_MENU300, 07, 25, ' Sistema Gerencial '   )
         end

      CASE WOPC0000 = 4 // Cadastros
         while ! WOPC00 $ '000ESQDIR'
            WOPC00 := menu( W_MENU400, 07, 35, ' Cadastros ' )
         end

      CASE WOPC0000 = 5 // Utilitarios
         while ! WOPC00 $ '000ESQDIR'
            WOPC00 := menu( W_MENU500, 07, 56, 'Utilitarios' )
         end

       CASE WOPC0000 = 0 // Saida
         abrir("FPG0100")
         If ! Login_Emp()
            if pergunta("Confirma Saida do Sistema (S/N) ?")
               exit
            end
         end

   endcase

   do case
      case WOPC00 = "ESQ"
         keyboard( chr( K_CTRL_S ) + chr( K_ENTER ) )
      case WOPC00 = "DIR"
         keyboard( chr( K_CTRL_D ) + chr( K_ENTER ) )
   endcase

end

restscreen(,,,,WTL0000)
setcolor("W/N,N/W,N")
cls
return

/*
-------------------------------------------------------------------------------
Procedimento .: TELAMAIN
Objetivo .....: Montar a tela principal
-------------------------------------------------------------------------------
*/
procedure telamain()
   static SCR_MENU0

   setcolor(W_CORMENU)
   if SCR_MENU0 = NIL

      setcolor( W_PDCOR )
      @ 00,00 say '                        Sistema Administrativo Integrado                 A&D    '
      @ 01,00 say '                                                                       Sistemas '
      @ 02,00 say '                                                                                '
      @ 03,00 say '                                                                                '
      @ 04,00 say '                                                                                '
      @ 05,00 say '                                                                                '
      setcolor( W_CORMENU )
      @ 03,02 say '⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø'
      @ 04,02 say '≥   Folha  Contabilidade  Gerencia  Cadastros               Utilitarios    ≥'
      @ 05,02 say '¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ'
      setcolor( W_PDCOR )
      @ 06,03 say '                                                                                '
      sombra(03,02,05,77)
      @ 07,00 say '                                                                                '
      @ 08,00 say '                                                                                '
      @ 09,00 say '                                                                                '
      @ 10,00 say '                                                                                '
      @ 11,00 say '                                                                                '
      @ 12,00 say '                                                                                '
      @ 13,00 say '                                                                                '
      @ 14,00 say '                                                                                '
      @ 15,00 say '                                                                                '
      @ 16,00 say '                                                                                '
      @ 17,00 say '                                                                                '
      @ 18,00 say '                                                                                '
      @ 19,00 say '                                                                                '
      @ 20,00 say '                                                                                '
      @ 21,00 say '                                                                                '
      @ 22,00 say '                                                                                '
      @ 23,00 say '   >                                                                            '
      logotipo()
      telanum('SCR000','MEN000')
      SCR_MENU0 := savescreen(00,00,24,79)
   else
      restscreen( 00,00,24,79,SCR_MENU0)
   end

   setcolor( W_PDCOR )
   dbcloseall()

return

/*
-------------------------------------------------------------------------------
Procedimento .:  M10001
Objetivo .....:  Tabelas Basicas
-------------------------------------------------------------------------------
*/
procedure M10001

W_MENU110 := {}

aadd( W_MENU110, { ' 1 - Setor              ', 'FPG0500' }  )
aadd( W_MENU110, { ' 2 - Funcao             ', 'FPG1200' }  )
aadd( W_MENU110, { ' 3 - Base de Calculo    ', 'FPG1400' }  )
aadd( W_MENU110, { ' 4 - Imposto de Renda   ', 'FPG2600' }  )
aadd( W_MENU110, { ' 5 - Parametros         ', 'FPG2500' }  )
aadd( W_MENU110, { ' 6 - Relatorios         ', 'R10001'  }  )


while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU110, 09, 05, ' Tabelas ' )
end
return

/*
-------------------------------------------------------------------------------
Procedimento .: R10001
Objetivo .....: Relatorios de Tabelas basicas
-------------------------------------------------------------------------------
*/
procedure R10001

W_MENU140 := {}

aadd( W_MENU140, { ' 1 - Setor             ', 'FPGR1400' } )
aadd( W_MENU140, { ' 2 - Funcao            ', 'FPGR0400' } )
aadd( W_MENU140, { ' 3 - Base de Calculo   ', 'FPGR1600' } )

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU140, 11, 10, ' Relatorios ' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: M10002
Objetivo .....: Cadastros Principais
-------------------------------------------------------------------------------
*/
procedure M10002

W_MENU120 := {}

aadd( W_MENU120, { ' 1 - Funcionarios          ', 'FPG0200' }  )
aadd( W_MENU120, { ' 2 - Dependentes           ', 'FPG1900' }  )
aadd( W_MENU120, { ' 3 - Eventos               ', 'FPG1500' }  )
aadd( W_MENU120, { ' 4 - Incidencias           ', 'FPG1800' }  )
aadd( W_MENU120, { ' 5 - Variaveis Funcionario ', 'FPG1600' }  )
aadd( W_MENU120, { ' 6 - Variaveis Empresa     ', 'FPG2200' }  )
aadd( W_MENU120, { ' 7 - Relatorios            ', 'R20002'  }  )

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU120, 10, 10, ' Cadastros ' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: R10002
Objetivo .....: Relatorios de Cadastros Principais
-------------------------------------------------------------------------------
*/
procedure R10002

W_MENU121 := {}

aadd( W_MENU121, { '1 - Ficha do Funcionario', 'FPGR2200' } )
aadd( W_MENU121, { '2 - Resumo Folha        ', 'FPGR2000' } )
aadd( W_MENU121, { '3 - Contra Cheque       ', 'FPG5200' } )
aadd( W_MENU121, { '4 - GRPS                ', 'FPGR3000' } )

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU121, 14, 10, ' Relatorios ' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: R20002
Objetivo .....: Relatorios de Cadastros Principais
-------------------------------------------------------------------------------
*/
procedure R20002

W_MENU122 := {}

aadd( W_MENU122, { '1 - Dependentes         ', 'FPGR0600' } )
aadd( W_MENU122, { '2 - Eventos             ', 'FPGR0500' } )
aadd( W_MENU122, { '3 - Funcionario         ', 'FPGR1900' } )
aadd( W_MENU122, { '4 - Incidencias         ', 'FPGR0300' } )

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU122, 14, 13, ' Relatorios ' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: R10003
Objetivo .....: Relatorios de cadastros gerais
-------------------------------------------------------------------------------
*/
procedure R10003

W_MENU130 := {}

aadd( W_MENU130, { ' 1 - Empresas            ', 'FPGR0200' } )
aadd( W_MENU130, { ' 2 - Bancos              ', 'FPGR1000' } )
aadd( W_MENU130, { ' 3 - Agencias            ', 'FPGR1100' } )
aadd( W_MENU130, { ' 4 - Cargos              ', 'FPGR0900' } )
aadd( W_MENU130, { ' 5 - Unidade Federal     ', 'FPGR0700' } )
aadd( W_MENU130, { ' 6 - Nacionalidade       ', 'FPGR1300' } )
aadd( W_MENU130, { ' 7 - Naturalidade        ', 'FPGR1800' } )
aadd( W_MENU130, { ' 8 - Salario Minimo      ', 'FPGR1200' } )
aadd( W_MENU130, { ' 9 - INSS                ', 'FPGR1500' } )
aadd( W_MENU130, { '10 - Estado Civil        ', 'FPGR0800' } )
aadd( W_MENU130, { '11 - Grau de Intrucao    ', 'FPGR1700' } )
aadd( W_MENU130, { '12 - Ficha de Empresa    ', 'FPGR2100' } )

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU130, 09, 10, ' Relatorios ' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: M10004
Objetivo .....: Menu de Utilitarios
-------------------------------------------------------------------------------
*/
procedure M10004

W_MENU400 := {}

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU400, 12, 05, 'Utilitarios' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: M20001
Objetivo .....: Menu de Contabilidade
-------------------------------------------------------------------------------
*/
procedure M20001

W_MENU200 := {}

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU200, 09, 15, ' Contabilidade ' )
end

return


/*
-------------------------------------------------------------------------------
Procedimento .: M30001
Objetivo .....: Menu de Cadastros gerais
-------------------------------------------------------------------------------
*/
procedure M30001

W_MENU310 := {}

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU310, 09, 15, ' Cadastros ' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .: TELANUM
Objetivo .....: Cabecalho com Nome / Numero da Tela
-------------------------------------------------------------------------------
*/
function TELANUM(TELANUM, PROGNOME)
local POLDCOR := setcolor()

setcolor( W_PDCOR )

@ 00,01 say TELANUM
@ 01,01 say PROGNOME
@ 01,25 say X_RAZAO

setcolor( POLDCOR)
return

/*
-------------------------------------------------------------------------------
Procedimento .: TELAREL
Objetivo .....: Cabecalho com nome / numero da tela no relatorio
-------------------------------------------------------------------------------
*/
function TELAREL(TELAREL,PROGNOME)

@ 00,01 say TELAREL
@ 01,01 say PROGNOME
@ 01,50 say X_RAZAO

return

/*
-------------------------------------------------------------------------------
Procedimento .: LOGOTIPO
Objetivo .....: Tela de Fundo com Logotipo do Cliente
-------------------------------------------------------------------------------
*/
procedure LOGOTIPO

@ 08,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 09,04 say '±±±±±±±±±   ±±±   ±±±   ±±±   ±±±±       ±±±       ±±±   ±±   ±±±±±±±±±±'
@ 10,04 say '±±±±±±±±±   ± ±   ±±±   ±±±   ±±±±    ±±±±±±       ±±±    ±   ±±±±±±±±±±'
@ 11,04 say '±±±±±±±±±    ±    ±±±   ±±±   ±±±±±±±±   ±±±   ±   ±±±   ±    ±±±±±±±±±±'
@ 12,04 say '±±±±±±±±±    ±    ±±±   ±±±    ±±±       ±±±       ±±±   ±    ±±±±±±±±±±'
@ 13,04 say '±±±±±±±±±    ±    ±±±   ±±±    ±±±       ±±±       ±±±   ±    ±±±±±±±±±±'
@ 14,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 15,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±  &  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 16,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 17,04 say '±±±±±±±±      ±±±   ±±±±   ±±±±        ±±±±   ±±   ±±±        ±±±±±±±±±±'
@ 18,04 say '±±±±±±±±   ±±±±±±   ±±±±   ±±±±   ±±   ±±±±    ±   ±±±   ±±   ±±±±±±±±±±'
@ 19,04 say '±±±±±±±±     ±±±±   ±±±±   ±±±±        ±±±±   ±    ±±±        ±±±±±±±±±±'
@ 20,04 say '±±±±±±±±   ±±±±±±    ±±±   ±±±±   ±±   ±±±±   ±    ±±±   ±±   ±±±±±±±±±±'
@ 21,04 say '±±±±±±±±      ±±±    ±±±   ±±±±   ±±   ±±±±   ±    ±±±   ±±   ±±±±±±±±±±'
@ 22,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'

return


/*
-------------------------------------------------------------------------------
Procedimento .: LOGIN_EMP
Objetivo .....: Tela de Fundo com Logotipo do Cliente
-------------------------------------------------------------------------------
*/
Function LOGIN_EMP()
local W_RET := .T.

@ 10,10 clear to 14,10
@ 10,10 say '’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏'
@ 11,10 say '≥                                                             ≥'
@ 12,10 say '≥ Codigo Empresa :                                            ≥'
@ 13,10 say '≥                                                             ≥'
@ 14,10 say '‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ'

@ 12,31 get X_CODEMP valid tes_codemp(12,31,30)
read

if lastkey()=K_ESC
   W_RET := .F.
end

@ 01,25 say X_RAZAO

return W_RET
