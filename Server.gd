extends Node

var ENet = NetworkedMultiplayerENet.new()

var port : int = 3033
#Número máximo de conexões simultâneas
var max_jogadores : int = 2

func _ready():
	StartServer()
	
func StartServer():
	ENet.create_server(port,max_jogadores)
	get_tree().set_network_peer(ENet)
	print("Server ligado!")
	
	ENet.connect('peer_connected', self, '_conecta_jogador')
	ENet.connect('peer_disconnected', self, '_discon_jogador')
	
	
func _conecta_jogador(player_id):
	print(str(player_id), ' conectou')
	
func _discon_jogador(player_id):
	print(str(player_id), ' desconectou')
