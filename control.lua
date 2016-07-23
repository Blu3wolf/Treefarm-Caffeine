
local BUFFTIME = 60
local DEBUFFTIME = 90

local BUFFMODIFIER = 1
local DEBUFFMODIFIER = -0.5
-- the (arbitrary) name of the seed, only used internally
local mySeedTypeName1 = "coffeeplant"
local mySeedTypeName2 = "teaplant"

-- the entity-names of the growing stages
-- here the plant will grow from "alien-seed" over "small-alien-plant" over "medium-alien-plant" to "mature-alien-plant"
local myGrowingStates1 =
	{
		"tf-coffee-seed",
		"tf-small-coffee-plant",
		"tf-medium-coffee-plant",
		"tf-mature-coffee-plant"
	}
local myGrowingStates2 =
	{
		"tf-tea-seed",
		"tf-small-tea-bush",
		"tf-medium-tea-bush",
		"tf-mature-tea-bush"
	}

-- the mining-result of the last growing state
local myOutput1 = {"tf-coffee-beans", 1}
local myOutput2 = {"tf-tea-leaves", 2}

-- defines the growing speed-modifier for different tiles
-- 1.00 means normal speed; 0.50 means half speed; 2.00 means double speed 
local myTileEfficiency1 =
	{
		["grass"] = 1.00,
		["grass-medium"] = 1.00,
		["grass-dry"] = 0.90,
		["dirt"] = 0.80,
		["dirt-dark"] = 0.80,
		["hills"] = 1.00,
		["sand"] = 0.50,
		["sand-dark"] = 0.50,

		["other"] = 0.1
	}

local myTileEfficiency2 =
	{
		["grass"] = 0.50,
		["grass-medium"] = 0.60,
		["grass-dry"] = 1.00,
		["dirt"] = 1.00,
		["dirt-dark"] = 1.00,
		["hills"] = 1.00,
		["sand"] = 0.50,
		["sand-dark"] = 0.50,

		["other"] = 0.1
	}


-- defines the minimum amount of ticks that are needed to evolve into the next growing-state
local myBasicGrowingTime1 = 12500 * 0.9 -- approx 1/2 day +/- 10%
local myBasicGrowingTime2 = 25000 * 0.9 -- approx 1 day +/- 10%

-- defines the highest value that might be added to the basic growing time
-- in general the growing time is determined by basicGrowingTime + randomValue
-- randomValue is between 0 and randomGrowingTime
local myRandomGrowingTime1 = 12500 / 5
local myRandomGrowingTime2 = 25000 / 5

-- defines how big the impact of fertilizer is
-- the total growing efficiency is TileEfficiency + fertilizerBoost ( if fertilizer was applied)
-- e.g. total efficiency of an alient-plant on a grass-tile with fertilizer = 2, which means double growing speed 
local myFertilizerBoost1 = 0.50
local myFertilizerBoost2 = 0.50


-- !!!do not modify!!!
local allInOne1 =
	{
		["name"] = mySeedTypeName1,
		["states"] = myGrowingStates1,
		["output"] = myOutput1,
		["efficiency"] = myTileEfficiency1,
		["basicGrowingTime"] = myBasicGrowingTime1,
		["randomGrowingTime"] = myRandomGrowingTime1,
		["fertilizerBoost"] = myFertilizerBoost1
	}

local allInOne2 =
	{
		["name"] = mySeedTypeName2,
		["states"] = myGrowingStates2,
		["output"] = myOutput2,
		["efficiency"] = myTileEfficiency2,
		["basicGrowingTime"] = myBasicGrowingTime2,
		["randomGrowingTime"] = myRandomGrowingTime2,
		["fertilizerBoost"] = myFertilizerBoost2
	}



script.on_init(function()
	initTables()
	-- this is used to "transfer" the needed information to the treefarm mod
	if (remote.interfaces.treefarm_interface) and (remote.interfaces.treefarm_interface.addSeed) then
		-- if something went wrong an error message is returned
		-- if everything is ok the function returns nil
		local errorMsg1 = remote.call("treefarm_interface", "addSeed", allInOne1)
		if errorMsg2 ~= nil then
			for _, player in pairs(game.players) do
				player.print(errorMsg)
			end
			return
		end
		local errorMsg2 = remote.call("treefarm_interface", "addSeed", allInOne2)
		if errorMsg2 ~= nil then
			for _, player in pairs(game.players) do
				player.print(errorMsg)
			end
			return
		end
		global.initDone = true
	end
end)





script.on_event(defines.events.on_built_entity, function(event)
	if global.initDone == true then
		if event.created_entity.name == "tf-crafting-speed-booster" then
			if global.blocking == nil then
				global.blocking = {ent = event.created_entity, counter = 0}
			else
				global.blocking.ent.destroy()
				global.blocking = {ent = event.created_entity, counter = 0}
			end

			local player = game.players[event.player_index]
			
			if global.caffeineTimer.state == "nothing" then
				global.caffeineTimer.running = true
				global.caffeineTimer.state = "buff"
				global.caffeineTimer.initialModifierValue = player.character_crafting_speed_modifier
				
				player.character_crafting_speed_modifier = BUFFMODIFIER
				
				global.caffeineTimer.buffValue = global.caffeineTimer.buffValue + BUFFTIME
				global.caffeineTimer.debuffValue = global.caffeineTimer.debuffValue + DEBUFFTIME
				global.caffeineTimer.amount = 1
			elseif global.caffeineTimer.state == "buff" then
				if (global.caffeineTimer.amount) and (global.caffeineTimer.amount >= 0) then
					global.caffeineTimer.amount = global.caffeineTimer.amount + 1
				else
					global.caffeineTimer.amount = 1
				end
				global.caffeineTimer.buffValue = global.caffeineTimer.buffValue + math.floor(BUFFTIME / global.caffeineTimer.amount)
				global.caffeineTimer.debuffValue = global.caffeineTimer.debuffValue + math.floor(DEBUFFTIME / global.caffeineTimer.amount)
			elseif global.caffeineTimer.state == "debuff" then
				--global.caffeineTimer.state = "buff"
				--player.character_crafting_speed_modifier = BUFFMODIFIER
				--global.caffeineTimer.buffValue = global.caffeineTimer.buffValue + BUFFTIME
				global.caffeineTimer.debuffValue = global.caffeineTimer.debuffValue - math.floor(0.1 * global.caffeineTimer.debuffValue)
			end
			showGUI()
		end
	end
end)




script.on_event(defines.events.on_tick, function(event)

	if (global.blocking ~= nil) then
		global.blocking.counter = global.blocking.counter + 1
		if global.blocking.counter >= 60 then
			global.blocking.ent.destroy()
			global.blocking = nil
		end
	end

	if (game.tick % 60 == 0) and (global.caffeineTimer.running == true) and (global.initDone == true) then
		for _, player in pairs(game.players) do
			if global.caffeineTimer.state == "buff" then
				global.caffeineTimer.buffValue = global.caffeineTimer.buffValue - 1
				if global.caffeineTimer.buffValue <= 0 then
					global.caffeineTimer.buffValue = 0
					global.caffeineTimer.state = "debuff"
					player.character_crafting_speed_modifier = DEBUFFMODIFIER
				end
			elseif global.caffeineTimer.state == "debuff" then
				global.caffeineTimer.debuffValue = global.caffeineTimer.debuffValue - 1
				if global.caffeineTimer.debuffValue <= 0 then
					global.caffeineTimer.debuffValue = 0
					global.caffeineTimer.state = "nothing"
					global.caffeineTimer.running = false
					player.character_crafting_speed_modifier = global.caffeineTimer.initialModifierValue

					if player.gui.left.caffeineRoot ~= nil then
						player.gui.left.caffeineRoot.destroy()
					end
					
				end
			end
		end
		
		updateGUI()
	end
end)


script.on_event(defines.events.on_research_finished, function(event)
	if event.research == "tf-caffeine" then
		for _,player in pairs(game.players) do
			if player.can_insert{name="tf-coffee-seed", count = 10} then
				player.insert{name="tf-coffee-seed", count = 10}
			else
				player.surface.create_entity({
					name = "item-on-ground", 
					position = player.position, 
					stack = {name="tf-coffee-seed", count = 10}
				})
			end
			if player.can_insert{name = "tf-tea-seed", count = 10} then
				player.insert{name = "tf-tea-seed", count = 10}
			else
				player.surface.create_entity({
					name = "item-on-ground", 
					position = player.position, 
					stack = {name="tf-tea-seed", count = 10}
				})
			end
		end
	end
end)



function showGUI()
	for _, player in pairs(game.players) do
		if player.gui.left.caffeineRoot == nil then
			--create GUI
			local text = "Increased for"
			local timerValue = global.caffeineTimer.buffValue
			local timerCaption = string.format("%s %d s", text, timerValue)
			player.gui.left.add{type = "frame", name = "caffeineRoot", caption = {"caffeineGUICaption"}, direction = "vertical"}
			player.gui.left.caffeineRoot.add{type = "label", name = "caffeineTimerLabel", caption = timerCaption}
		end
	end
end


function updateGUI()
	local text
	local timerValue
	if global.caffeineTimer.state == "buff" then
		text = "Increased for"
		timerValue = global.caffeineTimer.buffValue
	elseif global.caffeineTimer.state == "debuff" then
		text = "Decreased for"
		timerValue = global.caffeineTimer.debuffValue
	end

	for _, player in pairs(game.players) do
		if player.gui.left.caffeineRoot ~= nil then
			local arguments = "%s %d s"
			if timerValue > 600 then
				timerValue = math.floor(timerValue / 60)
				arguments = "%s %d min"
			end
			player.gui.left.caffeineRoot.caffeineTimerLabel.caption = string.format(arguments, text, timerValue)
		end
	end
end


function initTables()
	global.caffeineTimer = {
		  running = false
		, state = "nothing"
		, buffValue = 0
		, debuffValue = 0
		, initialModifierValue = 0 -- reset to the player's current crafting speed modifier the first time they consume caffeine
	}
	
	global.initDone = false
end