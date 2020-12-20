extends Node

const LOOTS = [
	preload("res://loot/loot1.tres"),
	preload("res://loot/loot2.tres"),
]

func get_all_loots():
	return LOOTS

func get_loot_data(name):
	for loot in LOOTS:
		if loot.id == name:
			return loot
