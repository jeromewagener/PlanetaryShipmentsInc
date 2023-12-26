extends Node


static var is_game_over : bool = false :
	get:
		return is_game_over
	set(go):
		is_game_over = go


static var is_win : bool = false :
	get:
		return is_win
	set(win):
		is_win = win


static var high_score : int = 0 :
	get:
		return high_score
	set(hs):
		high_score = hs


static var current_points : int = 0 :
	get:
		return current_points
	set(cp):
		current_points = cp
