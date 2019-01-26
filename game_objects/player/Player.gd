extends KinematicBody2D

var PopText = preload("res://game_objects/fx/TextPop.tscn")

export var GRAVITY = 10
export var MAX_FALLING_SPEED = 800
export var MOVE_ACCEL = 10
export var MOVE_DECEL = 10
export var MOVE_MAX_SPEED = 120
export var JUMP_FORCE = 950
export var SPRING_FORCE = 380

export var COLLIDE_SIDE_DETECT = 10
export var AXIS_DEAD_ZONE = 0.3

var current_interactor = null

var motion = Vector2()

const UP = Vector2(0, -1)

var vspeed = 0

var last_anim = ""

var was_on_floor_last_time = false

var touching_left = false
var touching_right = false

var trash_handled = 0
var trash_max = 5

var stats_not_yet_shown = true

onready var anim = $anim


func _ready():
    pass

func pickUpCoin():
    #get_tree().get_root().get_node("World").player_picked_coin()
    pass
    
func _physics_process(delta):
    
    if stats_not_yet_shown:
        do_update_stats()
        stats_not_yet_shown = false
        
    var axis = Input.get_joy_axis(0,0)
    
    var right_input = Input.is_action_pressed("ui_right")
    var left_input = Input.is_action_pressed("ui_left")
    var jump_input = Input.is_action_just_pressed("ui_accept")
    var interact_input = Input.is_action_just_pressed("ui_select")
    
    
    var on_floor = false


    motion.y += GRAVITY
    
    if motion.y >= MAX_FALLING_SPEED:
        motion.y = MAX_FALLING_SPEED
        
        

    if right_input:
        motion.x += MOVE_ACCEL
    elif left_input:
        motion.x -= MOVE_ACCEL
    else:
        # Deceleration
        var dir = sign(motion.x)
        var dec = dir * -1 * MOVE_DECEL
        
        motion.x += dec
        
        if dir == 1 and motion.x < 0:
            motion.x = 0
        if dir == -1 and motion.x > 0:
            motion.x = 0
        
    if motion.x > MOVE_MAX_SPEED:
        motion.x = MOVE_MAX_SPEED
    elif motion.x < -MOVE_MAX_SPEED:
        motion.x = -MOVE_MAX_SPEED

    
    if interact_input and current_interactor != null:
        current_interactor.interact()

    
    # Wall side detection
    var collide_left = false
    var collide_right = false
                        
    var space_state = get_world_2d().direct_space_state
    var result = space_state.intersect_ray(Vector2(self.position.x, self.position.y), Vector2(self.position.x - COLLIDE_SIDE_DETECT, self.position.y), [self])
    if result:
        collide_left = true
        
    result = space_state.intersect_ray(Vector2(self.position.x, self.position.y), Vector2(self.position.x + COLLIDE_SIDE_DETECT, self.position.y), [self])
    if result:
        collide_right = true
        
    if collide_left != touching_left:
        touching_left = collide_left
        if (touching_left):
            print("Touch left wall")
        else:
            print("No more touch left wall")
    
        
    if collide_right != touching_right:
        touching_right = collide_right
        if (touching_right):
            print("Touch right wall")
        else:
            print("No more touch right wall")
            
            
            
    # Tile below feet detection
    if was_on_floor_last_time:
        pass
        var tile_detect_x = self.position.x
        var tile_detect_y = self.position.y + 20
        result = space_state.intersect_ray(Vector2(self.position.x, self.position.y), Vector2(tile_detect_x, tile_detect_y), [self])
        if result:
            #print ("Colliding below: " + result.collider.name)
            if result.collider.name == "tiles_main":
                #print ("Colliding with tiles")
                var tilemap = result.collider
                var tilepos = tilemap.world_to_map(Vector2(tile_detect_x - tilemap.position.x, tile_detect_y - tilemap.position.y))
                var tiletype = tilemap.get_cellv(tilepos)
                
                #print("Tile position " + str(tilepos.x) + "," + str(tilepos.y) + ", type " + str(tiletype))
                
                if tiletype == 14:
                    motion.y  = -SPRING_FORCE
                    $springSound.play()
            
    
    # Jump
    if was_on_floor_last_time:
        on_floor = true
        if jump_input:
            print("Jump from floor")
            motion.y  = -JUMP_FORCE
            $jumpSound.play()
    elif touching_left or touching_right:
        # Wall kick left
        if jump_input and left_input and touching_left:
            print("Wall kick left")
            motion.x = MOVE_MAX_SPEED
            motion.y = -JUMP_FORCE
            $wallKickSound.play()
        # Wall kick right  
        elif jump_input and right_input and touching_right:
            print("Wall kick left")
            motion.x = -MOVE_MAX_SPEED
            motion.y = -JUMP_FORCE
            $wallKickSound.play()

    var facing_dir = sign(motion.x)
    $Sprite.set_flip_h(facing_dir == -1)

    var new_anim = "Idle"
    if on_floor:
        if motion.x != 0:
            new_anim = "Move"
    else:
        new_anim = "Jump"
    
    if new_anim != last_anim:
        
        anim.play(new_anim)
        last_anim = new_anim    
    


    motion = move_and_slide(motion, UP)

    was_on_floor_last_time = is_on_floor()
    
    
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
    
