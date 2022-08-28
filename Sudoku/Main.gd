extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var cell
var length = 9
var numberTable = []
var cellTable = []
var possibleVal = []
var solutions = []
var startingPosition = Vector2(25,25)
var target = 20
var counter = 0

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
	
	
	initialiseGrid()
	
	


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		generatePuzzle()
	if (Input.is_action_just_pressed("ui_down")):
		initialiseGrid()
#	if (Input.is_action_just_pressed("ui_right")):
	updateCells()
	
#

func initialiseGrid():
	
	get_tree().call_group("cell","queue_free")
	
	possibleVal.clear()
	position = startingPosition
	#numberTable = startPuzzle
	numberTable = baseGrid.duplicate(true)
	generatePuzzle()
	
	cellTable = baseGrid.duplicate(true)
	populateTable()
	
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

func populateValues():
	var table = []
	for x in 81:
		table.append([])
	return table
	
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
	

func recSolve():
	
	for x in 9:
		for y in 9:
			if numberTable[x][y] != 0:
				continue
			for i in range (1,10):
				if possible(x,y,i):
					numberTable[x][y] = i
					recSolve()
					if solutions.size() > 1:
						print("Too Many Solutions!")
						return false
			numberTable[x][y] = 0
			return 
	printGrid(numberTable)
	solutions.append(numberTable.duplicate(true))
	return true

func recFill():
	for x in 9:
		for y in 9:
			var num = [1,2,3,4,5,6,7,8,9]
			num.shuffle()
			if numberTable[x][y] == 0:
				for i in num.size():
					if possible(x,y,num[i]):
						numberTable[x][y] = num[i]
						if recFill():
							return true
				numberTable[x][y] = 0
				return
	printGrid(numberTable)
	return true

func generatePuzzle():
	recFill()
	target = 50
	counter = 0
	removeNumber()
	counter = 0

func removeNumber():
	if counter >= target:
		return
	var table = numberTable.duplicate(true)
	var filledCells = []
	for x in 9:
		for y in 9:
			if numberTable[x][y] != 0:
				filledCells.append((x * 9) + y)
	for x in filledCells.size():
		var index = filledCells[randi() % filledCells.size() - 1]
		var newX = index / 9
		var newY = index % 9
		numberTable[newX][newY] = 0
		recSolve()
		if solutions.size() > 1:
			numberTable = table.duplicate(true)
			solutions.clear()
			filledCells.remove(index)
			continue
		else:
			counter += 1
			removeNumber()
			if counter >= target:
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
			if x == 0:
				cellTable[x][y].thickTop = true
			if x == 8 || x == 2 || x == 5:
				cellTable[x][y].thickBottom = true
			if y == 0: 
				cellTable[x][y].thickLeft = true
			if y == 8 || y == 2 || y == 5:
				cellTable[x][y].thickRight = true
			add_child(cellTable[x][y])
			
	for x in 9:
		for y in 9:
			if numberTable[x][y] != 0:
				cellTable[x][y].locked = true
				
	connectButton()
			
func connectButton():
	for x in length:
		for y in length:
			if !cellTable[x][y].locked:
				cellTable[x][y].get_child(2).connect("pressed",self,"updateCell",[x,y])

func updateCell(x,y):
	var number = $NumberSelector.selectedNumber 
	var pencil = $NumberSelector.pencil
	var eraser = $NumberSelector.eraser 
	if eraser:
		numberTable[x][y] = 0
		cellTable[x][y].pencil.clear()
	elif pencil:
		numberTable[x][y] = 0
		var index = cellTable[x][y].pencil.find(number)
		if index >= 0:
			cellTable[x][y].pencil.remove(index)
		else:
			cellTable[x][y].pencil.append(number)
	else:
		numberTable[x][y] = number
		cellTable[x][y].pencil.clear()
	updateCells()

func updateCells():
	for x in length:
		for y in length:
			cellTable[x][y].value = numberTable[x][y]
#	for x in 81:
#		var newX = x / 9
#		var newY = x % 9
#		cellTable[newX][newY].pencil = possibleVal[x]

func _on_NumberSelector_numberChanged():
	for x in 9:
		for y in 9:
			if cellTable[x][y].value == $NumberSelector.selectedNumber: 
				cellTable[x][y].highlight = true
			else:
				if cellTable[x][y].highlight:
					cellTable[x][y].highlight = false
	
				 
