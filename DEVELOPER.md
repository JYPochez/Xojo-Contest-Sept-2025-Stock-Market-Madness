# Stock Market Madness - Developer Documentation

## Application Architecture

### Project Structure
```
Stock Market Madness.xojo_project
├── App (Class) - Application entry point
├── Window1 (Desktop Window) - Main window with canvas-based UI
├── MainMenuBar (Menu Bar) - Application menu structure
├── StockMarketMenuScene (Class) - Main menu scene management
├── StockMarketTradingScene (Class) - Trading interface and game logic
├── StockMarketInstructionsScene (Class) - How to play scene
├── Stock (Class) - Individual stock data and price simulation
├── Portfolio (Class) - Player holdings and cash management
├── StockMarketConstants (Module) - Game constants and enumerations
└── Shared Foundation Framework:
    ├── GameScene (Base Class) - Scene management base
    ├── Router (Module) - Scene switching and navigation
    ├── CanvasManager (Class) - Canvas rendering utilities
    └── AppTemplate (Module) - Shared application templates
```

## Core Classes and Components

### App (Class)
Main application entry point with Shared Foundation framework integration.

**Key Properties:**
- Inherits from AppTemplate for standardized application structure
- Manages application lifecycle and initialization
- Handles global application state

**Methods:**
```xojo
Sub Open()
  // Application startup, initialize Router and register scenes

Sub EnableMenuItems()
  // Configure menu bar based on application state
```

### Window1 (Desktop Window)
Primary application window with canvas-based rendering and input handling.

**Control Layout:**
- `MainCanvas As DesktopCanvas` - Primary rendering surface (1280×720)
- Scene-based UI rendered via canvas graphics context
- Router system manages scene transitions

**Properties:**
- `mInTradingScene As Boolean` - Trading scene input routing flag
- `mInInstructionsScene As Boolean` - Instructions scene input routing flag

**Key Methods:**
```xojo
Sub Opening()
  // Window initialization, setup canvas and Router

Sub MainCanvas_Paint(g As Graphics, areas() As Rect)
  // Delegate rendering to Router.DrawCurrentScene()

Sub MainCanvas_MouseDown(x As Integer, y As Integer)
  // Route mouse input to current scene via Router

Sub KeyDown(key As String) As Boolean
  // Route keyboard input to current scene via Router

Sub TimerFPS_Action()
  // Main game loop: update scenes and request canvas redraw
```

### StockMarketMenuScene (Class)
Inherits from GameScene base class, manages main menu interface.

**Properties:**
- `mTitle As String` - Game title display
- `mSubtitle As String` - Game subtitle
- `mMenuOptions() As String` - Menu option array
- `mSelectedOption As Integer` - Currently selected menu index

**Key Methods:**
```xojo
Sub Constructor()
  // Initialize menu with 4 options: Start Trading, Reset Game, How to Play, Exit

Sub Draw(g As Graphics)
  // Render menu UI with financial theme, stock chart decorations

Sub HandleInput(inputData As Dictionary)
  // Process keyboard navigation and menu selection

Sub HandleMenuSelection()
  // Execute selected menu action (start game, reset, instructions, exit)

Private Sub StartTrading()
  // Switch to trading scene via Router

Private Sub ResetGame()
  // Reset portfolio to initial state via Router scene access

Private Sub DrawStockChart(g As Graphics, x, y, width, height As Integer)
  // Draw decorative stock chart graphics
```

### StockMarketTradingScene (Class)
Core trading interface implementing the stock market simulation game.

**Properties:**
- `mStocks() As Stock` - Array of 10 available stocks
- `mPortfolio As Portfolio` - Player holdings and cash management
- `mGameState As StockMarketConstants.eGameState` - Current game state
- `mTimeRemaining As Double` - Session countdown timer
- `mSelectedStock As Integer` - Currently selected stock index
- `mTradeQuantity As Integer` - Number of shares for next trade
- `mLastPriceUpdate As DateTime` - Last market update timestamp

**Key Methods:**
```xojo
Sub Constructor()
  // Initialize trading scene with portfolio and stock setup

Sub Draw(g As Graphics)
  // Render complete trading interface: stock list, portfolio, controls, timer

Sub Update(deltaTime As Double)
  // Update stock prices, portfolio values, and game timer

Sub HandleInput(inputData As Dictionary)
  // Process trading controls, stock selection, buy/sell actions

Private Sub SetupStocks()
  // Initialize 10 stocks with realistic starting prices and volatilities

Private Sub DrawStockList(g As Graphics)
  // Render stock price panel with color-coded price changes

Private Sub DrawPortfolio(g As Graphics)
  // Display current holdings and portfolio summary

Private Sub DrawTradingControls(g As Graphics)
  // Render buy/sell buttons and quantity controls

Private Sub DrawGameTimer(g As Graphics)
  // Show remaining session time

Private Sub HandleMouseClick(x As Integer, y As Integer)
  // Process mouse clicks on stocks, buttons, and controls

Private Sub BuyStock()
  // Execute buy order for selected stock

Private Sub SellStock()
  // Execute sell order for selected stock

Sub ResetGame()
  // Reset portfolio and restart trading session
```

### Stock (Class)
Individual stock with realistic price simulation and market behavior.

**Enums (within StockMarketConstants module):**
```xojo
Enum eStockType
  Technology, Pharmaceutical, Energy, Cryptocurrency
  Banking, Automotive, Aerospace, Retail
  RealEstate, Telecommunications
End Enum

Enum eMarketTrend
  Bullish, Bearish, Sideways
End Enum
```

**Properties:**
- `mSymbol As String` - Stock symbol (TECH, PHRM, NRGY, etc.)
- `mName As String` - Full company name
- `mCurrentPrice As Double` - Latest price per share
- `mLastPrice As Double` - Previous price for change calculation
- `mStockType As StockMarketConstants.eStockType` - Stock category
- `mVolatility As Double` - Price movement volatility factor (1.5%-5.0%)
- `mTrend As StockMarketConstants.eMarketTrend` - Current price trend
- `mMomentum As Double` - Price momentum factor (-1.0 to 1.0)
- `mNewsImpact As Double` - Temporary news impact modifier
- `mPriceHistory() As Double` - Last 100 price points for trend analysis

**Key Methods:**
```xojo
Sub Constructor(symbol As String, name As String, initialPrice As Double, stockType As eStockType)
  // Initialize stock with basic properties and volatility

Sub UpdatePrice()
  // Calculate new price using random walk with volatility, momentum, and news impact

Function GetPercentChange() As Double
  // Return percentage change from last price update

Function GetPriceChangeString() As String
  // Return formatted price change display (+$1.23 (+2.45%))

Sub SetNewsImpact(impact As Double)
  // Apply news event impact affecting momentum

Private Function GetVolatilityForType(stockType As eStockType) As Double
  // Return volatility percentage for each stock category

Private Sub UpdateTrend()
  // Analyze recent price history to determine bullish/bearish/sideways trend
```

### Portfolio (Class)
Manages player's cash balance and stock holdings with transaction tracking.

**Properties:**
- `mCash As Double` - Available cash for trading
- `mHoldings As Dictionary` - Stock symbol → quantity owned mapping
- `mTransactionHistory As Dictionary` - Complete trade history
- `mTotalValue As Double` - Cache of portfolio total worth
- `mInitialValue As Double` - Starting portfolio value for P&L calculation

**Key Methods:**
```xojo
Sub Constructor()
  // Initialize with $10,000 starting cash and empty holdings

Function BuyStock(stock As Stock, quantity As Integer) As Boolean
  // Execute buy order if sufficient funds, update cash and holdings

Function SellStock(stock As Stock, quantity As Integer) As Boolean
  // Execute sell order if sufficient shares, update cash and holdings

Function CanAfford(stock As Stock, quantity As Integer) As Boolean
  // Check if player has enough cash for purchase including fees

Function GetSharesOwned(symbol As String) As Integer
  // Return quantity of shares owned for specified stock

Function GetCash() As Double
  // Return current cash balance

Function GetTotalValue() As Double
  // Return total portfolio worth (cash + stock values)

Function GetStockValue() As Double
  // Return value of stock holdings only (excluding cash)

Function GetProfitLoss() As Double
  // Return absolute profit/loss from initial value

Function GetProfitLossPercent() As Double
  // Return percentage return on investment

Sub UpdateTotalValue(stocks() As Stock)
  // Recalculate portfolio value based on current stock prices

Sub Reset()
  // Reset to initial state: $10,000 cash, no holdings

Private Sub RecordTransaction(symbol, action, quantity, price)
  // Log transaction in history for tracking
```

### StockMarketInstructionsScene (Class)
Displays game instructions and controls help.

**Properties:**
- `mInstructionText As String` - Complete instructions content
- `mScrollOffset As Integer` - Text scroll position

**Methods:**
```xojo
Sub Draw(g As Graphics)
  // Render scrollable instructions text with navigation hints

Sub HandleInput(inputData As Dictionary)
  // Handle scroll controls and return to menu
```

### StockMarketConstants (Module)
Centralized game configuration and enumerations.

**Game Constants:**
```xojo
Const kGameTitle = "Stock Market Madness"
Const kStartingCash = 10000.0           // Initial player cash
Const kTradingSessionDuration = 300     // 5 minutes in seconds
Const kPriceUpdateInterval = 3.0        // Seconds between price updates
Const kTransactionFee = 5.0             // Fixed fee per trade
Const kMinTradeQuantity = 1             // Minimum shares per trade
Const kMaxTradeQuantity = 1000          // Maximum shares per trade
```

**UI Layout Constants:**
```xojo
Const kStockListX = 20, kStockListY = 100        // Stock panel position
Const kPortfolioX = 450, kPortfolioY = 100       // Portfolio panel position
Const kNewsX = 880, kNewsY = 100                 // News panel position
Const kBalanceX = 20, kBalanceY = 650            // Balance display position
Const kTimerX = 1000, kTimerY = 20               // Timer position
```

**Enumerations:**
```xojo
Enum eStockType
  Technology, Pharmaceutical, Energy, Cryptocurrency
  Banking, Automotive, Aerospace, Retail
  RealEstate, Telecommunications
End Enum

Enum eGameState
  MainMenu, Trading, Paused, GameOver, Instructions
End Enum

Enum eTradingAction
  Buy, Sell, Hold
End Enum

Enum eMarketTrend
  Bullish, Bearish, Sideways, Volatile
End Enum
```

## Shared Foundation Framework

### Router (Module)
Scene management system for game navigation.

**Key Methods:**
```xojo
Sub RegisterScene(sceneType As eGameScene, scene As GameScene)
  // Register scene instance for later switching

Sub SwitchToScene(newSceneType As eGameScene)
  // Transition to specified scene with cleanup

Function GetRegisteredScene(sceneType As eGameScene) As GameScene
  // Retrieve registered scene instance

Sub DrawCurrentScene(g As Graphics)
  // Delegate rendering to active scene

Sub HandleInputForCurrentScene(inputData As Dictionary)
  // Route input to active scene
```

### GameScene (Base Class)
Abstract base class for all game scenes.

**Properties:**
- `mSceneID As String` - Unique scene identifier
- `mIsInitialized As Boolean` - Scene initialization state

**Abstract Methods:**
```xojo
Sub Draw(g As Graphics)
  // Render scene content (must override)

Sub HandleInput(inputData As Dictionary)
  // Process user input (must override)

Sub Update(deltaTime As Double)
  // Update scene logic (must override)
```

## Technical Implementation

### Market Simulation
- **Realistic Price Models**: Each stock uses geometric Brownian motion with stock-type-specific volatility
- **Trend Analysis**: 5-point moving analysis determines bullish/bearish/sideways trends
- **Momentum System**: Price changes influence future movement direction
- **News Impact Simulation**: Configurable impact factors with decay over time

### User Interface
- **Canvas-Based Rendering**: Full custom UI drawn on 1280×720 canvas
- **Scene Architecture**: Modular scene system with Router for navigation
- **Real-Time Updates**: Stock prices update every 3 seconds with smooth visual transitions
- **Color-Coded Feedback**: Green for rising prices, red for falling, clear profit/loss indicators

### Data Management
- **Dictionary-Based Storage**: Holdings and transactions stored in Xojo Dictionaries
- **Price History Tracking**: Circular buffer of last 100 price points per stock
- **Portfolio Calculation**: Real-time total value updates with separate stock/cash values

### Performance Optimization
- **Efficient Price Updates**: Batch processing of all stock price calculations
- **Limited History**: Price history capped at 100 points to manage memory
- **Selective Rendering**: Only redraw when prices change or user interaction occurs

## Build Configuration

**Target Platform:** Desktop (Windows, macOS, Linux)
**Window Size:** 1280×720 (fixed, windowed)
**Xojo Version:** 2025.r2 or later
**API Version:** API 2.0
**Update Frequency:** 3-second price updates, 60 FPS UI refresh
**Memory Usage:** ~50MB typical, ~100MB maximum

## Game Balance

### Stock Volatility Levels
- **Very Low (1.5-1.8%)**: Banking, Real Estate, Telecommunications
- **Low (2.0-2.5%)**: Pharmaceutical, Energy, Aerospace
- **Moderate (2.8-3.0%)**: Technology, Automotive
- **High (3.5%)**: Retail
- **Very High (5.0%)**: Cryptocurrency

### Economic Factors
- **Transaction Fees**: $5 flat fee encourages strategic trading over rapid churning
- **Price Ranges**: Stocks priced $20-$200 for realistic trading quantities
- **Session Length**: 5 minutes provides urgency while allowing thoughtful decisions
- **Starting Capital**: $10,000 enables diverse portfolio construction

### Risk/Reward Balance
- **Conservative Strategy**: Low volatility stocks for steady 5-15% gains
- **Aggressive Strategy**: High volatility stocks for potential 50%+ gains or losses
- **Diversification Benefits**: Balanced portfolios reduce risk while maintaining growth potential
- **Timing Skills**: 3-second update interval rewards quick decision-making without requiring superhuman reflexes