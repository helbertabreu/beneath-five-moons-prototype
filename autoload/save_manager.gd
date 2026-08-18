# res://autoload/save_manager.gd
extends Node

## Gerencia a persistência completa do estado do jogo (ATS, Player, Inventário, Quests, Reputação e Mundo).

const SAVE_PATH: String = "user://savegame.json"

func save_game() -> bool:
	var player: PlayerController = _get_player()
	if player == null:
		print("ERRO SAVE: Jogador não encontrado no mundo.")
		return false

	var save_data: Dictionary = {
		"timestamp": Time.get_datetime_string_from_system(),
		"player": {
			"position_x": player.global_position.x,
			"position_y": player.global_position.y,
		},
		"survival": {
			"current_hunger": player.survival_component.current_hunger if player.survival_component else 100.0,
			"accumulated_fatigue": player.survival_component.accumulated_fatigue if player.survival_component else 0.0,
			"current_energy": player.survival_component.current_energy if player.survival_component else 100.0,
		},
		"ats": {
			"current_day": TimeManager.current_day if "current_day" in TimeManager else 1,
			"current_hour": TimeManager.get_current_hour() if TimeManager.has_method("get_current_hour") else 6,
			"current_minute": TimeManager.get_current_minute() if TimeManager.has_method("get_current_minute") else 0,
			"current_season": TimeManager.current_season if "current_season" in TimeManager else 0,
		},
		"inventory": {
			"coins": player.inventory_component.coins if player.inventory_component else 0,
			"items": _serialize_inventory(player.inventory_component),
		},
		"quests": {
			"active_quests": _serialize_active_quests(),
			"completed_quests": QuestManager.completed_quests.duplicate() if "completed_quests" in QuestManager else [],
		},
		"reputation": _serialize_reputation(),
		"world_nodes": _serialize_world_nodes(),
		"workstations": _serialize_workstations()
	}

	var json_string: String = JSON.stringify(save_data, "\t")
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file == null:
		print("ERRO SAVE: Não foi possível criar o arquivo de save em: ", SAVE_PATH)
		return false

	file.store_string(json_string)
	file.close()

	print("JOGO SALVO COM SUCESSO em: ", SAVE_PATH)
	EventBus.notification_requested.emit("Progresso salvo com sucesso!", Color.GOLD)
	return true


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("AVISO LOAD: Nenhum arquivo salvo encontrado.")
		EventBus.notification_requested.emit("Nenhum jogo salvo encontrado.", Color.INDIAN_RED)
		return false

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		print("ERRO LOAD: Falha ao ler o arquivo em: ", SAVE_PATH)
		return false

	var json_string: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var error: Error = json.parse(json_string)
	if error != OK:
		print("ERRO LOAD: JSON inválido: ", json.get_error_message())
		return false

	var save_data: Dictionary = json.data
	var player: PlayerController = _get_player()

	# 1. Carrega ATS (Tempo)
	if save_data.has("ats"):
		var ats: Dictionary = save_data["ats"]
		var saved_day: int = int(ats.get("current_day", 1))
		var saved_hour: int = int(ats.get("current_hour", 6))
		var saved_minute: int = int(ats.get("current_minute", 0))
		var saved_season = ats.get("current_season", 0)

		if TimeManager.has_method("load_time_state"):
			TimeManager.load_time_state(saved_day, saved_hour, saved_minute, saved_season)

	# 2. Carrega Posição e Sobrevivência
	if player != null:
		if save_data.has("player"):
			var p_pos: Dictionary = save_data["player"]
			player.global_position = Vector2(p_pos.get("position_x", player.global_position.x), p_pos.get("position_y", player.global_position.y))
		
		if save_data.has("survival") and player.survival_component:
			var surv: Dictionary = save_data["survival"]
			player.survival_component.current_hunger = float(surv.get("current_hunger", 100.0))
			player.survival_component.accumulated_fatigue = float(surv.get("accumulated_fatigue", 0.0))
			player.survival_component.current_energy = float(surv.get("current_energy", 100.0))
			
			if player.survival_component.has_method("refresh_effective_energy"):
				player.survival_component.refresh_effective_energy()

		# 3. Carrega Inventário
		if save_data.has("inventory") and player.inventory_component:
			var inv_data: Dictionary = save_data["inventory"]
			player.inventory_component.coins = int(inv_data.get("coins", 0))
			_deserialize_inventory(player.inventory_component, inv_data.get("items", {}))

	# 4. Carrega Quests
	if save_data.has("quests"):
		var q_data: Dictionary = save_data["quests"]
		if "completed_quests" in QuestManager:
			QuestManager.completed_quests.clear()
			for q_id in q_data.get("completed_quests", []):
				QuestManager.completed_quests.append(str(q_id))

	# 5. Carrega Reputação
	if save_data.has("reputation"):
		_deserialize_reputation(save_data["reputation"])

	# 6. Carrega Estado dos Recursos e Bancadas
	if save_data.has("world_nodes"):
		_deserialize_world_nodes(save_data["world_nodes"])
	if save_data.has("workstations"):
		_deserialize_workstations(save_data["workstations"])

	print("JOGO CARREGADO COM SUCESSO!")
	EventBus.notification_requested.emit("Jogo carregado!", Color.GREEN_YELLOW)
	
	# Refresh da HUD
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("_on_time_advanced"):
		hud._on_time_advanced(0, TimeManager.get_current_hour(), TimeManager.get_current_minute())
	
	# --- CORREÇÃO BUG-002: DESTRAVAMENTO COMPLETO DE INPUT E UI ---
	_restore_player_input_and_focus(player)
	
	return true

## Libera as travas de input do PlayerController, fecha todas as janelas e devolve o foco para a Viewport
func _restore_player_input_and_focus(player: PlayerController) -> void:
	get_tree().paused = false
	
	# 1. Oculta forçadamente todas as janelas de interface da HUD
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		if "inventory_panel" in hud and hud.inventory_panel:
			hud.inventory_panel.hide()
		if "crafting_window" in hud and hud.crafting_window:
			hud.crafting_window.hide()
		if "vendor_window" in hud and hud.vendor_window:
			hud.vendor_window.hide()
		if "quest_log_window" in hud and hud.quest_log_window:
			hud.quest_log_window.hide()
			
		var profile_node = hud.get_node_or_null("CharacterProfileWindow")
		if profile_node != null:
			profile_node.hide()
		elif "character_profile_window" in hud and hud.character_profile_window:
			hud.character_profile_window.hide()
	
	# 2. Destrava o PlayerController diretamente
	if player != null:
		player.is_input_disabled = false
		player.velocity = Vector2.ZERO
		player.process_mode = Node.PROCESS_MODE_INHERIT
		
		if player.has_method("force_unlock_input"):
			player.force_unlock_input()

	# 3. Limpa o foco ativo de componentes de UI
	var viewport = get_tree().root.get_viewport()
	if viewport:
		var gui_focus = viewport.gui_get_focus_owner()
		if gui_focus:
			gui_focus.release_focus()

# --- MÉTODOS AUXILIARES ---

func _get_player() -> PlayerController:
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		return players[0] as PlayerController
		
	var current_scene = get_tree().current_scene
	if current_scene != null:
		for child in current_scene.get_children():
			if child is PlayerController:
				return child as PlayerController
	return null

func _serialize_inventory(inv_component) -> Dictionary:
	var dict: Dictionary = {}
	if inv_component == null or not "items" in inv_component:
		return dict
		
	for item_id in inv_component.items:
		var slot = inv_component.items[item_id]
		var item_data: ItemData = slot.get("item", null)
		
		# CORREÇÃO: Utilizar resource_path ao invés de scene_file_path
		dict[item_id] = {
			"quantity": slot.get("quantity", 0),
			"resource_path": item_data.resource_path if item_data != null else ""
		}
	return dict

func _deserialize_inventory(inv_component, items_dict: Dictionary) -> void:
	if inv_component == null:
		return
	inv_component.items.clear()
	for item_id in items_dict:
		var slot_info = items_dict[item_id]
		var res_path: String = slot_info.get("resource_path", "")
		var qty: int = int(slot_info.get("quantity", 0))
		
		var item_data: ItemData = null
		if res_path != "" and ResourceLoader.exists(res_path):
			item_data = load(res_path) as ItemData
			
		inv_component.items[item_id] = {
			"item": item_data,
			"quantity": qty
		}

func _serialize_active_quests() -> Array:
	var list: Array = []
	if "active_quests" in QuestManager:
		for q_id in QuestManager.active_quests:
			list.append(q_id)
	return list

func _serialize_reputation() -> Dictionary:
	if "reputation_scores" in ReputationManager:
		return ReputationManager.reputation_scores.duplicate()
	return {}

func _deserialize_reputation(rep_dict: Dictionary) -> void:
	if "reputation_scores" in ReputationManager:
		ReputationManager.reputation_scores = rep_dict.duplicate()

func _serialize_world_nodes() -> Dictionary:
	var nodes_data: Dictionary = {}
	var nodes = get_tree().get_nodes_in_group("resource_nodes")
	for node in nodes:
		if "node_id" in node and "is_exhausted" in node:
			nodes_data[node.node_id] = {
				"is_exhausted": node.is_exhausted,
				"respawn_day": node.get("respawn_day") if "respawn_day" in node else 0
			}
	return nodes_data

func _deserialize_world_nodes(nodes_data: Dictionary) -> void:
	var nodes = get_tree().get_nodes_in_group("resource_nodes")
	for node in nodes:
		if "node_id" in node and nodes_data.has(node.node_id):
			var data = nodes_data[node.node_id]
			node.is_exhausted = data.get("is_exhausted", false)
			if "respawn_day" in node:
				node.respawn_day = data.get("respawn_day", 0)
			if node.has_method("update_visual_state"):
				node.update_visual_state()

func _serialize_workstations() -> Dictionary:
	var ws_data: Dictionary = {}
	var stations = get_tree().get_nodes_in_group("workstations")
	for ws in stations:
		if "station_id" in ws and "is_processing" in ws:
			ws_data[ws.station_id] = {
				"is_processing": ws.is_processing,
				"remaining_minutes": ws.get("remaining_minutes") if "remaining_minutes" in ws else 0
			}
	return ws_data

func _deserialize_workstations(ws_data: Dictionary) -> void:
	var stations = get_tree().get_nodes_in_group("workstations")
	for ws in stations:
		if "station_id" in ws and ws_data.has(ws.station_id):
			var data = ws_data[ws.station_id]
			ws.is_processing = data.get("is_processing", false)
			if "remaining_minutes" in ws:
				ws.remaining_minutes = data.get("remaining_minutes", 0)
