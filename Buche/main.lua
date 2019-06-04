-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--Load background
local background = display.newImageRect( "background.png", 700, 1100 )
background.x = display.contentCenterX
background.y = display.contentCenterY

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80)
striscia.x = display.contentCenterX
striscia.y = display.contentCenterY

--Adding physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

--Initialize variables
local lives = 3
local score = 0
local died = false

local livesText
local scoreText

-- Set up display groups
local uiGroup = display.newGroup()

--Display lives and score
livesText = display.newText( uiGroup, "Lives: ".. lives, 180, 60, native.systemFont, 36)
scoreText = display.newText( uiGroup, "Score: ".. score, 380, 60, native.systemFont, 36)

--Load autobus
local autobus = display.newImageRect("autobus.png", 550, 250)
autobus.x = display.contentCenterX
autobus.y = display.contentHeight-170
physics.addBody(autobus, "dynamic", {radius = 40, isSensor = true})

--Move the autobus
local function moveAutobus(event)
    local autobus = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        -- Set touch focus on the autobus
        display.currentStage:setFocus( autobus )
        -- Store initial offset position
        autobus.touchOffsetX = event.x - autobus.x
 
    elseif ( "moved" == phase ) then
        -- Move the autobus to the new touch position
        autobus.x = event.x - autobus.touchOffsetX
    
    elseif ( "ended" == phase or "cancelled" == phase ) then
        --Release touch focus on the autobus
        display.currentStage: setFocus(nil)
    end
    
    return true
end

autobus: addEventListener( "touch", moveAutobus)

