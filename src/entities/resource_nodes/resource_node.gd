class_name ResourceNode
extends StaticBody2D
## Entidade interativa do mundo responsável por fornecer recursos naturais via coleta.
##
## Representa árvores, minérios, plantas e poços. Integra-se ao ActionSystem
## para consumo atômico e ao DropSystem para distribuição de recompensas data-driven.

@export var resource_id: String = "RES-001"
@export var display_name: String = "Mina de Cobre"
@export var required_tool_type: String = "pickaxe"
@export var base_time_cost: int = 15
@export var base_energy_cost: float = 10.0
@export var base_hunger_cost: float = 2.0

@export var drop_table: DropTableData

@onready var interaction_area: Area2D = $InteractionArea as Area2D

var is_depleted: bool = false

func _ready() -> void:
	add_to_group("interactables")

## Interface pública invocada pelo PlayerController para executar a interação.
func interact(actor: Node) -> void:
	if is_depleted:
		if EventBus != null and EventBus.has_signal("floating_text_requested"):
			EventBus.floating_text_requested.emit("Recurso Exaurido", global_position, Color.GRAY)
		return

	_harvest_resource(actor)

## Processa a coleta validando custos no ActionSystem e sorteando saques no DropSystem.
func _harvest_resource(actor: Node) -> void:
	# Encapsula os custos da coleta na classe GameAction da Sprint 01
	var action = GameAction.new("harvest_" + resource_id, base_time_cost, base_energy_cost, base_hunger_cost)
	
	var success: bool = ActionSystem.execute_action(action, actor)
	if not success:
		return

	# Gera recompensas através do DropSystem desacoplado da Sprint 02
	if drop_table != null:
		var rewards: Array[Dictionary] = DropSystem.evaluate_drop_table(drop_table)
		for reward in rewards:
			if EventBus != null and EventBus.has_signal("item_obtained"):
				EventBus.emit_signal("item_obtained", reward["item_id"], reward["amount"])

	if EventBus != null and EventBus.has_signal("resource_depleted"):
		EventBus.emit_signal("resource_depleted", resource_id)

	# Atualiza estado para exaurido temporariamente
	is_depleted = true
	visible = false
	var col_shape = $CollisionShape2D as CollisionShape2D
	if col_shape != null:
		col_shape.set_deferred("disabled", true)
