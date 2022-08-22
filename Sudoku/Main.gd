extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var cell
var length = 9
var numberTable = []
var cellTable = []
var startingPosition = Vector2(25,25)

var startPuzzle = [
	[5,3,6,9,1,8,0,2,3],
	[7,1,3,6,0,2,0,4,9],
	[0,8,0,0,0,0,0,5,1],
	[6,0,4,0,0,0,0,0,2],
	[0,2,7,8,6,0,0,0,0],
	[0,0,0,0,0,4,1,0,0],
	[3,0,0,1,4,0,2,0,0],
	[0,0,0,5,0,6,3,0,8],
	[0,7,0,0,0,0,0,0,6]
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	position = startingPosition
	numberTable = getTable()
	cellTable = getTable()
	populateTable()
	print (numberTable)


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCells()
	checkErrors()
	if (Input.is_action_just_pressed("ui_accept")):
		print(numberTable)

func getTable():
	var table = []
	for x in range (0,length):
		table.append([])
		for y in range (0,length):
			table[x].append(0)
	return table

func populateTable():
	var row_offset = 0
	var col_offset = 0
	for x in length:
		col_offset = x * 64 
		for y in length:
			row_offset = y * 64
			cellTable[x][y] = cell.instance()
			cellTable[x][y].position += Vector2(row_offset, col_offset)
			add_child(cellTable[x][y])
	updateCells()
	connectButton()

func updateCells():
	for x in length:
		for y in length:
			cellTable[x][y].value = numberTable[x][y]

func connectButton():
	for x in length:
		for y in length:
			if !cellTable[x][y].locked:
				cellTable[x][y].get_child(2).connect("pressed",self,"updateCell",[x,y])

func updateCell(x,y):
	var number = $NumberSelector.selectedNumber 
	var pencil = $NumberSelector.pencil
	if pencil:
		numberTable[x][y] = 0
		if cellTable[x][y].get_child(1).get_child(number-1).is_visible():
			cellTable[x][y].get_child(1).get_child(number-1).hide()
		else:
			cellTable[x][y].get_child(1).get_child(number-1).show()
	else:
		numberTable[x][y] = number
		

func checkErrors():
	checkRows()
	checkColumns()
	for grid in 9:
		checkSquare(grid)

func checkRows():
	for x in length:
		for num in range (1,10):
			var numCount = 0
			for y in length:
				if numberTable[x][y] == num:
					numCount += 1
			if numCount >= 2:
				print ("Error in line "+ str(x))
				return 1

func checkColumns():
	for y in length:
		for num in range (1,10):
			if num == 0:
				continue
			var numCount = 0
			for x in length:
				if numberTable[x][y] == num:
					numCount += 1
			if numCount >= 2:
				print ("Error in column "+ str(y))
				return 1

func checkSquare(grid):
	var xRange = []
	var yRange = []
	var yFactor = grid / 3
	var xFactor = grid % 3
	var debug

	xRange = [(0 + (3 * xFactor)),(2 + (3 * xFactor))]
	yRange = [(0 + (3 * yFactor)),(2 + (3 * yFactor))]
	
	for num in range (1,10):
			var numCount = 0
			for x in range (xRange[0],xRange[1]+1):
				for y in range (yRange[0],yRange[1]+1):
					debug = numberTable[x][y]
					if numberTable[x][y] == num:
						numCount += 1
			if numCount >= 2:
				print ("Error in grid "+ str(grid))
				return 1
