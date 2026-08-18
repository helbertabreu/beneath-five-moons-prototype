# res://src/entities/npcs/npc_vendor.gd
class_name NPCVendor
extends StaticBody2D

## Representa um vendedor associado a uma facção local com Flutuação de Oferta e Demanda (GDD Bloco 4).

@export var vendor_name: String = "Marcão do Armazém"
@export var faction: FactionData
@export var item_to_sell: ItemData
@export var base_sell_price: int = 50
@export var base_buy_price: int = 20 # Preço base que o NPC paga ao jogador

# --- TASK-302: PARÂMETROS DE OFERTA E DEMANDA (GDD BLOCO 4) ---
@export var current_stock: int = 5     # Estoque atual do item principal no comerciante
@export var target_demand: int = 20    # Demanda ideal que o vilarejo precisa
@export var min_stock_threshold: int = 10 # Estoque mínimo de referência

# Estoque dinâmico para armazenar os itens comprados do jogador durante a sessão
var dynamic_stock: Array[ItemData] = []


func interact(player: PlayerController) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("open_vendor_window"):
		hud.open_vendor_window(self, player)
	else:
		print("DEBUG ERRO: Não foi possível abrir a janela do Comerciante pela HUD.")


## Compra item do comerciante aplicando Desconto por Reputação + Flutuação por Oferta/Demanda
func buy_item_from_vendor(player: PlayerController) -> void:
	if item_to_sell == null and dynamic_stock.is_empty():
		return
		
	var faction_id: String = faction.faction_id if faction else "vilarejo"
	var rep_multiplier: float = ReputationManager.get_price_multiplier(faction_id, faction) if ReputationManager.has_method("get_price_multiplier") else 1.0
	
	# TASK-302: Multiplicador de Escassez (GDD Bloco 4)
	var supply_demand_modifier: float = _get_supply_demand_modifier()
	
	# Preço Final de Compra
	var price: int = max(1, int(round(base_sell_price * rep_multiplier * supply_demand_modifier)))
	
	if player.inventory_component and player.inventory_component.remove_coins(price):
		var bought_item: ItemData = item_to_sell
		if bought_item == null and not dynamic_stock.is_empty():
			bought_item = dynamic_stock.pop_back()
			
		if bought_item != null:
			player.inventory_component.add_item(bought_item, 1)
			
			# Reduz o estoque do NPC ao vender para o jogador
			current_stock = max(0, current_stock - 1)
			
			var spawn_pos: Vector2 = player.global_position + Vector2(0, -45)
			EventBus.floating_text_requested.emit("+1 %s" % bought_item.name, spawn_pos, Color.LIGHT_GREEN)
			
			print("COMPRA CONCLUÍDA: Compra de %s por %d moedas! (Estoque atual: %d | Modificador E&D: %.2f)" % [bought_item.name, price, current_stock, supply_demand_modifier])


## Vende item para o comerciante aplicando Reputação + Flutuação de Saturação de Mercado
func sell_item_to_vendor(player: PlayerController, item: ItemData) -> void:
	if player == null or item == null or player.inventory_component == null:
		return
		
	var faction_id: String = faction.faction_id if faction else "vilarejo"
	var rep_multiplier: float = 1.0
	if ReputationManager != null and ReputationManager.has_method("get_price_multiplier"):
		rep_multiplier = ReputationManager.get_price_multiplier(faction_id, faction)
		
	# TASK-302: Modificador de Oferta e Demanda
	var supply_demand_modifier: float = _get_supply_demand_modifier()
	
	# Preço pago ao jogador (Aumenta com alta reputação e alta escassez do vilarejo)
	var payout: int = max(1, int(round(base_buy_price * (2.0 - rep_multiplier) * supply_demand_modifier)))
	
	var item_removed: bool = false
	if player.inventory_component.has_method("remove_item"):
		item_removed = player.inventory_component.remove_item(item.id, 1)
	elif "items" in player.inventory_component and item.id in player.inventory_component.items:
		var slot = player.inventory_component.items[item.id]
		if slot.get("quantity", 0) > 0:
			slot["quantity"] -= 1
			item_removed = true
			if slot["quantity"] <= 0:
				player.inventory_component.items.erase(item.id)

	if item_removed:
		player.inventory_component.add_coins(payout)
		dynamic_stock.append(item)
		
		# Aumenta o estoque do NPC ao receber o item
		current_stock += 1
		
		var spawn_pos: Vector2 = player.global_position + Vector2(0, -45)
		EventBus.floating_text_requested.emit("+%d Moedas" % payout, spawn_pos, Color.GOLD)
		
		print("VENDA CONCLUÍDA: Vendido %s por %d moedas. (Estoque atual do NPC: %d)" % [item.name, payout, current_stock])


## TASK-302: Calcula a razão de escassez/saturação do estoque conforme a fórmula do GDD Bloco 4
func _get_supply_demand_modifier() -> float:
	var threshold: float = float(max(1, min_stock_threshold))
	var ratio: float = 1.0 + ((target_demand - current_stock) / threshold)
	
	# Limita o modificador entre 0.3 (-70% do valor) e 2.5 (+150% do valor) para evitar inflação infinita
	return clampf(ratio, 0.3, 2.5)
