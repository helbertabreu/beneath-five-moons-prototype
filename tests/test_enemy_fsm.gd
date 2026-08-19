extends Node

## Suíte de testes para validar a FSM dos inimigos.
## Sincronizado com o ciclo de física para garantir a conclusão da transição para DeadState.

func _ready() -> void:
	print("--- INICIANDO TESTE: TestEnemyFSM ---")
	await test_health_depleted_transition()
	print("--- TESTE FINALIZADO COM SUCESSO ---")

func test_health_depleted_transition() -> void:
	print("[TESTE] Instanciando inimigo (NightBandit)...")
	# Arrange
	var enemy_scene = preload("res://src/entities/enemies/night_bandit.tscn")
	assert(enemy_scene != null, "A cena night_bandit.tscn deve existir.")
	
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	# Aguarda os frames de inicialização da árvore de nós e física
	await get_tree().process_frame
	await get_tree().physics_frame
	
	var health = enemy.get_node_or_null("HealthComponent")
	var state_machine = enemy.get_node_or_null("StateMachine")
	
	assert(health != null, "O HealthComponent deve estar presente no inimigo.")
	assert(state_machine != null, "A StateMachine deve estar presente no inimigo.")
	
	print("[TESTE] HP inicial: ", health.current_health)
	
	# Act
	print("[TESTE] Aplicando dano letal...")
	health.take_damage(health.max_health + 50)
	
	# Aguarda o processamento de física para que a FSM execute a transição reativa ao sinal
	await get_tree().process_frame
	await get_tree().physics_frame
	
	# Assert / Validação
	var current_state = state_machine.current_state
	assert(current_state != null, "O estado atual da FSM não deveria ser nulo após o dano letal.")
	
	var current_state_name = current_state.name
	print("[TESTE] Estado atual da FSM após dano: ", current_state_name)
	
	var is_dead = (current_state_name.to_lower().contains("dead"))
	assert(is_dead, "O estado atual da FSM deveria ser de morte (DeadState).")
	
	print("[TESTE] Assertiva validada com sucesso: Inimigo transicionou para o estado de morte.")
	enemy.queue_free()
