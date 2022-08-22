extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var value = 0
var pencil = []
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hidePencil()

func _process(delta):
	#get_input()
	if (value != 0):
		$ColorRect/Field.text = str(value)
		hidePencil()
	else:
		$ColorRect/Field.text = ""
		if !pencil.empty():
			for x in range (1,10):
				if (pencil.find(x) >= 0):
					$Pencil.get_child(x-1).show()
				else:
					$Pencil.get_child(x-1).hide()
		else:
			hidePencil()

func hidePencil():
	for x in $Pencil.get_child_count():
		$Pencil.get_child(x).hide()

