# res://src/entities/player/player_controller.gd
class_name PlayerController
extends CharacterBody2D

## Controla a movimentação isométrica do jogador e entradas de debug.

@export var move_speed: float = 150.0

# Trava manual explícita de controle (para diálogos ou transições)
var is_input_disabled: bool = false

# Busca segura da referência do componente
@onready var survival_component: SurvivalComponent = $SurvivalComponent as SurvivalComponent
@onready var inventory_component: InventoryComponent = $InventoryComponent as InventoryComponent
@onready var profession_component: ProfessionComponent = $ProfessionComponent as ProfessionComponent


func _ready() -> void:
	# Validação defensiva de inicialização
	if not survival_component:
		push_error("CRÍTICO: SurvivalComponent não foi encontrado como nó filho do Player!")


func _physics_process(_delta: float) -> void:
	_handle_movement()


## Método público chamado pelo SaveManager para garantir destravamento total no Load
func force_unlock_input() -> void:
	is_input_disabled = false
	velocity = Vector2.ZERO
	process_mode = Node.PROCESS_MODE_INHERIT
	
	# Força o fechamento visual de qualquer janela que tenha permanecido aberta no HUD
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		if "inventory_panel" in hud and hud.inventory_panel:
			hud.inventory_panel.visible = false
		if "crafting_window" in hud and hud.crafting_window:
			hud.crafting_window.visible = false
		if "vendor_window" in hud and hud.vendor_window:
			hud.vendor_window.visible = false
		if "quest_log_window" in hud and hud.quest_log_window:
			hud.quest_log_window.visible = false
			
		var profile_node = hud.get_node_or_null("CharacterProfileWindow")
		if profile_node != null:
			profile_node.visible = false
		elif "character_profile_window" in hud and hud.character_profile_window:
			hud.character_profile_window.visible = false


func craft_item_active(recipe: RecipeData) -> void:
	if not profession_component.can_craft(recipe, inventory_component):
		return
		
	if recipe.result_item == null:
		push_error("ERRO CONFIGURAÇÃO: A receita '%s' não possui um Result Item atribuído no Inspetor!" % recipe.recipe_name)
		return
		
	var success: bool = survival_component.consume_resources_for_action(
		recipe.hunger_cost,
		recipe.energy_cost,
		recipe.time_cost_minutes
	)
	
	if not success:
		print("ENERGIA/FOME INSUFICIENTE: Você está exausto demais para forjar.")
		return
		
	for ingredient in recipe.ingredients:
		var item: ItemData = ingredient.item
		var required_qty: int = ingredient.amount
		inventory_component.items[item.id]["quantity"] -= required_qty
		
	inventory_component.add_item(recipe.result_item, recipe.result_amount)
	profession_component.add_xp(recipe.xp_reward)
	print("CRAFTING ATIVO CONCLUÍDO: Criado %dx %s" % [recipe.result_amount, recipe.result_item.name])


func _unhandled_input(event: InputEvent) -> void:
	if is_input_disabled:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				print("DEBUG: Executando trabalho de coleta...")
				survival_component.consume_resources_for_action(2.0, 10.0, 15)
			KEY_2:
				print("DEBUG: Consumindo alimento...")
				survival_component.consume_food(20.0, 10.0)
			KEY_3:
				print("DEBUG: Viajando para outra região...")
				survival_component.consume_resources_for_action(5.0, 0.0, 60)
			KEY_4:
				print("DEBUG: Descansando na fogueira...")
				survival_component.rest_in_campfire()
			KEY_E:
				_interact_with_closest_node()
			KEY_F:
				_interact_with_closest_workstation()
			KEY_H: # APAGAR ATALHO DE DEBUG (Restaurar Status)
				print("DEBUG: Restaurando Fome e Energia para os testes...")
				survival_component.current_hunger = survival_component.max_hunger
				survival_component.current_energy = survival_component.get_effective_max_energy()
				survival_component._update_all_signals()
			KEY_T: # ATALHO DE FERRAMENTA DE TESTE (Acelerar 3 Dias)
				_fast_forward_days(3)
			KEY_G: # Interagir com Comerciante mais próximo
				_interact_with_closest_vendor()
			KEY_B: # Comprar Item do Comerciante
				_buy_from_closest_vendor()
			KEY_V: # Vender Lingote/Ferramenta para o Comerciante
				_sell_to_closest_vendor()
			KEY_K: # DEBUG: Aumentar Reputação (+30)
				ReputationManager.add_reputation("vilarejo", 30)
			KEY_L: # DEBUG: Diminuir Reputação (-30)
				ReputationManager.add_reputation("vilarejo", -30)
			KEY_Q: # Aceitar a Missão (Debug)
				var quest_res: QuestData = load("res://data/quests/quest_primeira_ferramenta.tres") as QuestData
				QuestManager.accept_quest(quest_res)
			KEY_0: # Entregar a Missão no NPC mais próximo (Debug)
				QuestManager.complete_quest("quest_primeira_ferramenta", self)
			KEY_J: # Abre o Diário de Missões (UI)
				var hud = get_tree().get_first_node_in_group("hud")
				if hud and hud.has_method("toggle_quest_log"):
					hud.toggle_quest_log(self)
			KEY_I: # Abre Inventário (UI)
				var hud = get_tree().get_first_node_in_group("hud")
				if hud and hud.has_method("toggle_inventory"):
					hud.toggle_inventory(self)
			KEY_C: # Abre o Perfil do Jogador (UI)
				var hud = get_tree().get_first_node_in_group("hud")
				if hud and hud.has_method("toggle_character_profile"):
					hud.toggle_character_profile(self)
			KEY_F5: # Salvar o Jogo
				SaveManager.save_game()
			KEY_F9: # Carregar o Jogo
				SaveManager.load_game()


#### APAGAR ESSA FUNÇÃO FUTURAMENTE - Avança 3 dias
func _fast_forward_days(days_count: int) -> void:
	var total_minutes_to_skip: int = days_count * 1440
	print("DEBUG [FERRAMENTA DE TESTE]: Acelerando o tempo do jogo em %d dias (%d minutos)..." % [days_count, total_minutes_to_skip])
	
	survival_component.current_hunger = survival_component.max_hunger
	survival_component.current_energy = survival_component.get_effective_max_energy()
	
	TimeManager.advance_time(total_minutes_to_skip)
	survival_component._update_all_signals()


func _interact_with_closest_node() -> void:
	var resource_nodes: Array[Node] = get_tree().get_nodes_in_group("resource_nodes")
	
	var areas = $InteractionArea.get_overlapping_areas() if has_node("InteractionArea") else []
	for area in areas:
		if area is CropPlot:
			area.interact(self)
			return
	
	if resource_nodes.is_empty():
		print("DEBUG: Nenhum nó de recurso encontrado no mapa.")
		return
		
	var closest_node: ResourceNode = null
	var min_distance: float = INF
	var interaction_range: float = 80.0
	
	for node in resource_nodes:
		if node is ResourceNode:
			var res_node: ResourceNode = node as ResourceNode
			var distance: float = global_position.distance_to(res_node.global_position)
			
			if distance < min_distance:
				min_distance = distance
				closest_node = res_node
				
	if closest_node != null and min_distance <= interaction_range:
		print("DEBUG: Minerando em %s..." % closest_node.node_name)
		closest_node.interact(self)
	else:
		print("DEBUG: Você está muito longe de qualquer nó de recurso!")


func _interact_with_closest_workstation() -> void:
	var workstations: Array[Node] = get_tree().get_nodes_in_group("workstations")
	
	if workstations.is_empty():
		print("DEBUG: Nenhuma bancada encontrada no mapa.")
		return
		
	var closest_station: Workstation = null
	var min_distance: float = INF
	var interaction_range: float = 80.0
	
	for node in workstations:
		if node is Workstation:
			var station: Workstation = node as Workstation
			var distance: float = global_position.distance_to(station.global_position)
			
			if distance < min_distance:
				min_distance = distance
				closest_station = station
				
	if closest_station != null and min_distance <= interaction_range:
		print("DEBUG: Interagindo com %s (Distância: %.1fpx)..." % [closest_station.station_name, min_distance])
		closest_station.interact(self)
	else:
		print("DEBUG: Você está muito longe de qualquer bancada! Aproxime-se para interagir.")


func _handle_movement() -> void:
	if is_input_disabled:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Checagem de menus de UI abertos
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		var inv_open: bool = bool(hud.inventory_panel.visible) if ("inventory_panel" in hud and hud.inventory_panel) else false
		var craft_open: bool = bool(hud.crafting_window.visible) if ("crafting_window" in hud and hud.crafting_window) else false
		var vendor_open: bool = bool(hud.vendor_window.visible) if ("vendor_window" in hud and hud.vendor_window) else false
		var quest_open: bool = bool(hud.quest_log_window.visible) if ("quest_log_window" in hud and hud.quest_log_window) else false
		
		var profile_node = hud.get_node_or_null("CharacterProfileWindow")
		var profile_open: bool = false
		if profile_node != null:
			profile_open = profile_node.visible
		elif "character_profile_window" in hud and hud.character_profile_window:
			profile_open = bool(hud.character_profile_window.visible)
		
		if inv_open or craft_open or vendor_open or quest_open or profile_open:
			velocity = Vector2.ZERO
			move_and_slide()
			return

	var input_dir: Vector2 = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0

	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * move_speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()


func _get_closest_vendor() -> NPCVendor:
	var vendors: Array[Node] = get_tree().get_nodes_in_group("vendors")
	if vendors.is_empty():
		return null
		
	var closest: NPCVendor = null
	var min_distance: float = INF
	var interaction_range: float = 80.0
	
	for node in vendors:
		if node is NPCVendor:
			var vendor: NPCVendor = node as NPCVendor
			var distance: float = global_position.distance_to(vendor.global_position)
			if distance < min_distance and distance <= interaction_range:
				min_distance = distance
				closest = vendor
				
	return closest


func _interact_with_closest_vendor() -> void:
	var vendor: NPCVendor = _get_closest_vendor()
	if vendor != null:
		vendor.interact(self)
	else:
		print("DEBUG: Você está muito longe de qualquer comerciante!")


func _buy_from_closest_vendor() -> void:
	var vendor: NPCVendor = _get_closest_vendor()
	if vendor != null:
		vendor.buy_item_from_vendor(self)
	else:
		print("DEBUG: Chegue mais perto do comerciante para comprar!")


func _sell_to_closest_vendor() -> void:
	var vendor: NPCVendor = _get_closest_vendor()
	if vendor != null:
		var tool_item: ItemData = load("res://data/items/ferramenta_cobre.tres") as ItemData
		var ingot_item: ItemData = load("res://data/items/lingote_cobre.tres") as ItemData
		
		if inventory_component.get_item_quantity("ferramenta_cobre") > 0:
			vendor.sell_item_to_vendor(self, tool_item)
		elif inventory_component.get_item_quantity("lingote_cobre") > 0:
			vendor.sell_item_to_vendor(self, ingot_item)
		else:
			print("DEBUG: Você não tem Lingotes nem Ferramentas no inventário para vender!")
	else:
		print("DEBUG: Chegue mais perto do comerciante para vender!")
