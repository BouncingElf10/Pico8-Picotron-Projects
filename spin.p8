pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
		point = {}
		angle = 0
		add(point, {x=sin(angle/360)*7+64,y=cos(angle/360)*7+64})
		add(point, {x=sin((angle+140)/360)*5+64,y=cos((angle+140)/360)*5+64})
		add(point, {x=sin((angle-140)/360)*5+64,y=cos((angle-140)/360)*5+64})
		dx = 0
		dy = 0
		x = 0
		y = 0
		for i=0,16 do
				for j=0,16 do
						if rnd(2) > 1 then
							--	mset(i,j,001)
						end
				end
		end
		meteor = {}
		create_m(6,25,64,64)
end

function _update()
		
		if btn(⬅️) then
				angle -= 10
		end
		if btn(➡️) then
				angle += 10
		end
		
		if btn(⬆️) then
				for i=1, #point do
						dx += sin(angle/360) / 10
						dy += cos(angle/360) / 10
				end
		end
		
		if btn(⬇️) then
				for i=1, #point do
						dx -= sin(angle/360) / 10
						dy -= cos(angle/360) / 10
				end
		end
		
		dx *= 0.95
		dy *= 0.95
		
		x += dx
		y += dy
		
		point[1].x = sin(angle/360)*5+64+x
		point[1].y = cos(angle/360)*5+64+y
		point[2].x = sin((angle+140)/360)*3+64+x
		point[2].y = cos((angle+140)/360)*3+64+y
		point[3].x = sin((angle-140)/360)*3+64+x
		point[3].y = cos((angle-140)/360)*3+64+y
	
		
		camera((point[1].x+point[2].x+point[3].x)/3-64,(point[1].y+point[2].y+point[3].y)/3-64)
		
end

function _draw()
		
		cls()
		map(0,0,0,0,16,16)
		local p = point
		line(p[1].x,p[1].y,p[2].x,p[2].y)
		line(p[2].x,p[2].y,p[3].x,p[3].y)
		line(p[1].x,p[1].y,p[3].x,p[3].y)
		
		for i=1, #meteor do
				for j=1, #meteor[i] do
						if j != #meteor[i] then
								line(meteor[i][j].x,meteor[i][j].y,meteor[i][j+1].x,meteor[i][j+1].y)
						else
								line(meteor[i][j].x,meteor[i][j].y,meteor[i][j+1-#meteor[i]].x,meteor[i][j+1-#meteor[i]].y)
						end
						print(meteor[i][j].x.." "..meteor[i][j].y)
				end
		end
		
		
		print(angle)
		print(sin(angle/360))
		print(dx.." "..dy)
		print(#meteor.." "..#meteor[1])
		
		--print(meteor[1][1].x.." "..meteor[1][1].y)
end
-->8
function create_m(corners, size, x,y)
		temp = {}
		
		for i=1, corners do
				add(temp, {x=sin((angle+rnd(360))/360)*size+x, y=cos(angle+rnd(360)/360)*size+y})
		end
		
		add(meteor, temp)
		
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
