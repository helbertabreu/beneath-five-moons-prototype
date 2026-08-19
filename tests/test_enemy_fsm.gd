class_name TestEnemyFSM
extends Node
## Suíte de testes automatizados para verificação das transições de estado da FSM dos Inimigos.

func _ready() -> void:
	run_all_tests()

func run_all_tests() -> void:
	print("[TEST-SUITE] Iniciando testes da FSM de Inimigos...")
	test_fsm_initial_state()
	test_health_depleted_transition()
	print("[TEST-SUITE] Todos os testes da FSM de Inimigos passaram com SUCESSO!")

func test_fsm_initial_state() -> void:
	var fsm = EnemyStateMachine.new()
	var idle = IdleState.new()
	idle.name = "IdleState"
	var patrol = PatrolState.new()
	patrol.name = "PatrolState"
	
	fsm.add_child(idle)
	fsm.add_child(patrol)
	fsm.initial_state = idle
	
	var dummy_owner = Node2D.new()
	add_child(dummy_owner)
	dummy_owner.add_child(fsm)
	
	# Simula a inicialização da FSM na árvore
	fsm._ready()
	
	assert(fsm.current_state == idle, "O estado inicial da FSM deve ser o IdleState.")
	dummy_owner.queue_free()
	print(" -> test_fsm_initial_state: PASSED")

func test_health_depleted_transition() -> void:
	var wolf = WolfEnemy.new()
	add_child(wolf)
	
	var health = HealthComponent.new()
	health.name = "HealthComponent"
	wolf.add_child(health)
	
	var fsm = EnemyStateMachine.new()
	fsm.name = "StateMachine"
	
	var dead = DeadState.new()
	dead.name = "Dead"
	fsm.add_child(dead)
	wolf.add_child(fsm)
	
	# Vincula o nó do HealthComponent ao script do Wolf e inicializa a FSM
	wolf.health_component = health
	wolf.state_machine = fsm
	fsm._ready()
	
	# Garante a conexão do sinal de morte
	if not health.health_depleted.is_connected(wolf._on_health_depleted):
		health.health_depleted.connect(wolf._on_health_depleted)
	
	# Executa o dano letal
	health.take_damage(40.0)
	
	assert(fsm.current_state == dead, "Zerar a vida deve transicionar a FSM imediatamente para DeadState.")
	wolf.queue_free()
	print(" -> test_health_depleted_transition: PASSED")
