extends Node

var string_size = 3
var baits = []
var resources = {
	"money":{
		"name": "minhoca",
		"amount": 0,
	}
}

func init():
	for bait in BaitManager.get_all_baits():
		baits.append({"id": bait.id, "amount": 0, "showing": false})
	
	baits[0].showing = true


func get_resource_amount(name):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	return resources[name].amount

func spend(name, amount):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	resources[name].amount = max(resources[name].amount - amount, 0)
