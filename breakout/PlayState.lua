--[[
    GD50 2018
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    ball.dx = math.random(-200, 200)
    -- give a random y velocity, but add an amount (capped) based on the level
    ball.dy = math.random(-50, -60) - math.min(100, level * 5)

    ballTwo.dx = math.random(-200, 200)
    -- -- give a random y velocity, but add an amount (capped) based on the level
    ballTwo.dy = math.random(-50, -60) - math.min(100, level * 5)

    ballThree.dx = math.random(-200, 200)
    -- -- give a random y velocity, but add an amount (capped) based on the level
    ballThree.dy = math.random(-50, -60) - math.min(100, level * 5)

    powerup.dy = math.random(20, 40)
    powerup.counter = 0
    powerupInplay = 0

    -- keep track of whether the game is paused
    self.paused = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end

        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['music']:resume()
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['music']:pause()
        gSounds['pause']:play()
        return
    end
    -- player input
    playerMove(dt)
    -- update positions based on velocity
    player:update(dt)
    ball:update(dt)   

    if powerup:collides(player) then   
        powerupInplay = powerupInplay + 2
    end

    if powerupInplay >= 1 then
        ballTwo:update(dt)
        ballThree:update(dt)
    end

    if powerup.counter >= 1 then
        powerup:update(dt)
    end 

    -- bounce the ball back up if we collide with the paddle
    if ball:collides(player) then
        ball:playerCollision(player)
    end

    if ballTwo:collides(player) then
        ballTwo:playerCollision(player)
    end

    if ballThree:collides(player) then
        ballThree:playerCollision(player)
    end

    -- eliminate brick if we collide with it // not sure if it works when only checking for victory once
    for k, brick in pairs(bricks) do
        if brick.inPlay and ball:collides(brick) then      
                
            ball:brickCollision(brick, dt)           
        end

        if brick.inPlay and ballTwo:collides(brick) then       
            ballTwo:brickCollision(brick, dt)           
        end

        if brick.inPlay and ballThree:collides(brick) then       
            ballThree:brickCollision(brick, dt)          
        end    
            
        if self:checkVictory() then
            resetPowerup()
            gStateMachine:change('victory')
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if ball.y >= VIRTUAL_HEIGHT then
        health = health - 1
        if currentIndex > 1 then 
            player = paddleSize[currentIndex - 1]
            currentIndex = currentIndex - 1
        end
        gSounds['hurt']:play()

        if health == 0 then
            resetPowerup()
            gStateMachine:change('game-over')
        else
            resetPowerup()
            gStateMachine:change('serve', player.skin)
        end
    end

    for k, brick in pairs(bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    player:render()
    ball:render()

    renderBricks()
    renderScore()
    renderHealth()

    if powerup.counter >= 1 then
        powerup:render()
    end

    if powerupInplay > 1 then
        ballTwo:render()  
        ballThree:render()  
    end

    function resetPowerup()
        powerupInplay = 0
        powerup.counter = 0
    end

    for k, brick in pairs(bricks) do
        brick:renderParticles()
    end

    -- current level text
    love.graphics.setFont(smallFont)
    love.graphics.printf('Level ' .. tostring(level),
        0, 4, VIRTUAL_WIDTH, 'center')

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(largeFont)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end
