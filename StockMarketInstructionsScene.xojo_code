#tag Class
Protected Class StockMarketInstructionsScene
Inherits GameScene
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize Stock Market Instructions Scene
		  Super.Constructor("HowToPlay")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  // Draw instructions screen
		  Try
		    // Background
		    g.ForeColor = &c2C3E50 // Dark blue-gray
		    g.FillRectangle(0, 0, 1280, 720)

		    // Title
		    g.ForeColor = &cECF0F1 // Light gray
		    g.TextFont = "Arial"
		    g.TextSize = 36
		    g.DrawString("How to Play Stock Market Madness", 350, 60)

		    // Instructions content
		    g.TextSize = 18
		    g.ForeColor = &cF8C471 // Gold for headers

		    Var yPos As Integer = 120

		    // Objective
		    g.DrawString("Objective:", 50, yPos)
		    g.ForeColor = &cECF0F1
		    g.TextSize = 16
		    yPos = yPos + 25
		    g.DrawString("Buy low and sell high to maximize your portfolio value within the time limit.", 70, yPos)

		    yPos = yPos + 40
		    g.ForeColor = &cF8C471
		    g.TextSize = 18
		    g.DrawString("Game Mechanics:", 50, yPos)
		    g.ForeColor = &cECF0F1
		    g.TextSize = 16
		    yPos = yPos + 25
		    g.DrawString("• Stock prices update every 1-2 seconds", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• You start with $10,000 in cash", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• News events will affect stock prices", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• Each trade costs $5 in transaction fees", 70, yPos)

		    yPos = yPos + 40
		    g.ForeColor = &cF8C471
		    g.TextSize = 18
		    g.DrawString("Stock Types:", 50, yPos)
		    g.ForeColor = &cECF0F1
		    g.TextSize = 16
		    yPos = yPos + 25
		    g.DrawString("• TECH - Technology stocks (high volatility)", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• PHRM - Pharmaceutical stocks (moderate volatility)", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• NRGY - Energy stocks (affected by oil news)", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• CRYP - Cryptocurrency (extreme volatility)", 70, yPos)

		    yPos = yPos + 40
		    g.ForeColor = &cF8C471
		    g.TextSize = 18
		    g.DrawString("Controls:", 50, yPos)
		    g.ForeColor = &cECF0F1
		    g.TextSize = 16
		    yPos = yPos + 25
		    g.DrawString("• Click stocks to select them", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• Use Buy/Sell buttons to trade", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• Adjust quantity with +/- buttons", 70, yPos)
		    yPos = yPos + 20
		    g.DrawString("• Press ESC to return to main menu", 70, yPos)

		    yPos = yPos + 40
		    g.ForeColor = &cF8C471
		    g.TextSize = 18
		    g.DrawString("Winning:", 50, yPos)
		    g.ForeColor = &cECF0F1
		    g.TextSize = 16
		    yPos = yPos + 25
		    g.DrawString("Your score is your total portfolio value (cash + stock holdings) at the end.", 70, yPos)

		    // Back instruction
		    g.ForeColor = &c95A5A6
		    g.TextSize = 16
		    g.DrawString("Press any key or click anywhere to return to the main menu", 400, 650)

		  Catch e As RuntimeException
		    // Error in drawing
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleInput(inputData As Dictionary)
		  // Return to main menu on any input
		  Try
		    // Any input returns to main menu
		    Router.SwitchToScene(Router.eGameScene.MainMenu)
		  Catch e As RuntimeException
		    // Error handling input
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update instructions scene
		  Try
		    // Nothing to update for static instructions
		  Catch e As RuntimeException
		    // Error in update
		  End Try
		End Sub
	#tag EndMethod


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