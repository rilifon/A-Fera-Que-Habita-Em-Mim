extends Node

signal update_resources

var resources = {
	"money":{
		"name": "Grana",
		"amount": 0,
		"suffix": "doletas",
		"showing": true
	},
	"line_length":{
		"name": "Tamanho da Linha",
		"amount": 3,
		"suffix": "metros",
		"showing": true
	},
}

func init():
	var first = true
	resources["bait"] = {}
	for bait in BaitManager.get_all_baits():
		resources[bait.id] = {"name": bait.bait_name, "amount": 0, "showing": false, "suffix": "unidades",}
		if first:
			first = false
			resources[bait.id].showing = true
	
	resources["loot"] = {}
	for loot in LootManager.get_all_loots():
		resources[loot.id] = {"name": loot.loot_name, "amount": 0, "showing": false, "image": loot.image}	

func update_resources():
	emit_signal("update_resources")

func get_resource_name(name):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	return resources[name].name

func get_resource_amount(name):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	return resources[name].amount

func spend(name, amount):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	resources[name].amount = max(resources[name].amount - amount, 0)
	update_resources()

func gain(name, amount):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	resources[name].amount = resources[name].amount + amount
	if name == "money":
		AudioManager.play_sfx("getting_money")
	update_resources()
