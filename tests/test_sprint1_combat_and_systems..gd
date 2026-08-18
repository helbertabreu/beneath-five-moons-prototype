# res://tests/test_sprint1_combat_and_systems.gd
extends Node

## Suíte de Testes Automatizados da Sprint 1: Combate, Reputação e Avanço de Tempo (ATS)

var tests_passed: int = 0
var tests_failed: int = 0


func _ready() -> void:
	print("\n==================================================")
	print("SUÍTE DE TESTES AUTOMATIZADOS — SPRINT 1")
	print("==================================================")

	_test_health_component()
	_test_hitbox_hurtbox_integration()
	_test_reputation_system_scaling()
	_test_time_manager_fast_forward()

	print("\n--------------------------------------------------")
	print("RESULTADO FINAL DOS TESTES:")
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


func _test_health_component() -> void:
	print("\n[MÓDULO 1] Testes do HealthComponent:")

	var health_comp = HealthComponent.new()
	health_comp.max_health = 100.0
	health_comp.current_health = 100.0
	add_child(health_comp)

	_assert_true(health_comp.current_health == 100.0, "Inicialização de vida com 100 HP")

	# Teste de Aplicação de Dano
	health_comp.take_damage(30.0)
	_assert_true(health_comp.current_health == 70.0, "Aplicação de 30 de dano (HP restante: 70)")

	# Teste de Cura
	health_comp.heal(20.0)
	_assert_true(health_comp.current_health == 90.0, "Cura de 20 HP (HP restante: 90)")

	# Teste de Morte com Rastreamento por Referência (Dicionário)
	var signal_tracker: Dictionary = {"died": false}
	health_comp.died.connect(func(): signal_tracker["died"] = true)
	health_comp.take_damage(100.0)

	_assert_true(health_comp.current_health == 0.0, "Vida reduzida a zero ao sofrer dano fatal")
	_assert_true(health_comp.is_dead, "Flag is_dead alterada para true")
	_assert_true(signal_tracker["died"], "Sinal 'died' emitido com sucesso")

	health_comp.queue_free()


func _test_hitbox_hurtbox_integration() -> void:
	print("\n[MÓDULO 2] Testes de Integração Hitbox/Hurtbox:")

	var dummy_target = Node2D.new()
	var health_comp = HealthComponent.new()
	health_comp.max_health = 50.0
	health_comp.current_health = 50.0
	dummy_target.add_child(health_comp)

	var hurtbox = HurtboxComponent.new()
	hurtbox.health_component = health_comp
	dummy_target.add_child(hurtbox)

	add_child(dummy_target)

	# Simula impacto direto recebido pela Hurtbox
	hurtbox.receive_hit(25.0, Vector2.ZERO, self)
	_assert_true(health_comp.current_health == 25.0, "Hurtbox repassou 25 de dano para o HealthComponent")

	# Teste de Invulnerabilidade
	hurtbox.is_invulnerable = true
	hurtbox.receive_hit(25.0, Vector2.ZERO, self)
	_assert_true(health_comp.current_health == 25.0, "Hurtbox invulnerável ignorou o dano recebido")

	dummy_target.queue_free()


func _test_reputation_system_scaling() -> void:
	print("\n[MÓDULO 3] Testes do Sistema de Reputação (0 a 10.000):")

	ReputationManager.set_reputation("vilarejo", 0)
	_assert_true(ReputationManager.get_rank("vilarejo") == ReputationManager.Rank.DESCONHECIDO, "0 pts -> Rank DESCONHECIDO")
	_assert_true(is_equal_approx(ReputationManager.get_price_multiplier("vilarejo", null), 1.00), "0 pts -> Multiplicador 1.00 (Sem desconto)")

	ReputationManager.set_reputation("vilarejo", 3500)
	_assert_true(ReputationManager.get_rank("vilarejo") == ReputationManager.Rank.RESPEITADO, "3.500 pts -> Rank RESPEITADO")
	_assert_true(is_equal_approx(ReputationManager.get_price_multiplier("vilarejo", null), 0.90), "3.500 pts -> 10% Desconto (Mult 0.90)")

	ReputationManager.set_reputation("vilarejo", 9500)
	_assert_true(ReputationManager.get_rank("vilarejo") == ReputationManager.Rank.ELEGIVEL, "9.500 pts -> Rank ELEGÍVEL")
	_assert_true(ReputationManager.is_eligible_for_governance("vilarejo"), "9.500 pts -> Elegível para Governança = TRUE")


func _test_time_manager_fast_forward() -> void:
	print("\n[MÓDULO 4] Teste do TimeManager (Fast-Forward Múltiplos Dias):")

	var initial_day: int = TimeManager.current_day
	var days_to_skip: int = 3
	TimeManager.advance_time(days_to_skip * 1440)

	var expected_day: int = initial_day + days_to_skip
	_assert_true(TimeManager.current_day == expected_day, "Avanço de %d dias incrementou o calendário de %d para %d" % [days_to_skip, initial_day, TimeManager.current_day])
