--[[
    GD50 2018
    Breakout Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

Ball = Class{}

function Ball:init(skin)
    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- this will effectively be the color of our ball, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin

    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Ball:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 
    
    return true
    -- if the above aren't true, they're overlapping
 
end

function Ball:playerCollision(target)
    self.y = target.y - 8
    self.dy = -self.dy        
    
    if self.x < target.x + (target.width / 2) and target.dx < 0 then
        -- if the target is moving left...
        if target.dx < 0 then
            self.dx = -math.random(30, 50 + 
                10 * target.width / 2 - (self.x + 8 - target.x))
        end
    else
        -- if the target is moving right...
        if target.dx > 0 then
            self.dx = math.random(30, 50 + 
                10 * (self.x - target.x - target.width / 2))
        end
    end
    gSounds['paddle-hit']:play()
end

function Ball:brickCollision(target, dt)

    score = score + (target.tier * 200 + target.color * 25)
    target:hit()
    powerup.counter = powerup.counter + 1

    -- if we have enough points, recover a point of health
    -- if score > recoverPoints then
    --     -- can't go above 3 health
    --     health = math.min(3, health + 1)

    --     -- multiply recover points by 2, but no more than 100000
    --     recoverPoints = math.min(100000, recoverPoints * 2)

    --     -- play recover sound effect
    --     gSounds['recover']:play()
    -- end   

    if (score == 200 and currentIndex < 4) then
    -- can't go above 3 health
        health = math.min(3, health + 1)
        player = paddleSize[currentIndex + 1]
        currentIndex = currentIndex + 1

    -- multiply recover points by 2, but no more than 100000

    -- play recover sound effect
        gSounds['recover']:play()
    end   

    if (score == 400 and currentIndex < 4) then

        health = math.min(3, health + 1)
        player = paddleSize[currentIndex + 1]
        currentIndex = currentIndex + 1
        gSounds['recover']:play()
    end


    self.x = self.x + -self.dx * dt
    self.y = self.y + -self.dy * dt

    if self.dx > 0 then
        -- left edge
        if self.x + 2 < target.x then
            self.dx = -self.dx
        -- top edge
        elseif self.y + 1 < target.y then
            self.dy = -self.dy
        -- bottom edge
        else
            -- bottom edge
            self.dy = -self.dy
        end
    else
        -- right edge
        if self.x + 6 > target.x + target.width then
            -- reset self position
            self.dx = -self.dx
        elseif self.y + 1 < target.y then
            -- top edge
            self.dy = -self.dy
        else
            -- bottom edge
            self.dy = -self.dy
        end
    end
end


--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

-- function Ball:delete()
--     self.x = 

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

function Ball:render()
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
        self.x, self.y)
end