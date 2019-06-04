-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--Load background
local background = display.newImageRect( "back_grey.png", 700, 1100 )
background.x = display.contentCenterX
background.y = display.contentCenterY

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY-470

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY-470

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY-350

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY-350
--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY-230

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY-230

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY-110

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY-110

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY+5

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY+5

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY+125

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY+125

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY+245

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY+245

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY+365

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY+365

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX-96
striscia.y = display.contentCenterY+485

--Load striscia
local striscia = display.newImageRect("striscia.png", 10, 80) 
striscia.x = display.contentCenterX+96
striscia.y = display.contentCenterY+485


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


math.randomseed( os.time() )

local gameLoopTimer
local bucheTable = {}

local function createBuca()
    local newBuca1 = display.newImageRect("buca1.png", math.random(80, 150), math.random(80, 150))
    table.insert(bucheTable, newBuca1)
    physics.addBody(newBuca1, "dynamic", {radius = 40, bounce = 0})

    local whereFrom = math.random(5)

    if ( whereFrom == 1 ) then
        -- From the topLeft
        newBuca1.x = display.contentCenterX -200
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
  
    elseif ( whereFrom == 2 ) then
        -- From the topCenter
        newBuca1.x = display.contentCenterX
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
  
    elseif ( whereFrom == 3 ) then
        -- From the topRight
        newBuca1.x = display.contentCenterX +200
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 4 ) then
        -- From the topRight
        newBuca1.x = display.contentCenterX -96
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 5 ) then
        -- From the topRight
        newBuca1.x = display.contentCenterX +96
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
    end
end

local function gameLoop()

    createBuca()

    for i = #bucheTable, 1, -1 do
        local thisBuca1 = bucheTable[i]
 
        if ( thisBuca1.x < -100 or
             thisBuca1.x > display.contentWidth + 100 or
             thisBuca1.y < -100 or
             thisBuca1.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca1 )
            table.remove( bucheTable, i )
        end
    end
end

gameLoopTimer = timer.performWithDelay(3000, gameLoop, 0 )
