extends Node

## Testes automatizados de regressão e validação da Tabela Expandida de Inimigos.

func _ready() -> void:
	print("[TEST] Iniciando Suíte de Testes da Expansão de Inimigos...")
	test_enemy_stats_initialization()
	test_enemy_inheritance()
	print("[TEST] TODOS OS TESTES PASSARAM COM SUCESSO!")

func test_enemy_stats_initialization() -> void:
	var goblin = GoblinEnemy.new()
	assert(goblin.monster_id == "ENM-003", "Erro: ID do Goblin incorreto")
	assert(goblin.max_hp == 80.0, "Erro: HP do Goblin incorreto")
	goblin.free()

	var orc = OrcEnemy.new()
	assert(orc.monster_id == "ENM-004", "Erro: ID do Orc incorreto")
	assert(orc.attack_damage == 30.0, "Erro: Dano do Orc incorreto")
	orc.free()

	var troll = TrollEnemy.new()
	assert(troll.monster_id == "ENM-005", "Erro: ID do Troll incorreto")
	assert(troll.max_hp == 450.0, "Erro: HP do Troll incorreto")
	troll.free()

	var warlord = WarlordBoss.new()
	assert(warlord.monster_id == "ENM-008", "Erro: ID do Warlord incorreto")
	assert(warlord.max_hp == 2500.0, "Erro: HP do Boss Warlord incorreto")
	warlord.free()

func test_enemy_inheritance() -> void:
	var wraith = WraithEnemy.new()
	assert(wraith is EnemyBase, "Erro: Wraith deve herdar de EnemyBase")
	wraith.free()
