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
	enet_peer.create_server(GlobalVarables.port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	# Add host's own player
	add_player(multiplayer.get_unique_id())

func Join(_port: int):
	enet_peer.create_client("localhost", _port)
	multiplayer.multiplayer_peer = enet_peer
	# Add client's own player
	add_player(multiplayer.get_unique_id())
	# Request all players from host
	rpc_id(1, "request_player_list")

func _on_peer_connected(id):
	# Tell all peers to add the new player
	rpc("add_player", id)
	# Tell the new peer to add all existing players (except itself)
	for peer in multiplayer.get_peers():
		if peer != id:
			rpc_id(id, "add_player", peer)

@rpc("any_peer")
func add_player(peer_id):
	var player = Player.instantiate()
	player.set_multiplayer_authority(peer_id)
	player.name = str(peer_id)
	add_child(player)

@rpc("authority")
func request_player_list():
	# Send all current peer IDs to the requesting client
	for peer in multiplayer.get_peers():
		rpc_id(multiplayer.get_remote_sender_id(), "add_player", peer)
