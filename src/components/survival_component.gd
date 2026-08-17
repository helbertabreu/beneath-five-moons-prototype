# res://src/components/survival_component.gd
class_name SurvivalComponent
extends Node

## Gerencia Fome, Energia, Fadiga e penalidades de atributos do Jogador.

@export var max_hunger: float = 100.0
@export var base_max_energy: float = 100.0

var current_hunger: float = 100.0
var current_energy: float = 100.0
var accumulated_fatigue: float = 0.0 # Reduz o limite máximo de energia (0.0 a 0.5)

func _ready() -> void:
	# Garante que o jogador inicie o jogo com 100% dos status
	current_hunger = max_hunger
	current_energy = get_effective_max_energy()
	
	# Conecta com a virada de dia do TimeManager para processar a Fadiga
	EventBus.day_changed.connect(_on_day_changed)
	
	# Emite o estado inicial para a UI de forma segura após a montagem da árvore
	call_deferred("_update_all_signals")

func get_effective_max_energy() -> float:
	return base_max_energy * (1.0 - accumulated_fatigue)

func consume_resources_for_action(base_hunger_cost: float, base_energy_cost: float, action_time_minutes: int) -> bool:
	# Checa se o jogador pode realizar a ação
	if current_energy < base_energy_cost:
		return false
		
	# Calcula multiplicadores por faixa de Fome
	var hunger_time_multiplier: float = 1.0
	var energy_cost_multiplier: float = 1.0
	
	if current_hunger <= 0.0: # Estado Crítico
		return false
	elif current_hunger <= 10.0: # Faminto
		energy_cost_multiplier = 2.0
		hunger_time_multiplier = 2.0
	elif current_hunger <= 30.0: # Com Fome
		hunger_time_multiplier = 1.5
	elif current_hunger > 80.0: # Alimentado (+10% eficiência)
		hunger_time_multiplier = 0.85
		
	# Aplica consumo
	var final_energy_cost: float = base_energy_cost * energy_cost_multiplier
	current_energy = clampf(current_energy - final_energy_cost, 0.0, get_effective_max_energy())
	current_hunger = clampf(current_hunger - base_hunger_cost, 0.0, max_hunger)
	
	# Rastreia acúmulo de fadiga se trabalhar até tarde
	_check_fatigue_buildup()
	
	# Avança o tempo no relógio do ATS (com multiplicador de fome aplicado ao tempo)
	var final_time: int = int(ceil(action_time_minutes * hunger_time_multiplier))
	TimeManager.advance_time(final_time)
	
	_update_all_signals()
	return true

func consume_food(hunger_restore: float, energy_restore: float) -> void:
	current_hunger = clampf(current_hunger + hunger_restore, 0.0, max_hunger)
	current_energy = clampf(current_energy + energy_restore, 0.0, get_effective_max_energy())
	_update_all_signals()

func rest_in_campfire() -> void:
	# Pausa de 1 hora recupera +30 de energia
	current_energy = clampf(current_energy + 30.0, 0.0, get_effective_max_energy())
	TimeManager.advance_time(60)
	_update_all_signals()

func _check_fatigue_buildup() -> void:
	if TimeManager.is_overnight():
		# Desmaia se trabalhar até o período crítico
		_force_faint()
	elif TimeManager.is_late_night():
		# Aplica Fadiga Leve para o dia seguinte (-20% de energia máxima)
		accumulated_fatigue = maxf(accumulated_fatigue, 0.20)

func _force_faint() -> void:
	accumulated_fatigue = 0.50 # Acorda com -50% de energia
	current_energy = get_effective_max_energy()
	current_hunger = clampf(current_hunger - 20.0, 0.0, max_hunger)
	EventBus.player_fainted.emit()
	TimeManager.advance_time(360) # Pula tempo de exaustão

func _on_day_changed(_day_count: int, _season: String) -> void:
	# Processa renovação de dia
	current_hunger = clampf(current_hunger - 20.0, 0.0, max_hunger) # Custo do sono
	current_energy = get_effective_max_energy()
	
	# Reseta a fadiga acumulada para o próximo ciclo se repousou adequadamente
	if not TimeManager.is_late_night():
		accumulated_fatigue = 0.0
		
	_update_all_signals()

func _update_all_signals() -> void:
	EventBus.hunger_changed.emit(current_hunger, max_hunger)
	EventBus.energy_changed.emit(current_energy, get_effective_max_energy())
	EventBus.fatigue_changed.emit(accumulated_fatigue)
