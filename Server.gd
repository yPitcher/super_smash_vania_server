extends Node

var ENet = NetworkedMultiplayerENet.new()

var port : int = 42069
#Número máximo de conexões simultâneas
var max_jogadores : int = 2

var players = {}
var self_data = { id="", position=Vector2(300,60) }

const SPEED = 300

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
	
	
# <remote> é uma keyword para indicar que a função é executada remotamente,
# ou seja, um cliente pode chamar esta função.
# Geralmente é utilizada em conjunto da função rpc_id(...)

# <sync> é outra keyword bem utilizada para sincronizar os clientes com o servidor.
# Geralmente é utilizada em conjunto da função rpc(...)
remote func _get_player_pos(var motion, var direction):
	
	motion.x = direction * SPEED
	
	var sender_id = get_tree().get_rpc_sender_id()
	rpc_id(sender_id, "_get_player_pos", motion, direction)
	print('Enviando [', motion, '] para o cliente [', sender_id,']')
