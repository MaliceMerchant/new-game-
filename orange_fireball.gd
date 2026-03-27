extends Node2D
var speed = 300
var direction = Vector2(1,0)
func _on_hit_box_body_entered(body):
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(10,1.0)
		queue_free()

func _process(delta):
	position += speed * delta * direction
	
