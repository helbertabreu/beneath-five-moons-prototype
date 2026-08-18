# res://src/entities/items/loot_pickup.gd
class_name LootPickup
extends Area2D

## Entidade física de item caído no chão que pode ser coletada pelo Jogador.

@export var item_data: ItemData
@export var quantity: int = 1

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D


func _ready() -> void:
	add_to_group("resource_nodes") # Permite ser detectado pela busca contextual do PlayerController (tecla E)
	
	if item_data and sprite and item_data.icon:
		sprite.texture = item_data.icon


## Método chamado pelo PlayerController ao pressionar 'E' próximo ao item
func interact(player: CharacterBody2D) -> void:
	if item_data == null:
		queue_free()
		return

	var inventory: InventoryComponent = player.get_node_or_null("InventoryComponent") as InventoryComponent
	if inventory:
		inventory.add_item(item_data, quantity)
		print("LOOT: Jogador coletou %dx %s" % [quantity, item_data.name])
		
		# Dispara notificação de texto flutuante na tela
		EventBus.floating_text_requested.emit("+%d %s" % [quantity, item_data.name], global_position, Color.SPRING_GREEN)
		queue_free()
