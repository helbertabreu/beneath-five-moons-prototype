class_name PlayerController
extends CharacterBody2D
## Controller principal do Jogador em Beneath Five Moons.
##
## Gerencia entrada de usuário (Input), movimentação 2D Top-Down,
## execução de ações atômicas via ActionSystem e integração com SurvivalComponent.

@export var move_speed: float = 150.0

@onready var survival_component: SurvivalComponent = $SurvivalComponent as SurvivalComponent
@onready var interaction_area: Area2D = $InteractionArea as Area2D

var move_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	_handle_input()
	_apply_movement()

## Captura os comandos de entrada do jogador.
func _handle_input() -> void:
	move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Interagir com objetos/recursos do mundo (Tecla E / Espaço)
	if Input.is_action_just_pressed("ui_accept"):
		_interact_with_nearest_object()
		
	# Atachamento de atalhos de Debug (GDD / TDD Seção 44)
	if OS.is_debug_build():
		if Input.is_key_pressed(KEY_SHIFT) and Input.is_key_pressed(KEY_1):
			perform_gather_action()

## Aplica vetor de movimento ao CharacterBody2D.
func _apply_movement() -> void:
	velocity = move_direction * move_speed
	move_and_slide()

## Executa uma ação atômica de coleta (exemplo: coletar madeira/recurso).
##
## Utiliza a arquitetura ActionSystem para validar e deduzir custos atômicos
## de Tempo, Energia e Fome antes da realização da tarefa.
func perform_gather_action() -> void:
	var action = GameAction.new("gather_wood", 15, 10.0, 2.0)
	var success: bool = ActionSystem.execute_action(action, self)
	
	if success:
		print("PlayerController: Coleta executada com sucesso! Tempo e recursos atualizados.")
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

# MODO DE OPERAÇÃO: ESTADO 6 (VALIDAÇÃO) E ESTADO 7 (RELATÓRIO)

### Relatório de Atualização do Script
#* **Arquivo Modificado:** `src/entities/player/player_controller.gd`[cite: 1, 6]
# * **Alterações Principais:**
#  1. Integração da função `perform_gather_action()` instanciando `GameAction` e invocando `ActionSystem.execute_action(action, self)`[cite: 1, 6].
#  2. Suporte aos atalhos de depuração (`OS.is_debug_build()`) conforme estipulado na Seção 44 do TDD[cite: 1, 6].
#  3. Garantida a compatibilidade com a Godot 4.7.1 e a tipagem forte de dados no GDScript[cite: 1, 6].
