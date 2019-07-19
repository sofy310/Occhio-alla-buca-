
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require( "json" )
local scoreTable = {}
local filePath = system.pathForFile( "score.json", system.DocumentsDirectory )

local function loadScores()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoreTable = json.decode( contents )
	end

	if ( scoreTable == nil or #scoreTable == 0 ) then
		scoreTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end
end

local function saveScores()
	for i = #scoreTable, 11, -1 do 
		table.remove(scoreTable, i)
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoreTable ) )
		io.close( file )
	end
end

local function gotoMenu()
	composer.removeScene("menu")
	composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
end

	-- load previous scores
	loadScores()

	-- insert the saved score from the last game into the table, then reset it
	table.insert( scoreTable, composer.getVariable( "finalScore" ) )
	composer.setVariable( "finalScore", 0 )

	-- sort the tabe entries from highest to lowest
	local function compare( a, b )
		return a > b
	end
	table.sort( scoreTable, compare )

	-- save the scores
	saveScores()

	local background = display.newImageRect( "highscores/background.jpg", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect("highscores/highscores_title.png", 650, 200)
	title.x = display.contentCenterX
	title.y = display.contentCenterY-550

	local rankNum1 = display.newImageRect("highscores/1.png", 100, 100)
	rankNum1.x = display.contentCenterX -40
	rankNum1.y = 150 
	rankNum1.anchorX = 1
	local thisScore1 = display.newText( scoreTable[1], display.contentCenterX - 10, 150, native.systemFontBold, 70 )
	thisScore1:setFillColor( 0.9, 0, 0.2 )
	thisScore1.anchorX = 0

	local rankNum2 = display.newImageRect("highscores/2.png", 100, 100)
	rankNum2.x = display.contentCenterX -40
	rankNum2.y = 260 
	rankNum2.anchorX = 1
	local thisScore2 = display.newText( scoreTable[2], display.contentCenterX - 10, 260, native.systemFontBold, 70 )
	thisScore2:setFillColor( 0.9, 0, 0.2 )
	thisScore2.anchorX = 0
	
	local rankNum3 = display.newImageRect("highscores/3.png", 100, 100)
	rankNum3.x = display.contentCenterX -40
	rankNum3.y = 370 
	rankNum3.anchorX = 1
	local thisScore3 = display.newText( scoreTable[3], display.contentCenterX - 10, 370, native.systemFontBold, 70 )
	thisScore3:setFillColor( 0.9, 0, 0.2 )
	thisScore3.anchorX = 0

	local rankNum4 = display.newImageRect("highscores/4.png", 100, 100)
	rankNum4.x = display.contentCenterX -40
	rankNum4.y = 480 
	rankNum4.anchorX = 1
	local thisScore4 = display.newText( scoreTable[4], display.contentCenterX - 10, 480, native.systemFontBold, 70 )
	thisScore4:setFillColor( 0.9, 0, 0.2 )
	thisScore4.anchorX = 0

	local rankNum5 = display.newImageRect("highscores/5.png", 100, 100)
	rankNum5.x = display.contentCenterX -40
	rankNum5.y = 590 
	rankNum5.anchorX = 1
	local thisScore5 = display.newText( scoreTable[5], display.contentCenterX - 10, 590, native.systemFontBold, 70 )
	thisScore5:setFillColor( 0.9, 0, 0.2 )
	thisScore5.anchorX = 0

	local rankNum6 = display.newImageRect("highscores/6.png", 100, 100)
	rankNum6.x = display.contentCenterX -40
	rankNum6.y = 700 
	rankNum6.anchorX = 1
	local thisScore6 = display.newText( scoreTable[6], display.contentCenterX - 10, 700, native.systemFontBold, 70 )
	thisScore6:setFillColor( 0.9, 0, 0.2 )
	thisScore6.anchorX = 0

	local rankNum7 = display.newImageRect("highscores/7.png", 100, 100)
	rankNum7.x = display.contentCenterX -40
	rankNum7.y = 810 
	rankNum7.anchorX = 1
	local thisScore7 = display.newText( scoreTable[7], display.contentCenterX - 10, 810, native.systemFontBold, 70 )
	thisScore7:setFillColor( 0.9, 0, 0.2 )
	thisScore7.anchorX = 0


	local widget = require("widget")
	
	local menuButton = widget.newButton
	{
	width = 420,
	height = 160,
	defaultFile = "menu.png",
	overFile = "select.png",
	}
	menuButton.x = display.contentCenterX
	menuButton.y = 950
	menuButton.destination = "menu"
	menuButton:addEventListener("tap", menuButton)
	menuButton:addEventListener( "tap", gotoMenu )
	

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
