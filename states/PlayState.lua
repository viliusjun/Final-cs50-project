-- the play state class
PlayState = Class{__includes = BaseState}

-- we set a global variable reset to false at the start of play state class
restart = false

--global variable tracking the longest distance reached
BEST = 0

function PlayState:init()
    player = Player()
    lasers = {}
    lasers2 = {}
    spawnTimer = 0
end

function PlayState:update(dt)
    -- if the player is not dead then do the following
    if scrolling == true then
        sounds['title_music']:stop()
        sounds['music']:play()

        -- scroll background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

        -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
            % VIRTUAL_WIDTH

        -- timer
        spawnTimer = spawnTimer + dt

        -- we start counting the distance traveled
        DISTANCE = DISTANCE + 0.1

        -- we start spawning vertical lasers
        time = math.random(0.25, 12)
        if spawnTimer > time then
            table.insert(lasers, Laser())
            spawnTimer = 0
            time = math.random(0.25, 12)
        end

        -- we start spawning horizontal lasers
        time2 = math.random(0.25, 12)
        if spawnTimer > time2 then
            table.insert(lasers2, Laser2())
            spawnTimer = 0
            time2 = math.random(0.25, 12)
        end

        -- we update the player
        player:update(dt)

        -- if we reached a new best distance, play the sound
        if (DISTANCE > BEST and DISTANCE < BEST + 0.5 and BEST ~= 0) then
            sounds['distance']:play()
        end

        -- we update the vertical lasers
        for k, laser in pairs(lasers) do
            laser:update(dt)
            time = math.random(0.25, 12)

            -- we check if we collided with any of them 
            for l, laser in pairs(lasers) do
                if player:collides(laser) then
                    player.animation = player.animations['death']
                    player.animation:update(dt)
                    player.animation = player.animations['death2']
                    player.animation:update(dt)
                    sounds['music']:stop()
                    sounds['jetpack']:stop()
                    sounds['death']:play()
                    restart = true
                    scrolling = false
                    if (BEST < DISTANCE) then
                        BEST = DISTANCE
                    end
                end
            end

            -- we remove the lasers from the table that go over the edge of the screen
            if laser.x < -laser.width then
                table.remove(lasers, k)
                time = math.random(0.25, 12)
            end
        end

        -- do the same with the horizontal lasers
        for k, laser2 in pairs(lasers2) do
            laser2:update(dt)
            time2 = math.random(0.25, 12)

            for l, laser2 in pairs(lasers2) do
                if player:collides2(laser2) then
                    player.animation = player.animations['death']
                    player.animation:update(dt)
                    player.animation = player.animations['death2']
                    player.animation:update(dt)
                    sounds['music']:stop()
                    sounds['jetpack']:stop()
                    sounds['death']:play()
                    restart = true
                    scrolling = false
                    if (BEST < DISTANCE) then
                        BEST = DISTANCE
                    end
                end
            end

            if laser2.x < -laser2.width then
                table.remove(lasers2, k)
                time2 = math.random(0.25, 12)
            end
        end

    -- if we press enter or return we change the state to title
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
        scrolling = true
    end

end

-- render funtion
function PlayState:render()
    for k, laser in pairs(lasers) do
        laser:render()
    end

    for k, laser2 in pairs(lasers2) do
        laser2:render()
    end

    love.graphics.setFont(newFont)

    player:render()

    -- text written when the player dies
    if restart == true then
        love.graphics.setFont(newFont)
        love.graphics.printf('Distance: ' .. tostring(round(DISTANCE)) .. tostring(' m'), 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press Enter to restart', 0, 85, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Best score: ' .. tostring(round(BEST)) .. tostring(' m'), 0, 250, VIRTUAL_WIDTH, 'center')
    end
end
