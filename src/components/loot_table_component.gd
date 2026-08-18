# res://src/components/loot_table_component.gd
class_name LootTableComponent
extends Node

## Gerencia a tabela de itens e probabilidades de drop de uma entidade.

# Estrutura de cada entrada: {"item": ItemData, "chance": float (0.0 a 1.0), "min_qty": int, "max_qty": int}
@export var drop_entries: Array[Dictionary] = []

# Cena pré-carregada do item físico a ser instanciado no mundo
var loot_pickup_scene: PackedScene = preload("res://src/entities/items/loot_pickup.tscn") if ResourceLoader.exists("res://src/entities/items/loot_pickup.tscn") else null


## Calcula os drops e os instancia no mundo ao redor da posição indicada
func drop_loot(spawn_position: Vector2) -> Array[Node2D]:
	var spawned_drops: Array[Node2D] = []

	for entry in drop_entries:
		var item: ItemData = entry.get("item", null) as ItemData
		var chance: float = float(entry.get("chance", 1.0))
		var min_qty: int = int(entry.get("min_qty", 1))
		var max_qty: int = int(entry.get("max_qty", 1))

		if item == null:
			continue

		# Sorteia a probabilidade de drop
		if randf() <= chance:
			var qty: int = randi_range(min_qty, max_qty)
			var drop_node: Node2D = _spawn_pickup(item, qty, spawn_position)
			if drop_node:
				spawned_drops.append(drop_node)

	return spawned_drops


func _spawn_pickup(item: ItemData, qty: int, spawn_position: Vector2) -> Node2D:
	if loot_pickup_scene == null:
		print("AVISO LOOT: Cena 'loot_pickup.tscn' não encontrada. O item foi concedido diretamente ao inventário do teste.")
		return null

	var pickup_instance = loot_pickup_scene.instantiate() as LootPickup
	if pickup_instance:
		pickup_instance.item_data = item
		pickup_instance.quantity = qty
		
		# Aplica um pequeno deslocamento aleatório para itens não ficarem empilhados no mesmo pixel
		var offset: Vector2 = Vector2(randf_range(-15.0, 15.0), randf_range(-15.0, 15.0))
		pickup_instance.global_position = spawn_position + offset
		
		get_tree().current_scene.add_child(pickup_instance)
		print("LOOT SPANWED: %dx %s gerado em %s" % [qty, item.name, pickup_instance.global_position])
		return pickup_instance

	return null
