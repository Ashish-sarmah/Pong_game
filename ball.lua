require 'paddle'
ball = class{}

function ball:init(x,y,radius)
    self.x = x
    self.y = y
    self.dx = math.random(3) < 2 and 100 or -100
    self.dy = math.random(-50,50)*1.5

    self.radius = radius
end

function ball:reset()
    self.x = VIRTUAL_WIDTH/2 -2
    self.y = VIRTUAL_HEIGHT/2 -2
    self.dx = math.random(3) < 2 and 100 or -100
    self.dy = math.random(-50,50)*1.5
end

function ball:update(dt)
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt
end

function ball:render()
    love.graphics.circle('fill', self.x,self.y,self.radius)
end

function ball:collides(paddle)
    
    if self.x + self.radius < paddle.x or paddle.x +paddle.width < self.x then 
        return false
    elseif paddle.y +paddle.height < self.y or self.y + self.radius < paddle.y then
        return false
    else 
        return true
    end
end

function ball:boundary()
    if self.y <= 0 or self.y >= VIRTUAL_HEIGHT -4 then
        return true
    end
end
