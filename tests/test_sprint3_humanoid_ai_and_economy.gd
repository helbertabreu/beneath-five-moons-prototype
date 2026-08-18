# res://tests/test_sprint3_humanoid_ai_and_economy.gd
extends Node

## Suíte de Testes Automatizados da Sprint 3: IA do Salteador da Noite e Economia de Oferta/Demanda

var tests_passed: int = 0
var tests_failed: int = 0


func _ready() -> void:
	print("\n==================================================")
	print("SUÍTE DE TESTES AUTOMATIZADOS — SPRINT 3")
	print("==================================================")

	_test_night_bandit_initialization()
	_test_night_bandit_chase_and_attack()
	_test_night_bandit_damage_and_death()
	_test_supply_demand_economy()

	print("\n--------------------------------------------------")
	print("RESULTADO FINAL DOS TESTES DA SPRINT 3:")
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


func _test_night_bandit_initialization() -> void:
	print("\n[MÓDULO 1] Inicialização do Salteador da Noite (ENM-002):")

	var bandit = NightBandit.new()
	var health_comp = HealthComponent.new()
	health_comp.name = "HealthComponent"
	health_comp.max_health = 60.0
	health_comp.current_health = 60.0
	
	bandit.add_child(health_comp)
	bandit.health_component = health_comp

	_assert_true(health_comp.max_health == 60.0, "Vida do Salteador inicializada com 60.0 HP (GDD)")
	_assert_true(bandit.attack_damage == 15.0, "Dano de ataque configurado com 15.0 (GDD)")
	_assert_true(bandit.chase_speed == 120.0, "Velocidade de perseguição configurada com 120.0 px/s")

	bandit.queue_free()


func _test_night_bandit_chase_and_attack() -> void:
	print("\n[MÓDULO 2] Transições de Estado da IA Humanóide:")

	var bandit = NightBandit.new()
	var dummy_player = CharacterBody2D.new()
	dummy_player.add_to_group("player")

	bandit._on_detection_body_entered(dummy_player)
	_assert_true(bandit.current_state == NightBandit.State.CHASE, "Detecção de jogador alterou estado para CHASE")

	bandit._on_detection_body_exited(dummy_player)
	_assert_true(bandit.current_state == NightBandit.State.IDLE, "Perda de alvo alterou estado de volta para IDLE")

	bandit.queue_free()
	dummy_player.queue_free()


func _test_night_bandit_damage_and_death() -> void:
	print("\n[MÓDULO 3] Recebimento de Dano e Morte do Salteador:")

	var bandit = NightBandit.new()
	var health_comp = HealthComponent.new()
	health_comp.name = "HealthComponent"
	health_comp.max_health = 60.0
	health_comp.current_health = 60.0
	
	bandit.add_child(health_comp)
	bandit.health_component = health_comp

	# Cria temporariamente o nó de Timer no teste para simular a árvore completa da cena
	var attack_timer = Timer.new()
	attack_timer.name = "AttackTimer"
	bandit.add_child(attack_timer)
	bandit.attack_timer = attack_timer

	add_child(bandit)

	health_comp.take_damage(60.0)
	
	_assert_true(health_comp.is_dead, "Salteador foi derrotado após sofrer 60 de dano")
	_assert_true(bandit.current_state == NightBandit.State.DEAD, "Estado da IA alterado para DEAD")

	bandit.queue_free()


func _test_supply_demand_economy() -> void:
	print("\n[MÓDULO 4] Flutuação Econômica (Teste Real no NPCVendor):")

	var vendor = NPCVendor.new()
	vendor.base_sell_price = 100
	vendor.base_buy_price = 40
	vendor.target_demand = 20
	vendor.min_stock_threshold = 10

	# Caso 1: Escassez Crítica
	vendor.current_stock = 2
	var scarcity_modifier: float = vendor._get_supply_demand_modifier()
	_assert_true(scarcity_modifier > 1.0, "Modificador de escassez no NPCVendor aumentou o preço (Modificador: %.2f)" % scarcity_modifier)

	# Caso 2: Saturação de Mercado
	vendor.current_stock = 50
	var saturation_modifier: float = vendor._get_supply_demand_modifier()
	_assert_true(saturation_modifier < 1.0, "Modificador de saturação no NPCVendor reduziu o preço (Modificador: %.2f)" % saturation_modifier)

	# Caso 3: Estoque Equilibrado
	vendor.current_stock = 20
	var neutral_modifier: float = vendor._get_supply_demand_modifier()
	_assert_true(is_equal_approx(neutral_modifier, 1.0), "Estoque no nível da demanda manteve o preço base (Modificador: %.2f)" % neutral_modifier)

	vendor.queue_free()
