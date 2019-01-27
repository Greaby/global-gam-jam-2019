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
