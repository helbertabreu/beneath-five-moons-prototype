# res://src/entities/farming/crop_plot.gd
class_name CropPlot
extends Area2D

enum GrowthStage { EMPTY, SEED, GROWING, READY }

@export var crop_name: String = "Trigo"
@export var days_to_grow: int = 2
@export var seed_item_id: String = "semente_trigo"
@export var harvested_item: ItemData

var current_stage: GrowthStage = GrowthStage.EMPTY
var current_growth_days: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
	EventBus.day_changed.connect(_on_day_changed)
	_update_visuals()

func interact(player: PlayerController) -> void:
	match current_stage:
		GrowthStage.EMPTY:
			_try_plant(player)
		GrowthStage.READY:
			_harvest(player)
		_:
			EventBus.notification_requested.emit("A planta ainda está crescendo...", Color.LIGHT_BLUE)

func _try_plant(player: PlayerController) -> void:
	if player.inventory_component.get_item_quantity(seed_item_id) > 0:
		if player.inventory_component.remove_item(seed_item_id, 1):
			current_stage = GrowthStage.SEED
			current_growth_days = 0
			_update_visuals()
			EventBus.notification_requested.emit("Semente de %s plantada!" % crop_name, Color.GREEN)
	else:
		EventBus.notification_requested.emit("Você precisa de 1x Semente de %s!" % crop_name, Color.CORAL)

func _harvest(player: PlayerController) -> void:
	if harvested_item != null:
		player.inventory_component.add_item(harvested_item, 2) # Colhe 2x do recurso
		EventBus.notification_requested.emit("Colhido 2x %s!" % harvested_item.name, Color.GOLD)
	
	current_stage = GrowthStage.EMPTY
	current_growth_days = 0
	_update_visuals()

func _on_day_changed(_day: int, _season: String) -> void:
	if current_stage == GrowthStage.SEED or current_stage == GrowthStage.GROWING:
		current_growth_days += 1
		if current_growth_days >= days_to_grow:
			current_stage = GrowthStage.READY
		else:
			current_stage = GrowthStage.GROWING
		_update_visuals()

func _update_visuals() -> void:
	if label != null:
		match current_stage:
			GrowthStage.EMPTY:
				label.text = "[ Terra Arável ]\n(E para Plantar)"
			GrowthStage.SEED:
				label.text = "[ Semente de %s ]\n(Crescendo...)" % crop_name
			GrowthStage.GROWING:
				label.text = "[ Brotando %s ]\n(Crescendo...)" % crop_name
			GrowthStage.READY:
				label.text = "[ %s Pronto! ]\n(E para Colher)" % crop_name
