extends Object

class_name Matrixes

static func test():
	print("test")
	var mat:Array = [
		[1, 2, 3],
		[4, 5, 6],
		[7, 8, 9],
	]
	var rot:Array = [
		[0, 0, 0],
		[0, 0, 1],
		[0, 1, 0],
	]
	print_mat(multiply(mat, rot))

static func new_mat(size_y:int, size_x:int, initial=0) -> Array:
	var matrix:Array = []
	for y in range(size_y):
		matrix.append([])
		for x in range(size_x):
			matrix[y].append(initial)
	return matrix

static func multiply(mat1:Array, mat2:Array) -> Array:
	var k_size = mat2.size()
	var a_size = mat1.size()
	var b_size = mat2[0].size()
	var result:Array = new_mat(a_size, b_size)
	for k in range(k_size):
		for a in range(a_size):
			for b in range(b_size):
				result[a][b] += mat1[a][k] * mat2[k][b]
	return result

static func print_mat(matrix:Array):
	print("print mat")
	print("{")
	for row in matrix:
		print(row)
	print("}")
	print("")
