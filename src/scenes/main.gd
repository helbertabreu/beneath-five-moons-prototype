extends Node

## Gerencia a cena principal do protótipo sandbox (Main.tscn).
## Responsável por vincular o jogador aos sistemas globais no início da execução.

@onready var player: CharacterBody2D = null

func _ready() -> void:
	_setup_main_player()

## Localiza e inicializa o jogador de forma segura utilizando o grupo 'player'
func _setup_main_player() -> void:
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0] as CharacterBody2D
	else:
		# Fallback defensivo buscando na raiz ou subnós caso o grupo não esteja atribuído
		player = get_node_or_null("Player") as CharacterBody2D
