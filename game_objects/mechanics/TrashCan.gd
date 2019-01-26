extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var contents = 0
var capacity = 3

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area_body_entered(body):
    if body.is_in_group("player"):
        body.collides_trashcan = self   
            
func can_add_trash():
    return contents < capacity 

func add_trash(count):
    contents += count

func _on_Area_body_exited(body):
    print ("exited")
    if body.is_in_group("player"):
        body.collides_trashcan = null   