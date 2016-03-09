data:extend(
{
	{
		type = "recipe",
		name = "tf-coffee-seed",
		ingredients = {{"tf-coffee-beans",1}},
		result = "tf-coffee-seed",
		result_count = 2,
		enabled = "false"
	},

		{
		type = "recipe",
		name = "tf-tea-seed",
		ingredients = {{"tf-tea-leaves",1}},
		result = "tf-tea-seed",
		result_count = 1,
		enabled = "false"
	},

	{
		type = "recipe",
		name = "tf-caffeine1",
		category = "chemistry",
		energy_required = 10,
		ingredients =
		{
			{type = "fluid", name = "tf-liquid-co2", amount = 10},
			{type = "item", name = "tf-coffee-beans", amount = 10}
		},
		results=
		{
			{type="item", name="tf-pure-caffeine", amount=1}
		},
		enabled = "false"
	},

	{
		type = "recipe",
		name = "tf-caffeine2",
		category = "chemistry",
		energy_required = 10,
		ingredients =
		{
			{type = "fluid", name = "tf-liquid-co2", amount = 10},
			{type = "item", name = "tf-tea-leaves", amount = 10}
		},
		results=
		{
			{type = "item", name = "tf-pure-caffeine", amount = 1}
		},
		enabled = "false"
	},


	{
		type = "recipe",
		name = "tf-crafting-booster",
		category = "chemistry",
		energy_required = 20,
		ingredients =
		{
			{type = "item", name = "tf-nutrients", amount = 20},
			{type = "item", name = "tf-pure-caffeine", amount = 5},
			{type = "item", name = "science-pack-2", amount = 1}
		},
		results=
		{
			{type = "item", name = "tf-crafting-speed-booster", amount = 1}
		},
		enabled = "false"
	},
}
)