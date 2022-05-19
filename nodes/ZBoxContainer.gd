tool

extends Container

class_name ZBoxContainer

enum MODE {HORIZONTAL, VERTICAL}
const DEFAULT_MODE = MODE.HORIZONTAL
export (MODE) var mode = DEFAULT_MODE setget set_mode
export (bool) var fit_to_aspect_ratio = true
export (bool) var realign setget trigger_realign

var axis
var off_axis 

func set_mode(val):
	mode = val
	match mode:
		MODE.HORIZONTAL:
			axis = Axes.X
			off_axis = Axes.Y
		MODE.VERTICAL:
			axis = Axes.Y
			off_axis = Axes.X
	align()

func trigger_realign(val):
	realign = false
	align()

func stretch_total() -> float:
	var total:float = 0
	for child in get_children():
		if child_expands(child):
			var ratio = child.size_flags_stretch_ratio
			total += ratio
	return total

func stretch_limit() -> float:
	var stretch = rect_size[axis]
	for child in get_children():
		if not child_expands(child):
			stretch -= child.rect_min_size[axis]
	return stretch

func child_expands(child:Control) -> bool:
	var flag = (
		child.size_flags_horizontal if
			mode == MODE.HORIZONTAL else
				child.size_flags_vertical
	)
	return flag == SIZE_EXPAND or flag == SIZE_EXPAND_FILL

func has_expand_flags() -> bool:
	for child in get_children():
		if child_expands(child): return true
	return false

func align():
	var count = get_child_count()
	var stretch_sum = stretch_total()
	var stretch_size = stretch_limit()
	var has_expand = has_expand_flags()
	var axis_pos = 0
	var axis_size = 0
	for child in get_children():
		if (child_expands(child) and stretch_size >= 0):
			var stretch_ratio = child.size_flags_stretch_ratio/stretch_sum
			axis_size = stretch_size * stretch_ratio
		else:
			axis_size = child.rect_min_size[axis]
		var size = Make.vector2([axis_size, rect_size], [axis, off_axis])
		var pos = Make.vector2([axis_pos, 0], [axis, off_axis])
		fit_child_in_rect(child, Rect2(pos, size))
		axis_pos += size[axis]

func _init(md = DEFAULT_MODE): self.mode = md
func _ready(): align()
func _notification(what:int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		align()
