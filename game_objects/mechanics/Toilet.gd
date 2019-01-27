extends Node2D

var is_flushing = false

var already_flushed = false

func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):  
       body.collides_movable = self
       body.toilet_ref = self
    
    
    
func _on_Area2D_body_exited(body):
    if body.is_in_group("player"): 
       body.collides_movable = null
       body.toilet_ref = null

func flush(player):
    if not is_flushing:
        is_flushing = true
        $AudioStreamPlayer2D.play()
        if not already_flushed:
            already_flushed = true
            player.score_points(25)
            
        

func _on_AudioStreamPlayer2D_finished():
    is_flushing = false
