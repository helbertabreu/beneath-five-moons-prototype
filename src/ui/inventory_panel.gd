# res://src/ui/inventory_panel.gd
class_name InventoryPanel
extends PanelContainer

@onready var coins_label: Label = $VBoxContainer/CoinsLabel
@onready var item_list: ItemList = $VBoxContainer/ItemList
@onready var close_button: Button = $VBoxContainer/CloseButton

var player_ref: PlayerController = null

func _ready() -> void:
	visible = false
	close_button.pressed.connect(hide)
	
	# Força os parâmetros de layout no Godot 4 via script
	item_list.custom_minimum_size = Vector2(350, 150)
	item_list.size_flags_vertical = Control.SIZE_EXPAND_FILL

func open(player: PlayerController) -> void:
	player_ref = player
	refresh_ui()
	visible = true

func refresh_ui() -> void:
	if player_ref == null or player_ref.inventory_component == null:
		return
		
	var inv = player_ref.inventory_component
	coins_label.text = "Moedas: %d" % inv.coins
	
	item_list.clear()
	
	for item_id in inv.items:
		var slot = inv.items[item_id]
		var item_data: ItemData = null
		var qty: int = 0
		
		if slot is Dictionary:
			qty = slot.get("quantity", 0)
			
			# Tenta buscar a referência do item em qualquer chave comum
			for key in ["item", "item_data", "resource", "data"]:
				if slot.has(key) and slot[key] is ItemData:
					item_data = slot[key] as ItemData
					break
			
			# Se o slot guardou apenas o ID sem o objeto, carrega o ItemData pelo ID
			if item_data == null:
				var path: String = "res://data/items/%s.tres" % item_id
				if ResourceLoader.exists(path):
					item_data = load(path) as ItemData
					
		elif slot is ItemData:
			item_data = slot as ItemData
			qty = 1

		# Se encontrou o item e a quantidade for maior que 0, exibe na interface
		if item_data != null and qty > 0:
			item_list.add_item("%s (x%d)" % [item_data.name, qty])
		elif qty > 0:
			# Fallback visual caso o arquivo .tres do item não seja encontrado
			item_list.add_item("%s (x%d)" % [item_id.capitalize(), qty])
