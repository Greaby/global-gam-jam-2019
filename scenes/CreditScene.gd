extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    GameSingleton.play_overworld_music()
    GameSingleton.stop_title_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _physics_process(delta):
    if not $HUD/AnimationPlayer.is_playing():
        $HUD/AnimationPlayer.play("MovingCar")
    if not $HUD/AnimationPlayer2.is_playing():
         $HUD/AnimationPlayer2.play("CarBump")

func _on_AnimationPlayer_animation_finished(anim_name):
    get_tree().change_scene("res://scenes/TitleScreen.tscn")
