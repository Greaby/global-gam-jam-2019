tool
extends Node2D

export var stain_style = 0 setget editor_set_stain_style

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
var clean_timer = 0

var required_broom_type = 0

var collides_player = null

func editor_set_stain_style(style):
    stain_style = style
    $Sprite.region_rect.position.x = 32 + 32 * stain_style
    # Auto set broom type that works on this stain
    var broom_types = [0, 1, 1]
    required_broom_type = broom_types[style]

func _physics_process(delta):
    if collides_player and collides_player.brooming and collides_player.active_broom_type == required_broom_type:
        if clean_timer == 0:            
            clean_timer = 1
        if clean_timer > 0:
            #print(clean_timer)
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
           #print ("cleaning")   


func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):
        collides_player = null
        clean_timer = 0