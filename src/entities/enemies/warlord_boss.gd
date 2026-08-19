class_name WarlordBoss
extends EnemyBase

## Script para o Warlord (ENM-008). Chefe Supremo da Expansão.

func _init() -> void:
	monster_id = "ENM-008"
	display_name = "Warlord"
	max_hp = 2500.0
	attack_damage = 100.0
	movement_speed = 65.0
	detection_radius = 250.0
	attack_range = 50.0
	attack_cooldown = 1.5
