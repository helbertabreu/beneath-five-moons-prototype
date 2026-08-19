class_name BasiliskEnemy
extends EnemyBase

## Script para o Basilisk (ENM-007). Besta mortal de elite.

func _init() -> void:
	monster_id = "ENM-007"
	display_name = "Basilisk"
	max_hp = 700.0
	attack_damage = 65.0
	movement_speed = 55.0
	detection_radius = 180.0
	attack_range = 40.0
	attack_cooldown = 1.8
