extends Control

@onready var switch_fullscreen_window_button: Button = $ColorRect/VBoxContainer/SwitchFullscreenWindowButton
@onready var game_state = get_node("/root/GameState")
@onready var high_score_label: Label = $ColorRect/VBoxContainer/HighScoreLabel

func _ready() -> void:
	if game_state.highScore > 0:
		high_score_label.show()
		high_score_label.text = "Current Highscore: " + str(game_state.highScore)

func _on_play_button_pressed() -> void:
	game_state.isGameOver = false
	get_tree().change_scene_to_file("res://level.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_switch_fullscreen_window_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		switch_fullscreen_window_button.text = "Enter Window Mode"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		switch_fullscreen_window_button.text = "Enter Fullscreen"
