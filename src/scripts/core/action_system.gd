class_name ActionSystem
extends RefCounted
## Sistema central de execução atômica de ações de jogo.
##
## Coordena o consumo de atributos de sobrevivência, o avanço temporal e a
## notificação de eventos desacoplados.

## Executa uma ação atômica aplicada a uma determinada entidade que possua SurvivalComponent.
static func execute_action(action: GameAction, actor: Node) -> bool:
	if actor == null:
		push_error("ActionSystem: Ator inválido fornecido para execute_action.")
		return false
		
	# Busca dinâmica por qualquer nó filho que seja da classe SurvivalComponent
	var survival: SurvivalComponent = _find_survival_component(actor)
	
	if survival == null and (action.energy_cost > 0.0 or action.hunger_cost > 0.0):
		push_error("ActionSystem: Ator não possui SurvivalComponent.")
		return false

	# Validação prévia
	var validation: Dictionary = ActionValidator.validate_action(action, survival)
	if not validation.get("valid", false):
		if EventBus != null:
			EventBus.emit_signal("action_failed", action.action_id, validation.get("reason", "Ação recusada."))
		return false

	# 1. Consumo de atributos de sobrevivência
	if survival != null:
		if action.energy_cost > 0.0:
			survival.consume_energy(action.energy_cost)
		if action.hunger_cost > 0.0:
			survival.consume_hunger(action.hunger_cost)

	# 2. Avanço temporal via TimeManager
	if action.time_cost > 0 and TimeManager != null:
		TimeManager.advance_time(action.time_cost)

	# 3. Notificação desacoplada via EventBus
	if EventBus != null:
		EventBus.emit_signal("action_executed", action.action_id, action.time_cost)

	return true

## Auxiliar privado para localizar o SurvivalComponent independente do nome do nó.
static func _find_survival_component(actor: Node) -> SurvivalComponent:
	# Tentativa 1: Busca rápida por nome padrão
	var comp: SurvivalComponent = actor.get_node_or_null("SurvivalComponent") as SurvivalComponent
	if comp != null:
		return comp
		
	# Tentativa 2: Iteração nos filhos procurando por tipo
	for child in actor.get_children():
		if child is SurvivalComponent:
			return child as SurvivalComponent
			
	return null
