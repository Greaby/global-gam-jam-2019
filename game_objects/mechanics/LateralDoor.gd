extends Node2D

enum Direction {LEFT, RIGHT}
export (Direction) var direction

func _ready():
    if(direction == Direction.RIGHT):
        $Pivot.scale.x = -1

func _on_Area2D_body_entered(body):
    $Pivot/Open.show()
    $Pivot/Close.hide()

func _on_Area2D_body_exited(body):
    $Pivot/Close.show()
    $Pivot/Open.hide()
