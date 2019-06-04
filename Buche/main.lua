-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--Load background
local background = display.newImageRect( "background.png", 700, 1100 )
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

--Display mph
local mph = display.newImageRect( "finish.png", 100, 100 )
mph.x = display.contentCenterX+215
mph.y = display.contentCenterY-450

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


timeText = display.newText(uiGroup, " "..timeLeft, 600, 60, native.systemFontBold, 75)
timeText:setTextColor(0,0,1)

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

--timerr = timer.performWithDelay(1000,timerDown,timeLimit)

--timerUpTimer = timer.performWithDelay(1000, timerUp, 0)

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
