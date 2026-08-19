## WolfEnemy
## Entidade concreta de inimigo do tipo Lobo, integrando IA de FSM,
## HealthComponent e gerenciamento de combate básico.
class_name WolfEnemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent if has_node("HealthComponent") else null
@onready var state_machine: StateMachine = $StateMachine if has_node("StateMachine") else null

func _ready() -> void:
	_resolve_components()
	_connect_signals()

## Garante a obtenção dos componentes necessários via hierarquia ou busca direta.
func _resolve_components() -> void:
	if not health_component:
		health_component = get_node_or_null("HealthComponent") as HealthComponent
		if not health_component:
			health_component = find_child("HealthComponent") as HealthComponent

	if not state_machine:
		state_machine = get_node_or_null("StateMachine") as StateMachine
		if not state_machine:
			state_machine = find_child("StateMachine") as StateMachine

## Conecta os sinais necessários de forma segura e idempotente.
func _connect_signals() -> void:
	if health_component:
		if not health_component.health_depleted.is_connected(_on_health_depleted):
			health_component.health_depleted.connect(_on_health_depleted)
	else:
		push_warning("WolfEnemy: HealthComponent não encontrado na hierarquia.")
		
	if not state_machine:
		push_warning("WolfEnemy: StateMachine não encontrada na hierarquia.")

## Callback acionado quando o componente de vida zera.
func _on_health_depleted() -> void:
	if state_machine:
		if state_machine.has_node("DeadState") or state_machine.has_node("Dead"):
			# Suporta tanto o nome "DeadState" quanto "Dead" para compatibilidade com testes
			var target_state = "DeadState" if state_machine.has_node("DeadState") else "Dead"
			state_machine.transition_to(target_state)
