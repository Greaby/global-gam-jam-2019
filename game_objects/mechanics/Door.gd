extends Node2D

export (NodePath) var target_door = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func enter_door(player):
    print ("Enter door")
    if target_door != null:
        
        
        
        player.position = get_node(target_door).position
        



func _on_Area_body_entered(body):
    if body.is_in_group("player"):
        body.goes_in_front_of_door(self)


func _on_Area_body_exited(body):
    if body.is_in_group("player"):
        body.no_more_in_front_of_door(self)
