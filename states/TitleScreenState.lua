-- title state class
TitleScreenState = Class{__includes = BaseState}

require 'Animation'

function TitleScreenState:init()
    sounds['title_music']:play()

    self.width = 32
    self.height = 32

    self.x = 0 - (self.width / 2) + 255
    self.y = VIRTUAL_HEIGHT - (self.height / 2) - 30

    self.texture = love.graphics.newImage('graphics/player1.png')
    self.frames = generateQuads(self.texture, self.width, self.height)

    -- starting state
    self.state = 'idle'

    -- initialize all player animations
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[2]
            },
            interval = 0.15
        },
        ['walking_right'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[4], self.frames[8]
            },
            interval = 0.15
        },
        ['walking_left'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[5], self.frames[9]
            },
            interval = 0.15
        }
    }

    -- starting animation
    self.animation = self.animations['idle']

    -- initialize all player behaviors
    self.behaviors = {
        ['idle'] = function(dt)

            if love.keyboard.isDown('d') and self.x < VIRTUAL_WIDTH - 23 then
                self.animation = self.animations['walking_right']
                self.x = self.x + 2
            elseif love.keyboard.isDown('a') and self.x >= 0 then
                self.animation = self.animations['walking_left']
                self.x = self.x - 2
            else
                self.animation = self.animations['idle']
            end

        end
    }
end

function TitleScreenState:update(dt)
    -- change title state to play state if enter is pressed
    if ( love.keyboard.wasPressed('return') or love.keyboard.wasPressed('return') ) and self.x > -5 and self.x < 2 then
        restart = false
        DISTANCE = 0
        gStateMachine:change('play')
        sounds['music']:play()
        self.animation:update(dt)
    end

    -- update behavior and animation
    self.behaviors[self.state](dt)
    self.animation:update(dt)
end

function TitleScreenState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Survive', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('Come to the side\n and press Enter', -200, 200, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), math.floor(self.x), math.floor(self.y))
end