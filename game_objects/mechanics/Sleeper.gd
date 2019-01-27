extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speaker_nearby = null

var speaker_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
var wakeup_timer = 0
func _physics_process(delta):

        if wakeup_timer > 0 and speaker_playing:
            print ("Timer going...")
            print(wakeup_timer)
            wakeup_timer = wakeup_timer - delta
            if wakeup_timer <= 0:
                _wake_up()

func _on_Area2D_area_entered(area):
    #print ("speaker in")  
    if area.get_parent().is_in_group("speaker"): 
        print ("speaker in")  
        wakeup_timer = 1
        speaker_nearby = area.get_parent()
        speaker_playing = area.get_parent().playing
#       body.collides_movable = self

func _wake_up():
    if(not $AnimationPlayer.is_playing()):
        $AnimationPlayer.play("fade-out")

func notify_music_start():
    speaker_playing = true
    
func notify_music_stop():
    speaker_playing = false


func _on_Area2D_area_exited(area):
    if area.get_parent() == speaker_nearby:
        speaker_nearby = null
    
    pass
    #if area.is_in_group("player"):    
 #      body.collides_movable = self



func _on_AnimationPlayer_animation_finished(anim_name):
    queue_free()
