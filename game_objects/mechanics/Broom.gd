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
        $Sprites/VacuumItem.visible = true
        $Sprites/Brush.visible = false
    if type == 1:
        # Mop
        $Sprites/VacuumItem.visible = false
        $Sprites/Brush.visible = true
        
func start_scrub():
    if broom_type == 0:
        $AnimationPlayer.play("vacuum")
    else:
        $AnimationPlayer.play("brush")
    
func stop_scrub():
    $AnimationPlayer.play("idle")
    if broom_type == 0:
        # Vacuum
        $Sprites/VacuumItem.visible = true
        $Sprites/Brush.visible = false
    if broom_type == 1:
        # Mop
        $Sprites/VacuumItem.visible = false
        $Sprites/Brush.visible = true

func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):    
       body.collides_movable = self


func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):    
       body.collides_movable = null  