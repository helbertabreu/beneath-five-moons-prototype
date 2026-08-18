# res://src/entities/player/player_controller.gd
class_name PlayerController
extends CharacterBody2D

## Controla a movimentação isométrica do jogador, interações contextuais e comandos de debug.

@export var move_speed: float = 150.0
@export var interaction_range: float = 80.0

# Trava manual explícita de controle (para diálogos, transições ou menus abertos)
var is_input_disabled: bool = false

# Busca segura de componentes filhos
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
	
	# Força o fechamento visual de qualquer janela que tenha permanecido aberta na HUD
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
		# --- 1. ATALHOS DE GAMEPLAY E INTERFACE (PADRÃO DA INDÚSTRIA) ---
		match event.keycode:
			KEY_E: # Interação Universal Contextual (Nós, Canteiros, Bancadas, NPCs)
				_interact_contextual()
			KEY_I, KEY_TAB: # Alterna Inventário
				_toggle_hud_window("toggle_inventory")
			KEY_J: # Alterna Diário de Missões (Journal)
				_toggle_hud_window("toggle_quest_log")
			KEY_C: # Alterna Perfil do Personagem (Character)
				_toggle_hud_window("toggle_character_profile")
			KEY_F5: # Salvamento Rápido
				SaveManager.save_game()
			KEY_F9: # Carregamento Rápido
				SaveManager.load_game()

		# --- 2. ATALHOS DE DEBUG (ISOLADOS E PROTEGIDOS) ---
		if OS.is_debug_build() and Input.is_key_pressed(KEY_SHIFT):
			_handle_debug_shortcuts(event.keycode)


## Processa comandos de debug isoladamente quando o jogo é executado no editor com Shift pressionado
func _handle_debug_shortcuts(keycode: int) -> void:
	match keycode:
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
		KEY_H:
			print("DEBUG: Restaurando Fome e Energia...")
			survival_component.current_hunger = survival_component.max_hunger
			survival_component.current_energy = survival_component.get_effective_max_energy()
			survival_component._update_all_signals()
		KEY_T:
			_fast_forward_days(3)
		KEY_K:
			ReputationManager.add_reputation("vilarejo", 500)
		KEY_L:
			ReputationManager.add_reputation("vilarejo", -500)
		KEY_Q:
			var quest_res: QuestData = load("res://data/quests/quest_primeira_ferramenta.tres") as QuestData
			if quest_res:
				QuestManager.accept_quest(quest_res)
		KEY_0:
			QuestManager.complete_quest("quest_primeira_ferramenta", self)


## Interação Unificada e Contextual: Encontra o elemento mais próximo do jogador
func _interact_contextual() -> void:
	var closest_target: Node = null
	var min_distance: float = INF

	# 1. Checa Canteiros de Agricultura na área de intersecção
	if has_node("InteractionArea"):
		var areas = $InteractionArea.get_overlapping_areas()
		for area in areas:
			if area is CropPlot:
				area.interact(self)
				return

	# 2. Avalia Nós de Recursos
	for node in get_tree().get_nodes_in_group("resource_nodes"):
		if node is Node2D:
			var dist: float = global_position.distance_to(node.global_position)
			if dist < min_distance and dist <= interaction_range:
				min_distance = dist
				closest_target = node

	# 3. Avalia Bancadas de Trabalho
	for station in get_tree().get_nodes_in_group("workstations"):
		if station is Node2D:
			var dist: float = global_position.distance_to(station.global_position)
			if dist < min_distance and dist <= interaction_range:
				min_distance = dist
				closest_target = station

	# 4. Avalia Vendedores/NPCs
	for vendor in get_tree().get_nodes_in_group("vendors"):
		if vendor is Node2D:
			var dist: float = global_position.distance_to(vendor.global_position)
			if dist < min_distance and dist <= interaction_range:
				min_distance = dist
				closest_target = vendor

	# Executa a interação no elemento mais próximo encontrado
	if closest_target != null:
		if closest_target.has_method("interact"):
			closest_target.interact(self)
	else:
		print("GAMEPLAY: Nenhum objeto interativo próximo (Alcance: %.0fpx)." % interaction_range)


func _toggle_hud_window(method_name: String) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method(method_name):
		hud.call(method_name, self)


func _fast_forward_days(days_count: int) -> void:
	var total_minutes_to_skip: int = days_count * 1440
	print("DEBUG [FERRAMENTA DE TESTE]: Acelerando o tempo do jogo em %d dias (%d minutos)..." % [days_count, total_minutes_to_skip])
	
	survival_component.current_hunger = survival_component.max_hunger
	survival_component.current_energy = survival_component.get_effective_max_energy()
	
	TimeManager.advance_time(total_minutes_to_skip)
	survival_component._update_all_signals()


func _handle_movement() -> void:
	if is_input_disabled:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Trava movimentação se janelas da HUD estiverem abertas
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
