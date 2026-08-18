# res://src/components/health_component.gd
class_name HealthComponent
extends Node

## Gerencia a vida, aplicação de dano, cura e estado de morte de qualquer entidade.

signal health_changed(current_health: float, max_health: float)
signal damage_taken(amount: float, attacker: Node)
signal healed(amount: float)
signal died

@export var max_health: float = 100.0:
	set(value):
		max_health = maxf(1.0, value)
		current_health = minf(current_health, max_health)
		health_changed.emit(current_health, max_health)

var current_health: float = 100.0
var is_dead: bool = false


func _ready() -> void:
	current_health = max_health


## Aplica dano à entidade considerando invulnerabilidade ou resistência
func take_damage(amount: float, attacker: Node = null) -> void:
	if is_dead or amount <= 0.0:
		return

	current_health = clampf(current_health - amount, 0.0, max_health)
	print("COMBATE: %s recebeu %.1f de dano. (HP Restante: %.1f/%.1f)" % [get_parent().name, amount, current_health, max_health])
	
	health_changed.emit(current_health, max_health)
	damage_taken.emit(amount, attacker)

	# Solficta texto flutuante de dano na HUD/Tela se disponível
	EventBus.floating_text_requested.emit("-%.0f" % amount, get_parent_global_position(), Color.INDIAN_RED)

	if current_health <= 0.0 and not is_dead:
		_die()


## Restaura vida da entidade
func heal(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return

	current_health = clampf(current_health + amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)
	healed.emit(amount)

	# Solicita texto flutuante de cura na HUD/Tela se disponível
	EventBus.floating_text_requested.emit("+%.0f" % amount, get_parent_global_position(), Color.LIGHT_GREEN)


func _die() -> void:
	is_dead = true
	print("COMBATE: Entidade '%s' foi derrotada!" % get_parent().name)
	died.emit()


## Retorna a posição global da entidade pai de forma defensiva
func get_parent_global_position() -> Vector2:
	var parent_node = get_parent()
	if parent_node is Node2D:
		return parent_node.global_position
	return Vector2.ZERO


## Serialização para Save/Load
func get_save_data() -> Dictionary:
	return {
		"current_health": current_health,
		"max_health": max_health,
		"is_dead": is_dead
	}


func load_save_data(data: Dictionary) -> void:
	max_health = float(data.get("max_health", 100.0))
	current_health = float(data.get("current_health", max_health))
	is_dead = bool(data.get("is_dead", false))
	health_changed.emit(current_health, max_health)
