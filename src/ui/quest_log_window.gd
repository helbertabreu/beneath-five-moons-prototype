# res://src/ui/quest_log_window.gd
class_name QuestLogWindow
extends PanelContainer

@onready var quest_list: ItemList = $VBoxContainer/HBoxContainer/QuestList
@onready var quest_title: Label = $VBoxContainer/HBoxContainer/VBoxContainer/QuestTitle
@onready var description_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Description
@onready var requirements_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Requirements
@onready var rewards_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Rewards
@onready var close_button: Button = $VBoxContainer/CloseButton

var current_player: PlayerController = null
var active_quest_ids: Array[String] = []

func _ready() -> void:
	visible = false
	close_button.pressed.connect(hide)
	quest_list.item_selected.connect(_on_quest_selected)
	
	quest_list.custom_minimum_size = Vector2(200, 200)

func open(player: PlayerController) -> void:
	current_player = player
	_refresh_quest_list()
	visible = true

func _refresh_quest_list() -> void:
	quest_list.clear()
	active_quest_ids.clear()
	_clear_details()
	
	var active_quests: Dictionary = QuestManager.active_quests
	
	if active_quests.is_empty():
		quest_list.add_item("Nenhuma missão ativa.")
		quest_list.set_item_disabled(0, true)
		return
		
	for q_id in active_quests:
		var quest: QuestData = active_quests[q_id]
		if quest != null:
			active_quest_ids.append(q_id)
			quest_list.add_item(quest.title)
			
	# Seleciona a primeira missão automaticamente se houver alguma
	if not active_quest_ids.is_empty():
		quest_list.select(0)
		_on_quest_selected(0)

func _on_quest_selected(index: int) -> void:
	if index < 0 or index >= active_quest_ids.size():
		return
		
	var q_id: String = active_quest_ids[index]
	var quest: QuestData = QuestManager.active_quests.get(q_id)
	
	if quest == null:
		return
		
	quest_title.text = quest.title
	description_label.text = quest.description
	
	# Calcula a quantidade atual do item no inventário do jogador
	var current_qty: int = 0
	if current_player != null and current_player.inventory_component != null and quest.required_item != null:
		current_qty = current_player.inventory_component.get_item_quantity(quest.required_item.id)
		
	if quest.required_item != null:
		requirements_label.text = "Objetivo: %s (%d/%d)" % [
			quest.required_item.name, 
			current_qty, 
			quest.required_amount
		]
	else:
		requirements_label.text = "Objetivo: Concluído"
		
	rewards_label.text = "Recompensas: %d Moedas | +%d Reputação (%s)" % [
		quest.reward_coins, 
		quest.reward_reputation, 
		quest.reward_faction_id.capitalize()
	]

func _clear_details() -> void:
	quest_title.text = "Selecione uma Missão"
	description_label.text = ""
	requirements_label.text = ""
	rewards_label.text = ""
