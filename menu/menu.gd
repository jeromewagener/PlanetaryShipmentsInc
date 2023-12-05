extends Control

@onready var switch_fullscreen_window_button: Button = $ColorRect/VBoxContainer/SwitchFullscreenWindowButton

func _ready() -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_switch_fullscreen_window_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		switch_fullscreen_window_button.text = "Enter Window Mode"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		switch_fullscreen_window_button.text = "Enter Fullscreen"
