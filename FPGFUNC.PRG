/*

   FPG - Folha de Pagamento
   fpgfunc - Modulo de Procedimentos e Funcoes

*/
/*
-----------------------------------------------------------------------------
Procedimento : ABRIR
Parametros   : Nome do arquivo
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
Procedure abrir( P_FILE )

if select( P_FILE ) == 0
   do case

      case P_FILE = "FPG0100"
	 use FPG0100  index  FPG01001			 shared  New

      case P_FILE = "FPG0200"
	 use FPG0200  index  FPG02001			 shared  New

      case P_FILE = "FPG0300"
	 use FPG0300  index  FPG03001			 shared  New

      case P_FILE = "FPG0400"
	 use FPG0400  index  FPG04001			 shared  New

      case P_FILE = "FPG0500"
	 use FPG0500  index  FPG05001			 shared  New

      case P_FILE = "FPG0600"
	 use FPG0600  index  FPG06001			 shared  New

      case P_FILE = "FPG0700"
	 use FPG0700  index  FPG07001			 shared  New

      case P_FILE = "FPG0800"
	 use FPG0800  index  FPG08001			 shared  New

      case P_FILE = "FPG0900"
	 use FPG0900  index  FPG09001			 shared  New


      case P_FILE = "FPG1100"
	 use FPG1100  index  FPG11001			 shared  New

      case P_FILE = "FPG1200"
	 use FPG1200  index  FPG12001			 shared  New

      case P_FILE = "FPG1300"
	 use FPG1300  index  FPG13001			 shared  New

      case P_FILE = "FPG1400"
	 use FPG1400  index  FPG14001,FPG14002		 shared  New

      case P_FILE = "FPG1500"
	 use FPG1500  index  FPG15001, FPG15002 	 shared  New

      case P_FILE = "FPG1600"
	 use FPG1600  index  FPG16001			 shared  New

      case P_FILE = "FPG1700"
	 use FPG1700  index  FPG17001			 shared  New

      case P_FILE = "FPG1800"
	 use FPG1800  index  FPG18001, FPG18002 	 shared  New

      case P_FILE = "FPG1900"
	 use FPG1900  index  FPG19001			 shared  New

      case P_FILE = "FPG2000"
	 use FPG2000  index  FPG20001			 shared  New

      case P_FILE = "FPG2200"
	 use FPG2200  index  FPG22001			 shared  New

      case P_FILE = "FPG2300"
	 use FPG2300  index  FPG23001			 shared  New

      case P_FILE = "FPG2400"
	 use FPG2400  index  FPG24001			 shared  New

      case P_FILE = "FPG2500"
	 use FPG2500  index  FPG25001			 shared  New

      case P_FILE = "FPG2600"
	 use FPG2600  index  FPG26001			 shared  New

      case P_FILE = "FPG4000"
	 use FPG4000  index  FPG40001			 shared  New

      case P_FILE = "FPG3100"
	 use FPG3100  index  FPG31001			 shared  New

      case P_FILE = "FPG5000"
         use FPG5000  index  FPG50001,FPG50002,FPG50003,FPG50004 shared  New

      case P_FILE = "FPG5200"
	 use FPG5200  index  FPG52001			 shared  New

      case P_FILE = "FPGB001"
	 use FPGB001  index  FPGB0001			 shared  New

      case P_FILE = "GER0100"
	 use GER0100  index  GER01001			 shared  New

      case P_FILE = "GER0200"
	 use GER0200  index  GER02001,GER02002		 shared  New

      case P_FILE = "GER0300"
	 use GER0300  index  GER03001			 shared  New

      case P_FILE = "GER0400"
	 use GER0400  index  GER04001			 shared  New

      case P_FILE = "GER0500"
	 use GER0500  index  GER05001			 shared  New

   endcase

end
return

*---------------------------------------------*
Function reorg
*---------------------------------------------*

ind_ := 'Indexando '

dbcloseall()

set cursor off

testaind(.t.,'FPG0100','FPG01001','codemp'                                   ,ind_ + 'Cadastro de Empresas')
testaind(.t.,'FPG0200','FPG02001','codemp+matric'                            ,ind_ + 'Cadastro de Funcionarios')
testaind(.t.,'FPG0300','FPG03001','codcargo'                                 ,ind_ + 'Cadastro de Cargos')
testaind(.t.,'FPG0400','FPG04001','coduf'                                    ,ind_ + 'Cadastro de Unidade Federal')
testaind(.t.,'FPG0500','FPG05001','codemp+codsetor'                          ,ind_ + 'Cadastro de Setor')
testaind(.t.,'FPG0600','FPG06001','codcivil'                                 ,ind_ + 'Cadastro de Estado Civil')
testaind(.t.,'FPG0700','FPG07001','codbanco'                                 ,ind_ + 'Cadastro de Bancos')
testaind(.t.,'FPG0800','FPG08001','codbanco+codagencia'                      ,ind_ + 'Cadastro de Agencias')
testaind(.t.,'FPG0900','FPG09001','periodo'                                  ,ind_ + 'Cadastro de Salario')
testaind(.t.,'FPG1100','FPG11001','codnacional'                              ,ind_ + 'Cadastro de Nacionalidade')
testaind(.t.,'FPG1200','FPG12001','codemp+codfuncao'                         ,ind_ + 'Cadastro de Funcao')
testaind(.t.,'FPG1300','FPG13001','faixa'                                    ,ind_ + 'Cadastro de INSS')
testaind(.t.,'FPG1400','FPG14001','codemp+codbase'                           ,ind_ + 'Cadastro de Base de Calculo')
testaind(.t.,'FPG1400','FPG14002','codemp+especial'                          ,ind_ + 'Cadastro de Base de Calculo')
testaind(.t.,'FPG1500','FPG15001','codemp+codevento'                         ,ind_ + 'Cadastro de Eventos')
testaind(.t.,'FPG1500','FPG15002','codemp+modo_calc'                         ,ind_ + 'Cadastro de Eventos')

testaind(.t.,'FPG1600','FPG16001','codemp+matric+codevento'                  ,ind_ + '                         ')
testaind(.t.,'FPG1600','FPG16002','codemp+matric+codevento'                  ,ind_ + '                         ')
testaind(.t.,'FPG1700','FPG17001','codgrau'                                  ,ind_ + 'Cadastro de Grau de Instrucao')
testaind(.t.,'FPG1800','FPG18001','codemp+codbase+codevento'                 ,ind_ + 'Cadastro de Incidencias')
testaind(.t.,'FPG1800','FPG18002','codemp+codevento+codbase'                 ,ind_ + 'Cadastro de Incidencias')
testaind(.t.,'FPG1900','FPG19001','codemp+matric+matric_dep'                 ,ind_ + 'Cadastro de Dependentes')
testaind(.t.,'FPG2000','FPG20001','codnatural'                               ,ind_ + 'Cadastro de Naturalidade')
testaind(.t.,'FPG2200','FPG22001','codemp+codevento'                         ,ind_ + 'Cadastro de Evento Empresa')
testaind(.t.,'FPG2300','FPG23001','tpfolha'                                  ,ind_ + 'Cadastro de Tipo de Folha')
testaind(.t.,'FPG2400','FPG24001','codemp+ano+mes+numfolha'                  ,ind_ + 'Cadastro de Competencia da Folha ')
testaind(.t.,'FPG2500','FPG25001','limiinss+limiirrf'                        ,ind_ + 'Tabela de Parametros')
testaind(.t.,'FPG2600','FPG26001','faixa'                                    ,ind_ + 'Tabela de Imposto de Renda')
testaind(.t.,'FPG4000','FPG40001','codfpas'                                  ,ind_ + 'Tabela de Atividades')
testaind(.t.,'FPG3100','FPG31001','codemp+ano+mes+numfolha+matric+codbase'   ,ind_ + 'Cadastro de Evento Empresa')
testaind(.t.,'FPG5000','FPG50001','codemp+ano+mes+numfolha+matric+codevento' ,ind_ + 'Resultado Calculo')
testaind(.t.,'FPG5000','FPG50002','codemp+ano+mes+tpfolha+matric+codevento'  ,ind_ + 'Resultado Calculo')
testaind(.t.,'FPG5000','FPG50003','codemp+ano+mes+matric+tpfolha'            ,ind_ + 'Resultado Calculo')
testaind(.t.,'FPG5000','FPG50004','codemp+matric+codevento'                  ,ind_ + 'Resultado Calculo')
testaind(.t.,'FPG5200','FPG52001','codemp+anofolha+mesfolha+numfolha+matric' ,ind_ + 'R.N Contra Cheque')

testaind(.t.,'FPGB001','FPGB0001','codemp+matric'                            ,ind_ + 'Arquivo de Vencimentos')

testaind(.t.,'GER0100','GER01001','socio'                                    ,ind_ + 'Arquivo de Socios')
testaind(.t.,'GER0200','GER02001','codemp+periodo'                           ,ind_ + 'Arquivo de Receitas')
testaind(.t.,'GER0200','GER02002','periodo+codemp'                           ,ind_ + 'Arquivo de Receitas')
testaind(.t.,'GER0300','GER03001','codemp+codrec'                            ,ind_ + 'Arquivo de Receitas')
testaind(.t.,'GER0400','GER04001','codemp+ano+mes'                           ,ind_ + 'Arquivo de Mensalidades')
testaind(.t.,'GER0500','GER05001','codemp+ano+mes'                           ,ind_ + 'Arquivo de Mensalidades')

set cursor on

return nil

*---------------------------------------------*
Function testaind(flg,arq,ind,chave,titulo)
*---------------------------------------------*

if file(alltrim(ind) + '.ntx') ; return nil ; end
use &arq
if flg ; pack ; end
index on &chave to &ind
use
return nil

/*
-----------------------------------------------------------------------------
Procedimento : M_TABELAS
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function m_tabelas( P_COND )

   local P_OLDCOR := setcolor()
   local P_HDSEP := "ËÍ"
   local P_COLSEP := "-"

   local P_SCR := savescreen(,,,)
   local getlist:={}

   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| .T. }
   local COR	     := W_CORWIND
   local TITULO      := ""
   local LININI      := 06
   local LINFIM      := 15
   local COLINI      := 15
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA	     := 1

   local TECLA	     := nil
   local TABELA      := nil
   local IS_TBROWSE  := .F.

   do case

      case P_COND = "X_CODEMP"
	 IS_TBROWSE  := .T.

	 TITULO      := " Empresas "
	 LININI      := 07
	 COLINI      := 15
	 LINFIM      := 20

	 aadd( P_HEADER  , "Codigo"       )
	 aadd( P_HEADER  , "Razao Social" )

	 aadd( P_CAMPOS  , "CODEMP"       )
	 aadd( P_CAMPOS  , "RAZAO"        )

	 aadd( MASCARA	 , "999"          )
	 aadd( MASCARA	 , "@!"           )

	 aadd( TAMANHO	 , 03		  )
	 aadd( TAMANHO	 , 40		  )

	 select FPG0100
	 FPG0100->( dbsetorder(1) )
	 FPG0100->( dbgotop() )

      case P_COND = "X_MATRIC"

	 select FPG0200
	 FPG0200->( dbsetorder(1) )
	 FPG0200->( dbseek(X_CODEMP) )

	 IS_TBROWSE  := .T.

	 TITULO      := " Funcionarios "
	 LININI      := 03
	 COLINI      := 20
	 LINFIM      := 15
	 BESCAPE     := {|| CODEMP = X_CODEMP }

	 aadd( P_HEADER, "Matricula"    )
	 aadd( P_HEADER, "Nome"         )

	 aadd( P_CAMPOS, "MATRIC"       )
	 aadd( P_CAMPOS, "NOME"         )

	 aadd( MASCARA	 , "99999"      )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05 )
	 aadd( TAMANHO	 , 40 )


      case P_COND = "X_PERIODO"
	 IS_TBROWSE  := .T.

	 TITULO      := " Empresas & Receitas "
	 LININI      := 07
	 COLINI      := 15
	 LINFIM      := 15

	 aadd( P_HEADER  , "Empresa"      )
	 aadd( P_HEADER  , "Periodo"      )
	 aadd( P_HEADER  , "Valor"        )

	 aadd( P_CAMPOS  , "CODEMP"       )
	 aadd( P_CAMPOS  , "PERIODO"      )
	 aadd( P_CAMPOS  , "VALOR"        )

	 aadd( MASCARA	 , "999"          )
	 aadd( MASCARA	 , "9999"         )
	 aadd( MASCARA	 , "@E 999.99"    )

	 aadd( TAMANHO	 , 06		  )
	 aadd( TAMANHO	 , 07		  )
	 aadd( TAMANHO	 , 10		  )

	 select GER0200
	 GER0200->( dbsetorder(1) )
	 GER0200->( dbgotop() )

      case P_COND = "X_CODREC"
	 IS_TBROWSE  := .T.

	 TITULO      := " Cod. de Receita "
	 LININI      := 07
	 COLINI      := 15
	 LINFIM      := 15

	 aadd( P_HEADER  , "Codigo"       )
	 aadd( P_HEADER  , "Descricao "   )

	 aadd( P_CAMPOS  , "CODREC"       )
	 aadd( P_CAMPOS  , "DESCRICAO"    )

	 aadd( MASCARA	 , "9999"         )
	 aadd( MASCARA	 , "@!"           )

	 aadd( TAMANHO	 , 06		  )
	 aadd( TAMANHO	 , 30		  )

	 select GER0400
	 GER0400->( dbsetorder(1) )
	 GER0400->( dbgotop() )


      case P_COND = "X_CODBASE"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Base de Calculo "
	 LININI      := 05
	 COLINI      := 28
	 LINFIM      := 15

	 select FPG1400
	 FPG1400->( dbsetorder(1) )
	 FPG1400->( dbseek(X_CODEMP) )
	 BESCAPE     := {|| CODEMP = X_CODEMP }
	 aadd( P_HEADER  , "Codigo"     )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODBASE"    )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "999"        )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 06		)
	 aadd( TAMANHO	 , 32		)

      case P_COND = "X_CODUF"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Unidade Federal "
	 LININI      := 17
	 COLINI      := 50
	 LINFIM      := 28

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODUF"      )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 03		)
	 aadd( TAMANHO	 , 24		)

	 select FPG0400
	 FPG0400->( dbsetorder(1) )
	 FPG0400->( dbgotop() )

      case P_COND = "X_CODCIVIL"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Estado Civil "
	 LININI      := 11
	 COLINI      := 18
	 LINFIM      := 22

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODCIVIL"   )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 22		)

	 select FPG0600
	 FPG0600->( dbsetorder(1) )
	 FPG0600->( dbgotop() )

      case P_COND = "X_CODCARGO"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Cargos "
	 LININI      := 05
	 COLINI      := 18
	 LINFIM      := 15

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODCARGO"   )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 32		)

	 select FPG0300
	 FPG0300->( dbsetorder(1) )
	 FPG0300->( dbgotop() )

      case P_COND = "X_CODBANCO"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Bancos "
	 LININI      := 04
	 COLINI      := 30
	 LINFIM      := 15

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODBANCO"   )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "999"        )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 32		)

	 select FPG0700
	 FPG0700->( dbsetorder(1) )
	 FPG0700->( dbgotop() )

      case P_COND = "X_CODSETOR"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Setor "
	 LININI      := 06
	 COLINI      := 50
	 LINFIM      := 16

	 select FPG0500
	 FPG0500->( dbsetorder(1) )
	 FPG0500->( dbseek(X_CODEMP) )
	 BESCAPE     := {|| CODEMP = X_CODEMP }

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODSETOR"   )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 20		)

      case P_COND = "X_CODNACIONA"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Nacionalidade "
	 LININI      := 11
	 COLINI      := 45
	 LINFIM      := 19

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODNACIONA" )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 19		)

	 select FPG1100
	 FPG1100->( dbsetorder(1) )
	 FPG1100->( dbgotop() )

      case P_COND = "X_CODGRAU"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Grau de Intrucao "
	 LININI      := 10
	 COLINI      := 40
	 LINFIM      := 21

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODGRAU" )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 28		)

	 select FPG1700
	 FPG1700->( dbsetorder(1) )
	 FPG1700->( dbgotop() )

      case P_COND = "X_CODNATURAL"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Naturalidade "
	 LININI      := 10
	 COLINI      := 18
	 LINFIM      := 21

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODNATURAL" )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "99"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 28		)

	 select FPG2000
	 FPG2000->( dbsetorder(1) )
	 FPG2000->( dbgotop() )


      case P_COND = "X_CODEVENTO"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Eventos "
	 LININI      := 13
	 COLINI      := 37
	 LINFIM      := 21

	 select FPG1500
	 FPG1500->( dbsetorder(1) )
	 FPG1500->( dbseek(X_CODEMP) )
	 BESCAPE     := {|| CODEMP = X_CODEMP }
	 aadd( P_HEADER  , "Codigo"     )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "CODEVENTO"  )
	 aadd( P_CAMPOS  , "DESCEVENT"  )

	 aadd( MASCARA	 , "999"        )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 06		)
	 aadd( TAMANHO	 , 32		)

      case P_COND = "X_SOCIO"
	 IS_TBROWSE  := .T.

	 TITULO      := " Responsaveis "
	 LININI      := 04
	 COLINI      := 23
	 LINFIM      := 15

	 aadd( P_HEADER  , "Codigo"  )
	 aadd( P_HEADER  , "Nome"  )

	 aadd( P_CAMPOS  , "SOCIO"  )
	 aadd( P_CAMPOS  , "NOME"  )

	 aadd( MASCARA	 , "@!"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 06		)
	 aadd( TAMANHO	 , 40		)

	 select GER0100
	 GER0100->( dbsetorder(1) )
	 GER0100->( dbgotop() )

      case P_COND = "X_TPFOLHA"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Tipo de Folha "
	 LININI      := 06
	 COLINI      := 40
	 LINFIM      := 21

	 aadd( P_HEADER  , "Cod"        )
	 aadd( P_HEADER  , "Descricao"  )

	 aadd( P_CAMPOS  , "TPFOLHA" )
	 aadd( P_CAMPOS  , "DESCRICAO"  )

	 aadd( MASCARA	 , "@!"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 05		)
	 aadd( TAMANHO	 , 28		)

	 select FPG2300
	 FPG2300->( dbsetorder(1) )
	 FPG2300->( dbgotop() )

      case P_COND = "X_CODFPAS"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tabela de Atividades "
	 LININI      := 06
	 COLINI      := 15
	 LINFIM      := 21

	 aadd( P_HEADER  , "CODFPAS"   )
	 aadd( P_HEADER  , "FPAS"      )
	 aadd( P_HEADER  , "PERC_CONT" )
	 aadd( P_HEADER  , "PERC_TERC" )

	 aadd( P_CAMPOS  , "99"        )
	 aadd( P_CAMPOS  , "999"       )
	 aadd( P_CAMPOS  , "@E 999.99" )
	 aadd( P_CAMPOS  , "@E 999.99" )

	 aadd( MASCARA	 , "Cod"       )
	 aadd( MASCARA	 , "FPAS"      )
	 aadd( MASCARA	 , "Cont."     )
	 aadd( MASCARA	 , "Terc."     )

	 aadd( TAMANHO	 , 03	       )
	 aadd( TAMANHO	 , 04	       )
	 aadd( TAMANHO	 , 08	       )
	 aadd( TAMANHO	 , 08	       )

	 select FPG4000
	 FPG4000->( dbsetorder(1) )
	 FPG4000->( dbgotop() )

   endcase

   // ----------------
   // ---- tbrowse
   // ----------------

   if IS_TBROWSE

      TABELA := tabelanew( P_CAMPOS	  , ;
			   MASCARA	  , ;
			   P_HEADER	  , ;
			   TAMANHO	  , ;
			   BESCAPE	  , ;
			   COR		  , ;
			   TITULO	  , ;
			   LININI	  , ;
			   LINFIM	  , ;
			   COLINI	  , ;
			   BLOCK_DISP	  , ;
			   CAB_TITULO	  , ;
			   BORDA	    ;
			 )

      CONTINUA := .T.
      do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != 27 )
	 if TEC == 13 ; exit ; end
      enddo
      // ----------------
      // ---- fim tbrowse
      // ----------------

      // ----------------
      // ---- Retorno ...
      // ----------------

      if lastkey() = 13
	 do case

	    case P_COND = "X_CODEMP"
	       X_CODEMP    := FPG0100->CODEMP
	       X_RAZAO	   := FPG0100->RAZAO
	       FPG0100->( dbsetorder(1) )

	    case P_COND = "X_MATRIC"
	       X_MATRIC     := FPG0200->MATRIC
	       X_NOME	    := FPG0200->NOME
	       FPG0200->( dbsetorder(1) )

	    case P_COND = "X_PERIODO"
	       X_CODEMP    := GER0200->CODEMP
	       X_PERIODO   := GER0200->PERIODO
	       GER0200->( dbsetorder(1) )

	    case P_COND = "X_CODREC"
	       X_CODREC    := GER0400->CODREC
	       X_DESCRICAO := GER0400->DESCRICAO
	       GER0400->( dbsetorder(1) )

	    case P_COND = "X_CODBASE"
	       X_CODBASE     := FPG1400->CODBASE
	       X_DESCRICAO   := FPG1400->DESCRICAO
	       FPG1400->( dbsetorder(1) )

	    case P_COND = "X_CODUF"
	       X_CODUF	     := FPG0400->CODUF
	       X_DESCRICAO   := FPG0400->DESCRICAO
	       FPG0400->( dbsetorder(1) )

	    case P_COND = "X_CODCIVIL"
	       X_CODCIVIL    := FPG0600->CODCIVIL
	       X_DESCRICAO   := FPG0600->DESCRICAO
	       FPG0600->( dbsetorder(1) )

	    case P_COND = "X_CODCARGO"
	       X_CODCARGO    := FPG0300->CODCARGO
	       X_DESCRICAO   := FPG0300->DESCRICAO
	       FPG0300->( dbsetorder(1) )

	    case P_COND = "X_CODBANCO"
	       X_CODBANCO    := FPG0700->CODBANCO
	       X_DESCRICAO   := FPG0700->DESCRICAO
	       FPG0700->( dbsetorder(1) )

	    case P_COND = "X_CODSETOR"
	       X_CODSETOR    := FPG0500->CODSETOR
	       X_DESCRICAO   := FPG0500->DESCRICAO
	       FPG0500->( dbsetorder(1) )

	    case P_COND = "X_CODNACIONA"
	       X_CODNACIONA  := FPG1100->CODNACIONA
	       X_DESCRICAO   := FPG1100->DESCRICAO
	       FPG1100->( dbsetorder(1) )

	    case P_COND = "X_CODGRAU"
	       X_CODGRAU     := FPG1700->CODGRAU
	       X_DESCRICAO   := FPG1700->DESCRICAO
	       FPG1700->( dbsetorder(1) )

	    case P_COND = "X_CODNATURAL"
	       X_CODNATURAL  := FPG2000->CODNATURAL
	       X_DESCRICAO   := FPG2000->DESCRICAO
	       FPG2000->( dbsetorder(1) )

	    case P_COND = "X_CODEVENTO"
	       X_CODEVENTO   := FPG1500->CODEVENTO
	       X_DESCRICAO   := FPG1500->DESCRICAO
	       FPG1500->( dbsetorder(1) )

	    case P_COND = "X_SOCIO"
	       X_SOCIO	     := GER0100->SOCIO
	       GER0100->( dbsetorder(1) )

	    case P_COND = "X_TPFOLHA"
	       X_TPFOLHA     := FPG2300->TPFOLHA
	       X_DESCRICAO   := FPG2300->DESCRICAO
	       FPG2300->( dbsetorder(1) )

	    case P_COND = "X_CODFPAS"
	       X_CODFPAS     := FPG4000->CODFPAS
	       X_FPAS	     := FPG4000->FPAS
	       X_PERC_CONT   := FPG4000->PERC_CONT
	       X_PERC_TERC   := FPG4000->PERC_TERC
	       FPG4000->( dbsetorder(1) )

	 endcase
      end
      restscreen(,,,,P_SCR)
   end

   setcolor( P_OLDCOR )
return NIL

**********************
function tira_zero(VAR)
**********************
local WRET

if VAR == "ESP"
   MEDIDA := FPG007->ESP_INT

elseif VAR == "BIT10"
   MEDIDA := FPG010->BIT_INT

elseif VAR == "EST10"
   MEDIDA := FPG010->EST_INT

else
   MEDIDA := FPG007->BIT_INT
end

if MEDIDA == "0 " .or. MEDIDA == "  "
   WRET := space(3)
else
   WRET := MEDIDA + '+'
end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao Empresa_ok
-----------------------------------------------------------------------------
*/
function Empresa_ok()

   local WRET := .T.

   if empty( X_CODEMP ) .or. X_CODEMP = "000"

      m_tabelas("X_CODEMP")

      X_RAZAO := FPG0100->RAZAO
      @ 01,15 say X_RAZAO

      if lastkey()= 27
	 WRET := .F.
      end

   end

return WRET
/*
------------------------------------------------------------------------------
		      Funcao Cab_Emp_Tela()
-----------------------------------------------------------------------------
*/
function Cab_Emp_tela()

   local WRET := .T.
   local WPOS := 0

   FPG0100->( dbsetorder(1) )
   FPG0100->( dbseek( X_CODEMP ) )
   X_RAZAO := FPG0100->RAZAO
   WPOS := (43 - LEN(X_RAZAO) ) / 2

   @ 02,02   say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´  ' +  X_RAZAO + '  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_CODEMP
-----------------------------------------------------------------------------
*/
function tes_codemp( P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL, len( X_RAZAO ), P_TAM )

   X_CODEMP := zerofill(X_CODEMP)

   FPG0100->( dbsetorder(1) )
   FPG0100->( dbseek( X_CODEMP ) )

   if FPG0100->( ! found() )
      m_tabelas("X_CODEMP")
   end

   X_RAZAO   := FPG0100->RAZAO
   X_DIRCONT := FPG0100->DIRCONT

   @ P_LIN, P_COL say X_CODEMP

   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left( X_RAZAO, P_TAM )
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_MATRIC
-----------------------------------------------------------------------------
*/
function tes_matric( P_LIN, P_COL, P_TAM )

   local WRET := .T.

   X_CODEMP := Zerofill(X_CODEMP)
   X_MATRIC := Zerofill(X_MATRIC)

   P_TAM := if(P_TAM=NIL, len( FPG0200->NOME ), P_TAM )

   FPG0200->( dbsetorder(1) )
   FPG0200->( dbseek(X_CODEMP+X_MATRIC) )

   if FPG0200->( ! found() ) .or. X_MATRIC = "00000"
      m_tabelas("X_MATRIC")
   end

   @ P_LIN, P_COL say X_MATRIC

   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left( FPG0200->NOME, P_TAM )
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao ESP_ALT
-----------------------------------------------------------------------------
*/
function esp_alt()
local TEC

WRET := pergresp( 'Alterar/ Excluir/ Retornar (A/E/R) ? ','AER')

do case
case WRET = 'A'
   WRET := "A"
case WRET = 'E'
   WRET := "E"
case WRET = 'R'
   WRET := "*"
endcase

return ( WRET )

/*
-----------------------------------------------------------------------------
		      Funcao PEDIDO
-----------------------------------------------------------------------------
*/

function PEDIDO( VAR )

  local WRET := .T.

   FPG005->( dbsetorder(1) )

   FPG005->( dbseek( VAR ) )

   if FPG005->( ! found() )
      mensagem('Pedido nao encontrado !')
      WRET := .F.
   end

return WRET

************************
static func tes_sta_ped(var)
************************

if empty(var)
   mensagem('Campo Obrigatorio')
   return .f.
end

if var == 'P'
   return .t.
else
   if var == 'R'
      return .t.
   else
      mensagem ('Status do Pedido Invalido')
      return .f.
   end
end

db_dat_ped := var
db_dat_ent := var_ent_05
db_sta_ped := var

return .t.

/*
-----------------------------------------------------------------------------
		      Funcao SEQ_DETALHE
-----------------------------------------------------------------------------
*/
function SEQ_DETALHE( VAR )

   local W_SEQ := 0

   FPG006->( dbsetorder (2) )
   FPG006->( dbseek( VAR) )

   while !(FPG006->(EOF())) .and. VAR = FPG006->PEDIDO
      W_SEQ := FPG006->SEQUENC
      FPG006->( dbskip() )
   enddo

   W_SEQ++

return W_SEQ

/*
-------------------------------------------------------------------------------
			   NO_ZERO
-------------------------------------------------------------------------------
*/

function no_zero( VAR, INTEIRO, DECIMAL )

RETORNA := if( VAR = 0, space(INTEIRO), str( VAR, INTEIRO, DECIMAL ) )

return RETORNA


*--------------------------------------------*
function IMPRIME
PARAMETERS lin,col
tel = savescreen(lin,col,lin+4,col+29)
SETCOLOR(c_window)
TEC = 1
do while .t.
   @   lin,col sAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ lin+1,col say '³   Prepare a impressora    ³'
   @ lin+2,col SAY '³                           ³'
   @ lin+3,col SAY '³    Imprimir   Abortar     ³'
   @ lin+4,col SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   sombra(lin,col,lin+4,col+28)
   @ lin+3,col+5 prompt "Imprimir"
   @ lin+3,col+16 prompt "Abortar"
   menu to tec
   do case

   case tec=1
      c_blink:=substr(setcolor(),1,1)+"*"+substr(setcolor(),2)
      setcolor(c_blink)
      @ lin+1,col+1 say ' IMPRIMINDO '
      SETCOLOR(c_window)
      @ lin+1,col+13 SAY	    ' -  Aguarde ...'
      @ lin+2,col+1 SAY '   Tecle  "ESC"  para      '
      @ lin+3,col+1 SAY ' interromper a impressao   '
      RETURN(.t.)
   endcase

   restscreen(lin,col,lin+4,col+29,tel)
   return(.f.)
enddo

*-------------------------------------*
Function vazio

mensagem(' Preenchimento obrigatorio ! ')

return .f.

*------------------------------------*
function socorro
mensagem (' <F3>  Inclui    ',;
	  ' <F4>  Altera    ',;
	  ' <F5>  Exclui    ',;
	  ' <F6>  Consulta  ')
set curso off
return nil

*------------------------------------*
function help( prog, lin )

if prog == "GET_17" .or. prog == "ITEM_C_GET"  // apresenta mensagem apenas nos gets
   mensagem(' <F7>  Pecas Cortadas   ',;    // do item de estoque ou em consulta
	   ' <F8>  Pedido de Compra ' )
else
   mensagem(' <F3>  Inclui    ',;
	   ' <F4>  Altera    ',;
	   ' <F5>  Exclui    ',;
	   ' <F6>  Consulta  ')
end

set curso off
return nil

/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function wsave(lin1,col1,lin2,col2)
lin1:=if(valtype(lin1)!="N",0,lin1)
col1:=if(valtype(col1)!="N",0,col1)
lin2:=if(valtype(lin2)!="N",maxrow(),lin2)
col2:=if(valtype(col2)!="N",maxcol(),col2)
return str(lin1,2)+str(col1,2)+str(lin2,2)+str(col2,2)+;
       savescreen(lin1,col1,lin2,col2)


/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function wrest(telar)
RestScreen(val(substr(telar,1,2)),val(substr(telar,3,2)),;
	   val(substr(telar,5,2)),val(substr(telar,7,2)),;
	   substr(telar,9))
return nil


/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function at_next(var,texto,pos)
local valat:=0,z,pos_atu
pos:=if(valtype(pos)!="N",1,pos)
for z:=1 to pos
   pos_atu := at(var,texto)
   if pos_atu==0
      return 0
   endif
   valat+=pos_atu
   texto := substr(texto,pos_atu+1)
next
return valat
/*
	 1	   2	     3	       4
123456/890123/567890123456/8901234567890
*/


/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function wbox(lin1,col1,titulo,texto,opcao,vborda)
local i,tamtxt:=0,colant:=0,topc:=" ",tela,resp:=0,;
      lin2:=if(valtype(texto)=="A",len(texto)+1,2),;
      col2:=if(valtype(titulo)=="C",len(titulo)+4,0)
vborda:=if(valtype(vborda)=="U","ÉÍ»º¼ÍÈº ",vborda)

for i:=1 to len(opcao)
   topc+=alltrim(opcao[i])+"~~"
next
topc:=substr(topc,1,len(topc)-1)
col2:=if(col2>len(topc)+1,col2,len(topc)+1)
if valtype(texto)=="A"
   for i:=1 to len(texto)
      col2:=if(col2>len(alltrim(texto[i]))+2,col2,len(alltrim(texto[i]))+2)
   next
elseif valtype(texto)=="C"
   col2:=if(col2>len(alltrim(texto))+2,col2,len(alltrim(texto))+2)
endif
lin2+=2
lin1:=if(valtype(lin1)=="C",int(11-(lin2/2)),lin1)
col1:=if(valtype(col1)=="C",int(40-(col2/2)),col1)

tela := wsave(lin1,col1,lin1+lin2+1,col1+col2+2)

dispbox(lin1,col1,lin1+lin2,col1+col2,vborda)
sombra(lin1,col1,lin1+lin2,col1+col2)

if valtype(titulo)=="C"
   resp:=((col2+1-len(titulo))/2)+col1
   @ lin1,resp-1	   say if(substr(vborda,2,1)=="Í","µ","´")
   @ lin1,resp		   say titulo color c_wtitle
   @ lin1,resp+len(titulo) say if(substr(vborda,2,1)=="Í","Æ","Ã")
endif
if valtype(texto)=="A"
   for i:=1 to len(texto)
      if tamtxt<len(texto[i])
	 tamtxt:=len(texto[i])
      endif
      @ lin1+i,col1+2 say texto[i]
   next
elseif valtype(texto)=="C"
   resp:=((col2+1-len(texto))/2)+col1+1
   tamtxt:=len(texto)
   @ lin1+1,resp say texto
endif

resp:=1
if tamtxt<len(topc)
   col2:=2
else
   col2:=((col2-len(topc))/2)+2
endif
for i:=1 to len(opcao)
   @ lin1+lin2-1,col1+col2 prompt alltrim(opcao[i])
   col2+=at_next("~~",topc,i)
next
menu to resp
wrest(tela)
return resp

*___________________________________________*
Function tst_dt(data_)
 Private ret_dt:=.F.
 if valtype(data_)="D" ; data_:=dtoc(data_) ; end
 if alltrim(data_)="/  /" .or. empty(data_)
    return .t.
 end
 dd:=val(substr(data_,1,2)) ; mm:=zerofill(SUBSTR(data_,4,2))
 aa:=zerofill(SUBSTR(data_,7,2))
 if !empty(aa)
    if mm$"01,03,05,07,08,10,12"
       if dd<=31 .and. dd>0 ; ret_dt:=.t. ; end
    elseif mm$"04,06,09,11"
       if dd<=30 .AND. dd>0 ; ret_dt:=.t. ; end
    elseif mm$"02"

       if aa%4=0   // int(val(aa)/4)=val(aa)/4	 // Ano Bissexto
	  if dd<=29 .and. dd>0 ; ret_dt:=.t. ; end
       else
	  if dd<=28 .AND. dd>0 ; ret_dt:=.t. ; end
       end
    end
 end
 if !ret_dt ; mensagem('Data invalida!!') ; end
 return ret_dt

/* =-=-=-=-=-=-=-= */
FUNCTION editar(ee,linha,coluna)
// Funcao para ser usada com memoedit
******************************************
 ret_val = 0
 IF ee == 3
    ret_val=initstat()
 ELSE
    ret_val=tecexcecao()
 end
 @ 20,16 say "Linha "+str(linha,3)+" Coluna "+str(coluna,3)
 RETU ret_val

***
* tecexcecao()
* PROCESSA TECLAS DA FUNCAO EDITAR
***
FUNC tecexcecao
PRIV teclas
teclas = LASTKEY()
IF teclas = 28	 // F1
   mensagem(' <F1>    Aciona Ajuda     ',;
	   ' <F2>    Finaliza         ',;
	   ' <PgUp>  Avanca Pagina    ',;
	   ' <PgDn>  Retrocede Pagina ')
   ret_val:=22
elseif lastkey()==27
   opcal  :={"Gravar","N„o Gravar"}
   atext2 :='Sair do Texto:'

   opcal:=wbox("C","C",,atext2,opcal,"ÕÍ¸³¾ÍÔ³ ")
   if lastkey()==27
      ret_val:=22
   end
   if opcal==1
      keyb chr(23)
      ret_val:=22
   end

elseif teclas==22
   ins_on:=set(29)
   ret_val=22
   if !ins_on
      @20,58 say 'µInsÆ'
   else
      @20,58 say 'ÍÍÍÍÍ'
   end
end
RETU ret_val
***
* initstat()
*
FUNC initstat
IF init_count == 1
   // READINSERT(.F.)
   set(29,.f.)
   ins_mode=set(29) // READINSERT()
   IF (ins_on .AND. !ins_mode) .OR. (!ins_on .AND. ins_mode)
      ret_val=22
   ELSE
      init_count=2
   end
ELSE
   ret_val=0
end
RETU ret_val
***
* tecexcept()
* PROCESSA TECLAGENS
***
FUNC tecexcept
PRIV teclas
teclas = LASTKEY()
line_num=linha
col_num=coluna
IF teclas == 22
   READINSERT(.T.)
   ins_on=READINSERT()
   ret_val=22
end
RETU ret_val

*---------------------------------------------------------------------------*
* >>>>>>>>>>>>>>>>>>>>>>>>>>>  F U N C A O <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< *
*									    *
* Sistema...:								    *
* Modulo....:								    *
* Descricao.: Conjunto de rotinas e funcoes comuns a todos os modulos	    *
* Chamador..: * 							    *
* Chamados..: * 							    *
*---------------------------------------------------------------------------*
* EMPente...:								    *
* Analistas.: Daniel Luiz Guimaraes Machado				    *
* Autor.....: Daniel Luiz Guimaraes Machado				    *
* Inicio....: 01/08/93							    *
*---------------------------------------------------------------------------*

#include "inkey.ch"
#include "sic.ch"
#define ATTR_CONV( FORE, BACK ) (BACK)*16+(FORE)
#define BLACK 0
#define WHITE 7
#define DK_GRAY 8
#define COL_SHADOW_ATTRIBUTE ATTR_CONV(DK_GRAY, BLACK)
#define BW_SHADOW_ATTRIBUTE  ATTR_CONV(WHITE,	    BLACK)
#define LI_SEPH "Ä"
#define LI_SEPR "Í"
#define LI_SEPV "³"

/*
Procedimento : LIMPA_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure LIMPA_BUT()

setcolor(W_COREDIT)
@ 17,04 clear to 20,76

return
/*
Procedimento : CRIA_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure cria_but( LIN, COL, BOTAO, HOTLIN, HOTCOL, HOTKEY )
   local W_OLDCUR := setcursor(), W_OLDCOR := setcolor(), COLFIM

   setcursor(0)
   COLFIM := COL + len( BOTAO )
   setcolor(W_BOTOES)
   @ LIN,COL say BOTAO
   meiasombra( LIN, COL, LIN, COLFIM-1 )
   setcolor(W_FIRSTLET)
   @ HOTLIN,HOTCOL say HOTKEY
   setcursor( W_OLDCUR )
   setcolor( W_OLDCOR )
return

/*
Procedimento : PUSH_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure push_but( LIN, COL, BOTAO )
   local FIRSTL := left( alltrim(BOTAO), 1 ), COLFIM, TAMBOT
   local W_OLDCUR := setcursor(), W_OLDCOR := setcolor()

   setcursor(0)
   TAMBOT := len( BOTAO )

   COLFIM := COL + TAMBOT

   setcolor(W_COREDIT)
   @ LIN,  COL	 say space( TAMBOT+1 )
   @ LIN+1,COL	 say space( TAMBOT+1 )

   setcolor(W_BOTOES)
   @ LIN+1,COL+1 say BOTAO
   inkey(0.1)

   setcolor(W_COREDIT)
   @ LIN,  COL	 say space( TAMBOT+1 )
   @ LIN+1,COL	 say space( TAMBOT+1 )

   setcolor(W_PUSHBOT)
   @ LIN,COL say BOTAO
   meiasombra(LIN,COL,LIN,COLFIM-1)

   setcursor(W_OLDCUR)
   setcolor( W_OLDCOR )
return

*---------------------------------------------------------------------------*
* Funcao ......: MEIASOMBRA
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......:
*---------------------------------------------------------------------------*
function meiasombra( tw, lw, bw, rw )
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT) //("N/BG")
   for X:=LW+1 to RW+1
      @ BW+1,X say 'ß'
   next

   for X:=TW to BW
      @ X,RW+1 say 'Ü'
   next

   setcolor( W_OLDCOR )
return NIL


function zerofill( P_VAR )

return strzero( val( P_VAR ), len(P_VAR) )

*--------------------------------------------*
Function fpgi0000

if pergunta('Confirma reorganizacao dos indices (S/N) ?','N')
   ! del *.ntx > nul
   reorg()
endif

return nil



/*
-----------------------------------------------------------------------------
		      Funcao TES_ALMOXA
-----------------------------------------------------------------------------
*/
function tes_almoxa( VAR, POSICAO )
   local WRET := .T.

   if POSICAO = NIL; POSICAO := 1; end
   X_ALMOXARI := VAR := zerofill( X_ALMOXARI )

   begin sequence
      FPG0100->( dbsetorder(1) )
      FPG0100->( dbseek( VAR ) )

      if FPG0100->( ! found() )
	 m_tabelas()
	 if lastkey() = K_ESC
	    WRET := .F.
	    break
	 else
	    X_ALMOXARI := FPG0100->ALMOXARI
	 end
      end
      @ 11,26 say FPG0100->DESCRICAO picture '@!'
   end sequence

return WRET


/*
-----------------------------------------------------------------------------
		      Procedimento RELCAB
-----------------------------------------------------------------------------
*/
procedure RELCAB( P_PAG, P_TAM )

    @ 01      , 00 say replicate( '-', P_TAM)
    @ prow()+1, 50 say X_RAZAO
    @ prow()+2, 82 say 'Data: ' + dtoc(date())
    @ prow()  ,100 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  ,115 say 'Hora: '
    @ prow()  ,121 say (Time())
    @ prow()+1, 00 say replicate( '-', P_TAM)

return

//----------------------------------------------------------------------------
		      FUNCTION mesextenso( P_MES )
//----------------------------------------------------------------------------

WRET := ' '

do case
   case P_MES = '01'
      WRET := 'JANEIRO'
   case P_MES = '02'
      WRET := 'FEVEREIRO'
   case P_MES = '03'
      WRET := 'MARCO'
   case P_MES = '04'
      WRET := 'ABRIL'
   case P_MES = '05'
      WRET := 'MAIO'
   case P_MES = '06'
      WRET := 'JUNHO'
   case P_MES = '07'
      WRET := 'JULHO'
   case P_MES = '08'
      WRET := 'AGOSTO'
   case P_MES = '09'
      WRET := 'SETEMBRO'
   case P_MES = '10'
      WRET := 'OUTUBRO'
   case P_MES = '11'
      WRET := 'NOVEMBRO'
   case P_MES = '12'
      WRET := 'DEZEMBRO'
endcase

return WRET


/*
-----------------------------------------------------------------------------
		      Procedimento INI_CONTABIL
-----------------------------------------------------------------------------
*/

function ini_contabil()
local WRET := .T.

// if empty(X_DIRCONT)
//    mensagem('Diretorio Contabil Indefinido!')
//    WRET := .F.
// end

// PATH_CONT := "F:\CONT\"+X_DIRCONT
// SET PATH TO &PATH_CONT

return WRET
