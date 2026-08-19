class_name NightBandit
extends CharacterBody2D
## Entidade concreta do Salteador da Noite (ENM-002) refatorada para a FSM.
##
## Mapeia os atributos exatos do GDD (HP: 60, Dano: 15, Perseguição: 120px/s) e preferência de atividade noturna[cite: 4].

@export var enemy_id: String = "ENM-002"
@export var display_name: String = "Salteador da Noite"

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
		health_component.max_health = 60.0
		health_component.current_health = 60.0
		if not health_component.health_depleted.is_connected(_on_health_depleted):
			health_component.health_depleted.connect(_on_health_depleted)

func _on_health_depleted() -> void:
	if state_machine != null:
		state_machine.transition_to("dead")

## Verifica se o salteador deve agir agressivamente com base no horário do TimeManager[cite: 4].
func is_active_hour() -> bool:
	if TimeManager != null and TimeManager.has_method("is_late_night"):
		return TimeManager.is_late_night()
	return true
