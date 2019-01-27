extends Node2D

var playing = false

var sleeper_nearby = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):    
       body.collides_movable = self
    
    
func _on_Area2D_body_exited(body):
    if body.is_in_group("player"):    
       body.collides_movable = null
    
func play_music():
    $AnimationPlayer.play("rave")
    playing = true
    GameSingleton.att_lvl_music_volume()
    $MusicLoop.play()
    if sleeper_nearby != null:
        sleeper_nearby.notify_music_start()
    
func stop_music():
    $AnimationPlayer.play("off")
    playing = false
    GameSingleton.stop_att_lvl_music_volume()
    $MusicLoop.stop()
    if sleeper_nearby != null:
        sleeper_nearby.notify_music_stop()
    
func assign_sleeper(sleeper):
    sleeper_nearby = sleeper
    
func unassign_sleeper(sleeper):
    if sleeper_nearby == sleeper:
        sleeper_nearby = null
        
func notify_player_takes():
    $Timer.stop()
    if playing:
        GameSingleton.att_lvl_music_volume()
        $MusicLoop.play()
    

func notify_player_puts_back():
    $Timer.start()
        



func _on_Timer_timeout():
    if playing:
        GameSingleton.stop_att_lvl_music_volume()
        $MusicLoop.stop()
