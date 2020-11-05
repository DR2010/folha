/*

   FPG1900.PRG - Cadastro de Dependentes

*/
#include "inkey.ch"
altd(1)

telanum('SCE1900','FPG1900')

abrir("FPG0200")
abrir("FPG1900")

private X_MATRIC       := space(5)         ,;
        X_MATRIC_DEP   := space(2)         ,;
        X_NOME_DEP     := space(30)        ,;
        X_DT_NASCM     := ctod('  /  /  ') ,;
        X_FLAG_PENS    := space(1)         ,;
        X_SEXO         := space(1)         ,;
        X_FLAG_SALFM   := space(1)         ,;
        X_FLAG_IR      := space(1)

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| FPG1900->CODEMP = X_CODEMP }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Dependentes "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "MATRIC"     )
aadd( CAMPO     , "MATRIC_DEP" )
aadd( CAMPO     , "NOME_DEP"   )
aadd( CAMPO     , "DT_NASCM"   )
aadd( CAMPO     , "FLAG_PENS"  )
aadd( CAMPO     , "SEXO"       )
aadd( CAMPO     , "FLAG_SALFM" )
aadd( CAMPO     , "FLAG_IR"    )

aadd( MASCARA   , "99999"      )
aadd( MASCARA   , "99"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )

aadd( CABECALHO , "Func"       )
aadd( CABECALHO , "Dep "       )
aadd( CABECALHO , "Nome"       )
aadd( CABECALHO , "Dt.Nasc"    )
aadd( CABECALHO , "Pen."       )
aadd( CABECALHO , "Sexo"       )
aadd( CABECALHO , "SF"         )
aadd( CABECALHO , "IR"         )

aadd( TAMANHO   , 05           )
aadd( TAMANHO   , 03           )
aadd( TAMANHO   , 30           )
aadd( TAMANHO   , 08           )
aadd( TAMANHO   , 04           )
aadd( TAMANHO   , 04           )
aadd( TAMANHO   , 02           )
aadd( TAMANHO   , 11           )

setcolor(W_COREDIT)

tedite1900()

select FPG1900
FPG1900->( dbsetorder(1) )
FPG1900->( dbseek(X_CODEMP) )
     
TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
                     CABECALHO      , ;
                     TAMANHO        , ;
                     BESCAPE        , ;
                     COR            , ;
                     TITULO         , ;
                     LININI         , ;
                     LINFIM         , ;
                     COLINI         , ;
                     BLOCK_DISP     , ;
                     CAB_TITULO     , ;
                     BORDA          , ;
                     COLFIM           ;
                   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if !eof()
             editae1900()
          end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          insere1900()
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclusao do dependente (S/N) ?")
                while FPG1900->( ! rlock() ); end
                FPG1900->( dbdelete() )
                FPG1900->( dbunlock() )
                dbskip()
             end
           end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end

   select FPG1900
   FPG1900->( dbsetorder(1) )

enddo

close data

return

************************************
function insere1900()
************************************

setcursor(1)

while .t.

   telae1900()

   X_MATRIC       := space(5)
   X_MATRIC_DEP   := space(2)
   X_NOME_DEP     := space(30)
   X_DT_NASCM     := ctod('  /  /  ')
   X_FLAG_PENS    := space(1)
   X_SEXO         := space(1)
   X_FLAG_SALFM   := space(1)
   X_FLAG_IR      := space(1)

   @ 04,27 get X_MATRIC         picture "99999" valid tes_matric( 4,27 )
   @ 05,27 get X_MATRIC_DEP     picture "99"
   @ 06,27 get X_NOME_DEP       picture "@!"
   @ 08,27 get X_DT_NASCM       picture "@!"
   @ 10,27 get X_FLAG_PENS      picture "@!"    valid X_FLAG_PENS   = 'X' .or. X_FLAG_PENS   = ' '
   @ 12,27 get X_SEXO           picture "@!"    valid X_SEXO $ 'MF'
   @ 14,27 get X_FLAG_SALFM     picture "@!"    valid X_FLAG_SALFM  = 'X' .or. X_FLAG_SALFM  = ' '
   @ 16,27 get X_FLAG_IR        picture "@!"    valid X_FLAG_IR     = 'X' .or. X_FLAG_IR     = ' '

   read

   if lastkey()=27; exit; end

   X_MATRIC_DEP  := zerofill( X_MATRIC_DEP )

   @ 04,27 say X_MATRIC_DEP

   FPG1900->(Dbsetorder(1))

   if FPG1900->(Dbseek(X_CODEMP+X_MATRIC+X_MATRIC_DEP))
      mensbeep("Dependente ja cadastrado")
      loop
   end

   // X_NOME_DEP         := space(30)
   @ 06,27 get X_NOME_DEP       picture "@!"
   @ 08,27 get X_DT_NASCM       picture "@!"
   @ 10,27 get X_FLAG_PENS      picture "@!"   valid X_FLAG_PENS   = 'X' .or. X_FLAG_PENS   = ' '
   @ 12,27 get X_SEXO           picture "@!"   valid X_SEXO $ 'MF'
   @ 14,27 get X_FLAG_SALFM     picture "@!"   valid X_FLAG_SALFM  = 'X' .or. X_FLAG_SALFM  = ' '
   @ 16,27 get X_FLAG_IR        picture "@!"   valid X_FLAG_IR     = 'X' .or. X_FLAG_IR     = ' '

   if pergunta('Confirma inclusao do dependente (S/N) ?')
      FPG1900->( dbappend() )
      repl FPG1900->CODEMP        with X_CODEMP
      repl FPG1900->MATRIC        with X_MATRIC
      repl FPG1900->MATRIC_DEP    with X_MATRIC_DEP
      repl FPG1900->NOME_DEP      with X_NOME_DEP
      repl FPG1900->DT_NASCM      with X_DT_NASCM
      repl FPG1900->FLAG_PENS     with X_FLAG_PENS
      repl FPG1900->SEXO          with X_SEXO
      repl FPG1900->FLAG_SALFM    with X_FLAG_SALFM
      repl FPG1900->FLAG_IR       with X_FLAG_IR
      scroll(09,27,19,54,1)
      FPG1900->( dbunlock() )
   end

end

************************************
function editae1900()
************************************
setcursor(1)

telae1900()

@ 04,27 say    FPG1900->MATRIC
@ 05,27 say    FPG1900->MATRIC_DEP
tes_matric (04,27)

X_NOME_DEP         := FPG1900->NOME_DEP

@ 06,27 get X_NOME_DEP       picture "@!"
@ 08,27 get X_DT_NASCM       picture "@!"
@ 10,27 get X_FLAG_PENS      picture "@!"   valid X_FLAG_PENS   = 'X' .or. X_FLAG_PENS   = ' '
@ 12,27 get X_SEXO           picture "@!"   valid X_SEXO $ 'MF'
@ 14,27 get X_FLAG_SALFM     picture "@!"   valid X_FLAG_SALFM  = 'X' .or. X_FLAG_SALFM  = ' '
@ 16,27 get X_FLAG_IR        picture "@!"   valid X_FLAG_IR     = 'X' .or. X_FLAG_IR     = ' '
read
    
if empty(X_NOME_DEP) .or. lastkey()=27
   setcursor(0)
   return nil
end

while FPG1900->( ! rlock() ); end
FPG1900->NOME_DEP     :=   X_NOME_DEP
FPG1900->DT_NASCM     :=   X_DT_NASCM
FPG1900->FLAG_PENS    :=   X_FLAG_PENS
FPG1900->SEXO         :=   X_SEXO
FPG1900->FLAG_SALFM   :=   X_FLAG_SALFM
FPG1900->FLAG_IR      :=   X_FLAG_IR
FPG1900->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1900
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1900()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TELAe1900
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae1900()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Funcionario..........:                                                   '
   @ 05,03 say ' Dependente...........:                                                   '
   @ 06,03 say ' Nome.................:                                                   '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Data de Nascimento...:                                                   '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' Pensao...............:                                                   '
   @ 11,03 say '                                                                          '
   @ 12,03 say ' Sexo.................:                                                   '
   @ 13,03 say '                                                                          '
   @ 14,03 say ' Salario Familia......:                                                   '
   @ 15,03 say '                                                                          '
   @ 16,03 say ' Imposto de Renda.....:                                                   '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '
   @ 22,03 say '                                                                          '



