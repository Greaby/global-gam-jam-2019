extends Node2D

export (bool) var is_bonus_stage = false

var timer_label
var trash_carried_label
var score_label
var stain_cleaned_label
var health_label

var trash_count = 0
var trash_in_dumpster = 0

var stains_count = 0
var stains_cleaned = 0

var secrets_found = 0
var secrets_count = 0

var current_door_for_fade = null

var level_complete = false
var level_lost = false

var current_level_number

var canvasLayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    timer_label = $CanvasLayer/HUD/Panel/HBoxContainer/TimerLabel
    trash_carried_label = $CanvasLayer/HUD/Panel/HBoxContainer/TrashCountLabel
    stain_cleaned_label = $CanvasLayer/HUD/Panel/HBoxContainer/StainCountLabel
    score_label = $CanvasLayer/HUD/Panel/HBoxContainer/ScoreLabel
    health_label = $CanvasLayer/HUD/Panel/HBoxContainer/HealthLabel
    canvasLayer = $CanvasLayer
    
    current_level_number = GameSingleton.current_level
    
    if is_bonus_stage:
        $CanvasLayer.show_bonus_stage()
    
    GameSingleton.play_overworld_music()
    GameSingleton.stop_title_music()
    
    $Player.init_score(GameSingleton.current_score)
    $Player.current_lives = GameSingleton.current_lives
    $CanvasLayer.animate_start_panel(current_level_number, GameSingleton.current_lives)
    
    spawn_trash()
    count_trash()
    update_stain_stats()
    update_trash_stats()
    
func update_trash_stats():
    update_stats(trash_in_dumpster, trash_count)
    

func count_trash():
    for item in $Collectibles.get_children():
        if item.is_in_group("trash_item"):
            trash_count += 1
        if item.is_in_group("stain_item"):
            stains_count += 1
        if item.is_in_group("secret_item"):
            secrets_count += 1
        
    for item in $Mechanics.get_children():
        if item.is_in_group("stain_item"):
            stains_count += 1

func spawn_trash():
    var trash_ressource = load("res://game_objects/collectables/TrashPiece.tscn")
    
    for spawn in $Spawners.get_children():
        var trash = trash_ressource.instance()
        trash.trash_type = randi() % 4
        trash.position = spawn.position
        $Collectibles.add_child(trash)

func update_stats(trash_carried, trash_carried_max):
    
    var text_to_show = str(trash_carried) + "/" + str(trash_carried_max)
    trash_carried_label.text = text_to_show
    
    check_level_completion()
    

func update_stain_stats():
    var text_to_show = str(stains_cleaned) + "/" + str(stains_count)
    stain_cleaned_label.text = text_to_show
    
    check_level_completion()
    
func update_score(score):
    var text_to_show = str(score).pad_zeros(8)
    score_label.text = text_to_show
    
func update_health(health):
    var texts = ["---", "--*", "-**", "***"]
    health_label.text = texts[health]
    
func notify_trash_deposited(count):
    trash_in_dumpster += count
    update_trash_stats()
    

func notify_stain_cleaned(count):
    stains_cleaned += count
    update_stain_stats()
    
func notify_secret_found():
    secrets_found += 1

func notify_player_death():
    player_died()

func _physics_process(delta):
    var time_left = int($Timer.time_left) 
    $CanvasLayer/HUD/Panel/HBoxContainer/CarProgress.set_timeleft(time_left, $Timer.get_wait_time())
    timer_label.text = str(time_left).pad_zeros(3)
 
func delay_if_possible():
    var time_left = int($Timer.time_left) 
    timer_label.text = str(time_left).pad_zeros(3)
    if ($Timer.time_left < 20 and !level_complete):
        var rem_time =  $Timer.time_left + 10
        $Timer.stop()
        $Timer.start(rem_time)
        
        $CanvasLayer/HUD/WarningPanel.visible = true
        var text = ""
        randomize()
        var rnd = randi()%8
        if rnd == 0:
            text = "BONUS TIME! Mom has forgot her purse in the car!"
        elif rnd == 1:
            text = "BONUS TIME! Dad is talking to the neighbours!"
        elif rnd == 2:
            text = "BONUS TIME! Jehovah's Witnesses stoped your parents"
        elif rnd == 3:
            text = "BONUS TIME! Mom got kidnaped by aliens"
        elif rnd == 4:
            text = "BONUS TIME! Dad run over your cat"
        elif rnd == 5:
            text = "BONUS TIME! Mom slipped on a banana peel"
        else:
            text = "BONUS TIME! Parents went to supermarket"
                            
        $CanvasLayer/HUD/WarningPanel/WarningLabel.text = text
        if not $CanvasLayer/HUD/WarningPanel/WarningLabel/WarningAnimationPlayer.is_playing():            
            $CanvasLayer/HUD/WarningPanel/WarningLabel/WarningAnimationPlayer.play("blinking")  

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

func check_level_completion():
    
    #To test level complete quickly
    #if trash_in_dumpster == 1 or stains_cleaned == 1:
    if trash_in_dumpster == trash_count and stains_cleaned == stains_count:
        level_complete()
        #level_lost()
        
func level_complete():
    level_complete = true
    GameSingleton.stop_overworld_music()
    $Player.move_enabled = false
    $Timer.set_paused(true)
    var time_bonus = int($Timer.time_left) * 10
    $CanvasLayer.show_level_complete(time_bonus, secrets_found, secrets_count)
    $Player.score_points_no_popup(time_bonus)
    #Save score
    GameSingleton.current_score = $Player.current_score
    
func level_lost():
    level_lost = true
    GameSingleton.stop_overworld_music()
    $Player.move_enabled = false
    $Timer.set_paused(true)
    $CanvasLayer.show_level_lost(false)
    #Save score
    GameSingleton.current_score = $Player.current_score
    GameSingleton.current_lives = $Player.current_lives - 1
    
func player_died():
    level_lost = true
    GameSingleton.stop_overworld_music()
    $Player.move_enabled = false
    $Timer.set_paused(true)
    $CanvasLayer.show_level_lost(true)
    #Save score
    GameSingleton.current_score = $Player.current_score
    GameSingleton.current_lives = $Player.current_lives - 1


func _on_CanvasLayer_fade_finished():
    current_door_for_fade.notify_warp_pre_fade_ended()
    
func _input(event):
    if event.is_action_pressed("ui_accept"):
        if level_complete:
            next_level()
        if level_lost:
            if GameSingleton.current_lives == -1:
                game_over()
            else:
                restart_level()
            
func next_level():
    GameSingleton.current_level += 1
    restart_level()
    
func game_over():
    get_tree().change_scene("res://scenes/GameOver.tscn")
        
func restart_level():
    if GameSingleton.current_level == 1:
        get_tree().change_scene("res://scenes/GameSceneLevel1.tscn")
    elif GameSingleton.current_level == 2:
        get_tree().change_scene("res://scenes/GameSceneLevel2.tscn")
    elif GameSingleton.current_level == 3:
        get_tree().change_scene("res://scenes/GameSceneLevel3.tscn")
    elif GameSingleton.current_level == 4:
        get_tree().change_scene("res://scenes/GameSceneLevel4.tscn")
    elif GameSingleton.current_level == 5:
        get_tree().change_scene("res://scenes/GameSceneLevel5.tscn")
    elif GameSingleton.current_level == 6:
        get_tree().change_scene("res://scenes/GameSceneLevel6.tscn")
    elif GameSingleton.current_level == 7:
        get_tree().change_scene("res://scenes/GameSceneLevel7.tscn")
    else:
        get_tree().change_scene("res://scenes/CreditScene.tscn")

func _on_Timer_timeout():
    if is_bonus_stage:
        level_complete()
    else:
        level_lost()
