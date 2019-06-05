-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--Load background
local background = display.newImageRect( "background.png", 700, 1100)
background.x = display.contentCenterX
background.y = display.contentCenterY

local bg1
local bg2
local runtime = 0
local scrollSpeed = 1.78

local function addScrollableBg()
    local bgImage = { type="image", filename="background.png" }

    -- Add First bg image
    bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg1.fill = bgImage
    bg1.x = display.contentCenterX
    bg1.y = display.contentCenterY

    -- Add Second bg image
    bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg2.fill = bgImage
    bg2.x = display.contentCenterX
    bg2.y = display.contentCenterY - display.actualContentHeight
end

local function moveBg(dt)
    bg1.y = bg1.y + scrollSpeed * dt
    bg2.y = bg2.y + scrollSpeed * dt

    if (bg1.y - display.contentHeight/2) > display.actualContentHeight then
        bg1:translate(0, -bg1.contentHeight * 2)
    end
    if (bg2.y - display.contentHeight/2) > display.actualContentHeight then
        bg2:translate(0, -bg2.contentHeight * 2)
    end
end

local function getDeltaTime()
   local temp = system.getTimer()
   local dt = (temp-runtime) / (1000/60)
   runtime = temp
   return dt
end

local function enterFrame()
    local dt = getDeltaTime()
    moveBg(dt)
end

function init()
    addScrollableBg()
    Runtime:addEventListener("enterFrame", enterFrame)
end

init()

--Adding physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

--Display finish
local finish = display.newImageRect( "finish.png", 150, 150 )
finish.x = display.contentCenterX+215
finish.y = display.contentCenterY-600

--Initialize variables
local lives = 3
local score = 0
--local scoreLimit = 30
local timeLeft = 90
local died = false

local livesText
local scoreText
local punteggioText
local timeText

-- Set up display groups
local uiGroup = display.newGroup()

--Display lives, score and timer
livesText = display.newText( uiGroup, "Lives: ".. lives, 180, -110, native.systemFontBold, 42)
livesText:setFillColor( 1, 0, 0 )
scoreText = display.newText( "Score: ", 357, -110, native.systemFontBold, 42)
scoreText:setFillColor( 1, 0, 0 )
punteggioText = display.newText( uiGroup, " ".. score, 455, -110, native.systemFontBold, 50)
punteggioText:setFillColor( 1, 0, 0 )
timeText = display.newText(uiGroup, " "..timeLeft, 600, -110, native.systemFontBold, 75)
timeText:setTextColor(0,0,1)

local function timerUp()
    score = score + 1
    punteggioText.text = score
   -- if score >= scoreLimit then
    --    display.remove(scoreText)
    --    timer.cancel(timerUpTimer)
    --    storyboard.gotoScene("maxtime", "fade", 400)
   -- end
end
local timerUpTimer = timer.performWithDelay(1000, timerUp, 0)

local function timerDown()
    timeLeft = timeLeft - 1
    timeText.text = timeLeft
   -- if(timeLimit==0)then
    --    display.remove(timeLeft)
    --    timer.cancel(timerr)
   --     storyboard.gotoScene("maxtime", "fade", 400)
   -- end
end
local countDownTimer = timer.performWithDelay( 1000, timerDown, timeLeft )

--Load autobus
local autobus = display.newImageRect("autobus.png", 550, 250)
autobus.x = display.contentCenterX
autobus.y = display.contentHeight-30
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
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 100 )
  
    elseif ( whereFrom == 2 ) then
        -- buca1 From the topCenter
        newBuca1.x = display.contentCenterX
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 100 )
 
    elseif ( whereFrom == 3 ) then
        -- buca1 From the topRight
        newBuca1.x = display.contentCenterX +200
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newBuca1.x = display.contentCenterX -96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newBuca1.x = display.contentCenterX +96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 6 ) then
        -- buca2 From the topRight
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 7 ) then
        -- buca3 From the topLeft
        newBuca2.x = display.contentCenterX -96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 8 ) then
        -- buca3 From the topCenter
        newBuca2.x = display.contentCenterX
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 100 )
    elseif ( whereFrom == 9 ) then
        -- buca3 From the topRight
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 10 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX -96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 100 )
    
    elseif ( whereFrom == 11 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 100 )
    end
end


local function gameLoop()

    createBuca()

    for i = #bucheTable, 1, -1 do
        local thisBuca1 = bucheTable[i]
		local thisBuca2 = bucheTable[i]
		local thisBuca3 = bucheTable[i]
 
        if ( thisBuca1.x < -100 or
             thisBuca1.x > display.contentWidth + 100 or
             thisBuca1.y < -100 or
             thisBuca1.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca1 )
            table.remove( bucheTable, i )
       

		elseif ( thisBuca2.x < -100 or
             thisBuca2.x > display.contentWidth + 100 or
             thisBuca2.y < -100 or
             thisBuca2.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca2 )
            table.remove( bucheTable, i )
        

		elseif ( thisBuca3.x < -100 or
            thisBuca3.x > display.contentWidth + 100 or
            thisBuca3.y < -100 or
            thisBuca3.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca3 )
            table.remove( bucheTable, i )
        end
    end

end

gameLoopTimer = timer.performWithDelay(3000, gameLoop, 0 )

local function restoreAutobus()
 
    autobus.isBodyActive = false
    autobus.x = display.contentCenterX
    autobus.y = display.contentHeight - 30
 
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
                livesText.text = "Lives: "..lives

                if ( lives == 0 ) then
                    display.remove( autobus )
                else
                    autobus.alpha = 0
                    timer.performWithDelay( 1000, restoreAutobus )
                end
            end
 
        end

        if ( (obj1.myName == "autobus" and obj2.myName == "buca2") or
              obj1.myName == "buca2" and obj2.myName == "autobus") 
        then
            if (died == false) then
                died = true

                --Update lives
                lives = lives -1
                livesText.text = "Lives: "..lives

                if (lives == 0) then 
                    display.remove(autobus)
                else
                    autobus.alpha = 0
                    timer.performWithDelay( 1000, restoreAutobus)
                end
            end    
        end

        if ( (obj1.myName == "autobus" and obj2.myName == "buca3") or
              obj1.myName == "buca3" and obj2.myName == "autobus") 
        then
             if (died == false) then
                died = true

                --Update lives
                lives = lives -1
                livesText.text = "Lives: "..lives

          if (lives == 0) then 
              display.remove(autobus)
          else
              autobus.alpha = 0
              timer.performWithDelay( 1000, restoreAutobus)
          end
      end    
  end
        
    end
end
Runtime:addEventListener( "collision", onCollision )
