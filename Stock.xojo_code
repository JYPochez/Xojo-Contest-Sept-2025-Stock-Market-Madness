#tag Class
Protected Class Stock
	#tag Method, Flags = &h0
		Sub Constructor(symbol As String, name As String, initialPrice As Double, stockType As StockMarketConstants.eStockType)
		  // Initialize stock with basic properties
		  mSymbol = symbol
		  mName = name
		  mCurrentPrice = initialPrice
		  mLastPrice = initialPrice
		  mOpenPrice = initialPrice
		  mHighPrice = initialPrice
		  mLowPrice = initialPrice
		  mStockType = stockType
		  mVolatility = GetVolatilityForType(stockType)

		  // Initialize price history
		  ReDim mPriceHistory(-1)
		  mPriceHistory.Add(initialPrice)

		  // Set trend and momentum
		  mTrend = StockMarketConstants.eMarketTrend.Sideways
		  mMomentum = 0.0
		  mNewsImpact = 0.0
		  mLastUpdate = DateTime.Now
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetVolatilityForType(stockType As StockMarketConstants.eStockType) As Double
		  // Return appropriate volatility for stock type
		  Select Case stockType
		  Case StockMarketConstants.eStockType.Technology
		    Return 0.03 // 3% volatility
		  Case StockMarketConstants.eStockType.Pharmaceutical
		    Return 0.02 // 2% volatility
		  Case StockMarketConstants.eStockType.Energy
		    Return 0.025 // 2.5% volatility
		  Case StockMarketConstants.eStockType.Cryptocurrency
		    Return 0.05 // 5% volatility (very high)
		  Case StockMarketConstants.eStockType.Banking
		    Return 0.015 // 1.5% volatility (conservative)
		  Case StockMarketConstants.eStockType.Automotive
		    Return 0.028 // 2.8% volatility
		  Case StockMarketConstants.eStockType.Aerospace
		    Return 0.022 // 2.2% volatility
		  Case StockMarketConstants.eStockType.Retail
		    Return 0.035 // 3.5% volatility
		  Case StockMarketConstants.eStockType.RealEstate
		    Return 0.018 // 1.8% volatility
		  Case StockMarketConstants.eStockType.Telecommunications
		    Return 0.016 // 1.6% volatility
		  Else
		    Return 0.02 // Default
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPercentChange() As Double
		  // Calculate percentage change from last price
		  If mLastPrice > 0 Then
		    Return ((mCurrentPrice - mLastPrice) / mLastPrice) * 100.0
		  Else
		    Return 0.0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPriceChangeString() As String
		  // Return formatted price change string
		  Var change As Double = mCurrentPrice - mLastPrice
		  Var percentChange As Double = GetPercentChange()

		  If change > 0 Then
		    Return "+" + Format(change, "0.00") + " (+" + Format(percentChange, "0.00") + "%)"
		  ElseIf change < 0 Then
		    Return Format(change, "0.00") + " (" + Format(percentChange, "0.00") + "%)"
		  Else
		    Return "0.00 (0.00%)"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSymbol() As String
		  Return mSymbol
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  Return mName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCurrentPrice() As Double
		  Return mCurrentPrice
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLastPrice() As Double
		  Return mLastPrice
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStockType() As StockMarketConstants.eStockType
		  Return mStockType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsRising() As Boolean
		  Return mCurrentPrice > mLastPrice
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsFalling() As Boolean
		  Return mCurrentPrice < mLastPrice
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetNewsImpact(impact As Double)
		  // Set news impact on stock price (-1.0 to 1.0)
		  mNewsImpact = impact

		  // News impact affects momentum
		  mMomentum = mMomentum + (impact * 0.5)

		  // Clamp momentum
		  If mMomentum > 1.0 Then mMomentum = 1.0
		  If mMomentum < -1.0 Then mMomentum = -1.0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePrice()
		  // Update stock price with realistic market simulation
		  Try
		    mLastPrice = mCurrentPrice

		    // Random price change based on volatility
		    Var randomFactor As Double = (Rnd - 0.5) * 2.0 // -1.0 to 1.0
		    Var baseChange As Double = randomFactor * mVolatility

		    // Add momentum effect
		    Var momentumEffect As Double = mMomentum * 0.01

		    // Add news impact
		    Var newsEffect As Double = mNewsImpact * 0.02

		    // Calculate total price change
		    Var totalChange As Double = baseChange + momentumEffect + newsEffect

		    // Apply change to current price
		    mCurrentPrice = mCurrentPrice * (1.0 + totalChange)

		    // Ensure price doesn't go below minimum
		    If mCurrentPrice < 1.0 Then mCurrentPrice = 1.0

		    // Update high/low tracking
		    If mCurrentPrice > mHighPrice Then mHighPrice = mCurrentPrice
		    If mCurrentPrice < mLowPrice Then mLowPrice = mCurrentPrice

		    // Add to price history
		    mPriceHistory.Add(mCurrentPrice)

		    // Keep only last 100 price points
		    If mPriceHistory.Count > 100 Then
		      mPriceHistory.RemoveAt(0)
		    End If

		    // Update trend
		    UpdateTrend()

		    // Decay momentum and news impact
		    mMomentum = mMomentum * 0.95
		    mNewsImpact = mNewsImpact * 0.9

		    mLastUpdate = DateTime.Now

		  Catch e As RuntimeException
		    // Error updating price
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateTrend()
		  // Analyze recent price movement to determine trend
		  If mPriceHistory.Count >= 5 Then
		    Var recentPrices() As Double
		    Var startIndex As Integer = Max(0, mPriceHistory.Count - 5)

		    For i As Integer = startIndex To mPriceHistory.LastIndex
		      recentPrices.Add(mPriceHistory(i))
		    Next

		    Var firstPrice As Double = recentPrices(0)
		    Var lastPrice As Double = recentPrices(recentPrices.LastIndex)

		    Var trendChange As Double = (lastPrice - firstPrice) / firstPrice

		    If trendChange > 0.01 Then // Rising more than 1%
		      mTrend = StockMarketConstants.eMarketTrend.Bullish
		    ElseIf trendChange < -0.01 Then // Falling more than 1%
		      mTrend = StockMarketConstants.eMarketTrend.Bearish
		    Else
		      mTrend = StockMarketConstants.eMarketTrend.Sideways
		    End If
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mSymbol As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentPrice As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastPrice As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOpenPrice As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHighPrice As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLowPrice As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStockType As StockMarketConstants.eStockType
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVolatility As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrend As StockMarketConstants.eMarketTrend
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMomentum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNewsImpact As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPriceHistory() As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastUpdate As DateTime
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