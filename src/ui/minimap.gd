# res://src/ui/minimap.gd
class_name Minimap
extends SubViewportContainer

@onready var sub_viewport: SubViewport = $SubViewport
@onready var minimap_camera: Camera2D = $SubViewport/MinimapCamera

var target_player: Node2D = null

func _ready() -> void:
	sub_viewport.gui_disable_input = true
	sub_viewport.size = Vector2i(150, 150)
	
	# Define a máscara de renderização do minimapa estritamente para a Camada 1 (Bit 1)
	# Ignora Camada 2 onde os textos e elementos visuais de UI do mundo residem
	sub_viewport.canvas_cull_mask = 1
	
	# Ajusta o Zoom da câmera para ter visão ampla do cenário
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
