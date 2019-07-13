local composer = require( "composer" )

local scene = composer.newScene()


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
local scrollSpeed = 2.78

--Scrollable Background
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

-- load BORDO SX
local bordoSX = display.newImageRect( "bordo.png", 8, 2100)
bordoSX.x = display.contentCenterX - 290
bordoSX.y = display.contentCenterY
bordoSX.myName = "bordoSX"
physics.addBody(bordoSX, "static")

-- load BORDO DX
local bordoDX = display.newImageRect( "bordo.png", 8, 2100)
bordoDX.x = display.contentCenterX + 290
bordoDX.y = display.contentCenterY
bordoDX.myName = "bordoDX"
physics.addBody(bordoDX, "static")

--Display finish
--local finish = display.newImageRect( "finish.png", 150, 150 )
--finish.x = display.contentCenterX+215
--finish.y = display.contentCenterY-600
--finish.myName = "finish"
--physics.addBody(finish, "static")

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
local bucheTable = {}

-- Set up display groups
local uiGroup = display.newGroup()
local mainGroup = display.newGroup()


--Display lives, score and timer
livesText = display.newText( uiGroup, "Lives: ".. lives, 280, -110, native.systemFontBold, 50)
livesText:setFillColor( 1, 0, 0 )
scoreText = display.newText( uiGroup, "Score: ", 477, -110, native.systemFontBold, 50)
scoreText:setFillColor( 1, 0, 0 )
punteggioText = display.newText( uiGroup, " ".. score, 575, -110, native.systemFontBold, 55)
punteggioText:setFillColor( 1, 0, 0 )
--timeText = display.newText(uiGroup, " "..timeLeft, 600, -110, native.systemFontBold, 75)
--timeText:setTextColor(0,0,1)

--Timer UP
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

-- Timer DOWN
--local function timerDown()
   -- timeLeft = timeLeft - 1
    ----timeText.text = timeLeft
   -- if(timeLimit==0)then
    --    display.remove(timeLeft)
    --    timer.cancel(timerr)
   --     storyboard.gotoScene("maxtime", "fade", 400)
   -- end
--end
local countDownTimer = timer.performWithDelay( 1000, timerDown, timeLeft )

--Load autobus
local autobus = display.newImageRect(mainGroup, "autobus.png", 590, 280)
autobus.x = display.contentCenterX
autobus.y = display.contentHeight-30
physics.addBody(autobus, "dynamic", {radius = 100, isSensor = true})
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

-- Load RUOTA
local ruoteTable = {}
local function createRuota()
    local newRuota = display.newImageRect(mainGroup, "ruota.png", 100, 100)
	table.insert(ruoteTable, newRuota)
	physics.addBody(newRuota, "dynamic", {radius = 40, bounce = 0})
    newRuota.myName = "ruota"
   
	local whereFrom = math.random(10)
	
    if ( whereFrom == 1 ) then
        newRuota.x = display.contentCenterX -200
        newRuota.y = -100
        newRuota:setLinearVelocity(0, 150 )
	elseif ( whereFrom == 2 ) then
		newRuota.x = display.contentCenterX +200
		newRuota.y = -100
		newRuota:setLinearVelocity(0, 150 )
	elseif ( whereFrom == 3 ) then
		newRuota.x = display.contentCenterX
		newRuota.y = -100
        newRuota:setLinearVelocity(0, 150 )
    else 
        newRuota.x = display.contentCenterX
        newRuota.y = -200 
        newRuota:setLinearVelocity(0, 0 )

	end
	newRuota:applyTorque( math.random( 3,5 ) )
end
-- loop RUOTA
local function ruotaLoop()
	createRuota()
	for i = #ruoteTable, 1, -1 do
        local thisRuota = ruoteTable[i]
 
        if ( thisRuota.x < -100 or
             thisRuota.x > display.contentWidth + 100 or
             thisRuota.y < -100 or
             thisRuota.y > display.contentHeight + 100 )
        then
            display.remove( thisRuota )
            table.remove( ruoteTable, i )
        end
    end
end
ruotaLoopTimer = timer.performWithDelay( 5000, ruotaLoop, 0 )

local function deleteRuota()
    for i = #ruoteTable, 1, -1 do
        local thisRuota = ruoteTable[i]
        display.remove(thisRuota)
        table.remove( ruoteTable, i )

    end
end
    

-- Load CAR1
local carsTable = {}
local function createCar1()
    local newCar1 = display.newImageRect(mainGroup, "car1.png", 100, 150)
	table.insert(carsTable, newCar1)
	physics.addBody(newCar1, "dynamic", {radius = 60, bounce = 0})
    newCar1.myName = "car1"
   
	local whereFrom = math.random(5)
	
    if ( whereFrom == 1 ) then
        newCar1.x = display.contentCenterX -240
        newCar1.y = -100
        newCar1:setLinearVelocity(0, math.random( 190,350 ) )
		--newCar1:setLinearVelocity(0,100)
	elseif ( whereFrom == 2 ) then
		newCar1.x = display.contentCenterX -100
		newCar1.y = -100
		newCar1:setLinearVelocity(0, math.random( 190,350 ) )
        --newCar1:setLinearVelocity(0,100)
    else 
        newCar1.x = display.contentCenterX 
        newCar1.y = -1000
        newCar1:setLinearVelocity(0, 0 )

    end 
end
-- loop CARS
local function car1Loop()
	createCar1()
	for i = #carsTable, 1, -1 do
        local thisCar1 = carsTable[i]
 
        if ( thisCar1.x < -100 or
             thisCar1.x > display.contentWidth + 100 or
             thisCar1.y < -100 or
             thisCar1.y > display.contentHeight + 100 )
        then
            display.remove( thisCar1 )
            table.remove( carsTable, i )
        end
    end
end
car1LoopTimer = timer.performWithDelay( 5000, car1Loop, 0 )

local function deleteCar()
    for i = #carsTable, 1, -1 do
        local thisCar = carsTable[i]
        display.remove(thisCar)
        table.remove( carsTable, i )

    end
end
math.randomseed( os.time() )

-- load BUCA1
local function createBuca1()
    local newBuca1 = display.newImageRect(mainGroup, "buca1.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca1)
    physics.addBody(newBuca1, "kinematic", {radius = 50, bounce = 0})
    newBuca1.myName = "buca1"

    local whereFrom = math.random(5)
	
    if ( whereFrom == 1 ) then
        -- buca1 From the topLeft
        newBuca1.x = display.contentCenterX -200
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 150 )
    elseif ( whereFrom == 2 ) then
        -- buca1 From the topCenter
        newBuca1.x = display.contentCenterX
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 150 )
    elseif ( whereFrom == 3 ) then
        -- buca1 From the topRight
        newBuca1.x = display.contentCenterX +200
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 150 )
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newBuca1.x = display.contentCenterX -96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 150 )
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newBuca1.x = display.contentCenterX +96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 150 )
    end
end

-- load BUCA2
local function createBuca2()
	local newBuca2 = display.newImageRect(mainGroup, "buca2.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca2)
    physics.addBody(newBuca2, "kinematic", {radius = 50, bounce = 0})
    newBuca2.myName = "buca2"

	local whereFrom = math.random(3)

	if ( whereFrom == 1 ) then
        -- buca2 From the topRight
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 150 )
    elseif ( whereFrom == 2 ) then
        -- buca3 From the topLeft
        newBuca2.x = display.contentCenterX -96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 150 )  
    elseif ( whereFrom == 3 ) then
        -- buca3 From the topCenter
        newBuca2.x = display.contentCenterX
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 150 )
	end
end

-- load BUCA3
local function createBuca3()

	local newBuca3 = display.newImageRect(mainGroup, "buca3.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca3)
    physics.addBody(newBuca3, "kinematic", {radius = 40, bounce = 0})
    newBuca3.myName = "buca3"

	local whereFrom = math.random(3)

	if ( whereFrom == 1 ) then
        -- buca3 From the topRight
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 150 ) 
    elseif ( whereFrom == 2 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX -96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 150 )   
    elseif ( whereFrom == 3 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 150 )
	end
end

-- loop BUCHE
local function gameLoop()
	local whichBuca = math.random(3)
    if ( whichBuca == 1 ) then
		createBuca1()
	else if( whichBuca == 2 ) then
			createBuca2()
		else
			createBuca3()
		end
	end

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

-- restore AUTOBUS
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

-- endGAME
local function endGame()
    composer.setVariable("finalScore", score)
    composer.removeScene("highscore")
    composer.gotoScene( "highscore", { time=800, effect="crossFade" } )
end

-- collisione AUTOBUS/BUCA e AUTOBUS/LINEE
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
                    timer.performWithDelay( 2000, endGame )

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
                    timer.performWithDelay( 2000, endGame )

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
                    timer.performWithDelay( 2000, endGame )

				else
					autobus.alpha = 0
					timer.performWithDelay( 1000, restoreAutobus)
				end
			 end    
        end

        if((obj1.myName == "ruota" and obj2.myName == "autobus") or
        obj1.myName == "autobus" and obj2.myName == "ruota" )
        then
            deleteRuota()
            if(lives == 2 or lives == 1) then
                lives = lives +1
                livesText.text = "Lives: "..lives
            end
        end
        
        if ( (obj1.myName == "car1" and obj2.myName == "buca1") or
        (obj1.myName == "buca1" and obj2.myName == "car1"))
        then
            deleteCar()
        end

        if ( (obj1.myName == "car1" and obj2.myName == "buca2") or
        (obj1.myName == "buca2" and obj2.myName == "car1"))
        then
            deleteCar()
        end

        if ( (obj1.myName == "car1" and obj2.myName == "buca3") or
        (obj1.myName == "buca3" and obj2.myName == "car1"))
        then
            deleteCar()
        end 

        if ( (obj1.myName == "car1" and obj2.myName == "autobus") or
        (obj1.myName == "autobus" and obj2.myName == "car1"))
        then
            if (died == false) then
               died = true

               --Update lives
               lives = lives -1
               livesText.text = "Lives: "..lives

               if (lives == 0) then 
                   display.remove(autobus)
                   timer.performWithDelay( 2000, endGame )

               else
                   autobus.alpha = 0
                   timer.performWithDelay( 1000, restoreAutobus)
               end
            end    
       end

        if ( ( obj1.myName == "bordoDX" and obj2.myName == "autobus" ) or
             ( obj1.myName == "autobus" and obj2.myName == "bordoDX" ) )
         then
            if (died == false) then
                died = true

                --Update lives
                lives = lives -1
                livesText.text = "Lives: "..lives

                if (lives == 0) then 
                    display.remove(autobus)
                    timer.performWithDelay( 2000, endGame )
                else
                    autobus.alpha = 0
                    timer.performWithDelay( 1000, restoreAutobus)
                end
            end    
        end

        if ( (obj1.myName == "bordoSX" and obj2.myName == "autobus") or
              obj1.myName == "autobus" and obj2.myName == "bordoSX") 
         then
            if (died == false) then
                died = true

                --Update lives
                lives = lives -1
                livesText.text = "Lives: "..lives

                if (lives == 0) then 
                    display.remove(autobus)
                    timer.performWithDelay( 2000, endGame )

                else
                    autobus.alpha = 0
                    timer.performWithDelay( 1000, restoreAutobus)
                end
            end    
        end       
        
    end
end
Runtime:addEventListener( "collision", onCollision )



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
        --Adding physics
  

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
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
