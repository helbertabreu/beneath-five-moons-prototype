class_name EnemyBase
extends CharacterBody2D

## Propriedades base de identidade e combate para todos os inimigos.
@export var monster_id: String = "ENM-000"
@export var display_name: String = "Inimigo Genérico"
@export var max_hp: float = 100.0
@export var attack_damage: float = 10.0
@export var movement_speed: float = 50.0
@export var detection_radius: float = 150.0
@export var attack_range: float = 30.0
@export var attack_cooldown: float = 1.5

@onready var health_component: HealthComponent = $HealthComponent
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	if health_component:
		if not health_component.health_depleted.is_connected(_on_health_depleted):
			health_component.health_depleted.connect(_on_health_depleted)

## Responde ao esgotamento da vida acionando a transição para o estado de morte na FSM.
func _on_health_depleted() -> void:
	if state_machine:
		state_machine.transition_to("DeadState")
