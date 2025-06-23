local ecs = require 'source.util.systems.ecs'
local proto = require 'source.util.systems.prototypes'
local screen = require 'source.util.systems.screen'
local json = require 'source.libraries.jsonSys.json'
local util = require "source.util.systems.util"
local stage = require "source.util.game.stage"

local mouseClicked = false
local mouseClickProcessed = false

local yoff = 0
local tt = 0

local room = -1

local mxo,myo,md = 0,0,false

local TSsel = 1
local gameWidth,gameHeight = 256,256
local grabbing = -1
local dc = 0

local Tilesel = 1

mode=1



function love.mousepressed(_, _, button)
    if mouseClickProcessed == false then
    if button == 1 then
        mouseClicked = true
    end
    if button == 2 then
        rightClicked = true
    end
    end
end

function love.mousereleased(_, _, button)
    if button == 1 and mouseClicked and not love.mouse.isDown(1) then
        mouseClickProcessed = true
        mouseClicked = false
    end
    if button == 2 and mouseClicked and not love.mouse.isDown(2) then
        mouseClickProcessed = true
        rightClicked = false
    end
end



function drawRect(c,n)
            n = n*4
            local box = love.graphics.newImage("assets/editor/roomEdges.png")
            local quad = love.graphics.newQuad(0,n, 4,4, box)
            love.graphics.draw(box,quad, c.x,c.y)
            local quad = love.graphics.newQuad(4,n, 4,4, box)
            love.graphics.draw(box,quad, c.x+c.w-1,c.y)
            local quad = love.graphics.newQuad(8,n, 4,4, box)
            love.graphics.draw(box,quad, c.x,c.y+c.h-1)
            local quad = love.graphics.newQuad(12,n, 4,4, box)
            love.graphics.draw(box,quad, c.x+c.w-1,c.y+c.h-1)
            for i = 0,c.h/4 do
                local quad = love.graphics.newQuad(16,n, 4,4, box)
                love.graphics.draw(box,quad, c.x,c.y+i*4)
            end
            for i = 0,c.w/4 do
                local quad = love.graphics.newQuad(20,n, 4,4, box)
                love.graphics.draw(box,quad, c.x+i*4,c.y+c.h-1)
            end
            for i = 0,c.h/4 do
                local quad = love.graphics.newQuad(24,n, 4,4, box)
                love.graphics.draw(box,quad, c.x+c.w-1,c.y+i*4)
            end
            for i = 0,c.w/4 do
                local quad = love.graphics.newQuad(28,n, 4,4, box)
                love.graphics.draw(box,quad, c.x+i*4,c.y)
            end
end

bb = {x=0,y=0,w=0,h=0}

return {
    init = function()end,


    draw = function(self)
        local mmult 
        local camx,camy = screen.toWorld()
        if mode == 0 then mmult = 8 else mmult = 4 end
        for i = 0,gameWidth/mmult do
            for j = 0,gameHeight/mmult do
                
                if j % 2 == 0 then
                    if i % 2 == 1 then
                        love.graphics.setColor(34/255,34/255,34/255)
                        love.graphics.rectangle("fill", i*mmult, j*mmult, mmult, mmult)
                    else
                        love.graphics.setColor(17/255,17/255,17/255)
                        love.graphics.rectangle("fill", i*mmult, j*mmult, mmult, mmult)
                    end
                else 
                    if i % 2 == 0 then
                        love.graphics.setColor(34/255,34/255,34/255)
                        love.graphics.rectangle("fill", i*mmult, j*mmult, mmult, mmult)
                    else
                        love.graphics.setColor(17/255,17/255,17/255)
                        love.graphics.rectangle("fill", i*mmult, j*mmult, mmult, mmult)
                    end
                end
                love.graphics.setColor(255,255,255)
            end
        end
        
        local mx, my = screen.mousePos()
        local mouse
        if mmult == 8 then
            mouse = love.graphics.newImage("assets/editor/editorMouse.png")
        else
            mouse = love.graphics.newImage("assets/editor/editorMouseSmall.png")
        end
        love.graphics.draw(mouse,math.floor((mx+camx)/mmult)*mmult,math.floor((my+camy)/mmult)*mmult)
    end,
    savelevel = function()
        --temp saving script
        if love.keyboard.isDown("a") then
            print("Trying to save stage to JSON")
            local values = {}
            local n = 1
                for k,e in ecs.filter({"save"}) do
                    values[n] = e
                    n = n+1
                end

            local encoded = json.encode(values)
            local file = io.open("levels/level1.json", "w")
            if file then
                print(encoded)
                file:write(encoded)
                file:close()
                print ("wrote to file")
            else
                print("Failed to write file")
            end

            
        end
    end;


--create rects for levels
map = function()
    
    local camx,camy = screen.toWorld()
    local mxr, myr = screen.mousePos()
    local mx, my = screen.mousePos()
    mx = mx+camx
    my = my+camy
    local mxF = math.floor((mxr+camx)/4)*4 
    local myF = math.floor((myr+camy)/4)*4

    local inbox = false

    if love.mouse.isDown(3) then
        if md==false then
            md = true
            mxo = mx
            myo = my
        end
        screen.camera(mxo-mxr,myo-myr)
    else
        md = false
    end


    if dc > 0 then
        dc = dc-1
    end

    for k,e in ecs.filter({"box"}) do
        drawRect(e,e.col)
            for k, l in pairs(e.level) do
                local box = love.graphics.newImage("assets/editor/roomEdges.png")
                local quad = love.graphics.newQuad(32,0, 4,4, box)
                love.graphics.draw(box,quad, e.x+l.x/2,e.y+l.y/2)
                
            end
        --check if im being grabbed and if so move based on mouse offset
        if grabbing == e then
            e.x = mxF-omx
            e.y = myF-omy
        end

        --shrink and grow
        if grabbing == e then
            if love.keyboard.isDown("down")  then
                if e.buttony == false then
                    e.buttony = true
                    e.h = e.h+4
                end 
            elseif love.keyboard.isDown("up") and e.h ~= 1 then
                if e.buttony == false then
                    e.buttony = true
                    e.h = e.h-4
                end
            else
                e.buttony = false
            end
            if love.keyboard.isDown("left") and e.w ~= 1 then    
                if e.buttonx == false then
                    e.buttonx = true
                    e.w = e.w-4
                end
            elseif love.keyboard.isDown("right") then    
                if e.buttonx == false then
                    e.buttonx = true
                    e.w = e.w+4
                end
            else
                e.buttonx = false
            end
        end



        --if aabb with mouse and the mouse isnt creating a stage, i can be grabbed
        if util.aabb(e,{x=mx,y=my,w=1,h=1}) and creatingStage == false or grabbing == e then
            --mouse is in box
            inbox = true
            --yellow
            e.col = 1


            if mouseClickProcessed then
                
                if dc > 0 then
                    for k,f in ecs.filter({"box"}) do
                        
                        if util.aabb(e,f) and e ~= f then
                            util.warning("Level Bounds Intersect With Another",1)
                        end
                    end

                    mode = 0
                    gameWidth = e.w*2
                    gameHeight = e.h*2
                    room = e
                    stage.loadLevel(e.level)
                else
                    dc = 20
                end
                --print("Mouse was clicked this frame!")
                mouseClickProcessed = false
            end
            

            --mouse pressed to grab and is not holding another rect
            if love.mouse.isDown(1) and grabbing == -1 then
                grabbing = e
                omx = mxF-e.x
                omy = myF-e.y
            elseif not love.mouse.isDown(1) then
                --if mouse is not down reset grab state
                grabbing = -1
            end
        else
            --if not being hovered become white
            e.col = 0
        end
        --if inside another box be red
        for k,f in ecs.filter({"box"}) do
            if util.aabb(e,f) and e ~= f then
                e.col = 3
            end
        end
    end
        
    if love.mouse.isDown(1) and inbox == false  then
        if creatingStage == false then
            omx = mxF
            omy = myF
        end
        local hh = myF-omy+1
        local yy = omy
        if hh <0 then
            yy = myF
            hh = omy-myF-3
        end
        local ww = mxF-omx+1
        local xx = omx
        if ww <0 then
            xx = mxF
            ww = omx-mxF-3
        end
        creator = {x=xx,y=yy,w=ww,h=hh}
        love.graphics.setFont(fntMainSmall)
        love.graphics.print(tostring(((ww-1)/4)+1)..", "..tostring(((hh-1)/4)+1),xx,yy-12)
        drawRect(creator,0)
        creatingStage = true
    else
        if creatingStage == true then
            if creator.h == 1 and creator.w == 1 then

            else 
                local obj=proto.spatial:new{x=creator.x,y=creator.y,w=creator.w,h=creator.h,box=true,col=0,level={},buttonx=false,buttony=false}
                ecs.add(obj)        
            end
            
        end
        creatingStage = false
    end   
end,

paint = function()
    local camx,camy = screen.toWorld()
    local mx, my = screen.mousePos()
    local mxF = math.floor((mx+camx)/8)*8
    local myF = math.floor((my+camy)/8)*8
    


    if love.mouse.isDown(3) then
        if md==false then
            md = true
            mxo = mx+camx
            myo = my+camy
        end
        screen.camera(mxo-mx,myo-my)
    else
        md = false
    end
    
    local camx,camy = screen.toWorld()
  
    
    if love.keyboard.isDown("s") then
        
        local values = {}
        local n = 1
        for k,e in ecs.filter({"save"}) do
            values[n] = e
            n = n+1
        end
        for k,e in ecs.filter({"save"}) do
                    ecs.delete(e)
            end

        room.level = values
        print(#room.level)
        room = -1
        mode = 1
        gameWidth = 256
        gameHeight = 256
    end

    if omx ~= mxF or omy ~= myF  then 

        if love.mouse.isDown(2)  then
            
            for k,e in ecs.filter({"save"}) do
                if e.x == mxF and e.y == myF then
                    ecs.delete(e)
                    print("goob")
                end
            end
        end 
        if mxF > -1 and mxF < gameWidth and myF > -1 and myF < gameHeight then
        if love.mouse.isDown(1) then
            omx = mxF
            omy = myF
            for k,e in ecs.filter({"save"}) do
                if e.x == mxF and e.y == myF then
                    ecs.delete(e)
                end
            end
            local obj=proto.spatial:new{x=mxF,y=myF,sprite=TSsel,quad=Tilesel,name="tile",canCollide=true,save=true}
            ecs.add(obj)
            
        end
    end
    end
    
end,

drawUi = function()
    local screenWidth,screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    local tilesets = {"assets/sprites/testSheet.png","assets/editor/roomEdges.png"}
    local names = {"Debug Grids","Map Sprites"}
    local heights = {24,16}
    local widths = {24,40}

    local mx, my = love.mouse.getX(),love.mouse.getY()

    local s = screenWidth/1920

    local TotalDown = 0

    love.graphics.setColor(55/255, 55/255, 55/255)
    love.graphics.rectangle("fill",0,0,400*s,screenHeight)
    love.graphics.setColor(1, 1, 1)
    for k = 1,#names do
        local yy = 15*s+(k-1) + TotalDown*s
        TotalDown = TotalDown+160
        love.graphics.setFont(fntMain)
        
        love.graphics.print(names[k],15*s,yy,0,s,s)

        local ow = love.graphics.newImage("assets/editor/outlineWhite.png")
        local og = love.graphics.newImage("assets/editor/outlineGreen.png")

        local sheets = {}
        sheets[k] = {
            texture = love.graphics.newImage(tilesets[k]),
            quads={}
        }
      
        local sheet = sheets[k]
        for y=0,((heights[k]/8)-1) do
            for x=0,((widths[k]/8)-1) do
                table.insert(sheet.quads,love.graphics.newQuad(x*8,y*8, 8,8, widths[k],heights[k]))
                 
            end
        end

        local down = 0
        local side = 0

        for i = 1,(heights[k]/8)*(widths[k]/8) do
            local posX = 15*s+(side)*s*90
            local posY = yy+down*s+60*s

            local ww = {x=posX,y=posY,w=8*8*s,h=8*8*s}


            if util.aabb(ww,{x=mx,y=my,w=1,h=1}) then
                if love.mouse.isDown(1) then
                    TSsel = k
                    Tilesel = i
                end
                love.graphics.draw(og,posX-8*s,posY-8*s ,0,s*8,s*8)
            end


            if TSsel == k and Tilesel == i then
                love.graphics.draw(ow,posX-8*s,posY-8*s ,0,s*8,s*8)
            end
            love.graphics.draw(sheet.texture,sheet.quads[i],posX,posY ,0,s*8,s*8)
            side = side+1
            if i % 4 == 0 then
                down = down + 90
                TotalDown = TotalDown+100
                side = 0
            end

            
        end

    end
    
end;

}

--for k,e in pairs(ecs) do
    --do whatever with ecs
--end           


