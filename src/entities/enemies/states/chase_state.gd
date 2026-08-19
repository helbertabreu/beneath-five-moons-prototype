class_name ChaseState
extends State
## Estado de perseguição de inimigos.
##
## Persegue o jogador utilizando os parâmetros de velocidade e alcance definidos no GDD[cite: 4].

@export var chase_speed: float = 110.0
@export var attack_range: float = 35.0

var _actor: CharacterBody2D
var _target_player: Node2D

func enter(_msg: Dictionary = {}) -> void:
	_actor = owner as CharacterBody2D
	_find_player()

func physics_update(_delta: float) -> void:
	if _actor == null:
		return

	if _target_player == null or not is_instance_valid(_target_player):
		_find_player()
		if _target_player == null:
			state_machine.transition_to("idle")
			return

	var distance: float = _actor.global_position.distance_to(_target_player.global_position)

	# Transiciona para ataque ao atingir o alcance estipulado no GDD (35px para o Lobo)[cite: 4]
	if distance <= attack_range:
		state_machine.transition_to("attack", {"target": _target_player})
		return

	# Se o player se afastar além da área de detecção, volta para Idle
	if distance > 220.0:
		state_machine.transition_to("idle")
		return

	var direction: Vector2 = (_target_player.global_position - _actor.global_position).normalized()
	_actor.velocity = direction * chase_speed
	_actor.move_and_slide()

func _find_player() -> void:
	if _actor == null:
		return
	var detection_area: Area2D = _actor.get_node_or_null("DetectionArea") as Area2D
	if detection_area != null:
		for body in detection_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				_target_player = body as Node2D
				return
