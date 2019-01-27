extends KinematicBody2D

var PopText = preload("res://game_objects/fx/TextPop.tscn")

onready var trash_bag = preload("res://game_objects/mechanics/TrashBag.tscn")

var CARRY_OFFSET_TOP = 30

var current_interactor = null

const UP = Vector2(0, -1)

var trash_handled = 0
var trash_max = 5

var stats_not_yet_shown = true

var collides_movable = null
var collected_object = null

var collides_trashcan = null

var collides_dumpster = null


var put_down_distance = 0

var current_door = null

var current_score = 0
var current_life = 3
var current_health = 3

var has_broom = false

var brooming = false
var active_broom_type = 0

onready var anim = $anim

const MAX_GRAVITY = 400
export (int) var gravity = 18
export (int) var speed = 200
export (int) var jump_speed = 400

enum states {IDLE, WALK, JUMP, FALL}
var state

var velocity = Vector2()
var input_direction = Vector2()

var move_enabled = true

var temp_invincible = false

func _ready():
    _change_state(states.IDLE)

func _change_state(new_state):
    match new_state:
        states.IDLE:
            anim.play("Idle")
        states.WALK:
            anim.play("Move")
        states.JUMP:
            anim.play("Jump")
            $jumpSound.play()
            velocity.y = -jump_speed

    state = new_state

func pickUpCoin():
    #get_tree().get_root().get_node("World").player_picked_coin()
    pass

func _process(delta):
    if stats_not_yet_shown:
        do_update_stats()
        stats_not_yet_shown = false

func _physics_process(delta):
    
    if not move_enabled:
        return
    
    update_direction()
    apply_gravity()
    
    if has_broom:
        
        var broom_type = collected_object.broom_type
        
        if Input.is_action_just_pressed("ui_clean"):
            collected_object.position.y = collected_object.position.y + put_down_distance 
            brooming = true   
            active_broom_type = broom_type
            collected_object.start_scrub()
            if broom_type == 0:
                $vacuumSound.play()      
            if broom_type == 1:
                $scrubSound.play()      
        if Input.is_action_just_released("ui_clean"):
            collected_object.position.y = collected_object.position.y - put_down_distance
            brooming = false
            collected_object.stop_scrub()
            if broom_type == 0:
                $vacuumSound.stop()
            if broom_type == 1:
                $scrubSound.stop()

    match state:
        states.IDLE:
            if input_direction.x:
                _change_state(states.WALK)
        states.WALK:
            if input_direction.x == 0:
                _change_state(states.IDLE)
        states.JUMP:
            if is_on_floor():
                $jumpLandingSound.play()
                _change_state(states.IDLE)

    if !brooming:
        move()

func update_direction():
    input_direction = Vector2()
    input_direction.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
    
    $Sprite.set_flip_h(input_direction.x < 0)

func apply_gravity():
    velocity.y += gravity
    if velocity.y >= MAX_GRAVITY:
        velocity.y = MAX_GRAVITY

func _input(event):
    if event.is_action_pressed("jump") and state in [states.IDLE, states.WALK]:
        return _change_state(states.JUMP)
   
    # Door enter 
    if event.is_action_pressed("ui_up") and current_door != null:
        process_door_enter()

func process_door_enter():
    move_enabled = false
    current_door.enter_door(self)
    $warpDoorSound.play()

func move():
    velocity.x = input_direction.x * speed
    velocity = move_and_slide(velocity, Vector2(0, -1))
    if collected_object and !brooming:
        var new_pos = self.position
        put_down_distance = new_pos.y - collected_object.position.y  + (CARRY_OFFSET_TOP /2)
        new_pos.y = new_pos.y - CARRY_OFFSET_TOP
    
        collected_object.position = new_pos      
        
    for i in range(get_slide_count()):
        var collision = get_slide_collision(i)
        var collider = collision.collider
        
        if collider.is_in_group("collectable_on_touch"):
            collider.collect(self)
    
func _unhandled_input(event):
     if event is InputEventKey:
        
        if not move_enabled:
            return
        
        # Collecting an object
        if event.pressed and event.scancode == KEY_F and collides_movable and collected_object == null and !collides_trashcan:
            #collected_object = collides_movable.collider                 
            collected_object = collides_movable
            if collected_object.is_in_group("trash_item"):
                if collected_object.trash_type == 3:
                    $pickupGlassSound.play()
                else:
                    $pickupMetalSound.play()
            elif collected_object.is_in_group("broom"): 
                print ("broom")                                
                has_broom = true
            print ("collecting")
            
        # Dropping object to trashCan    
        elif event.pressed and event.scancode == KEY_F and collected_object and collides_trashcan:
            if collected_object.is_in_group("trash_item"):        
                if collides_trashcan.can_add_trash():
                    print ("dropping")
                    collected_object.delete()
                    #pop_text_on_obj(collides_trashcan, "THROW TRASH")
                    collected_object = null
                    collides_trashcan.add_trash(1)
                    $emptyTrashSound.play()      
                    score_points(10)

                else:
                    pop_text_on_obj(collides_trashcan, "TRASH FULL")
                      
                    
        # Dropping trash bag to dumpster           
        elif event.pressed and event.scancode == KEY_F and collected_object and collides_dumpster: 
            if collected_object.is_in_group("trash_item") or collected_object.is_in_group("trash_bag"):   
            
                var items_emptied = 1
                
                if collected_object.is_in_group("trash_bag"):
                    items_emptied = collected_object.contents
                      
                $emptyTrashSound.play()
                collected_object.delete()
                collected_object = null   
                    
                # Bigger points for emptying full bags
                var points_table = [0, 10, 20, 30, 100] 
                    
                score_points(points_table[items_emptied])
                
                owner.notify_trash_deposited(items_emptied)
                
        # Picking up trashbag if can is full
        elif event.pressed and event.scancode == KEY_F and collected_object == null and collides_trashcan:
            #print ("trying to pickup")
            
            if collides_trashcan.contents > 0:
                 $pickupGlassSound.play()
                 $pickupMetalSound.play()
                 var bag = trash_bag.instance()
                 bag.contents = collides_trashcan.contents     
                 self.get_parent().add_child(bag)
                 collected_object = bag
                 collides_trashcan.empty_trash()
    
    
                #print ("trying to pickup")
                #collected_object = collides_trashcan
                #put_down_distance = self.position.y - collected_object.position.y  + (CARRY_OFFSET_TOP /2)
                
        # Dropping object on the ground
        elif event.pressed and event.scancode == KEY_F and collected_object:            
            collected_object.position.y = collected_object.position.y + put_down_distance 
            if collected_object.is_in_group("broom"): 
                has_broom = false
            collected_object = null
            if collides_trashcan:
                collides_trashcan
            
            
func notify_stain_cleaned():
    owner.notify_stain_cleaned(1)
    score_points(5)

func notify_death():
    owner.notify_player_death()
    
func set_current_interactor(interactor):
    current_interactor = interactor
    print("Interactor set: " + current_interactor.name)

func unset_current_interactor(interactor):
    if current_interactor == interactor:
        current_interactor = null
        print("Interactor unset")
        
func do_update_stats():
    owner.update_stats(trash_handled, trash_max)
    owner.update_health(current_health)

        
func do_pick_up_trash(trash_type):
    if trash_type == 3:
        $pickupGlassSound.play()
    else:
        $pickupMetalSound.play()
    trash_handled += 1
    do_update_stats()
    
func do_drop_trash(trash_container):
    if trash_handled > 0:
        $emptyTrashSound.play()
        trash_container.add_trash(trash_handled)
        trash_handled = 0
        pop_text_on_obj(trash_container, "THROW TRASH")
    do_update_stats()


func pop_text_on_obj(node, text):
    var popTextInstance = PopText.instance()
    get_parent().add_child(popTextInstance)
    popTextInstance.set_text(text)
    popTextInstance.rect_position = node.position
    pass
    
    
func pop_text_on_self(text):
    var popTextInstance = PopText.instance()
    get_parent().add_child(popTextInstance)
    popTextInstance.set_text(text)
    popTextInstance.rect_position = position
    pass

func score_points(points):
    current_score += points
    owner.update_score(current_score)
    pop_text_on_self(str(points))
    
func score_points_no_popup(points):
    current_score += points
    owner.update_score(current_score)
    
func init_score(points):
    current_score = points
    owner.update_score(current_score)
    

func do_collect_item(score):
    $collectSecretItemSound.play()
    score_points(score)

func can_pick_up_trash():
    return trash_handled < trash_max
    
func goes_in_front_of_door(door):
    current_door = door
    
func no_more_in_front_of_door(door):
    if current_door == door:
        current_door = null

func cause_damage():
    if not temp_invincible:
        decrease_health()
        if current_health > 0:
            temp_invincible = true
            $DamageInvincibilityTimer.start()
            $DamageAnim.play("temp_invincible")

func _on_DamageInvincibilityTimer_timeout():
    temp_invincible = false
    $DamageAnim.stop(true)
    $Sprite.visible = true

func decrease_health():
    if current_health > 0:
        current_health -= 1
        $hurtSound.play()
    owner.update_health(current_health)
    if current_health == 0:
        notify_death()
        
func replenish_health():
    current_health = 3
    pop_text_on_self("HEALED")
    $collectHealingSound.play()
    owner.update_health(current_health)
    
