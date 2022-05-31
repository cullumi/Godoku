extends Object

class_name GodokuReducer

static func reduce(source_board:Array, tries=25):
	var board = source_board.duplicate(true)
	var result
	var y:int
	var x:int
	var val = 0
	var filled = count_filled(board)
	while (GodokuCollapse.one_solution(board, tries) and filled > 17):
		val = 0
		while (val == 0):
			y = randi() % 9
			x = randi() % 9
			val = board[y][x]
		board[y][x] = 0
		filled -= 1
	if val != 0:
		board[y][x] = val
	Matrixes.print_mat(board)
	return board

static func count_filled(board:Array):
	var count:int = 0
	for y in range(9):
		for x in range(9):
			if board[y][x] != 0:
				count += 1
	return count
