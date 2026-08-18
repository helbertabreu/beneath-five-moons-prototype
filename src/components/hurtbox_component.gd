# res://src/components/hurtbox_component.gd
class_name HurtboxComponent
extends Area2D

## Área de recepção de dano que repassa os ataques sofridos para o HealthComponent vinculado.

@export var health_component: HealthComponent
@export var is_invulnerable: bool = false


func _ready() -> void:
	# Ajusta camada e máscara padrão de colisão de Hurtbox (Camada 3 de combate)
	collision_layer = 4 # Layer 3
	collision_mask = 0


## Método invocado pelas Hitboxes para causar dano
func receive_hit(damage: float, knockback_force: Vector2 = Vector2.ZERO, attacker: Node = null) -> void:
	if is_invulnerable or health_component == null:
		return

	health_component.take_damage(damage, attacker)

	# Aplica impulso/knockback na entidade pai se ela for um CharacterBody2D
	var parent_body = get_parent()
	if parent_body is CharacterBody2D and knockback_force != Vector2.ZERO:
		parent_body.velocity += knockback_force
