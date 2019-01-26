extends Node2D

export (NodePath) var target_door = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func enter_door(player):
    
    if target_door != null:
        
        player.position = target_door.position
        

