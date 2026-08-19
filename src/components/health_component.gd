class_name HealthComponent
extends Node

## Emitido sempre que a vida sofre alteração (dano ou cura).
signal health_changed(current_health: float, max_health: float)

## Emitido imediatamente quando a vida atinge ou fica abaixo de zero.
signal health_depleted

@export var max_health: float = 100.0
@onready var current_health: float = max_health

func _ready() -> void:
	current_health = max_health

## Aplica dano à entidade, atualiza o valor atual e dispara os sinais correspondentes.
## O parâmetro opcional [param attacker] permite rastrear a origem do dano para sistemas de combate/agronegócio.
func take_damage(amount: float, attacker: Node = null) -> void:
	if current_health <= 0.0:
		return
		
	current_health = max(0.0, current_health - amount)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health <= 0.0:
		emit_signal("health_depleted")

## Restaura a vida da entidade respeitando o limite máximo.
func heal(amount: float) -> void:
	if current_health <= 0.0:
		return
		
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health, max_health)
