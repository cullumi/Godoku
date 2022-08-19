extends Object

class_name Axes

const X = "x"
const Y = "y"
const Z = "z"
const AXES:Array = [X, Y, Z]

static func fillAxes(axes:Array, max_size:int=3):
	for a in AXES:
		if (not axes.has(a)):
			axes.append(a)
		if axes.size() >= max_size:
			break

static func convertAxes(axes:Array):
	for i in range(axes.size()):
		if axes[i] is int:
			axes[i] = AXES[axes[i]]

static func conformAxes(vals, axes:Array):
	if (vals is Array):
		if (vals.size() > axes.size()):
			fillAxes(axes, vals.size())
