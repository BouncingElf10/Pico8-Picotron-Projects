pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
		cls()
		cur_x = 1
		cur_y = 1
		line(0,0,127,0,7)
		line(0,0,0,127,7)
		line(127,127,0,127,7)
		line(127,127,127,0,7)
		dir = 1
		stuck = false
		whil = 0
		done = 0
end

function _update60()	
		if (pget(cur_x+2,cur_y) == 7 or pget(cur_x+1,cur_y) == 7) and (pget(cur_x-2,cur_y) == 7 or pget(cur_x-1,cur_y) == 7) and (pget(cur_x,cur_y+2) == 7 or pget(cur_x,cur_y+1) == 7) and (pget(cur_x,cur_y-2) == 7 or pget(cur_x,cur_y-1) == 7) then
				stuck = true
		else
				stuck = false
		end
		
		if stuck then
				for i=1,63 do
						for j=1,63 do
								if not(pget(i*2-1,j*2-1) == 7) then
								  cur_x = i*2-1
								  cur_y = j*2-1
								  if i == 63 and j == 63 then
								  		done = true
								  		spr(1,64,64)
								  		pal(7,8)
								  end
								  return
								end
						end
				end
		else
		
				connected = false
				dir = flr(rnd(4))
				if dir == 0 then
						if not(pget(cur_x+1,cur_y) == 7 or pget(cur_x+2,cur_y) == 7) then
								cur_x += 2
								connected = true
						end
				end
				if dir == 1 then
						if not(pget(cur_x-1,cur_y) == 7 or pget(cur_x-2,cur_y) == 7) then
								cur_x -= 2
								connected = true
						end
				end
				if dir == 2 then
						if not(pget(cur_x,cur_y+1) == 7 or pget(cur_x,cur_y+2) == 7) then
								cur_y += 2
								connected = true
						end
				end
				if dir == 3 then
						if not(pget(cur_x,cur_y-1) == 7 or pget(cur_x,cur_y-2) == 7) then
								cur_y -= 2
								connected = true
						end
				end
		end		
end

function _draw()
		--cls()
		temp_x = cur_x
		temp_y = cur_y
		
		if connected == true then
						pset(cur_x,cur_y,7) 
						if dir == 0 then
								pset(cur_x-1,cur_y,7)
						end 
						if dir == 1 then
								pset(cur_x+1,cur_y,7)
						end
						if dir == 2 then
								pset(cur_x,cur_y-1,7)
						end 
						if dir == 3 then
								pset(cur_x,cur_y+1,7)
						end
				end
				
		if btn(⬆️) then
				pset(cur_x,cur_y,10)
		end	
		
		--rectfill(0,0,80,8,0)
		--print(tostr(stuck).." "..cur_x.." "..cur_y,2,2,7)
end
__gfx__
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
