class_name IdleState
extends State
## Estado de repouso/aguardando para inimigos.
##
## Permanece parado temporariamente até decidir patrulhar ou detectar o jogador.

@export var idle_time_min: float = 1.5
@export var idle_time_max: float = 3.5

var _timer: float = 0.0
var _actor: CharacterBody2D

func enter(_msg: Dictionary = {}) -> void:
	_actor = owner as CharacterBody2D
	_timer = randf_range(idle_time_min, idle_time_max)
	if _actor != null:
		_actor.velocity = Vector2.ZERO

func update(delta: float) -> void:
	# Checagem de detecção de Player se o ator possuir a área
	if _check_player_in_range():
		state_machine.transition_to("chase")
		return

	_timer -= delta
	if _timer <= 0.0:
		state_machine.transition_to("patrol")

func _check_player_in_range() -> bool:
	if _actor == null:
		return false
	var detection_area: Area2D = _actor.get_node_or_null("DetectionArea") as Area2D
	if detection_area != null:
		for body in detection_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				return true
	return false
