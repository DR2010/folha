/*
   FPG   - Folha de Pagamento
   FPG0100.PRG - Cadastro de Empresa
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('SCE0100','FPG0100')

setcolor(W_COREDIT)

X_CODEMP     := space(03)

X_CGC        := space(14)
X_INSC_MUN   := space(08)
X_ENDERECO   := space(40)
X_CEP        := space(08)
X_BAIRRO     := space(20)
X_ESTADO     := space(20)

X_DDD01      := X_DDD02      := X_DDD03      := X_DDD04      := X_DDD05      := space(04)
X_TELEFONE01 := X_TELEFONE02 := X_TELEFONE03 := X_TELEFONE04 := X_TELEFONE05 := space(07)
X_RAMAL01    := X_RAMAL02    := X_RAMAL03    := X_RAMAL04    := X_RAMAL05    := space(04)
X_CONTATO01  := X_CONTATO02  := X_CONTATO03  := X_CONTATO04  := X_CONTATO05  := space(20)

X_DDDFAX01   := X_DDDFAX02   := space(04)
X_FAX01      := X_FAX02      := space(08)

X_FLAG_FOLHA := space(01)
X_FLAG_GER   := space(01)
X_DIRCONT    := space(05)

X_CEI        := space(12)

X_CODFPAS    := space(02)


// --> Inicio

abrir("FPG0100")
abrir("FPG4000")

While .T.

   tela_100()
   zera_100()

   @ 04,19 get X_CODEMP picture "@!"
   read

   X_CODEMP := zerofill(X_CODEMP)
   @ 04,19 say X_CODEMP

   if lastkey()=K_ESC; exit; end

   if ! (Empresa_ok())
      loop
   end

   if lastkey()=K_ESC
      return nil
      end

   FPG0100->( dbseek(X_CODEMP) )

   if FPG0100->( found() )
      atribui_100()
      show_100()

      W_RESP := esp_alt()

      do case

      case W_RESP = "*"
         exit

      case W_RESP = "A"
         while .t.
            if get_100()
               if Pergunta('Confirma Dados (S/N) ?')
                  grava_100('A')
                  exit
               end
            else
               exit
            end
         end

      case W_RESP = "E"
         if Pergunta( 'Confirma Exclusao (S/N) ?')
            FPG0100->( dbdelete() )
         end
      end
   else
      while .t.
         get_100()
         if lastkey() = K_ESC
            if Pergunta('Abandona Alteracoes (S/N) ?')
               exit
            end
         end
         if Pergunta('Confirma Dados (S/N) ?')
            grava_100('I')
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
procedure TELA_100()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³  Empresa.....:                                                           ³'
   @ 05,02 say '³  Razao Social:                                                           ³'
   @ 06,02 say '³  C.G.C.......:   .   .   /    -      Inscric.Municipal:                  ³'
   @ 07,02 say '³  Endereco....:                                          CEP:      -      ³'
   @ 08,02 say '³  Bairro......:                       Estado:                             ³'
   @ 09,02 say '³  Telefone: (    )    -      Ramal:       Contato:                        ³'
   @ 10,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 11,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 12,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 13,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 14,02 say '³  Fax     : (    )    -      Fax  :(    )   -                             ³'
   @ 15,02 say '³  Cei..........:                         Cod.Atividade.:                  ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³  - SISTEMA -                                                             ³'
   @ 18,02 say '³  Folha de Pgto:                                                          ³'
   @ 19,02 say '³  Contabilidade:                                                          ³'
   @ 20,02 say '³  Gerencia.....:                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
                      Funcao GET_100
-----------------------------------------------------------------------------
*/
function get_100()
   local WRET := .T.

   @ 05,19 get X_RAZAO        picture "@!"
   @ 06,19 get X_CGC          picture "@R 99.999.999/9999-99" valid testa_cgc( X_CGC )

   @ 06,60 get X_INSC_MUN     picture "@R 99.999.999"
   @ 07,19 get X_ENDERECO     picture "@!"
   @ 07,65 get X_CEP          picture "@R 99999-999"
   @ 08,19 get X_BAIRRO       picture "@!"
   @ 08,49 get X_ESTADO       picture "@!"

   begin sequence
   @ 09,16 get X_DDD01        picture "9999"
   @ 09,22 get X_TELEFONE01   picture "@R 999-9999"
   @ 09,39 get X_RAMAL01      picture "9999"
   @ 09,54 get X_CONTATO01    picture "@!"
   @ 10,16 get X_DDD02        picture "9999"
   @ 10,22 get X_TELEFONE02   picture "@R 999-9999"
   @ 10,39 get X_RAMAL02      picture "9999"
   @ 10,54 get X_CONTATO02    picture "@!"
   @ 11,16 get X_DDD03        picture "9999"
   @ 11,22 get X_TELEFONE03   picture "@R 999-9999"
   @ 11,39 get X_RAMAL03      picture "9999"
   @ 11,54 get X_CONTATO03    picture "@!"
   @ 12,16 get X_DDD04        picture "9999"
   @ 12,22 get X_TELEFONE04   picture "@R 999-9999"
   @ 12,39 get X_RAMAL04      picture "9999"
   @ 12,54 get X_CONTATO04    picture "@!"
   @ 13,16 get X_DDD05        picture "9999"
   @ 13,22 get X_TELEFONE05   picture "@R 999-9999"
   @ 13,39 get X_RAMAL05      picture "9999"
   @ 13,54 get X_CONTATO05    picture "@!"
   @ 14,16 get X_DDDFAX01     picture "9999"
  
   end seguence

   @ 14,22 get X_FAX01        picture "@ 999-9999"  when !empty( X_DDDFAX01 )
   @ 14,39 get X_DDDFAX02     picture "9999"
   @ 14,45 get X_FAX02        picture "@ 999-9999"  when !empty( X_DDDFAX02 )

   @ 15,20 get X_CEI          picture "@!"
   @ 15,60 get X_CODFPAS      picture "@!"valid tes_codfpas(15,60,15)


   @ 18,20 get X_FLAG_FOLHA   picture "@!" valid X_FLAG_FOLHA  = 'X' .or. X_FLAG_FOLHA  = ' '
   @ 19,20 get X_DIRCONT      picture "@!"
   @ 20,20 get X_FLAG_GER     picture "@!" valid X_FLAG_GER    = 'X' .or. X_FLAG_GER    = ' '

   read

   if lastkey() = K_ESC
      WRET := .F.
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao SHOW_100
-----------------------------------------------------------------------------
*/
procedure SHOW_100()

  if !empty(X_CODFPAS)
     tes_codfpas(15,60,15)
  end
   @ 04,19 say X_CODEMP       picture "@!"
   @ 05,19 say X_RAZAO        picture "@!"
   @ 06,19 say X_CGC          picture "@R 99.999.999/9999-99"
   @ 06,60 say X_INSC_MUN     picture "@R 99.999.999"
   @ 07,19 say X_ENDERECO     picture "@!"
   @ 07,65 say X_CEP          picture "@R 99999-999"
   @ 08,19 say X_BAIRRO       picture "@!"
   @ 08,49 say X_ESTADO       picture "@!"
   @ 09,16 say X_DDD01        picture "9999"
   @ 09,22 say X_TELEFONE01   picture "@R 999-9999"
   @ 09,39 say X_RAMAL01      picture "9999"
   @ 09,54 say X_CONTATO01    picture "@!"
   @ 10,16 say X_DDD02        picture "9999"
   @ 10,22 say X_TELEFONE02   picture "@R 999-9999"
   @ 10,39 say X_RAMAL02      picture "9999"
   @ 10,54 say X_CONTATO02    picture "@!"
   @ 11,16 say X_DDD03        picture "9999"
   @ 11,22 say X_TELEFONE03   picture "@R 999-9999"
   @ 11,39 say X_RAMAL03      picture "9999"
   @ 11,54 say X_CONTATO03    picture "@!"
   @ 12,16 say X_DDD04        picture "9999"
   @ 12,22 say X_TELEFONE04   picture "@R 999-9999"
   @ 12,39 say X_RAMAL04      picture "9999"
   @ 12,54 say X_CONTATO04    picture "@!"
   @ 13,16 say X_DDD05        picture "9999"
   @ 13,22 say X_TELEFONE05   picture "@R 999-9999"
   @ 13,39 say X_RAMAL05      picture "9999"
   @ 13,54 say X_CONTATO05    picture "@!"
   @ 14,16 say X_DDDFAX01     picture "9999"
   @ 14,22 say X_FAX01        picture "@ 999-9999"
   @ 14,39 say X_DDDFAX02     picture "9999"
   @ 14,48 say X_FAX02        picture "@ 999-9999"
   @ 15,20 say X_CEI          picture "@!"
   @ 15,60 say X_CODFPAS      picture "@!"
   @ 18,20 say X_FLAG_FOLHA   picture "@!"
   @ 19,20 say X_DIRCONT      picture "@!"
   @ 20,20 say X_FLAG_GER     picture "@!"


return

/*
-----------------------------------------------------------------------------
                      Funcao ZERA_100
-----------------------------------------------------------------------------
*/
procedure zera_100()

X_CGC        := space(14)
X_INSC_MUN   := space(08)
X_ENDERECO   := space(40)
X_CEP        := space(08)
X_BAIRRO     := space(20)
X_ESTADO     := space(20)

X_DDD01      := X_DDD02      := X_DDD03      := X_DDD04      := X_DDD05      := space(04)
X_TELEFONE01 := X_TELEFONE02 := X_TELEFONE03 := X_TELEFONE04 := X_TELEFONE05 := space(07)
X_RAMAL01    := X_RAMAL02    := X_RAMAL03    := X_RAMAL04    := X_RAMAL05    := space(04)
X_CONTATO01  := X_CONTATO02  := X_CONTATO03  := X_CONTATO04  := X_CONTATO05  := space(20)

X_DDDFAX01   := X_DDDFAX02   := space(04)
X_FAX01      := X_FAX02      := space(08)

X_FLAG_FOLHA := space(01)
X_DIRCONT    := space(05)
X_FLAG_GER   := space(01)

X_CEI        := space(12)

X_CODFPAS    := space(02)

return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI_100
-----------------------------------------------------------------------------
*/
procedure atribui_100()

   X_CODEMP     := FPG0100->CODEMP

   X_RAZAO      := FPG0100->RAZAO
   X_CGC        := FPG0100->CGC
   X_INSC_MUN   := FPG0100->INSC_MUN
   X_ENDERECO   := FPG0100->ENDERECO
   X_CEP        := FPG0100->CEP
   X_BAIRRO     := FPG0100->BAIRRO
   X_ESTADO     := FPG0100->ESTADO
   X_DDD01      := FPG0100->DDD01
   X_TELEFONE01 := FPG0100->TELEFONE01
   X_RAMAL01    := FPG0100->RAMAL01
   X_CONTATO01  := FPG0100->CONTATO01
   X_DDD02      := FPG0100->DDD02
   X_TELEFONE02 := FPG0100->TELEFONE02
   X_RAMAL02    := FPG0100->RAMAL02
   X_CONTATO02  := FPG0100->CONTATO03
   X_DDD03      := FPG0100->DDD03
   X_TELEFONE03 := FPG0100->TELEFONE03
   X_RAMAL03    := FPG0100->RAMAL03
   X_CONTATO03  := FPG0100->CONTATO03
   X_DDD04      := FPG0100->DDD04
   X_TELEFONE04 := FPG0100->TELEFONE04
   X_RAMAL04    := FPG0100->RAMAL04
   X_CONTATO04  := FPG0100->CONTATO04
   X_DDD05      := FPG0100->DDD05
   X_TELEFONE05 := FPG0100->TELEFONE05
   X_RAMAL05    := FPG0100->RAMAL05
   X_CONTATO05  := FPG0100->CONTATO05
   X_DDDFAX01   := FPG0100->DDDFAX01
   X_FAX01      := FPG0100->FAX01
   X_DDDFAX02   := FPG0100->DDDFAX02
   X_FAX02      := FPG0100->FAX02
   X_FLAG_FOLHA := FPG0100->FLAG_FOLHA
   X_DIRCONT    := FPG0100->DIRCONT
   X_FLAG_GER   := FPG0100->FLAG_GER
   X_CEI        := FPG0100->CEI
   X_CODFPAS    := FPG0100->CODFPAS
return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_100()
-----------------------------------------------------------------------------
*/
procedure GRAVA_100( MODO )

   if MODO = "I"
      FPG0100->( dbappend() )
   else
      while FPG0100->( ! rlock() ); end
   end

   FPG0100->CODEMP     := X_CODEMP
   FPG0100->RAZAO      := X_RAZAO
   FPG0100->CGC        := X_CGC
   FPG0100->INSC_MUN   := X_INSC_MUN
   FPG0100->ENDERECO   := X_ENDERECO
   FPG0100->CEP        := X_CEP
   FPG0100->BAIRRO     := X_BAIRRO
   FPG0100->ESTADO     := X_ESTADO
   FPG0100->DDD01      := X_DDD01
   FPG0100->TELEFONE01 := X_TELEFONE01
   FPG0100->RAMAL01    := X_RAMAL01
   FPG0100->CONTATO01  := X_CONTATO01
   FPG0100->DDD02      := X_DDD02
   FPG0100->TELEFONE02 := X_TELEFONE02
   FPG0100->RAMAL02    := X_RAMAL02
   FPG0100->CONTATO03  := X_CONTATO02
   FPG0100->DDD03      := X_DDD03
   FPG0100->TELEFONE03 := X_TELEFONE03
   FPG0100->RAMAL03    := X_RAMAL03
   FPG0100->CONTATO03  := X_CONTATO03
   FPG0100->DDD04      := X_DDD04
   FPG0100->TELEFONE04 := X_TELEFONE04
   FPG0100->RAMAL04    := X_RAMAL04
   FPG0100->CONTATO04  := X_CONTATO04
   FPG0100->DDD05      := X_DDD05
   FPG0100->TELEFONE05 := X_TELEFONE05
   FPG0100->RAMAL05    := X_RAMAL05
   FPG0100->CONTATO05  := X_CONTATO05
   FPG0100->DDDFAX01   := X_DDDFAX01
   FPG0100->FAX01      := X_FAX01
   FPG0100->DDDFAX02   := X_DDDFAX02
   FPG0100->FAX02      := X_FAX02
   FPG0100->FLAG_FOLHA := X_FLAG_FOLHA
   FPG0100->DIRCONT    := X_DIRCONT
   FPG0100->FLAG_GER   := X_FLAG_GER
   FPG0100->CEI        := X_CEI
   FPG0100->CODFPAS    := X_CODFPAS

return
* ----------> Fim do meu programa




