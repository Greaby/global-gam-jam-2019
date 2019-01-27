extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var image_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    #GameSingleton.play_title_music()
    #GameSingleton.stop_overworld_music()

    $AnimationPlayer.play("swap")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _input(event):
    
    if event.is_action_pressed("ui_accept"):
        show_next_page()
            
func show_next_page():
    image_index += 1
    
    $AnimationPlayer.play("swap")
    
    
func anim_has_reached_page_change():
    show_page()
            
func show_page():
    if image_index == 0:
        $Label01.visible = true
        $Label02.visible = false
        $Image01.visible = true
        $Image02.visible = false
    elif image_index == 1:
        $Label01.visible = false
        $Label02.visible = true
        $Image01.visible = false
        $Image02.visible = true
    elif image_index == 2:
        go_to_next_scene()
            
func go_to_next_scene():
    GameSingleton.current_level = 1
    GameSingleton.current_score = 0
    get_tree().change_scene("res://scenes/GameScene.tscn")

    
    