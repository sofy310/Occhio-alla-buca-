local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

composer.gotoScene( "menu" )

--for background music
audio.reserveChannels( 1 )

