extends CanvasLayer

onready var shader_rect = $ShaderRect

const BG = 0
const FG = 1

export(Array, Array, Color) var palettes = [
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
export var transition_duration := .5

var curr_palette := 1
var curr_bg := Color.black
var curr_fg := Color.white
var transition_timer : float


func _ready():
	set_process(false)


func _input(event):
	if event.is_action_pressed("ui_right"):
		change_to((curr_palette + 1) % palettes.size())
	elif event.is_action_pressed("ui_left"):
		change_to((curr_palette - 1) % palettes.size())


func _process(delta):
	var bg_color = palettes[curr_palette][BG]
	var fg_color = palettes[curr_palette][FG]
	
	if transition_timer < transition_duration:
		var weight = transition_timer / transition_duration
		bg_color = lerp(curr_bg, bg_color, weight)
		fg_color = lerp(curr_fg, fg_color, weight)
		transition_timer += delta
	else:
		set_process(false)
	
	shader_rect.material.set_shader_param("bg_color", bg_color)
	shader_rect.material.set_shader_param("fg_color", fg_color)


func change_to(palette: int):
	curr_bg = shader_rect.material.get_shader_param("bg_color")
	curr_fg = shader_rect.material.get_shader_param("fg_color")
	curr_palette = palette
	transition_timer = 0
	set_process(true)
