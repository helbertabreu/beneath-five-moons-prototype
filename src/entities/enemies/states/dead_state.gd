class_name DeadState
extends State
## Estado de morte de inimigos.
##
## Desativa colisões, aciona o DropSystem para geração de saques e remove a entidade da cena[cite: 1, 4].

var _actor: CharacterBody2D

func enter(_msg: Dictionary = {}) -> void:
	_actor = owner as CharacterBody2D
	if _actor == null:
		return

	_actor.velocity = Vector2.ZERO

	# Desativa colisões do corpo principal
	var col_shape: CollisionShape2D = _actor.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if col_shape != null:
		col_shape.set_deferred("disabled", true)

	# Geração de saques via LootTableComponent / DropSystem[cite: 1, 4]
	var loot_component: Node = _actor.get_node_or_null("LootTableComponent")
	if loot_component != null and loot_component.has_method("generate_loot"):
		var drops: Array = loot_component.generate_loot()
		for item in drops:
			if EventBus != null:
				EventBus.emit_signal("item_obtained", item["item_id"], item["amount"])

	# Notifica a morte do monstro ao EventBus[cite: 4]
	if EventBus != null:
		var enemy_id: String = _actor.get("enemy_id") if "enemy_id" in _actor else "ENM-GENERIC"
		EventBus.emit_signal("monster_killed", enemy_id)

	_actor.queue_free()
