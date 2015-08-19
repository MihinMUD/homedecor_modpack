local S = homedecor.gettext

local default_can_dig = function(pos,player)
	local meta = minetest.get_meta(pos)
	return meta:get_inventory():is_empty("main")
end

local default_inventory_size = 32
local background = default.gui_bg .. default.gui_bg_img .. default.gui_slots
local default_inventory_formspecs = {
	["4"]="size[8,6]".. background ..
	"list[context;main;2,0;4,1;]"..
	"list[current_player;main;0,2;8,4;]",

	["6"]="size[8,6]".. background ..
	"list[context;main;1,0;6,1;]"..
	"list[current_player;main;0,2;8,4;]",

	["8"]="size[8,6]".. background ..
	"list[context;main;0,0;8,1;]"..
	"list[current_player;main;0,2;8,4;]",

	["12"]="size[8,7]".. background ..
	"list[context;main;1,0;6,2;]"..
	"list[current_player;main;0,3;8,4;]",

	["16"]="size[8,7]".. background ..
	"list[context;main;0,0;8,2;]"..
	"list[current_player;main;0,3;8,4;]",

	["24"]="size[8,8]".. background ..
	"list[context;main;0,0;8,3;]"..
	"list[current_player;main;0,4;8,4;]",

	["32"]="size[8,9]".. background ..
	"list[context;main;0,0.3;8,4;]"..
	"list[current_player;main;0,4.85;8,1;]"..
	"list[current_player;main;0,6.08;8,3;8]"..
	default.get_hotbar_bg(0,4.85),

	["50"]="size[10,10]".. background ..
	"list[context;main;0,0;10,5;]"..
	"list[current_player;main;1,6;8,4;]",
}

local function get_formspec_by_size(size)
	--TODO heuristic to use the "next best size"
	local formspec = default_inventory_formspecs[tostring(size)]
	return formspec or default_inventory_formspecs
end

----
-- handle inventory setting
-- inventory = {
--	size = 16
--	formspec = …
-- }
--
function homedecor.handle_inventory(name, def)
	local inventory = def.inventory
	if not inventory then return end
	def.inventory = nil

	local infotext = def.infotext

	def.on_construct = def.on_construct or function(pos)
		local meta = minetest.get_meta(pos)
		if infotext then
			meta:set_string("infotext", infotext)
		end
		local size = inventory.size or default_inventory_size
		meta:get_inventory():set_size("main", size)
		meta:set_string("formspec", inventory.formspec or get_formspec_by_size(size))
	end

	def.can_dig = def.can_dig or default_can_dig
	def.on_metadata_inventory_move = def.on_metadata_inventory_move or function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", S("%s moves stuff in %s at %s"):format(
			player:get_player_name(), name, minetest.pos_to_string(pos)
		))
	end
	def.on_metadata_inventory_put = def.on_metadata_inventory_put or function(pos, listname, index, stack, player)
		minetest.log("action", S("%s moves stuff to %s at %s"):format(
			player:get_player_name(), name, minetest.pos_to_string(pos)
		))
	end
	def.on_metadata_inventory_take = def.on_metadata_inventory_take or function(pos, listname, index, stack, player)
		minetest.log("action", S("%s takes stuff from %s at %s"):format(
			player:get_player_name(), name, minetest.pos_to_string(pos)
		))
	end
end
