extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var anim_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "enter":
        $AnimationPlayer.play("press_start")
        anim_done = true

func _input(event):
    
    if event.is_action_pressed("ui_accept"):
        print("accept")
        
        if anim_done:
            go_to_next_scene()
        else:
            #End frame
            $AnimationPlayer.seek(2, true)
            $AnimationPlayer.play("press_start")
            anim_done = true
            
        
func go_to_next_scene():
    get_tree().change_scene("res://scenes/GameScene.tscn")

    
    