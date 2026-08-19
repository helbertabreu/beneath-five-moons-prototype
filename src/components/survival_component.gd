## 6. Refatoração: `src/components/survival_component.gd`
# Ajuste das 5 faixas de fome e penalidades do GDD Seção 8 e 10[cite: 1, 6].

class_name SurvivalComponent
extends Node
## Componente responsável pela gestão do estado biológico do jogador (Fome, Energia e Fadiga).

@export var max_hunger: float = 100.0
@export var current_hunger: float = 100.0

@export var max_energy: float = 100.0
@export var current_energy: float = 100.0

# Modificador temporário de energia máxima diária por penalidade noturna
var energy_max_modifier: float = 1.0

## Enum que reflete as 5 faixas de fome estipuladas no GDD Seção 8.
enum HungerState {
	FULL,      # 81–100 (+10% eficiência)
	NORMAL,    # 31–80  (Sem modificador)
	HUNGRY,    # 11–30  (+50% tempo de trabalho)
	STARVING,  # 1–10   (+100% tempo / 2x consumo de Energia)
	CRITICAL   # 0      (Bloqueia esforço físico)
}

func _ready() -> void:
	if EventBus != null:
		EventBus.day_started.connect(_on_day_started)

## Consome uma quantidade de fome.
func consume_hunger(amount: float) -> void:
	var multiplier: float = 1.0
	if get_hunger_state() == HungerState.STARVING:
		multiplier = 2.0 # GDD Seção 8: No estado Faminto, gasta o dobro de energia/fome
		
	current_hunger = clamp(current_hunger - (amount * multiplier), 0.0, max_hunger)
	if EventBus != null:
		EventBus.emit_signal("hunger_changed", current_hunger, max_hunger)
		EventBus.emit_signal("hunger_state_changed", HungerState.keys()[get_hunger_state()])

## Restaura fome do jogador.
func restore_hunger(amount: float) -> void:
	current_hunger = clamp(current_hunger + amount, 0.0, max_hunger)
	if EventBus != null:
		EventBus.emit_signal("hunger_changed", current_hunger, max_hunger)

## Consome energia do jogador.
func consume_energy(amount: float) -> void:
	current_energy = clamp(current_energy - amount, 0.0, get_effective_max_energy())
	if EventBus != null:
		EventBus.emit_signal("energy_changed", current_energy, get_effective_max_energy())

## Restaura energia do jogador.
func restore_energy(amount: float) -> void:
	current_energy = clamp(current_energy + amount, 0.0, get_effective_max_energy())
	if EventBus != null:
		EventBus.emit_signal("energy_changed", current_energy, get_effective_max_energy())

## Retorna a faixa atual de fome com base na porcentagem de nutrição.
func get_hunger_state() -> HungerState:
	if current_hunger <= 0.0:
		return HungerState.CRITICAL
	elif current_hunger <= 10.0:
		return HungerState.STARVING
	elif current_hunger <= 30.0:
		return HungerState.HUNGRY
	elif current_hunger <= 80.0:
		return HungerState.NORMAL
	else:
		return HungerState.FULL

## Retorna a energia máxima aplicável com o modificador de penalidade diária.
func get_effective_max_energy() -> float:
	return max_energy * energy_max_modifier

## Aplica a penalidade noturna de trabalhar entre 22:00 e 02:00 (GDD Seção 10).
func apply_late_night_penalty() -> void:
	energy_max_modifier = 0.80 # -20% de energia máxima
	if EventBus != null:
		EventBus.emit_signal("fatigue_penalty_applied", 0.20)

## Executa a rotina de desmaio por exaustão às 06:00 (GDD Seção 10).
func trigger_faint_routine() -> void:
	if TimeManager != null:
		TimeManager.hour = 12
		TimeManager.minute = 0
	energy_max_modifier = 0.50 # Acorda ao meio-dia com apenas 50% de energia
	current_energy = get_effective_max_energy()
	if EventBus != null:
		EventBus.emit_signal("player_fainted")

func _on_day_started(_day_number: int) -> void:
	# Reseta modificador diário padrão no início do dia
	energy_max_modifier = 1.0
