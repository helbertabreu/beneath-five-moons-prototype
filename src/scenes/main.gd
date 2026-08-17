# res://src/scenes/main.gd
extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	# Pressione 'R' para reiniciar o teste se quiser resetar o estado
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().reload_current_scene()
