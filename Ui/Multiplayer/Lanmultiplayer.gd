extends Node

var defult_port: int = 49152
var Player_ = preload("res://Player/Player.tscn")

func _ready() -> void:
	if GlobalVarables.port == 0:
		Host()
	elif GlobalVarables.port is int:
		if GlobalVarables.port > 0 and GlobalVarables.port < 65535:
			Join(GlobalVarables.port)
		else: print("Port out of range")
	else: print("Port Invalid input")

func port_check(lan_port: int):
	var check = null
	while check != OK:
		var peer = ENetMultiplayerPeer.new()
		check = peer.create_server(lan_port)
		if check != OK:
			peer.close()
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
	$"Allways open UI/Port Display".show()
	$"Allways open UI/Port Display".text = " Port: " + str(GlobalVarables.port)
	enet_peer.create_server(GlobalVarables.port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())

func Join(_port: int):
	enet_peer.create_client("localHost", GlobalVarables.port)
	$"Allways open UI/Port Display".show()
	$"Allways open UI/Port Display".text = " Port: " + str(GlobalVarables.port)	
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player_.instantiate()
	player.name = str(peer_id)
	add_child(player)
