-- Menu Scene

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoMenu()
    composer.removeScene( "menu" )
    composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
end

local function gotoLevel1()
    composer.removeScene( "level1" )
    composer.gotoScene( "level1", { time = 800, effect = "crossFade" } )
end

local function gotoLevel2()
    composer.removeScene( "level2" )
    composer.gotoScene( "level2", { time = 800, effect = "crossFade" } )
end

local function gotoLevel3()
    composer.removeScene( "level3" )
    composer.gotoScene( "level3", { time = 800, effect = "crossFade" } )
end

local function gotoLevel4()
    composer.removeScene( "level4" )
    composer.gotoScene( "level4", { time = 800, effect = "crossFade" } )
end

local function gotoLevel5()
    composer.removeScene( "level5" )
    composer.gotoScene( "level5", { time = 800, effect = "crossFade" } )
end

local function gotoLevel6()
    composer.removeScene( "level6" )
    composer.gotoScene( "level6", { time = 800, effect = "crossFade" } )
end

local function gotoLevel7()
    composer.removeScene( "level7" )
    composer.gotoScene( "level7", { time = 800, effect = "crossFade" } )
end

local function gotoLevel8()
    composer.removeScene( "level8" )
    composer.gotoScene( "level8", { time = 800, effect = "crossFade" } )
end

local function gotoLevel9()
    composer.removeScene( "level9" )
    composer.gotoScene( "level9", { time = 800, effect = "crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local widget = require("widget")


-- create()
function scene:create( event )

	local sceneGroup = self.view

	local background = display.newImageRect("corsa.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--local logo = display.newImage("logo.png")
	--logo.x = display.contentCenterX 
	--logo.y = 350

	local ButtonUndo = widget.newButton
	{
	width = 160,
    height = 66,
    defaultFile = "undoBlack.png",
	}
	ButtonUndo.x = display.contentCenterX-310
	ButtonUndo.y = -120
	ButtonUndo.destination = "menu"
	ButtonUndo:addEventListener("tap", ButtonUndo)
	ButtonUndo:addEventListener( "tap", gotoMenu)

	local Button1 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level1.png",
	}
	Button1.x = display.contentCenterX-230
	Button1.y = 100
	Button1.destination = "level1"
	Button1:addEventListener("tap", Button1)
	Button1:addEventListener( "tap", gotoLevel1)

	local Button2 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level2.png",
	}
	Button2.x = display.contentCenterX
	Button2.y = 100
	Button2.destination = "level2"
	Button2:addEventListener("tap", Button2)
	Button2:addEventListener( "tap", gotoLevel2 )

	local Button3 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level3.png",
	}
	Button3.x = display.contentCenterX+230
	Button3.y = 100
	Button3.destination = "level3"
	Button3:addEventListener("tap", Button3)
	Button3:addEventListener( "tap", gotoLevel3 )

	local Button4 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level4.png",
	}
	Button4.x = display.contentCenterX-230
	Button4.y = 300
	Button4.destination = "level4"
	Button4:addEventListener("tap", Button4)
	Button4:addEventListener( "tap", gotoLevel4 )

	local Button5 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level5.png",
	}
	Button5.x = display.contentCenterX
	Button5.y = 300
	Button5.destination = "level5"
	Button5:addEventListener("tap", Button5)
	Button5:addEventListener( "tap", gotoLevel5 )

	local Button6 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level6.png",
	}
	Button6.x = display.contentCenterX+230
	Button6.y = 300
	Button6.destination = "level6"
	Button6:addEventListener("tap", Button6)
	Button6:addEventListener( "tap", gotoLevel6 )

	local Button7 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level7.png",
	}
	Button7.x = display.contentCenterX-230
	Button7.y = 500
	Button7.destination = "level7"
	Button7:addEventListener("tap", Button7)
	Button7:addEventListener( "tap", gotoLevel7 )

	local Button8 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level8.png",
	}
	Button8.x = display.contentCenterX
	Button8.y = 500
	Button8.destination = "level8"
	Button8:addEventListener("tap", Button8)
	Button8:addEventListener( "tap", gotoLevel8 )

	local Button9 = widget.newButton
	{
	width = 220,
    height = 153,
    defaultFile = "level9.png",
	}
	Button9.x = display.contentCenterX+230
	Button9.y = 500
	Button9.destination = "level9"
	Button9:addEventListener("tap", Button9)
	Button9:addEventListener( "tap", gotoLevel9 )


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