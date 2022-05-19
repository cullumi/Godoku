extends Object

class_name Solver

func simplify(board:Array) -> Array:
	var y:int = randi() % 9
	var x:int = randi() % 9
	var val:int = board[y][x]
	board[y][x] = 0
	if solvable(board):
		return simplify(board)
	else:
		board[y][x] = val
		return board

func solvable(board:Array) -> bool:
	
	return true

func vals_check(vals:Array, val:int):
	if vals.has(val):
		return false
	else:
		vals.append(val)
		return true

func valid_row(board:Array, y:int):
	var vals = []
	for x in range(9):
		if not vals_check(vals, board[y][x]):
			return false
	return true

func valid_column(board:Array, x:int):
	var vals = []
	for y in range(9):
		if not vals_check(vals, board[y][x]):
			return false
	return true

func valid_box(board:Array, y:int, x:int):
	var vals = []
	var bys = y / 3
	var bxs = x / 3
	for by in range(3):
		for bx in range(3):
			if vals_check(vals, board[by+bys][bx+bys]):
				return false
	return true
