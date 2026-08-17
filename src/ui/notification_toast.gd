# res://src/ui/notification_toast.gd
class_name NotificationToast
extends PanelContainer

@onready var message_label: Label = $MessageLabel

@export var display_duration: float = 2.5
@export var slide_distance: float = 40.0

func setup(message: String, custom_color: Color = Color.WHITE) -> void:
	message_label.text = message
	modulate = custom_color

func _ready() -> void:
	# Animação de entrada (Slide Down + Fade In) e saída (Fade Out)
	modulate.a = 0.0
	position.y -= slide_distance
	
	var tween: Tween = create_tween()
	
	# Entrada suave
	tween.tween_property(self, "position:y", position.y + slide_distance, 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	# Aguarda o tempo de exibição
	tween.tween_interval(display_duration)
	
	# Saída com Fade Out
	tween.tween_property(self, "modulate:a", 0.0, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
	# Destrói o nó após terminar
	tween.chain().tween_callback(queue_free)
