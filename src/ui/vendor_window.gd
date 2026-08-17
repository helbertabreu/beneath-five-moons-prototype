# res://src/ui/vendor_window.gd
class_name VendorWindow
extends PanelContainer

enum TradeMode { BUY, SELL }

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var reputation_label: Label = $VBoxContainer/ReputationLabel
@onready var item_list: ItemList = $VBoxContainer/ItemList
@onready var action_button: Button = $VBoxContainer/ActionButton
@onready var close_button: Button = $VBoxContainer/CloseButton

# Botões de alternância de modo
@onready var buy_mode_button: Button = $VBoxContainer/ModeContainer/BuyModeButton
@onready var sell_mode_button: Button = $VBoxContainer/ModeContainer/SellModeButton

@export var vendor_name: String = "Comerciante"
@export var faction_id: String = "vilarejo"
@export var base_sell_price: int = 50
@export var base_buy_price: int = 20
@export var item_to_sell: ItemData

var current_vendor: NPCVendor = null
var current_player: PlayerController = null
var current_mode: TradeMode = TradeMode.BUY

# Mapeamento do inventário do jogador no modo de venda
var player_sellable_items: Array[ItemData] = []


func _ready() -> void:
	visible = false
	close_button.pressed.connect(hide)
	action_button.pressed.connect(_on_action_button_pressed)
	
	if buy_mode_button and sell_mode_button:
		buy_mode_button.pressed.connect(func(): _switch_mode(TradeMode.BUY))
		sell_mode_button.pressed.connect(func(): _switch_mode(TradeMode.SELL))
	
	item_list.custom_minimum_size = Vector2(350, 180)
	item_list.size_flags_vertical = Control.SIZE_EXPAND_FILL


func _process(_delta: float) -> void:
	if not visible:
		return
		
	if current_vendor != null and current_player != null:
		var distance: float = current_player.global_position.distance_to(current_vendor.global_position)
		if distance > 100.0:
			hide()


func open(vendor: NPCVendor, player: PlayerController) -> void:
	current_vendor = vendor
	current_player = player
	current_mode = TradeMode.BUY
	
	title_label.text = vendor.vendor_name if "vendor_name" in vendor else "Comerciante"
	_update_reputation_status()
	_refresh_ui()
	visible = true


func _switch_mode(new_mode: TradeMode) -> void:
	current_mode = new_mode
	_refresh_ui()


func _update_reputation_status() -> void:
	# Correção: Acessa o Autoload diretamente sem passar pelo Engine.has_singleton
	if ReputationManager != null and ReputationManager.has_method("get_reputation"):
		var faction_id: String = current_vendor.faction_id if "faction_id" in current_vendor else "vilarejo"
		var rep_val: int = ReputationManager.get_reputation(faction_id)
		var rep_status: String = ReputationManager.get_reputation_level(faction_id)
		reputation_label.text = "Reputação: %s (%+d)" % [rep_status, rep_val]
	else:
		reputation_label.text = "Reputação: Neutro"


func _refresh_ui() -> void:
	item_list.clear()
	player_sellable_items.clear()
	_update_reputation_status()
	
	if current_mode == TradeMode.BUY:
		action_button.text = "Comprar Item"
		_refresh_buy_list()
	else:
		action_button.text = "Vender Item Selecionado"
		_refresh_sell_list()


func _refresh_buy_list() -> void:
	var items: Array = _get_vendor_items(current_vendor)
	
	if items.is_empty():
		item_list.add_item("O comerciante não possui itens para vender.")
		action_button.disabled = true
	else:
		action_button.disabled = false
		for item in items:
			if item != null:
				var item_name: String = item.name if "name" in item else "Item"
				var base_price: int = current_vendor.base_sell_price if "base_sell_price" in current_vendor else 50
				var final_price: int = _calculate_price_with_reputation(base_price, true)
				
				item_list.add_item("%s — Custo: %d Moedas" % [item_name, final_price])


func _refresh_sell_list() -> void:
	if current_player == null or current_player.inventory_component == null:
		return
		
	var inv: Dictionary = current_player.inventory_component.items
	
	for item_id in inv:
		var slot = inv[item_id]
		var qty: int = slot.get("quantity", 0)
		var item_data: ItemData = slot.get("item", null)
		
		if qty > 0 and item_data != null:
			player_sellable_items.append(item_data)
			var base_payout: int = current_vendor.base_buy_price if "base_buy_price" in current_vendor else 20
			var final_payout: int = _calculate_price_with_reputation(base_payout, false)
			
			item_list.add_item("%s (x%d) — Valor: %d Moedas cada" % [item_data.name, qty, final_payout])
			
	if player_sellable_items.is_empty():
		item_list.add_item("Você não possui itens no inventário para vender.")
		action_button.disabled = true
	else:
		action_button.disabled = false


func _on_action_button_pressed() -> void:
	var selected_items: PackedInt32Array = item_list.get_selected_items()
	if selected_items.is_empty():
		print("Nenhum item selecionado na lista.")
		return
		
	var index: int = selected_items[0]
	
	if current_mode == TradeMode.BUY:
		if current_vendor != null and current_vendor.has_method("buy_item_from_vendor"):
			current_vendor.buy_item_from_vendor(current_player)
	else:
		if index < player_sellable_items.size():
			var item_to_sell: ItemData = player_sellable_items[index]
			if current_vendor != null and current_vendor.has_method("sell_item_to_vendor"):
				current_vendor.sell_item_to_vendor(current_player, item_to_sell)
				
	_refresh_ui()


## Calcula o valor do item aplicando a curva de reputação (-100 a +100)
func _calculate_price_with_reputation(base_price: int, is_buying: bool) -> int:
	if ReputationManager == null or not ReputationManager.has_method("get_reputation"):
		return base_price
		
	var faction_id: String = current_vendor.faction_id if "faction_id" in current_vendor else "vilarejo"
	var rep: int = ReputationManager.get_reputation(faction_id)
	
	# Fórmula: Variação de -50% a +50% no valor com base na reputação
	var modifier: float = 1.0 - (float(rep) / 200.0)
	
	if is_buying:
		return max(1, int(round(base_price * modifier)))
	else:
		# Para venda, maior reputação = maior valor de venda (inverte o modificador)
		var sell_modifier: float = 1.0 + (float(rep) / 200.0)
		return max(1, int(round(base_price * sell_modifier)))


func _get_vendor_items(vendor: NPCVendor) -> Array:
	var result: Array = []
	if vendor != null:
		# 1. Item padrão configurado no Inspetor do NPC
		if "item_to_sell" in vendor and vendor.get("item_to_sell") != null:
			result.append(vendor.get("item_to_sell"))
			
		# 2. Itens do estoque dinâmico (revendidos pelo jogador nesta sessão)
		if "dynamic_stock" in vendor and vendor.dynamic_stock is Array:
			for item in vendor.dynamic_stock:
				if item != null:
					result.append(item)
				
	return result
