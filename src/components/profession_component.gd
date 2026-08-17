# res://src/components/profession_component.gd
class_name ProfessionComponent
extends Node

## Gerencia a profissão única do jogador e o ganho de experiência/nível.

# Restrição do GDD: Apenas 1 profissão ativa por personagem no MVP
@export var active_profession: String = "Ferraria"
var current_level: int = 1
var current_xp: int = 0

func add_xp(amount: int) -> void:
	if current_level >= 100:
		return
		
	current_xp += amount
	print("PROFISSÃO: +%d XP em %s. Total: %d XP" % [amount, active_profession, current_xp])
	
	# Dispara texto flutuante de XP sobre o jogador
	var parent_node: Node2D = get_parent() as Node2D
	if parent_node != null:
		var spawn_pos: Vector2 = parent_node.global_position + Vector2(0, -35)
		EventBus.floating_text_requested.emit("+%d XP" % amount, spawn_pos, Color.CYAN)
	
	_check_level_up()

func can_craft(recipe: RecipeData, player_inventory: InventoryComponent) -> bool:
	if recipe == null:
		return false
		
	# Valida se o jogador possui a profissão exigida
	if recipe.required_profession != active_profession:
		print("PROFISSÃO INCORRETA: Exige a profissão %s!" % recipe.required_profession)
		return false
		
	# Valida o nível do jogador
	if current_level < recipe.required_level:
		print("NÍVEL INSUFICIENTE: Exige nível %d em %s!" % [recipe.required_level, active_profession])
		return false
		
	# Valida se o jogador possui todos os insumos necessários no inventário
	for ingredient in recipe.ingredients:
		var item: ItemData = ingredient.item
		var required_qty: int = ingredient.amount
		
		if item == null or player_inventory.get_item_quantity(item.id) < required_qty:
			print("INSUMOS INSUFICIENTES: Faltam itens para a receita %s!" % recipe.recipe_name)
			return false
			
	return true

func _check_level_up() -> void:
	# Fórmula de XP para subir de nível: Nível * 100
	var xp_needed: int = current_level * 100
	while current_xp >= xp_needed and current_level < 100:
		current_xp -= xp_needed
		current_level += 1
		print("PARABÉNS! Você subiu para o Nível %d na profissão %s!" % [current_level, active_profession])
		
		# Dispara texto flutuante de Level Up destacado
		var parent_node: Node2D = get_parent() as Node2D
		if parent_node != null:
			var spawn_pos: Vector2 = parent_node.global_position + Vector2(0, -50)
			EventBus.floating_text_requested.emit("LEVEL UP! (Nív. %d)" % current_level, spawn_pos, Color.GOLD)
			
		xp_needed = current_level * 100
