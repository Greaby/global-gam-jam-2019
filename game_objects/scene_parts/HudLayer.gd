extends CanvasLayer


signal fade_finished
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass



func _on_FadeAnimation_animation_finished(anim_name):
    if anim_name == "fade_out":
        emit_signal("fade_finished")


func show_level_complete(time_bonus):
    $HUD/CenterPanel.visible = true
    var text_to_show = "CLEANING COMPLETE!\nTIME BONUS: " + str(time_bonus)
    $HUD/CenterPanel/CenterLabel.text = text_to_show


func animate_start_panel(level_number):
    $HUD/StartPanel.visible = true
    $HUD/StartPanel/StartLabel.text = "HOUSE " + str(level_number)
    $HUD/StartPanel/StartPanelAnimator.play("ready_intro")

func animation_show_ready(step):
    if step == 0:
        $HUD/StartPanel/StartLabel.text = "READY"
    if step == 1:
        $HUD/StartPanel/StartLabel.text = "SET"
    if step == 2:
        $HUD/StartPanel/StartLabel.text = "CLEAN"
    if step == 3:
        $HUD/StartPanel.visible = false
     