extends TileMap

#Tetr's coordinates for eeach tetrimino shape as well as each of their rotations
var i0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i0, i90, i180, i270]

var t0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t0, t90, t180, t270]

var o0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o90 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o180 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o0, o90, o180, o270]

var z0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z90 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z := [z0, z90, z180, z270]

var s0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s270 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s := [s0, s90, s180, s270]

var l0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l0, l90, l180, l270]

var j0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j := [j0, j90, j180, j270]

#Array to hold the different shapes as well as a duplicate array to select a true random tetr
var shapes := [i, t, o, z, s, l, j]
var shapesFull := shapes.duplicate()

#Constants for grid
const COLUMNS : int = 10
const ROWS : int = 20

#Variables for movement
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps : Array
const requiredSteps : int = 50
const startPosition := Vector2i(5, 1)
var currentPosition : Vector2i
var speed : float

#Variables for the different tetrs
var tetrShape
var nextTetrShape
var rotateIndex : int = 0
var currTetr : Array

#Variables for the tilemap
var tileId :int = 0
var tetrAtlas : Vector2i
var nextTetrAtlas : Vector2i

#Variables for the player
var boardLayer : int = 0
var currLayer : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	newGame()
	
func newGame():
	speed = 1.0
	#Index 0 is left 1 is right and 2 is down
	steps = [0, 0, 0]
	tetrShape = selectTetr()
	#Assigns our atlas variable to set colors for each unique shape for the tetrs
	tetrAtlas = Vector2i(shapesFull.find(tetrShape), 0)
	newTetr()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		steps[0] += 10
	elif Input.is_action_pressed("ui_right"):
		steps[1] += 10
	elif Input.is_action_pressed("ui_down"):
		steps[2] += 10
	#Downward movement for each frame
	steps[2] += speed
	#Moving the tetr
	for i in range(steps.size()):
		if steps[i] > requiredSteps:
			moveTetr(directions[i])
			steps[i] = 0

#Function to select a random tetr
func selectTetr():
	var tetr
	#If the shapes array is not empty it will shuffle the shapes and remove the front tetr 
	if not shapes.is_empty():
		shapes.shuffle()
		tetr = shapes.pop_front()
	#If the array is empty fill the array with the duplicate and select another random tetr
	else:
		shapes = shapesFull.duplicate()
		shapes.shuffle()
		tetr = shapes.pop_front()
	return tetr

#Function to reset our variables and to create a new tetr
func newTetr():
	steps = [0, 0, 0]
	currentPosition = startPosition
	currTetr = tetrShape[rotateIndex]
	createTetr(currTetr, currentPosition, tetrAtlas)

#Function to remove any trail made by moving a piece
func removeTetr():
	for i in currTetr:
		erase_cell(currLayer, currentPosition + i)

#Function to create a piece on the board
func createTetr(piece, pos, atlas):
	for i in piece:
		set_cell(currLayer, pos + i, tileId, atlas)

#Function to move the tetr in a direction
func moveTetr(dir):
	if moveCheck(dir):
		removeTetr()
		currentPosition += dir
		createTetr(currTetr, currentPosition, tetrAtlas)

#Function that checks if there is space to move
func moveCheck(dir):
	var mc = true
	for i in currTetr:
		if not isFree(i + currentPosition + dir):
			mc = false
	return mc

#Function that returns the id for the tileset thats used in a cell if not empty, if it is it returns -1
func isFree(pos):
	return get_cell_source_id(boardLayer, pos) == -1
