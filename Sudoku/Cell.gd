extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var value = 0
var pencil = []
var locked = false
var thickTop = false
var thickRight = false
var thickLeft = false
var thickBottom = false
var highlight = false
var error = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Highlight.hide()
	$Error.hide()
	hidePencil()
	if thickTop:
		$Border/TopBorder.rect_size += Vector2(0,4)
	if thickLeft:
		$Border/LeftBorder.rect_size += Vector2(4,0)
	if thickRight:
		$Border/RightBorder.rect_size += Vector2(4,0)
		$Border/RightBorder.rect_position -= Vector2(4,0)
	if thickBottom:
		$Border/BottomBorder.rect_size += Vector2(0,4)
		$Border/BottomBorder.rect_position -= Vector2(0,4)

func _process(delta):
	#get_input()
	if value != str(0):
		$Border/Field.text = str(value)
		hidePencil()
	else:
		$Border/Field.text = ""
		if !pencil.empty():
			for x in range (1,10):
				if (pencil.find(x) >= 0):
					$Pencil.get_child(x-1).show()
				else:
					$Pencil.get_child(x-1).hide()
		else:
			hidePencil()
	if error:
		$Highlight.hide()
		$Error.show()
	else:
		$Error.hide()	
		if highlight:
			$Highlight.show()
		else:
			$Highlight.hide()

func hidePencil():
	for x in $Pencil.get_child_count():
		$Pencil.get_child(x).hide()

