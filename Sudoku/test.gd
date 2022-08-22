extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var cell
var length = 9
var numberTable = []
var cellTable = []
var possibleVal = []
var startingPosition = Vector2(25,25)

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
	[0,0,0,0,3,0,0,5,0],
	[0,6,0,0,0,0,0,0,0],
	[1,0,4,2,0,0,0,0,9],
	[0,2,0,0,0,0,0,0,6],
	[6,0,7,0,0,5,0,9,0],
	[0,8,0,7,0,0,0,0,0],
	[7,0,9,4,0,0,0,0,1],
	[0,0,8,0,0,0,0,0,0],
	[0,0,0,0,0,2,4,0,0]
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	cellTable = makeGrid()
	populateTable()
	initiaiseGrid()
	
	


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		randomGridStart()
		#getNewVal()
	if (Input.is_action_just_pressed("ui_down")):
		initiaiseGrid()

func initiaiseGrid():
	
	possibleVal.clear()
	position = startingPosition
	numberTable = makeGrid()
	
	possibleVal = populateValues()
	
	
	getNewVal()
	
	updateCells()

func printGrid(grid):
	for x in 9:
		print(grid[x])
	print("Break")

func makeGrid():
	var grid = []
	for x in 9:
		grid.append([])
		for y in 9:
			grid[x].append(0)
	return grid

func possible(x,y,n):
	var result = false
	for i in 9:
		if numberTable[x][i] == n:
			return result
	for i in 9:
		if numberTable[i][y] == n:
			return result
	var gridX = (x / 3) * 3
	var gridY = (y / 3) * 3
	for i in 3:
		for j in 3:
			if numberTable[i+gridX][j+gridY] == n:
				return result
	result = true
	return result

func checkCorrectness():
	for x in 9:
		for i in range (1,10):
			if numberTable[x].count(i) > 1:
				print ("error in row " + str(x))
				return false
	for y in 9:
		var col = []
		for x in 9:
			col.append(numberTable[x][y])
		for i in range (1,10):
			if col.count(i) > 1:
				print ("error in column " + str(y))
				return false
	for x in 9:
		var grid = []
		var gridX = 0 + (x/3) * 3
		var gridY = 0 + (x%3) * 3
		for i in 3:
			for j in 3:
				grid.append(numberTable[i + gridX][j+gridY])
		for i in range (1,10):
			if grid.count(i) > 1:
				print ("error in grid " + str(x))
				return false
				
func gridFull():
	for x in 9:
		for y in 9:
			if numberTable[x][y] == 0:
				return false
	return true
#				

func populateValues():
	var table = []
	for x in 81:
		table.append([])
	return table
	
func randomGridStart():
	
	if gridFull():
			checkCorrectness()
			return
	
	var spots = []
	var newX
	var newY
	var low = 9
	
	for x in 81:
		if possibleVal[x].size() < low && possibleVal[x].size() > 0:
			low = possibleVal[x].size()
	for x in 81: 
		if possibleVal[x].size() == low:
			spots.append(x)

	var newIndex = spots[randi() % spots.size()]
	newX = newIndex / 9
	newY = newIndex % 9

	numberTable[newX][newY] = possibleVal[newIndex][randi() % possibleVal[newIndex].size()]
	possibleVal[newIndex].clear()
	
	getNewVal()
	
	randomGrid()
	
	

func randomGrid():
	
	if gridFull():
		checkCorrectness()
		return
		
	for x in 9:
		for y in 9:
			if numberTable[x][y] == 0 && possibleVal[(x * 9) + y].size() <= 0:
				numberTable[randi()%8+1][randi()%8+1] = 0
				numberTable[randi()%8+1][randi()%8+1] = 0
				numberTable[randi()%8+1][randi()%8+1] = 0
				
	var spots = []
	var newX
	var newY
	var low = 9
	
	for x in 81: 
		newX = x/9
		newY = x%9
		if (numberTable[newX][newY] == 0):
			spots.append(x)
		
	var newIndex = spots[randi() % spots.size()]
	newX = newIndex / 9
	newY = newIndex % 9

	numberTable[newX][newY] = possibleVal[newIndex][randi() % possibleVal[newIndex].size()]
	possibleVal[newIndex].clear()
	
	getNewVal()
	
	randomGrid()
	
	
	
func getNewVal():
	
	for x in 9:
		for y in 9:
			var value = []
			var index
			if numberTable[x][y] != 0:
				continue
			for i in range (1,10):
				if possible(x,y,i):
					value.append(i)
			index = (x * 9) + y
			possibleVal[index] = value
	updateCells()

func solve():
	var value = []
	for x in 9:
		for y in 9:
			value.clear()
			if numberTable[x][y] != 0:
				continue
			for i in range (1,10):
				if possible(x,y,i):
					value.append(i)
			if value.size() == 1:
				numberTable[x][y] = value[0]
				print(str(value[0]) + " added to " + str(x) + "," + str(y))
	printGrid(numberTable)


func recSolve():
	for x in 9:
		for y in 9:
			if numberTable[x][y] != 0:
				continue
			for i in range (1,10):
				if possible(x,y,i):
					numberTable[x][y] = i
					recSolve()
			numberTable[x][y] = 0
			return
	printGrid(numberTable)
	return


			
			
			
			
			
			

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

func updateCells():
	for x in length:
		for y in length:
			cellTable[x][y].value = numberTable[x][y]
	for x in 81:
		var newX = x / 9
		var newY = x % 9
		cellTable[newX][newY].pencil = possibleVal[x]
