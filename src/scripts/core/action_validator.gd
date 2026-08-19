## 2. Novo Script: `src/scripts/core/action_validator.gd`
# Validador estático responsável por checar as precondições do jogador (`SurvivalComponent`) antes de permitir a execução.

class_name ActionValidator
extends RefCounted
## Validador de pré-requisitos para execução de ações de jogo.
##
## Verifica se a entidade possui energia e nutrição suficientes e se não está
## impedida por estado crítico conforme o GDD.

## Valida se a ação pode ser executada por determinado SurvivalComponent.
## Retorna um Dictionary com chave 'valid' (bool) e 'reason' (String).
static func validate_action(action: GameAction, survival: SurvivalComponent) -> Dictionary:
	if survival == null:
		return {"valid": false, "reason": "SurvivalComponent ausente"}
	
	# GDD Seção 8: Fome = 0 (Estado Crítico) bloqueia qualquer esforço físico
	if survival.current_hunger <= 0.0 and (action.energy_cost > 0.0 or action.hunger_cost > 0.0):
		return {"valid": false, "reason": "Jogador em estado crítico por fome. Ação física bloqueada."}
	
	# Verifica se há energia suficiente para a ação
	if survival.current_energy < action.energy_cost:
		return {"valid": false, "reason": "Energia insuficiente para realizar a ação."}
		
	return {"valid": true, "reason": "OK"}
# [cite: 1, 6]
