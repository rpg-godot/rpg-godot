class_name AudioManager

static func load_music_player(name: String, path: String, bus: String, loop:=true):
	Core.emit_signal("msg", "Playing " + name + " on bus " + bus + "...", Log.INFO, "audio_manager")
	var player = AudioStreamPlayer.new()
	player.name = name + "MusicPlayer"
	
	var node
	if Core.get_parent().has_node(name + "MusicPlayer"):
		node = Core.get_parent().get_node(name + "MusicPlayer")
	else:
		node = Node.new()
		node.name = name + "MusicPlayer"
		Core.get_parent().call_deferred("add_child", node)
	
	node.add_child(player)
	var music = load("res://Assets/Sounds/" + path)
	music.loop = loop
	player.bus = bus
	player.stream = music
	player.play()
	
	yield(player, "finished")
	player.queue_free()
