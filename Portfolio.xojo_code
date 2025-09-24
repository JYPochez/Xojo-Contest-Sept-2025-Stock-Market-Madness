#tag Class
Protected Class Portfolio
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize portfolio with starting cash
		  mCash = StockMarketConstants.kStartingCash
		  mHoldings = New Dictionary
		  mTransactionHistory = New Dictionary
		  mTotalValue = mCash
		  mInitialValue = mCash
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BuyStock(stock As Stock, quantity As Integer) As Boolean
		  // Attempt to buy stock
		  Try
		    Var totalCost As Double = (stock.GetCurrentPrice() * quantity) + StockMarketConstants.kTransactionFee

		    If mCash >= totalCost Then
		      // Sufficient funds - execute trade
		      mCash = mCash - totalCost

		      // Add to holdings
		      Var symbol As String = stock.GetSymbol()
		      If mHoldings.HasKey(symbol) Then
		        Var currentShares As Integer = mHoldings.Value(symbol)
		        mHoldings.Value(symbol) = currentShares + quantity
		      Else
		        mHoldings.Value(symbol) = quantity
		      End If

		      // Record transaction
		      RecordTransaction(symbol, StockMarketConstants.eTradingAction.Buy, quantity, stock.GetCurrentPrice())

		      Return True
		    Else
		      // Insufficient funds
		      Return False
		    End If

		  Catch e As RuntimeException
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanAfford(stock As Stock, quantity As Integer) As Boolean
		  // Check if player can afford to buy stock
		  Var totalCost As Double = (stock.GetCurrentPrice() * quantity) + StockMarketConstants.kTransactionFee
		  Return mCash >= totalCost
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCash() As Double
		  Return mCash
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSharesOwned(symbol As String) As Integer
		  // Get number of shares owned for a stock
		  If mHoldings.HasKey(symbol) Then
		    Return mHoldings.Value(symbol)
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTotalValue() As Double
		  Return mTotalValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStockValue() As Double
		  // Get value of stock holdings only (excluding cash)
		  Return mTotalValue - mCash
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetProfitLoss() As Double
		  Return mTotalValue - mInitialValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetProfitLossPercent() As Double
		  If mInitialValue > 0 Then
		    Return ((mTotalValue - mInitialValue) / mInitialValue) * 100.0
		  Else
		    Return 0.0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasShares(symbol As String) As Boolean
		  Return GetSharesOwned(symbol) > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Reset portfolio to initial state
		  mCash = StockMarketConstants.kStartingCash
		  mHoldings.RemoveAll()
		  mTransactionHistory.RemoveAll()
		  mTotalValue = mCash
		  mInitialValue = mCash
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RecordTransaction(symbol As String, action As StockMarketConstants.eTradingAction, quantity As Integer, price As Double)
		  // Record transaction for history tracking
		  Try
		    Var transaction As New Dictionary
		    transaction.Value("symbol") = symbol
		    transaction.Value("action") = action
		    transaction.Value("quantity") = quantity
		    transaction.Value("price") = price
		    transaction.Value("timestamp") = DateTime.Now

		    // Use timestamp as key to avoid collisions
		    Var key As String = Format(DateTime.Now.SecondsFrom1970, "0") + "_" + symbol
		    mTransactionHistory.Value(key) = transaction

		  Catch e As RuntimeException
		    // Error recording transaction
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SellStock(stock As Stock, quantity As Integer) As Boolean
		  // Attempt to sell stock
		  Try
		    Var symbol As String = stock.GetSymbol()
		    Var sharesOwned As Integer = GetSharesOwned(symbol)

		    If sharesOwned >= quantity Then
		      // Sufficient shares - execute trade
		      Var totalRevenue As Double = (stock.GetCurrentPrice() * quantity) - StockMarketConstants.kTransactionFee
		      mCash = mCash + totalRevenue

		      // Remove from holdings
		      mHoldings.Value(symbol) = sharesOwned - quantity

		      // Remove entry if no shares left
		      If mHoldings.Value(symbol) = 0 Then
		        mHoldings.Remove(symbol)
		      End If

		      // Record transaction
		      RecordTransaction(symbol, StockMarketConstants.eTradingAction.Sell, quantity, stock.GetCurrentPrice())

		      Return True
		    Else
		      // Insufficient shares
		      Return False
		    End If

		  Catch e As RuntimeException
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateTotalValue(stocks() As Stock)
		  // Update total portfolio value based on current stock prices
		  Try
		    mTotalValue = mCash

		    // Add value of all stock holdings
		    For Each symbol As Variant In mHoldings.Keys
		      Var shares As Integer = mHoldings.Value(symbol)
		      If shares > 0 Then
		        // Find current price for this stock
		        For Each stock As Stock In stocks
		          If stock.GetSymbol() = symbol.StringValue Then
		            mTotalValue = mTotalValue + (stock.GetCurrentPrice() * shares)
		            Exit For stock
		          End If
		        Next
		      End If
		    Next

		  Catch e As RuntimeException
		    // Error updating total value
		  End Try
		End Sub
	#tag EndMethod



	#tag Property, Flags = &h21
		Private mCash As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHoldings As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTransactionHistory As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTotalValue As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialValue As Double
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