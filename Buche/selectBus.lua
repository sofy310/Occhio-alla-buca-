
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require( "json" )
local coinTable = { }
local filePath = system.pathForFile( "coin.json", system.DocumentsDirectory )
local textCoins



table.insert(coinTable, 1000)
table.insert(coinTable, 1000)


local function loadCoins()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		coinTable = json.decode( contents )
	end

end

local function saveCoins()

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( coinTable ) )
		io.close( file )
	end
end


loadCoins()

table.insert( coinTable, composer.getVariable( "finalCoins" ) )
composer.setVariable( "finalCoins", 0 )

saveCoins()

local prezzoGiallo = 1000
local prezzoBlu = 10000
local prezzoRosa = 20000



local function getTotal()
    local totalCoins = 0
    for i = 1, 10000 do
        if ( coinTable[i] ) then
            totalCoins = totalCoins + coinTable[i]
        end
    end

    return totalCoins
end




local function gotoMenu()
	composer.removeScene("menu")
	composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
end

local sfondotitle = display.newImageRect("asfalto.jpg", 800, 1400 )
sfondotitle.x = display.contentCenterX
sfondotitle.y = display.contentCenterY

local shop = display.newImageRect("autobus/shop.png", 600, 250)
shop.x = display.contentCenterX
shop.y = display.contentCenterY - 550

local widget = require("widget")
	
	local menuButton = widget.newButton
	{
	width = 420,
	height = 160,
	defaultFile = "menu.png",
	}
	menuButton.x = display.contentCenterX
	menuButton.y = 950
	menuButton.destination = "menu"
	menuButton:addEventListener("tap", menuButton)
	menuButton:addEventListener( "tap", gotoMenu )

    local si = widget.newButton
    {
    width = 300,
    height = 130,
    defaultFile = "autobus/si.png",
    }
    si.x = display.contentCenterX - 200
    si.y = display.contentCenterY + 600
    si.destination = "selectBus"

    si.isVisible = false
    
    local no = widget.newButton
    {
    width = 300,
    height = 130,
    defaultFile = "autobus/no.png",
    }
    no.x = display.contentCenterX + 200
    no.y = display.contentCenterY + 600

    no.isVisible = false

    local mexRosa = display.newImageRect("autobus/vuoiAcquistare.png", 500, 200)
    local mexGiallo = display.newImageRect("autobus/vuoiAcquistare.png", 500, 200)
    local mexBlu = display.newImageRect("autobus/vuoiAcquistare.png", 500, 200)
    mexRosa.isVisible = false
    mexGiallo.isVisible = false
    mexBlu.isVisible = false




    local function gotoSI()
        composer.removeScene("selecBus")
        composer.gotoScene("selectBus")
        si.isVisible = false
        no.isVisible = false
        menuButton.isVisible = true
        mexRosa.isVisible = false
        mexGiallo.isVisible = false
        mexBlu.isVisible = false

    end
        
    local function gotoNO()
        composer.removeScene("selecBus")
        composer.gotoScene("selectBus")
        si.isVisible = false
        no.isVisible = false
        menuButton.isVisible = true
        mexRosa.isVisible = false
        mexGiallo.isVisible = false
        mexBlu.isVisible = false


    end


    

local function vuoiAcquistareGiallo()
    mexGiallo.isVisible = true
    mexGiallo.x = display.contentCenterX
    mexGiallo.y = display.contentCenterY + 400
    menuButton.isVisible = false
    si.isVisible = true
    si:addEventListener("tap", si)
    si:addEventListener("tap", gotoSI)
    no.isVisible = true
    no:addEventListener("tap", no)
    no:addEventListener("tap", gotoNO)

end


local function vuoiAcquistareBlu()
    mexBlu.isVisible = true
    mexBlu.x = display.contentCenterX
    mexBlu.y = display.contentCenterY + 400
    menuButton.isVisible = false
    si.isVisible = true
    si:addEventListener("tap", si)
    si:addEventListener("tap", gotoSI)
    no.isVisible = true
    no:addEventListener("tap", no)
    no:addEventListener("tap", gotoNO)

end


local function vuoiAcquistareRosa()
    mexRosa.isVisible = true
    mexRosa.x = display.contentCenterX
    mexRosa.y = display.contentCenterY + 400
    menuButton.isVisible = false
    si.isVisible = true
    si:addEventListener("tap", si)
    si:addEventListener("tap", gotoSI)
    no.isVisible = true
    no:addEventListener("tap", no)
    no:addEventListener("tap", gotoNO)

end




local function showTotalCoins()
    local total = getTotal()
    local imageCoin = display.newImageRect("coin.png", 100, 100)
    imageCoin.x = display.contentCenterX-100
    imageCoin.y = display.contentCenterY-400
    coinsText = display.newText( " ".. total, 450, 115, native.systemFontBold, 70)
    coinsText:setFillColor( 1, 0, 0 )
end


showTotalCoins()



    local autobusBlu = display.newImageRect("autobus/autobusBlu.png", 150, 390)
    autobusBlu.x = display.contentCenterX
    autobusBlu.y = display.contentCenterY
    local prezzoImage = display.newImageRect("coin.png", 60, 60)
    prezzoImage.x = display.contentCenterX - 70
    prezzoImage.y = display.contentCenterY + 250
    local prezzoText = display.newText( " ".. prezzoBlu, 400, 760, native.systemFontBold, 40)
    prezzoText:setFillColor( 1, 0, 0 ) 
    autobusBlu:addEventListener( "touch", vuoiAcquistareBlu ) 



    local autobusGiallo = display.newImageRect("autobus/autobusGiallo.png", 150, 390)
    autobusGiallo.x = display.contentCenterX - 260
    autobusGiallo.y = display.contentCenterY
    local prezzoImage = display.newImageRect("coin.png", 60, 60)
    prezzoImage.x = display.contentCenterX - 330
    prezzoImage.y = display.contentCenterY + 250
    local prezzoText = display.newText( " ".. prezzoGiallo, 130, 760, native.systemFontBold, 40)
    prezzoText:setFillColor( 1, 0, 0 ) 
    autobusGiallo:addEventListener( "touch", vuoiAcquistareGiallo ) 



    local autobusRosa = display.newImageRect("autobus/autobusRosa.png", 150, 390)
    autobusRosa.x = display.contentCenterX + 260
    autobusRosa.y = display.contentCenterY
    local prezzoImage = display.newImageRect("coin.png", 60, 60)
    prezzoImage.x = display.contentCenterX +190
    prezzoImage.y = display.contentCenterY + 250
    local prezzoText = display.newText( " ".. prezzoRosa, 660, 760, native.systemFontBold, 40)
    prezzoText:setFillColor( 1, 0, 0 )
    autobusRosa:addEventListener( "touch", vuoiAcquistareRosa ) 



local function showLockBlu()
    local lucchetto = display.newImageRect("adesivi/lucchetto.png", 200, 200)
    lucchetto.x = display.contentCenterX
    lucchetto.y = display.contentCenterY
    lucchetto.alpha = 0.8
    autobusBlu:removeEventListener("touch", vuoiAcquistareBlu)
end
local function showLockGiallo()
    local lucchetto = display.newImageRect("adesivi/lucchetto.png", 200, 200)
    lucchetto.x = display.contentCenterX - 260
    lucchetto.y = display.contentCenterY
    lucchetto.alpha = 0.8
    autobusGiallo:removeEventListener("touch", vuoiAcquistareGiallo)

end
local function showLockRosa()
    local lucchetto = display.newImageRect("adesivi/lucchetto.png", 200, 200)
    lucchetto.x = display.contentCenterX + 260
    lucchetto.y = display.contentCenterY
    lucchetto.alpha = 0.8
    autobusRosa:removeEventListener("touch", vuoiAcquistareRosa)

end


if(getTotal()<prezzoBlu) then 
    showLockBlu()
    autobusBlu:removeEventListener("tap", vuoiAcquistareBlu)
end

if(getTotal()<prezzoGiallo) then
    showLockGiallo()
    autobusGiallo:removeEventListener("tap", vuoiAcquistareGiallo)


end
if(getTotal()<prezzoRosa) then
    showLockRosa()
    autobusRosa:removeEventListener("tap", vuoiAcquistareRosa)


end 


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
        menuButton.isVisible = true
        autobusBlu:addEventListener("tap", vuoiAcquistareBlu)
        autobusGiallo:addEventListener("tap", vuoiAcquistareGiallo)
        autobusRosa:addEventListener("tap", vuoiAcquistareRosa)
        showTotalCoins()
        getTotal()

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        autobusBlu:removeEventListener("touch", vuoiAcquistareBlu)
        autobusGiallo:removeEventListener("touch", vuoiAcquistareGiallo)
        autobusRosa:removeEventListener("touch", vuoiAcquistareRosa)
        menuButton.isVisible = false


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

