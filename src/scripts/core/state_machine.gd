class_name EnemyStateMachine
extends Node
## Gerenciador central da Finite State Machine (FSM) dos inimigos.
##
## Gerencia transições atômicas entre estados filhos e delega o processamento de física e quadros.

signal transitioned(state_name: String)

## Estado inicial configurável pelo Inspetor.
@export var initial_state: State

## Estado atual ativo na FSM.
var current_state: State
var _states: Dictionary = {}

func _ready() -> void:
	# Verificação defensiva de inicialização para suportar instâncias dinâmicas e testes unitários
	if owner != null and not owner.is_node_ready():
		await owner.ready
	
	# Mapeia automaticamente todos os nós filhos que derivam de State
	for child in get_children():
		if child is State:
			_states[child.name.to_lower()] = child
			child.state_machine = self
			
	if initial_state != null:
		current_state = initial_state
		current_state.enter()
	elif get_child_count() > 0 and get_child(0) is State:
		current_state = get_child(0) as State
		current_state.enter()

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_update(delta)

## Transiciona a FSM atômica para um novo estado pelo nome.
## [param target_state_name] Nome do nó do estado destino (case-insensitive).
## [param msg] Parâmetros adicionais para o método enter() do estado destino.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	var key: String = target_state_name.to_lower()
	if not _states.has(key):
		push_warning("EnemyStateMachine: Estado '%s' não encontrado em %s" % [target_state_name, get_path()])
		return
		
	var new_state: State = _states[key] as State
	if current_state != null:
		current_state.exit()
		
	current_state = new_state
	current_state.enter(msg)
	emit_signal("transitioned", current_state.name)
