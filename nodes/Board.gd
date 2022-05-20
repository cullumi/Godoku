
extends GridContainer

class_name Board

export (Color) var predefined_color:Color = Color.darkgray
export (Color) var filled_color:Color = Color.royalblue
export (Font) var filled_font:Font
export (Font) var noted_font:Font

enum MODE {VALUE, NOTE}
var mode:int = MODE.VALUE
var initial:Array = []
var solution:Array = []
var board:Array = []
var history:Array = []
var number:int = 1 setget set_number

var cur_coord = null
signal box_unselected
signal box_selected

func _ready():
	columns = 17
	board = []
	for y in range(17):
		if (y % 2 == 0):
			board.append([])
		for x in range(17):
			if (x % 2 == 0 and y % 2 == 0):
				board[y/2].append(add_new_box())
			elif (x % 2 == 1 and y % 2 == 0):
				if (x == 5 or x == 11):
					var hbox = HBoxContainer.new()
					hbox.add_child(VSeparator.new())
					hbox.add_child(VSeparator.new())
					add_child(hbox)
				else:
					add_child(Control.new())
#					add_child(VSeparator.new())
			elif (y % 2 == 1):
				if (y == 5 or y == 11):
					var vbox = VBoxContainer.new()
					vbox.add_child(HSeparator.new())
					vbox.add_child(HSeparator.new())
					add_child(vbox)
				else:
					add_child(Control.new())
#					add_child(HSeparator.new())
	connect_board()
	generate()

func add_new_box() -> Box:
	var box:Box = Box.new(filled_font, noted_font)
	box.size_flags_horizontal = SIZE_EXPAND_FILL
	box.size_flags_vertical = SIZE_EXPAND_FILL
	box.predefined_color = predefined_color
	box.filled_color = filled_color
	box.toggle_mode = true
	box.clear_highlight()
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

func set_box():
	var box = board[cur_coord.y][cur_coord.x]
	if (box.value >= 0):
		if mode == MODE.VALUE or number == 0:
			push_history(number, MODE.VALUE, box.content, box.mode, box)
			box.value = number
		elif mode == MODE.NOTE:
			push_history(number, MODE.NOTE, box.content, box.mode, box)	
			box.note = number

func set_box_toggle_modes(val:bool):
	for y in range(9):
		for x in range(9):
			board[y][x].toggle_mode = val

func _on_box_selected(y, x):
	var box = board[y][x]
	if cur_coord != null:
		if y == cur_coord.y and x == cur_coord.x:
			cur_coord = null
			emit_signal("box_unselected")
		else:
			board[cur_coord.y][cur_coord.x].pressed = false
			cur_coord = Vector2(x, y)
			emit_signal("box_selected", box.empty())
	else:
		cur_coord = Vector2(x, y)
		emit_signal("box_selected", box.empty())

func generate():
	GodokuGenerator.randomatize()
	initial = GodokuGenerator.reference.duplicate(true)
	initial = GodokuReducer.reduce(initial)
	solution = GodokuGenerator.reference.duplicate(true)
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

func match_to(num:int=number):
	if num != 0:
		for y in range(9):
			for x in range(9):
				board[y][x].match_to(num)

func clear_highlight():
	for y in range(9):
		for x in range(9):
			board[y][x].clear_highlight()
