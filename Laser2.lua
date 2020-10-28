-- laser class for the horizontal laser
Laser2 = Class{}

local LASER2_IMAGE = love.graphics.newImage('graphics/onelaser_horizontal.png')

-- the speed at which the laser will be scrolling
local LASER2_SCROLL = -300

-- laser height and width
LASER2_HEIGHT = 8
LASER2_WIDTH = 49

function Laser2:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = math.random(0, VIRTUAL_HEIGHT - 24)
    self.width = LASER2_IMAGE:getWidth()
end

function Laser2:update(dt)
    self.x = self.x + LASER2_SCROLL * dt
    LASER2_SCROLL = LASER2_SCROLL - 0.005
end

function Laser2:render()
    love.graphics.draw(LASER2_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end