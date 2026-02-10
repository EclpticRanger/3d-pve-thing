extends Node

var defult_port: int = 49152
var Player_ = preload("res://Player/Player.tscn")
var peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	if GlobalVarables.port is int:
		Join(GlobalVarables.port)
	elif GlobalVarables.port == "host":
		Host()
	else: print("Port Invalid input")

func port_check(efult_port):
	var port: int = efult_port
	var max_attempts: int = 10
	
	for i in range(max_attempts):
		var enet = ENetMultiplayerPeer.new()
		var error = enet.create_server(port, 2)
		
		if error == OK:
			enet.close()
			return port
		
		enet.close()
		port += 1
		print("Port %d in use, trying %d..." % [port - 1, port])
	
	print("Could not find available port after %d attempts" % max_attempts)
	return -1

func Host():
	peer.create_server(port_check(defult_port))
	multiplayer.multiplayer_peer = peer
	$Node2D.hide()
	#$"Allways open UI/Pear Display".show()
	GlobalVarables.port = defult_port
	DisplayServer.clipboard_set(str(GlobalVarables.port))
	#$"Allways open UI/Pear Display".text = "  Peer id: " + str(GlobalVarables.port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(peer.get_unique_id())

func Join(_port):
	peer.create_client(GlobalVarables.ip, _port)
	multiplayer.multiplayer_peer = peer
	$Node2D.hide()
	#$"Allways open UI/Pear Display".show()
	#$"Allways open UI/Pear Display".text = "  Peer id: " + str(GlobalVarables.port)
	multiplayer.multiplayer_peer = peer

func add_player(peer_id):
	if has_node(str(peer_id)):  # Check if player already exists
		return
	var player = Player_.instantiate()
	player.name = str(peer_id)
	add_child(player)

var mobs = preload("res://mob/mob.tscn")

func _on_timer_timeout() -> void:
	if not multiplayer.is_server(): return
	if GlobalVarables.Momber_spawns_per > 9:
		GlobalVarables.Momber_spawns_per = 9
	for i in range(GlobalVarables.Momber_spawns_per):
		print("mob spawn")
		var Mob = mobs.instantiate()
		add_child(Mob, true)

func _on_more_mob_timer_timeout() -> void:
	GlobalVarables.Momber_spawns_per += 1
