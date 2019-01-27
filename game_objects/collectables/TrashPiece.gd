tool
extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var trash_type = 0 setget editor_set_trash_type

# 0 = metal / 1 = glass
var trash_material = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):    
       body.collides_movable = self
    
func delete():
    queue_free()
    
func editor_set_trash_type(type):
    
    $Sprite.region_rect.position.x = 128 + 32 * type
    
    trash_type = type
    var materials = [0, 0, 0, 1]
    trash_material = materials[type]

func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):    
       body.collides_movable = null