# res://autoload/quest_manager.gd
extends Node

## Gerencia missões ativas e concluídas do jogador.

var active_quests: Dictionary = {} # quest_id: QuestData
var completed_quests: Array[String] = []


func accept_quest(quest: QuestData) -> void:
	if quest == null:
		return

	# TRAVA B02: Impede aceitar missões que já foram concluídas
	if is_quest_completed(quest.quest_id):
		print("QUEST BLOQUEADA: A missão '%s' já foi concluída anteriormente!" % quest.title)
		EventBus.notification_requested.emit("Esta missão já foi concluída!", Color.ORANGE_RED)
		return

	# Impede aceitar missões que já estão ativas no diário
	if is_quest_active(quest.quest_id):
		print("QUEST BLOQUEADA: A missão '%s' já está ativa no diário." % quest.title)
		EventBus.notification_requested.emit("Missão já está em andamento.", Color.GOLD)
		return

	active_quests[quest.quest_id] = quest
	print("QUEST ACEITA: '%s' adicionada ao Diário!" % quest.title)
	EventBus.notification_requested.emit("Nova Missão: %s" % quest.title, Color.CORNFLOWER_BLUE)


func complete_quest(quest_id: String, player: PlayerController) -> bool:
	# Trava defensiva se a missão já constar como concluída
	if is_quest_completed(quest_id):
		print("QUEST ERRO: Tentativa de reentregar a missão '%s' que já foi concluída!" % quest_id)
		return false

	if not is_quest_active(quest_id):
		print("QUEST FALHOU: Missão '%s' não está ativa." % quest_id)
		return false

	var quest: QuestData = active_quests[quest_id]

	# Valida se o jogador tem o item exigido no inventário
	if quest.required_item != null:
		var has_qty: int = player.inventory_component.get_item_quantity(quest.required_item.id)
		if has_qty < quest.required_amount:
			print("QUEST INCOMPLETA: Faltam itens no inventário para entregar a missão '%s'!" % quest.title)
			EventBus.notification_requested.emit("Itens insuficientes para concluir '%s'" % quest.title, Color.INDIAN_RED)
			return false

		# Consome os itens da entrega através do componente
		if player.inventory_component.has_method("remove_item"):
			player.inventory_component.remove_item(quest.required_item.id, quest.required_amount)
		else:
			player.inventory_component.items[quest.required_item.id]["quantity"] -= quest.required_amount

	# Entregar Recompensas
	if quest.reward_coins > 0 and player.inventory_component:
		player.inventory_component.add_coins(quest.reward_coins)

	if quest.reward_faction_id != "" and quest.reward_reputation != 0:
		if ReputationManager != null and ReputationManager.has_method("add_reputation"):
			ReputationManager.add_reputation(quest.reward_faction_id, quest.reward_reputation)

	# Transição do estado da missão
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)

	print("========================================")
	print("QUEST CONCLUÍDA: %s!" % quest.title)
	print("Recompensas Recebidas: +%d Moedas e +%d Reputação com %s" % [quest.reward_coins, quest.reward_reputation, quest.reward_faction_id])
	print("========================================")

	EventBus.notification_requested.emit("Missão Concluída: %s!" % quest.title, Color.LIME_GREEN)
	return true


## Consulta se uma missão está ativa no momento
func is_quest_active(quest_id: String) -> bool:
	return active_quests.has(quest_id)


## Consulta se uma missão já foi concluída no histórico
func is_quest_completed(quest_id: String) -> bool:
	return completed_quests.has(quest_id)
