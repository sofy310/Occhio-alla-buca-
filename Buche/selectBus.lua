
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require( "json" )
local coinTable = { }
local filePath = system.pathForFile( "coin.json", system.DocumentsDirectory )
local textCoins



table.insert(coinTable, 100)
table.insert(coinTable, 100)


local function loadCoins()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		coinTable = json.decode( contents )
	end

end

local function saveCoins()

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( coinTable ) )
		io.close( file )
	end
end


loadCoins()

table.insert( coinTable, composer.getVariable( "finalCoins" ) )
composer.setVariable( "finalCoins", 0 )

saveCoins()

local function getTotal()
    local totalCoins = 0
    for i = 1, 10000 do
        if ( coinTable[i] ) then
            totalCoins = totalCoins + coinTable[i]
        end
    end

    return totalCoins
end


local function gotoMenu()
	composer.removeScene("menu")
	composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
end

local sfondotitle = display.newImageRect("asfalto.jpg", 800, 1400 )
sfondotitle.x = display.contentCenterX
sfondotitle.y = display.contentCenterY

local widget = require("widget")
	
	local menuButton = widget.newButton
	{
	width = 420,
	height = 160,
	defaultFile = "menu.png",
	}
	menuButton.x = display.contentCenterX
	menuButton.y = 950
	menuButton.destination = "menu"
	menuButton:addEventListener("tap", menuButton)
	menuButton:addEventListener( "tap", gotoMenu )
    
local function showTotalCoins()
    local total = getTotal()
    local imageCoin = display.newImageRect("coin.png", 80, 80)
    imageCoin.x = display.contentCenterX+50
    imageCoin.y = display.contentCenterY-550
    coinsText = display.newText( " ".. total, 575, -40, native.systemFontBold, 55)
    coinsText:setFillColor( 1, 0, 0 )
end


showTotalCoins()




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	


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

