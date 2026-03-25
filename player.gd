extends CharacterBody2D

@onready var AnimatedSprite : AnimatedSprite2D = %AnimatedSprite2D

var is_dashing = false
var dash_speed = 1000.0
var dash_direction = 0
var can_dash = true
var is_parrying = false
var parry_window = 0.2
signal health_changed(new_health)
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var can_take_damage : bool = true 


var health = 100.0

 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		can_dash = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AnimatedSprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walkleft", "walkright")
	if is_dashing:
		velocity.x = dash_direction * dash_speed
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			AnimatedSprite.play("walk")
		
		
				
				
		

	move_and_slide()
	
	
	if not is_on_floor():
		if velocity.y < 0:
			AnimatedSprite.play("jump")   # going up

	elif is_dashing:
		AnimatedSprite.play("run")

	elif direction != 0:
		AnimatedSprite.play("walk")

	else:
		AnimatedSprite.play("Idle")
	
	
	
	if Input.is_action_just_pressed("dash") and not is_dashing and can_dash:
		is_dashing = true
		can_dash = false
		dash_direction = direction if direction != 0 else 1
		if direction != 0:
			AnimatedSprite.flip_h
		%Timer.start()
		AnimatedSprite.play("run")
	
	if direction != 0:
		AnimatedSprite.flip_h = direction < 0
	
func _on_timer_timeout():
	is_dashing = false
	
	
func take_damage(damage_amt:float,invincible_time:float = 0.0,ignore_invincible:bool = false) :
	if not can_take_damage:
		if not ignore_invincible:
			return
		
		
	health -= damage_amt
	if invincible_time > 0.0:
		can_take_damage = false
		var invincible_tween = create_tween().set_trans(Tween.TRANS_SINE)
		invincible_tween.tween_property(%AnimatedSprite2D,"modulate:a",0.5,invincible_time/4.0)
		invincible_tween.chain().tween_property(%AnimatedSprite2D,"modulate:a",1.0,invincible_time/4.0)
		invincible_tween.chain().chain().tween_property(%AnimatedSprite2D,"modulate:a",0.5,invincible_time/4.0)
		invincible_tween.chain().chain().chain().tween_property(%AnimatedSprite2D,"modulate:a",1.0,invincible_time/4.0).finished.connect(func(): can_take_damage = true) 
	
	
func parry_flash():
		AnimatedSprite.modulate = Color(0, 1, 1)
		await get_tree().create_timer(0.1).timeout
		AnimatedSprite.modulate = Color(1, 1, 1)  # back to normal
	

func start_parry():
	if is_parrying:
		return
	
	is_parrying = true
	%ParryBox.monitoring = true
	
	parry_flash()  # your color effect
	
	await get_tree().create_timer(2.0).timeout
	
	%ParryBox.monitoring = false
	is_parrying = false
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("parry"):
		start_parry()
		
func heal(amount):
	health += amount
	health = clamp(health,0,100)
	emit_signal("health_changed", health)



func _on_parry_box_area_entered(_area: Area2D) -> void:
	if is_parrying:
		print("Parry Success")
		heal(10)
