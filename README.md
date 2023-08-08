# Pong_game
It's the popular pong game 1972 version.
Primary execution file is 'main.lua'. It imports all other classes like ball, paddle etc. By creating separate classes for all instances in the game it is easier to understand and update.
I have used love2d libraries like love.graphics that is used to draw, write and also responsible for color and font in the game.
I also used love.load function that makes up for the loading the initial configuration of the game.
Also used love.update, love.draw that executes automatically at regular interval of 'dt' time , which actually are the core fuctions for the game as that takes the game on moving.
Finally used love.keypressed that captures enter and spaces to run the game. Also you can quit the game by pressing escape.
In order to randomize the ball motion , used math.random library to choose a random direction of propagation as it hits one of the paddle.


