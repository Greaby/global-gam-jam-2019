extends KinematicBody2D

var PopText = preload("res://game_objects/fx/TextPop.tscn")

var CARRY_OFFSET_TOP = 30

var current_interactor = null

const UP = Vector2(0, -1)

var trash_handled = 0
var trash_max = 5

var stats_not_yet_shown = true

var collides_movable = null
var collected_object = null

var collides_trashcan = null


var put_down_distance = 0

var current_door = null


onready var anim = $anim

const MAX_GRAVITY = 400
export (int) var gravity = 18
export (int) var speed = 200
export (int) var jump_speed = 400

enum states {IDLE, WALK, JUMP, FALL}
var state

var velocity = Vector2()
var input_direction = Vector2()

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
	update_direction()
	apply_gravity()

	match state:
		states.IDLE:
			if input_direction.x:
				_change_state(states.WALK)
		states.WALK:
			if input_direction.x == 0:
				_change_state(states.IDLE)
		states.JUMP:
			if is_on_floor():
				_change_state(states.IDLE)

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
    current_door.enter_door(self)

func move():
    velocity.x = input_direction.x * speed
    velocity = move_and_slide(velocity, Vector2(0, -1))
    if collected_object:
        var new_pos = self.position
        put_down_distance = new_pos.y - collected_object.position.y  + (CARRY_OFFSET_TOP /2)
        new_pos.y = new_pos.y - CARRY_OFFSET_TOP
    
        collected_object.position = new_pos            
    
func _unhandled_input(event):
     if event is InputEventKey:
        # Collecting an object
        if event.pressed and event.scancode == KEY_F and collides_movable and collected_object == null and !collides_trashcan:
            #collected_object = collides_movable.collider
            collected_object = collides_movable
            print ("collecting")
            
        # Dropping object to trashCan    
        elif event.pressed and event.scancode == KEY_F and collected_object and collides_trashcan:            
            if collides_trashcan.can_add_trash():
                print ("dropping")
                collected_object.delete()
                collected_object = null
                collides_trashcan.add_trash(1)
                $emptyTrashSound.play()      
                #pop_text_on_obj(trash_container, "THROW TRASH")
                
        # Picking up trashcan if its full
        elif event.pressed and event.scancode == KEY_F and collected_object == null and collides_trashcan:
            #print ("trying to pickup")
            
            if !collides_trashcan.can_add_trash():
                print ("trying to pickup")
                collected_object = collides_trashcan
                put_down_distance = self.position.y - collected_object.position.y  + (CARRY_OFFSET_TOP /2)
                
        # Dropping object on the ground
        elif event.pressed and event.scancode == KEY_F and collected_object:            
            collected_object.position.y = collected_object.position.y + put_down_distance 
            collected_object = null
            if collides_trashcan:
                collides_trashcan
            
            
            

                
    
func set_current_interactor(interactor):
    current_interactor = interactor
    print("Interactor set: " + current_interactor.name)

func unset_current_interactor(interactor):
    if current_interactor == interactor:
        current_interactor = null
        print("Interactor unset")
        
func do_update_stats():
    owner.update_stats(trash_handled, trash_max)

        
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

func can_pick_up_trash():
    return trash_handled < trash_max
    
func goes_in_front_of_door(door):
    current_door = door
    
func no_more_in_front_of_door(door):
    if current_door == door:
        current_door = null

