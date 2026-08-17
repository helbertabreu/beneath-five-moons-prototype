# res://src/ui/hud/minimap.gd
class_name Minimap
extends SubViewportContainer

@onready var sub_viewport: SubViewport = $SubViewport
@onready var minimap_camera: Camera2D = $SubViewport/MinimapCamera

var target_player: Node2D = null

func _ready() -> void:
	sub_viewport.gui_disable_input = true
	sub_viewport.size = Vector2i(150, 150)
	
	# No Godot 4, canvas_cull_mask fica no SubViewport
	# Valor 1 = Desenha a Camada 1 do Canvas (Mundo/Cenário)
	# Valor 3 (1 + 2) = Desenha Camada 1 + Camada 2 (Ícones do Minimapa)
	sub_viewport.canvas_cull_mask = 1
	
	# Ajusta o Zoom da câmera para dar mais visão do entorno
	minimap_camera.zoom = Vector2(0.5, 0.5)
	
	call_deferred("_setup_world")

func _setup_world() -> void:
	var current_scene = get_tree().current_scene
	if current_scene != null and current_scene.get_world_2d() != null:
		sub_viewport.world_2d = current_scene.get_world_2d()

func _process(_delta: float) -> void:
	if target_player == null:
		_find_player()
		return
		
	minimap_camera.global_position = target_player.global_position

func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		target_player = players[0] as Node2D
