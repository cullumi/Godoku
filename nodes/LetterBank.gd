tool
extends ItemList

class_name LetterBank

enum MODE {VALUE, NOTE}
export (MODE) var mode = MODE.VALUE
export (Texture) var item_icon setget set_icon
export (DynamicFont) var font setget set_font
export (bool) var realign = false setget realign

const n = null
const X = "X"
const columns = 3
const column_width = 48*2 - 16
const buffer = 30
const letters:Array = [
	n, n, n,
	1, 2, 3,
	n, n, n,
	4, 5, 6,
	n, n, n,
	7, 8, 9,
	n, n, n,
	n, X, n,
	n, n, n,
]
const letter_indexes:Array = []
const values:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
const notes:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
const sets:Array = [values, notes]

signal unselected
signal selected(val)

var last_selected:int = -1

func realign(_ignored): align()
func align():
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL
	max_columns = columns
	allow_reselect = true
	same_column_width = false
	fixed_column_width = column_width
	var rows = ((letters.size()/columns) + (letters.size()%columns))
	var total_hsep = (columns) * get_constant("hseparation")
	var total_vsep = (rows+1) * get_constant("vseparation")
	var x_size = (columns) * column_width
	rect_min_size.x = x_size + total_hsep + buffer
	rect_min_size.y = total_vsep + buffer
	rect_size.x = rect_min_size.x
	reinitialize_children()

func reinitialize_children():
	clear()
	create_items()

func create_items():
	letter_indexes.clear()
	var index:int = 0
	for letter in letters:
		var letter_not_null = letter != null
		var icon = null
		if (letter_not_null):
			letter_indexes.append(index)
			icon = item_icon
		else:
			letter = " "
		add_item(" " + String(letter) + " ", icon, letter_not_null)
		index += 1

func resized(): align()
func _ready():
	connect("item_selected", self, "item_selected")
	align()

func set_icon(val):
	item_icon = val
	align()
func set_font(val):
	font = val
	if (font != null):
		add_font_override("font", font)
	align()

func deselect(index:int=last_selected):
	if last_selected >= 0:
		unselect(index)
		last_selected = -1

func item_selected(index:int):
	if (last_selected == index):
		unselect(index)
		emit_signal("unselected")
		last_selected = -1
	else:
		last_selected = index
		emit_signal("selected", sets[mode][letter_indexes.find(index)])
