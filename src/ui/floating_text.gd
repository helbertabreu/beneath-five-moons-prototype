# res://src/ui/floating_text.gd
class_name FloatingText
extends Label

@export var float_speed: float = 30.0
@export var duration: float = 0.8

func setup(text_str: String, start_pos: Vector2, color: Color = Color.WHITE) -> void:
	text = text_str
	global_position = start_pos
	modulate = color

func _ready() -> void:
	pivot_offset = size / 2.0
	
	var tween: Tween = create_tween().set_parallel(true)
	
	# Anima a subida do texto
	tween.tween_property(self, "position:y", position.y - float_speed, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	# Anima o desaparecimento (Fade Out)
	tween.tween_property(self, "modulate:a", 0.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
		
	# Destrói o nó automaticamente após a animação
	tween.chain().tween_callback(queue_free)
