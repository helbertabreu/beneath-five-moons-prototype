class_name GameAction
extends RefCounted
## Representa uma ação atômica no jogo com custos de tempo e sobrevivência.
##
## Encapsula os parâmetros e requisitos necessários para validação e execução
## no ActionSystem.

var action_id: String = ""
var time_cost: int = 0
var energy_cost: float = 0.0
var hunger_cost: float = 0.0
var fatigue_cost: float = 0.0
var metadata: Dictionary = {}

## Construtor para inicialização rápida da ação.
func _init(p_id: String = "", p_time: int = 0, p_energy: float = 0.0, p_hunger: float = 0.0, p_fatigue: float = 0.0, p_metadata: Dictionary = {}) -> void:
	action_id = p_id
	time_cost = p_time
	energy_cost = p_energy
	hunger_cost = p_hunger
	fatigue_cost = p_fatigue
	metadata = p_metadata
