extends Object

class_name GodokuGenerator

# == Sudoku Generator ==
# Creating a sudoku board generator is quite easy.
# Due to their properties, swapping any two rows or columns
# will always result in a valid sudoku board. Additionally,
# rotating or mirroring the board is a closed operation.
# So, any number of sudoku puzzles could be generated
# by starting with a valid solution then randomly performing
# closed operations as many times as you like.

const reference:Array = [
	[2, 3, 4,	6, 8, 9,	1, 7, 5],
	[7, 6, 5,	2, 4, 1,	8, 9, 3],
	[1, 9, 8,	3, 5, 7,	4, 6, 2],
	
	[6, 1, 9,	7, 2, 3,	5, 4, 8],
	[8, 4, 7,	9, 1, 5,	2, 3, 6],
	[3, 5, 2,	8, 6, 4,	7, 1, 9],
	
	[4, 7, 6,	5, 9, 2,	3, 8, 1],
	[5, 8, 3,	1, 7, 6,	9, 2, 4],
	[9, 2, 1,	4, 3, 8,	6, 5, 7],
]

static func swap_rows(a:int, b:int):
	var a_row:Array = reference[a]
	var b_row:Array = reference[b]
	reference[a] = b_row
	reference[b] = a_row

static func swap_rand_rows():
	swap_rows(randi() % 9, randi() % 9)

static func swap_columns(a:int, b:int):
	for row in reference:
		var a_elem:int = row[a]
		var b_elem:int = row[b]
		row[a] = b_elem
		row[b] = a_elem

static func swap_rand_columns():
	swap_columns(randi() % 9, randi() % 9)

static func randomatize():
	for t in range(100):
		swap_rand_rows()
		swap_rand_columns()
