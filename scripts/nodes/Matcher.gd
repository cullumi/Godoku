tool

extends Control

export (Array, NodePath) var target_paths = []
export (bool) var match_rect_min_size = false
export (bool) var realign = false setget trigger_realign

var targets:Array

func _ready():
	align()

func reinitialize_targets():
	targets.clear()
	for path in target_paths:
		targets.append(get_node(path))

func trigger_realign(_ignored): align()
func align():
	reinitialize_targets()
	for target in targets:
		if (match_rect_min_size):
			rect_min_size = Vector2()
			rect_min_size.x = max(rect_min_size.x, target.rect_min_size.x)
			rect_min_size.y = max(rect_min_size.y, target.rect_min_size.y)
