extends Control

@onready var play_button: Button = $ColorRect/Menu/PlayButton
@onready var controls: VBoxContainer = $ColorRect/Controls
@onready var controls_back_button: Button = $ColorRect/Controls/Back

@onready var switch_fullscreen_window_button: Button = $ColorRect/Menu/SwitchFullscreenWindowButton
@onready var game_state = get_node("/root/GameState")
@onready var high_score_label: Label = $ColorRect/Menu/HighScoreLabel
@onready var menu: VBoxContainer = $ColorRect/Menu

@onready var story_begin: VBoxContainer = $ColorRect/StoryBegin
@onready var story_begin_next_button: Button = $ColorRect/StoryBegin/StoryBeginNextButton

@onready var story_end: VBoxContainer = $ColorRect/StoryEnd
@onready var story_end_next_button: Button = $ColorRect/StoryEnd/StoryEndNextButton

@onready var story_fail: VBoxContainer = $ColorRect/StoryFail
@onready var story_fail_next_button: Button = $ColorRect/StoryFail/StoryFailNextButton


func _ready() -> void:	
	if game_state.isGameOver: 
		menu.visible = false
		if game_state.isWin:
			story_end.visible = true
			story_end_next_button.grab_focus()
		else:
			story_fail.visible = true
			story_fail_next_button.grab_focus()
	else:
		menu.visible = true
		play_button.grab_focus()
		story_fail.visible = false
	
	if game_state.highScore > 0:
		high_score_label.show()
		high_score_label.text = "Current Highscore: " + str(game_state.highScore)


func _on_play_button_pressed() -> void:
	menu.visible = false
	story_begin.visible = true
	story_begin_next_button.grab_focus()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_switch_fullscreen_window_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		switch_fullscreen_window_button.text = "Enter Window Mode"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		switch_fullscreen_window_button.text = "Enter Fullscreen"


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_esc"):
		get_tree().quit()


func _on_story_begin_next_button_pressed() -> void:
	game_state.isGameOver = false
	game_state.isWin = false
	get_tree().change_scene_to_file("res://level.tscn")


func _on_story_fail_next_button_pressed() -> void:
	game_state.isGameOver = false
	menu.visible = true
	story_fail.visible = false
	play_button.grab_focus()

func _on_story_end_next_button_pressed() -> void:
	game_state.isGameOver = false
	menu.visible = true
	story_end.visible = false
	play_button.grab_focus()


func _on_back_pressed() -> void:
	play_button.grab_focus()
	menu.visible = true
	controls.visible = false


func _on_controls_pressed() -> void:
	controls_back_button.grab_focus()
	menu.visible = false
	controls.visible = true
