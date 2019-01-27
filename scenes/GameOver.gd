extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var anim_done = false
var play_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
    GameSingleton.play_title_music()
    GameSingleton.stop_overworld_music()
    $LabelScore.text = "SCORE: " + str(GameSingleton.current_score)

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
            if not play_done:
                $AudioStreamPlayer.play()
                $AnimationPlayer.play("press_start_fast")
                play_done = true
        else:
            #End frame
            $AnimationPlayer.seek(2, true)
            $AnimationPlayer.play("press_start")
            anim_done = true
            
func go_to_next_scene():
    GameSingleton.current_level = 1
    GameSingleton.current_score = 0
    GameSingleton.current_lives = 3
    get_tree().change_scene("res://scenes/TitleScreen.tscn")

    
    

func _on_AudioStreamPlayer_finished():
    go_to_next_scene()
