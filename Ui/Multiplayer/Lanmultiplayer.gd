extends Node

var defult_port: int = 49152
var Player_ = preload("res://Player/Player.tscn")
var peer = NodeTunnelPeer.new()

func _ready() -> void:
	multiplayer.multiplayer_peer = peer
	$Node2D/Label2.show()
	peer.connect_to_relay("relay.nodetunnel.io", 9998)
	await peer.relay_connected
	$Node2D/Label2.hide()
	if GlobalVarables.port == 0:
		Host()
	elif GlobalVarables.port is String or GlobalVarables.port is int:
		Join(GlobalVarables.port)
	else: print("Port Invalid input")
	
func Host():
	$Node2D/Label3.show()
	peer.host()
	await peer.hosting
	$Node2D/Label3.hide()
	$Node2D.hide()
	$"Allways open UI/Pear Display".show()
	$"Allways open UI/Pear Display".text = "  Peer id: " + str(peer.online_id)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(peer.get_unique_id())

func Join(_port: int):
	$Node2D/Label4.show()
	peer.join(GlobalVarables.port)
	await peer.joined
	$Node2D/Label4.hide()
	$Node2D.hide()
	$"Allways open UI/Pear Display".show()
	$"Allways open UI/Pear Display".text = "  Peer id: " + str(peer.online_id)
	multiplayer.multiplayer_peer = peer

func add_player(peer_id):
	var player = Player_.instantiate()
	player.name = str(peer_id)
	add_child(player)
