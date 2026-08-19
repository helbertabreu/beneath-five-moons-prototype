class_name EnemyBase
extends CharacterBody2D

## Classe base para todas as entidades de inimigos.
## Gerencia a FSM (EnemyStateMachine), atributos de combate, detecção e navegação.

signal enemy_died(enemy_id: String)

@export var monster_id: String = "ENM-000"
@export var display_name: String = "Inimigo Base"
@export var max_hp: float = 50.0
@export var attack_damage: float = 10.0
@export var movement_speed: float = 80.0
@export var detection_radius: float = 150.0
@export var attack_range: float = 30.0
@export var attack_cooldown: float = 1.5

@onready var health_component: HealthComponent = $HealthComponent
@onready var loot_table_component: LootTableComponent = $LootTableComponent

var state_machine: Node = null
var nav_agent: NavigationAgent2D = null
var target: Node2D = null

func _ready() -> void:
	_setup_state_machine()
	_setup_navigation_agent()
	
	if health_component:
		health_component.max_health = max_hp
		health_component.current_health = max_hp
		if not health_component.died.is_connected(_on_died):
			health_component.died.connect(_on_died)
	
	_setup_target()

## Tenta localizar a máquina de estados defensivamente
func _setup_state_machine() -> void:
	if has_node("EnemyStateMachine"):
		state_machine = get_node("EnemyStateMachine")
	elif has_node("StateMachine"):
		state_machine = get_node("StateMachine")

## Tenta localizar o nó de navegação defensivamente
func _setup_navigation_agent() -> void:
	if has_node("NavigationAgent2D"):
		nav_agent = get_node("NavigationAgent2D") as NavigationAgent2D

## Busca e associa o jogador principal como alvo inicial
func _setup_target() -> void:
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]

func _physics_process(delta: float) -> void:
	if state_machine:
		if state_machine.has_method("physics_update"):
			state_machine.physics_update(delta)
		elif state_machine.has_method("update"):
			state_machine.update(delta)

func _on_died() -> void:
	EventBus.monster_killed.emit(monster_id)
	enemy_died.emit(monster_id)
	if loot_table_component:
		loot_table_component.generate_and_spawn_loot(global_position)
	queue_free()
