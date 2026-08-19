class_name TestActionSystem
extends Node
## Suíte de testes unitários automatizados para validação da Sprint 01 (Action System & Survival).

func _ready() -> void:
	run_all_tests()

func run_all_tests() -> void:
	print("[TEST-SUITE] Iniciando testes do ActionSystem e SurvivalComponent...")
	test_atomic_action_execution()
	test_critical_hunger_blocking()
	test_insufficient_energy_blocking()
	print("[TEST-SUITE] Todos os testes passaram com SUCESSO!")

func test_atomic_action_execution() -> void:
	var dummy_actor = Node.new()
	var survival = SurvivalComponent.new()
	survival.name = "SurvivalComponent"
	dummy_actor.add_child(survival)
	add_child(dummy_actor)
	
	survival.current_energy = 100.0
	survival.current_hunger = 100.0
	var initial_time = TimeManager.get_total_minutes()
	
	var action = GameAction.new("test_gather", 15, 10.0, 2.0)
	var success = ActionSystem.execute_action(action, dummy_actor)
	
	assert(success == true, "Ação deveria ter sido executada.")
	assert(survival.current_energy == 90.0, "Energia deveria ter reduzido em 10.")
	assert(survival.current_hunger == 98.0, "Fome deveria ter reduzido em 2.")
	assert(TimeManager.get_total_minutes() == initial_time + 15, "Relógio deveria ter avançado 15 min.")
	
	dummy_actor.queue_free()
	print(" -> test_atomic_action_execution: PASSED")

func test_critical_hunger_blocking() -> void:
	var dummy_actor = Node.new()
	var survival = SurvivalComponent.new()
	survival.name = "SurvivalComponent"
	dummy_actor.add_child(survival)
	add_child(dummy_actor)
	
	survival.current_hunger = 0.0 # Estado Crítico
	
	var action = GameAction.new("heavy_work", 30, 20.0, 5.0)
	var success = ActionSystem.execute_action(action, dummy_actor)
	
	assert(success == false, "Ação física deveria ser bloqueada em fome crítica.")
	
	dummy_actor.queue_free()
	print(" -> test_critical_hunger_blocking: PASSED")

func test_insufficient_energy_blocking() -> void:
	var dummy_actor = Node.new()
	var survival = SurvivalComponent.new()
	survival.name = "SurvivalComponent"
	dummy_actor.add_child(survival)
	add_child(dummy_actor)
	
	survival.current_energy = 5.0
	
	var action = GameAction.new("expensive_action", 15, 20.0, 1.0)
	var success = ActionSystem.execute_action(action, dummy_actor)
	
	assert(success == false, "Ação deveria ser bloqueada por energia insuficiente.")
	
	dummy_actor.queue_free()
	print(" -> test_insufficient_energy_blocking: PASSED")
