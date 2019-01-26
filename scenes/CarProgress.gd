extends Node2D

onready var start_pos = $StartPosition.position.x
onready var end_pos = $EndPosition.position.x

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_timeleft(time, time_total):
	$Car.position.x = lerp(start_pos, end_pos, 1-(time/time_total))
	
	
