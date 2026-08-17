# res://src/entities/workstations/workstation.gd
class_name Workstation
extends StaticBody2D

## Representa uma bancada de trabalho ativa (Bigorna) ou passiva (Alto-Forno).

@export var station_name: String = "Alto-Forno"
@export var recipe: RecipeData

# Estados da Bancada Passiva
var is_processing: bool = false
var minutes_remaining: int = 0
var completed_items_count: int = 0

func _ready() -> void:
	# Bancadas passivas escutam o tempo avançando no ATS
	EventBus.time_advanced.connect(_on_time_advanced)

func interact(player: PlayerController) -> void:
	# Busca a HUD no grupo para abrir a janela de receitas
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("open_crafting_window"):
		hud.open_crafting_window(self, player)
	else:
		print("DEBUG ERRO: Não foi possível abrir a janela de Crafting pela HUD.")

func _handle_passive_interaction(player: PlayerController) -> void:
	# 1. Se já houver itens prontos na bancada, entrega ao jogador
	if completed_items_count > 0:
		player.inventory_component.add_item(recipe.result_item, completed_items_count)
		print("BANCADA PASSIVA: Você coletou %dx %s do %s!" % [completed_items_count, recipe.result_item.name, station_name])
		completed_items_count = 0
		return
		
	# 2. Se a bancada estiver ocupada processando
	if is_processing:
		print("BANCADA OCUPADA: %s está em funcionamento. Tempo restante: %d minutos." % [station_name, minutes_remaining])
		return
		
	# 3. Tenta carregar a bancada passiva com novos insumos
	if not player.profession_component.can_craft(recipe, player.inventory_component):
		return
		
	# Consome apenas o custo leve de carregamento (ex: 5 min, 5 energia)
	var success: bool = player.survival_component.consume_resources_for_action(
		recipe.hunger_cost,
		recipe.energy_cost,
		5 # 5 minutos para carregar a bancada
	)
	
	if not success:
		return
		
	# Consome os ingredientes do inventário do jogador
	for ingredient in recipe.ingredients:
		var item: ItemData = ingredient.item
		var required_qty: int = ingredient.amount
		player.inventory_component.items[item.id]["quantity"] -= required_qty
		
	is_processing = true
	minutes_remaining = recipe.time_cost_minutes
	print("BANCADA PASSIVA INICIADA: %s foi carregado. Levará %d minutos de jogo." % [station_name, minutes_remaining])

func _on_time_advanced(elapsed_minutes: int, _hour: int, _minute: int) -> void:
	if not is_processing:
		return
		
	# Subtrai o tempo REAL decorrido no TimeManager
	minutes_remaining -= elapsed_minutes
	
	if minutes_remaining <= 0:
		is_processing = false
		minutes_remaining = 0
		completed_items_count += recipe.result_amount
		print("BANCADA PASSIVA CONCLUÍDA! O item %s está pronto para ser retirado no %s!" % [recipe.result_item.name, station_name])
