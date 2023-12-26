extends Node

static var isGameOver : bool = false :
	get:
		return isGameOver
	set(gameOver):
		isGameOver = gameOver

static var isWin : bool = false :
	get:
		return isWin
	set(win):
		isWin = win

static var highScore : int = 0 :
	get:
		return highScore
	set(score):
		highScore = score
