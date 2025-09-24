#tag Module
Protected Module StockMarketConstants
	#tag Constant, Name = kGameTitle, Type = String, Dynamic = False, Default = \"Stock Market Madness", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kGameVersion, Type = String, Dynamic = False, Default = \"v1.0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kStartingCash, Type = Double, Dynamic = False, Default = \"10000.0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTradingSessionDuration, Type = Integer, Dynamic = False, Default = \"300", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kPriceUpdateInterval, Type = Double, Dynamic = False, Default = \"3.0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kNewsEventInterval, Type = Integer, Dynamic = False, Default = \"15", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTransactionFee, Type = Double, Dynamic = False, Default = \"5.0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kMinTradeQuantity, Type = Integer, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kMaxTradeQuantity, Type = Integer, Dynamic = False, Default = \"1000", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kStockListX, Type = Integer, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kStockListY, Type = Integer, Dynamic = False, Default = \"100", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kPortfolioX, Type = Integer, Dynamic = False, Default = \"450", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kPortfolioY, Type = Integer, Dynamic = False, Default = \"100", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kNewsX, Type = Integer, Dynamic = False, Default = \"880", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kNewsY, Type = Integer, Dynamic = False, Default = \"100", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kBalanceX, Type = Integer, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kBalanceY, Type = Integer, Dynamic = False, Default = \"650", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTimerX, Type = Integer, Dynamic = False, Default = \"1000", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTimerY, Type = Integer, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = eStockType, Type = Integer, Flags = &h0
		Technology
		Pharmaceutical
		Energy
		Cryptocurrency
		Banking
		Automotive
		Aerospace
		Retail
		RealEstate
		Telecommunications
	#tag EndEnum


	#tag Enum, Name = eGameState, Type = Integer, Flags = &h0
		MainMenu
		Trading
		Paused
		GameOver
		Instructions
	#tag EndEnum


	#tag Enum, Name = eTradingAction, Type = Integer, Flags = &h0
		Buy
		Sell
		Hold
	#tag EndEnum


	#tag Enum, Name = eNewsEventType, Type = Integer, Flags = &h0
		Earnings
		Regulatory
		TechBreakthrough
		MarketCrash
		EconomicIndicator
	#tag EndEnum


	#tag Enum, Name = eMarketTrend, Type = Integer, Flags = &h0
		Bullish
		Bearish
		Sideways
		Volatile
	#tag EndEnum


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
End Module
#tag EndModule