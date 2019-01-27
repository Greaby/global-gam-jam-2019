tool
extends Node2D

export (NodePath) var target_door = null

export var door_style = 0 setget editor_set_door_style

var current_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func editor_set_door_style(style):
    
    $Sprite.region_rect.position.x = 192 + 32 * style
    door_style = style

func enter_door(player):
    print ("Enter door")
    
    if target_door != null:
        current_player = player
        
        owner.fade_for_door(self)
        

func notify_warp_pre_fade_ended():
    current_player.position = get_node(target_door).position
    
    current_player.move_enabled = true
    
    owner.fade_out_for_door(self)

func _on_Area_body_entered(body):
    if body.is_in_group("player"):
        body.goes_in_front_of_door(self)


func _on_Area_body_exited(body):
    if body.is_in_group("player"):
        body.no_more_in_front_of_door(self)
