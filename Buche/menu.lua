-- Menu Scene

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
    composer.removeScene( "game" )
    composer.gotoScene( "game", { time = 800, effect = "crossFade" } )
end

local function gotoLevelSelect()
    composer.removeScene( "levelselect" )
    composer.gotoScene( "levelselect", { time = 800, effect = "crossFade" } )
end

local function gotoHighscore()
    composer.removeScene( "highscore" )
    composer.gotoScene( "highscore", { time = 800, effect = "crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local widget = require("widget")


-- create()
function scene:create( event )

	local sceneGroup = self.view

	local background = display.newImageRect("sfondotitle.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--local logo = display.newImage("logo.png")
	--logo.x = display.contentCenterX 
	--logo.y = 350

	local playButton = widget.newButton
	{
	width = 450,
    height = 200,
    defaultFile = "playgame.png",
	}
	playButton.x = display.contentCenterX
	playButton.y = 700
	playButton.destination = "game"
	playButton:addEventListener("tap", playButton)
	playButton:addEventListener( "tap", gotoGame )

	local levelsButton = widget.newButton
	{
	width = 450,
    height = 200,
    defaultFile = "levels.png",
	}
	levelsButton.x = display.contentCenterX
	levelsButton.y = 850
	levelsButton.destination = "levelselect"
	levelsButton:addEventListener("tap", levelsButton)
	levelsButton:addEventListener( "tap", gotoLevelSelect )

	local highscoreButton = widget.newButton
	{
	width = 450,
    height = 200,
    defaultFile = "highscore.png",
	}
	highscoreButton.x = display.contentCenterX
	highscoreButton.y = 1000
	highscoreButton.destination = "highscore"
	highscoreButton:addEventListener("tap", highscoreButton)
	highscoreButton:addEventListener( "tap", gotoHighscore )


	--local highScoreButton = display.newText( "High Scores", display.contentCenterX, 810, native.systemFont, 44 )
	--highScoreButton:setFillColor( 0.75, 0.78, 1 )

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
