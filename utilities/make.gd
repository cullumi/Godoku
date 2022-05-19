extends Object

class_name Make

static func is_vector(val):
	return val is Vector2 or val is Vector3

static func vector2(vals, axes:Array):
	var vector:Vector2 = Vector2()
	Axes.convertAxes(axes)
	Axes.conformAxes(vals, axes)
	for i in range(axes.size()):
		if is_vector(vals):
			vector[axes[i]] = vals[axes[i]]
		elif is_vector(vals[i]):
			vector[axes[i]] = vals[i][axes[i]]
		else:
			vector[axes[i]] = vals[i]
	return vector
