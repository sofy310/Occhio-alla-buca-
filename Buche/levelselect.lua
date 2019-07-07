local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )

-- Require "global" data table
-- This will contain relevant data like the current level, max levels, number of stars earned, etc.
local myData = require( "mydata" )

-- Declare vertices for vector stars (an image is probably preferable for an actual game).
local starVertices = { 0,-8,1.763,-2.427,7.608,-2.472,2.853,0.927,4.702,6.472,0.0,3.0,-4.702,6.472,-2.853,0.927,-7.608,-2.472,-1.763,-2.427 }

-- Button handler to cancel the level selection and return to the menu
local function handleCancelButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene( "menu", { effect="crossFade", time=333 } )
    end
end

-- Button handler to go to the selected level
local function handleLevelSelect( event )
    if ( "ended" == event.phase ) then
        -- 'event.target' is the button and '.id' is a number indicating which level to go to.  
        -- The 'game' scene will use this setting to determine which level to load.
        -- This could be done via passed parameters as well.
        myData.settings.currentLevel = event.target.id

        -- Purge the game scene so we have a fresh start
        composer.removeScene( "game", false )

        -- Go to the game scene
        composer.gotoScene( "game", { effect="crossFade", time=333 } )
    end
end

-- Declare the Composer event handlers
-- On scene create...
function scene:create( event )
    local sceneGroup = self.view

    -- Create background
    local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
    background:setFillColor( 1 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    -- Use a scrollView to contain the level buttons (for support of more than one full screen).
    -- Since this will only scroll vertically, lock horizontal scrolling.
    local levelSelectGroup = widget.newScrollView({
        width = 460,
        height = 260,
        scrollWidth = 460,
        scrollHeight = 800,
        horizontalScrollDisabled = true
    })

    -- 'xOffset', 'yOffset' and 'cellCount' are used to position the buttons in the grid.
    local xOffset = 64
    local yOffset = 24
    local cellCount = 1

    -- Define the array to hold the buttons
    local buttons = {}

    -- Read 'maxLevels' from the 'myData' table. Loop over them and generating one button for each.
    for i = 1, myData.maxLevels do
        -- Create a button
        buttons[i] = widget.newButton({
            label = tostring( i ),
            id = tostring( i ),
            onEvent = handleLevelSelect,
            emboss = false,
            shape="roundedRect",
            width = 48,
            height = 32,
            font = native.systemFontBold,
            fontSize = 18,
            labelColor = { default = { 1, 1, 1 }, over = { 0.5, 0.5, 0.5 } },
            cornerRadius = 8,
            labelYOffset = -6, 
            fillColor = { default={ 0, 0.5, 1, 1 }, over={ 0.5, 0.75, 1, 1 } },
            strokeColor = { default={ 0, 0, 1, 1 }, over={ 0.333, 0.667, 1, 1 } },
            strokeWidth = 2
        })
        -- Position the button in the grid and add it to the scrollView
        buttons[i].x = xOffset
        buttons[i].y = yOffset
        levelSelectGroup:insert( buttons[i] )

        -- Check to see if the player has achieved (completed) this level.
        -- The '.unlockedLevels' value tracks the maximum unlocked level.
        -- First, however, check to make sure that this value has been set.
        -- If not set (new user), this value should be 1.

        -- If the level is locked, disable the button and fade it out.
        if ( myData.settings.unlockedLevels == nil ) then
            myData.settings.unlockedLevels = 1
        end
        if ( i <= myData.settings.unlockedLevels ) then
            buttons[i]:setEnabled( true )
            buttons[i].alpha = 1.0
        else 
            buttons[i]:setEnabled( false ) 
            buttons[i].alpha = 0.5 
        end 

        -- Generate stars earned for each level, but only if:
        -- a. The 'levels' table exists 
        -- b. There is a 'stars' value inside of the 'levels' table 
        -- c. The number of stars is greater than 0 (no need to draw zero stars). 

        local star = {} 
        if ( myData.settings.levels[i] and myData.settings.levels[i].stars and myData.settings.levels[i].stars > 0 ) then
            for j = 1, myData.settings.levels[i].stars do
                star[j] = display.newPolygon( 0, 0, starVertices )
                star[j]:setFillColor( 1, 0.9, 0 )
                star[j].strokeWidth = 1
                star[j]:setStrokeColor( 1, 0.8, 0 )
                star[j].x = buttons[i].x + (j * 16) - 32
                star[j].y = buttons[i].y + 8
                levelSelectGroup:insert( star[j] )
            end
        end

        -- Compute the position of the next button.
        -- This tutorial draws 5 buttons across.
        -- It also spaces based on the button width and height + initial offset from the left.
        xOffset = xOffset + 75
        cellCount = cellCount + 1
        if ( cellCount > 5 ) then
            cellCount = 1
            xOffset = 64
            yOffset = yOffset + 45
        end
    end

    -- Place the scrollView into the scene and center it.
    sceneGroup:insert( levelSelectGroup )
    levelSelectGroup.x = display.contentCenterX
    levelSelectGroup.y = display.contentCenterY

    -- Create a cancel button for return to the menu scene.
    local doneButton = widget.newButton({
        id = "button1",
        label = "Cancel",
        onEvent = handleCancelButtonEvent
    })
    doneButton.x = display.contentCenterX
    doneButton.y = display.contentHeight - 20
    sceneGroup:insert( doneButton )
end

-- On scene show...
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "did" ) then
    end
end

-- On scene hide...
function scene:hide( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
    end
end

-- On scene destroy...
function scene:destroy( event )
    local sceneGroup = self.view   
end

-- Composer scene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
