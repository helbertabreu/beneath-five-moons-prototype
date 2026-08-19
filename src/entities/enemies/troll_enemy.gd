class_name TrollEnemy
extends EnemyBase

## Script para o Troll (ENM-005). Mini-boss tanque de alta resistência.

func _init() -> void:
	monster_id = "ENM-005"
	display_name = "Troll"
	max_hp = 450.0
	attack_damage = 55.0
	movement_speed = 45.0
	detection_radius = 120.0
	attack_range = 45.0
	attack_cooldown = 2.5
