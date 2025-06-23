
local ecs = require '
ecs'
local proto = require 'source.util.systems.prototypes'

local wSprites = {
	love.graphics.newImage("assets/editor/debug/warning.png"),
	love.graphics.newImage("assets/editor/debug/alert.png"),
	love.graphics.newImage("assets/editor/debug/suggestion.png")
}
local wColors = {
	255/255, 198/255, 26/255,
	255/255, 39/255, 42/255,
	77/255, 122/255, 253/255
}

function normalize(x,y)
	local m = math.sqrt(x^2+y^2)
	if(m==0)then return 0,0 end
	return x/m,y/m
end

function aabb(a,b)
return (a.x<b.x+b.w and
		a.x+a.w>b.x and
		a.y<b.y+b.h and
		a.y+a.h>b.y)
end

function sign(n)
	return n == 0 and 0 or math.abs(n)/n 
end

function warning(text,col)
	for k,e in ecs.filter({"offset"}) do
       	e.offset = e.offset+4*10
    end
	local obj=proto.spatial:new{offset=0,text=text,fade=0,ap=1,col=col}
    ecs.add(obj)
    
end

function warningDraw()
	for k,e in ecs.filter({"offset"}) do
       	e.fade = e.fade+1
       	if e.fade > 80 then
       		e.ap = e.ap-0.05
       	end
       	if e.ap <= 0 then
       		ecs.delete(e)
       	end
       	love.graphics.setFont(fntMain)
       	love.graphics.setColor(wColors[(e.col*3)+1],wColors[(e.col*3)+2],wColors[(e.col*3)+3], e.ap)
       		love.graphics.print(e.text, 4*16, 4*5 +e.offset)
       	love.graphics.setColor(1,1,1,e.ap)
       		love.graphics.draw(wSprites[e.col+1],4*5,4*7+e.offset,0,4,4)
       	love.graphics.setColor(1,1,1,1)
    end

    
    

end


return {
	normalize=normalize,
	aabb=aabb,
	sign=sign,
	warning=warning,
	warningDraw=warningDraw,
}