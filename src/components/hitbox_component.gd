# res://src/components/hitbox_component.gd
class_name HitboxComponent
extends Area2D

## Área ofensiva que causa dano ao colidir com uma HurtboxComponent.

signal hit_landed(hurtbox: HurtboxComponent, damage: float)

@export var damage: float = 10.0
@export var knockback_magnitude: float = 100.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 4 # Detecta Layer 3 (Hurtbox)
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var hurtbox: HurtboxComponent = area as HurtboxComponent
		var owner_node = get_parent()
		var attack_direction: Vector2 = (hurtbox.global_position - global_position).normalized()
		var knockback_vector: Vector2 = attack_direction * knockback_magnitude

		hurtbox.receive_hit(damage, knockback_vector, owner_node)
		hit_landed.emit(hurtbox, damage)
