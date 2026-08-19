class_name WolfEnemy
extends CharacterBody2D
## Entidade concreta do Lobo Esfomeado (ENM-001) refatorada para a FSM.
##
## Mapeia os atributos exatos do GDD (HP: 40, Dano: 12, Cooldown: 1.5s, Patrulha: 50px/s, Perseguição: 110px/s)[cite: 4].

@export var enemy_id: String = "ENM-001"
@export var display_name: String = "Lobo Esfomeado"

var health_component: HealthComponent
var state_machine: EnemyStateMachine

func _ready() -> void:
	add_to_group("enemies")
	
	# Busca defensiva de nós para evitar exceções no debugger em testes unitários programáticos
	if health_component == null:
		health_component = get_node_or_null("HealthComponent") as HealthComponent
		
	if state_machine == null:
		state_machine = get_node_or_null("StateMachine") as EnemyStateMachine
	
	if health_component != null:
		health_component.max_health = 40.0
		health_component.current_health = 40.0
		if not health_component.health_depleted.is_connected(_on_health_depleted):
			health_component.health_depleted.connect(_on_health_depleted)

func _on_health_depleted() -> void:
	if state_machine != null:
		state_machine.transition_to("dead")
