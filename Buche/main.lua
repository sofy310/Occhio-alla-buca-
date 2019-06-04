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
--local scoreLimit = 30
local died = false

local livesText
local scoreText
local punteggioText

-- Set up display groups
local uiGroup = display.newGroup()

--Display lives and score
livesText = display.newText( uiGroup, "Lives: ".. lives, 180, 60, native.systemFontBold, 36)
livesText:setFillColor( 1, 0, 0 )
scoreText = display.newText( "Score: ", 357, 60, native.systemFontBold, 36)
scoreText:setFillColor( 1, 0, 0 )
punteggioText = display.newText( uiGroup, " ".. score, 455, 60, native.systemFontBold, 40)
punteggioText:setFillColor( 1, 0, 0 )

local function timerUp()
    score = score + 1
    punteggioText.text = score

   -- if score >= scoreLimit then
    --    display.remove(scoreText)
    --    timer.cancel(timerUpTimer)
    --    storyboard.gotoScene("maxtime", "fade", 400)
   -- end
end

timerUpTimer = timer.performWithDelay(1000, timerUp, 0)

--Load autobus
local autobus = display.newImageRect("autobus.png", 550, 250)
autobus.x = display.contentCenterX
autobus.y = display.contentHeight-170
physics.addBody(autobus, "dynamic", {radius = 40, isSensor = true})
autobus.myName = "autobus"

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
    local newBuca1 = display.newImageRect("buca1.png", math.random(100, 200), math.random(100, 200))
    table.insert(bucheTable, newBuca1)
    physics.addBody(newBuca1, "dynamic", {radius = 40, bounce = 0})
    newBuca1.myName = "buca1"

    local newBuca2 = display.newImageRect("buca2.png", math.random(100, 200), math.random(100, 200))
    table.insert(bucheTable, newBuca2)
    physics.addBody(newBuca2, "dynamic", {radius = 40, bounce = 0})
    newBuca2.myName = "buca2"

    local newBuca3 = display.newImageRect("buca3.png", math.random(100, 200), math.random(100, 200))
    table.insert(bucheTable, newBuca3)
    physics.addBody(newBuca3, "dynamic", {radius = 40, bounce = 0})
    newBuca3.myName = "buca3"

    local whereFrom = math.random(11)

    if ( whereFrom == 1 ) then
        -- buca1 From the topLeft
        newBuca1.x = display.contentCenterX -200
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
  
    elseif ( whereFrom == 2 ) then
        -- buca1 From the topCenter
        newBuca1.x = display.contentCenterX
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
  
    elseif ( whereFrom == 3 ) then
        -- buca1 From the topRight
        newBuca1.x = display.contentCenterX +200
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newBuca1.x = display.contentCenterX -96
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newBuca1.x = display.contentCenterX +96
        newBuca1.y = -60
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 6 ) then
        -- buca2 From the topRight
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -60
        newBuca2:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 7 ) then
        -- buca3 From the topLeft
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -60
        newBuca2:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 8 ) then
        -- buca3 From the topCenter
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -60
        newBuca2:setLinearVelocity(0, 100 )
    elseif ( whereFrom == 9 ) then
        -- buca3 From the topRight
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -60
        newBuca3:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 10 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -60
        newBuca3:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 11 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -60
        newBuca3:setLinearVelocity(0, 100 )
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

local function restoreAutobus()
 
    autobus.isBodyActive = false
    autobus.x = display.contentCenterX
    autobus.y = display.contentHeight - 100
 
    -- Fade in the autobus
    transition.to( autobus, { alpha=1, time=4000,
        onComplete = function()
            autobus.isBodyActive = true
            died = false
        end
    } )
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        
        if ( ( obj1.myName == "autobus" and obj2.myName == "buca1" ) or
             ( obj1.myName == "buca1" and obj2.myName == "autobus" ) )
        then
            if ( died == false ) then
                died = true

                --Update lives
                lives = lives -1
                livesText = "Lives: " ..lives

                if ( lives == 0 ) then
                    display.remove( autobus )
                else
                    autobus.alpha = 0
                    timer.performWithDelay( 1000, restoreAutobus )
                end
            end
 
        end
        
    end
end
Runtime:addEventListener( "collision", onCollision )
