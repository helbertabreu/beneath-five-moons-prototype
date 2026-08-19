class_name EnemyBase
extends CharacterBody2D
## Classe e controller base para todas as entidades de inimigos em Beneath Five Moons.
##
## Coordena a integração entre HealthComponent, HurtboxComponent, LootTableComponent
## e o gerenciador de estados StateMachine.

@export var enemy_id: String = "ENM-GENERIC"
@export var display_name: String = "Inimigo Base"

@onready var health_component: HealthComponent = $HealthComponent as HealthComponent
@onready var state_machine: EnemyStateMachine = $StateMachine as EnemyStateMachine
@onready var loot_table_component: LootTableComponent = $LootTableComponent as LootTableComponent

func _ready() -> void:
	add_to_group("enemies")
	_setup_health_signals()

func _setup_health_signals() -> void:
	if health_component != null:
		if not health_component.health_depleted.is_connected(_on_health_depleted):
			health_component.health_depleted.connect(_on_health_depleted)

## Callback disparado quando os pontos de vida no HealthComponent chegam a zero.
func _on_health_depleted() -> void:
	if state_machine != null:
		state_machine.transition_to("dead")
