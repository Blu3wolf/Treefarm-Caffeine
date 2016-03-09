data:extend(
{
	{
		type = "technology",
		name = "tf-caffeine",
		icon = "__Treefarm-Caffeine-Addon__/graphics/icons/crafting-speed-booster.png",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tf-coffee-seed"
			},
			{
				type = "unlock-recipe",
				recipe = "tf-tea-seed"
			},
			{
				type = "unlock-recipe",
				recipe = "tf-caffeine1"
			},
			{
				type = "unlock-recipe",
				recipe = "tf-caffeine2"
			},
			{
				type = "unlock-recipe",
				recipe = "tf-crafting-booster"
			}
		},
		prerequisites = {
			"tf-advanced-treefarming"
		},
		unit = {
			count = 50,
			ingredients = {
				{"science-pack-1", 2},
				{"science-pack-2", 2},
				{"science-pack-3", 1}
			},
			time = 30
		}
	}
}
)