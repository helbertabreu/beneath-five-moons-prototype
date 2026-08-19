class_name ResourceNode
extends Area2D
## Representa um nó de recurso natural (mina, árvore, planta) que pode ser coletado via ActionSystem.

@export var resource_id: String = "wood_node"
@export var drop_table: DropTableData
@export var action_time_cost: int = 15
@export var energy_cost: float = 10.0
@export var hunger_cost: float = 2.0

@onready var loot_component: LootTableComponent = $LootTableComponent as LootTableComponent

func _ready() -> void:
	if loot_component != null and drop_table != null:
		loot_component.drop_table = drop_table

## Interface de interação do nó com o jogador.
func interact(actor: Node) -> void:
	var action = GameAction.new("harvest_resource", action_time_cost, energy_cost, hunger_cost)
	var success: bool = ActionSystem.execute_action(action, actor)
	
	if success:
		_harvest(actor)

func _harvest(actor: Node) -> void:
	var loot: Array[Dictionary] = []
	if loot_component != null:
		loot = loot_component.generate_loot()
	elif drop_table != null:
		loot = DropSystem.evaluate_drop_table(drop_table)
		
	for item in loot:
		if EventBus != null:
			EventBus.emit_signal("item_obtained", item["item_id"], item["amount"])
			
	if EventBus != null:
		EventBus.emit_signal("resource_depleted", resource_id)
		
	queue_free()
