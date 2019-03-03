    -- eliminate brick if we collide with it
    for k, brick in pairs(bricks) do
        if brick.inPlay and ball:collides(brick) then
            score = score + (brick.tier * 200 + brick.color * 25)
            brick:hit()
            powerup.counter = powerup.counter + 1

            -- if we have enough points, recover a point of health
            if score > recoverPoints then
                -- can't go above 3 health
                health = math.min(3, health + 1)

                -- multiply recover points by 2, but no more than 100000
                recoverPoints = math.min(100000, recoverPoints * 2)

                -- play recover sound effect
                gSounds['recover']:play()
            end

            if self:checkVictory() then
                gStateMachine:change('victory')
            end

            -- first, reapply inverted velocity to reset our position

            
            ball.x = ball.x + -ball.dx * dt
            ball.y = ball.y + -ball.dy * dt

            -- hit from the left
            if ball.dx > 0 then
                -- left edge
                if ball.x + 2 < brick.x then
                    ball.dx = -ball.dx
                -- top edge
                elseif ball.y + 1 < brick.y then
                    ball.dy = -ball.dy
                -- bottom edge
                else
                    -- bottom edge
                    ball.dy = -ball.dy
                end
            else
                -- right edge
                if ball.x + 6 > brick.x + brick.width then
                    -- reset ball position
                    ball.dx = -ball.dx
                elseif ball.y + 1 < brick.y then
                    -- top edge
                    ball.dy = -ball.dy
                else
                    -- bottom edge
                    ball.dy = -ball.dy
                end
            end

            -- slightly scale the y velocity to speed up the game
            ball.dy = ball.dy * 1.02

            -- only collide with one brick per turn
            break
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if ball.y >= VIRTUAL_HEIGHT then
        health = health - 1
        gSounds['hurt']:play()