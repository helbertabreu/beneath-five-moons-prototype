class_name TestDropSystem
extends Node
## Suíte de testes automatizados para validação do DropSystem.

func _ready() -> void:
	run_all_tests()

func run_all_tests() -> void:
	print("[TEST-SUITE] Iniciando testes do DropSystem...")
	test_guaranteed_and_zero_drop()
	test_quantity_limits()
	test_independent_roll_mode()
	test_exclusive_roll_mode()
	test_statistical_convergence()
	print("[TEST-SUITE] Todos os testes do DropSystem passaram com SUCESSO!")

func test_guaranteed_and_zero_drop() -> void:
	var table = DropTableData.new()
	var entry_100 = DropEntryData.new("copper_ore", 1.0, 1, 1, true)
	var entry_0 = DropEntryData.new("diamond", 0.0, 1, 1, false)
	
	var typed_entries: Array[DropEntryData] = [entry_100, entry_0]
	table.entries = typed_entries
	
	var drops = DropSystem.evaluate_drop_table(table)
	assert(drops.size() == 1, "Apenas o item garantido deveria ter caído.")
	assert(drops[0]["item_id"] == "copper_ore", "O item obtido deve ser copper_ore.")
	print(" -> test_guaranteed_and_zero_drop: PASSED")

func test_quantity_limits() -> void:
	var table = DropTableData.new()
	var entry = DropEntryData.new("wood", 1.0, 3, 7, true)
	
	var typed_entries: Array[DropEntryData] = [entry]
	table.entries = typed_entries
	
	for i in range(50):
		var drops = DropSystem.evaluate_drop_table(table)
		var qty = drops[0]["amount"]
		assert(qty >= 3 and qty <= 7, "A quantidade gerada deve estar estritamente entre 3 e 7.")
	print(" -> test_quantity_limits: PASSED")

func test_independent_roll_mode() -> void:
	var table = DropTableData.new()
	table.roll_mode = DropTableData.RollMode.INDEPENDENT
	
	var typed_entries: Array[DropEntryData] = [
		DropEntryData.new("item_a", 1.0, 1, 1, true),
		DropEntryData.new("item_b", 1.0, 1, 1, true)
	]
	table.entries = typed_entries
	
	var drops = DropSystem.evaluate_drop_table(table)
	assert(drops.size() == 2, "No modo INDEPENDENT ambos os itens 100% devem ser sorteados.")
	print(" -> test_independent_roll_mode: PASSED")

func test_exclusive_roll_mode() -> void:
	var table = DropTableData.new()
	table.roll_mode = DropTableData.RollMode.EXCLUSIVE
	
	var typed_entries: Array[DropEntryData] = [
		DropEntryData.new("item_a", 1.0, 1, 1, true),
		DropEntryData.new("item_b", 1.0, 1, 1, true)
	]
	table.entries = typed_entries
	
	var drops = DropSystem.evaluate_drop_table(table)
	assert(drops.size() == 1, "No modo EXCLUSIVE apenas um item deve ser sorteado.")
	print(" -> test_exclusive_roll_mode: PASSED")

func test_statistical_convergence() -> void:
	var table = DropTableData.new()
	table.roll_mode = DropTableData.RollMode.INDEPENDENT
	var entry = DropEntryData.new("rare_drop", 0.10, 1, 1, false)
	
	var typed_entries: Array[DropEntryData] = [entry]
	table.entries = typed_entries
	
	var success_count: int = 0
	var iterations: int = 1000
	
	for i in range(iterations):
		var drops = DropSystem.evaluate_drop_table(table)
		if drops.size() > 0:
			success_count += 1
			
	# Espera-se ~100 acertos em 1000 tentativas (tolerância entre 60 e 140)
	assert(success_count >= 60 and success_count <= 140, "A convergência estatística deve ficar próxima de 10%.")
	print(" -> test_statistical_convergence: PASSED")
