extends Node2D

var contents = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func delete():
    queue_free()
    

func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):    
       body.collides_movable = self  


func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):    
       body.collides_movable = null  
