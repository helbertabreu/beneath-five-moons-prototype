class_name DropEntryData
extends Resource
## Custom Resource que representa uma entrada individual na tabela de drops.
##
## Define o item a ser sorteado, probabilidades base e intervalo de quantidades.

@export var item_id: String = ""
@export_range(0.0, 1.0) var chance: float = 1.0
@export var min_quantity: int = 1
@export var max_quantity: int = 1
@export var guaranteed: bool = false
@export var condition_id: String = ""

func _init(p_item_id: String = "", p_chance: float = 1.0, p_min: int = 1, p_max: int = 1, p_guaranteed: bool = false) -> void:
	item_id = p_item_id
	chance = p_chance
	min_quantity = p_min
	max_quantity = p_max
	guaranteed = p_guaranteed
