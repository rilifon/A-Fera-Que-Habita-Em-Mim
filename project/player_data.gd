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
	"bait":{}
}

func init():
	var first = true
	for bait in BaitManager.get_all_baits():
		resources[bait.id] = {"name": bait.bait_name, "amount": 2, "showing": false, "suffix": "unidades",}
		if first:
			first = false
			resources[bait.id].showing = true

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
	update_resources()
