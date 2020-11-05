*****************************************************************************
*                                                                           *
* Arquivo  : Ct1006.Prg                Update : 22:26:16  6/11/1992         *
*                                                                           *
* Sistema  : Sistema de contabilidade                                       *
*                                                                           *
* Objetivo : Manutencao de historicos padroes                               *
*                                                                           *
*****************************************************************************

C_Barra  = 'W/N'
C_Menu   = 'W/B'
C_Title  = 'W+/BG+'
C_Borda  = 'N/W,W/N'

Sele 0
Use CTD003 Index CTI00301  Alias Historico

A06_Inicializa()

A06_Processa()

Close

Release All

Return

&&=========================================================================&&

Function A06_Inicializa

Set Delete  On
Set Confirm On
Set Cursor  On
Set Score   Off

Return ''

&&=========================================================================&&

Function A06_Processa

A06_Tela1 (6,20)

Declare campos[2],divisor[2]
Divisor[1]= ''
Divisor[2]= '³'
Campos[1] = 'C_CodHist'
Campos[2] = 'C_Desc'

SetColor (C_Borda)

DbEdit (09,21,19,60,campos,'A06_Funcao','','','',divisor)

Return ''

&&=========================================================================&&

Function  A06_Tela1

Parameters Lin,Col

SetColor (C_Borda)

InitScreen(Lin,Col)

ShowScreen ('ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿',0)
ShowScreen ('³  Cod   ³           Descricao           ³')
ShowScreen ('ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('³        ³                               ³')
ShowScreen ('ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')

setcolor(C_Title)
@ Lin,35 say ' Historico Padrao '

Shadow (Lin,Col,14,41)

A06_1Foot()

Return ('')

&&=========================================================================&&

Function A06_1Foot

Set Color To W+/BG

@ 24,00 Say  Replicate (' ',80);

@ 24,21 Say  'Ins'
@ 24,36 Say  'Del'
@ 24,51 Say  'Esc'

Set Color To /BG

@ 24,24 Say '-Inclusao'
@ 24,39 Say '-Exclusao'
@ 24,54 Say '-Fim'

Return ''

&&=========================================================================&&

Function A06_Funcao

  Parameters Mode,N

  Tec = LastKey()

  Do Case
     // Set Cursor off
     Case Tec = 27
          Return 0

     Case Tec = 22  && Ins inclusao
          A06_Inser()
          Return 2

     Case Tec = 7   && Del exclusao
          If .not. eof()
             If MsgPrompt (' Confirma a exclusao ? ',2)
                dele
                skip
             EndIf
             KeyBoard Chr(13)
             set curso off
          EndIf
          Return 2

  EndCase

Return 1

&&=========================================================================&&

Function A06_Inser

  Do While .t.

     Set Cursor off

     WCod  = Space (08)
     WDesc = Space (30)
     @ 19,21 Say WCod
     @ 19,30 Say WDesc

     @ 19,21 Get WCod  pict "!!!!!!!!"
     Read
     If Empty(WCod) .or. LastKey()=27
        KeyBoard Chr(13)
        Return ('')
     EndIf

     @ 19,21 Say WCod

     Seek Wcod

     If .Not. Eof()
        message("Codigo ja existente")
        loop
     endif

     @ 19,30 Get WDesc pict "@!"
     Read
     If LastKey()=27
        KeyBoard Chr(13)
        Return ('')
     EndIf
     If MsgPrompt(' Confirma a inclusao ? ',1)
        Append Blank
        Replace C_CodHist With WCod
        Replace C_Desc    With WDesc
     EndIf
     Go Top
     Exit
  EndDo

Return ''

&&=========================================================================&&
