/*
   FPG   - Folha de Pagamento
   FPG0200.PRG - Cadastro de Funcionarios
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('SCE0200','FPG0200')

setcolor(W_COREDIT)

X_MATRIC        := space(05)
X_NOME          := space(40)
X_CODCARGO      := space(02)
X_CODSETOR      := space(02)
X_SALARIO       := 0.00
X_DSR           := space(10)
X_CRGHORMES     := 0.00
X_DAT_NASCM     := ctod('  /  /  ')
X_CODGRAU       := space(02)
X_CODNATURAL    := space(02)
X_CODNACIONA    := space(02)
X_CODCIVIL      := space(02)
X_DEPENDENTE    := space(02)
X_FIL_PAI       := space(45)
X_FIL_MAE       := space(45)
X_ENDERECO      := space(58)
X_BAIRRO        := space(15)
X_CIDADE        := space(20)
X_CODUF         := space(02)
X_CEP           := space(09)
X_TEL_CONTAT    := space(08)
X_CPF           := space(12)
X_IDENTIDADE    := space(12)
X_ORGAO         := space(05)
X_EMISSAO       := ctod('  /  /  ')
X_TIT_ELEIT     := SPACE(12)
X_ZONA          := SPACE(03)
X_SECAO         := SPACE(04)
X_CERT_RESER    := SPACE(15)
X_CART_PROFS    := SPACE(05)
X_SERIE         := SPACE(05)
X_DATA          := ctod('  /  /  ')
X_PIS           := SPACE(11)
X_DATA01        := ctod('  /  /  ')
X_BANCO         := SPACE(06)
X_AGENCIA       := SPACE(06)
X_OPCAO         := SPACE(07)
X_DT_OPCAO      := ctod('  /  /  ')
X_DT_ADM        := ctod('  /  /  ')
X_DT_DEM        := ctod('  /  /  ')
X_STATUS        := space(1)

               
// --> Inicio

abrir("FPG0100")
abrir("FPG0200")
abrir("FPG0300")
abrir("FPG0400")
abrir("FPG0500")
abrir("FPG0600")
abrir("FPG1100")
abrir("FPG1700")
abrir("FPG2000")

While .T.

   tela_200()
   zera_200()

   @ 03,14 get X_MATRIC picture "@!"
   read

   X_MATRIC := zerofill(X_MATRIC)
   @ 03,14 say X_MATRIC

   if lastkey()=K_ESC; exit; end

   if empty( X_MATRIC ) .or. X_MATRIC = "00000"

      m_tabelas("X_MATRIC")
      if lastkey()=K_ESC
         loop
      end

   end

   if lastkey()=K_ESC
      return nil
      end

   FPG0200->( dbseek(X_CODEMP+X_MATRIC) )

   if FPG0200->( found() )
      atribui_200()
      show_200()

      W_RESP := esp_alt()

      do case

      case W_RESP = "*"
         exit

      case W_RESP = "A"
         while .t.
            if get_200()
               if Pergunta('Confirma Dados (S/N) ?')
                  grava_200('A')
                  exit
               end
            else
               exit
            end
         end

      case W_RESP = "E"
         if Pergunta( 'Confirma Exclusao (S/N) ?')
            FPG0200->( dbdelete() )
         end
      end
   else
      while .t.
         get_200()
         if lastkey() = K_ESC
            if Pergunta('Abandona Alteracoes (S/N) ?')
               exit
            end
         end
         if Pergunta('Confirma Dados (S/N) ?')
            grava_200('I')
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
procedure TELA_200()

   Cab_emp_tela()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³ Matric...:      -                                                        ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³ Cargo....:   -                                 Setor:   -                ³'
   @ 06,02 say '³ Salario..:                                                               ³'
   @ 07,02 say '³ D.S.R....:              Carga Horaria..:     Hs   Status:   (Ativ/Demit) ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³ Data Nasc:              Grau Instrucao.:   -                             ³'
   @ 10,02 say '³ Natural..:   -                      Nacionalidade.:   -                  ³'
   @ 11,02 say '³ Est.Civil:   -                      Dependentes...:                      ³'
   @ 12,02 say '³ Filiacao :                                                               ³'
   @ 13,02 say '³                                                                          ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³ Endereco.:                                                               ³'
   @ 16,02 say '³ Bairro...:                   Cidade..:                       Uf.:   -    ³'
   @ 17,02 say '³ Cep......:                   Telefone:                                   ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³ Cpf......:               Rg.:             Exp.:        Dt.Emis:          ³'
   @ 20,02 say '³ T.Eleitor:               Zn.:             Sec.:                          ³'
   @ 21,02 say '³ C.Reserv.:                          Cart.Prof.:       Ser.:              ³'
   @ 22,02 say '³ Pis/Pasep:            Data..:           Banco.:       Ag..:              ³'
   @ 23,02 say '³ E optante:         Dt.Opcao.:           Dt.Adm:                          ³'
   @ 24,02 say '³                                         Dt.Dem:                          ³'
   @ 25,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
                      Funcao GET_200
-----------------------------------------------------------------------------
*/
function get_200()
   local WRET := .T.

   @ 03,22 get X_NOME        picture "@!"
   @ 05,14 get X_CODCARGO    picture "@!"  valid tes_codcargo (05,14)
   @ 05,57 get X_CODSETOR    picture "@!"  valid tes_codsetor (05,57,15)
   @ 06,14 get X_SALARIO     picture "@E 999,999,999.99"
   @ 07,14 get X_DSR         picture "@!"
   @ 07,45 get X_CRGHORMES   picture "@ 999"
   @ 07,62 get X_STATUS      picture "!"   valid X_STATUS $"AD"
   @ 09,14 get X_DAT_NASCM   picture "@ 99/99/99"
   @ 09,44 get X_CODGRAU     picture "@!"  valid tes_codgrau    (09,44)
   @ 10,14 get X_CODNATURAL  picture "@!"  valid tes_codnatural (10,14)
   @ 10,55 get X_CODNACIONA  picture "@!"  valid tes_codnaciona (10,55)
   @ 11,14 get X_CODCIVIL    picture "@!"  valid tes_codcivil   (11,14)
   @ 11,55 get X_DEPENDENTE  picture "@!"
   @ 12,14 get X_FIL_PAI     picture "@!"
   @ 13,14 get X_FIL_MAE     picture "@!"
   @ 15,14 get X_ENDERECO    picture "@!"
   @ 16,14 get X_BAIRRO      picture "@!"
   @ 16,42 get X_CIDADE      picture "@!"
   @ 16,69 get X_CODUF       picture "@!"  valid tes_coduf      (16,69)
   @ 17,14 get X_CEP         picture "@ 99999-999"
   @ 17,42 get X_TEL_CONTAT  picture "@ 999-9999"
   @ 19,14 get X_CPF         picture "@ 999999999-99"
   @ 19,33 get X_IDENTIDADE  picture "@!"
   @ 19,51 get X_ORGAO       picture "@!"
   @ 19,67 get X_EMISSAO     picture "@ 99/99/99"
   @ 20,14 get X_TIT_ELEIT   picture "@ 999999999/99"
   @ 20,33 get X_ZONA        picture "@!"
   @ 20,51 get X_SECAO       picture "@!"
   @ 21,14 get X_CERT_RESER  picture "@ 999999999999999"
   @ 21,51 get X_CART_PROFS  picture "@!"
   @ 21,63 get X_SERIE       picture "@!"
   @ 21,69 get X_DATA        picture "@ 99/99/99"
   @ 22,14 get X_PIS         picture "@!"
   @ 22,33 get X_DATA01      picture "@ 99/99/99"
   @ 22,51 get X_BANCO       picture "@!"
   @ 22,63 get X_AGENCIA     picture "@!"
   @ 23,14 get X_OPCAO       picture "@!"
   @ 23,33 get X_DT_OPCAO    picture "@ 99/99/99"
   @ 23,51 get X_DT_ADM      picture "@ 99/99/99"
   @ 24,51 get X_DT_DEM      picture "@ 99/99/99"

   read

   if lastkey() = K_ESC
      WRET := .F.
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao SHOW_200
-----------------------------------------------------------------------------
*/
procedure SHOW_200()

   @ 03,14 say X_MATRIC        picture "@!"
   @ 03,22 say X_NOME          picture "@!"
   @ 05,14 say X_CODCARGO      picture "@!"
   @ 05,57 say X_CODSETOR      picture "@!"
   @ 06,14 say X_SALARIO       picture "@E 999,999,999.99"
   @ 07,14 say X_DSR           picture "@!"
   @ 07,45 say X_CRGHORMES     picture "@ 999"
   @ 07,62 say X_STATUS        picture "!"
   @ 09,14 say X_DAT_NASCM     picture "@ 99/99/99"
   @ 09,44 say X_CODGRAU       picture "@!"
   @ 10,14 say X_CODNATURAL    picture "@!"
   @ 10,55 say X_CODNACIONA    picture "@!"
   @ 11,14 say X_CODCIVIL      picture "@!"
   @ 11,55 say X_DEPENDENTE    picture "@!"
   @ 12,14 say X_FIL_PAI       picture "@!"
   @ 13,14 say X_FIL_MAE       picture "@!"
   @ 15,14 say X_ENDERECO      picture "@!"
   @ 16,14 say X_BAIRRO        picture "@!"
   @ 16,42 say X_CIDADE        picture "@!"
   @ 16,69 say X_CODUF         picture "@!"
   @ 17,14 say X_CEP           picture "@ 99999-999"
   @ 17,42 say X_TEL_CONTAT    picture "@ 999-9999"
   @ 19,14 say X_CPF           picture "@ 999999999-99"
   @ 19,33 say X_IDENTIDADE    picture "@!"
   @ 19,51 say X_ORGAO         picture "@!"
   @ 19,67 say X_EMISSAO       picture "@ 99/99/99"
   @ 20,14 say X_TIT_ELEIT     picture "@ 999999999/99"
   @ 20,33 say X_ZONA          picture "@!"
   @ 20,51 say X_SECAO         picture "@!"
   @ 21,14 say X_CERT_RESER    picture "@ 999999999999999"
   @ 21,51 say X_CART_PROFS    picture "@!"
   @ 21,63 say X_SERIE         picture "@!"
   @ 21,69 say X_DATA          picture "@ 99/99/99"
   @ 22,14 say X_PIS           picture "@!"
   @ 22,33 say X_DATA01        picture "@ 99/99/99"
   @ 22,51 say X_BANCO         picture "@!"
   @ 22,63 say X_AGENCIA       picture "@!"
   @ 23,14 say X_OPCAO         picture "@!"
   @ 23,33 say X_DT_OPCAO      picture "@ 99/99/99"
   @ 23,51 say X_DT_ADM        picture "@ 99/99/99"
   @ 24,51 say X_DT_DEM        picture "@ 99/99/99"


tes_codcargo   (05,14)
tes_codsetor   (05,57,15)
tes_codgrau    (09,44)
tes_codnatural (10,14)
tes_codnaciona (10,55)
tes_codcivil   (11,14)
tes_coduf      (16,69)
  
return

/*
-----------------------------------------------------------------------------
                      Funcao ZERA_200
-----------------------------------------------------------------------------
*/
procedure zera_200()

X_MATRIC        := space(05)
X_NOME          := space(40)
X_CODCARGO      := space(02)
X_CODSETOR      := space(02)
X_SALARIO       := 0.00
X_DSR           := space(10)
X_CRGHORMES     := 0.00
X_STATUS        := space(01)
X_DAT_NASCM     := ctod('  /  /  ')
X_CODGRAU       := space(02)
X_CODNATURAL    := space(02)
X_CODNACIONA    := space(02)
X_CODCIVIL      := space(02)
X_DEPENDENTE    := space(02)
X_FIL_PAI       := space(45)
X_FIL_MAE       := space(45)
X_ENDERECO      := space(58)
X_BAIRRO        := space(15)
X_CIDADE        := space(20)
X_CODUF         := space(02)
X_CEP           := space(09)
X_TEL_CONTAT    := space(08)
X_CPF           := space(12)
X_IDENTIDADE    := space(12)
X_ORGAO         := space(05)
X_EMISSAO       := ctod('  /  /  ')
X_TIT_ELEIT     := SPACE(12)
X_ZONA          := SPACE(03)
X_SECAO         := SPACE(04)
X_CERT_RESER    := SPACE(15)
X_CART_PROFS    := SPACE(05)
X_SERIE         := SPACE(05)
X_DATA          := ctod('  /  /  ')
X_PIS           := SPACE(11)
X_DATA01        := ctod('  /  /  ')
X_BANCO         := SPACE(06)
X_AGENCIA       := SPACE(06)
X_OPCAO         := SPACE(07)
X_DT_OPCAO      := ctod('  /  /  ')
X_DT_ADM        := ctod('  /  /  ')
X_DT_DEM        := ctod('  /  /  ')

return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI_200
-----------------------------------------------------------------------------
*/
procedure atribui_200()

   X_MATRIC     := FPG0200->MATRIC
   X_NOME       := FPG0200->NOME
   X_CODCARGO   := FPG0200->CODCARGO
   X_CODSETOR   := FPG0200->CODSETOR
   X_SALARIO    := FPG0200->SALARIO
   X_DSR        := FPG0200->DSR
   X_CRGHORMES  := FPG0200->CRGHORMES
   X_STATUS     := FPG0200->STATUS
   X_DAT_NASCM  := FPG0200->DAT_NASCM
   X_CODGRAU    := FPG0200->CODGRAU
   X_CODNATURAL := FPG0200->CODNATURAL
   X_CODNACIONA := FPG0200->CODNACIONA
   X_CODCIVIL   := FPG0200->CODCIVIL
   X_DEPENDENTE := FPG0200->DEPENDENTE
   X_FIL_PAI    := FPG0200->FIL_PAI
   X_FIL_MAE    := FPG0200->FIL_MAE
   X_ENDERECO   := FPG0200->ENDERECO
   X_BAIRRO     := FPG0200->BAIRRO
   X_CIDADE     := FPG0200->CIDADE
   X_CODUF      := FPG0200->CODUF
   X_CEP        := FPG0200->CEP
   X_TEL_CONTAT := FPG0200->TEL_CONTAT
   X_CPF        := FPG0200->CPF
   X_IDENTIDADE := FPG0200->IDENTIDADE
   X_ORGAO      := FPG0200->ORGAO
   X_EMISSAO    := FPG0200->EMISSAO
   X_TIT_ELEIT  := FPG0200->TIT_ELEIT
   X_ZONA       := FPG0200->ZONA
   X_SECAO      := FPG0200->SECAO
   X_CERT_RESER := FPG0200->CERT_RESER
   X_CART_PROFS := FPG0200->CART_PROFS
   X_SERIE      := FPG0200->SERIE
   X_DATA       := FPG0200->DATA
   X_PIS        := FPG0200->PIS
   X_DATA01     := FPG0200->DATA01
   X_BANCO      := FPG0200->BANCO
   X_AGENCIA    := FPG0200->AGENCIA
   X_OPCAO      := FPG0200->OPCAO
   X_DT_OPCAO   := FPG0200->DT_OPCAO
   X_DT_ADM     := FPG0200->DT_ADM
   X_DT_DEM     := FPG0200->DT_DEM

  return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_200()
-----------------------------------------------------------------------------
*/
procedure GRAVA_200( MODO )

   if MODO = "I"
      FPG0200->( dbappend() )
   else
      while FPG0200->( ! rlock() ); end
   end

   FPG0200->CODEMP       := X_CODEMP
   FPG0200->MATRIC       := X_MATRIC
   FPG0200->NOME         := X_NOME
   FPG0200->CODCARGO     := X_CODCARGO
   FPG0200->CODSETOR     := X_CODSETOR
   FPG0200->SALARIO      := X_SALARIO
   FPG0200->DSR          := X_DSR
   FPG0200->CRGHORMES    := X_CRGHORMES
   FPG0200->STATUS       := X_STATUS
   FPG0200->DAT_NASCM    := X_DAT_NASCM
   FPG0200->CODGRAU      := X_CODGRAU
   FPG0200->CODNATURAL   := X_CODNATURAL
   FPG0200->CODNACIONA   := X_CODNACIONA
   FPG0200->CODCIVIL     := X_CODCIVIL
   FPG0200->DEPENDENTE   := X_DEPENDENTE
   FPG0200->FIL_PAI      := X_FIL_PAI
   FPG0200->FIL_MAE      := X_FIL_MAE
   FPG0200->ENDERECO     := X_ENDERECO
   FPG0200->BAIRRO       := X_BAIRRO
   FPG0200->CIDADE       := X_CIDADE
   FPG0200->CODUF        := X_CODUF
   FPG0200->CEP          := X_CEP
   FPG0200->TEL_CONTAT   := X_TEL_CONTAT
   FPG0200->CPF          := X_CPF
   FPG0200->IDENTIDADE   := X_IDENTIDADE
   FPG0200->ORGAO        := X_ORGAO
   FPG0200->EMISSAO      := X_EMISSAO
   FPG0200->TIT_ELEIT    := X_TIT_ELEIT
   FPG0200->ZONA         := X_ZONA
   FPG0200->SECAO        := X_SECAO
   FPG0200->CERT_RESER   := X_CERT_RESER
   FPG0200->CART_PROFS   := X_CART_PROFS
   FPG0200->SERIE        := X_SERIE
   FPG0200->DATA         := X_DATA
   FPG0200->PIS          := X_PIS
   FPG0200->DATA01       := X_DATA01
   FPG0200->BANCO        := X_BANCO
   FPG0200->AGENCIA      := X_AGENCIA
   FPG0200->OPCAO        := X_OPCAO
   FPG0200->DT_OPCAO     := X_DT_OPCAO
   FPG0200->DT_ADM       := X_DT_ADM
   FPG0200->DT_DEM       := X_DT_DEM

/*
-----------------------------------------------------------------------------
                      Funcao TES_CODCARGO
-----------------------------------------------------------------------------
*/
function tes_CODCARGO(lin,col,tam,rel)

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG0300->DESCRICAO), TAM )

   X_CODCARGO      := zerofill(X_CODCARGO)

   FPG0300->( dbsetorder(1) )
   FPG0300->( dbseek( X_CODCARGO ) )

   if FPG0300->( ! found() ) .or. X_CODCARGO = "00" .or. empty(X_CODCARGO)
      m_tabelas("X_CODCARGO")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL    say left(FPG0300->DESCRICAO,TAM)
   else
      if LIN # NIL
         @ LIN     , COL         say        X_CODCARGO
         @ LIN     , COL     + 3 say '- ' + left(FPG0300->DESCRICAO,TAM)
      else
         @ 10,55 say X_CODCARGO
         @ 10,57 say left(FPG0300->DESCRICAO,TAM)
      end
   end

return WRET
                            

/*
-----------------------------------------------------------------------------
                      Funcao TES_CODSETOR
-----------------------------------------------------------------------------
*/
function tes_CODSETOR( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG0500->DESCRICAO), TAM )

   X_CODSETOR      := zerofill(X_CODSETOR)

   FPG0500->( dbsetorder(1) )
   FPG0500->( dbseek( X_CODEMP+X_CODSETOR ) )

   if FPG0500->( ! found() ) .or. X_CODSETOR = "00"
      m_tabelas("X_CODSETOR")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL     say  left(FPG0500->DESCRICAO,TAM)
   else
       
      if LIN # NIL
         @ LIN     , COL         say        X_CODSETOR
         @ LIN     , COL     + 3 say '- ' + left(FPG0500->DESCRICAO,TAM)
      else
         @ 05,57 say X_CODSETOR
         @ 05,59 say left(FPG0500->DESCRICAO,TAM)
      end
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao TES_CODGRAU
-----------------------------------------------------------------------------
*/
function tes_CODGRAU( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG1700->DESCRICAO), TAM )

   X_CODGRAU      := zerofill(X_CODGRAU)

   FPG1700->( dbsetorder(1) )
   FPG1700->( dbseek( X_CODGRAU ) )

   if FPG1700->( ! found() ) .or. X_CODGRAU = "00"
      m_tabelas("X_CODGRAU")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL     say  left(FPG1700->DESCRICAO,TAM)
   else

      if LIN # NIL
         @ LIN     , COL         say        X_CODGRAU
         @ LIN     , COL     + 3 say '- ' + left(FPG1700->DESCRICAO,TAM)
      else
         @ 09,44 say X_CODGRAU
         @ 09,46 say left(FPG1700->DESCRICAO,TAM)
      end
   end

return WRET



/*
-----------------------------------------------------------------------------
                      Funcao TES_CODNATURAL
-----------------------------------------------------------------------------
*/
function tes_CODNATURAL( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG2000->DESCRICAO), TAM )

   X_CODNATURAL      := zerofill(X_CODNATURAL)

   FPG2000->( dbsetorder(1) )
   FPG2000->( dbseek( X_CODNATURAL ) )

   if FPG2000->( ! found() ) .or. X_CODNATURAL = "00"
      m_tabelas("X_CODNATURAL")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL     say  left(FPG2000->DESCRICAO,TAM)
   else

      if LIN # NIL
         @ LIN     , COL         say        X_CODNATURAL
         @ LIN     , COL     + 3 say '- ' + left(FPG2000->DESCRICAO,TAM)
      else
         @ 10,14 say X_CODNATURAL
         @ 10,16 say left(FPG2000->DESCRICAO,TAM)
      end
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao TES_CODNACIONA
-----------------------------------------------------------------------------
*/
function tes_CODNACIONA( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG1100->DESCRICAO), TAM )

   X_CODNACIONA      := zerofill(X_CODNACIONA)

   FPG1100->( dbsetorder(1) )
   FPG1100->( dbseek( X_CODNACIONA ) )

   if FPG1100->( ! found() ) .or. X_CODNACIONA = "00"
      m_tabelas("X_CODNACIONA")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL     say  left(FPG1100->DESCRICAO,TAM)
   else


      if LIN # NIL
         @ LIN     , COL         say        X_CODNACIONA
         @ LIN     , COL     + 3 say '- ' + left(FPG1100->DESCRICAO,TAM)
      else
         @ 04,26 say X_CODNACIONA
         @ 04,28 say left(FPG1100->DESCRICAO,TAM)
      end
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao TES_CODCIVIL
-----------------------------------------------------------------------------
*/
function tes_CODCIVIL( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG0600->DESCRICAO), TAM )

   X_CODCIVIL      := zerofill(X_CODCIVIL)

   FPG0600->( dbsetorder(1) )
   FPG0600->( dbseek( X_CODCIVIL ) )

   if FPG0600->( ! found() ) .or. X_CODCIVIL = "00"
      m_tabelas("X_CODCIVIL")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL     say  left(FPG0600->DESCRICAO,TAM)
   else



      if LIN # NIL
         @ LIN     , COL         say        X_CODCIVIL
         @ LIN     , COL     + 3 say '- ' + left(FPG0600->DESCRICAO,TAM)
      else
         @ 11,14 say X_CODCIVIL
         @ 11,16 say left(FPG0600->DESCRICAO,TAM)
      end
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao TES_CODUF
-----------------------------------------------------------------------------
*/
function tes_CODUF( lin,col,tam,rel )

   local WRET := .T.

   TAM := if(TAM=NIL, len(FPG0400->DESCRICAO), TAM )

   X_CODUF      := zerofill(X_CODUF)

   FPG0400->( dbsetorder(1) )
   FPG0400->( dbseek( X_CODUF ) )

   if FPG0400->( ! found() ) .or. X_CODUF = "00"
      m_tabelas("X_CODUF")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if REL # NIL
      @ LIN     , COL     say  left(FPG0400->DESCRICAO,TAM)
   else

       
      if LIN # NIL
         @ LIN     , COL         say        X_CODUF
         @ LIN     , COL     + 3 say '- ' + left(FPG0400->DESCRICAO,TAM)
      else
         @ 16,69 say X_CODUF
         @ 16,71 say left(FPG0400->DESCRICAO,TAM)
      end
   end

return WRET

/*
-----------------------------------------------------------------------------
                      Funcao TES_STATUS
-----------------------------------------------------------------------------
*/
function tes_status(P_MATRICULA)

Local WRET := .T.
ARQ := alias()

   P_MATRICULA     := zerofill(P_MATRICULA)

   FPG0200->( dbsetorder(1) )
   FPG0200->( dbseek(X_CODEMP+P_MATRICULA) )

   if FPG0200->STATUS != "A"
      WRET := .F.
   end

sele &ARQ
return WRET
