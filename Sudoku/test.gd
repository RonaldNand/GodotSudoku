extends Node2D


export (PackedScene) var cell
var length = 8
var grid = []
var cellTable = []
var explored = []
var startingPosition = Vector2(25,25)
var solution = []

var north = [-1,0]
var east = [0,1]
var south = [1,0]
var west = [0,-1]
var northEast = [-1,1]
var northWest = [-1,-1]
var southEast = [1,1]
var southWest = [1,-1]




var baseGrid = [
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0]
	]

var startPuzzle = [
	[2,9,5,7,4,3,8,6,1],
	[4,3,1,8,6,5,9,0,0],
	[8,7,6,1,9,2,5,4,3],
	[3,8,7,4,5,9,2,1,6],
	[6,1,2,3,8,7,4,9,5],
	[5,4,9,2,1,6,7,3,8],
	[7,6,3,5,2,4,1,8,9],
	[9,2,8,6,7,1,3,5,4],
	[1,5,4,9,3,8,6,0,0]
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	initialise()
	createGrid()
	updateGrid()
	printGrid(grid)
	


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		#paint(5,0,"add")
		solution.clear()
		explored.clear()
		fillTents()
		updateGrid()
		printGrid(grid)
	if Input.is_action_just_pressed("ui_down"):
		fillTrees()
		updateGrid()

func printGrid(grid):
	for x in length:
		print(grid[x])
	print("Break")

func initialise():
	#Create LengthxLength Grid of Blank Spaces
	##########
	for x in length:
		grid.append([])
		for y in length:
			grid[x].append("Bl")
	#Generate a random number of Trees in the Grid in random order
	###########
	fillTrees()
	#setTrees()
	#Attempt to fill board with tents. 
	##########
	#fillTents()
	

func fillTrees():
	var rows = [1,2,3,1,2,0,2,1]
	rows.shuffle()
	for x in length:
		var line = []
		for i in rows[x]:
			line.append("Tr")
		while line.size() < length:
			line.append("Bl")
		line.shuffle()
		grid[x] = line.duplicate(true)

func setTrees():
	for x in length:
		for y in length:
			if x == 1 && y == 1:
				grid[x][y] = "Tr"
			if x == 4 && y == 4:
				grid[x][y] = "Tr"
			if x == 6 && y == 6:
				grid[x][y] = "Tr"

func fillTents():
	for x in length:
		for y in length:
			#Go through each tree in Grid
			if grid[x][y] == "Tr":
				#Skip Trees already explored.
				if explored.has([x,y]):
					continue 
				#Choose valid directions to explore
				var directions = []
				if x != 0:
					directions.append(north)
				if (y != (length - 1)):
					directions.append(east)
				if y != 0:
					directions.append(west)
				if (x != (length - 1)):
					directions.append(south)
				directions.shuffle()
				#Explore each direction
				for i in directions.size():
					var tryX = x + directions[i][0]
					var tryY = y + directions[i][1]
					#Add Tent to Spot if possible.
					if grid[tryX][tryY] == "Bl":
						grid[tryX][tryY] = "Te"
						paint(tryX,tryY,"add")
						#Mark tree as explored
						explored.append([x,y])
						#Continue attemptint to solve with added tree
						fillTents()
						if (solution.size() > 0):
							return
						#If we return without a solution, undo changes and try another direction.
						explored.erase([x,y])
						grid[tryX][tryY] = "Bl"
						paint(tryX,tryY,"remove")
				return
	#If we explore all trees report solution.
	solution = grid.duplicate(true)
	print("We found something?")
	return

func paint(x,y,mode):
	#Choose valid directions to explore.
	var directions = []
	if x != 0:
		directions.append(north)
	if y != (length - 1):
		directions.append(east)
	if y != 0: 
		directions.append(west)
	if x != (length - 1):
		directions.append(south)
	if x != 0 && y != (length - 1):
		directions.append(northEast)
	if x != (length - 1) && y != (length - 1):
		directions.append(southEast)
	if x != 0 && y != 0:
		directions.append(northWest)
	if x != (length - 1) && y != 0:
		directions.append(southWest)
	for i in directions.size():
		var tryX = x + directions[i][0]
		var tryY = y + directions[i][1]
		match mode:
			#If a blank square exists fill with dirt.
			"add":
				if grid[tryX][tryY] == "Bl":
					grid[tryX][tryY] = "Dr"
			"remove":
				if grid[tryX][tryY] == "Dr":
					grid[tryX][tryY] = "Bl"
	
func createGrid():
	for x in length:
		cellTable.append([])
		for y in length:
			cellTable[x].append(0)
	var row_offset = 0
	var col_offset = 0
	for x in length:
		col_offset = x * 64 
		for y in length:
			row_offset = y * 64
			cellTable[x][y] = cell.instance()
			cellTable[x][y].position += Vector2(row_offset, col_offset)
			add_child(cellTable[x][y])

func updateGrid():
	for x in length:
		for y in length:
			cellTable[x][y].value = grid[x][y]
	
						
