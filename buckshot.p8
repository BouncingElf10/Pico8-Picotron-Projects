pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function game_init()
		debug = false
		table_x = 3
		table_y = 0
		name = input_text
		init_hand()
		cursor(64,64)
		ammo = {}
		gen_ammo()
		angle = -15
		gun_x = 25
		gun_y = 48
		gun_dy = 13
		player_health = total_lives
		dealer_health = total_lives
		show_player_health = player_health
		show_dealer_health = dealer_health
		render_text_bool = true
		draw_ammo_bool = false
		turn_complete = false
		--fade_time = 0
		fade_loop = 0
		turn = "none"
		glitch_factor = 32
		black_out = false
		flash = false
		main_turn = 3
		spanw_in = true
		ammo_text = false
		end_text_bool = true
		generate_end = true
		spot = 0
		blood_init()
		shells_in = 0
		talk_sound = true
		fired_blank = true
end

function game_update()
		update_hand()
		update_ammo()
		main()
		blood_update()
end

function game_draw()
		cls()
		render_table()
		map(0,0,0,0,16,16)
		if draw_ammo_bool then
				draw_ammo()
		end
		blood_draw()
		draw_points()
		draw_gun()
		draw_hand()
		if ammo_text then
				if ammo_live == 1 and ammo_blank == 1 then
						ammo_text = ammo_live.." live.  "..ammo_blank.." blank.."
				elseif ammo_live == 1 and ammo_blank != 1 then
						ammo_text = ammo_live.." live.  "..ammo_blank.." blanks.."
				elseif ammo_live != 1 and ammo_blank == 1 then
						ammo_text = ammo_live.." lives.  "..ammo_blank.." blank.."
				else
						ammo_text = ammo_live.." lives.  "..ammo_blank.." blanks.."
				end
				
				if talk_sound then
						if flr(rnd(2)) == 0 then
								sfx(20)
						else
								sfx(21)
						end
				end
				
				spot+=0.5
				spot%=#ammo_text+1
				outline(sub(ammo_text,1,spot),61-(#ammo_text*2.5),72,0,7)
				if spot > #ammo_text-1 then
						spot -= 1
						talk_sound = false
				end
		else
				spot = 0
		end
	
		if render_text_bool == true then
				render_text()	
		end
		
		if flash == true then
				pal()
				rectfill(0,0,127,127,10)
		end
		
		if black_out == true then
				pal()
				rectfill(0,0,127,127,0)
		end
		
		if glitch == true then
				glitchfx(glitch_factor)
				glitch_factor -= 1
				if glitch_factor == 0 then
						glitch_factor = 32
				end
		end
		
		if debug then
				print(player_health,100,110,7)
				print(dealer_health,100,10,7)
				print(text_input(),0,0,7)
				print(fade_loop)
				print(gun_y)
				print(gun_dy)
				print(turn)
				print(left_hand_x.." "..left_hand_y.." "..anim_step_l)
				print(black_out)
				print(fade_time)
				print(debug,10)
				for i=1,#ammo do
						if ammo[i] == true then
								print(ammo[i],8)
						else
								print(ammo[i],11)
						end	
				end
		end
end
-->8
--render
function render_table()
		for i=0,15 do
  		for j=0,9 do
    		local sprite_index = j + i * 16
    		if sprite_index < 128 then
    				--mset(j+table_x, i+table_y, 010)
    		else
    				mset(j+table_x, i+table_y, sprite_index)
  				end
  		end
		end
end

function render_text()
		if cursor_y < 35 then
				spr(012,56,10)
				outline("dealer",44,20,10,0)
		else
				outline("dealer",44,20,0,7)
		end
		if cursor_y > 100 then
				spr(013,57,115)
				outline(name,58-(#name*2.5),105,10,0)
		else
				outline(name,58-(#name*2.5),105,0,7)
		end
end

function outline(s,x,y,c1,c2)
	for i=0,2 do
	 for j=0,2 do
	  if not(i==1 and j==1) then
	   print(s,x+i,y+j,c1)
	  end
	 end
	end
	print(s,x+1,y+1,c2)
end

local fadetable={
 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 {1,1,129,129,129,129,129,129,129,129,0,0,0,0,0},
 {2,2,2,130,130,130,130,130,128,128,128,128,128,0,0},
 {3,3,3,131,131,131,131,129,129,129,129,129,0,0,0},
 {4,4,132,132,132,132,132,132,130,128,128,128,128,0,0},
 {5,5,133,133,133,133,130,130,128,128,128,128,128,0,0},
 {6,6,134,13,13,13,141,5,5,5,133,130,128,128,0},
 {7,6,6,6,134,134,134,134,5,5,5,133,130,128,0},
 {8,8,136,136,136,136,132,132,132,130,128,128,128,128,0},
 {9,9,9,4,4,4,4,132,132,132,128,128,128,128,0},
 {10,10,138,138,138,4,4,4,132,132,133,128,128,128,0},
 {11,139,139,139,139,3,3,3,3,129,129,129,0,0,0},
 {12,12,12,140,140,140,140,131,131,131,1,129,129,129,0},
 {13,13,141,141,5,5,5,133,133,130,129,129,128,128,0},
 {14,14,14,134,134,141,141,2,2,133,130,130,128,128,0},
 {15,143,143,134,134,134,134,5,5,5,133,133,128,128,0}
}

function fade(i)
 for c=0,15 do
  if flr(i+1)>=16 then
   pal(c,0)
  else
   pal(c,fadetable[c+1][flr(i+1)])
  end
 end
end

function fade_render()
		if fade_in == true then
				fade(fade_time)
				if fade_time < 15 then
						fade_time += 1
				end
		elseif fade_out == true then
				fade(fade_time)
				if fade_time > 0 then
						fade_time -= 1
				end
		end
		
end

function glitchfx(lines)
	local lines=lines or 64
	
	for i=1,lines do
		row=flr(rnd(128))
		row2=flr(rnd(127))
		if (row2>=row) row2+=1
		
		// copy a row from the
		// screen into temp memory
		memcpy(0x4300, 0x6000+64*row, 64)
		
		//copy another row from the
		// screen to our original row
		memcpy(0x6000+64*row, 0x6000+64*row2, 64)
		       
		//copy the temp row into row2's
		//original slot
		memcpy(0x6000+64*row2, 0x4300,64)
	end
end

function draw_points()
		for i=0,show_dealer_health - 1 do
				spr(031,100,45 - (i*6))
		end
		for i=0,show_player_health - 1 do
				spr(031,100,71 + (i*6))
		end	
end
-->8
--hands
function init_hand()
		right_table = {}
		left_hand = {
    {x=0, y=0, rad=6},
    {x=-7, y=0, rad=4},
    {x=-11, y=5, rad=3},
    {x=-12, y=9, rad=3},
    {x=6, y=0, rad=2},
    {x=9, y=1, rad=2},
    {x=11, y=4, rad=2},
    {x=0, y=6, rad=3},
    {x=0, y=11, rad=3},
		}
		right_hand = {
    {x=0, y=0, rad=6},
    {x=7, y=2, rad=4},
    {x=10, y=7, rad=3},
    {x=11, y=11, rad=3},
    {x=-7, y=0, rad=2},
    {x=-11, y=2, rad=2},
    {x=-10, y=1, rad=2},
    {x=-12, y=5, rad=2},
    {x=-2, y=7, rad=3},
    {x=-3, y=12, rad=3},
		}
		grab_right_hand = {
    {x=0, y=0, rad=6},
    {x=6, y=2, rad=4},
    {x=7, y=8, rad=3},
    {x=7, y=9, rad=3},
    {x=-6, y=1, rad=3},
    {x=-7, y=5, rad=2},
    {x=-7, y=8, rad=2},
    {x=-1, y=7, rad=3},
    {x=-1, y=11, rad=3},
		}
		grab_left_hand = {
    {x=0, y=0, rad=6},
    {x=-6, y=2, rad=4},
    {x=-9, y=7, rad=3},
    {x=1, y=6, rad=3},
    {x=0, y=10, rad=3},
    {x=6, y=0, rad=2},
    {x=7, y=4, rad=2},
    {x=8, y=8, rad=2},
    {x=5, y=2, rad=2},
    {x=8, y=6, rad=2},
		}

		hand_anim_l = false
		hand_anim_r = false
		current_left = left_hand
		current_right = right_hand
		left_hand_x = 40
		left_hand_y = 7
		right_hand_x = 79
		right_hand_y = 7
		anim_step_l = 1
		anim_step_r = 1
end


function draw_hand()
		for i=1, #current_left do
				circfill(left_hand_x + current_left[i].x,left_hand_y + current_left[i].y,current_left[i].rad+1,6)
		end
		for i=1, #current_right do
				circfill(right_hand_x + current_right[i].x,right_hand_y + current_right[i].y,current_right[i].rad+1,6)
		end	
		for i=1, #current_left do
				circfill(left_hand_x + current_left[i].x,left_hand_y + current_left[i].y,current_left[i].rad,7)
		end
		for i=1, #current_right do
				circfill(right_hand_x + current_right[i].x,right_hand_y + current_right[i].y,current_right[i].rad,7)
		end
end

function update_hand()
		hand_idle()
end

function move_left_hand(x, y, tick, cost)
  if cost == "open" then
  		current_left = left_hand
  elseif cost == "closed" then
  		current_left = grab_left_hand
  end
  
  if not hand_anim_l then
		  x_dif_l = x - left_hand_x
				y_dif_l = y - left_hand_y
				x_move_l = x_dif_l/tick
				y_move_l =	y_dif_l/tick
				hand_anim_l = true
		end
		
		if hand_anim_l then
				left_hand_x += x_move_l
				left_hand_y	+= y_move_l
				if abs(left_hand_x - x) <= 1 and abs(left_hand_y - y) <= 1 then
						hand_anim_l = false
						return true
				end
		end
end

function move_right_hand(x, y, tick, cost)
  if cost == "open" then
  		current_right = right_hand
  elseif cost == "closed" then
  		current_right = grab_right_hand
  end
  
  if not hand_anim_r then
		  x_dif_r = x - right_hand_x
				y_dif_r = y - right_hand_y
				x_move_r = x_dif_r/tick
				y_move_r =	y_dif_r/tick
				hand_anim_r = true
		end
		
		if hand_anim_r then
				right_hand_x += x_move_r
				right_hand_y	+= y_move_r
				if abs(right_hand_x - x) <= 1 and abs(right_hand_y - y) <= 1 then
						hand_anim_r = false
						return true
				end
		end
end

function hand_idle()
		for i=1, #current_left do
				local time_ = time() + i/10 * i/15
				current_left[i].y += sin(time_/4*(abs(dealer_health-total_lives+1)))/10		
		end
		for i=1, #current_right do
				local time_ = time() + i/10 * i/15 -1
				current_right[i].y += sin(time_/4*(abs(dealer_health-total_lives+1)))/10		
		end
end
-->8
--contorls

function cursor_update()
		cursor_x = stat(32)-1 + offset_x
		cursor_y = stat(33)-1 + offset_y
end

function d_pad_control()
		speed = 3
		if btn(⬆️) then offset_y -= speed end
		if btn(⬇️) then offset_y += speed end
		if btn(⬅️) then offset_x -= speed end
		if btn(➡️) then offset_x += speed end
end

function return_ending(won)
		if won then
				return winning_messages[flr(rnd(#winning_messages))+1]		
		else
				return losing_messages[flr(rnd(#losing_messages))+1]		
		end
end

losing_messages = {
    "come on. you can \ndo better than that. ",
    "we've been doing \nthis same song and \ndance for years. \nwhy do you still \ncontinue to fail? ",
    "your taste in \ngames is awful. \ngo play something \nelse. ",
    "start paying \nattention. you're \ngetting sloppy. ",
    "remember me? \ni remember you. ",
    "hello, we meet \nagain. sorry i had \nto cut our talk \nshort. ",
    "it was nice seeing \nyou again. so sad \nit had to be cut \nshort. ",
    "how many times are \nwe going to repeat \nthis little scene?",
    "persistence or \nfoolishness? i \ncan't tell with \nyou anymore. ",
    "you keep coming \nback, but i'll keep \nwatching you fall. ",
    "you're making this \ntoo easy. care to \ntry again? ",
    "back so soon? \ni was just starting \nto enjoy our break. ",
    "another attempt, \nanother failure. \nsome things never \nchange. ",
    "you're so \npredictable. i \ncould almost write \nthe script myself. ",
    "all that effort... \njust to meet me \nhere once again. ",
    "why do you even \ntry? we both know \nhow this ends. ",
    "you just keep \ngetting worse. am \ni supposed to be \nimpressed? ",
    "why do you insist \non trying? you're \nonly delaying the \ninevitable. ",
    "another failure \nto add to the list. \nbetter luck \nnext time. ",
    "face it, you'll \nnever be rid \nof me. ",
}

winning_messages = {
    "glad to see \nyou're paying \nattention. you've \ngot this. ",
    "glad to see you've \nstill got your \nhead in the game. ",
    "we both die \ntonight, one of us, \na bit later than \nthe other. ",
    "good job, see you \nagain soon. ",
    "nice work. i was \nalmost starting to \nworry about you. ",
    "you held on... \nthis time. don't \nlose focus now. ",
    "you slipped through \nthat one… barely. ",
    "keep this up, and \nyou might actually \nmake it out alive. ",
    "that was close. \ndon't let your \nguard down yet. ",
    "you're proving \nyourself, \nstep by step. ",
    "impressive. but \ndon't think it'll \nbe easy from here. ",
    "well played. but \ni'm always \nwatching. ",
    "not bad at all. i \nalmost thought you \nwouldn't make it. ",
    "survived this one? \nluck or skill? \nlet's find out. ",
    "nice save. it's \nlike you actually \nwant to live. ",
    "well done. just \ndon't expect it to \nget any easier. ",
    "a narrow escape, \nbut you're still in \nthe game. ",
    "you've bought \nyourself a little \nmore time. use it \nwisely. ",
    "still here? \nimpressive... but \ni'm not done yet. ",
    "you made it this \ntime. but i'm just \ngetting started. ",
}


-->8
--ammo gun

function draw_gun()
		spr_r(1,gun_x,gun_y,angle,9,4)
end

function gen_ammo()
  local count = rnd(4) + 2
  local full_count = 0
  local empty_count = 0
    
  for i = 1, count do
    if rnd(1) > 0.5 then
      add(ammo, true)
      full_count += 1
    else
      add(ammo, false)
      empty_count += 1
    end
  end
  
  if full_count == 0 then
    ammo[1] = true
  elseif empty_count == 0 then
    ammo[1] = false
  end
  --[[
 	ammo = {}
 	ammo[1] = false
 	ammo[2] = true
 	--(debug)
 	--]]
end

function draw_ammo()
		for i=1,ammo_live do
				spr(014, 67+i*3, 57)
		end
		for i=1,ammo_blank do
				spr(015, 67+i*3+(ammo_live*3), 57)
		end
end

function update_ammo()
		ammo_live = 0
		ammo_blank = 0
		
		for i=1, #ammo do
				if ammo[i] == true then
						ammo_live += 1
				else
						ammo_blank += 1
				end
		end	
end

function spr_r(s,x,y,a,w,h)
 sw=(w or 1)*8
 sh=(h or 1)*8
 sx=(s%8)*8
 sy=flr(s/8)*8
 x0=flr(0.5*sw)
 y0=flr(0.5*sh)
 a=a/360
 sa=sin(a)
 ca=cos(a)
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   dx=ix-x0
   dy=iy-y0
   xx=flr(dx*ca-dy*sa+x0)
   yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
    if sget(sx+xx,sy+yy) != 0 then
    	pset(x+ix,y+iy,sget(sx+xx,sy+yy))
   	end
   end
  end
 end
end
-->8
--main game loop

function text_input()
		if cursor_y < 35 and (stat(34) == 1 or btnp(❎)) then
				return "dealer"
		elseif cursor_y > 100 and (stat(34) == 1 or btnp(❎)) then
				return "player"
		else
				return "none"
		end
end

function main()
		if #ammo == 0 then
				gen_ammo()
				main_turn = 3
				spanw_in = false
		end
		
		if main_turn == 1 then
				m_continue, m_live, m_turn = players_turn()
				if	m_continue then
						if not m_live and m_turn == "player" then
								main_turn = 1
								if #ammo != 0 then
										render_text_bool = true
								end
						else
								main_turn = 2
						end
						reset_turn()
						deli(ammo, 1)
						turn_complete = false
						continue = false
				end
		elseif main_turn == 2 then
				
				m_continue, m_live, m_turn = dealers_turn()
		
				if	m_continue then
						if not m_live and m_turn == "dealer" then
								main_turn = 2
						else
								main_turn = 1
								if #ammo != 0 then
										render_text_bool = true
								end
						end
						reset_turn()
						deli(ammo, 1)
				end
		elseif main_turn == 3 then
				m_continue = show_ammo_anim(spanw_in)
				if	m_continue then
						main_turn = 1
						reset_turn()
						render_text_bool = true
				end
		end		
end

function show_ammo_anim(spawn)
		render_text_bool = false
		fade_loop += 1
		if fade_loop < 72 then
				if spawn then
						return_hand_table(false)
				end
		elseif fade_loop < 73 then
				anim_step_r = 1
		elseif fade_loop < 137 then
				move_right_hand(75, 55, 64, "closed")
		elseif fade_loop < 150 then
				draw_ammo_bool = true
				move_right_hand(75, 55, 64, "open")
		elseif fade_loop < 182+40 then
				ammo_text = true
				move_right_hand(75, 40, 32, "open")
		elseif fade_loop < 204+40 then

		elseif fade_loop < 236+40 then
				move_right_hand(75, 55, 32, "open")
				move_left_hand(55, 55, 32, "open")
				ammo_text = false
		elseif fade_loop < 296+40 then
				sfx(19)
				draw_ammo_bool = false
				move_right_hand(75, -25, 64, "closed")
				move_left_hand(45, -28, 64, "closed")
				gun_y = left_hand_y-8
				gun_x = left_hand_x-32
		elseif fade_loop < 297+40 then
					
		elseif fade_loop < 380+40 then
				if fade_loop%10 == 0 and shells_in < (ammo_live + ammo_blank) then
						sfx(18)
						shells_in += 1
				end
		elseif fade_loop < 416+40 then
				fade_in = true
				fade_out = false
		elseif fade_loop < 417+40 then
				init_hand()
				angle = -15
				gun_x = 25
				gun_y = 48
		elseif fade_loop < 433+40 then
				fade_in = false
				fade_out = true
		elseif fade_loop < 463+40 then
		
		else
				return true
		end
end

function reset_turn()
		fade_loop = 0
		anim_step_l = 1
		anim_step_r = 1
		gun_dy = 13
		show_player_health = player_health
		show_dealer_health = dealer_health
		turn_complete = false
		shells_in = 0
		talk_sound = true
		fired_blank = true
end

function dealers_turn()
		local live = false
		if ammo[1] == true then
				live = true
		else
				live = false
		end

			
		if turn_complete == false then
				--dealer ai
				chance_player = ammo_live/ammo_blank
				chance_random = flr(2)
				if chance_player < 1 or not chance_random == 1 then
						shoot = "dealer"
				else if chance_player > 1 or not chance_random == 1 then
						shoot = "player"
				else
						if rnd(1) > 0.5 then
								shoot = "dealer"
						else
								shoot = "player"
						end
					end
				end	
			--	shoot = "dealer" --debug
				if shoot == "player" then
						if live then player_health -= 1 end
						render_text_bool = false
						turn_complete = true
						turn = "player"
				elseif shoot == "dealer" then
						if live then dealer_health -= 1 end
						render_text_bool = false
						turn_complete = true
						turn = "dealer"
				end
		end
		
		if turn_complete == true then
				fade_loop += 1
				if fade_loop < 128 then
						grab_gun()
				elseif fade_loop < 129 then
						anim_step_l = 1
						anim_step_r = 1
						glitch_factor = 32
						gun_y += 2.002
						--play sound
				elseif fade_loop < 169 then
						--wait for sound
				elseif fade_loop < 200 then
						
						if live == true then
								if fade_loop < 170 then
										splat = true
										if shoot == "dealer" then
												create_splatter(64, -10, true)
												sfx(22)
										else 
												create_splatter(64, 137, false)
												sfx(22)	
										end
								end
								if fade_loop < 173 then
										flash = true
								else
										if shoot == "player" then
											black_out = true
										end
										flash = false
								end
								--fire
						else
									if fired_blank then
											sfx(23)
											fired_blank = false
									--didnt fire
									end
							end
				else
						if live and turn == "dealer" then
								gun_y += gun_dy
								gun_dy /= 1.2
								if fade_loop > 250 then
											return_hand_table(true)
								end
						elseif live and turn == "player" then
								if fade_loop > 205 then
										black_out = false
								end
								fade_in = false
								fade_out = true
								if fade_loop < 230 then
										glitch = true
								else
										glitch = false
								end
								gun_x = 25
								gun_y = 48
								angle = -15
								return_hand_table(true)
						else
								return_gun()
						end
				end
				if not live then
						if fade_loop > 340 then
								return true, live, shoot
						end
				else
						if shoot == "player" then
								if fade_loop > 280 then
										return true, live, shoot
								end
						else
								if fade_loop > 305 then
										return true, live, shoot
								end
						end
				end
		end
end

function players_turn()
		local live = false
		if ammo[1] == true then
				live = true
		else
				live = false
		end	
			
		if turn_complete == false then
				if text_input() == "player" then
						if live then player_health -= 1 end
						render_text_bool = false
						turn_complete = true
						turn = "player"
				elseif text_input() == "dealer" then
						if live then dealer_health -= 1 end
						render_text_bool = false
						turn_complete = true
						turn = "dealer"
				end
		end
		
		if turn_complete == true then
				fade_loop += 1
				if fade_loop < 16 then
						fade_in = true
						fade_out = false
				elseif fade_loop < 40 then
						if live == true then
								if fade_loop < 17 then
										splat = true
										if turn == "dealer" then
												create_splatter(64, -10, true)
												sfx(22)
										else 
												create_splatter(64, 137, false)
												sfx(22)
										end
								end
								if fade_loop < 20 then
										flash = true
								else
										flash = false
								end
								--fire
						else
								if fired_blank then
										sfx(23)
										fired_blank = false
								--didnt fire
								end
						end
				else
						if turn == "dealer" and live == true then
								return_hand_table(true)
						end
						if turn == "player" and live == true and fade_loop < 64 then
								glitch = true
						else
								glitch = false
						end
						fade_in = false
						fade_out = true
						if fade_loop > 100 then
								return true, live, turn
						end
				end
		end
end

function return_hand_table(r_hand)
		if anim_step_l == 1 then
				if	move_left_hand(40, -20, 1, "open") then
						anim_step_l = 2
				end
		elseif anim_step_l == 2 then
				if	move_left_hand(40, 7, 48, "open") then
						anim_step_l = 3
				end
		end
		-----------
		if r_hand then
				r_cost = "open"
		else
				r_cost = "closed"
		end
		
		if anim_step_r == 1 then
				if	move_right_hand(79, -20, 1, r_cost) then
						anim_step_r = 2
				end
		elseif anim_step_r == 2 then
				if	move_right_hand(79, 7, 48, r_cost) then
						anim_step_r = 3
				end
		end
end

function grab_gun()
		if anim_step_l == 1 then
				if	move_left_hand(40, 62, 64, "open") then
						anim_step_l = 2
				end
		elseif anim_step_l == 2 then
				gun_y -= 1.25
				angle += 0.1
				if	move_left_hand(40, -25, 64, "closed") then
						anim_step_l = 3
				end
		end
		-----------
		if anim_step_r == 1 then
				if	move_right_hand(75, 44, 64, "open") then
						anim_step_r = 2
				end
		elseif anim_step_r == 2 then
				sfx(19)
				if	move_right_hand(75, -25, 58, "closed") then
						anim_step_r = 3
				end
		end
end

function return_gun()
		if anim_step_l == 1 then
				if gun_y < 48 then
						gun_y += 1.25
				end
				sfx(19)
				if	move_left_hand(40, 62, 64, "closed") then
						anim_step_l = 2
				end
		elseif anim_step_l == 2 then
				if	move_left_hand(40, 7, 48, "open") then
						anim_step_l = 3
				end
		end
		-----------
		if anim_step_r == 1 then
				if	move_right_hand(75, 44, 56, "closed") then
						anim_step_r = 2
				end
		elseif anim_step_r == 2 then
				if	move_right_hand(79, 7, 48, "open") then
						anim_step_r = 3
				end
		end
end




-->8
--blood

function blood_init()
    blood = {}
    blood_trails = {}
    splat = false
end

function blood_update()
    if splat then
        update_particles()
        update_trails()
    end
end

function blood_draw()
    for i=1,#blood_trails do
        local t = blood_trails[i]
        if t.y > 123 or t.y < 4 then
        		circfill(t.x, t.y, t.s, 2)
    				else
    						circfill(t.x, t.y, t.s, 8)    				
    				end
    end

    for i=1,#blood do
        local p = blood[i]
        if p.y > 123 or p.y < 4 then
        		circfill(p.x, p.y, p.s, 2)
        else
        		circfill(p.x, p.y, p.s, 8)
        end     
    end
end

function create_splatter(x, y, down)
    blood = {}
    for i=1,20 do
    				local angle
    				if down then
        		angle = rnd(180) / -360
        else
        		angle = rnd(180) / 360
        end
        local speed = rnd(2) + 8
        local particle = {
            x = x,
            y = y,
            dx = cos(angle) * speed,
            dy = sin(angle) * speed,
            s = rnd(2) + 1
        }
        add(blood, particle)
    end
end

function update_particles()
    for i=#blood,1,-1 do
        local p = blood[i]
        
        if flr(rnd(2)) == 1 then
            add(blood_trails, {x = p.x, y = p.y, s = p.s / 2, life = 1.7})
        else
            add(blood_trails, {x = p.x, y = p.y, s = p.s, life = 1.7})
        end

        p.x += p.dx
        p.y += p.dy
        p.dx *= 0.75
        p.dy *= 0.75

        if p.s > 0.1 then
            p.s -= 0.05
        end

        if abs(p.dx) < 0.1 and abs(p.dy) < 0.1 and p.s <= 0.1 then
           del(blood, p)
        end
    end
end

function update_trails()
    for i=#blood_trails,1,-1 do
        local t = blood_trails[i]
        if t.life < 1 then
        		t.s -= 0.01
        end
        
        t.life -= 0.01 / rnd(10)
        if t.life <= 0 or t.s <= 0 then
            del(blood_trails, t)
        end
    end
end

-->8
	-- main menu
local hex_size = 16
local hex_height = 72
total_lives = 3

offset_x = 0
offset_y = 0

vertices = {}
faces = {}

shells = {}
max_shells = 6  -- maximum simultaneous shells

keys = {
    "q","w","e","r","t","y","u","i","o","p",
    "a","s","d","f","g","h","j","k","l",
    "z","x","c","v","b","n","m", "delete"
}
key_positions = {}  -- store positions of keys for detection
input_text = ""     -- store the text typed

-- keyboard layout settings
key_size = 8
spacing = 2
start_x = 10
start_y = 80

function menu_init()
				music(0)
				select_pos = 0
				title_screen = true
				screen = 0
				
    make_hexagon()
    for i=1,4 do
        spawn_shell()
    end
end

function spawn_shell()
  if #shells >= max_shells then return end
    local shell = {
        x = rnd(128),  -- random x position
        y = -hex_height/2,  -- start above screen
        z = 0,
        rot = {
            x = rnd(1),
            y = rnd(1),
            z = rnd(1)
        },
        rot_speed = {
            x = (rnd(2)-1)*0.02,  -- random rotation speed
            y = (rnd(2)-1)*0.02,
            z = (rnd(2)-1)*0.02
        },
        fall_speed = 0.5 + rnd(1)  -- random fall speed
    }
    add(shells, shell)
end

function make_hexagon()
    vertices = {}
    faces = {}
    
    local yellow_height = hex_height * 0.2
    
    for i=0,5 do
        local angle = i * (1/6)
        local x = cos(angle) * hex_size
        local z = sin(angle) * hex_size
        
        -- top vertex (red section)
        add(vertices, {
            x=x, y=-hex_height/2, z=z
        })
        -- bottom of red section/top of yellow
        add(vertices, {
            x=x, y=hex_height/2 - yellow_height, z=z
        })
        -- bottom vertex (yellow section)
        add(vertices, {
            x=x, y=hex_height/2, z=z
        })
    end
    
    -- generate faces
    -- top face (red)
    local top = {}
    for i=1,16,3 do
        add(top, i)
    end
    add(faces, {verts=top, col=8})  -- red top
    
    -- bottom face (yellow)
    local bottom = {}
    for i=3,18,3 do
        add(bottom, i)
    end
    add(faces, {verts=bottom, col=10})  -- yellow bottom
    
    -- side faces - red section (alternating colors)
    local red_colors = {2,136,8,14,8,136}  -- alternating shades of red
    for i=1,16,3 do
        local next_i = (i + 3 - 1) % 18 + 1
        add(faces, {
            verts={i, i+1, next_i+1, next_i},
            col=red_colors[flr(i/3)+1]  -- alternate red shades
        })
    end
    
    -- side faces - yellow section
    for i=2,17,3 do
        local next_i = (i + 3 - 1) % 18 + 1
        add(faces, {
            verts={i, i+1, next_i+1, next_i},
            col=10  -- yellow
        })
    end
end

function menu_update()
    if rnd(1) < 1 then  -- 2% chance each frame
        spawn_shell()
    end
    
   	for i=#shells,1,-1 do
        local shell = shells[i]
        
        shell.rot.x += shell.rot_speed.x
        shell.rot.y += shell.rot_speed.y
        shell.rot.z += shell.rot_speed.z
        
        shell.y += shell.fall_speed
        
        if shell.y > 64 + hex_height then
            deli(shells, i)
        end
    end
end

function menu_draw()
    cls(0)
    scr="⁶-b⁶x8⁶y8                \n    ⁶-#ᶜ6⁶.\0\0█\0\0\0█\0⁸⁶-#ᶜ7⁶.\0\0xxxxxx⁶-#ᶜ6⁶.\0\0¹\"\"\0ᶠ\0⁸⁶-#ᶜ7⁶.\0\0おううお██⁶-#ᶜ6⁶.\0\0⁴⁴⁴⁴⁴⁴⁸⁶-#ᶜ7⁶.\0\0れネリリリリ⁶-#ᶜ6⁶.\0\0ᶜ▮¹\0\0\0⁸⁶-#ᶜ7⁶.\0\0³¹████⁶-#ᶜ6⁶.\0\0000\0\0\0\0\0⁸⁶-#ᶜ7⁶.\0\0ウんんんんん⁶-#ᶜ6⁶.\0\0\0\0\0\0\0ユ⁸⁶-#ᶜ7⁶.\0\0\0¹³リリ³⁶-#ᶜ6⁶.\0\0█\0\0🐱²¹⁸⁶-#ᶜ7⁶.\0\0pxxqqx⁶-#ᶜ6⁶.\0\0	▮\0⁸\0\0⁸⁶-#ᶜ7⁶.\0\0⁶ᵉ゛⁷ᵉ゛⁶-#    \n    ⁶.xxx\0\0\0\0\0⁶.███\0\0\0\0\0⁶-#ᶜ6⁶.⁴⁴d\0\0\0\0\0⁸⁶-#ᶜ7⁶.リネ⬇️\0\0\0\0\0⁶-#ᶜ6⁶.¹▮ᶜ\0\0\0\0\0⁸⁶-#ᶜ7⁶.█¹³\0\0\0\0\0⁶-#ᶜ6⁶.\0\0★\0\0\0\0\0⁸⁶-#ᶜ7⁶.んんl\0\0\0\0\0⁶-#⁶.³¹\0\0\0\0\0\0⁶-#ᶜ6⁶.\0\0き\0\0\0\0\0⁸⁶-#ᶜ7⁶.xx@\0\0\0\0\0⁶-#ᶜ6⁶.\0▮⁴\0\0\0\0\0⁸⁶-#ᶜ7⁶.゛ᵉ³\0\0\0\0\0⁶-#    \n                \n ⁶-#ᶜ6⁶.¹¹¹¹¹¹¹¹⁸⁶-#ᶜ7⁶.◜>>>>>◜>⁶-#ᶜ6⁶.\0\0²\0²\0\0@⁸⁶-#ᶜ7⁶.?~ュュュ~?>⁶-#ᶜ6⁶.@\0\0\0²\0\0\0⁸⁶-#ᶜ7⁶.█ユヲュュ◜◜◜⁶-#ᶜ6⁶. ▒\0\0\0\0\0\0⁸⁶-#ᶜ7⁶.゜xユユユユユユ⁶-#⁶.ユユヨリリリリリ⁶-#ᶜ6⁶.⁴⁴⁴⁴⁴⁴⁴⁴⁸⁶-#ᶜ7⁶.⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⁶-#ᶜ6⁶.🐱🐱🐱🐱🐱🐱🐱🐱⁸⁶-#ᶜ7⁶.||||||||⁶-# ⁶.ヲヲヲヲヲヲヲヲ⁶.◝¹¹¹¹¹゜¹⁶-#ᶜ6⁶.\0@@@@@@@⁸⁶-#ᶜ7⁶.ュ███████⁶-#ᶜ6⁶.\0▮▮▮▮▮▮▮⁸⁶-#ᶜ7⁶.◝ᶠᶠᶠᶠᶠᶠᶠ⁶-#ᶜ6⁶.²\0\0\0\0\0\0\0⁸⁶-#ᶜ7⁶.ン\0\0\0\0\0\0\0⁶-#⁶.◝???????⁶-#ᶜ6⁶.⁴\0\0\0\0\0\0\0⁸⁶-#ᶜ7⁶.³\0\0\0\0\0\0\0\n⁶-# ⁶-#ᶜ6⁶.¹¹¹¹¹\0\0\0⁸⁶-#ᶜ7⁶.>>>>>\0\0\0⁶-#ᶜ6⁶.\0████\0\0\0⁸⁶-#ᶜ7⁶.|||||\0\0\0⁶-#ᶜ6⁶.\0\0\0\0@\0\0\0⁸⁶-#ᶜ7⁶.ュュヲユ█\0\0\0⁶-#ᶜ6⁶.\0\0\0▒▮\0\0\0⁸⁶-#ᶜ7⁶.ユユユxᶠ\0\0\0⁶-#ᶜ6⁶.\0²\0\0@\0\0\0⁸⁶-#ᶜ7⁶.リヨヨナ█\0\0\0⁶-#ᶜ6⁶.⁴⁴\0⁸ \0\0\0⁸⁶-#ᶜ7⁶.⬇️⬇️♥g゜\0\0\0⁶-#ᶜ6⁶.🐱🐱🐱🐱²\0\0\0⁸⁶-#ᶜ7⁶.||||ュ\0\0\0⁶-#ᶜ6⁶.\0\0\0\0@\0\0\0⁸⁶-#ᶜ7⁶.\0\0\0\0?\0\0\0⁶-#⁶.????◝\0\0\0⁶.\0\0\0\0゜\0\0\0⁶-#ᶜ6⁶.⁸⁸⁸⁸⁸\0\0\0⁸⁶-#ᶜ7⁶.ユユユユユ\0\0\0⁶-#ᶜ6⁶.²²²²²\0\0\0⁸⁶-#ᶜ7⁶.¹¹¹¹¹\0\0\0⁶-#⁶.ナナナナナ\0\0\0⁶.⁷⁷⁷⁷⁷\0\0\0 "
    
    for shell in all(shells) do
        draw_shell(shell)
    end
    sx, sy = (26 % 16) * 8, (26 \ 16) * 8
    
    if title_screen then
		  		?scr, 3, 0
		  		sspr(sx, sy,8,8,85,7,16,16)
		  end
		  if screen == 0 then
				  outline("sTART gAME", 35, 90, 0,7)
						outline("sETTINGS", 43, 100, 0, 6)
						if select_pos == 0 then
								spr(027,25,89)
						elseif select_pos == 1 then
								spr(027,34,99)
						end
				elseif screen == 1 then
						outline("lIVES:", 48, 30, 0,7)
						outline("nAME:", 47, 54, 0,7)
						outline(total_lives, 60, 42, 0,7)
						outline(input_text,61-(#input_text*2.5), 66, 2,7)
						
						line(44,51,81,51,7)
						line(44,39,81,39,7)
						spr(028,54,41)
						spr(029,64,41)
						outline("rETURN", 47, 110, 0,7)
						if select_pos == 0 then
								spr(027,38,53)
						elseif select_pos == 1 then
								spr(027,38,29)
						elseif select_pos == 2 then
								spr(027,38,109)
						end
						draw_keyboard()
				end
				
				print("cpu: "..flr(stat(1)*100).."%", 0, 120, 5)		
				
end

function draw_keyboard()
    local row_offset = 0  -- offset for row alignment
    local row_length = 10 -- number of keys in the top row
    
    for i, key in ipairs(keys) do
        -- calculate row and column
        local row = flr((i - 1) / row_length)
        local col = (i - 1) % row_length
        row_offset = (row == 1 and 4) or (row == 2 and 12) or 0

        -- calculate x and y position for each key
        local x = start_x + col * (key_size + spacing) + row_offset
        local y = start_y + row * (key_size + spacing)
        
        -- special case for the "delete" key (place it in the bottom-right corner)
        if key == "delete" then
            x = start_x + 9 * (key_size + spacing)  -- place at the end of the row
            y = start_y + 2 * (key_size + spacing)  -- place in the bottom row
        end
        
        -- draw the key background
        rectfill(x, y, x + key_size, y + key_size, 5)
        
        -- adjust text position to center it within the key
        local text_x = x + (key_size / 2) - 2  -- center horizontally
        local text_y = y + (key_size / 2) - 2  -- center vertically

        -- shift w, m, and v one pixel to the left
        if key == "w" or key == "m" or key == "v" then
            text_x -= 1
        end
        
        -- handle "delete" key text differently
        if key == "delete" then
            print("⬅️", text_x-1, text_y, 7)
        else
            print(key, text_x, text_y, 7)
        end
        
        -- save position for mouse detection
        key_positions[i] = {key = key, x = x, y = y}
    end
end

-- check if a key is clicked
function check_key_click()
    local mouse_x, mouse_y = cursor_x, cursor_y
    if current_mouse_state == 1 and prev_mouse_state == 0 or btnp(❎) then  -- if mouse clicked
        for i, key_info in ipairs(key_positions) do
            local kx, ky = key_info.x, key_info.y
            if mouse_x >= kx and mouse_x <= kx + key_size and
               mouse_y >= ky and mouse_y <= ky + key_size then
                if key_info.key == "delete" then
                    -- remove the last character if "delete" is clicked
                    input_text = sub(input_text, 1, #input_text - 1)
                else
                    -- append the character to input_text
                    input_text = input_text .. key_info.key
                end
            end
        end
    end
end


function draw_shell(shell)
    local cx,sx = cos(shell.rot.x),sin(shell.rot.x)
    local cy,sy = cos(shell.rot.y),sin(shell.rot.y)
    local cz,sz = cos(shell.rot.z),sin(shell.rot.z)
    
    local proj = {}
    for v in all(vertices) do
        local x,y,z = v.x,v.y,v.z
        
      		local ny = y*cx - z*sx
        local nz = y*sx + z*cx
        y,z = ny,nz
        
        local nx = x*cy + z*sy
        nz = -x*sy + z*cy
        x,z = nx,nz
        
        nx = x*cz - y*sz
        ny = x*sz + y*cz
        x,y = nx,ny
        
        local scale = 32/(128+z)
        add(proj, {
            x = 64 + shell.x - 64 + x*scale,  -- offset by shell position
            y = shell.y + y*scale,
            z = z
        })
    end
    
    local sorted = {}
    for f in all(faces) do
        local z = 0
        for v in all(f.verts) do
            z += proj[v].z
        end
        z /= #f.verts
        add(sorted, {face=f, z=z})
    end
    sort(sorted, function(a,b) 
        return a.z < b.z 
    end)
    
    for f in all(sorted) do
        local pts_x = {}
        local pts_y = {}
        for v in all(f.face.verts) do
            add(pts_x, proj[v].x)
            add(pts_y, proj[v].y)
        end
        
        fillp()
        poly(#pts_x, pts_x, pts_y, f.face.col)
        
        for i=1,#pts_x do
            local j = i % #pts_x + 1
            line(pts_x[i],pts_y[i],
                 pts_x[j],pts_y[j],
                 f.face.col)
        end
    end
end

function sort(arr, compare)
    for i=1,#arr do
        for j=1,#arr-i do
            if compare(arr[j+1], arr[j]) then
                arr[j], arr[j+1] = arr[j+1], arr[j]
            end
        end
    end
    return arr
end

function poly(n,x,y,c)
    local pts = {}
    for i=1,n do
        add(pts,{x=x[i],y=y[i]})
    end
    
    local minx,maxx,miny,maxy=999,-999,999,-999
    for i=1,n do
        minx=min(minx,x[i])
        maxx=max(maxx,x[i])
        miny=min(miny,y[i])
        maxy=max(maxy,y[i])
    end
    
    for sy=miny,maxy do
        local intersects = {}
        for i=1,n do
            local j = i%n + 1
            local y1,y2 = y[i],y[j]
            if (y1 <= sy and y2 > sy) or
               (y2 <= sy and y1 > sy) then
                local x1,x2 = x[i],x[j]
                if y1 != y2 then
                    local t = (sy-y1)/(y2-y1)
                    add(intersects,x1+t*(x2-x1))
                end
            end
        end
        sort(intersects,function(a,b) return a<b end)
        for i=1,#intersects-1,2 do
            local x1,x2=intersects[i],intersects[i+1]
            rectfill(x1,sy,x2,sy,c)
        end
    end
end
-->8
init_menu = true
update_menu = true
draw_menu = true
poke(0x5600,unpack(split"6,8,6,0,0,1,0,0,0,0,0,0,0,0,0,0,85,32,112,64,102,22,101,117,96,119,112,112,0,85,103,7,18,112,0,6,80,6,38,0,0,119,6,33,0,103,96,118,5,112,112,7,112,22,39,17,0,112,7,34,17,119,117,3,0,0,96,102,96,0,96,96,0,96,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,3,0,0,0,5,5,0,0,0,0,0,0,54,127,54,127,54,0,0,0,30,7,31,28,15,4,0,4,13,12,6,3,11,0,0,0,30,11,30,11,30,8,0,8,1,1,0,0,0,0,0,0,6,3,3,3,6,0,0,0,3,6,6,6,3,0,0,0,2,7,2,0,0,0,0,0,12,12,63,12,12,0,0,0,0,0,0,3,3,2,0,0,0,0,7,0,0,0,0,0,0,0,0,3,3,0,0,0,12,12,6,3,3,0,0,0,14,27,27,27,14,0,0,0,7,6,6,6,6,0,0,0,7,12,6,3,15,0,0,0,15,12,6,12,15,0,0,0,27,27,31,24,24,0,0,0,15,3,15,12,7,0,0,0,12,6,31,27,14,0,0,0,15,12,6,3,3,0,0,0,14,27,14,27,14,0,0,0,14,27,31,12,6,0,0,0,3,3,0,3,3,0,0,0,3,3,0,3,3,2,0,0,12,6,3,6,12,0,0,0,0,7,0,7,0,0,0,0,3,6,12,6,3,0,0,0,14,27,24,0,4,0,0,0,62,99,107,51,6,28,0,0,0,14,27,27,54,0,0,0,3,15,27,27,15,0,0,0,0,14,3,3,14,0,0,0,24,30,27,27,30,0,0,0,0,30,27,15,30,0,0,0,6,3,7,3,3,0,0,0,0,30,27,27,28,14,0,0,3,15,27,27,27,0,0,0,3,0,3,3,3,0,0,0,0,6,6,6,6,3,0,0,3,27,15,31,27,0,0,0,3,3,3,3,6,0,0,0,0,62,107,99,99,0,0,0,0,14,27,27,27,0,0,0,0,14,27,27,14,0,0,0,0,14,27,27,15,3,0,0,0,30,27,27,30,24,0,0,0,14,3,3,3,0,0,0,0,14,3,12,7,0,0,0,3,7,3,3,6,0,0,0,0,27,27,27,14,0,0,0,0,51,51,30,12,0,0,0,0,99,99,107,62,0,0,0,0,27,14,14,27,0,0,0,0,27,27,27,30,24,0,0,0,15,12,6,15,0,0,0,7,3,3,3,7,0,0,0,3,3,6,12,12,0,0,0,7,6,6,6,7,0,0,0,2,7,0,0,0,0,0,0,0,0,0,0,15,0,0,0,3,3,2,0,0,0,0,0,14,27,31,27,27,0,0,0,15,27,15,27,15,0,0,0,14,3,3,3,14,0,0,0,15,27,27,27,15,0,0,0,15,3,7,3,15,0,0,0,15,3,7,3,3,0,0,0,14,3,3,27,14,0,0,0,27,27,31,27,27,0,0,0,15,6,6,6,15,0,0,0,7,6,6,6,3,0,0,0,51,27,15,27,51,0,0,0,3,3,3,3,15,0,0,0,99,119,127,107,99,0,0,0,51,55,63,59,51,0,0,0,30,51,51,51,30,0,0,0,15,27,27,15,3,0,0,0,14,27,27,27,14,24,0,0,15,27,27,15,27,0,0,0,14,3,15,12,7,0,0,0,15,6,6,6,6,0,0,0,27,27,27,27,14,0,0,0,99,99,54,54,28,0,0,0,99,107,127,119,34,0,0,0,51,30,12,30,51,0,0,0,51,51,30,12,12,0,0,0,15,12,6,3,15,0,0,0,14,6,7,6,14,0,0,0,3,3,3,3,3,0,0,0,7,6,14,6,7,0,0,0,0,14,219,112,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,127,127,0,0,0,85,42,85,42,85,0,0,0,65,127,93,93,62,0,0,0,62,99,99,119,62,0,0,0,17,68,17,68,17,0,0,0,2,30,14,15,8,0,0,0,14,23,31,31,14,0,0,0,27,31,31,14,4,0,0,0,28,54,119,54,28,0,0,0,14,14,31,14,10,0,0,0,28,62,127,42,58,0,0,0,62,103,99,103,62,0,0,0,127,93,127,65,127,0,0,0,28,4,4,7,7,0,0,0,62,99,107,99,62,0,0,0,4,14,31,14,4,0,0,0,0,0,85,0,0,0,0,0,62,115,99,115,62,0,0,0,8,28,127,62,34,0,0,0,31,14,4,14,31,0,0,0,62,119,99,99,62,0,0,0,0,5,82,32,0,0,0,0,0,17,42,68,0,0,0,0,62,107,119,107,62,0,0,0,127,0,127,0,127,0,0,0,85,85,85,85,85,0,0,0"))
poke(0x5f2d, 1)
prev_mouse_state = 0
fade_loop = 0
fade_in = false
fade_out = false
fade_time = 0
generate_end = true

function _init()
		death = "none"
		death_reset = true
		end_text = ""
		if init_menu then
				menu_init()	
		else
				game_init()
		end
end

function _update()
		poke(0x5f58, 0x81)
		cursor_update()
		d_pad_control()
		
		fade_render()
		fade_menu()
		
		if update_menu then
				menu_logic()
				menu_update()
		else
				death_check()
				game_update()
		end
		
end

function _draw()
		cls()
		if death == "none" then
				if draw_menu then
						menu_draw()
				else
						game_draw()
				end
				spr(011,cursor_x,cursor_y)
		else
				if death == "dealer" then
						fade_time = 0
						print("winner.", 64-14,14,7)
						ending_text(true)
				end
				if death == "player" then
						fade_time = 0
						print("loser.", 64-18,14,7)
						
							ending_text(false)
				end
		end
end

function ending_text(ending)
		if end_text_bool then
				if generate_end then
						end_text = return_ending(ending)
						generate_end = false
				end
				
				if talk_sound then
						if flr(rnd(2)) == 0 then
								sfx(20)
						else
								sfx(21)
						end
				end
				
				spot+=0.25
				spot%=#end_text+1
				outline(sub(end_text,1,spot),61-(#end_text*2.5)/(count_newlines(end_text)+1),72,2,8)
				if spot > #end_text-1 then
						spot -= 0.25
				end
				if spot >= #end_text-1 then
						print("press ❎ to resart.",64-(24*2),110,5)
						talk_sound = false
				end
		else
				spot = 0
				generate_end = true
		end
end

function count_newlines(str)
    local count_ = 0
    for i = 1, #str do
        if sub(str, i, i) == "\n" then
            count_ += 1
        end
    end
    return count_
end


function death_check()
		if death_reset and (player_health <= 0 or dealer_health <= 0) then
				fade_loop = 0
				death_reset = false
		end
		
		if dealer_health <= 0 then
			--	fade_loop += 1
				if main_turn != 2 then
						if fade_loop > 32 then
								fade_time = 0
								reset_turn()
								death = "dealer"
						end
				else
						if fade_loop > 170 then
								fade_time = 0
								reset_turn()
								death = "dealer"
						end
				end
		end
		if player_health <= 0 then
			--	fade_loop += 1
				if main_turn != 2 then
						if fade_loop > 32 then
								fade_time = 0
								reset_turn()
								death = "player"
						end
				else
						if fade_loop > 170 then
								fade_time = 0
								reset_turn()
								death = "player"
						end
				end
		end
		if btnp(❎) and (player_health <= 0 or dealer_health <= 0) then
				_init()
				fade_time = 0
				fade_in = false
				fade_out = false
				death = "none"
				init_menu = true
				update_menu = true
				draw_menu = true
				_init()
		end
end

function fade_menu()
if startgame then
				fade_loop += 1
				if fade_loop < 32 then
						fade_in = true
						fade_out = false
				elseif fade_loop < 33 then
						init_menu = false
						update_menu = false
						draw_menu = false
						_init()
						fade_loop = 34
				elseif fade_loop < 64 then
						fade_in = false
						fade_out = true
				else
					 startgame = false
						
						fade_loop = 0 
				end
		end
end

function menu_logic()
		if btnp(❎) then
				button_press = 1
		else
				button_press = 0
		end

		current_mouse_state = stat(34) + button_press
		--stat(34) == 1 -> if current_mouse_state == 1 and prev_mouse_state == 0
		if cursor_y > 100 and screen == 0 then
				select_pos = 1
		elseif cursor_y < 100 and screen == 0 then
				select_pos = 0
		end
		
		if screen == 1 then
				check_key_click()
		end
		
		if cursor_y < 50 and screen == 1 then
				select_pos = 1
				if current_mouse_state == 1 and prev_mouse_state == 0 and cursor_x < 64 then
						total_lives	-= 1
				elseif current_mouse_state == 1 and prev_mouse_state == 0 and cursor_x > 64 then
						total_lives += 1
				end
		elseif cursor_y < 112 and screen == 1 then
				select_pos = 0
		elseif cursor_y < 127 and screen == 1 then
				select_pos = 2
		end
		
		if current_mouse_state == 1 and prev_mouse_state == 0 and select_pos == 0 and screen == 0 then
				if input_text == "" then
				  input_text = "player"
				end
	 		startgame = true
	 		music(-1)
	 		sfx(17)
		elseif current_mouse_state == 1 and prev_mouse_state == 0 and select_pos == 1 and screen == 0 then
				screen = 1
				title_screen = false
		elseif current_mouse_state == 1 and prev_mouse_state == 0 and select_pos == 2 and screen == 1 then
				screen = 0
				title_screen = true
		end
		
		prev_mouse_state = current_mouse_state
end


__gfx__
0000000000000000000000000000000000000000000000000000000000000000000000000000000055555555010000000000a000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000555d55d517100000000aaa00000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000005d555d551771000000aaaaa0000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000055d55555177710000aaaaaaa0aaaaaaa0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000055d50000177771000000000000aaaaa08800000011000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000555d00001771100000000000000aaa008800000011000000
000000000000000000000000000000000000000000000000000000000000000000600000000600005d5d001001171000000000000000a0008800000011000000
000000000000000000000000000000000000000000000000606606060066066660660660660060005d5d0000000000000000000000000000aa000000aa000000
00000000000000000000000000dd66666666677666666666666666666666666666666666666d6000000000000000000000000000000000000000000000000000
000000000000000000000000dd446dd66666666666dddddddddd4d4dd4dd4dd4dd4dddddddd66000000500000000000000070000000070000000000000000000
00000000000000000000000dd444d666d66d6666d6ddddddddd4444444444444444dddddddddd000005650000000000000770000000077000000000000000000
0000000000000000000006d444444666666666666600000000044444444444444440000000000000056765000067765007770000000077700000000007770000
000dddddddddddddddddd44444444000000000000000000000000000000000000000000000000000005650000677776577770000000077770000000077777000
00044444444444444444444444440600000000000000000000000000000000000000000000000000000500000067765007770000000077700000000077777000
00064444444444444444444444440000000000000000000000000000000000000000000000000000000000000000000000770000000077000000000077777000
00064444444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000070000000070000000000007770000
00064444444444444400000000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555dd55555d55555d5
000644444444444400000000000000000000000000000000000000000000000000000000000000000000000055dd5d55d5d55d55d55dd5dd555d5d5555dd55dd
0006444444444400000000000000000000000000000000000000000000000000000000000000000000000000dd555d5d55dd55dd55d55555d555dd55dd55dd55
00064444444400000000000000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555
00064444440000000000000000000000000000000000000000000000000000000000000000000000000000000000100010001000010000000000000000000010
00064440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000001000000100000000001
00006000000000000000000000000000000000000000000000000000000000000000000000000000000000000010010001000100001000000100000001000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011001010010100010110011011011011010
00000000000000000000000000000000000000000000000000000000000000000000000000000000455d00001002500550050050505100505000500500500550
0000000000000000000000000000000000000000000000000000000000000000000000000000000055d510015555552555525225555525205545555555555505
000000000000000000000000000000000000000000000000000000000000000000000000000000005d5510050555250022550505555555552555555555225502
0000000000000000000000000000000000000000000000000000000000000000000000000000000055d500005205022250555525525555055555555555550555
00000000000000000000000000000000000000000000000000000000000000000000000000000000555510005554552005225520255555545555555552552552
000000000000000000000000000000000000000000000000000000000000000000000000000000005dd500052052555022025555555555552555555555555520
000000000000000000000000000000000000000000000000000000000000000000000000000000005d5d00005525555555555552555555555555555555550555
000000000000000000000000000000000000000000000000000000000000000000000000000000005d5510000555022002555555555555555055555505525522
00000000000000000000000000000000000000000000000000000000000000000000000000000000555d555555555555555555555510000055d5100552025502
000000000000000000000000000000000000000000000000000000000000000000000000000000005dd55dd55dd55d555dd555d5555000005555100052052025
000000000000000000000000000000000000000000000000000000000000000000000000000000005d55d55d55dd555dd555dd55d51000005dd5000055252520
0000000000000000000000000000000000000000000000000000000000000000000000000000000055555555555555555555555d551000005555100500555200
000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000455d10000055d5000122505255
000000000000000000000000000000000000000000000000000000000000000000000000000000001000100101001001001000d55550000055d5100005252505
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004d55100000555d100050020522
00000000000000000000000000000000000000000000000000000000000000000000000000000000001100501011001010000045d51000005d55000122525250
000000000000000000000000000000000000000000000000000000000000000000000000000000005102001050055000200110d55550000055dd000105250250
00000000000000000000000000000000000000000000000000000000000000000000000000000000552552255555225555000045d51000005555100550255202
00000000000000000000000000000000000000000000000000000000000000000000000000000000555055500455055205200145d51000005555100055505502
000000000000000000000000000000000000000000000000000000000000000000000000000000005252202255055205505010555550000055d5000055555525
0000000000000000000000000000000000000000000000000000000000000000000000000000000055055520225255522500505d555000005555100105225525
000000000000000000000000000000000000000000000000000000000000000000000000000000005555550500225055550200555550000055d5100505555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555545555525505500045d51000005555000025022555
00000000000000000000000000000000000000000000000000000000000000000000000000000000555552555205255550050045d5500000555d100055050250
00000000000000000000000000000000000000000000000000000000000000000000000000000000205252205555555555555555255525555520555502055525
00000000000000000000000000000000000000000000000000000000000000000000000000000000025555522555555555555025555550255055555555225505
00000000000000000000000000000000000000000000000000000000000000000000000000000000025525520552555555555525555555502552255255505255
00000000000000000000000000000000000000000000000000000000000000000000000000000000425055025555555255555555555555555520525550525022
00000000000000000000000000000000000000000000000000000000000000000000000000000000555252552555555055555555555552525520555552552055
00000000000000000000000000000000000000000000000000000000000000000000000000000000520252502502252555205555052505200252055555022520
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555225255052555555555555555052255025525555502
00000000000000000000000000000000000000000000000000000000000000000000000000000000202250055022555555555555555255205502255500250555
00000000000000000000000000000000000000000000000000000000000000000000000000000000205552552550255255555555555505525555555255255255
00000000000000000000000000000000000000000000000000000000000000000000000000000000252555525550552055505555555525555555055255055555
00000000000000000000000000000000000000000000000000000000000000000000000000000000052555525552055525555255555555555502255522552505
00000000000000000000000000000000000000000000000000000000000000000000000000000000505255250552555202555055555555055555555500555525
00000000000000000000000000000000000000000000000000000000000000000000000000000000525055555555552550255552550255525025255552225055
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555555555555555555525555555555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555555552555552552055555555555552555555552525
00000000000000000000000000000000000000000000000000000000000000000000000000000000555552205255555025055255555505255555025552550550
5d5510015555255555552555555555555555555555550555555555555552500500dd4150051000005500005d5550000055550005054555525555555255052555
55dd00100255552555255555525525255555555555550515001001105010000410455115500000002505105d5510000055d50005052055525520555505255552
555d00150250555525551552555555155555555555555005505505501151000510454000510000005050004555500000555d1000520552550525552525250555
55d5100550552205555522550550225552055550555055005005000055001105005550100510000050500045d550000055550000555525052505205025555550
55d510005525055055205502525550555555522520555555550225200522000401550155000000000550005d5550000055dd0015005525502255502255525525
555d10005205202255205552505255505555005555555055055555555505220500550000115000000205005555500000555d1005522002225052552550250555
54dd00150022555555552055525055555555525502555555555055052200500515505550550000002505004dd510000054551000055255025550555025555552
55551000055055052055255052552505250555525505555055555555052200550000000055000000550010555550000055d50005500525050225505255525555
5d5d10002555202550550220555505555555055055550555505505555055520000001005551000005050005555500000455d1000552525225052225555505520
555d00105025552502555055205552505555555550555505525552055002555520000055551000000550004d555000005d551000552055552250555205255525
45d501001025055502502502555055522055250555525522055055525220500550500005550000005500105d5550000055d50005005552050250555555022555
55dd100120055552552525500255550552505552550505502555505505555520025000055510000050050055d550000055dd0002055255225552552555550550
555510000552550025050025250525050525505505255025505555552505555555005055551000005550005555500000455d0100525555505555555552555525
5dd5000102550255250200052055502525052255052052255022052055550255200500555500000050050055555000005dd50000505550205525025005225055
5555110500022555025052255052555555500522525055002205555050255005205500155510000055050055d510000045551050025525252005252550552552
5555100022505552502550520525020520525055005255520555505225505525050000555510000025001055d510000055dd0010250025552525502522550525
55dd0000055502002555250552550555055252055552055205502505055202500250005555100000555000455550000055d50005002250550220502550552505
555d00055004552055505552505525555550552525002505525555225505502250500015551000000500005d5550000045541002055555555505000250255505
555510005250005000205000500005022052502500422015055105505010550055001555555000005505105d551000005d5d0100025025002525225505555252
55dd10000555500520055055055502550555550555550555555555515555515502050005d550000050500055d5100000555d0001500555455025555022555502
55d5000505505502550250520505505255505552250025155515555155555500550000555550000025000055d550000054d51000252555552552002255550555
555d10010220055002005200550020502052502055255055155555555555151120200055d5500000050200555550000055d51000052550250255555505525555
555d00005505205000521055002505505255055520025055515555155555551020500015555000000200105dd5100000455d1005505520255255202255555255
55d5010050051002200550022055055550220255555055515555515551515500550010555d50000055000055d510000054551000225055555550555550250550
55dd000502500250152055005001502505505500225501555555555555515510020500555550000050250045551000005dd51001052252505552525025552555
555d1001055052005500520052505055022520225005551551551511555d511055000055d55000000500005d5510000055551005050502525502055255205555
55d510005550055002211022005055225555502555552500111511111151101050200005d550000025000055d510000045d50005552555505555225550555205
55d51000502005220050500501200550550555502550551510111105511010005505015455500000520500555510000055dd0100505525255555555025525555
555d100150205005555255552505525025520250255550155555155551555500550500155550000002050055d5100000555d1001505555055525055555555525
5555100055505050055555502555055250525055505505555555555555555510500000555550000025000055d51000005d5d0010225522555555255552552555
555d00100500505502505525052505550250552505555555555555555555155055500155555000005050005555100000545d0050155055552555555555555555
555d00050220120555555005520555052555055555055055555551555155115005050055d55000000250005d5550000055dd100ddd6666666666666666666666
55dd0100505105505505555555555555500525055555515555155155555551105500005555500000020000555510000025550555055555055205255250055250
55551000505105000555555205205550552555550550255515555555155155005050005555500000550500555410000005225525525555520525555555225555
55d51000155055020250555255550220255055055552505555515555dd555550550500555550000005050015d510000025555200255252052555055525555225
55550000520050200022500550525055025550555055015555551555d555d510550000555d500000050000555550000055555555555055255052055555005505
5d5d100105500050205555552550055505555025555555011111115515555150505000555d500000502000555510000055250022055525555250255502552002
555d00050020500502205250550202255500555505505500111011111551101020500155d550000050001005d510000002252552552555502505455505552502
55d50000552002200550502202025005555555555550215010550515505555505500005555500000020050145510000055055205525505555225555225255025
55d51000205100052055555550552550555505505505501555555555555555005505005555500000005550505500000020520555500255550550525550525502
5d5d100000205200250250202250022500050005005555555515555555d55550050001555d500000155555555510000052555520222055525552505252505202
55550001250051500525502505555505055055055050550555555555dd55d5502205005555500000005500000010000052052055552055055505555205525555
55dd00000250052002505250550550550550550055005115555555555555555050050055d5500000004440155000000055555552555205200225525555020525
554d001005500500200255502205552500050055050550555551515dd55d555055500055555000001045d1050150000025555502505255225550255525550250
5d4510055025002055255025055505515505505505505555155155515555511010000055dd50000050d541051100000050220525505025555555555555555555
55dd000000210020002550052555055105505500505051151155115555555100555000555550000000d5d0550510000055505550252025002502502205202002
4d55000155002005005055555055505500500550205050011000010110110100505000555d5000000045d5550510000005525025555552250255250525520225
5d551000025051020225525055505551005500500500550000000000000000105005005555500000014540055500000022550225502205520255555052055555
555d10050020000000000000000000510500500505055100011110110110151055000055d5500000000000000000000055025550255255055025055250552055
55d5000155055520201255555555555015005505005155525555555200252555055000555d500000000000000000000055255055550552252555550555555502
45dd0000055550250250550025055055005515155150550255002502552005250500005555500000000000000000000005205255552505205505555525055552
5d5d10050025020155250525055055055555555555550255052500250505500525050055d5500000000000000000000055555250255525052255055555255020
555d00005505250220052005505555055055105055050505505555002505525050050055d5500000000000000000000020555555555055555555525050255025
55dd000050055050055050205505005200505550050550055000220550500550500000555d500000000000000000000055555055555550525055505550202500
55d5000005000050050050500500500055000005005005500500000500500002002000555d500000000000000000000055555555055555555555555552502505
555d1000020050050005000500500500000500505000000000250000050050050000005d55500000000000000000000055502552255555550555052502550054
5d5500000000000000000100000000050000000000015000100001000000010001001015d5500000000000000000000055555055055055555555550525022005
55d50001005101500110010051005001011011000100001005005500501100100050001555500000000000000000000055555255255552505550225525055205
55d511105551550015555555515555555555555555555555555551555555555555515005dd500000000000000000000055025500255555555550550055200004
5d5555555555555555555555555555555555555555555555515555550555555555555545d5500000000000000000000052555555555505555052552255002505
5555555555555555555555555555555555555555555555555555555555555555555555d555500000000000000000000055555555555550000010000001150005
55d555d55d5555d55555d55d55d555555d5555d555d555555d555555d5d5d55dd55d55dd55500000000000000000000055555555555050000500000000000025
55d5d55dd55d55d5dd5d5d55d55d5ddd5d55d5d5555d555d55555dd5d555d5555d5d555dd5500000000000000000000055555555555550555555555550505005
555551555555555555111511111511111111111111111511111111111111015101101110110000000000000000000000d66d6666dddd55555555525522525555
__label__
0000000000000000gkkkkkkkkkkkkkkkkk6li0000000000000000000000000g000000000000000000000000000000077777777777777777g0000000000000000
000000000000000kkkkkkkkkkkkkkkkmlg00000000000000000000000g5m65777mkkktf6mg00000000000000000000000m777777777777776000000000000000
0000000000000gkkkkkkkkkvkkkkkvgggg000000000000000mmmd5mmdm6f7777ffkkk4ff6mmmmmmmd5000000000000000l555777777777777md0000000000000
0000000000000kkkkkkkkkkkkkkkki00000000000000000006t6777767777776ffkkkv77777776776600000000000000000g0777777777777760000000000000
00000000000gkkkkkkkkkkkkkkk0g000000000000000miik6kkk7777m77777777fkkkf6667777m77776666600000000000000l67777777777776000000000000
0000000000ggkkkkkkkkkkkkkkf0000000000000000gtkkkkkkm77777777777777kkf76nmf777mf77777766000000000000000m7777777777777g00000000000
00000000kkkkgkkkkkkkkkkkk00000000000000kkkkkkkkkkkk77777666m500000ggf77f677nfm677777ff7f67m0000000000000007777777777770000000000
0000000gkkkkkkkkkkkkkkkgk00000000000g0gkkkkkkkkkkkk7777766mm5g0000gg7f76nf76fmf77f77f77ff76ghi000000000000667777777777gg00000000
000000kkkkkkkkkkkkkkkg0000000000000gkkkkk4kkkkkkkkkf7777g000000000007f766776n6f76mn66fn666f7770000000000000g77777777777600000000
0000gikkkkkkkkkkkkkkgg0000000000ikkkkkkkkfv4kkkkkkk46f77666mm00666667f6n6f7mmgg0g000g66fnm6f7777650000000000g6677777776665000000
0000gkkkkkkkkkkkkkkg000000000000kkkkkkkkmkkkkkkkkkgmff7f756mm006f66mf76n6f7mm0000000066f6mnf77776500000000000667777777ff7m000000
0000gkkkkkkkkkkkkkg00000000000665kkkkkkkt00000gik4kmf6mmfmnmmg0m6nvmfm77f660006777mm0006ff677777766770000000000666ff6fm66f600000
0000gkkkkkkkkkkkkkg00000000g0gm7fmkkkkkkm000000m6mgk4mm6n66nm0066mn66m77f6600g6677mm0006n66f7777776f7g00000000066n6f6fmnn66gg000
00gkkkkkkkkkkkkkg0000000000ikkmmkkkkkkk000gkgg0006kkkm66n6mm500ff6mmf7777g000777777f6g0mm6ff77777777775000000000g667777f66m77000
0ggkkkkkkkkkkkkkg00000000gggkvkkkkkkkgk0gl5555lg0mikkmnm6fmmm006f66nf6777l00077777fn6g06mmn77777777777dl00000000gmm7777f6n677lg0
0kkkkkkkkkkkkkk0000000000kkkv6kkvmkkk000g77mm775000mvm64mmnnm0066n6677777g0007777766m006nmm7777777777777h0000000005m77ff6f777750
kkkkkkkkkkkkkgg0000000052444f7m67fkkk00kk7fkkf776g0kmmm4km56m006mnf6nf6nfh077777hg00066nf66777777777777777mm0000000gmmf777777777
kkkkkkkkkkkkk000000000gkkkkkkm7776kkkg0kk77kkt777g0kfmmm5mm6m006m6f66f66fl077777hg000m6f66f7777766677776ffmmg0000000mm7677777777
kkkkkkkkkkkg000000000gkkkkkkkk4m7vk4k00kkm76m777m005vfmmnmfmm00mn6ff6nn66g07777766000006nf67777m0007777777776g000000007777777777
kkkkkkukkkkg00000000ggkkkkkkkkkkkkk4200kk4777776fg0m6fmgmmmkk00mmmm766ff6g06m7776mll0g066667776m000777777777f5l0000000m677777777
kkkkv7vkkk000000000gkkkkkkkkkkkkkff2k00kkk777776k00kk6mmmmmmm00mmn67f7777l0007776nm50ggffmn7775500077777ff67766g0000000l77777777
kkkkkvkkkg00000000gkkkkkkggkkkkk476kk00gkk67777tk00kmfmm5554555m67f7777776600055kl00077ffff766000m7777777777777gg0000000057777n6
kkkkk4kkgg00000000kkkkkkkg0kkkkk777kk000gk476m5kg0g46nmmkk5mmkkmnf7777777f600055kl00065f7f7fn600gm7777776777777gg00000000m7777ff
kkkkok4kg0000000ikkkkff4kg00gkkkvkkkkkk000gkkkgg000m6mmm45k5qm5ff6f777777777700000000mkmm776000577777776g0777777600000000567776f
kkkkkkki0000000gkkkkkm7fkgggggf4kkkkkkkgg0giikg00glffmmnmmk5nmmf4kkkm77777777555555lg6fmm76m005m7777776mg07777776ll0000005m777f6
kkkkk7g0000000gkkkkk4m77tkkgg0ikkkkkkk44k00000000k7mmnmmmqmmn6ffkkkkk7777777777777765ff6nn500077777776l0007777f777m00000000777f6
kkkkkm00000000gkkkkku7777mkkg0gggkkkkkk2klggggttgk7f66n66nmm6ff7kk4ok777777777777777m77ff6m0dm7777ff7ggg55777777776m0000000mm7fn
kkkkkk0000000ggkkkkkk7mkkff4ig00gg4mu27774kkkk77kkf776ff66mm6f56kkkkkf77777777ff7777f77776m077777776600077ff777777770000000gg76f
kkkkk00000000kkkkkkkgg4kkkmkg0000gkm77777kkk477mkk47777777fn6f6f4okkof777777776n66mmnff777m07777ff700gm677ff77777777m600000007f7
kkkkk0000000gkkkkokkggkkkv2ig0000glm77777kkk477kkkt77777776n6f5m4k4okf777777776nn6mmmf7777d07777777000m6776f77777777mm000000077f
kkkgg000000lkkkkkkkkg00kkkk000kk760007767kkk476kkkf77777mmff6vmfmkkkkf777776f7n6mmf7f66f77m0007n6l00056fnf77nf777f777700000000mf
kkkg0000000ikkkkkkkum50gggg0gikkk4lg07777kkkk7mkkm777775kkg55lgl5ggggk66777fn766fnf77ff7776d00555g0006ff6677f6fn77nfff55000000m7
k4k00000000kkkkokku7lt000000gkkkkkkm07777kkkkfvkkf7777fkkg000000000g00mmf7777ffn776f77777777000000000777fn77fnf76ff66n6m000000d7
mkg000000gkkkkkkkk4mk47l00gkkkkkkkk677f7fkk4umkkkkff6000000000000000000000000m6ff66n6f77767777m5gm677f77ff7n6m5gg5mnff6m00000000
7lg000000l4kkkkkkkkuk76l00gkkkkkkkkkff5k4kkkkkkkkk776000000000000000000000000m66fff6mf777f7777fmgm677ff77f777m5005mff7nm00000000
7g000000ggkkkkokkkk47777k000gkkokkkkkmm44kkkkokkkg000000000000000000000000000000mm7fn77f7f77777777f77fff66n6000000l6f66665000000
50000000ikkkokkkkkkk777fktg0ggkkkkkkkk4kk444kkkggg000000000giik5mliktmg000000000llmm7777777nf77777777n6n55550000gmmf6nmmf5000000
0000000gkkkkkkkkokkkkmkkkkk000kkkkkkkkkkk44kkkg000000000000gkkk4774467gg000000000g5m7777777f7f77f77776mmg0000000i77f6nmmfm000000
0000005gkkkkkokkkkkokkkkkkkkk04kkkkkkk5444kkgg00000000ikkkkkkkkk77765mm6m66ig00000ggl77777f67fnf7ffffllh0066mg0gl76mn6mnf6m00000
000000ggkkkkkkkkkkkkkkkukkkt6gkkkkkkk4mm4kkk00000000ggkkkkkkkkkk67ffm5vff77ll00000000677n7ff776f766n7000gg7f5g0ggfnmn6mnf6600000
000000kkkokkk0000gkkkokkk4f66fkkkvkk4f77vgg0000000gkkkkkgggg0000000000l5mf7f7750000000067777ff77nf7770m777f6000kk6ff6fn6mmm00000
000000kokkkkk00g0gkkkkkm6m4fmk4m77m4f7ff6gg00000gg0kkkk2kkgg0000000000lmm66fn7500g000007777n77nf7ff77gmf77f600gkkff6666vmmm00000
000000kkkkkg000ikkkkg0000kkm7tm777777ffn5000000gg4mfmkg000000000000000000006f6ff77000000l77777ff677f676n6nmm0kkkmfm000mm5g000000
0000gkkkkkkg0kkgkkgg00l00kk4777777776mml0000005ffvmllg000000000000000000000lgg5ff76m00000lm7n66nff6f77n66fgg0mmlllh00055kg000000
0000gkkkkkkggkkkggg00g500kkk6777777fkgk000000gk6f66000000000000000000000000000lmf77600000057mnm6fn67ffnmn600066g0000gg5lgg000000
0000lkfvkkkg0kkkgg00m6fmkm4km7777776kgg00000ikmmmgg0000000000000000000000000000055f77g00005f6nf666nn666fgg0gkg000ilmllg000000000
00005777gkkg0kkkg00gfff6fmmm77777776m000000gkkfmmg000000000000000gg000000000000055f77gg00056f6fnn6m6nf6ngg00l00ggikkgl0000000000
0000577t4kg0gkkgg0if7fmlg0g777ff77fnm00000ggkmf5000000000000000glm550000000000000g6nf660000077f66nmmmf6mg00000gmf4kkg000000gg000
00005765f645gggg00km564g0lmf66ff77m5l00000gkk4gg000000000g666666f6mf6666mg00000000g57n60000077nf6nvn6mnmg00giikgmmkkgggggg00gg00
0000577mf5kmg00000kk46k00kmmk57ff75lg00000mfk500000000000i7777777m5677766g000000000l7n600000776fnm6nvmn6g000kkkgkmm4kgg00gg00gg0
00g7777m5kmfmk2kk4kg000005vmk4777nm50000ikil00000000006777777777f6mf777777700000000g5ff6m000007f66nmmmmvmmmmmkggkg00gg0gggggg000
00g777776mf77776kmkk0000gm7mmf777fm50000l5kg000000000067777777fffffff77777700000000g56fmmg00007ffnmmm5kkkk54mkgk500ggg0ggggggg00
00gm57777777777777kk0ggkkk6f7777765l0000575g00000000g6m67577fffm6nn66nf6fn666000000006fnmgg00076m4mgggggkggknmm450glgg0000gggg00
00gm67mf777775f777kkgggk7kkf6m777n5l000g5f500000000gl75m7777f6fn666n6fff66nn6gg000000ff6m5l0007n555ggggggkkkmmm45ggkggggggggg000
00g777m5f77fmkffff4kkkkkmm4mmmkmf60000066m5000000007776777ff77f6nn6f776mmmmff6l000000mmfffm0007mkg0ggggkggkk4mqm4554kkkkggggggg0
00h7m54m7fmfkk66kfmkkkkkkfmk4f57f600000fnml00000000m77776n7f6nn6mvm5n6fnfmmn67m5g0000gg77nm000mmn50gggkkkgkk45kkk4qnmmmm454445g0
00g77mmmffmfkk45m7fkkkkkkkkk5f77f6000006mml0000000067777m67n666mf6mkn6ff7mmn67mm0000000776m000mmf50ggkkgkkkkk4kkg5mmm4qmmm4m44l0
00g77mk5mn6fkkvf777kkkkkkkkv777fm5000007v5g000000777776nf6n66n4gklk5mmmm544ffnm50000077776m000057mkkgkkggkggkmmkg4m445nm54m44gg0
00g77fm5mn6fkk7fff74gkkkokkkv77f55000ggf5lg00000076677ff6fn6vnm4455qmmm555mn66mmg00006677nm00005m6kgkkggggggkmm4kkkm55mkkkm4mggg
00h75m7fff6fk4fff6fkgkkk44kkmff7000005lkklg0000005kkk477ff6n66n55qmvmmg00lkmmnmng00000077fml00057fvkkggg00000mm4kggm0064ggkl5ggg
00g7t5mkffm4kkk5fnfkkkkk474kff65g0000m55kgg000000kkkkkmff66n6mnk54mmllgg0ggm4nm6gg0000077mlg000576nkkgg0gigi055m4kgl007f5kggggg0
00g76ff5mfkkkkkkm66nlgkkf7fkv7mkg00007ffm00000000kkkkkkf6nf6vn6kkglk000ggggm46nvgg0000076mkl000576nmkgg0kkmf000mm4l00g76mkggggg0
00g7777766kggkkk4f5k00000tfm5k4k00000777m000000mkkkkkkkffff6fff5lgg5g0000lkmmk54gg0000077n500005m6fmf05mffmmmg054k50660ln4gggg00
00g7777f5vkg0kkkkm4g00000kkk45kkg000067ml000000mkkkkkkkff67f66nklgl5g000glk4mk4mgg00000776m00005mnfm605mffvmmg0m45g06f0lmmkggg00
0gl77fffmmgg0kkum5g00g6g00g7ffkk00000mkkl0000006mkkkkk4mfn6f7nfm5gggg00ggk5kkq55g000000776m0000lmm6mm0676n55k55ggkg0ff0lmm4kgg00
00g775m5gggg0kkf6ml05565g0gk6fmk0g0007kkkgg0000m6mkkkkmmmnffff6mmklg00gll5545m450000000777mg000lmmnmm0m7mmllgkkgggg0660lnm5kkgg0
00g775kmkg000kkf7fi0f677mg0kf6m4gg0007mkkgg0000lmffvvkkkmmf66fnnmm5g0g5mmmmkqmk5g0000007776l0005mmmnn0m7mm000lkgggg0mm0l7n4gklg0
00g6fffmk4kggko47kg06f7mk0g67fmmgg00076kkkg0000ik47mmmmnnmfnf7f6nnff6vnnmm45nkg00000000777mk00057ffn60m7mm00000mm000000005mlkg00
00gff6ffkmki0kok7kg0644mm0g77fmmgg00077kkkl0000gk57mmqmmm6ff6ff6f6mk4mfmmqmmmkg000000007776l00057f6m60m7mm00000m5000000005ngggg0
00g66v4kkkkg0kkkvkt7ggkg0007fm54kl0006f7ff500000067nfffffff6ff7fffmkk5fmmvn45kg00000000777m00005777mm067kkllmg055000000005fk5gg0
00g6n4kkkkkggkkk445fggkg0557fm55550005l7fml000000m6ff6f7nf6nn6ff6ff4k4fnmmnmmgg00000000777m00005777mm05m55gkmg0550gii55l05fk5g00
00g7kkkkkkfg0kkkmff6gg000776nm5kqm0000076ml000000557f6f76nmmmf65nf6fff6fn6fmmg000000000777d00005777mm0005mgg5g0450g54fmm05f55g00
00gvkkkkkkfl0kk4ffmmg00m677mm5kkmm000007fmm500000gg7fn7f6nn6mnm6fmn66nf6fnm4500000000mm77m5000gd77755000gg0gg00mm054kmmm0g5gg000
00gkkkkkkuml0k4fffmm000677fm5kkkmmg000077nm5000000077f7nf6fvmmmnfmnnm67nf6m45000000006676m5000gm777kk0000000000mm05kkgkl0gggg000
00gkkokkkkkg0fmmm6lg0g777ffnmm55qm650000577700000000g677f6ffn5mnff6fff7ffmm0000000000776m00000777mmkkg5mg000067fm0lkkkkgkm4gl000
00gkkkkkkkkg0fkkmfl00g77777mmm5kmmn5000057770000000006f7fff6n44f67f6fn7ffmm0000000000777600000777mmkkg5mg00006ff605f5kgkmmmk5000
00g4kkkkkkkl0mm4fng05500000m7nnmmmm500005f776500000000gg7fmm555f7fnf66nmmg000000000i6ffgg00000777nn54k5455nf6mmmmf6m4mk44mmgg000
00g4kgggkggg0lilm6l0gg0000077m4455k55000glm7ffg000000000lllggkknnmmm5lllg0000000000l7mmg0000mm776mmk5kkkgg54m445555kkkggkk500000
00ggg0ggkg000000mfl0000000g77n55kkl5m00000m7ffgg0000000000000llmmnm5gg0000000000000l7mmg0000667fnmmkkkkkggkk544kkkgkkgggggk00000
0000gigggk6666666m6666666666nm5kggglm00000hl776l0000000000000gggggggg000000000000gmmmgg0000077f6mm445kgggggg5qq5kkgkkgkkggg00000
0000lmkggkf57777nmff777ffff6nm4kgg0lm00000006f7500000000000000000000000000000000ggmmmg00000g7fmk4m445kg000gg44m4kggkkgkgkgg00000
00gkmfkgkkmff6nf6nf6ffmk555mm44qgl0gln6000000g677lg0000000000000000000000000000067lg000000576kkkk4q54ql0ggkk5mm4kgkggkkgggg00000
00ggmv5ggkmvnmmmmn6nn6l5kkk45m4m55ggg665l000005mfmmmm000000000000000000000000mmm77gg0000lm67m4kkk4m54kg0lk445qmgggkkggkkgg000000
000k5mm4k4mmnmmmmm6fmmgkkkkkkqm4mm000fnm5000000m67776000000000000000000000000677760g0000l77754k4mmm45gg0lkm454kgkggkkggggg000000
000g0gmmklk5mm4mmmmm55gggk5gg5mmmm5klmmfmml0000ggmn7766mg0000000000000000dm66766lg00000g57774k4mk44gggg0gg54l4kkkggkggggg0000000
000000mmggk544mmq4mnk50ggk50gkmmq445g4mnmml000000mm77766g000000g0000000g0mm77766g000000gkffmkkk4k5mggg000g45g44kggkggggg00000000
000000mnkkk55qmm444mgl0gkggggkkk44mmmqmfffmm000000055f77f777f6655k55777777766gg00000000kkkkggggk545gggg0gggkklggkgggggg000000000
000000m6kk5kkqmmm545kgggkggggkk55554mmmf7fmmgg0000g5566fff77fnf55k5m7777f66m5gg000000ggkkkkkggkkkkkggg00ggggggggkggggg0000000000
00000000llggg544455kkk5kkkkgkklkllgl4mmnn6ffm60000000000mmmmm7777777776m5g000000000ggkkkkkkkgkkkkgggg00ggggkggkgggg0000000000000
m0000000mmkg00gm5k545kgmm5554q54gggg5qmmmmmmf77l00000000gggggg0gggggggg0000000000g6kkkkkkkkgk4k4mgg000ggggkkggggggg0000000000000
m0000000mmkg000m5k4555gmqkk45m4mgg0gkmmnmmmmf775000000000000000000000000000000000gfkkkkkkkkgkkggkgg00000ggkggkggggg0000000000000
l00000000glg0ggkk5qq44k54k54kgk55kglk44nnnnnn667777000000000000000000000000000mm77f4kkkkkggkkkkkkgggggggggkgkkggggg0000000000000
lg0000000gkg0ggkkk445qk54545kg54k5gk5q4mmv66mnf77f70gg0000000000000000000000ggmm77fvkkkkggkkkkgkggggggggggkkggggggg0000000000000
ggg000000g45gkggkk544mkk5q4llg44kkggkmmn6vmmvn6mmn6777l00000000000000000000m45ffnm54kkkkkggkgkkkkkkggkggkgkkggggggg00000000000gk
ggg000000g5lgkgkkl554554545kkg555kggkmmmnnmmnmmnmmmff75llllllggggggglllllll7fmfvmv544kkkkggkkgkgkggkkgggkkkkgggggg000000000000gk
0ki000000005mgkkk5kk55qq4454kkkl45gkkqmmmmmmmmmmmmmmmnf6777f65555mmmf66f7777fkkkk455kgkkkkkkkgk444k4kgkkgkkkgkgggg0g0000000000kk
0lk6m0000000gm45q44qgg0lkq445544ggkk5444mnnmmqm4mqmmmmmm55mm544nnff7fnmffnmmvkkgkgggggkgkkkggk444kkkk4kkkggkkkkgggg0000000000kkk
0gkn500000000m4445m4gg05544q4554gggk4mq5mnmvmmmmmmmqmm4444q4545nffnf6nmnf6mm4kkgkgggggkkkgkgk444mkgkkm444kggkgkgggg0000000000mkk
iggkl000000006m554qmkl0lkmmm44llkkk55qm4mnmnmm4qmmmvmm45544kggkmm5mmmmmm4mnkkkgkgggggkkkkkgg00ik5kk5kkk5kgkkkggkggg00000000007kg
kggkll0000000mmq5k45k5g5km455klg55kkl555mmmnmm4mmqmvqm444555kkkmm4mq44qm4mmkkggkgggggkgkkkgk00ggkkk54kkkkkggkkggggg00000000gg7mk
gggglm0000000007mg54qm445q4k5lgg44ggg000g54mmq44mm4mmm45q4kkkkl44q44m4m44q4kkkggggkggggkk44m000gkk44q5kkkkgggggkkgg00000000k4fmg
gg000000000000005fm5qvmqm4mlggggklgg00000000mm44444qm4q445ggkmq4mm4m5k4qmmmkkggggggggkkk4mmkgg000g544qmm45gggggggg0000000lmffmkg
g0000000000000005n45nvmmm4mlggg0llgg00000000mm45q45mm4mm44ggkmm4qmm4k5kmnmmkkgggggggg44k4mmkggg00g445qm44mggggkkg00000000lmfnmkg
0000000000000000ggmmmm444qm44l0000g0077mm650kk45kkkmq4kkmqkk544m444k54qmmm4kkg00gggk4kkk5kkgggkg000m44kkg000gkk000000000057mmggg
00000000li000000ggmmmq45mm445kg0gggg06mmmml05544kkk554kk55kk4qq44m5544qmmm4kgg00gggkkkkk4k4gggkggg0555kl00ggggg00000000glmn54kgg
00000000mm00000000544m44q54454ggkkm5000544g0775kkllgg5kkkkgk4mm4mq4kq4m4444ggg00000gm45mq4444kgkkg000kg00gkkkggg0000000l6mmkkkgg
00000000mmml000000il5k544k54445kggm5g00l5m5g7n455gggg45kkkkk54mqm4455l555glgggg0000gm44mmmqmvm445lg00gg05gkkggg0000000g5m45ggggg
g0000000mmf500000000ggmq54554q55ggm450005m5gfnm4qg0004445kklg4mmmm5l00000000ggg0000g5lknvnmmnm44455g0000mkggg000000000kkkkkgggg0
60000000mmm670000000000mm4qqmkg00lnnmk50g4mnf6m4k00774q4q4gg0nnm4kg0000006f6kggg00000lkmmmm4444q44mkl0mf5ggg00000000gggggg000000
mg00000gmmmnf0000000000mm44mmkg00lf6mkl0g4mnffm5kg07f54445gg06mm4lg000000mfvkkggg000054mqmm4qq54544l5gmn4g0000000000gggkg00000gg
05l0005444k55f60000000000mmmqmg00lfnm4m0lmmnmmm44g077q4555glmnmm4gg0776mk4mmkggggg0005k44nmm444454qmmmmmg00000000000gkgggg000gkm
0m4lg0lk45ggln6ml00000000glmvv5m0h5mm450glmnmm44500555llkl056nnm5gg077m4k5l5gkkgkggg0lg44mmqkl55k4q44m55g0000000000gggggg0000ggg
06m5k0gg5kgg06mf5000000000gn6nn6000lm55000m6mn455g000000gg0576fm5gg077m5ggg00kkkkggg0ggmm54mggkkkmm44mg00000000000gggg00g0000gg0
00gmm5ggggg00m4m66l000000000g5ff6m0000g057nmfn4gg00gg000000576fmm4l0000000000kggggg0000ll00000m4444qm0000000000gggggg000g00g0000
00gmm4gggg000mmmvng000000000gm776m0000005f6mnfmgg00gg00000057ffmm4l000000000gkgkggg00005l00000m45q55m0000000000ggggg00g0g0000000
0000lm44k5000m444m67000000000000mmnf6fffffmmnmml05mffm6fm5057fnmmn50006ffffmmmkgkkkl000000006mnmml00000000000ikgggg000gggg000000
0000g5mmm4gggmq44mnfmm0000000000l55mvm6ff7nvmmml0lmfnmnmll057mmmmn50007f66nmvf5k444500000gilmm55lg0000000000ggkggg00ggggggi00000
000000mnmmkggvm5qmv6m5g00000000000g5mmmfff6nmvqg05mffmmmgg05fmmqmm50007nmffmnn4444mmg000gkkk4m0g00000000000gkggggg0ggggggkk00000
000000llfnm5lnvk444m555g00000000000gl5knfnmmnmml0mfffnvngg5mfnvnnmml007mllllgg5mmq45gg00g55ggg000000000000gggggkigggigggkgg00000
0000000076m4kfn55454glmg0000000000000llf66mmnmnl0f77fmn60gm6fnmffm4k0075000000mm4m55ggg0gll00000000000000gigg00iggggkggkkg000000
000000000lfnn66nnmgg000005l000000000000000mvmmffm6nnffmmggff6fnmmvmm0000000000mnm5gg000000000000000000ggggggg00gg00gkkkk00000000
000000000l76nnmfmmkg000g0klg000000000000005mm6fnmvm6fnmngg6fn6f4mnmmggg0g00gggmn5500000000000000000000ggkgggg00gg00g5kkg00000000
00000000000lmmmfmkggg0gg0ggkl000000000000000000l5mmnff6f6ff6vvnmmnnf55n6vn6v6m45gg0000000000000000000gkkggggg00ii000000000000000
00000000000ggmnfm4gglkkgggg4m55m0000000000000000gllllllk54nnmfnmmmvm44mmmlllgggg0000000000000000000gigkkgkgg000gg000000000000000
00000000000006mfm4kgkkkggggmmmmm0000000000000000000000gg55mn6ffmnmmm4qmm4g0000000000000000000000000llgiggggg000gg000000000000000
0000000000000g0g5qmvkkmkkggmnvmmg0g000000000000000000000gg00g0gggggg00gg0000000000000000000000555ig00gggggggglkgg000000000000000
00000000000000005mmn5km4kggvmnmmggg00g00000000000000000000000000000000000000000000000000000g0glgkgg0gggggggggkklg000000000000000
000000000000000000mf7nnm4mmmmn44ggkkk5kkg0000000000000000000000000000000000000000000000000lmkmkgkk4gi0000g00066g0000000000000000

__map__
0000000a2b2c2d2e2f4a4b4c4d00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000003a3b3c3d3e3f5a5b5c5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004e4f6a6b6c6d6e6f8a8b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000005e5f7a7b7c7d7e7f9a9b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000008c8d8e8fcccdcecfaaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000009c9d9e9fdcdddedfbabb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000acadaeafecedeeefcacb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000bcbdbebffcfdfeffdadb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001c00002204022040160401604025040250401904019040220402204016040160402504025040190401904022040220401604016040250402504019040190402204022040160401604025040250401904019040
001c00000004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040
001c000026040260401b0401b04029040290401f0401f04026040260401b0401b04029040290401f0401f04026040260401b0401b04029040290401f0401f04026040260401b0401b04029040290401f0401f040
001c00000304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400504005040
001c00002404024040180401804027040270401b0401b0402404024040180401804027040270401b0401b0402404024040180401804027040270401b0401b0402404024040180401804027040270401b0401b040
001c00000004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000403e7303e730
001c00000000000000000000000026040260402604026040260402604026040260402604026040260402604026040260402604026040260402604026040260402604026040260402604021040220402204022040
001c00002204022040220402204000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000026040260402604026040
001c00002604026040260402604021040220402204022040220402204022040220400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001c0000000400004000040000400004000040000400004000040000003f7303f7303f7303f7303f7303f7303f730000003e7303e7303e7303e7303e7303e7303e730000003d7303d7303d7303d7303b7303b730
001c00000504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040
001c0c002604026040260402604021040220402204022040220402204022040220400140001400014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400
001c00000304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040030400304003040
001c00002204022040160401604026040260401a0401a0402204022040160401604026040260401a0401a0402204022040160401604026040260401a0401a0402204022040160401604026040260402404024040
001c00003e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e7303e730
001c00001f0401f0401f0401f040260402604024040240401f0401f0401f0401f040260402604024040240401f0401f0401f0401f040260402604024040240401f0401f0401f0401f04024040240402604026040
001000001c1531c1431c1331c1231c1131a1030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161000001625300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
021000001661016600166001660016600166001660016600166001660016600166001660016600166001660016600166001660000000000000000000000000000000000000000000000000000000000000000000
000200000343005350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000545003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
040100003a6703c6703c6703c6703c6703c6703c6703a6703a6703a6703a6703a6703a6703c6703c6700007000430004200042000410004100000000000000000000000000000000000000000000000000000000
000500000335005450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 00000140
00 02020340
00 04040540
00 06020340
00 07040540
00 08400340
00 09400a40
00 0b020340
00 0b040540
00 0b020340
00 0b000b40
00 0c020340
00 0c040540
00 0c020340
00 0c040540
00 06020340
00 07040540
00 08400340
00 0c400a40
00 40020340
00 40040540
00 40020340
00 40000b40
00 40020340
00 40040540
00 40020d40
00 40040140
00 400e0f40
02 40100140

