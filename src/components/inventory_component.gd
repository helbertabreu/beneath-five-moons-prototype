# res://src/components/inventory_component.gd
class_name InventoryComponent
extends Node

@export var coins: int = 100 # Saldo inicial do jogador para testes

## Gerencia o inventário do jogador (adicionar, remover e consultar itens).

# Estrutura interna: { "item_id": { "data": ItemData, "quantity": int } }
var items: Dictionary = {}

func add_item(item: ItemData, amount: int = 1) -> void:
	if item == null:
		return
		
	if items.has(item.id):
		items[item.id]["quantity"] += amount
		# Garante que a referência do objeto não se perca
		items[item.id]["item"] = item 
	else:
		items[item.id] = {
			"item": item,
			"quantity": amount
		}
	print("INVENTÁRIO: Adicionado %dx %s. Total: %d" % [amount, item.name, items[item.id]["quantity"]])

func get_item_quantity(item_id: String) -> int:
	if items.has(item_id):
		return items[item_id]["quantity"]
	return 0

func add_coins(amount: int) -> void:
	coins += amount
	print("INVENTÁRIO: +%d Moedas. Saldo Atual: %d" % [amount, coins])
	
	# Dispara texto flutuante de moedas ganhas
	var parent_node: Node2D = get_parent() as Node2D
	if parent_node != null:
		var spawn_pos: Vector2 = parent_node.global_position + Vector2(0, -25)
		EventBus.floating_text_requested.emit("+%d Moedas" % amount, spawn_pos, Color.GOLD)

func remove_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		print("INVENTÁRIO: -%d Moedas. Saldo Atual: %d" % [amount, coins])
		
		# Dispara texto flutuante de moedas gastas
		var parent_node: Node2D = get_parent() as Node2D
		if parent_node != null:
			var spawn_pos: Vector2 = parent_node.global_position + Vector2(0, -25)
			EventBus.floating_text_requested.emit("-%d Moedas" % amount, spawn_pos, Color.CRIMSON)
			
		return true
		
	print("INVENTÁRIO: Moedas insuficientes! Saldo: %d, Necessário: %d" % [coins, amount])
	return false
	
### Remoção de itens
func remove_item(item_id: String, amount: int = 1) -> bool:
	if not items.has(item_id):
		print("INVENTÁRIO: Item %s não encontrado." % item_id)
		return false

	if items[item_id]["quantity"] >= amount:
		items[item_id]["quantity"] -= amount
		print("INVENTÁRIO: Removido %dx %s. Restante: %d" % [amount, item_id, items[item_id]["quantity"]])
		
		# Se zerar a quantidade, remove a chave do dicionário
		if items[item_id]["quantity"] <= 0:
			items.erase(item_id)
		return true

	print("INVENTÁRIO: Quantidade insuficiente de %s!" % item_id)
	return false
