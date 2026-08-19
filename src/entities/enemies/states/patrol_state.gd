class_name PatrolState
extends State
## Estado de patrulha para inimigos.
##
## Movimenta o inimigo até um ponto aleatório de patrulha a uma velocidade reduzida.

@export var patrol_speed: float = 50.0
@export var max_patrol_distance: float = 120.0

var _target_position: Vector2
var _actor: CharacterBody2D
var _origin_position: Vector2

func enter(_msg: Dictionary = {}) -> void:
	_actor = owner as CharacterBody2D
	if _actor != null:
		if _origin_position == Vector2.ZERO:
			_origin_position = _actor.global_position
		_pick_random_target()

func physics_update(_delta: float) -> void:
	if _actor == null:
		return

	# Checagem prioritária para perseguir o Player se detectado
	if _check_player_in_range():
		state_machine.transition_to("chase")
		return

	var direction: Vector2 = (_target_position - _actor.global_position).normalized()
	_actor.velocity = direction * patrol_speed
	_actor.move_and_slide()

	if _actor.global_position.distance_to(_target_position) < 8.0:
		state_machine.transition_to("idle")

func _pick_random_target() -> void:
	var random_offset: Vector2 = Vector2(
		randf_range(-max_patrol_distance, max_patrol_distance),
		randf_range(-max_patrol_distance, max_patrol_distance)
	)
	_target_position = _origin_position + random_offset

func _check_player_in_range() -> bool:
	if _actor == null:
		return false
	var detection_area: Area2D = _actor.get_node_or_null("DetectionArea") as Area2D
	if detection_area != null:
		for body in detection_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				return true
	return false
