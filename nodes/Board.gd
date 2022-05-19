
extends GridContainer

class_name Board

export (Color) var predefined_color:Color = Color.darkgray
export (Color) var filled_color:Color = Color.royalblue
export (DynamicFont) var font:DynamicFont

enum MODE {VALUE, NOTE}
var mode:int = MODE.VALUE
var initial:Array = []
var solution:Array = []
var board:Array = []
var history:Array = []
var number:int = 1 setget set_number

func _init():
	columns = 17
	board = []
	for y in range(17):
		if (y % 2 == 0):
			board.append([])
		for x in range(17):
			if (x % 2 == 0 and y % 2 == 0):
				board[y/2].append(add_new_box())
			elif (x % 2 == 1 and y % 2 == 0):
				add_child(VSeparator.new())
			elif (y % 2 == 1):
				add_child(HSeparator.new())
	connect_board()
	generate()

func add_new_box() -> Box:
	var box:Box = Box.new(font)
	box.size_flags_horizontal = SIZE_EXPAND_FILL
	box.size_flags_vertical = SIZE_EXPAND_FILL
	box.predefined_color = predefined_color
	box.filled_color = filled_color
	add_child(box)
	return box

func connect_board():
	for y in range(9):
		for x in range(9):
			var box = board[y][x]
			box.connect("selected", self, "_on_box_selected", [y, x])

func set_number(val:int):
	number = val

func push_history(new_num:int, new_mode:int, old_content, old_mode:int, box):
	var hist:Dictionary = {
		"new_num":new_num,
		"new_mode":new_mode,
		"old_content":old_content,
		"old_mode":old_mode,
		"box":box,
	}
	history.push_front(hist)

func _on_box_selected(y, x):
	var box = board[y][x]
	if (box.value >= 0):
		if mode == MODE.VALUE or number == 0:
			push_history(number, MODE.VALUE, box.content, box.mode, box)
			box.value = number
		elif mode == MODE.NOTE:
			push_history(number, MODE.NOTE, box.content, box.mode, box)	
			box.note = number


func generate():
	Generator.randomatize()
	initial = Generator.reference.duplicate(true)
	solution = Generator.reference.duplicate(true)
	reset()

func reset():
	for y in range(9):
		for x in range(9):
			board[y][x].initial = initial[y][x]
	history.clear()

func undo():
	if not history.empty():
		var hist:Dictionary = history.pop_front()
		var box = hist.box
		match hist.old_mode:
			MODE.VALUE: box.value = hist.old_content
			MODE.NOTE: box.notes = hist.old_content

func validate():
	for y in range(9):
		for x in range(9):
			board[y][x].validate(solution[y][x])
