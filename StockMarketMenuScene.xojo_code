#tag Class
Protected Class StockMarketMenuScene
Inherits GameScene
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize Stock Market Madness Main Menu Scene
		  Super.Constructor("StockMarketMenu")

		  // Initialize menu properties
		  mTitle = StockMarketConstants.kGameTitle
		  mSubtitle = "Trade your way to fortune!"
		  mSelectedOption = 0

		  // Initialize menu options array
		  ReDim mMenuOptions(-1)
		  mMenuOptions.Add("Start Trading")
		  mMenuOptions.Add("Reset Game")
		  mMenuOptions.Add("How to Play")
		  mMenuOptions.Add("Exit")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cleanup()
		  // Clean up menu scene resources
		  mMenuOptions.RemoveAll()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  // Draw main menu UI
		  Try
		    // Draw background with financial theme
		    g.ForeColor = &c1B2631 // Dark financial blue
		    g.FillRectangle(0, 0, 1280, 720)

		    // Draw title
		    g.ForeColor = &cFFFFFF // White
		    g.TextFont = "Arial"
		    g.TextSize = 48
		    g.DrawString("Stock Market Madness", 380, 150)

		    // Draw subtitle
		    g.TextSize = 20
		    g.ForeColor = &c85C1E9 // Light purple
		    g.DrawString("Trade your way to fortune!", 520, 200)

		    // Draw menu options
		    g.TextSize = 28
		    Var options() As String = Array("Start Trading", "Reset Game", "How to Play", "Exit")
		    For i As Integer = 0 To options.Count - 1
		      If i = mSelectedOption Then
		        g.ForeColor = &c2ECC71 // Green for selected (money color)
		      Else
		        g.ForeColor = &cECF0F1 // Light gray for normal
		      End If
		      g.DrawString(options(i), 550, 300 + (i * 50))
		    Next

		    // Draw financial graphics/decorations
		    DrawStockChart(g, 50, 450, 200, 100)
		    DrawStockChart(g, 1030, 450, 200, 100)

		    // Draw instructions
		    g.ForeColor = &c95A5A6 // Gray
		    g.TextSize = 16
		    g.DrawString("Use arrow keys to navigate, Enter to select, ESC to exit", 450, 600)

		    // Draw version info
		    g.TextSize = 14
		    g.DrawString("Stock Market Madness v1.0 - Contest Entry September 2025", 850, 700)

		  Catch e As RuntimeException
		    // Error in drawing routine
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawStockChart(g As Graphics, x As Integer, y As Integer, width As Integer, height As Integer)
		  // Draw a simple stock chart decoration
		  Try
		    // Chart background
		    g.ForeColor = &c34495E
		    g.FillRectangle(x, y, width, height)

		    // Chart border
		    g.ForeColor = &cFFFFFF
		    g.DrawRectangle(x, y, width, height)

		    // Draw sample price line
		    g.ForeColor = &c2ECC71 // Green for rising stock
		    Var points() As Integer
		    points.Add(x + 10)
		    points.Add(y + height - 30)
		    points.Add(x + 30)
		    points.Add(y + height - 45)
		    points.Add(x + 50)
		    points.Add(y + height - 35)
		    points.Add(x + 70)
		    points.Add(y + height - 60)
		    points.Add(x + 90)
		    points.Add(y + height - 70)
		    points.Add(x + 110)
		    points.Add(y + height - 50)
		    points.Add(x + 130)
		    points.Add(y + height - 65)
		    points.Add(x + 150)
		    points.Add(y + height - 80)
		    points.Add(x + 170)
		    points.Add(y + height - 75)
		    points.Add(x + 190)
		    points.Add(y + height - 85)

		    // Draw connecting lines
		    For i As Integer = 0 To points.Count - 4 Step 2
		      g.DrawLine(points(i), points(i + 1), points(i + 2), points(i + 3))
		    Next

		  Catch e As RuntimeException
		    // Error drawing chart
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleInput(inputData As Dictionary)
		  // Handle menu navigation and selection
		  Try
		    If inputData.HasKey("keyPressed") Then
		      Var keyCode As String = inputData.Value("keyPressed")

		      Select Case keyCode
		      Case Chr(28), Chr(30) // Up arrow key codes
		        // Navigate up
		        mSelectedOption = mSelectedOption - 1
		        If mSelectedOption < 0 Then mSelectedOption = 3

		      Case Chr(29), Chr(31) // Down arrow key codes
		        // Navigate down
		        mSelectedOption = mSelectedOption + 1
		        If mSelectedOption > 3 Then mSelectedOption = 0

		      Case Chr(13), Chr(3), " " // Enter, Return, Space
		        // Select current option
		        HandleMenuSelection()

		      Case Chr(27) // Escape key
		        // Exit game
		        Quit()

		      End Select
		    End If

		    If inputData.HasKey("mouseClicked") Then
		      Var mouseX As Integer = inputData.Value("mouseX")
		      Var mouseY As Integer = inputData.Value("mouseY")
		      HandleMouseClick(mouseX, mouseY)
		    End If

		  Catch e As RuntimeException
		    // Error handling input
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleMenuSelection()
		  // Handle menu option selection
		  Select Case mSelectedOption
		  Case 0 // Start Trading
		    StartTrading()
		  Case 1 // Reset Game
		    ResetGame()
		  Case 2 // How to Play
		    ShowHowToPlay()
		  Case 3 // Exit
		    Quit()
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleMouseClick(x As Integer, y As Integer)
		  // Handle mouse clicks on menu options
		  Var startY As Integer = 300
		  Var lineHeight As Integer = 50  // Match drawing spacing

		  For i As Integer = 0 To mMenuOptions.LastIndex
		    Var optionY As Integer = startY + (i * lineHeight)
		    // Check both X and Y coordinates for better click detection
		    If x >= 450 And x <= 830 And y >= optionY - 25 And y <= optionY + 25 Then
		      mSelectedOption = i
		      HandleMenuSelection()
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init()
		  // Initialize menu scene
		  // Clear any scene flags to ensure proper input routing
		  If Window1 <> Nil Then
		    Window1.mInInstructionsScene = False
		    Window1.mInTradingScene = False
		  End If

		  // Ensure menu options are properly initialized
		  ReDim mMenuOptions(-1)
		  mMenuOptions.Add("Start Trading")
		  mMenuOptions.Add("Reset Game")
		  mMenuOptions.Add("How to Play")
		  mMenuOptions.Add("Exit")

		  // Reset selected option
		  mSelectedOption = 0

		  SetInitialized(True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowHowToPlay()
		  // Navigate to How to Play scene
		  System.DebugLog("StockMarketMenuScene: Switching to How to Play scene")

		  // Set flag for Window1 to handle input directly
		  If Window1 <> Nil Then
		    Window1.mInInstructionsScene = True
		  End If

		  Router.SwitchToScene(Router.eGameScene.HowToPlay)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartTrading()
		  // Start new trading session
		  System.DebugLog("StockMarketMenuScene: Switching to trading scene")

		  // Set flag for Window1 to handle input directly
		  If Window1 <> Nil Then
		    Window1.mInTradingScene = True
		  End If

		  Router.SwitchToScene(Router.eGameScene.GamePlay)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ResetGame()
		  // Reset game to initial state
		  System.DebugLog("StockMarketMenuScene: Resetting game")

		  // Get reference to trading scene and reset it
		  Var gameScene As GameScene = Router.GetRegisteredScene(Router.eGameScene.GamePlay)
		  If gameScene <> Nil And gameScene IsA StockMarketTradingScene Then
		    Var tradingScene As StockMarketTradingScene = StockMarketTradingScene(gameScene)
		    tradingScene.ResetGame()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update menu scene (animations, etc.)
		  Try
		    // Could add menu animations here if desired
		    // For now, just update the base scene
		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMenuOptions() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNormalColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedOption As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubtitle As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitle As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitleColor As Color
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass