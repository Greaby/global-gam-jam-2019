extends Node2D

var timer_label
var trash_carried_label
var score_label

var trash_count = 0
var trash_in_dumpster = 0

var current_door_for_fade = null

# Called when the node enters the scene tree for the first time.
func _ready():
    timer_label = $CanvasLayer/HUD/Panel/HBoxContainer/TimerLabel
    trash_carried_label = $CanvasLayer/HUD/Panel/HBoxContainer/TrashCountLabel
    score_label = $CanvasLayer/HUD/Panel/HBoxContainer/ScoreLabel
    
    spawn_trash()
    count_trash()
    update_trash_stats()
    
    print ("Counted " + str(trash_count))
    
func update_trash_stats():
    update_stats(trash_in_dumpster, trash_count)
    

func count_trash():
    for item in $Collectibles.get_children():
        if item.is_in_group("trash_item"):
            trash_count += 1

func spawn_trash():
    var trash_ressource = load("res://game_objects/collectables/TrashPiece.tscn")
    
    for spawn in $Spawners.get_children():
        var trash = trash_ressource.instance()
        trash.position = spawn.position
        $Collectibles.add_child(trash)

func update_stats(trash_carried, trash_carried_max):
    var text_to_show = str(trash_carried) + "/" + str(trash_carried_max)
    trash_carried_label.text = text_to_show
    
func update_score(score):
    var text_to_show = str(score).pad_zeros(8)
    score_label.text = text_to_show
    
func notify_trash_deposited(count):
    trash_in_dumpster += count
    update_trash_stats()

func _physics_process(delta):
    var time_left = int($Timer.time_left) 
    $CanvasLayer/HUD/Panel/HBoxContainer/CarProgress.set_timeleft(time_left, $Timer.get_wait_time())
    timer_label.text = str(time_left)
    if ($Timer.time_left < 295):
        #$CanvasLayer/HUD/ParentsAreClose.visible = true
        pass
    


func fade_for_door(door):
    current_door_for_fade = door
    $CanvasLayer/FadePanel.visible = true
    $CanvasLayer/FadeAnimation.play("fade_out")
    pass
    
    
func fade_out_for_door(door):
    current_door_for_fade = door
    $CanvasLayer/FadePanel.visible = true
    $CanvasLayer/FadeAnimation.play("fade_in")
    pass

func _on_FadeAnimation_animation_finished(anim_name):
    if anim_name == "fade_out":
        current_door_for_fade.notify_warp_pre_fade_ended()
    if anim_name == "fade_in":
        $CanvasLayer/FadePanel.visible = false
