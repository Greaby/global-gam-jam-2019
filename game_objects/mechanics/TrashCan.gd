extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var contents = 0
var capacity = 4

# Called when the node enters the scene tree for the first time.
func _ready():
    for n in self.get_children():
        n.visible = false
        
    self.get_children()[0].visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area_body_entered(body):
    if body.is_in_group("player"):
        body.collides_trashcan = self   
            
func can_add_trash():
    return contents < capacity 

func add_trash(count):    
    contents += count
    
    for n in self.get_children():
        n.visible = false
        
    self.get_children()[contents-1].visible = true
    
    
func empty_trash():
    contents = 0
    for n in self.get_children():
        n.visible = false
        
    self.get_children()[0].visible = true
    
     

func _on_Area_body_exited(body):
    print ("exited")
    if body.is_in_group("player"):
        body.collides_trashcan = null   