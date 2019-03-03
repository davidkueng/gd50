Powerup = Class{}

function Powerup:init()

    self.width = 16
    self.height = 16
    self.x = math.random(80, 390)
    self.y = VIRTUAL_HEIGHT/2 - 80
    self.dy = 0
    self.counter = 0

end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    return true

end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['power'][4],
        self.x, self.y)
end