
local explosion = {}

function explosion.new()
     explosion.displayGroup =display.newGroup()
     return explosion
end
function explosion:initialise(explosionParams)
    explosion.explosionSheet = graphics.newImageSheet(explosionParams.imageSheet, explosionParams.options )
    explosion.sequenceData = explosionParams.sequenceData
end
function explosion.remove_explosion(event)
    local phase = event.phase
    if phase == "loop" then 
        local explosions = event.target
        explosions:removeEventListener( "sprite", explosion.remove_explosion )
        explosions:removeSelf()
        explosions=nil
    end 
end 
function explosion:PlayExplosion(x , y , stringtype)
    local sequence = stringtype or "MiniExplosion"
    local animation = display.newSprite( explosion.explosionSheet, explosion.sequenceData )
    animation:setSequence(sequence)
    animation.x = x 
    animation.y = y - 25
    animation:addEventListener( "sprite", explosion.remove_explosion )
    animation:play()     
end

return explosion