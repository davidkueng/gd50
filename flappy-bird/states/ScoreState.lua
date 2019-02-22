--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.goldMedal = love.graphics.newImage('gold_medal.png')
    self.silverMedal = love.graphics.newImage('silver_medal.png')
    self.bronzeMedal = love.graphics.newImage('bronze_medal.png')
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen  

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 130, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 160, VIRTUAL_WIDTH, 'center')

    if self.score < 2 then 
        love.graphics.draw(self.bronzeMedal, VIRTUAL_WIDTH/2-60)
    elseif self.score >= 2 and self.score <= 4 then
        love.graphics.draw(self.silverMedal, VIRTUAL_WIDTH/2-60)
    elseif self.score > 4 then
        love.graphics.draw(self.goldMedal, VIRTUAL_WIDTH/2-60)

    end

    love.graphics.printf('Press Enter to Play Again!', 0, 180, VIRTUAL_WIDTH, 'center')
end