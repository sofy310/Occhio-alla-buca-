local composer = require( "composer" )

local scene = composer.newScene()


-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--Load sound effects
local clacson = audio.loadSound( "clacson.wav" )
local crash = audio.loadSound("crash.wav")
local live = audio.loadSound("lives.wav")
local bounce = audio.loadSound("bounce.wav")
local largeCrash = audio.loadSound("largeCrash.wav")
local vittoria = audio.loadSound("vittoria.wav")
--Load background
local background = display.newImageRect( "background.png", 700, 1100)
background.x = display.contentCenterX
background.y = display.contentCenterY
local backgroundMusic = audio.loadStream( "occhioAllaBuca.wav" )

local bg1
local bg2
local runtime = 0
local scrollSpeed = 6.3

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
bordoSX.x = display.contentCenterX - 360
bordoSX.y = display.contentCenterY
bordoSX.myName = "bordoSX"
physics.addBody(bordoSX, "static")

-- load BORDO DX
local bordoDX = display.newImageRect( "bordo.png", 8, 2100)
bordoDX.x = display.contentCenterX + 360
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
local died = false
local livesText
local punteggioText
local timeText
local bucheTable = {}

-- Set up display groups
local uiGroup = display.newGroup()
local mainGroup = display.newGroup()


--Display lives, score and timer
livesText = display.newText( uiGroup, "Lives: ".. lives, 280, -110, native.systemFontBold, 50)
livesText:setFillColor( 1, 0, 0 )


local countDown = 100
pauseTime = false;
resumeTime = true;

local timerText = display.newText( "", 620, -110, "comic sans ms", 60)

timerText:setTextColor( 1, 0, 0 )

local timeBut = display.newRect( 50, 50, 100, 50 );
timeBut.x = 440;
timeBut.y = 40;
timeBut.alpha = 0.01;

local function delay_trans(event)
    display.remove(autobus)
    composer.removeScene("levelselect")
    composer.gotoScene( "levelselect", { time=1500, effect="crossFade" } )
end

function gameOver()
    if countDown == 0 then
            countDown = 0
            currentTime = countDown
            timerText.text = countDown
            local winText = display.newText( "You Win!", 420, 197, "comic sans ms", 80)
            audio.play(vittoria)
            winText:setTextColor(1, 0, 0)

            timer.performWithDelay(3000, delay_trans)
            display.remove(autobus)
    end
    timerText.text = countDown
    currentTime = countDown
    countDown = countDown - 1
end

Timer1 = timer.performWithDelay( 1000, gameOver, 101 )


--Load autobus
local autobus = display.newImageRect(mainGroup, "autobus.png", 100, 260)
autobus.x = display.contentCenterX
autobus.y = display.contentHeight-30
physics.addBody(autobus, "dynamic", {isSensor = true})
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

--explosionSheet
local sheetOptions =
{
    width = 192,
    height = 195,
    numFrames = 20
}

local sheet_explosion = graphics.newImageSheet( "explosionSheet.png", sheetOptions )

local sequences_exp = {
    -- consecutive frames sequence
    {
        name = "normalExplosion",
        start = 1,
        count = 20,
        time = 1000,
    }
}

local explosion = display.newSprite( sheet_explosion, sequences_exp)
explosion.x = 1111111
explosion.y = 1111111



-- Load RUOTA
local ruoteTable = {}
local function createRuota()
    local newRuota = display.newImageRect(mainGroup, "ruota.png", 100, 100)
	table.insert(ruoteTable, newRuota)
	physics.addBody(newRuota, "dynamic", {bounce = 0})
    newRuota.myName = "ruota"
   
	local whereFrom = math.random(10)
	
    if ( whereFrom == 1 ) then
        newRuota.x = display.contentCenterX -200
        newRuota.y = -100
        newRuota:setLinearVelocity(0, 345 )

	elseif ( whereFrom == 2 ) then
		newRuota.x = display.contentCenterX +200
		newRuota.y = -100
        newRuota:setLinearVelocity(0, 345 )

	elseif ( whereFrom == 3 ) then
		newRuota.x = display.contentCenterX
		newRuota.y = -100
        newRuota:setLinearVelocity(0, 345 )

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
	physics.addBody(newCar1, "dynamic", {bounce = 0})
    newCar1.myName = "car1"
   
	local whereFrom = math.random(5)
	
    if ( whereFrom == 1 ) then
        newCar1.x = display.contentCenterX -240
        newCar1.y = -100
        newCar1:setLinearVelocity(0, math.random( 450,600 ) )
        audio.play( clacson)

		--newCar1:setLinearVelocity(0,100)
	elseif ( whereFrom == 2 ) then
		newCar1.x = display.contentCenterX -100
		newCar1.y = -100
        newCar1:setLinearVelocity(0, math.random( 450,600 ) )
        audio.play( clacson)

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
    physics.addBody(newBuca1, "kinematic", {bounce = 0})
    newBuca1.myName = "buca1"

    local whereFrom = math.random(5)
	
    if ( whereFrom == 1 ) then
        -- buca1 From the topLeft
        newBuca1.x = display.contentCenterX -200
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 345 )
    elseif ( whereFrom == 2 ) then
        -- buca1 From the topCenter
        newBuca1.x = display.contentCenterX
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 345 )
    elseif ( whereFrom == 3 ) then
        -- buca1 From the topRight
        newBuca1.x = display.contentCenterX +200
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 345 )
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newBuca1.x = display.contentCenterX -96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 345 )
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newBuca1.x = display.contentCenterX +96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 345 )
    end
end

-- load BUCA2
local function createBuca2()
	local newBuca2 = display.newImageRect(mainGroup, "buca2.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca2)
    physics.addBody(newBuca2, "kinematic", {bounce = 0})
    newBuca2.myName = "buca2"

	local whereFrom = math.random(3)

	if ( whereFrom == 1 ) then
        -- buca2 From the topRight
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 345 )
    elseif ( whereFrom == 2 ) then
        -- buca3 From the topLeft
        newBuca2.x = display.contentCenterX -96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 345 )  
    elseif ( whereFrom == 3 ) then
        -- buca3 From the topCenter
        newBuca2.x = display.contentCenterX
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 345 )
	end
end

-- load BUCA3
local function createBuca3()

	local newBuca3 = display.newImageRect(mainGroup, "buca3.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca3)
    physics.addBody(newBuca3, "kinematic", {bounce = 0})
    newBuca3.myName = "buca3"

	local whereFrom = math.random(3)

	if ( whereFrom == 1 ) then
        -- buca3 From the topRight
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 345 ) 
    elseif ( whereFrom == 2 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX -96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 345 )   
    elseif ( whereFrom == 3 ) then
        -- From the topRight
        newBuca3.x = display.contentCenterX
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 345 )
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
gameLoopTimer = timer.performWithDelay(1300, gameLoop, 0 )

-- restore AUTOBUS
local function restoreAutobus()
    autobus.isBodyActive = false
    autobus.x = display.contentCenterX
    autobus.y = display.contentHeight - 30
    explosion:pause() 

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
    composer.removeScene("levelselect")
    composer.gotoScene( "levelselect", { time=800, effect="crossFade" } )
end




-- collisione AUTOBUS/BUCA e AUTOBUS/LINEE
local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        
        
        if ( ( obj1.myName == "autobus" and obj2.myName == "buca1" ) or
             ( obj1.myName == "buca1" and obj2.myName == "autobus" ) )
        then
            audio.play(crash)
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y


            if ( died == false ) then
                died = true

                --Update lives
                lives = lives -1
                livesText.text = "Lives: "..lives

                if ( lives == 0 ) then
                    display.remove( autobus )
                    local looseText = display.newText( "You Loose!", 420, 197, "comic sans ms", 80)
                    looseText:setTextColor(1, 0, 0)
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
            audio.play(crash)
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y

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
            audio.play(crash)
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y

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
            audio.play(live)

            deleteRuota()
            if(lives == 2 or lives == 1) then
                lives = lives +1
                livesText.text = "Lives: "..lives
            end
        end
        
        if ( (obj1.myName == "car1" and obj2.myName == "buca1") or
        (obj1.myName == "buca1" and obj2.myName == "car1"))
        then
            audio.play(bounce)
            deleteCar()
        end

        if ( (obj1.myName == "car1" and obj2.myName == "buca2") or
        (obj1.myName == "buca2" and obj2.myName == "car1"))
        then
            audio.play(bounce)
            deleteCar()
        end

        if ( (obj1.myName == "car1" and obj2.myName == "buca3") or
        (obj1.myName == "buca3" and obj2.myName == "car1"))
        then
            audio.play(bounce)
            deleteCar()
        end 

        if ( (obj1.myName == "car1" and obj2.myName == "autobus") or
        (obj1.myName == "autobus" and obj2.myName == "car1"))
        then
            audio.play(largeCrash)
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y

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
            audio.play(bounce)
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y

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
            audio.play(bounce)
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y

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




--pause game
function pauseGame(event)
    --if end of touch event
    if(event.phase == "ended") then
        --pause the physics
        physics.pause(1)
        Runtime:removeEventListener( "enterFrame", enterFrame )
        Runtime:removeEventListener("collision", onCollision)

        audio.pause( 1 )
        timer.pause( gameLoopTimer )
        timer.pause( car1LoopTimer)
        timer.pause( ruotaLoopTimer)
        timer.pause( Timer1)
        autobus:removeEventListener("touch", moveAutobus)
        explosion:pause() 

        --make pause button invisible
        pauseBtn.isVisible = false
        --make resume button visible
        resumeBtn.isVisible = true
        menuBtn.isVisible = true

        -- indicates successful touch
        return true
    end
end
 
--resume game
function resumeGame(event)
    --if end of touch event
    if(event.phase == "ended") then
        --resume physics
        physics.start()
        Runtime:addEventListener( "enterFrame", enterFrame )
        autobus:addEventListener("touch", moveAutobus)
        Runtime:addEventListener("collision", onCollision)

        timer.resume( gameLoopTimer )
        timer.resume( car1LoopTimer)
        timer.resume( ruotaLoopTimer)
        timer.resume( Timer1)
        audio.resume( 1 )

        --make pause button visible
        pauseBtn.isVisible = true
        --make resume button invisible
        resumeBtn.isVisible = false
        --make menu button invisible
        menuBtn.isVisible = false
        -- indicates successful touch
        return true
    end
end
local function gotoMenu()
	composer.removeScene("menu")
    composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
            --make pause button visible
        pauseBtn.isVisible = false
        --make resume button invisible
        resumeBtn.isVisible = false
        --make menu button invisible
        menuBtn.isVisible = false
end

    --define button dimensions
    local btnW, btnH = 250, 100
     
    --create pause button
    pauseBtn = display.newImageRect( "pause.png", btnW, btnH )
     
    --place button in center
    pauseBtn.x, pauseBtn.y = display.contentCenterX, display.contentHeight-1000
     
    --add event
    pauseBtn:addEventListener( "touch", pauseGame ) 
     
    --create resume button
    resumeBtn = display.newImageRect( "resume.png", btnW, btnH )
     
    --put it on pause button
    resumeBtn.x, resumeBtn.y = display.contentCenterX, display.contentHeight-1000
     
    --and hide it
    resumeBtn.isVisible = false
     
    --add event
    resumeBtn:addEventListener( "touch", resumeGame ) 

    --create menu button
    menuBtn = display.newImageRect( "menu.png", btnW, btnH )
     
    --put it on pause button
    menuBtn.x, menuBtn.y = display.contentCenterX, display.contentHeight-850
     
    --and hide it
    menuBtn.isVisible = false
     
    --add event
    menuBtn:addEventListener( "touch", gotoMenu ) 



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
    
    audio.play( backgroundMusic, { channel=1, loops=-1 } )

end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
        timer.cancel( car1LoopTimer)
        timer.cancel( ruotaLoopTimer)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
        Runtime:removeEventListener("enterFrame", enterFrame)
        pauseBtn:removeEventListener( "touch", pauseGame ) 
        explosion:pause() 

        physics.pause()
        audio.stop( 1 )

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
