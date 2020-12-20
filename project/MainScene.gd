extends Node2D

const PALETTES = [
	[Color.white, Color.black],
	[Color.black, Color.white],
	[Color.red, Color.black],
	[Color("#b8c2b9"), Color("#382b26")], #Paperback2 - lospec
	[Color("#3e232c"), Color("#edf6d6")], #Pixel ink - lospec
	[Color("#222323"), Color("#f0f6f0")], #1bit monitor - lospec
	[Color("#0020a5"), Color("#ff89ff")], #Gender Binary - lospec
	[Color("#2e3037"), Color("#ebe5ce")], #Obra Dinn IBM 8503 - lospec
	[Color("#222a3d"), Color("#edf2e2")], #note-2C - lospec
	[Color("#002f40"), Color("#ffd500")], #Gato Roboto Urine - lospec
	[Color("#280e0b"), Color("#ffecc9")], #Gato Roboto Coffee Stain - lospec
	[Color("#10368f"), Color("#ff8e42")], #Gato Roboto Port - lospec
	[Color("#413652"), Color("#6493ff")], #The Night - lospec
]

const EPS = .02
const COLOR_SPEED = 2.5

var player_data
var cur_palette = 1


func _input(event):
	if event.is_action_pressed("ui_right"):
		cur_palette = (cur_palette + 1)%PALETTES.size()
	elif event.is_action_pressed("ui_left"):
		cur_palette = (cur_palette - 1)%PALETTES.size()


func _ready():
	player_data = load("res://player_data.gd").new()
	player_data.init()
	
	for button in $Buttons.get_children():
		button.set_player(player_data)
		button.connect("acted", self, "_on_button_pressed")


func _process(dt):
	var bg_color = $ColorShader.material.get_shader_param("bg_color")
	var fg_color = $ColorShader.material.get_shader_param("fg_color")
	var cur_bg = PALETTES[cur_palette][0]
	var cur_fg = PALETTES[cur_palette][1]
	for i in 4:
		if abs(bg_color[i] - cur_bg[i]) > EPS:
			bg_color[i] += (cur_bg[i] - bg_color[i])*COLOR_SPEED*dt
		else:
			bg_color[i] = cur_bg[i]
		
		if abs(fg_color[i] - cur_fg[i]) > EPS:
			fg_color[i] += (cur_fg[i] - fg_color[i])*COLOR_SPEED*dt
		else:
			fg_color[i] = cur_fg[i]
		$ColorShader.material.set_shader_param("bg_color", bg_color)
		$ColorShader.material.set_shader_param("fg_color", fg_color)

func _on_button_pressed(button):
	pass
