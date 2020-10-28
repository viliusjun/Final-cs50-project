-- laser class for the vertical laser
Laser = Class{}

local LASER_IMAGE = love.graphics.newImage('graphics/onelaser_vertical.png')

-- the speed at which the laser will be scrolling
local LASER_SCROLL = -300

-- laser height and width
LASER_HEIGHT = 49
LASER_WIDTH = 8

function Laser:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = math.random(0, VIRTUAL_HEIGHT - 65)
    self.width = LASER_IMAGE:getWidth()
end

function Laser:update(dt)
    self.x = self.x + LASER_SCROLL * dt
    LASER_SCROLL = LASER_SCROLL - 0.005
end

function Laser:render()
    love.graphics.draw(LASER_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end