extends CharacterBody2D
@onready var fireball = preload("res://orange_fireball.tscn")
@onready var AnimatedSprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var player = get_node("/root/Game/Player")

func shoot():
	var fireball_temp = fireball.instantiate()
	var dir = (player.global_position - self.global_position).normalized()
	fireball_temp.direction = dir
	%ShootingPoint.add_child(fireball_temp)


func _on_timer_timeout() -> void: AnimatedSprite.play("Fireball")


func _on_animated_sprite_2d_animation_finished() -> void:
	shoot()
