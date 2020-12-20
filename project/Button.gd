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

const HOVER_SCALE = 1.1
const SCALE_SPEED = 3

var player = null
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


func set_player(player_ref):
	player = player_ref


func get_cost_amount():
	pass


func error():
	AudioManager.play_sfx("error_button")


func start_cooldown():
	if not on_cooldown:
		$Button.disabled = true
		on_cooldown = true
		$Cooldown/TextureRect/AnimationPlayer.playback_speed = 1.0/cooldown
		$Cooldown/TextureRect/AnimationPlayer.play("Cooldown")
		yield($Cooldown/TextureRect/AnimationPlayer, "animation_finished")
		$Cooldown/TextureRect/AnimationPlayer.play("Idle")
		$Button.disabled = false
		on_cooldown = false


func _on_Button_pressed():
	if cost.active:
		if player.get_resource_amount(cost.type) > get_cost_amount():
			player.spend(cost.type, get_cost_amount())
		else:
			error()
			return
	AudioManager.play_sfx("click_button")
	if reward_resource.active:
		player.get(reward_resource.type, reward_resource.amount)
	else:
		emit_signal("acted", self)
	
	if cooldown:
		start_cooldown()
		


func _on_Button_mouse_entered():
	if not $Button.disabled:
		hovered = true
		AudioManager.play_sfx("hover_button")


func _on_Button_mouse_exited():
	hovered = false
