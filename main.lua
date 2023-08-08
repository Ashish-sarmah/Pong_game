push = require 'push'

class = require 'class'

require 'paddle'
require 'ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PLAYER1_SCORE = 0
PLAYER2_SCORE =0

startmsg = 'PRESS SPACE!'
PADDLE_SPEED = 200

function love.load()

    player1 = paddle(0,30,5,50)
    player2 = paddle(VIRTUAL_WIDTH -4, VIRTUAL_HEIGHT -80,5,50)
    ball = ball(VIRTUAL_WIDTH/2 -2,VIRTUAL_HEIGHT/2 -2,3)

    love.graphics.setDefaultFilter('nearest','nearest')

    math.randomseed(os.time())

    smallfont = love.graphics.newFont("font2.ttf", 12)
    scorefont = love.graphics.newFont("font2.ttf",24)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
    }

    push: setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_HEIGHT,WINDOW_WIDTH,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.window.setTitle('PONG')

    gamestate = 'start'

end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'return' or key == 'space' then
        if gamestate == 'victory' then
            gamestate = 'serve'
        else
            gamestate = 'play'
            startmsg = 'GO!'
        end
    end
end

function love.update(dt)

    if PLAYER1_SCORE >= 3 then
        winner = 1
        gamestate = 'victory'
    elseif PLAYER2_SCORE >= 3 then
        winner = 2
        gamestate = 'victory'
    end

    if gamestate == 'serve' then
        ball.x = VIRTUAL_WIDTH/2 -2
        ball.y = VIRTUAL_HEIGHT/2 -2
        ball.dy = math.random(-50,50)
        
        if prevscorer ==1 then
            ball.dx = 100
        else
            ball.dx = -100
        end
    end


    if love.keyboard.isDown('d') then
        player1.dy = -PADDLE_SPEED
    
    elseif love.keyboard.isDown('c') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)

    if gamestate == 'play' then
        ball:update(dt)
    

        if ball.dx > 0 and ball:collides(player2) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx*1.03
            ball.x = player2.x - 5
            if ball.dy < 0 then
                ball.dy = -math.random(10,75)
            else
                ball.dy = math.random(10,75)
            end
            

        elseif ball.dx < 0 and ball:collides(player1) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx*1.03
            ball.x = player1.x + 4
            if ball.dy < 0 then
                ball.dy = -math.random(10,75)
            else
                ball.dy = math.random(10,75)
            end
        end

        if ball.x <0 then 
            gamestate = 'serve'
            prevscorer = 2
            PLAYER2_SCORE = PLAYER2_SCORE + 1
            sounds['score']:play()
            startmsg = "Player 2 serves"
            
        elseif ball.x > VIRTUAL_WIDTH + 10 then
            gamestate = 'serve'
            prevscorer = 1
            PLAYER1_SCORE= PLAYER1_SCORE +1
            sounds['score']:play()
            startmsg = "Player 1 serves"
            
        end
        
        if ball:boundary() then
            sounds['wall_hit']:play()
            if ball.y <=0 then
                ball.y = ball.y +5
            elseif ball.y >= VIRTUAL_HEIGHT -4 then
                ball.y = ball.y -4
            end
            ball.dy = -ball.dy
        end
    end

end

function love.draw()

    push: apply('start')

    love.graphics.clear(255,255,0,255)
    love.graphics.setColor(0,0,255,255)
    
    if gamestate == 'start' or gamestate == 'serve' or gamestate == 'play' then
        love.graphics.setFont(smallfont)
        love.graphics.printf(startmsg,0,0,VIRTUAL_WIDTH,'center')

        love.graphics.setFont(scorefont)
        love.graphics.print(tostring(PLAYER1_SCORE), VIRTUAL_WIDTH/2 - 130,0)
        love.graphics.print(tostring(PLAYER2_SCORE), VIRTUAL_WIDTH/2 + 120,0)
        
        player1:render()
        player2:render()
        ball:render()  
    elseif gamestate == 'victory' then
        love.graphics.setFont(scorefont)
        finalmessage = "Player " .. tostring(winner) .. ' is the winner'
        love.graphics.printf(finalmessage,0,VIRTUAL_HEIGHT/2 - 50,VIRTUAL_WIDTH,'center')
        PLAYER1_SCORE = 0
        PLAYER2_SCORE = 0
    end  
    

    displayfps()
    push:apply('end')

  
end

function displayfps()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(0,255,0)
    love.graphics.print("FPS is: ".. tostring(love.timer.getFPS()), 10, 10)
end

function love.resize(w,h)
    push:resize(w,h)
end
