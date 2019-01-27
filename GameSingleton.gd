extends Node

var current_level = 1
var current_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _input(event):
    if event is InputEventKey:
        if event.pressed:
            if event.scancode == KEY_F11:
                OS.window_fullscreen = !OS.window_fullscreen
                

func play_overworld_music():
    $Music/Overworld.play()
    
func stop_overworld_music():
    $Music/Overworld.stop()
    
    
func play_title_music():
    $Music/Title.play()
    
func stop_title_music():
    $Music/Title.stop()
    
func att_lvl_music_volume():
    $Music/Overworld.volume_db = -20
    pass
    
func stop_att_lvl_music_volume():
    $Music/Overworld.volume_db = -5
    pass





