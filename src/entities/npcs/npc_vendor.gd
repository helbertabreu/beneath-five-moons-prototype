# res://src/entities/npcs/npc_vendor.gd
class_name NPCVendor
extends StaticBody2D

## Representa um vendedor associado a uma facção local.

@export var vendor_name: String = "Marcão do Armazém"
@export var faction: FactionData
@export var item_to_sell: ItemData
@export var base_sell_price: int = 50
@export var base_buy_price: int = 20 # Preço base que o NPC paga ao jogador

# Estoque dinâmico para armazenar os itens comprados do jogador durante a sessão
var dynamic_stock: Array[ItemData] = []


func interact(player: PlayerController) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("open_vendor_window"):
		hud.open_vendor_window(self, player)
	else:
		print("DEBUG ERRO: Não foi possível abrir a janela do Comerciante pela HUD.")


func buy_item_from_vendor(player: PlayerController) -> void:
	if item_to_sell == null and dynamic_stock.is_empty():
		return
		
	var faction_id: String = faction.faction_id if faction else "vilarejo"
	var multiplier: float = ReputationManager.get_price_multiplier(faction_id, faction) if ReputationManager.has_method("get_price_multiplier") else 1.0
	var price: int = int(base_sell_price * multiplier)
	
	if player.inventory_component and player.inventory_component.remove_coins(price):
		# Prioriza vender o item base; se não houver, pega do estoque dinâmico
		var bought_item: ItemData = item_to_sell
		if bought_item == null and not dynamic_stock.is_empty():
			bought_item = dynamic_stock.pop_back()
			
		if bought_item != null:
			player.inventory_component.add_item(bought_item, 1)
			
			# Dispara texto flutuante
			var spawn_pos: Vector2 = player.global_position + Vector2(0, -45)
			EventBus.floating_text_requested.emit("+1 %s" % bought_item.name, spawn_pos, Color.LIGHT_GREEN)
			
			print("COMPRA CONCLUÍDA: Você comprou %s por %d moedas!" % [bought_item.name, price])


func sell_item_to_vendor(player: PlayerController, item: ItemData) -> void:
	if player == null or item == null or player.inventory_component == null:
		return
		
	# 1. Extrai o ID da facção a partir do Resource FactionData
	var faction_id: String = faction.faction_id if faction else "vilarejo"
		
	# 2. Calcula o valor pago utilizando o ReputationManager do projeto
	var multiplier: float = 1.0
	if ReputationManager != null and ReputationManager.has_method("get_price_multiplier"):
		multiplier = ReputationManager.get_price_multiplier(faction_id, faction)
		
	# Preço final ajustado (vender com alta reputação gera mais moedas)
	var payout: int = max(1, int(round(base_buy_price * (2.0 - multiplier))))
	
	# 3. Remove o item passando o ID (String) exigido pelo InventoryComponent
	var item_removed: bool = false
	
	if player.inventory_component.has_method("remove_item"):
		# CORREÇÃO AQUI: Passando item.id (String) em vez da instância de ItemData
		item_removed = player.inventory_component.remove_item(item.id, 1)
	elif "items" in player.inventory_component and item.id in player.inventory_component.items:
		var slot = player.inventory_component.items[item.id]
		if slot.get("quantity", 0) > 0:
			slot["quantity"] -= 1
			item_removed = true
			if slot["quantity"] <= 0:
				player.inventory_component.items.erase(item.id)

	# 4. Credita o pagamento e armazena o item no estoque do NPC
	if item_removed:
		player.inventory_component.add_coins(payout)
		dynamic_stock.append(item)
		
		# Dispara texto flutuante de moedas recebidas
		var spawn_pos: Vector2 = player.global_position + Vector2(0, -45)
		EventBus.floating_text_requested.emit("+%d Moedas" % payout, spawn_pos, Color.GOLD)
		
		print("VENDA CONCLUÍDA: Vendido %s por %d moedas. Item mantido no estoque do NPC." % [item.name, payout])
