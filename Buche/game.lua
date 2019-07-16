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
--Load background
local background = display.newImageRect( "background.png", 700, 1100)
background.x = display.contentCenterX
background.y = display.contentCenterY
local backgroundMusic = audio.loadStream( "occhioAllaBuca.wav" )



--Adding physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )



local bg1
local bg2

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

local function moveBg()
    bg1.y = bg1.y + 13
    bg2.y = bg2.y + 13
    if (bg1.y - display.contentHeight/2) > display.actualContentHeight then
        bg1:translate(0, -bg1.contentHeight * 2)
    end
    if (bg2.y - display.contentHeight/2) > display.actualContentHeight then
        bg2:translate(0, -bg2.contentHeight * 2)
    end
end


local function enterFrame()
    moveBg()
end

addScrollableBg()
Runtime:addEventListener("enterFrame", enterFrame)



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
--finish.y = display.contentCenterY-780
--finish.myName = "finish"
--physics.addBody(finish, "static")

--Initialize variables
local lives = 3
local score = 0
local coins = 0
--local scoreLimit = 30
local timeLeft = 90
local died = false

local livesText
local scoreText
local coinsText
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
coinsText = display.newText( uiGroup, "Coins: ", 477, -40, native.systemFontBold, 50)
coinsText:setFillColor( 1, 0, 0 )
punteggioText = display.newText( uiGroup, " ".. score, 575, -110, native.systemFontBold, 55)
punteggioText:setFillColor( 1, 0, 0 )
numeroCoinsText = display.newText( uiGroup, " ".. coins, 575, -40, native.systemFontBold, 55)
numeroCoinsText:setFillColor( 1, 0, 0 )

--Timer UP
local function timerUp()
    score = score + 1
    punteggioText.text = score
end


local function coinsUp()
    coins = coins + 1
    numeroCoinsText.text = coins
end

local timerUpTimer = timer.performWithDelay( 1000, timerUp, 0 )

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
        if (autobus.touchOffsetX == nil) then
            autobus.touchOffsetX = autobus.x
        end
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




-- sprite listener function
local function spriteListener( event )
 
    local thisSprite = event.target  -- "event.target" references the sprite
 
    if ( event.phase == "ended" ) then
         
    end
end
 
-- add the event listener to the sprite
explosion:addEventListener( "sprite", spriteListener )


--pause game
function pauseGame(event)
    --if end of touch event
    if(event.phase == "ended") then
        --pause the physics
        physics.pause()
        Runtime:removeEventListener( "enterFrame", enterFrame )
        audio.pause( 1 )
        timer.pause( gameLoopTimer )
        timer.pause( car1LoopTimer)
        timer.pause( ruotaLoopTimer)
        timer.pause( timerUpTimer)
        timer.pause( coinsLoopTimer)

        autobus:removeEventListener("touch", moveAutobus)

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
        timer.resume( gameLoopTimer )
        timer.resume( car1LoopTimer)
        timer.resume( ruotaLoopTimer)
        timer.resume( timerUpTimer)
        timer.resume( coinsLoopTimer)

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
    pauseBtn.x, pauseBtn.y = display.contentCenterX, display.contentHeight-900
     
    --add event
    pauseBtn:addEventListener( "touch", pauseGame ) 
     
    --create resume button
    resumeBtn = display.newImageRect( "resume.png", btnW, btnH )
     
    --put it on pause button
    resumeBtn.x, resumeBtn.y = display.contentCenterX, display.contentHeight-900
     
    --and hide it
    resumeBtn.isVisible = false
     
    --add event
    resumeBtn:addEventListener( "touch", resumeGame ) 

    --create menu button
    menuBtn = display.newImageRect( "menu.png", btnW, btnH )
     
    --put it on pause button
    menuBtn.x, menuBtn.y = display.contentCenterX, display.contentHeight-800
     
    --and hide it
    menuBtn.isVisible = false
     
    --add event
    menuBtn:addEventListener( "touch", gotoMenu ) 


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
        newRuota:setLinearVelocity(0, 780)
	elseif ( whereFrom == 2 ) then
		newRuota.x = display.contentCenterX +200
		newRuota.y = -100
        newRuota:setLinearVelocity(0, 780)
	elseif ( whereFrom == 3 ) then
		newRuota.x = display.contentCenterX
		newRuota.y = -100
        newRuota:setLinearVelocity(0, 780)
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
    
--Load Coins
local coinsTable = {}
local function createCoin()
    local newCoin = display.newImageRect(mainGroup, "coin.png", 50, 50)
    table.insert(coinsTable, newCoin)
    physics.addBody(newCoin, "dynamic", {bounce = 0})
    newCoin.myName = "coin"

    local whereFrom = math.random(5)
    
    if ( whereFrom == 1 ) then
        -- buca1 From the topLeft
        newCoin.x = display.contentCenterX -200
        newCoin.y = -100
        newCoin:setLinearVelocity(0, 780)
    elseif ( whereFrom == 2 ) then
        -- buca1 From the topCenter
        newCoin.x = display.contentCenterX
        newCoin.y = -100
        newCoin:setLinearVelocity(0, 780)
    elseif ( whereFrom == 3 ) then
        -- buca1 From the topRight
        newCoin.x = display.contentCenterX +200
        newCoin.y = -100
        newCoin:setLinearVelocity(0, 780)
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newCoin.x = display.contentCenterX -96
        newCoin.y = -100
        newCoin:setLinearVelocity(0, 780)
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newCoin.x = display.contentCenterX +96
        newCoin.y = -100
        newCoin:setLinearVelocity(0, 780)
    end
	newCoin:applyTorque(0.4)

end

-- loop BUCHE
local function coinsLoop()

    createCoin()

    for i = #coinsTable, 1, -1 do
        local thisCoin = coinsTable[i]

        if (thisCoin.y < -100 or
             thisCoin.y > display.contentHeight + 100 )
        then
            display.remove( thisCoin )
            table.remove( coinsTable, i )
        end
    end
end
coinsLoopTimer = timer.performWithDelay(500, coinsLoop, 0 )


local function deleteCoin(i)
        local thisCoin = coinsTable[i]
        display.remove(thisCoin)
        table.remove( coinsTable, i )
end
-- Load CAR1
local carsTable = {}
local function createCar1()
    local newCar1 = display.newImageRect(mainGroup, "car1.png", 100, 150)
	table.insert(carsTable, newCar1)
	physics.addBody(newCar1, "dynamic", {bounce = 0})
    newCar1.myName = "car1"
   
	local whereFrom = math.random(2)
	
    if ( whereFrom == 1 ) then
        newCar1.x = display.contentCenterX -240
        newCar1.y = -100
        newCar1:setLinearVelocity(0, math.random( 900, 1100 ) )
        audio.play( clacson)


		--newCar1:setLinearVelocity(0,100)
	elseif ( whereFrom == 2 ) then
		newCar1.x = display.contentCenterX -100
		newCar1.y = -100
        newCar1:setLinearVelocity(0, math.random( 900, 1100 ) )
        audio.play( clacson)

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
        newBuca1:setLinearVelocity(0, 780)
    elseif ( whereFrom == 2 ) then
        -- buca1 From the topCenter
        newBuca1.x = display.contentCenterX
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 780)
    elseif ( whereFrom == 3 ) then
        -- buca1 From the topRight
        newBuca1.x = display.contentCenterX +200
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 780)
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newBuca1.x = display.contentCenterX -96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 780)
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newBuca1.x = display.contentCenterX +96
        newBuca1.y = -100
        newBuca1:setLinearVelocity(0, 780)
    end
end

-- load BUCA2
local function createBuca2()
	local newBuca2 = display.newImageRect(mainGroup, "buca2.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca2)
    physics.addBody(newBuca2, "kinematic", {bounce = 0})
    newBuca2.myName = "buca2"

    local whereFrom = math.random(5)
	
    if ( whereFrom == 1 ) then
        -- buca2 From the topLeft
        newBuca2.x = display.contentCenterX -200
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 780)
    elseif ( whereFrom == 2 ) then
        -- buca2 From the topCenter
        newBuca2.x = display.contentCenterX
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 780)
    elseif ( whereFrom == 3 ) then
        -- buca2 From the topRight
        newBuca2.x = display.contentCenterX +200
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 780)
    elseif ( whereFrom == 4 ) then
        -- buca2 From the topLeft
        newBuca2.x = display.contentCenterX -96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 780)
    
    elseif ( whereFrom == 5 ) then
        -- buca2 From the topCenter
        newBuca2.x = display.contentCenterX +96
        newBuca2.y = -100
        newBuca2:setLinearVelocity(0, 780)
    end
end

-- load BUCA3
local function createBuca3()

	local newBuca3 = display.newImageRect(mainGroup, "buca3.png", math.random(90, 130), math.random(90, 130))
    table.insert(bucheTable, newBuca3)
    physics.addBody(newBuca3, "kinematic", {bounce = 0})
    newBuca3.myName = "buca3"
    local whereFrom = math.random(5)
	
    if ( whereFrom == 1 ) then
        -- buca3 From the topLeft
        newBuca3.x = display.contentCenterX -200
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 780)
    elseif ( whereFrom == 2 ) then
        -- buca3 From the topCenter
        newBuca3.x = display.contentCenterX
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 780)
    elseif ( whereFrom == 3 ) then
        -- buca3 From the topRight
        newBuca3.x = display.contentCenterX +200
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 780)
    elseif ( whereFrom == 4 ) then
        -- buca3 From the topLeft
        newBuca3.x = display.contentCenterX -96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 780)
    
    elseif ( whereFrom == 5 ) then
        -- buca3 From the topCenter
        newBuca3.x = display.contentCenterX +96
        newBuca3.y = -100
        newBuca3:setLinearVelocity(0, 780)
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
 
        if (thisBuca1.y < -100 or
             thisBuca1.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca1 )
            table.remove( bucheTable, i )
		elseif (thisBuca2.y < -100 or
             thisBuca2.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca2 )
            table.remove( bucheTable, i )
		elseif (thisBuca3.y < -100 or
            thisBuca3.y > display.contentHeight + 100 )
        then
            display.remove( thisBuca3 )
            table.remove( bucheTable, i )
        end
    end
end
gameLoopTimer = timer.performWithDelay(1500, gameLoop, 0 )

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
    explosion:pause() 
    composer.setVariable("finalCoins", coins)
    composer.setVariable("finalScore", score)
    composer.removeScene("highscore")
    composer.gotoScene( "highscore", { time=800, effect="crossFade" } )
end

-- collisione AUTOBUS/BUCA e AUTOBUS/LINEE
local function onCollision( event )
    
    



    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        --Collisione AUTOBUS e BUCA
        if ( ( obj1.myName == "autobus" and obj2.myName == "buca1" ) or
             ( obj1.myName == "buca1" and obj2.myName == "autobus" ) )
        then
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y
            
            audio.play(crash)

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
        --Collisione AUTOBUS e BUCA
        if ( (obj1.myName == "autobus" and obj2.myName == "buca2") or
              obj1.myName == "buca2" and obj2.myName == "autobus") 
        then
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y
            
            audio.play(crash)
 
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
        --Collisione AUTOBUS e BUCA
        if ( (obj1.myName == "autobus" and obj2.myName == "buca3") or
              obj1.myName == "buca3" and obj2.myName == "autobus") 
        then
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y
            
            audio.play(crash)

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

        --Collisione AUTOBUS e RUOTA
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
        --Collisione AUTOBUS e CAR
        if ( (obj1.myName == "car1" and obj2.myName == "autobus") or
        (obj1.myName == "autobus" and obj2.myName == "car1"))
        then
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y
            
            audio.play(largeCrash)
   
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
        --Collisione AUTOBUS e BORDODX
        if ( ( obj1.myName == "bordoDX" and obj2.myName == "autobus" ) or
             ( obj1.myName == "autobus" and obj2.myName == "bordoDX" ) )
         then
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y
            
            audio.play(bounce)
 
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
        --Collisione AUTOBUS e BORDODX
        if ( (obj1.myName == "bordoSX" and obj2.myName == "autobus") or
              obj1.myName == "autobus" and obj2.myName == "bordoSX") 
         then
            explosion:play() 
            explosion.x = autobus.x
            explosion.y = autobus.y
            
            audio.play(bounce)

            
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

        --Collisione CAR e BUCA
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
        
        --Collisione Buca e COIN
        if ( (obj1.myName == "coin" and obj2.myName == "buca1") or
        (obj1.myName == "buca1" and obj2.myName == "coin"))
        then
            if(obj1.myName == "coin")then 
                obj1.isBodyActive = false
                obj1.isVisible = false
            end
            if(obj2.myName == "coin")then
                obj2.isBodyActive = false
                obj2.isVisible = false            
            end
        end
        if ( (obj1.myName == "coin" and obj2.myName == "buca2") or
        (obj1.myName == "buca2" and obj2.myName == "coin"))
        then
            if(obj1.myName == "coin")then 
                obj1.isBodyActive = false
                obj1.isVisible = false
            end
            if(obj2.myName == "coin")then
                obj2.isBodyActive = false
                obj2.isVisible = false            
            end
        end

        if ( (obj1.myName == "coin" and obj2.myName == "buca3") or
        (obj1.myName == "buca3" and obj2.myName == "coin"))
        then
            if(obj1.myName == "coin")then 
                obj1.isBodyActive = false
                obj1.isVisible = false
            end
            if(obj2.myName == "coin")then
                obj2.isBodyActive = false
                obj2.isVisible = false            
            end
        end              
        --Collisione tra CAR e COIN
        if ( (obj1.myName == "coin" and obj2.myName == "car1") or
        (obj1.myName == "car1" and obj2.myName == "coin"))
        then
            if(obj1.myName == "coin")then 
                obj1.isBodyActive = false
                obj1.isVisible = false
            end
            if(obj2.myName == "coin")then
                obj2.isBodyActive = false
                obj2.isVisible = false            
            end
        end     
        --Collisione tra AUTOBUS e COIN
        if((obj1.myName == "coin" and obj2.myName == "autobus") or
        obj1.myName == "autobus" and obj2.myName == "coin" )
        then
            audio.play(live)
            coinsUp()
            if(obj1.myName == "coin")then 
                obj1.isBodyActive = false
                obj1.isVisible = false
            end
            if(obj2.myName == "coin")then
                obj2.isBodyActive = false
                obj2.isVisible = false            
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
    autobus: addEventListener( "touch", moveAutobus)


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
        timer.cancel( timerUpTimer)
        timer.cancel( coinsLoopTimer)

        Runtime:removeEventListener( "collision", onCollision )
        Runtime:removeEventListener( "enterFrame", enterFrame )
        pauseBtn:removeEventListener( "touch", pauseGame ) 
        explosion:pause() 
        physics.pause()
        audio.stop( 1 )


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
