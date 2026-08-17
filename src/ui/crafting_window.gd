# res://src/ui/crafting_window.gd
class_name CraftingWindow
extends PanelContainer

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var recipe_list: ItemList = $VBoxContainer/RecipeList
@onready var craft_button: Button = $VBoxContainer/CraftButton
@onready var close_button: Button = $VBoxContainer/CloseButton

var current_workstation: Workstation = null
var current_player: PlayerController = null

func _ready() -> void:
	visible = false
	close_button.pressed.connect(hide)
	craft_button.pressed.connect(_on_craft_button_pressed)
	
	# Força layout da lista de receitas via código
	recipe_list.custom_minimum_size = Vector2(350, 200)
	recipe_list.size_flags_vertical = Control.SIZE_EXPAND_FILL

# Função auxiliar para buscar a lista de receitas, independente do nome da variável na bancada
func _get_workstation_recipes(workstation: Workstation) -> Array:
	var result: Array = []
	
	# 1. Checa se é um Array de receitas (recipes ou available_recipes)
	if "available_recipes" in workstation and workstation.get("available_recipes") != null:
		result = workstation.get("available_recipes")
	elif "recipes" in workstation and workstation.get("recipes") != null:
		result = workstation.get("recipes")
	# 2. Checa se é uma receita única no singular (recipe)
	elif "recipe" in workstation and workstation.get("recipe") != null:
		result.append(workstation.get("recipe"))
		
	return result

func open(workstation: Workstation, player: PlayerController) -> void:
	current_workstation = workstation
	current_player = player
	
	# Define o título da janela usando o nome da bancada
	if "station_name" in workstation:
		title_label.text = workstation.station_name
	else:
		title_label.text = workstation.name
		
	recipe_list.clear()
	
	var recipes: Array = _get_workstation_recipes(workstation)
	
	if recipes.is_empty():
		recipe_list.add_item("Nenhuma receita cadastrada nesta bancada.")
		craft_button.disabled = true
	else:
		craft_button.disabled = false
		for recipe in recipes:
			if recipe is RecipeData:
				var text: String = "%s (Energia: %d | Tempo: %d min)" % [recipe.recipe_name, recipe.energy_cost, recipe.time_cost_minutes]
				recipe_list.add_item(text)
		
	visible = true

func _on_craft_button_pressed() -> void:
	var selected_items: PackedInt32Array = recipe_list.get_selected_items()
	
	if selected_items.is_empty():
		print("UI: Nenhuma receita selecionada.")
		return
		
	var recipe_index: int = selected_items[0]
	var recipes: Array = _get_workstation_recipes(current_workstation)
	
	if recipe_index >= recipes.size():
		return
		
	var recipe: RecipeData = recipes[recipe_index] as RecipeData
	if recipe == null:
		return

	# Identifica se é bancada passiva (Alto-Forno) ou ativa (Bigorna)
	var is_passive: bool = false
	if "is_passive" in current_workstation:
		is_passive = current_workstation.get("is_passive")
		
	if is_passive and current_workstation.has_method("start_passive_crafting"):
		current_workstation.start_passive_crafting(recipe, current_player)
	else:
		current_player.craft_item_active(recipe)
	
	hide() # Fecha a janela após mandar craftar

func _process(_delta: float) -> void:
	if not visible:
		return
		
	# Valida a distância do jogador em relação à bancada aberta
	if current_workstation != null and current_player != null:
		var distance: float = current_player.global_position.distance_to(current_workstation.global_position)
		
		# Se a distância ultrapassar 100 pixels, fecha a janela de forja/processamento
		if distance > 100.0:
			print("UI: Jogador se afastou da bancada. Fechando CraftingWindow...")
			hide()
