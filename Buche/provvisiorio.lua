local caniTable = {}

-- load Cane1 (SX)
local function createCane1()
    local newCane1 = display.newImageRect(mainGroup, "Canesx.png", 125, 130)
	--local newCane1 = Cane1
    table.insert(caniTable, newCane1)
    physics.addBody(newCane1, "dynamic", { isSensor = true})
    newCane1.myName = "Cane1"

    local whereFrom = math.random(2)
	
    if ( whereFrom == 1 ) then
        newCane1.x = display.contentCenterX -250
        newCane1.y = -100
        newCane1:setLinearVelocity(math.random( 100,300 ), 1080 )
        audio.play(scream)
    elseif ( whereFrom == 2 ) then
        newCane1.x = display.contentCenterX -250
        newCane1.y = 0
        newCane1:setLinearVelocity(math.random( 100,300 ), 1080 )
        audio.play(scream)
	end
end

-- load Cane2(DX)
local function createCane2()
    local newCane2 = display.newImageRect(mainGroup, "Canedx.png", 145,150)
    table.insert(caniTable, newCane2)
    physics.addBody(newCane2, "dynamic", { isSensor = true})
    newCane2.myName = "Cane2"

    local whereFrom = math.random(2)
	
    if ( whereFrom == 1 ) then
        newCane2.x = display.contentCenterX +250
        newCane2.y = -100
        newCane2:setLinearVelocity(math.random( -300,-100 ), 460 )
        audio.play(scream)
    elseif ( whereFrom == 2 ) then
        newCane2.x = display.contentCenterX +250
        newCane2.y = 0
        newCane2:setLinearVelocity(math.random( -300,-100 ), 460 )
        audio.play(scream)
	end
end
-- loop cani
local function caniLoop()
	local whichCane = math.random(2)
    if ( whichCane == 1 ) then
		createCane1()
	else if( whichCane == 2 ) then
			createCane2()
		end
	end

    for i = #caniTable, 1, -1 do
        local thisCane1 = caniTable[i]
		local thisCane2 = caniTable[i]

        if ( thisCane1.x < -100 or
             thisCane1.x > display.contentWidth + 100 or
             thisCane1.y < -100 or
             thisCane1.y > display.contentHeight + 100 )
        then
            display.remove( thisCane1 )
            table.remove( caniTable, i )
		elseif ( thisCane2.x < -100 or
             thisCane2.x > display.contentWidth + 100 or
             thisCane2.y < -100 or
             thisCane2.y > display.contentHeight + 100 )
        then
            display.remove( thisCane2 )
            table.remove( caniTable, i )
		end
    end
end
caniLoopTimer = timer.performWithDelay(3500, caniLoop, 0 )

--Delete Cane
local function deleteCane1()
    for i = #caniTable, 1, -1 do
        local thisCane1 = caniTable[i]
        display.remove(thisCane1)
        table.remove( caniTable, i )
    end
end

local function deleteCane2()
    for i = #caniTable, 1, -1 do
        local thisCane2 = caniTable[i]
        display.remove(thisCane2)
        table.remove( caniTable, i )
    end
end
