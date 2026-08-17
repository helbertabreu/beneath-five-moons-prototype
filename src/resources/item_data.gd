# res://src/resources/item_data.gd
class_name ItemData
extends Resource

enum ItemType { RAW_MATERIAL, CONSUMABLE, EQUIPMENT, TOOL }

@export var id: String = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var type: ItemType = ItemType.RAW_MATERIAL
@export var base_value: int = 10
@export var max_stack: int = 99
