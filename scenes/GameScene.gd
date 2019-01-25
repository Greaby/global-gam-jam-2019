extends Node2D

var timer_label

# Called when the node enters the scene tree for the first time.
func _ready():
    timer_label = $HUD/Panel/TimerLabel
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _physics_process(delta):
    
    var time_left = int($Timer.time_left)    
    timer_label.text = str(time_left)
    
