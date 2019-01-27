tool
extends Node2D

# 0 for vacuum / 1 for mop
export var broom_type = 0 setget editor_set_broom_type


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func editor_set_broom_type(type):
    broom_type = type
    if type == 0:
        # Vacuum
        $Sprites/Sprite.visible = true
        $Sprites/Sprite2.visible = false
    if type == 1:
        # Mop
        $Sprites/Sprite.visible = false
        $Sprites/Sprite2.visible = true
        
func start_scrub():
    $AnimationPlayer.play("vacuum")
    
func stop_scrub():
    $AnimationPlayer.play("idle")

func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):    
       body.collides_movable = self


func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):    
       body.collides_movable = null  