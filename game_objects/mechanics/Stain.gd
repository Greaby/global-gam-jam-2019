extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
var clean_timer = 0

var collides_player = null
func _physics_process(delta):
    if collides_player and collides_player.brooming:
        if clean_timer == 0:            
            clean_timer = 1
        if clean_timer > 0:
            print ("dvdsvds")
            print(clean_timer)
            clean_timer = clean_timer - delta
            if clean_timer <= 0:
                collides_player.notify_stain_cleaned()
                queue_free()
    elif collides_player and !collides_player.brooming:
        clean_timer = 0
        

func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):
        collides_player = body
        if body.brooming:    
           clean_timer = 1
           print ("cleaning")   


func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):
        collides_player = null
        clean_timer = 0