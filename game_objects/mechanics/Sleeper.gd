extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
var wakeup_timer = 0
func _physics_process(delta):

        if wakeup_timer > 0:
            print ("dvdsvds")
            print(wakeup_timer)
            wakeup_timer = wakeup_timer - delta
            if wakeup_timer <= 0:
                _wake_up()

func _on_Area2D_area_entered(area):
    print ("speaker in")  
    if area.get_parent().is_in_group("speaker"): 
        print ("speaker in")  
        wakeup_timer = 1
#       body.collides_movable = self

func _wake_up():
    print ("waking up")



func _on_Area2D_area_exited(area):
    pass
    #if area.is_in_group("player"):    
 #      body.collides_movable = self

