class_name WraithEnemy
extends EnemyBase

## Script para o Wraith (ENM-006). Inimigo espectral veloz.

func _init() -> void:
	monster_id = "ENM-006"
	display_name = "Wraith"
	max_hp = 250.0
	attack_damage = 40.0
	movement_speed = 100.0
	detection_radius = 200.0
	attack_range = 30.0
	attack_cooldown = 1.4
