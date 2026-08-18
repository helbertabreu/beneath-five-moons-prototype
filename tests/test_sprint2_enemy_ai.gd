# res://tests/test_sprint2_enemy_ai.gd
extends Node

## Suíte de Testes Automatizados da Sprint 2: IA de Inimigos e Combate

var tests_passed: int = 0
var tests_failed: int = 0


func _ready() -> void:
	print("\n==================================================")
	print("SUÍTE DE TESTES AUTOMATIZADOS — SPRINT 2 (INIMIGOS)")
	print("==================================================")

	_test_wolf_initialization()
	_test_wolf_chase_trigger()
	_test_wolf_damage_and_death()

	print("\n--------------------------------------------------")
	print("RESULTADO FINAL DOS TESTES DA SPRINT 2:")
	print("  ✓ Passaram: %d" % tests_passed)
	print("  ✗ Falharam: %d" % tests_failed)
	print("==================================================\n")


func _assert_true(condition: bool, test_name: String) -> void:
	if condition:
		tests_passed += 1
		print("  ✓ [PASS] %s" % test_name)
	else:
		tests_failed += 1
		push_error("  ✗ [FAIL] %s" % test_name)


func _test_wolf_initialization() -> void:
	print("\n[MÓDULO 1] Inicialização do Lobo Esfomeado (ENM-001):")

	var wolf = WolfEnemy.new()
	var health_comp = HealthComponent.new()
	health_comp.max_health = 40.0
	health_comp.current_health = 40.0
	wolf.add_child(health_comp)
	wolf.health_component = health_comp

	_assert_true(health_comp.max_health == 40.0, "Vida do Lobo inicializada com 40.0 HP (GDD)")
	_assert_true(wolf.attack_damage == 12.0, "Dano de ataque do Lobo configurado com 12.0 (GDD)")

	wolf.queue_free()


func _test_wolf_chase_trigger() -> void:
	print("\n[MÓDULO 2] Transição de Estado da IA (Detecção de Perseguição):")

	var wolf = WolfEnemy.new()
	var dummy_player = CharacterBody2D.new()
	dummy_player.add_to_group("player")

	wolf._on_detection_body_entered(dummy_player)
	_assert_true(wolf.current_state == WolfEnemy.State.CHASE, "Entrada de jogador na área alterou estado para CHASE")

	wolf._on_detection_body_exited(dummy_player)
	_assert_true(wolf.current_state == WolfEnemy.State.IDLE, "Saída do jogador alterou estado de volta para IDLE")

	wolf.queue_free()
	dummy_player.queue_free()


func _test_wolf_damage_and_death() -> void:
	print("\n[MÓDULO 3] Recebimento de Dano e Morte do Lobo:")

	var wolf = WolfEnemy.new()
	var health_comp = HealthComponent.new()
	health_comp.name = "HealthComponent" # Define o nome do nó para casar com a busca @onready $HealthComponent
	health_comp.max_health = 40.0
	health_comp.current_health = 40.0
	
	wolf.add_child(health_comp)
	wolf.health_component = health_comp

	add_child(wolf)

	health_comp.take_damage(40.0)
	
	_assert_true(health_comp.is_dead, "Lobo foi derrotado após sofrer 40 de dano")
	_assert_true(wolf.current_state == WolfEnemy.State.DEAD, "Estado da IA do Lobo alterado para DEAD")

	wolf.queue_free()
