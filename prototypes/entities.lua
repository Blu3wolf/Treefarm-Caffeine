data:extend(
{
	{
		type = "container",
		name = "tf-crafting-speed-booster",
		icon = "__Treefarm-Caffeine__/graphics/icons/crafting-speed-booster.png",
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 1, result = "tf-crafting-speed-booster"},
		max_health = 100,
		corpse = "small-remnants",
		resistances ={{type = "fire",percent = 80}},
		collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		fast_replaceable_group = "container",
		inventory_size = 1,
		picture =
		{
			filename = "__Treefarm-Caffeine__/graphics/icons/empty.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			shift = {0.0, 0.0}
		}
	},





	{
		type = "tree",
		name = "tf-coffee-seed",
		icon = "__Treefarm-Caffeine__/graphics/icons/coffee-seed.png",
		order="b-b-h",
		flags = {"placeable-neutral", "breaths-air"},
		emissions_per_tick = -0.0001,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.1,
			result = "tf-coffee-seed"
		},
		max_health = 10,
		collision_box = {{-0.01, -0.01}, {0.01, 0.01}},
		selection_box = {{-0.1, -0.1}, {0.1, 0.1}},
		drawing_box = {{0.0, 0.0}, {1.0, 1.0}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/coffee-seed.png",
				priority = "extra-high",
				width = 32,
				height = 32,
				shift = {0.0, 0.0}
			}
		}
	},

	{
		type = "tree",
		name = "tf-small-coffee-plant",
		icon = "__Treefarm-Caffeine__/graphics/icons/coffee-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0002,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "tf-coffee-seed"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/small-coffee-plant.png",
				priority = "extra-high",
				width = 25,
				height = 27,
				shift = {0.0, 0.0}
			}
		} 
	},

	{
		type = "tree",
		name = "tf-medium-coffee-plant",
		icon = "__Treefarm-Caffeine__/graphics/icons/coffee-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0002,
		minable =
		{
			count = 2,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "raw-wood"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/medium-coffee-plant.png",
				priority = "extra-high",
				width = 40,
				height = 42,
				shift = {0.0, 0.0}
			}
		} 
	},

	{
		type = "tree",
		name = "tf-mature-coffee-plant",
		icon = "__Treefarm-Caffeine__/graphics/icons/coffee-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0002,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "tf-coffee-beans"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/mature-coffee-plant.png",
				priority = "extra-high",
				width = 40,
				height = 42,
				shift = {0.0, 0.0}
			}
		} 
	},













	{
		type = "tree",
		name = "tf-tea-seed",
		icon = "__Treefarm-Caffeine__/graphics/icons/tea-seed.png",
		order="b-b-h",
		flags = {"placeable-neutral", "breaths-air"},
		emissions_per_tick = -0.0001,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.1,
			result = "tf-tea-seed"
		},
		max_health = 10,
		collision_box = {{-0.01, -0.01}, {0.01, 0.01}},
		selection_box = {{-0.1, -0.1}, {0.1, 0.1}},
		drawing_box = {{0.0, 0.0}, {1.0, 1.0}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/tea-seed.png",
				priority = "extra-high",
				width = 32,
				height = 32,
				shift = {0.0, 0.0}
			}
		}
	},


	{
		type = "tree",
		name = "tf-small-tea-bush",
		icon = "__Treefarm-Caffeine__/graphics/icons/tea-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0002,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "tf-tea-seed"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/small-tea-bush.png",
				priority = "extra-high",
				width = 34,
				height = 23,
				shift = {0.0, 0.0}
			}
		} 
	},

	{
		type = "tree",
		name = "tf-medium-tea-bush",
		icon = "__Treefarm-Caffeine__/graphics/icons/tea-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0003,
		minable =
		{
			count = 2,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "raw-wood"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/medium-tea-bush.png",
				priority = "extra-high",
				width = 27,
				height = 27,
				shift = {0.0, 0.0}
			}
		} 
	},

	{
		type = "tree",
		name = "tf-mature-tea-bush",
		icon = "__Treefarm-Caffeine__/graphics/icons/tea-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0003,
		minable =
		{
			count = 2,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "tf-tea-leaves"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__Treefarm-Caffeine__/graphics/entities/mature-tea-bush.png",
				priority = "extra-high",
				width = 40,
				height = 40,
				shift = {0.0, 0.0}
			}
		} 
	}
}
)