class_name StateMachine
extends Node

## Máquina de Estados Genérica (FSM) para gerenciamento de comportamentos.

signal transitioned(state_name: String)

## Permite aceitar NodePath (via Inspetor) ou referências diretas de nós com segurança.
@export var initial_state: Variant

var current_state: Node = null
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			if child.has_signal("transition"):
				child.transition.connect(_on_child_transition)
	
	# Verificação defensiva de segurança para o owner e ciclo de vida
	if is_inside_tree():
		if owner:
			await owner.ready
		_initialize_state()

func _initialize_state() -> void:
	if initial_state == null:
		return
	
	var initial: Node = null
	
	if initial_state is NodePath:
		initial = get_node_or_null(initial_state)
	elif initial_state is Node:
		initial = initial_state
		
	if initial and initial is State:
		transition_to(initial.name)

func _process(delta: float) -> void:
	if current_state and current_state.has_method("update"):
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("physics_update"):
		current_state.physics_update(delta)

func _on_child_transition(state_name: String, source_state: State) -> void:
	if source_state != current_state:
		return
	transition_to(state_name)

## Transiciona para um novo estado, mantendo assinatura flexível para aceitar múltiplos argumentos de sinais
func transition_to(target_state_name: String, _extra_arg = null) -> void:
	var target_key = target_state_name.to_lower()
	if not states.has(target_key):
		# Fallback defensivo caso o estado solicitado não exista (ex: 'patrol')
		if states.has("idle"):
			target_key = "idle"
		else:
			return

	if current_state:
		if current_state.has_method("exit"):
			current_state.exit()

	current_state = states[target_key]
	if current_state.has_method("enter"):
		current_state.enter()
	
	transitioned.emit(target_state_name)
