tool
extends Control

export var cooldown := 0.0
export var text : String
export var id : String
export var level_unlocked := 0
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
export var fake_cost = ""

signal acted
signal no_bait_selected
signal finished_cooldown

const HOVER_SCALE = 1.1
const SCALE_SPEED = 3

var player = null
var main = null
var hovered = false
var on_cooldown := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = text


func _process(dt):
	if hovered and not $Button.disabled:
		$Button.rect_scale.x = min($Button.rect_scale.x + SCALE_SPEED*dt, HOVER_SCALE)
		$Button.rect_scale.y = min($Button.rect_scale.y + SCALE_SPEED*dt, HOVER_SCALE)
	else:
		$Button.rect_scale.x = max($Button.rect_scale.x - SCALE_SPEED*dt, 1.0)
		$Button.rect_scale.y = max($Button.rect_scale.y - SCALE_SPEED*dt, 1.0)


func setup(player_ref, main_ref):
	player = player_ref
	main = main_ref
	update_cost_text()
	


func get_cost_amount():
	return cost.base_cost + pow((cost.times_used * cost.incremental_cost), cost.exponential_progression)


func update_cost_text():
	if fake_cost != "":
		$Cost.text = "custo: %s" % [fake_cost]
		rect_min_size.y = $Cost.rect_position.y + $Cost.rect_size.y
	elif cost.active:
		var type_name
		if cost.type != "bait":
			type_name = player.get_resource_name(cost.type)
		else:
			type_name = "bait"
		$Cost.text = "custo: %d %s" % [get_cost_amount(), type_name]
		rect_min_size.y = $Cost.rect_position.y + $Cost.rect_size.y
	else:
		$Cost.text = ""
		rect_min_size.y = $Button.rect_position.y + $Button.rect_size.y


func error():
	AudioManager.play_sfx("error_button")


func start_cooldown():
	$Button.disabled = true
	on_cooldown = true
	$Cooldown/TextureRect/AnimationPlayer.playback_speed = 1.0/cooldown
	$Cooldown/TextureRect/AnimationPlayer.play("Cooldown")
	yield($Cooldown/TextureRect/AnimationPlayer, "animation_finished")
	$Cooldown/TextureRect/AnimationPlayer.play("Idle")
	$Button.disabled = false
	on_cooldown = false
	emit_signal("finished_cooldown")


func _on_Button_pressed():
	if cost.active:
		if id != "fishing":
			if player.get_resource_amount(cost.type) >= get_cost_amount():
				player.spend(cost.type, get_cost_amount())
			else:
				error()
				return
		else:
			var bait = main.get_selected_bait()
			if not bait:
				emit_signal("no_bait_selected")
				return
			else:
				if player.get_resource_amount(bait) >= get_cost_amount():
					player.spend(bait, get_cost_amount())
				else:
					error()
					return
	AudioManager.play_sfx("click_button")
	cost.times_used += 1
	update_cost_text()
	if cooldown and not on_cooldown:
		start_cooldown()
		yield(self, "finished_cooldown")
	
	if reward_resource.active:
		player.gain(reward_resource.type, reward_resource.amount)
		if cost.active:
			AudioManager.play_sfx("buying")
	else:
		emit_signal("acted", self)
		


func _on_Button_mouse_entered():
	if not $Button.disabled:
		hovered = true
		AudioManager.play_sfx("hover_button")


func _on_Button_mouse_exited():
	hovered = false
