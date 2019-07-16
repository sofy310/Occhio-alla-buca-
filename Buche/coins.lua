
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require( "json" )
local coins
local filePath = system.pathForFile( "coins.json", system.DocumentsDirectory )
local coinsText
local coinsImage
local numeroCoinsText

local function loadCoins()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		coins = json.decode( contents )
	end

	if ( coins == nil ) then
		coins = 0
	end
end

local function saveCoins()
    coins = coins + composer.getVariable( "finalCoins")
	
	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( coins ) )
		io.close( file )
	end
end

local function gotoMenu()
	composer.removeScene("menu")
	composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
end

local widget = require("widget")
	local ButtonUndo = widget.newButton
	{
	width = 160,
    height = 66,
    defaultFile = "undoBlack.png",
	}
	ButtonUndo.x = display.contentCenterX-320
	ButtonUndo.y = -100
	ButtonUndo.destination = "menu"
	ButtonUndo:addEventListener("tap", ButtonUndo)
	ButtonUndo:addEventListener( "tap", gotoMenu)

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
	-- load previous scores
	loadCoins()

    -- insert the saved score from the last game into the table, then reset it
    
	composer.setVariable( "finalCoins", 0 )

	-- save the scores
	saveCoins()

	local background = display.newImageRect("back_grey.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

    coinsImage = display.newImageRect("coin.png", 80, 80 )
    coinsImage.x = display.contentCenterX - 300
    coinsImage.y = display.contentCenterY-610 
    coinsText = display.newText("Coins: ", 260, -100, native.systemFontBold, 70)
    coinsText:setFillColor( 1, 0, 0 )
    numeroCoinsText = display.newText(" ".. coins, 600, -100, native.systemFontBold, 70)
    numeroCoinsText:setFillColor( 1, 0, 0 )
	--local highScoresHeader = display.newText( "High Scores", display.contentCenterX, 100, native.systemFontBold, 55 )
    --highScoresHeader:setFillColor(1, 0, 0)

	

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		ButtonUndo:removeEventListener("tap", ButtonUndo)
		ButtonUndo:removeEventListener( "tap", gotoMenu)
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
