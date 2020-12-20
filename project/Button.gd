tool

extends Control

export var cooldown = 0
export var text : String
export var id : String
export var reward_resource = {
	"active":  false,
	"type" : "",
	"amount":  0
}
export var cost = {
	"active":  false,
	"type" : "",
	"base_cost" : 100,
	"times_used" : 0,
	"incremental_cost" : 20,
	"exponential_progression": 1.2
}

signal acted

var player = null
var on_cooldown := false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = text


func set_player(player_ref):
	player = player_ref


func get_cost_amount():
	pass


func error():
	pass


func start_cooldown():
	if not on_cooldown:
		$Button.disabled = true
		on_cooldown = true
		yield(get_tree().create_timer(cooldown), "timeout")
		$Button.disabled = false
		on_cooldown = false
		#$CooldownTween.interpolate_property()


func _on_Button_pressed():
	if cost.active:
		if player.get_resource_amount(cost.type) > get_cost_amount():
			player.spend(cost.type, get_cost_amount())
		else:
			error()
			return
	if reward_resource.active:
		player.get(reward_resource.type, reward_resource.amount)
	else:
		emit_signal("acted", self)
	
	if cooldown:
		start_cooldown()
		
