class_name GoblinEnemy
extends EnemyBase

## Script para o Goblin (ENM-003). Inimigo rápido e frágil.

func _init() -> void:
	monster_id = "ENM-003"
	display_name = "Goblin"
	max_hp = 80.0
	attack_damage = 18.0
	movement_speed = 95.0
	detection_radius = 160.0
	attack_range = 28.0
	attack_cooldown = 1.2
