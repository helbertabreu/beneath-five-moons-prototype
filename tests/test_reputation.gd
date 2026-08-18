# res://tests/test_reputation.gd
extends Node

## Script de Validação Técnica Automatizada para a TASK-001 (Sistema de Reputação)

func _ready() -> void:
	print("\n==================================================")
	print("INICIANDO SUÍTE DE TESTES: TASK-001 (REPUTAÇÃO)")
	print("==================================================")
	
	_test_limits_and_clamping()
	_test_rank_progression()
	_test_faction_resource_discount()
	_test_governance_eligibility()
	
	print("==================================================")
	print("TODOS OS TESTES DE REPUTAÇÃO FORAM CONCLUÍDOS!")
	print("==================================================\n")


func _test_limits_and_clamping() -> void:
	print("\n[TESTE 1] Limites e Clamping (0 a 10.000):")
	
	ReputationManager.set_reputation("vilarejo", 0)
	assert(ReputationManager.get_reputation("vilarejo") == 0, "ERRO: Reputação inicial deveria ser 0.")
	
	# Teste de Estouro Superior
	ReputationManager.add_reputation("vilarejo", 15000)
	var max_rep: int = ReputationManager.get_reputation("vilarejo")
	assert(max_rep == 10000, "ERRO: Clamping máximo falhou! Valor obtido: %d" % max_rep)
	print("  ✓ Clamping Superior (Max 10.000): OK (%d pts)" % max_rep)
	
	# Teste de Estouro Inferior
	ReputationManager.add_reputation("vilarejo", -20000)
	var min_rep: int = ReputationManager.get_reputation("vilarejo")
	assert(min_rep == 0, "ERRO: Clamping mínimo falhou! Valor obtido: %d" % min_rep)
	print("  ✓ Clamping Inferior (Min 0): OK (%d pts)" % min_rep)


func _test_rank_progression() -> void:
	print("\n[TESTE 2] Progressão dos 5 Ranks do GDD:")
	
	var test_cases: Array[Dictionary] = [
		{"rep": 500, "expected_rank": "Desconhecido", "expected_mult": 1.00},
		{"rep": 1500, "expected_rank": "Reconhecido", "expected_mult": 0.95},
		{"rep": 4000, "expected_rank": "Respeitado", "expected_mult": 0.90},
		{"rep": 7500, "expected_rank": "Ilustre", "expected_mult": 0.85},
		{"rep": 9500, "expected_rank": "Elegível (Líder)", "expected_mult": 0.80}
	]
	
	for test in test_cases:
		ReputationManager.set_reputation("vilarejo", test["rep"])
		var current_rank_name: String = ReputationManager.get_reputation_level("vilarejo")
		var current_mult: float = ReputationManager.get_price_multiplier("vilarejo", null)
		
		assert(current_rank_name == test["expected_rank"], "ERRO: Rank incorreto para %d pts." % test["rep"])
		assert(is_equal_approx(current_mult, test["expected_mult"]), "ERRO: Multiplicador incorreto para %d pts." % test["rep"])
		
		print("  ✓ %d pts -> Rank: %s | Desconto: %.2f (OK)" % [test["rep"], current_rank_name, current_mult])


func _test_faction_resource_discount() -> void:
	print("\n[TESTE 3] Desconto via FactionData Resource:")
	
	var faction: FactionData = FactionData.new()
	faction.faction_id = "vilarejo"
	
	ReputationManager.set_reputation("vilarejo", 9000)
	var modifier: float = faction.get_price_modifier(ReputationManager.get_reputation("vilarejo"))
	assert(is_equal_approx(modifier, 0.80), "ERRO: FactionData deveria retornar 0.80 para rank Elegível.")
	print("  ✓ FactionData Modificador de Preço (Rank Elegível): OK (%.2f)" % modifier)


func _test_governance_eligibility() -> void:
	print("\n[TESTE 4] Pré-requisito de Governança (9.000+ pts):")
	
	ReputationManager.set_reputation("vilarejo", 8999)
	assert(not ReputationManager.is_eligible_for_governance("vilarejo"), "ERRO: Não deveria ser elegível com 8.999 pts.")
	print("  ✓ 8.999 pts -> Elegibilidade: FALSE (OK)")
	
	ReputationManager.set_reputation("vilarejo", 9000)
	assert(ReputationManager.is_eligible_for_governance("vilarejo"), "ERRO: Deveria ser elegível com 9.000 pts.")
	print("  ✓ 9.000 pts -> Elegibilidade: TRUE (OK)")
