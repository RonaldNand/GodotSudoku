extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectedNumber = null
var pencil = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	initialize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func selectNumber(number):
	selectedNumber = number
	$Layer.show()
	if number <= 0:
		$Layer.rect_position = get_child(10).rect_position
	else:
		$Layer.rect_position = get_child(number - 1).rect_position

func togglePencil():
	if !pencil:
		pencil = true
	else: 
		pencil = false
	print(pencil)
	

func initialize():
	$Layer.hide()
	for x in get_child_count():
		if x < 9:
			get_child(x).connect("pressed",self,"selectNumber",[x+1])
	get_child(9).connect("pressed",self,"togglePencil")
	get_child(10).connect("pressed",self,"selectNumber",[0])
