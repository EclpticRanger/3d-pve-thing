extends Node
func _exit_tree() -> void:
	# Clean up multiplayer peer when leaving the scene
	if enet_peer:
		enet_peer.close()
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer = null
	# Optionally, free all player nodes
	for child in get_children():
		if child is CharacterBody3D:
			child.queue_free()

var defult_port: int = 49152
var Player = preload("res://Player/Player.tscn")

func _ready() -> void:
	if GlobalVarables.port == null:
		Host()
	elif GlobalVarables.port is int:
		if GlobalVarables.port > 0 and GlobalVarables.port < 65535:
			Join(GlobalVarables.port)
	else: get_tree().quit()

func port_check(lan_port: int):
	var check = null
	while check != OK:
		var peer = ENetMultiplayerPeer.new()
		check = peer.create_server(lan_port)
		if check != OK:
			if lan_port < 65535: # prevent infinite loop
				lan_port += 1
			else:
				get_tree().quit()
		else:
			peer.close()
			return lan_port

var enet_peer = ENetMultiplayerPeer.new()
func Host():
	GlobalVarables.port = port_check(defult_port)
	
	enet_peer.create_server(9999)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())

func Join(_port: int):
	enet_peer.create_client("localhost", GlobalVarables.port)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
