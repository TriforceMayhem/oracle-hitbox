--Author Trianull

--Objects
local origin = 0x1000
local oy = 0x000B
local ox = 0x000D
local oh = 0x0026
local ow = 0x0027
local ofsy = 0
local ofsx = 0
local scrolling = 0x0D01
userdata.set("addr", 0)

local function objects()
	scrolling = mainmemory.read_u8(0x0D01)
	for i = 0,64 do
		local active = mainmemory.read_u8(origin)
		if active > 0 then
			if scrolling == 0 then
				ofsy = mainmemory.read_u8(0x0492) - 240 - mainmemory.read_u8(0x0D08)
				if ofsy < 0 then
					ofsy = ofsy + 256
				end
				ofsx = mainmemory.read_u8(0x0493) - mainmemory.read_u8(0x0D09)
				if ofsx < 0 then
					ofsx = ofsx + 256
				end
			else
				ofsy = 0
				ofsx = 0
			end
			x = mainmemory.read_u8(origin + ox)
			y = mainmemory.read_u8(origin + oy)
			w = mainmemory.read_u8(origin + ow)
			h = mainmemory.read_u8(origin + oh)
			gui.drawBox(x - w - ofsx,y - h + 16 - ofsy,x + w - 1 - ofsx,y + h + 15 - ofsy,0xFF2AF07E,0x602AF07E)
			if userdata.get("addr") == 1 or userdata.get("addr") == 2 then
				gui.drawString(x - w - ofsx, y - h - ofsy, string.format("%x", origin), 0xFFFFFFFF, 0xFF000000)
			end
		end
		origin = origin + 0x40
	end
	origin = 0x1000
end

while true do
	emu.frameadvance()
	objects()
	if input.getmouse()["Middle"] == true then
		if userdata.get("addr") == 2 then
			userdata.set("addr", 3)
		elseif userdata.get("addr") == 0 then
			userdata.set("addr", 1)
		end
	elseif userdata.get("addr") == 1 or userdata.get("addr") == 3 then
		userdata.set("addr", userdata.get("addr") + 1)
		if userdata.get("addr") > 3 then
			userdata.set("addr", 0)
		end
	end
end
