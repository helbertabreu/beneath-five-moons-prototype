class_name WolfEnemy
extends CharacterBody2D

## Controlador do Inimigo Lobo com integração à StateMachine e HealthComponent.

@export var max_health: float = 40.0
@export var attack_damage: float = 12.0
@export var movement_speed: float = 110.0
@export var detection_radius: float = 180.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

var player_target: Node2D = null

func _ready() -> void:
	if health_component:
		health_component.max_health = max_health
		health_component.health = max_health
		# Conecta o sinal de morte ao método exigido pelo teste e pela FSM
		if not health_component.died.is_connected(_on_health_depleted):
			health_component.died.connect(_on_health_depleted)

func _physics_process(delta: float) -> void:
	pass

## Callback exigido pelo teste para transicionar a FSM para DeadState.
func _on_health_depleted() -> void:
	if state_machine and state_machine.has_method("transition_to"):
		state_machine.transition_to("dead")
