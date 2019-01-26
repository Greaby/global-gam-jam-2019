extends Node2D

var timer_label
var trash_carried_label


# Called when the node enters the scene tree for the first time.
func _ready():
    timer_label = $CanvasLayer/HUD/Panel/HBoxContainer/TimerLabel
    trash_carried_label = $CanvasLayer/HUD/Panel/HBoxContainer/TrashCountLabel
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func update_stats(trash_carried, trash_carried_max):
    var text_to_show = str(trash_carried) + "/" + str(trash_carried_max)
    trash_carried_label.text = text_to_show


func _physics_process(delta):
    var time_left = int($Timer.time_left) 
    $CanvasLayer/HUD/Panel/HBoxContainer/CarProgress.set_timeleft(time_left, $Timer.get_wait_time())
    timer_label.text = str(time_left)
    if ($Timer.time_left < 295):
        $CanvasLayer/HUD/ParentsAreClose.visible = true
    
