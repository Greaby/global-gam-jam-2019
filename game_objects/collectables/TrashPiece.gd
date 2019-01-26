tool
extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var trash_type = 0 setget editor_set_trash_type

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):
        if body.can_pick_up_trash():
            body.do_pick_up_trash(trash_type)
            queue_free()

func editor_set_trash_type(type):
    
    $Sprite.region_rect.position.x = 128 + 32 * type
    
    trash_type = type