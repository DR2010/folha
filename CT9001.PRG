*****************************************************************************
*                                                                           *
* Arquivo  : Ct9001.Prg                 Update : 19:02:55  7/24/1992        *
*                                                                           *
* Sistema  : Sistema integrado de contabilidade                             *
*                                                                           *
* Objetivo : Apuracao/Atualizacao de saldos dos arquivos e documentos       *
*                                                                           *
*****************************************************************************

Set Wrap    On
Set Score   Off
Set Dele    On
Set Confirm On
Set Date Brit

Public SaveColor

SaveColor = SetColor()

E1_01_Inicializa()     && Inicializa parametros de processamento
E1_02_Processa()       && Rotina de processamento

Close Data

Release All

SetColor(SaveColor)

Return

&&=========================================================================&&

Function E1_01_Inicializa

Public W_Arquivo

W_Arquivo = ''

UseCtD004()
UseCtD009()
UseCtD011()

Return ''

&&=========================================================================&&

Function E1_02_Processa

E1_Tela()

Do While LastKey() <> 27

   E1_Totaliza()

   E1_Tela()

EndDo

Return ''

&&=========================================================================&&

Function E1_Tela

  L_Lin = 7
  L_Col = 20

  Titulo = ' Totalizacao dos lancamentos '

  DrawWindow (L_Lin,L_Col,04,36,'B/W','B/W',Titulo)

  @ L_Lin + 2, L_Col + 6  Say 'Arquivo:'


  W_Arquivo = '        '

  @ L_Lin+2,L_Col+14 Get W_Arquivo Pict '@!'  Valid  E1_Valid()

  Read

  If LastKey() = 27
     Return ''
  EndIf

Return ''

&&=========================================================================&&

Function E1_Valid

  Select Arquivo
  Seek W_Arquivo
  If .not. Found()
     Message('Arquivo nao existe.')
     Return .f.
  Endif

Return .t.

&&=========================================================================&&

Function E1_Totaliza

Select Lancamento

Set SoftSeek On
Seek W_Arquivo
Set SoftSeek Off

If D_Arquivo # W_Arquivo
   Message('Nao ha lancamentos para este arquivo.')
   Return ''
EndIf

W_ArqDb = 0
W_ArqCr = 0

Do While (.Not. Eof()) .And. (D_Arquivo = W_Arquivo)

   W_Doc = D_Bloco

   W_DocDb = 0
   W_DocCr = 0

   Do While (.Not. Eof()) .And. (D_Arquivo = W_Arquivo) .And. (D_Bloco = W_Doc)
      If D_DC = 'D'
         W_DocDb = W_DocDb + D_Valor
      Else
         If D_Dc # 'C'
            Message('Lancamento com tipo de lancamento diferente de "D" e "C"')
            Return ''
         Else
            W_DocCr = W_DocCr + D_Valor
         EndIf
      EndIf
      Skip
   EndDo

   W_ArqDb = W_ArqDb + W_DocDb
   W_ArqCr = W_ArqCr + W_DocCr

   Select SaldoDoc

   Seek W_Arquivo + StrZero(W_Doc,3)

   If .Not. Found()
      Append Blank
      Replace K_Arquivo With W_Arquivo
      Replace K_Doc     With W_Doc
   EndIf

   Replace K_Debito  With W_DocDb
   Replace K_Credito With W_DocCr

   Select Lancamento

EndDo

Select Arquivo

Seek W_Arquivo

If .Not. Found()
   Message('Arquivo nao encontrado:' + W_Arquivo)
   Return ''
EndIf

Replace I_Debito  With W_ArqDb
Replace I_Credito With W_ArqCr

Return ''

&&=========================================================================&&
