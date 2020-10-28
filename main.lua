--[[
    Vilius Junevicius
    Vilnius, Lithuania
    CS50 final project

    "Survive" - a programmed game written in Lua
    open -n -a love ~/Documents/Games/survive

    2020
]]

push = require 'push'
Class = require 'class'

require 'Player'
require 'Util'
require 'Laser'
require 'Laser2'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- the starting distance
DISTANCE = 0

-- images we load into memory from files to later draw onto the screen and their starting points
background = love.graphics.newImage('graphics/background.png')
backgroundScroll = 0
ground = love.graphics.newImage('graphics/ground.png')
groundScroll = 0

-- speed at which we should scroll our images
BACKGROUND_SCROLL_SPEED = 60
GROUND_SCROLL_SPEED = 120

-- point at which we should loop our background back to x = 0
BACKGROUND_LOOPING_POINT = 512

-- we set scrolling to true at the start
scrolling = true

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Survive')

    math.randomseed(os.time())

    -- fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/newfont.ttf', 14)
    mediumFont2 = love.graphics.newFont("fonts/font.ttf", 24)
    newFont = love.graphics.newFont('fonts/newfont.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/newfont.ttf', 56)
    love.graphics.setFont(newFont)

    -- sounds
    sounds = {
        ['jetpack_start'] = love.audio.newSource('sounds/jetpack_start.aiff', 'static'),
        ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
        ['distance'] = love.audio.newSource('sounds/distance.wav', 'static'),
        ['jetpack'] = love.audio.newSource('sounds/jetpack.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
        ['title_music'] = love.audio.newSource('sounds/title_music.wav', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['title_music']:setLooping(true)

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('title')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

-- the function we call when window is being resized
function love.resize(w, h)
    push:resize(w, h)
end

-- global key pressed function
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

-- called whenever a key is pressed
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- update function
function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

-- function used to display the FPS
function displayFPS(x, y)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH - 40, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

-- function used for displaying the Distance
function displayDistance(x, y)
    love.graphics.setColor(1, 1, 153 / 255, 1)
    love.graphics.setFont(mediumFont)
    love.graphics.print('Distance: ' .. tostring(round(DISTANCE)) .. tostring(' m'), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

-- function used to round numbers to the DecimalPlace
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- function used to render to the screen
function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    displayFPS()

    if restart == false then
        displayDistance()
    end
    
    push:finish()
end