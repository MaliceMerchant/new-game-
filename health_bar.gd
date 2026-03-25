extends ProgressBar


func _ready():
	await get_tree().process_frame
	
	var player = get_tree().get_first_node_in_group("player")
	print ("found node",player)
	print("Script",player.get_script())
	
	if player:
		player.health_changed.connect(Callable(self, "update_health"))
		
		# ✅ Set initial value
		update_health(player.health)

func update_health(new_health):
	value = new_health
	print("fuck")
