
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local function loadScores()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end
end

local function saveScores()
	for i = #scoresTable, 11, -1 do 
		table.remove(scoresTable, i)
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
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
	loadScores()

	-- insert the saved score from the last game into the table, then reset it
	table.insert( scoresTable, composer.getVariable( "finalScore" ) )
	composer.setVariable( "finalScore", 0 )

	-- sort the tabe entries from highest to lowest
	local function compare( a, b )
		return a > b
	end
	table.sort( scoresTable, compare )

	-- save the scores
	saveScores()

	local background = display.newImageRect("sfondo_highscore.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--local highScoresHeader = display.newText( "High Scores", display.contentCenterX, 100, native.systemFontBold, 55 )
    --highScoresHeader:setFillColor(1, 0, 0)

	for i = 1, 10 do
		if ( scoresTable[i] ) then
			local yPos = 150 + ( i * 56 )

			local rankNum = display.newText(i .. ")", display.contentCenterX - 50, yPos, "comic sans ms", 65 )
			rankNum:setFillColor(0, 0.1, 1 )
			rankNum.anchorX = 1

			local thisScore = display.newText( scoresTable[i], display.contentCenterX - 30, yPos,  "comic sans ms", 65 )
            thisScore.anchorX = 0
            thisScore:setFillColor(0, 0.1, 1)
		end
	end

	

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
