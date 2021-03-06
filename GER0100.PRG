/*
   Sistema gerencial
   GER0100.PRG - Cadastro de Socios

*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('GER0100','GER0100')

setcolor(W_COREDIT)

X_SOCIO       := space(3)
X_NOME        := space(40)
X_CRC         := space(10)
X_IDENTIDADE  := space(09)
X_CPF         := space(11)
X_R_ENDERECO  := space(38)
X_R_BAIRRO    := space(20)
X_R_CEP       := space(8)
X_R_ESTADO    := space(2)
X_R_TEL1      := space(7)
X_R_TEL2      := space(7)
X_R_FAX       := space(7)
X_C_ENDERECO  := space(38)
X_C_BAIRRO    := space(20)
X_C_CEP       := space(8)
X_C_ESTADO    := space(2)
X_C_TEL1      := space(7)
X_C_TEL2      := space(7)
X_C_FAX       := space(7)

// --> Inicio

abrir("GER0100")

While .T.

   tela_11()
   zera_11()

   @ 04,18 get X_SOCIO picture "@!"
   read

   if lastkey()=K_ESC; exit; end
   if empty( X_SOCIO ) .or. X_SOCIO = "000"
      m_tabelas( "X_SOCIO" )
      if lastkey()=K_ESC; exit; end
   end

   if lastkey()=K_ESC
      return nil
      end

   GER0100->( dbseek(X_SOCIO) )

   if GER0100->( found() )
      atribui_11()
      show_11()

      W_RESP := esp_alt()

      do case

      case W_RESP = "*"
         exit

      case W_RESP = "A"
         while .t.
            if get_11()
               if Pergunta('Confirma Dados (S/N) ?')
                  grava_11('A')
                  exit
               end
            else
               exit
            end
         end

      case W_RESP = "E"
         if Pergunta( 'Confirma Exclusao (S/N) ?')
            GER0100->( dbdelete() )
         end
      end
   else
      while .t.
         get_11()
         if lastkey() = K_ESC
            if Pergunta('Abandona Alteracoes (S/N) ?')
               exit
            end
         end
         if Pergunta('Confirma Dados (S/N) ?')
            grava_11('I')
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
procedure TELA_11()

   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�                                                                          �'
   @ 04,02 say '�  Responsavel.:    -                                                      �'
   @ 05,02 say '�                                                                          �'
   @ 06,02 say '�  C.R.C.......:                                                           �'
   @ 07,02 say '�  Identidade..:                                                           �'
   @ 08,02 say '�  C.P.F.......:                                                           �'
   @ 09,02 say '�                                                                          �'
   @ 10,02 say '�  靈컴컴컴컴컴컴컴컴컴컴컴컴� Dados Pessoais 쳐컴컴컴컴컴컴컴컴컴컴컴컴�  �'
   @ 11,02 say '�  � Endereco..:                                       Cep...:          �  �'
   @ 12,02 say '�  � Bairro....:                                       Estado:          �  �'
   @ 13,02 say '�  � Telefone..:     -                                                  �  �'
   @ 14,02 say '�  �                 -                                                  �  �'
   @ 15,02 say '�  � Fax.......:     -                                                  �  �'
   @ 16,02 say '�  픔컴컴컴컴컴컴컴컴컴컴컴캑 Dados Comerciais 쳐컴컴컴컴컴컴컴컴컴컴컴캘  �'
   @ 17,02 say '�  � Endereco..:                                       Cep...:          �  �'
   @ 18,02 say '�  � Bairro....:                                       Estado:          �  �'
   @ 19,02 say '�  � Telefone..:     -                                                  �  �'
   @ 20,02 say '�  �                 -                                                  �  �'
   @ 21,02 say '�  � Fax.......:     -                                                  �  �'
   @ 22,02 say '�  聃컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캭  �'
   @ 23,02 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

return

/*
-----------------------------------------------------------------------------
                      Funcao GET_11
-----------------------------------------------------------------------------
*/
function get_11()
   local WRET := .T.

   @ 04,24 get X_NOME         picture "@!"
   @ 06,18 get X_CRC          picture "@!"
   @ 07,18 get X_IDENTIDADE   picture "@R 99999999/9"
   @ 08,18 get X_CPF          picture "@R 999999999-99" // valid testa_cpf( X_CPF )
   @ 11,18 get X_R_ENDERECO   picture "@!"
   @ 11,64 get X_R_CEP        picture "@R 99999-999"
   @ 12,18 get X_R_BAIRRO     picture "@!"
   @ 12,64 get X_R_ESTADO     picture "@!"
   @ 13,18 get X_R_TEL1       picture "@R 999-9999"
   @ 14,18 get X_R_TEL2       picture "@R 999-9999"
   @ 15,18 get X_R_FAX        picture "@R 999-9999" // when !empty( X_R_FAX )
   @ 17,18 get X_C_ENDERECO   picture "@!"
   @ 17,64 get X_C_CEP        picture "@R 99999-999"
   @ 18,18 get X_C_BAIRRO     picture "@!"
   @ 18,64 get X_C_ESTADO     picture "@!"
   @ 19,18 get X_C_TEL1       picture "@R 999-9999"
   @ 20,18 get X_C_TEL2       picture "@R 999-9999"
   @ 21,18 get X_C_FAX        picture "@R 999-9999" // when !empty( X_C_FAX )




   read

   if lastkey() = K_ESC
      WRET := .F.
   end

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao SHOW_11
-----------------------------------------------------------------------------
*/
procedure SHOW_11()


   @ 04,18 say X_SOCIO        picture "@!"
   @ 04,24 say X_NOME         picture "@!"
   @ 06,18 say X_CRC          picture "@!"
   @ 07,18 say X_IDENTIDADE   picture "@R 99999999/9"
   @ 08,18 say X_CPF          picture "@R 999999999-99" // valid testa_cpf( X_CPF )
   @ 11,18 say X_R_ENDERECO   picture "@!"
   @ 11,64 say X_R_CEP        picture "@R 99999-999"
   @ 12,18 say X_R_BAIRRO     picture "@!"
   @ 12,64 say X_R_ESTADO     picture "@!"
   @ 13,18 say X_R_TEL1       picture "@R 999-9999"
   @ 14,18 say X_R_TEL2       picture "@R 999-9999"
   @ 15,18 say X_R_FAX        picture "@R 999-9999"  // when !empty( X_R_FAX )
   @ 17,18 say X_C_ENDERECO   picture "@!"
   @ 17,64 say X_C_CEP        picture "@R 99999-999"
   @ 18,18 say X_C_BAIRRO     picture "@!"
   @ 18,64 say X_C_ESTADO     picture "@!"
   @ 19,18 say X_C_TEL1       picture "@R 999-9999"
   @ 20,18 say X_C_TEL2       picture "@R 999-9999"
   @ 21,18 say X_C_FAX        picture "@R 999-9999"  // when !empty( X_C_FAX )



return

/*
-----------------------------------------------------------------------------
                      Funcao ZERA_11
-----------------------------------------------------------------------------
*/
procedure zera_11()


X_SOCIO       := space(3)
X_NOME        := space(40)
X_CRC         := space(10)
X_IDENTIDADE  := space(09)
X_CPF         := space(11)
X_R_ENDERECO  := space(38)
X_R_BAIRRO    := space(20)
X_R_CEP       := space(8)
X_R_ESTADO    := space(2)
X_R_TEL1      := space(7)
X_R_TEL2      := space(7)
X_R_FAX       := space(7)
X_C_ENDERECO  := space(38)
X_C_BAIRRO    := space(20)
X_C_CEP       := space(8)
X_C_ESTADO    := space(2)
X_C_TEL1      := space(7)
X_C_TEL2      := space(7)
X_C_FAX       := space(7)


return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI_11
-----------------------------------------------------------------------------
*/
procedure atribui_11()

X_SOCIO       := GER0100->SOCIO
X_NOME        := GER0100->NOME
X_CRC         := GER0100->CRC
X_IDENTIDADE  := GER0100->IDENTIDADE
X_CPF         := GER0100->CPF
X_R_ENDERECO  := GER0100->R_ENDERECO
X_R_BAIRRO    := GER0100->R_BAIRRO
X_R_CEP       := GER0100->R_CEP
X_R_ESTADO    := GER0100->R_ESTADO
X_R_TEL1      := GER0100->R_TEL1
X_R_TEL2      := GER0100->R_TEL2
X_R_FAX       := GER0100->R_FAX
X_C_ENDERECO  := GER0100->C_ENDERECO
X_C_BAIRRO    := GER0100->C_BAIRRO
X_C_CEP       := GER0100->C_CEP
X_C_ESTADO    := GER0100->C_ESTADO
X_C_TEL1      := GER0100->C_TEL1
X_C_TEL2      := GER0100->C_TEL2
X_C_FAX       := GER0100->C_FAX

return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_11()
-----------------------------------------------------------------------------
*/
procedure GRAVA_11( MODO )

   if MODO = "I"
      GER0100->( dbappend() )
   else
      while GER0100->( ! rlock() ); end
   end

   GER0100->SOCIO       :=  X_SOCIO
   GER0100->NOME        :=  X_NOME
   GER0100->CRC         :=  X_CRC
   GER0100->IDENTIDADE  :=  X_IDENTIDADE
   GER0100->CPF         :=  X_CPF
   GER0100->R_ENDERECO  :=  X_R_ENDERECO
   GER0100->R_BAIRRO    :=  X_R_BAIRRO
   GER0100->R_CEP       :=  X_R_CEP
   GER0100->R_ESTADO    :=  X_R_ESTADO
   GER0100->R_TEL1      :=  X_R_TEL1
   GER0100->R_TEL2      :=  X_R_TEL2
   GER0100->R_FAX       :=  X_R_FAX
   GER0100->C_ENDERECO  :=  X_C_ENDERECO
   GER0100->C_BAIRRO    :=  X_C_BAIRRO
   GER0100->C_CEP       :=  X_C_CEP
   GER0100->C_ESTADO    :=  X_C_ESTADO
   GER0100->C_TEL1      :=  X_C_TEL1
   GER0100->C_TEL2      :=  X_C_TEL2
   GER0100->C_FAX       :=  X_C_FAX

return








* --------------------> Fim do meu programa



