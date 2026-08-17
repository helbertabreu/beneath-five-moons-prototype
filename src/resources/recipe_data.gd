# res://src/resources/recipe_data.gd
class_name RecipeData
extends Resource

enum CraftingType { ACTIVE, PASSIVE_BENCH }

@export var id: String = ""
@export var recipe_name: String = ""
@export var required_profession: String = "Ferraria" # Nome da profissão exigida
@export var required_level: int = 1

@export var crafting_type: CraftingType = CraftingType.ACTIVE

# Insumos necessários: Array de Dicionários contendo { "item": ItemData, "amount": int }
@export var ingredients: Array[IngredientData] = []

# Item resultante
@export var result_item: ItemData
@export var result_amount: int = 1

# Custos para Crafting Ativo / Tempo de carregamento para Passivo
@export var time_cost_minutes: int = 20
@export var energy_cost: float = 10.0
@export var hunger_cost: float = 1.0

# Recompensa
@export var xp_reward: int = 15
