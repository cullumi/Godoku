extends Object

class_name GodokuCollapse

const boxCount = 9*9

static func solve(source_board:Array, tries=1000) -> bool:
	var board:Array = source_board.duplicate(true)
	var non_entropy = generate_entropy(board)
	var rips:int
	for coord in non_entropy:
		rips = ripple(board, coord)
		if rips < 0:
			return false # Contradictory Board
		elif rips == boxCount - non_entropy.size():
			return true
	return find_solution(board)

static func find_solution(board:Array, tries=1000):
	for i in range(tries):
		var solution = solve_attempt(board)
		if solution: return true
	return false # Timed Out, Too Many Attempts

static func entropies(board) -> Dictionary:
	var entropies:Dictionary = {}
	for y in range(9):
		for x in range(9):
			if board[y][x] is Array:
				var entropy = board[y][x].size()
				if not entropies.has(entropy):
					entropies[entropy] = []
				entropies[entropy].append(Vector2(x, y))
	return entropies

static func solve_attempt(source_board:Array):
	var board:Array = source_board.duplicate(true)
	var entropies:Dictionary = entropies(board)
	while (not entropies.empty()):
		for i in range(1,10):
			if entropies.has(i):
				var coord = entropies[i].front()
				var elem = board[coord.y][coord.x]
				var idx = randi() % elem.size()
				board[coord.y][coord.x] = elem[idx]
				var rip:int = ripple(board, coord)
				if rip < 0: return false # Rippled Contradiction
				elif rip == 0:
					entropies[i].erase(coord)
					if entropies[i].empty():
						entropies.erase(i)
				else: entropies = entropies(board)
	return true # Solved Board

static func generate_entropy(board:Array) -> Array:
	var non_entropy:Array = []
	for y in range(9):
		for x in range(9):
			if not board[y][x] is int or board[y][x] == 0:
				board[y][x] = range(1,10)
			else:
				non_entropy.append(Vector2(x, y))
	return non_entropy

static func ripple(board:Array, coord:Vector2) -> int:
	var n_rips:int = ripple_neighborhood(board, coord)
	if n_rips < 0: return -1
	var r_rips:int = ripple_row(board, coord)
	if r_rips < 0: return -1
	var c_rips:int = ripple_column(board, coord)
	if c_rips < 0: return -1
	return n_rips + r_rips + c_rips

static func ripple_compare(board:Array, y:int, x:int, coord:Vector2) -> int:
	var elem = board[y][x]
	var val = board[coord.y][coord.x]
	var rips:int = 0
	if elem is Array:
		if elem.has(val):
			elem.erase(val)
		if elem.empty():
			return -1 # Contradiction
		elif elem.size() == 1:
			board[y][x] = elem.front()
			var rip:int = ripple(board, Vector2(x, y))
			if rip < 0: return -1 # Rippled Contradiction
			else: rips += rip + 1
	return rips

static func ripple_neighborhood(board:Array, coord:Vector2):
	var n_hood:Vector2 = (coord/3).floor()*3
	var rips:int = 0
	for y in range(n_hood.y, n_hood.y+3):
		for x in range(n_hood.x, n_hood.x+3):
			var rip:int = ripple_compare(board, y, x, coord)
			if rip < 0: return -1 # Contradictory
			else: rips += rip
	return rips

static func ripple_row(board:Array, coord:Vector2):
	var y:int = coord.y
	var rips:int = 0
	for x in range(9):
		var rip:int = ripple_compare(board, y, x, coord)
		if rip < 0: return -1 # Contradictory
		else: rips += rip
	return true

static func ripple_column(board:Array, coord:Vector2):
	var x:int = coord.x
	var rips:int = 0
	for y in range(9):
		var rip:int = ripple_compare(board, y, x, coord)
		if rip < 0: return -1 # Contradictory
		else: rips += rip
	return rips
