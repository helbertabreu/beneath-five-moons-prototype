class_name OrcEnemy
extends EnemyBase

## Script para o Orc (ENM-004). Inimigo pesado e resistente.

func _init() -> void:
	monster_id = "ENM-004"
	display_name = "Orc"
	max_hp = 180.0
	attack_damage = 30.0
	movement_speed = 70.0
	detection_radius = 140.0
	attack_range = 35.0
	attack_cooldown = 2.0
