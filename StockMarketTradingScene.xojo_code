#tag Class
Protected Class StockMarketTradingScene
Inherits GameScene
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize Stock Market Trading Scene
		  Super.Constructor("Trading")

		  // Initialize trading session
		  mGameState = StockMarketConstants.eGameState.Trading
		  mTimeRemaining = StockMarketConstants.kTradingSessionDuration
		  mSelectedStock = 0
		  mTradeQuantity = 1
		  mLastPriceUpdate = DateTime.Now
		  mLastNewsEvent = DateTime.Now

		  // Initialize portfolio
		  mPortfolio = New Portfolio()

		  // Initialize stocks
		  SetupStocks()

		  // Initialize news messages
		  ReDim mNewsMessages(-1)
		  mCurrentNewsMessage = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cleanup()
		  // Clean up trading scene resources
		  mStocks.RemoveAll()
		  mNewsMessages.RemoveAll()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  // Draw trading interface
		  Try
		    // Draw background
		    g.ForeColor = &c212F3D // Dark trading background
		    g.FillRectangle(0, 0, 1280, 720)

		    // Draw header
		    DrawHeader(g)

		    // Draw stock list
		    DrawStockList(g)

		    // Draw portfolio
		    DrawPortfolio(g)

		    // Draw trading controls
		    DrawTradingControls(g)

		    // Draw news panel
		    DrawNewsPanel(g)

		    // Draw game over overlay if needed
		    If mGameState = StockMarketConstants.eGameState.GameOver Then
		      DrawGameOverOverlay(g)
		    End If

		  Catch e As RuntimeException
		    // Error in drawing routine
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawHeader(g As Graphics)
		  // Draw header with timer and portfolio value
		  Try
		    // Timer
		    g.ForeColor = &cFFFFFF
		    g.TextFont = "Arial"
		    g.TextSize = 24
		    Var timeText As String = "Time: " + FormatTime(mTimeRemaining)
		    g.DrawString(timeText, StockMarketConstants.kTimerX, StockMarketConstants.kTimerY + 24)

		    // Portfolio value
		    g.TextSize = 22
		    g.ForeColor = &c2ECC71 // Green
		    Var valueText As String = "Portfolio: $" + Format(mPortfolio.GetStockValue(), "#,##0.00")
		    g.DrawString(valueText, StockMarketConstants.kBalanceX, StockMarketConstants.kBalanceY)

		    // Cash
		    g.ForeColor = &cF39C12 // Orange
		    Var cashText As String = "Cash: $" + Format(mPortfolio.GetCash(), "#,##0.00")
		    g.DrawString(cashText, StockMarketConstants.kBalanceX, StockMarketConstants.kBalanceY + 25)

		    // Profit/Loss
		    Var profitLoss As Double = mPortfolio.GetProfitLoss()
		    If profitLoss >= 0 Then
		      g.ForeColor = &c2ECC71 // Green for profit
		    Else
		      g.ForeColor = &cE74C3C // Red for loss
		    End If
		    Var plText As String = "P&L: $" + Format(profitLoss, "#,##0.00") + " (" + Format(mPortfolio.GetProfitLossPercent(), "0.00") + "%)"
		    g.DrawString(plText, StockMarketConstants.kBalanceX, StockMarketConstants.kBalanceY + 50)

		  Catch e As RuntimeException
		    // Error drawing header
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawGameOverOverlay(g As Graphics)
		  // Draw game over screen
		  Try
		    // Semi-transparent overlay
		    g.ForeColor = &c000000
		    g.FillRectangle(0, 0, 1280, 720)

		    // Title
		    g.ForeColor = &cFFFFFF
		    g.TextFont = "Arial"
		    g.TextSize = 48
		    g.DrawString("Trading Session Complete!", 350, 200)

		    // Final results
		    g.TextSize = 24
		    g.ForeColor = &c2ECC71
		    g.DrawString("Final Portfolio Value: $" + Format(mPortfolio.GetStockValue(), "#,##0.00"), 420, 280)

		    Var profitLoss As Double = mPortfolio.GetProfitLoss()
		    If profitLoss >= 0 Then
		      g.ForeColor = &c2ECC71 // Green
		      g.DrawString("Total Profit: $" + Format(profitLoss, "#,##0.00"), 450, 320)
		    Else
		      g.ForeColor = &cE74C3C // Red
		      g.DrawString("Total Loss: $" + Format(Abs(profitLoss), "#,##0.00"), 450, 320)
		    End If

		    g.ForeColor = &cF39C12
		    g.DrawString("Return: " + Format(mPortfolio.GetProfitLossPercent(), "0.00") + "%", 490, 360)

		    // Instructions
		    g.ForeColor = &c95A5A6
		    g.TextSize = 18
		    g.DrawString("Press ESC to return to main menu", 500, 450)

		  Catch e As RuntimeException
		    // Error drawing game over
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawNewsPanel(g As Graphics)
		  // Draw news and events panel
		  Try
		    g.ForeColor = &c34495E
		    g.FillRectangle(StockMarketConstants.kNewsX, StockMarketConstants.kNewsY, 380, 200)

		    g.ForeColor = &cFFFFFF
		    g.DrawRectangle(StockMarketConstants.kNewsX, StockMarketConstants.kNewsY, 380, 200)

		    g.TextFont = "Arial"
		    g.TextSize = 18
		    g.DrawString("Market News", StockMarketConstants.kNewsX + 10, StockMarketConstants.kNewsY + 25)

		    g.TextSize = 14
		    g.ForeColor = &cF8C471
		    If mCurrentNewsMessage <> "" Then
		      DrawMultilineText(g, mCurrentNewsMessage, StockMarketConstants.kNewsX + 10, StockMarketConstants.kNewsY + 50, 360, 140)
		    Else
		      g.DrawString("No recent news...", StockMarketConstants.kNewsX + 10, StockMarketConstants.kNewsY + 50)
		    End If

		  Catch e As RuntimeException
		    // Error drawing news panel
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawMultilineText(g As Graphics, text As String, x As Integer, y As Integer, maxWidth As Integer, maxHeight As Integer)
		  // Draw text with word wrapping
		  Try
		    Var words() As String = text.Split(" ")
		    Var currentLine As String = ""
		    Var lineHeight As Integer = 18
		    Var currentY As Integer = y

		    For Each word As String In words
		      Var testLine As String = currentLine
		      If testLine <> "" Then testLine = testLine + " "
		      testLine = testLine + word

		      If g.TextWidth(testLine) > maxWidth And currentLine <> "" Then
		        g.DrawString(currentLine, x, currentY)
		        currentY = currentY + lineHeight
		        currentLine = word
		        If currentY > y + maxHeight Then Exit For
		      Else
		        currentLine = testLine
		      End If
		    Next

		    If currentLine <> "" And currentY <= y + maxHeight Then
		      g.DrawString(currentLine, x, currentY)
		    End If

		  Catch e As RuntimeException
		    // Error drawing multiline text
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawPortfolio(g As Graphics)
		  // Draw portfolio holdings
		  Try
		    g.ForeColor = &c34495E
		    g.FillRectangle(StockMarketConstants.kPortfolioX, StockMarketConstants.kPortfolioY, 400, 300)

		    g.ForeColor = &cFFFFFF
		    g.DrawRectangle(StockMarketConstants.kPortfolioX, StockMarketConstants.kPortfolioY, 400, 300)

		    g.TextFont = "Arial"
		    g.TextSize = 20
		    g.DrawString("Your Holdings", StockMarketConstants.kPortfolioX + 10, StockMarketConstants.kPortfolioY + 25)

		    g.TextSize = 16
		    Var yPos As Integer = StockMarketConstants.kPortfolioY + 50

		    For Each stock As Stock In mStocks
		      Var shares As Integer = mPortfolio.GetSharesOwned(stock.GetSymbol())
		      If shares > 0 Then
		        g.ForeColor = &cECF0F1
		        Var holdingText As String = stock.GetSymbol() + ": " + Str(shares) + " shares"
		        g.DrawString(holdingText, StockMarketConstants.kPortfolioX + 10, yPos)

		        Var value As Double = stock.GetCurrentPrice() * shares
		        Var valueText As String = "$" + Format(value, "#,##0.00")
		        g.DrawString(valueText, StockMarketConstants.kPortfolioX + 250, yPos)

		        yPos = yPos + 20
		      End If
		    Next

		    If yPos = StockMarketConstants.kPortfolioY + 50 Then
		      g.ForeColor = &c95A5A6
		      g.DrawString("No holdings", StockMarketConstants.kPortfolioX + 10, yPos)
		    End If

		  Catch e As RuntimeException
		    // Error drawing portfolio
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawStockList(g As Graphics)
		  // Draw list of stocks with prices
		  Try
		    g.ForeColor = &c34495E
		    g.FillRectangle(StockMarketConstants.kStockListX, StockMarketConstants.kStockListY, 400, 460)

		    g.ForeColor = &cFFFFFF
		    g.DrawRectangle(StockMarketConstants.kStockListX, StockMarketConstants.kStockListY, 400, 460)

		    g.TextFont = "Arial"
		    g.TextSize = 20
		    g.DrawString("Stock Prices", StockMarketConstants.kStockListX + 10, StockMarketConstants.kStockListY + 25)

		    g.TextSize = 16
		    For i As Integer = 0 To mStocks.LastIndex
		      Var stock As Stock = mStocks(i)
		      Var yPos As Integer = StockMarketConstants.kStockListY + 60 + (i * 40)

		      // Highlight selected stock
		      If i = mSelectedStock Then
		        g.ForeColor = &c85C1E9
		        g.FillRectangle(StockMarketConstants.kStockListX + 5, yPos - 15, 390, 30)
		      End If

		      // Stock symbol and name
		      g.ForeColor = &cECF0F1
		      g.DrawString(stock.GetSymbol() + " - " + stock.GetName(), StockMarketConstants.kStockListX + 10, yPos)

		      // Current price
		      g.ForeColor = &c2ECC71
		      Var priceText As String = "$" + Format(stock.GetCurrentPrice(), "0.00")
		      g.DrawString(priceText, StockMarketConstants.kStockListX + 250, yPos)

		      // Price change
		      If stock.IsRising() Then
		        g.ForeColor = &c2ECC71 // Green
		      ElseIf stock.IsFalling() Then
		        g.ForeColor = &cE74C3C // Red
		      Else
		        g.ForeColor = &c95A5A6 // Gray
		      End If
		      g.DrawString(stock.GetPriceChangeString(), StockMarketConstants.kStockListX + 10, yPos + 15)
		    Next

		  Catch e As RuntimeException
		    // Error drawing stock list
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTradingControls(g As Graphics)
		  // Draw buy/sell controls
		  Try
		    Var controlsX As Integer = StockMarketConstants.kPortfolioX
		    Var controlsY As Integer = StockMarketConstants.kPortfolioY + 320

		    // Controls background
		    g.ForeColor = &c34495E
		    g.FillRectangle(controlsX, controlsY, 400, 150)
		    g.ForeColor = &cFFFFFF
		    g.DrawRectangle(controlsX, controlsY, 400, 150)

		    g.TextFont = "Arial"
		    g.TextSize = 20
		    g.DrawString("Trading Controls", controlsX + 10, controlsY + 25)

		    If mStocks.Count > 0 And mSelectedStock >= 0 And mSelectedStock < mStocks.Count Then
		      Var selectedStock As Stock = mStocks(mSelectedStock)

		      g.TextSize = 16
		      g.ForeColor = &cECF0F1
		      g.DrawString("Selected: " + selectedStock.GetSymbol(), controlsX + 10, controlsY + 50)

		      g.DrawString("Quantity: " + Str(mTradeQuantity), controlsX + 10, controlsY + 75)

		      // Buy button
		      g.ForeColor = &c2ECC71
		      g.FillRectangle(controlsX + 10, controlsY + 100, 80, 30)
		      g.ForeColor = &cFFFFFF
		      g.DrawString("BUY", controlsX + 35, controlsY + 120)

		      // Sell button
		      g.ForeColor = &cE74C3C
		      g.FillRectangle(controlsX + 110, controlsY + 100, 80, 30)
		      g.ForeColor = &cFFFFFF
		      g.DrawString("SELL", controlsX + 135, controlsY + 120)

		      // Quantity controls
		      g.ForeColor = &c85C1E9
		      g.FillRectangle(controlsX + 220, controlsY + 100, 30, 30)
		      g.ForeColor = &cFFFFFF
		      g.DrawString("+", controlsX + 232, controlsY + 120)

		      g.ForeColor = &c85C1E9
		      g.FillRectangle(controlsX + 260, controlsY + 100, 30, 30)
		      g.ForeColor = &cFFFFFF
		      g.DrawString("-", controlsX + 272, controlsY + 120)
		    End If

		  Catch e As RuntimeException
		    // Error drawing trading controls
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatTime(seconds As Integer) As String
		  // Format time as MM:SS
		  Var minutes As Integer = seconds \ 60
		  Var secs As Integer = seconds Mod 60
		  Return Format(minutes, "00") + ":" + Format(secs, "00")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateNewsEvent()
		  // Generate random news event
		  Try
		    Var newsEvents() As String
		    newsEvents.Add("TECH sector boosted by AI breakthrough announcement")
		    newsEvents.Add("PHRM stocks rise on FDA approval of new treatment")
		    newsEvents.Add("NRGY prices volatile due to oil supply concerns")
		    newsEvents.Add("CRYP market surges on institutional adoption news")
		    newsEvents.Add("Market volatility increases amid economic uncertainty")
		    newsEvents.Add("TECH earnings exceed analyst expectations")
		    newsEvents.Add("PHRM faces regulatory scrutiny over pricing")
		    newsEvents.Add("NRGY companies report strong quarterly results")
		    newsEvents.Add("CRYP prices swing wildly on regulatory speculation")

		    Var eventIndex As Integer = Rnd * newsEvents.Count
		    mCurrentNewsMessage = newsEvents(eventIndex)

		    // Apply impact to relevant stocks
		    For Each stock As Stock In mStocks
		      Var impact As Double = (Rnd - 0.5) * 0.5 // -0.25 to 0.25
		      stock.SetNewsImpact(impact)
		    Next

		    mLastNewsEvent = DateTime.Now

		  Catch e As RuntimeException
		    // Error generating news
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleInput(inputData As Dictionary)
		  // Handle trading input
		  Try
		    If mGameState <> StockMarketConstants.eGameState.Trading Then
		      // Game over - only accept ESC
		      If inputData.HasKey("keyPressed") Then
		        Var keyCode As String = inputData.Value("keyPressed")
		        If keyCode = Chr(27) Then // ESC
		          Router.SwitchToScene(Router.eGameScene.MainMenu)
		        End If
		      End If
		      Return
		    End If

		    If inputData.HasKey("keyPressed") Then
		      Var keyCode As String = inputData.Value("keyPressed")

		      Select Case keyCode
		      Case Chr(28), Chr(30) // Up arrow
		        mSelectedStock = mSelectedStock - 1
		        If mSelectedStock < 0 Then mSelectedStock = mStocks.LastIndex

		      Case Chr(29), Chr(31) // Down arrow
		        mSelectedStock = mSelectedStock + 1
		        If mSelectedStock > mStocks.LastIndex Then mSelectedStock = 0

		      Case "b", "B" // Buy
		        BuySelectedStock()

		      Case "s", "S" // Sell
		        SellSelectedStock()

		      Case "=", "+" // Increase quantity
		        mTradeQuantity = mTradeQuantity + 1
		        If mTradeQuantity > StockMarketConstants.kMaxTradeQuantity Then mTradeQuantity = StockMarketConstants.kMaxTradeQuantity

		      Case "-", "_" // Decrease quantity
		        mTradeQuantity = mTradeQuantity - 1
		        If mTradeQuantity < StockMarketConstants.kMinTradeQuantity Then mTradeQuantity = StockMarketConstants.kMinTradeQuantity

		      Case Chr(27) // ESC
		        Router.SwitchToScene(Router.eGameScene.MainMenu)

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
		Private Sub HandleMouseClick(x As Integer, y As Integer)
		  // Handle mouse clicks on trading interface
		  Try
		    // Check stock list clicks
		    If x >= StockMarketConstants.kStockListX + 5 And x <= StockMarketConstants.kStockListX + 395 Then
		      For i As Integer = 0 To mStocks.LastIndex
		        Var stockYPos As Integer = StockMarketConstants.kStockListY + 60 + (i * 40)
		        // Check if click is within the stock's clickable area (yPos - 15 to yPos + 15)
		        If y >= stockYPos - 15 And y <= stockYPos + 15 Then
		          mSelectedStock = i
		          Exit For i
		        End If
		      Next
		    End If

		    // Check trading control clicks
		    Var controlsX As Integer = StockMarketConstants.kPortfolioX
		    Var controlsY As Integer = StockMarketConstants.kPortfolioY + 320

		    // Buy button
		    If x >= controlsX + 10 And x <= controlsX + 90 And y >= controlsY + 100 And y <= controlsY + 130 Then
		      BuySelectedStock()
		    End If

		    // Sell button
		    If x >= controlsX + 110 And x <= controlsX + 190 And y >= controlsY + 100 And y <= controlsY + 130 Then
		      SellSelectedStock()
		    End If

		    // Quantity + button
		    If x >= controlsX + 220 And x <= controlsX + 250 And y >= controlsY + 100 And y <= controlsY + 130 Then
		      mTradeQuantity = mTradeQuantity + 1
		      If mTradeQuantity > StockMarketConstants.kMaxTradeQuantity Then mTradeQuantity = StockMarketConstants.kMaxTradeQuantity
		    End If

		    // Quantity - button
		    If x >= controlsX + 260 And x <= controlsX + 290 And y >= controlsY + 100 And y <= controlsY + 130 Then
		      mTradeQuantity = mTradeQuantity - 1
		      If mTradeQuantity < StockMarketConstants.kMinTradeQuantity Then mTradeQuantity = StockMarketConstants.kMinTradeQuantity
		    End If

		  Catch e As RuntimeException
		    // Error handling mouse click
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init()
		  // Initialize trading scene
		  If Window1 <> Nil Then
		    Window1.mInInstructionsScene = False
		    Window1.mInTradingScene = False
		  End If

		  SetInitialized(True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetGame()
		  // Reset the trading session to initial state
		  mGameState = StockMarketConstants.eGameState.Trading
		  mTimeRemaining = StockMarketConstants.kTradingSessionDuration
		  mSelectedStock = 0
		  mTradeQuantity = 1
		  mLastPriceUpdate = DateTime.Now
		  mLastNewsEvent = DateTime.Now
		  mCurrentNewsMessage = ""

		  // Reset portfolio
		  mPortfolio.Reset()

		  // Reset stocks to initial prices
		  SetupStocks()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BuySelectedStock()
		  // Buy the currently selected stock
		  Try
		    If mStocks.Count > 0 And mSelectedStock >= 0 And mSelectedStock < mStocks.Count Then
		      Var stock As Stock = mStocks(mSelectedStock)
		      If mPortfolio.CanAfford(stock, mTradeQuantity) Then
		        Call mPortfolio.BuyStock(stock, mTradeQuantity)
		        System.DebugLog("Bought " + Str(mTradeQuantity) + " shares of " + stock.GetSymbol())
		      End If
		    End If
		  Catch e As RuntimeException
		    // Error buying stock
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SellSelectedStock()
		  // Sell the currently selected stock
		  Try
		    If mStocks.Count > 0 And mSelectedStock >= 0 And mSelectedStock < mStocks.Count Then
		      Var stock As Stock = mStocks(mSelectedStock)
		      If mPortfolio.HasShares(stock.GetSymbol()) Then
		        Var sharesToSell As Integer = Min(mTradeQuantity, mPortfolio.GetSharesOwned(stock.GetSymbol()))
		        Call mPortfolio.SellStock(stock, sharesToSell)
		        System.DebugLog("Sold " + Str(sharesToSell) + " shares of " + stock.GetSymbol())
		      End If
		    End If
		  Catch e As RuntimeException
		    // Error selling stock
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupStocks()
		  // Initialize the 10 stock types
		  Try
		    ReDim mStocks(-1)

		    // Technology stock
		    Var techStock As New Stock("TECH", "TechCorp Inc.", 150.0, StockMarketConstants.eStockType.Technology)
		    mStocks.Add(techStock)

		    // Pharmaceutical stock
		    Var pharmStock As New Stock("PHRM", "PharmaCorp Ltd.", 75.0, StockMarketConstants.eStockType.Pharmaceutical)
		    mStocks.Add(pharmStock)

		    // Energy stock
		    Var energyStock As New Stock("NRGY", "EnergyMax Corp.", 95.0, StockMarketConstants.eStockType.Energy)
		    mStocks.Add(energyStock)

		    // Cryptocurrency
		    Var cryptoStock As New Stock("CRYP", "CryptoCoin Fund", 50.0, StockMarketConstants.eStockType.Cryptocurrency)
		    mStocks.Add(cryptoStock)

		    // Banking stock
		    Var bankStock As New Stock("BANK", "MegaBank Corp.", 120.0, StockMarketConstants.eStockType.Banking)
		    mStocks.Add(bankStock)

		    // Automotive stock
		    Var autoStock As New Stock("AUTO", "DriveMax Motors", 85.0, StockMarketConstants.eStockType.Automotive)
		    mStocks.Add(autoStock)

		    // Aerospace stock
		    Var aeroStock As New Stock("AERO", "SkyTech Aerospace", 180.0, StockMarketConstants.eStockType.Aerospace)
		    mStocks.Add(aeroStock)

		    // Retail stock
		    Var retailStock As New Stock("RETL", "ShopWorld Inc.", 65.0, StockMarketConstants.eStockType.Retail)
		    mStocks.Add(retailStock)

		    // Real Estate stock
		    Var realEstateStock As New Stock("REAL", "PropInvest REIT", 110.0, StockMarketConstants.eStockType.RealEstate)
		    mStocks.Add(realEstateStock)

		    // Telecommunications stock
		    Var telecomStock As New Stock("TCOM", "ConnectGlobal Inc.", 90.0, StockMarketConstants.eStockType.Telecommunications)
		    mStocks.Add(telecomStock)

		  Catch e As RuntimeException
		    // Error setting up stocks
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update trading simulation
		  Try
		    If mGameState <> StockMarketConstants.eGameState.Trading Then
		      Return
		    End If

		    // Update timer
		    mTimeRemaining = mTimeRemaining - deltaTime
		    If mTimeRemaining <= 0 Then
		      mTimeRemaining = 0
		      mGameState = StockMarketConstants.eGameState.GameOver
		      Return
		    End If

		    // Update stock prices
		    Var now As DateTime = DateTime.Now
		    If now.SecondsFrom1970 - mLastPriceUpdate.SecondsFrom1970 >= StockMarketConstants.kPriceUpdateInterval Then
		      For Each stock As Stock In mStocks
		        stock.UpdatePrice()
		      Next
		      mPortfolio.UpdateTotalValue(mStocks)
		      mLastPriceUpdate = now
		    End If

		    // Generate news events
		    If now.SecondsFrom1970 - mLastNewsEvent.SecondsFrom1970 >= StockMarketConstants.kNewsEventInterval Then
		      GenerateNewsEvent()
		    End If

		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mStocks() As Stock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPortfolio As Portfolio
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameState As StockMarketConstants.eGameState
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTimeRemaining As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedStock As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTradeQuantity As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastPriceUpdate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastNewsEvent As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNewsMessages() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentNewsMessage As String
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