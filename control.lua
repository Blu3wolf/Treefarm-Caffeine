
local BUFF_SECONDS_PER_CAFFEINE = 60
local DEBUFF_SECONDS_PER_CAFFEINE = 90

local STATE_NOTRUNNING = "nothing"
local STATE_BUFFED = "buff"
local STATE_DEBUFFED = "debuff"

local BUFFMODIFIER = 1
local DEBUFFMODIFIER = -0.5

function reset_player_caffeine_data(player_index)
	global.tfCaffeine.players[player_index] = {
		  state = STATE_NOTRUNNING
		, consumed_amount = 0
		, remaining_seconds = 0
	}
end

function upgrade_to_v7()

	if (global.blocking ~= nil) then
		global.blocking.ent.destroy()
	end
	
	global.tfCaffeine.init_done = global.initDone
	global.initDone = nil
	
	-- the second counter is already set to zero by the initialize_global_data() function

	-- get rid of the GUI for all players. if we need to show it it will be added back for the first player
	for _, player in pairs(game.players) do
		if player.gui.left.caffeineRoot ~= nil then
			player.gui.left.caffeineRoot.destroy()
		end
	end
	
	if global.caffeineTimer.state ~= STATE_NOTRUNNING then
		-- convert the state to be state for the first player, since tf-caffeine was written before multiplayer
		global.tfCaffeine.players[1] = {
			  state = global.caffeineTimer.state
			, consumed_amount = global.caffeineTimer.amount or 1
		}
		
		-- convert the crafting speed
		-- v6 and earlier just set the crafting speed, however doing that will ignore any applied
		-- modifiers from other mods, so we just want to increase or decrease the crafting speed as appropriate
		game.players[1].character_crafting_speed_modifier = global.caffeineTimer.initialModifierValue
		if (global.tfCaffeine.players[1].state == STATE_BUFFED) then
			global.tfCaffeine.players[1].remaining_seconds = global.caffeineTimer.buffValue
			game.players[1].character_crafting_speed_modifier = game.players[1].character_crafting_speed_modifier + BUFFMODIFIER
		else
			global.tfCaffeine.players[1].remaining_seconds = global.caffeineTimer.debuffValue
			game.players[1].character_crafting_speed_modifier = game.players[1].character_crafting_speed_modifier + DEBUFFMODIFIER
		end
		
		update_gui(1)
	end
	
	global.caffeineTimer = nil
	
end



function initialize_global_data()
	global.tfCaffeine = global.tfCaffeine or {}
	global.tfCaffeine.players = {}
	global.tfCaffeine.init_done = false
	global.tfCaffeine.second_counter = 0
	
	for	idx = 1, #game.players do
		-- its safe to reset all the players as long as we don't do it on every configuration change
		reset_player_caffeine_data(idx)
	end
end

script.on_init(function()
	initialize_global_data()
	-- this is used to "transfer" the needed information to the treefarm mod
	if (remote.interfaces.treefarm_interface) and (remote.interfaces.treefarm_interface.addSeed) then
	
		-- !!!do not modify!!!
		local coffeeplant = {
			["name"] = "coffeeplant",
			["states"] = {
				"tf-coffee-seed",
				"tf-small-coffee-plant",
				"tf-medium-coffee-plant",
				"tf-mature-coffee-plant"
			},
			["efficiency"] = {
				["grass"] = 1.00,
				["grass-medium"] = 1.00,
				["grass-dry"] = 0.90,
				["dirt"] = 0.80,
				["dirt-dark"] = 0.80,
				["hills"] = 1.00,
				["sand"] = 0.50,
				["sand-dark"] = 0.50,

				["other"] = 0.1
			},
			["basicGrowingTime"] = 12500 * 0.9, -- approx 1/2 day +/- 10%
			["randomGrowingTime"] = 12500 / 5,
			["fertilizerBoost"] = 0.50 -- grow 50% faster w/ fertilizxer applied
		}

		local teaplant = {
			["name"] = "teaplant",
			["states"] = {
				"tf-tea-seed",
				"tf-small-tea-bush",
				"tf-medium-tea-bush",
				"tf-mature-tea-bush"
			},
			["efficiency"] = {
				["grass"] = 0.50,
				["grass-medium"] = 0.60,
				["grass-dry"] = 1.00,
				["dirt"] = 1.00,
				["dirt-dark"] = 1.00,
				["hills"] = 1.00,
				["sand"] = 0.50,
				["sand-dark"] = 0.50,

				["other"] = 0.1
			},
			["basicGrowingTime"] = 25000 * 0.9, -- approx 1 day +/- 10%
			["randomGrowingTime"] = 25000 / 5, 
			["fertilizerBoost"] = 0.50  -- grow 50% faster w/ fertilizer applied
		}
		
		-- if something went wrong an error message is returned
		-- if everything is ok the function returns nil
		local message = remote.call("treefarm_interface", "addSeed", coffeeplant)
		if message ~= nil then
			for _, player in pairs(game.players) do
				player.print(errorMsg)
			end
			return
		end
		
		message = remote.call("treefarm_interface", "addSeed", teaplant)
		if message ~= nil then
			for _, player in pairs(game.players) do
				player.print(errorMsg)
			end
			return
		end
		global.tfCaffeine.init_done = true
	end
end)

script.on_configuration_changed(function (data)

	-- NOTE: initialize has already been called by on_init

	if data.mod_changes == nil or data.mod_changes["Treefarm-Caffeine"] == nil or data.mod_changes["Treefarm-Caffeine"].old_version == nil then
		return
	end
	
	local previousVersion = tonumber(string.sub(data.mod_changes["Treefarm-Caffeine"].old_version, 3, 5))

	-- NOTE: these migrations are meant to be cumulative. so to upgrade from v5 to v7, 
	-- the v5 update must run, then the v6 update, then the v7 update
	if (previousVersion < 7.0) then
		initialize_global_data() -- initialization for v6 and earlier was different, so we have to run it again
		upgrade_to_v7()
	end
	
end)



script.on_event(defines.events.on_built_entity, function(event)
	if global.tfCaffeine.init_done == false or event.created_entity.name ~= "tf-crafting-speed-booster" then
		return
	end
	
	event.created_entity.destroy()
	
	local player = game.players[event.player_index]
	local tf_player = global.tfCaffeine.players[event.player_index]
	
	if tf_player.state == STATE_NOTRUNNING then
		tf_player.state = STATE_BUFFED
		tf_player.consumed_amount = tf_player.consumed_amount + 1
		tf_player.remaining_seconds = BUFF_SECONDS_PER_CAFFEINE
		
		player.character_crafting_speed_modifier = player.character_crafting_speed_modifier + BUFFMODIFIER
	
	elseif tf_player.state == STATE_BUFFED then
		-- eat another pill
		tf_player.consumed_amount = tf_player.consumed_amount + 1
		
		-- each additional pill increases the buff time by fewer seconds, down to a 1 second minumum
		tf_player.remaining_seconds = tf_player.remaining_seconds + math.max(1, math.floor(BUFF_SECONDS_PER_CAFFEINE / tf_player.consumed_amount))
	elseif tf_player.state == STATE_DEBUFFED then
	
		-- consuming a pill while in the debuff state will reduce the remaining debuff time by 10%
		tf_player.remaining_seconds = math.floor(0.9 * tf_player.remaining_seconds)
	
	end
	
	update_gui(event.player_index)
end)


script.on_event(defines.events.on_tick, function(event)

	global.tfCaffeine.second_counter = global.tfCaffeine.second_counter + 1

	if (not global.tfCaffeine.init_done) or (global.tfCaffeine.second_counter ~= 60) then
		return
	end
	
	global.tfCaffeine.second_counter = 0 -- reset the second timer
	
	for idx = 1, #game.players do
		local tf_player = global.tfCaffeine.players[idx]
		
		if tf_player.state == STATE_BUFFED then
			tf_player.remaining_seconds = tf_player.remaining_seconds - 1
			
			if tf_player.remaining_seconds <= 0 then
				tf_player.remaining_seconds = tf_player.consumed_amount * DEBUFF_SECONDS_PER_CAFFEINE
				tf_player.state = STATE_DEBUFFED
				
				-- undo the buff modifier and add in the debuff modifier
				game.players[idx].character_crafting_speed_modifier = game.players[idx].character_crafting_speed_modifier - BUFFMODIFIER + DEBUFFMODIFIER
				
			end
			
			update_gui(idx)
		elseif tf_player.state == STATE_DEBUFFED then
			tf_player.remaining_seconds = tf_player.remaining_seconds - 1

			if tf_player.remaining_seconds <= 0 then
				tf_player.remaining_seconds = 0
				tf_player.consumed_amount = 0
				tf_player.state = STATE_NOTRUNNING
				
				-- undo the debuff modifier
				game.players[idx].character_crafting_speed_modifier = game.players[idx].character_crafting_speed_modifier - DEBUFFMODIFIER
			end
			
			update_gui(idx)
		end
		
	end
end)


script.on_event(defines.events.on_research_finished, function(event)
	if event.research.name ~= "tf-caffeine" then
		return
	end

	-- give every player on the force that researched the technology
	-- a single stack each of coffe and tea seeds so that they can start farming them
	local coffee_stack_size = game.item_prototypes["tf-coffee-seed"].stack_size
	local tea_stack_size = game.item_prototypes["tf-tea-seed"].stack_size
	
	for _, player in pairs(event.research.force.players) do
		if player.can_insert{name="tf-coffee-seed", count = coffee_stack_size} then
			player.insert{name="tf-coffee-seed", count = coffee_stack_size}
		else
			player.surface.create_entity({
				name = "item-on-ground", 
				position = player.position, 
				stack = {name="tf-coffee-seed", count = coffee_stack_size}
			})
		end
		
		if player.can_insert{name = "tf-tea-seed", count = tea_stack_size} then
			player.insert{name = "tf-tea-seed", count = tea_stack_size}
		else
			player.surface.create_entity({
				name = "item-on-ground", 
				position = player.position, 
				stack = {name="tf-tea-seed", count = tea_stack_size}
			})
		end
		
		player.print("Received a gift: Coffee and Tea seeds")
	end

end)

script.on_event(defines.events.on_player_created, function(event)
	
	reset_player_caffeine_data(event.player_index)

end)

script.on_event(defines.events.on_player_died, function(event)

	-- just stop all the timers and buffs; player died after all
	reset_player_caffeine_data(event.player_index)
	update_gui(event.player_index)
end)

script.on_event(defines.events.on_player_left_game, function(event)

	-- just stop all the timers and buffs; it's the simplest thing to do
	reset_player_caffeine_data(event.player_index)
	update_gui(event.player_index)
end)

function update_gui(player_index)

	local game_player = game.players[player_index]
	local tf_player = global.tfCaffeine.players[player_index]

	if game_player == nil or tf_player == nil then
		return
	end

	if tf_player.remaining_seconds == 0 then
		if game_player.gui.left.tfCaffeine ~= nil then game_player.gui.left.tfCaffeine.destroy() end
		return
	end
	
	-- create the gui if it's not already there
	if game_player.gui.left.tfCaffeine == nil then
		game_player.gui.left.add({type = "frame", name = "tfCaffeine", caption = {"caffeineGUICaption"}, direction = "vertical"})
		game_player.gui.left.tfCaffeine.add({type = "label", name = "caffeineTimerLabel", caption = ""})
	end

	if tf_player.state == STATE_NOTRUNNING then return end
	
	if tf_player.remaining_seconds > 600  then
		game_player.gui.left.tfCaffeine.caffeineTimerLabel.caption = string.format(
			"Crafting modified by %d%% for %d min"
			, math.floor(game_player.character_crafting_speed_modifier * 100)
			, math.floor(tf_player.remaining_seconds / 60)
		)
	else
		game_player.gui.left.tfCaffeine.caffeineTimerLabel.caption = string.format(
			"Crafting modified by %d%% for %d s"
			, math.floor(game_player.character_crafting_speed_modifier * 100)
			, tf_player.remaining_seconds
		)
	end
end
