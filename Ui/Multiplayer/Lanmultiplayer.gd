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
	
func Host():
	peer.create_server(defult_port)
	multiplayer.multiplayer_peer = peer
	$Node2D.hide()
	$"Allways open UI/Pear Display".show()
	GlobalVarables.port = defult_port
	DisplayServer.clipboard_set(str(GlobalVarables.port))
	$"Allways open UI/Pear Display".text = "  Peer id: " + str(GlobalVarables.port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(peer.get_unique_id())

func Join(_port):
	peer.create_client("localhost", _port)
	multiplayer.multiplayer_peer = peer
	$Node2D.hide()
	$"Allways open UI/Pear Display".show()
	$"Allways open UI/Pear Display".text = "  Peer id: " + str(GlobalVarables.port)
	multiplayer.multiplayer_peer = peer

func add_player(peer_id):
	var player = Player_.instantiate()
	player.name = str(peer_id)
	add_child(player)

var mobs = preload("res://mob/mob.tscn")
var Momber_spawns_per:int = 1
var mobs_spawned: int = 0

func _on_timer_timeout() -> void:
	if mobs_spawned < 20:
		for i in range(Momber_spawns_per):
			print("mob spawn")
			var Mob = mobs.instantiate()
			add_child(Mob)
			mobs_spawned += 1

func _on_more_mob_timer_timeout() -> void:
	Momber_spawns_per += 1
