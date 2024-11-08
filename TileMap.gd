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
const ACCELERATION : float = 0.25

#Variables for the different tetrs
var tetrShape
var nextTetrShape
var nextNextTetrShape
var nextNextNextTetrShape
var rotateIndex : int = 0
var currTetr : Array

#Variables for the score
var score : int
const GIVEPOINT : int = 100
const TETRIS : int = 1000
var level : int = 1
var linesCleared : int = 0
var gameRunning : bool

#Variables for the tilemap
var tileId :int = 0
var tetrAtlas : Vector2i
var nextTetrAtlas : Vector2i
var nextNextTetrAtlas
var nextNextNextTetrAtlas

#Variables for the player
var boardLayer : int = 0
var currLayer : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	newGame()
	$Display.get_node("NewGameButton").pressed.connect(newGame)
	
func newGame():
	score = 0
	speed = 1.0
	gameRunning = true
	#Index 0 is left 1 is right and 2 is down
	steps = [0, 0, 0]
	$Display.get_node("GameOver").hide()
	#Clear the screen after a new game
	removeTetr()
	removeBoard()
	removePanel()
	$Display.get_node("ScoreLabel").text = "SCORE: " + str(score)
	tetrShape = selectTetr()
	#Assigns our atlas variable to set colors for each unique shape for the tetrs
	tetrAtlas = Vector2i(shapesFull.find(tetrShape), 0)
	nextTetrShape = selectTetr()
	nextTetrAtlas = Vector2i(shapesFull.find(nextTetrShape), 0)
	nextNextTetrShape = selectTetr()
	nextNextTetrAtlas = Vector2i(shapesFull.find(nextNextTetrShape), 0)
	nextNextNextTetrShape = selectTetr()
	nextNextNextTetrAtlas = Vector2i(shapesFull.find(nextNextNextTetrShape), 0)
	newTetr()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameRunning:
		if Input.is_action_pressed("ui_left"):
			steps[0] += 15
		elif Input.is_action_pressed("ui_right"):
			steps[1] += 15
		elif Input.is_action_pressed("ui_down"):
			steps[2] += 15
		elif Input.is_action_just_pressed("ui_up"):
			rotateTetr()
		elif Input.is_action_just_pressed("ui.space"):
			quickDrop()
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
	createTetr(nextTetrShape[0], Vector2i(15, 3), nextTetrAtlas)
	createTetr(nextNextTetrShape[0], Vector2i(15, 6), nextNextTetrAtlas)
	createTetr(nextNextNextTetrShape[0], Vector2i(15, 9), nextNextNextTetrAtlas)

#Function to remove any trail made by moving a piece
func removeTetr():
	for i in currTetr:
		erase_cell(currLayer, currentPosition + i)

#Function to create a piece on the board
func createTetr(piece, pos, atlas):
	for i in piece:
		set_cell(currLayer, pos + i, tileId, atlas)

#Function that implements the rotations for the tetrs
func rotateTetr():
	if rotateCheck():
		removeTetr()
		#Modding by 4 to not go past 5 rotations
		rotateIndex = (rotateIndex + 1) % 4
		currTetr = tetrShape[rotateIndex]
		createTetr(currTetr, currentPosition, tetrAtlas)

#Function to move the tetr in a direction
func moveTetr(dir):
	if moveCheck(dir):
		removeTetr()
		currentPosition += dir
		createTetr(currTetr, currentPosition, tetrAtlas)
	else:
		if dir == Vector2i.DOWN:
			landTetr()
			rowCheck()
			tetrShape = nextTetrShape
			tetrAtlas = nextTetrAtlas
			nextTetrShape = selectTetr()
			nextTetrAtlas = Vector2i(shapesFull.find(nextTetrShape), 0)
			removePanel()
			newTetr()
			nextTetrShape = nextNextTetrShape
			nextTetrAtlas = nextNextTetrAtlas
			nextNextTetrShape = selectTetr()
			nextNextTetrAtlas = Vector2i(shapesFull.find(nextNextTetrShape), 0)
			removePanel()
			newTetr()
			nextNextTetrShape = nextNextNextTetrShape
			nextNextTetrAtlas = nextNextNextTetrAtlas 
			nextNextNextTetrShape = selectTetr()
			nextNextNextTetrAtlas = Vector2i(shapesFull.find(nextNextNextTetrShape), 0)
			removePanel()
			newTetr()
			gameOverCheck()

#Function that checks if there is space to move
func moveCheck(dir):
	var mc = true
	for i in currTetr:
		if not isFree(i + currentPosition + dir):
			mc = false
	return mc

#Function that checks if a tetr can be rotated if it isnt overlapping with the borders
func rotateCheck():
	var rc = true
	var tempRotateIndex = (rotateIndex + 1) % 4
	for i in tetrShape[tempRotateIndex]:
		if not isFree(i + currentPosition):
			rc = false
	return rc

#Function that returns the id for the tileset thats used in a cell if not empty, if it is it returns -1
func isFree(pos):
	return get_cell_source_id(boardLayer, pos) == -1

#Function to remove each tetr from the current layer into the board layer when they get to the ground
func landTetr():
	for i in currTetr:
		erase_cell(currLayer, currentPosition + i)
		set_cell(boardLayer, currentPosition + i, tileId, tetrAtlas)

#Function that removes the tiles in the next box after they are placed so there is no overlapping
func removePanel():
	for i in range(14, 19):
		for j in range(2, 13):
			erase_cell(currLayer, Vector2i(i, j))

#Function to check if a row is empty to delete it
func rowCheck():
	var row : int = ROWS
	var rowsCleared : int = 0
	var totalRowsCleared : int = 0
	#Loop until the top of the board
	while row > 0:
		var res = 0
		#Loop to check if the cells are free
		for i in range(COLUMNS):
			if not isFree(Vector2i(i + 1, row)):
				res += 1
		#When the row becomes full we delete it and shift down, if not we subtract 1
		if res == COLUMNS:
			shiftRowDown(row)
			rowsCleared += 1
			totalRowsCleared += 1
			#Give points when a row is completed and updates the display
		else:
			row -= 1
	#If 4 rows are cleared simultaneously it rewards the player with a TETRIS which is 1000 pointst
	if rowsCleared == 4:
		score += TETRIS
	#Else it will give them 100-300 depending on the rows cleared
	else:
		score += GIVEPOINT * rowsCleared
	linesCleared += totalRowsCleared
	if linesCleared >= 10 * level:
		level += 1
		speed += ACCELERATION
		linesCleared = 0
		$Display.get_node("LevelLabel").text = "LEVEL: " + str(level)
	#Updates the Score on the display and rests rowsCleared to 0
	$Display.get_node("ScoreLabel").text = "SCORE: " + str(score)
	rowsCleared = 0

#Function that will shift the rest of the rows downward after a row is completed
func shiftRowDown(row):
	var atlas
	#Loop going through the rows from top down
	for i in range(row, 1, -1):
		#Loop going through each cells
		for j in range(COLUMNS):
			#Takes the cell coordinates and checks if there is a color in that cell
			atlas = get_cell_atlas_coords(boardLayer, Vector2i(j + 1, i - 1))
			if atlas == Vector2i(-1, -1):
				erase_cell(boardLayer, Vector2i(j + 1, i))
			else:
				set_cell(boardLayer, Vector2i(j + 1, i), tileId, atlas)

#Function that will clear the board for the start of each new game
func removeBoard():
	for i in range(ROWS):
		for j in range(COLUMNS):
			erase_cell(boardLayer, Vector2i(j+1, i+1))
			erase_cell(boardLayer, Vector2i(j+2, i+1))

#Function that will check if a game over has happened and stop the game when it does
func gameOverCheck():
	for i in currTetr:
		if not isFree(i+currentPosition):
			landTetr()
			$Display.get_node("GameOver").show()
			gameRunning = false

#Fuction that uses a binary search to find the valid cell in order to quick drop and quickly place a piece
func quickDrop():
	if not gameRunning:
		return
		
	var bottom_pos = currentPosition
	var low = 0
	var high = ROWS - 1
	
	while low <= high:
		var mid = (low + high) / 2
		var isValid = true
		for i in currTetr:
			if not isFree(Vector2i(currentPosition.x+i.x, mid+i.y)):
				isValid = false
				break
		if isValid:		
			low = mid + 1
		else:
			high = mid - 1
	
	bottom_pos.y = high
	removeTetr()A
	currentPosition = bottom_pos
	landTetr()
	moveTetr(Vector2i.DOWN)
