-- The player class
Player = Class{}

require 'Animation'

-- the speed at which the player moves
local MOVE_SPEED = 180

function Player:init()
    self.width = 32
    self.height = 32

    self.x = 0 - (self.width / 2) + 20
    self.y = VIRTUAL_HEIGHT - (self.height / 2) - 40

    self.texture = love.graphics.newImage('graphics/player1.png')
    self.frames = generateQuads(self.texture, self.width, self.height)

    -- starting state
    self.state = 'up'

    -- initialize all player animations
    self.animations = {
        ['up'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[24], self.frames[20]
            },
            interval = 0.15
        },
        ['down'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[28], self.frames[32]
            },
            interval = 0.15
        },
        ['death'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[254]
            },
            interval = 1
        },
        ['death2'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[255]
            },
            interval = 1
        }
    }
    
    -- starting animation
    self.animation = self.animations['up']

    -- initialize all player behaviors
    self.behaviors = {
        ['up'] = function(dt)

            if love.keyboard.isDown('space')then
                if self.y >= 10 then
                    self.y = self.y - MOVE_SPEED * dt
                    MOVE_SPEED = MOVE_SPEED + 3
                    self.animation = self.animations['up']
                    sounds['jetpack']:play()
                end
            elseif self.y <= VIRTUAL_HEIGHT - 45 then
                self.y = self.y + MOVE_SPEED * dt
                MOVE_SPEED = 180
                self.animation = self.animations['down']
            end

        end,
        ['down'] = function(dt)

            if love.keyboard.isDown('space')then
                if self.y >= 10 then
                    self.y = self.y - MOVE_SPEED * dt
                    MOVE_SPEED = MOVE_SPEED + 3
                    self.animation = self.animations['up']
                    sounds['jetpack']:play()
                end
            elseif self.y <= VIRTUAL_HEIGHT - 45 then
                self.y = self.y + MOVE_SPEED * dt
                MOVE_SPEED = 180
                self.animation = self.animations['down']
            end

        end,
        ['death'] = function(dt)
            self.animation = self.animations['death']
            self.x = self.x + 2
        end,
        ['death2'] = function(dt)
            self.animation = self.animations['death2']
            self.x = self.x + 2
        end
    }

end

-- function which is called when the player collides with a vertical laser
function Player:collides(laser)

    if (self.x) + (self.width) >= laser.x and self.x <= laser.x + LASER_WIDTH then
        if (self.y) + (self.height) >= laser.y and self.y <= laser.y + LASER_HEIGHT then
            return true
        end
    end

    return false
end

-- function which is called when the player collides with a horizontal laser
function Player:collides2(laser2)

    if (self.x) + (self.width) >= laser2.x and self.x <= laser2.x + LASER2_WIDTH then
        if (self.y) + (self.height) >= laser2.y and self.y <= laser2.y + LASER2_HEIGHT then
            return true
        end
    end

    return false
end

function Player:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
end

function Player:render()
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), math.floor(self.x), math.floor(self.y))
end