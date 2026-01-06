extends Control

var satisfaction := 20.0
var satisfaction_max := 100.0

class UI_Signal:
	var source: Control
	var hovered: bool
	var pressed: bool
	var just_pressed: bool

@onready var ui_element_table := {
	"Person A": [%Control_Person_A, UI_Signal.new()],
	"Person B": [%Control_Person_B, UI_Signal.new()],
	"Person C": [%Control_Person_C, UI_Signal.new()],
	"Softea": [%Control_Softea, UI_Signal.new()],
	"Person D": [%Control_Person_D, UI_Signal.new()],
	"Main_Text": [%Main_Text, UI_Signal.new()],
	"Settings": [%Control_Settings, UI_Signal.new()],
	"Quick Save": [%Control_Quick_Save, UI_Signal.new()],
	"Saves": [%Control_Saves, UI_Signal.new()],
	"Undo": [%Control_Undo, UI_Signal.new()],
	"Fast Forward": [%Control_Fast_Forward, UI_Signal.new()],
	"Satisfaction": [%Bar_Rect_Satisfaction, UI_Signal.new()]
}

func _ready() -> void:
	for pair: Array in ui_element_table.values():
		pair[0].connect("mouse_entered", 
			func() -> void: pair[1].hovered = true)
		pair[0].connect("mouse_exited",
			func() -> void: pair[1].hovered = false)
		pair[0].connect("gui_input",
			func(ev: InputEvent) -> void:
				# @Robustness (Jan 4) should use input map events and such instead of querying mouse
				if ev is InputEventMouseButton:
					if ev.button_index == MOUSE_BUTTON_LEFT:
						pair[1].pressed = true and ev.pressed
						pair[1].just_pressed = true and ev.pressed)
	pass

func get_signal_from_string(ui_str: String) -> UI_Signal:
	assert(ui_str in ui_element_table.keys())
	var ui_element: Control = ui_element_table[ui_str][0]
	var ui_signal: UI_Signal = ui_element_table[ui_str][1]
	var result := UI_Signal.new()
	result.source = ui_element
	result.hovered = ui_signal.hovered
	result.pressed = ui_signal.pressed
	result.just_pressed = ui_signal.just_pressed
	return result

func _process(_delta: float) -> void:
	var Signal_Person_A := get_signal_from_string("Person A")
	var Signal_Person_B := get_signal_from_string("Person B")
	var Signal_Person_C := get_signal_from_string("Person C")
	var Signal_Softea := get_signal_from_string("Softea")
	var Signal_Person_D := get_signal_from_string("Person D")
	
	var Signal_Settings := get_signal_from_string("Settings")
	var Signal_Quick_Save := get_signal_from_string("Quick Save")
	var Signal_Saves := get_signal_from_string("Saves")
	var Signal_Undo := get_signal_from_string("Undo")
	var Signal_Fast_Forward := get_signal_from_string("Fast Forward")

	if 0.3 >= satisfaction_max - satisfaction:
		satisfaction = 0
	satisfaction += 0.3
	var size_max_pixels: int = %Bar_Rect_Satisfaction.get_parent().size.x
	%Bar_Rect_Satisfaction.size.x = clamp((satisfaction / satisfaction_max) * size_max_pixels, 0, size_max_pixels - 7) # @Hack (Jan 4) -7 is a hack. my math is wrong somewhere.
	
	for the_signal: UI_Signal in [Signal_Person_A, Signal_Person_B, Signal_Person_C, Signal_Softea, Signal_Person_D, \
								  Signal_Settings, Signal_Quick_Save, Signal_Saves, Signal_Undo, Signal_Fast_Forward]:
		if the_signal.hovered:
			the_signal.source.find_child("base_color").modulate = Color.BLACK
		else:
			the_signal.source.find_child("base_color").modulate = Color.WHITE
		
		if the_signal.just_pressed:
			%Main_Text.append_text(the_signal.source.name + "\n")
	
	for pair: Array in ui_element_table.values():
		pair[1].just_pressed = false
