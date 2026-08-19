class_name PlayerController
extends CharacterBody2D
## Controller principal do Jogador em Beneath Five Moons.
##
## Gerencia entrada de usuário (Input), movimentação 2D Top-Down,
## execução de ações atômicas via ActionSystem e integração com SurvivalComponent.

const ActionSystemScript = preload("res://src/scripts/core/action_system.gd")

@export var move_speed: float = 150.0

var survival_component: SurvivalComponent
var interaction_area: Area2D

var move_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Registro obrigatório no grupo de atores ANTES de buscar sub-nós
	add_to_group("player")
	_setup_components_defensive()

## Garante a inicialização defensiva dos componentes sem causar exceções no debugger
func _setup_components_defensive() -> void:
	# Busca defensiva do SurvivalComponent
	if survival_component == null:
		survival_component = get_node_or_null("SurvivalComponent") as SurvivalComponent
		if survival_component == null:
			for child in get_children():
				if child is SurvivalComponent:
					survival_component = child as SurvivalComponent
					break

	# Busca defensiva da InteractionArea
	if interaction_area == null:
		interaction_area = get_node_or_null("InteractionArea") as Area2D
		if interaction_area == null:
			for child in get_children():
				if child is Area2D and child.name != "Hurtbox" and child.name != "Hitbox":
					interaction_area = child as Area2D
					break

func _physics_process(_delta: float) -> void:
	_handle_input()
	_apply_movement()

## Captura os comandos de entrada do jogador.
func _handle_input() -> void:
	move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Interagir com objetos/recursos do mundo (Tecla E / Espaço)
	if Input.is_action_just_pressed("ui_accept"):
		_interact_with_nearest_object()
		
	# Atalhos de Debug (GDD / TDD Seção 44)
	if OS.is_debug_build():
		if Input.is_key_pressed(KEY_SHIFT) and Input.is_key_pressed(KEY_1):
			perform_gather_action()

## Aplica vetor de movimento ao CharacterBody2D.
func _apply_movement() -> void:
	velocity = move_direction * move_speed
	move_and_slide()

## Executa uma ação atômica de coleta (exemplo: coletar madeira/recurso).
func perform_gather_action() -> void:
	var action = GameAction.new("gather_wood", 15, 10.0, 2.0)
	var success: bool = ActionSystemScript.execute_action(action, self)
	
	if success:
		print("PlayerController: Coleta executada com sucesso!")
	else:
		print("PlayerController: Não foi possível realizar a coleta.")

## Tenta interagir com o objeto/recurso interativo mais próximo dentro da área.
func _interact_with_nearest_object() -> void:
	if interaction_area == null:
		return
		
	var overlapping_areas = interaction_area.get_overlapping_areas()
	var overlapping_bodies = interaction_area.get_overlapping_bodies()
	
	# Checa corpos interativos
	for body in overlapping_bodies:
		if body.has_method("interact"):
			body.interact(self)
			return
			
	# Checa áreas interativas
	for area in overlapping_areas:
		if area.has_method("interact"):
			area.interact(self)
			return
