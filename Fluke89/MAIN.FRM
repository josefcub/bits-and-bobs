VERSION 2.00
Begin Form Main 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   3  'Fixed Double
   Caption         =   "Fluke 89 Series IV"
   ClientHeight    =   2640
   ClientLeft      =   1365
   ClientTop       =   1575
   ClientWidth     =   5625
   Height          =   3045
   Icon            =   MAIN.FRX:0000
   Left            =   1305
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   2640
   ScaleWidth      =   5625
   Top             =   1230
   Width           =   5745
   Begin CommonDialog CMDialog1 
      DefaultExt      =   "CSV"
      DialogTitle     =   "Save Meter Data As..."
      Left            =   120
      Top             =   2160
   End
   Begin TextBox IntervalText 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   4560
      TabIndex        =   10
      Text            =   "1.0"
      Top             =   2160
      Width           =   855
   End
   Begin Timer Timer1 
      Enabled         =   0   'False
      Interval        =   250
      Left            =   840
      Top             =   2160
   End
   Begin SSPanel ConnectionPanel 
      BackColor       =   &H00C0C0C0&
      BevelInner      =   1  'Inset
      Font3D          =   0  'None
      Height          =   1935
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5415
      Begin SSCommand LogButton 
         Caption         =   "Open Log"
         Font3D          =   0  'None
         Height          =   375
         Left            =   3960
         TabIndex        =   14
         Top             =   120
         Width           =   1335
      End
      Begin SSCommand ConnectButton 
         Caption         =   "Connect"
         Font3D          =   0  'None
         Height          =   375
         Left            =   3960
         TabIndex        =   5
         Top             =   1440
         Width           =   1335
      End
      Begin SSOption Option3D1 
         Caption         =   "COM4"
         Font3D          =   0  'None
         Height          =   375
         Index           =   3
         Left            =   1440
         TabIndex        =   4
         Top             =   1200
         Width           =   975
      End
      Begin SSOption Option3D1 
         Caption         =   "COM3"
         Font3D          =   0  'None
         Height          =   375
         Index           =   2
         Left            =   1440
         TabIndex        =   3
         Top             =   720
         Width           =   975
      End
      Begin SSOption Option3D1 
         Caption         =   "COM2"
         Font3D          =   0  'None
         Height          =   375
         Index           =   1
         Left            =   240
         TabIndex        =   2
         Top             =   1200
         Width           =   975
      End
      Begin SSOption Option3D1 
         Caption         =   "COM1"
         Font3D          =   0  'None
         Height          =   375
         Index           =   0
         Left            =   240
         TabIndex        =   1
         Top             =   720
         Width           =   975
      End
      Begin Label Label2 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Select COM Port"
         Height          =   255
         Left            =   240
         TabIndex        =   15
         Top             =   360
         Width           =   2055
      End
   End
   Begin MSComm MSComm1 
      Interval        =   1000
      Left            =   1440
      RThreshold      =   1
      Top             =   2160
   End
   Begin SSPanel MeterPanel 
      BackColor       =   &H00C0C0C0&
      BevelInner      =   1  'Inset
      Font3D          =   0  'None
      Height          =   1935
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Visible         =   0   'False
      Width           =   5415
      Begin SSCommand PauseButton 
         Caption         =   "Hold"
         Font3D          =   0  'None
         Height          =   375
         Left            =   120
         TabIndex        =   12
         Top             =   1440
         Width           =   1215
      End
      Begin SSCommand DisconnectButton 
         Caption         =   "Disconnect"
         Font3D          =   0  'None
         Height          =   375
         Left            =   4080
         TabIndex        =   7
         Top             =   1440
         Width           =   1215
      End
      Begin Label ReadingLabel 
         Alignment       =   2  'Center
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Caption         =   " "
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Courier New"
         FontSize        =   18
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   495
         Left            =   240
         TabIndex        =   8
         Top             =   720
         Width           =   4935
      End
      Begin Label VersionLabel 
         Alignment       =   2  'Center
         BackColor       =   &H00C0C0C0&
         Caption         =   "Click 'Hold' to pause meter readings."
         Height          =   255
         Left            =   240
         TabIndex        =   9
         Top             =   240
         Width           =   4935
      End
   End
   Begin Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "s"
      Height          =   255
      Left            =   5440
      TabIndex        =   13
      Top             =   2220
      Width           =   3015
   End
   Begin Label QueryLabel 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Update Interval:"
      Height          =   255
      Left            =   1440
      TabIndex        =   11
      Top             =   2220
      Width           =   3015
   End
End
Dim Shared BuffCap$
Dim Shared Paused
Dim Shared Logging


Sub ConnectButton_Click ()
  
  If (IsNumeric(IntervalText.Text) = False) Then
    MsgBox "The Update Interval requires you to only use numbers.  Please enter a numeric value, or accept the default.", 48, "Fluke 89 Series IV"
    IntervalText.Text = "1.0"
    Exit Sub
  End If

  If (IntervalText.Text < .2) Then
    MsgBox "Update interval too high.  Please select a slower update speed.", 48, "Fluke 89 Series IV"
    IntervalText.Text = "1.0"
    Exit Sub
  End If

  MSComm1.PortOpen = True
  ConnectionPanel.Visible = False
  MeterPanel.Visible = True
  IntervalText.Enabled = False
  Timer1.Interval = IntervalText.Text * 1000
  Timer1.Enabled = True

End Sub

Sub DisconnectButton_Click ()
  Timer1.Enabled = False
  MSComm1.PortOpen = False
  MeterPanel.Visible = False
  ConnectionPanel.Visible = True
  IntervalText.Enabled = True
End Sub

Sub LogButton_Click ()

'File Open/Save Dialog Flags
 Const OFN_READONLY = &H1&
 Const OFN_OVERWRITEPROMPT = &H2&
 Const OFN_HIDEREADONLY = &H4&
 Const OFN_NOCHANGEDIR = &H8&
 Const OFN_SHOWHELP = &H10&
 Const OFN_NOVALIDATE = &H100&
 Const OFN_ALLOWMULTISELECT = &H200&
 Const OFN_EXTENSIONDIFFERENT = &H400&
 Const OFN_PATHMUSTEXIST = &H800&
 Const OFN_FILEMUSTEXIST = &H1000&
 Const OFN_CREATEPROMPT = &H2000&
 Const OFN_SHAREAWARE = &H4000&
 Const OFN_NOREADONLYRETURN = &H8000&


  If Logging = False Then

    CmDialog1.Filename = Format$(Now, "yyyymmdd") + ".CSV"
    CmDialog1.DefaultExt = "CSV"
    CmDialog1.InitDir = "C:\DATA"
    CmDialog1.Filter = "Comma Separated Values (*.csv)|*.csv|Text Files (*.txt)|*.txt"
    CmDialog1.Flags = OFN_CREATEPROMPT Or OFN_NOREADONLYRETURN Or OFN_OVERWRITEPROMPT
    CmDialog1.Action = 2
    Open CmDialog1.Filename For Output As #1
    
    LogButton.Caption = "Close Log"
    Logging = True

  Else

    Close #1
    LogButton.Caption = "Open Log"
    Logging = False

  End If


End Sub

Sub MSComm1_OnComm ()
  
  Buffchar$ = MSComm1.Input
  
  If Right$(Buffchar$, 1) = Chr$(13) Then
      
    BuffCap$ = BuffCap$ + Buffchar$
    BuffCap$ = Right$(BuffCap$, Len(BuffCap$) - 5)

    ReadingLabel.Caption = BuffCap$
    WriteLog (BuffCap$)
    BuffCap$ = ""
  
  Else
    
    BuffCap$ = BuffCap$ + Buffchar$

  End If

End Sub

Sub Option3D1_Click (Index As Integer, Value As Integer)
  MSComm1.CommPort = Index + 1
End Sub

Sub PauseButton_Click ()
  
  If Paused = True Then
    Paused = False
    PauseButton.Caption = "Hold"

  Else
    Paused = True
    PauseButton.Caption = "Resume"
  End If

End Sub

Sub Timer1_Timer ()

If Paused = False Then

  If MSComm1.PortOpen = True Then
    MSComm1.Output = "QM" + Chr$(13)
  End If

End If

End Sub

Sub WriteLog (Buffer As String)
  
 If Logging = True Then
   Buffer = Trim$(Buffer)
   If InStr(Buffer, "Out of range") Then Buffer = Chr$(34) + "OL" + Chr$(34)

   Split = InStr(Buffer, " ")
   If Split > 0 Then
     Value$ = Left$(Buffer, Split - 1)
     Units$ = Right$(Buffer, Split - 2)
     Units$ = Left$(Units$, Len(Units$) - 1)
   Else
     Value$ = Buffer
     Units$ = "N/A"
   End If

   Value$ = Trim$(Value$)
   Units$ = Trim$(Units$)

   Print #1, Chr$(34) + Date$ + " " + Time$ + Chr$(34) + "," + Value$ + "," + Chr$(34) + Units$ + Chr$(34)
   'MsgBox Chr$(34) + Date$ + " " + Time$ + Chr$(34) + "," + Value$ + "," + Chr$(34) + Units$ + Chr$(34)
   
 End If

End Sub

