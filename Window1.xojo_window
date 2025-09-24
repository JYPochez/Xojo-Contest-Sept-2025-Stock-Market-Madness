#tag DesktopWindow
Begin DesktopWindow Window1
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   720
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   720
   MaximumWidth    =   1280
   MenuBar         =   1595224063
   MenuBarVisible  =   False
   MinimumHeight   =   720
   MinimumWidth    =   1280
   Resizeable      =   False
   Title           =   "Stock Market Madness"
   Type            =   0
   Visible         =   True
   Width           =   1280
   Begin DesktopCanvas GameCanvas
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   720
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   0
      Transparent     =   False
      Visible         =   True
      Width           =   1280
   End
   Begin Timer GameTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   16
      RunMode         =   2
      TabPanelIndex   =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
   #tag Property, Flags = &h21
      Private mCanvasManager As CanvasManager
   #tag EndProperty

   #tag Property, Flags = &h21
      Private mUseSimpleMode As Boolean = False
   #tag EndProperty

   #tag Property, Flags = &h0
      mInInstructionsScene As Boolean = False
   #tag EndProperty

   #tag Property, Flags = &h0
      mInTradingScene As Boolean = False
   #tag EndProperty

	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Handle keyboard input
		  If mUseSimpleMode Then
		    // Simple mode key handling
		    If key = Chr(27) Then // ESC key
		      Self.Close()
		      Return True
		    End If
		    System.Beep()
		    Return True
		  Else
		    // Normal framework mode
		    Var inputData As New Dictionary
		    inputData.Value("keyPressed") = key
		    System.DebugLog("Window1: Forwarding key input: " + key)

		    // Direct handling for scenes since Router isn't forwarding properly
		    If mInInstructionsScene Then
		      System.DebugLog("Window1: Direct handling for instructions scene")
		      mInInstructionsScene = False
		      Router.SwitchToScene(Router.eGameScene.MainMenu)
		    ElseIf mInTradingScene Then
		      System.DebugLog("Window1: Direct handling for trading scene key input")
		      // Forward directly to trading scene
		      Var currentScene As GameScene = Router.GetCurrentScene()
		      If currentScene <> Nil Then
		        currentScene.HandleInput(inputData)
		      End If
		    Else
		      // Check if we're in main menu and handle directly
		      Var currentScene As GameScene = Router.GetCurrentScene()
		      If currentScene <> Nil Then
		        System.DebugLog("Window1: Direct handling for menu scene key input")
		        currentScene.HandleInput(inputData)
		      Else
		        Router.HandleInputForCurrentScene(inputData)
		      End If
		    End If
		    Return True
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  // Handle mouse input
		  If mUseSimpleMode Then
		    // Simple mode - just beep
		    System.Beep()
		    Return True
		  Else
		    // Normal framework mode
		    System.DebugLog("Window1: Mouse clicked at (" + Str(x) + ", " + Str(y) + ")")
		    Var inputData As New Dictionary
		    inputData.Value("mouseClicked") = True
		    inputData.Value("mouseX") = x
		    inputData.Value("mouseY") = y

		    // Direct handling for scenes since Router isn't forwarding properly
		    If mInInstructionsScene Then
		      System.DebugLog("Window1: Direct mouse handling for instructions scene")
		      mInInstructionsScene = False
		      Router.SwitchToScene(Router.eGameScene.MainMenu)
		    ElseIf mInTradingScene Then
		      System.DebugLog("Window1: Direct handling for trading scene mouse input")
		      // Forward directly to trading scene
		      Var currentScene As GameScene = Router.GetCurrentScene()
		      If currentScene <> Nil Then
		        currentScene.HandleInput(inputData)
		      End If
		    Else
		      System.DebugLog("Window1: Forwarding mouse input to Router")

		      // Check if we're in main menu and handle directly
		      Var currentScene As GameScene = Router.GetCurrentScene()
		      If currentScene <> Nil Then
		        System.DebugLog("Window1: Direct handling for menu scene mouse input")
		        currentScene.HandleInput(inputData)
		      Else
		        Router.HandleInputForCurrentScene(inputData)
		      End If
		    End If
		    Return True
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  // Initialize the application
		  Try
		    System.DebugLog("Starting Stock Market Madness initialization...")

		    // Try Shared Foundations initialization
		    System.DebugLog("Initializing AppTemplate...")
		    AppTemplate.InitializeApplication(Self)

		    System.DebugLog("Creating CanvasManager...")
		    mCanvasManager = New CanvasManager(GameCanvas)

		    System.DebugLog("Creating scenes...")
		    Var menuScene As New StockMarketMenuScene()
		    Var tradingScene As New StockMarketTradingScene()
		    Var instructionsScene As New StockMarketInstructionsScene()

		    System.DebugLog("Registering scenes...")
		    Router.RegisterScene(Router.eGameScene.MainMenu, menuScene)
		    Router.RegisterScene(Router.eGameScene.GamePlay, tradingScene)
		    Router.RegisterScene(Router.eGameScene.HowToPlay, instructionsScene)

		    System.DebugLog("Switching to main menu...")
		    Router.SwitchToScene(Router.eGameScene.MainMenu)

		    System.DebugLog("Stock Market Madness initialization complete!")

		  Catch e As RuntimeException
		    System.DebugLog("Window1.Opening failed: " + e.Message)
		    System.DebugLog("Stack: " + Join(e.Stack, EndOfLine))

		    // Fallback: Use simple direct rendering
		    System.DebugLog("Falling back to simple rendering mode...")
		    mUseSimpleMode = True
		  End Try
		End Sub
	#tag EndEvent


   #tag Method, Flags = &h21
      Private Sub DrawSimpleMenu(g As Graphics)
         // Simple fallback menu when Shared Foundations fails

         // Background
         g.ForeColor = &c2C3E50
         g.FillRectangle(0, 0, 1280, 720)

         // Title
         g.ForeColor = &cECF0F1
         g.TextFont = "Arial"
         g.TextSize = 48
         g.DrawString("Stock Market Madness", 400, 150)

         // Status message
         g.TextSize = 20
         g.ForeColor = &cF39C12
         g.DrawString("Framework Loading Issue - Using Simple Mode", 450, 250)

         // Menu options
         g.ForeColor = &cECF0F1
         g.TextSize = 24
         g.DrawString("1. Start Trading (Not Available)", 500, 350)
         g.DrawString("2. How to Play (Not Available)", 500, 400)
         g.DrawString("3. Exit", 500, 450)

         // Instructions
         g.TextSize = 16
         g.ForeColor = &c95A5A6
         g.DrawString("The Shared Foundations framework could not be loaded.", 450, 550)
         g.DrawString("Please check the debug console for error details.", 450, 580)
         g.DrawString("Press ESC to close the application.", 450, 610)
      End Sub
   #tag EndMethod

#tag EndWindowCode

#tag Events GameCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  // Render the current scene with double buffering
		  Try
		    If mUseSimpleMode Then
		      // Simple fallback mode - draw basic menu
		      DrawSimpleMenu(g)
		    ElseIf mCanvasManager <> Nil Then
		      mCanvasManager.BeginFrame()
		      Var backBufferGraphics As Graphics = mCanvasManager.GetBackBufferGraphics()
		      AppTemplate.RenderFrame(backBufferGraphics)
		      mCanvasManager.EndFrame()
		      g.DrawPicture(mCanvasManager.GetBackBuffer(), 0, 0)
		    Else
		      // Fallback direct rendering
		      AppTemplate.RenderFrame(g)
		    End If
		  Catch e As RuntimeException
		    System.DebugLog("GameCanvas.Paint failed: " + e.Message)
		    System.DebugLog("Stack: " + Join(e.Stack, EndOfLine))

		    // Emergency fallback - draw something so we know it's working
		    g.ForeColor = &cFF0000
		    g.FillRectangle(10, 10, 100, 50)
		    g.ForeColor = &cFFFFFF
		    g.DrawString("ERROR", 20, 40)
		  End Try
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events GameTimer
	#tag Event
		Sub Action()
		  // Update and render at ~60 FPS
		  Try
		    If Not mUseSimpleMode Then
		      Var deltaTime As Double = AppTemplate.CalculateDeltaTime()
		      AppTemplate.UpdateFrame(deltaTime)
		      GameCanvas.Refresh(False)
		    End If
		  Catch e As RuntimeException
		    System.DebugLog("GameTimer.Action failed: " + e.Message)
		    System.DebugLog("Stack: " + Join(e.Stack, EndOfLine))
		  End Try
		End Sub
	#tag EndEvent
#tag EndEvents

