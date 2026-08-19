class_name AttackState
extends State
## Estado de ataque para inimigos.
##
## Executa o golpe contra o jogador, ativa o HitboxComponent temporariamente e respeita o cooldown de ataque[cite: 1, 4].

@export var attack_cooldown: float = 1.5
@export var attack_damage: float = 12.0

var _actor: CharacterBody2D
var _target_player: Node2D
var _cooldown_timer: float = 0.0
var _has_attacked: bool = false

func enter(msg: Dictionary = {}) -> void:
	_actor = owner as CharacterBody2D
	if msg.has("target"):
		_target_player = msg["target"] as Node2D
	_cooldown_timer = 0.0
	_has_attacked = false
	if _actor != null:
		_actor.velocity = Vector2.ZERO

func update(delta: float) -> void:
	if not _has_attacked:
		_perform_attack()
		_has_attacked = true
		
	_cooldown_timer += delta
	if _cooldown_timer >= attack_cooldown:
		if _target_player != null and is_instance_valid(_target_player):
			var dist: float = _actor.global_position.distance_to(_target_player.global_position)
			if dist <= 40.0:
				# Reseta para atacar novamente
				_cooldown_timer = 0.0
				_has_attacked = false
			else:
				state_machine.transition_to("chase")
		else:
			state_machine.transition_to("idle")

func _perform_attack() -> void:
	if _actor == null:
		return
	var hitbox: Area2D = _actor.get_node_or_null("HitboxComponent") as Area2D
	if hitbox != null:
		if hitbox.has_method("set_damage"):
			hitbox.set_damage(attack_damage)
		hitbox.monitoring = true
		# Desativa a hitbox após 0.2 segundos de frame de golpe
		get_tree().create_timer(0.2).timeout.connect(func(): if is_instance_valid(hitbox): hitbox.monitoring = false)
