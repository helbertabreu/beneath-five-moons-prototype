# res://autoload/event_bus.gd
extends Node

## Barramento global de sinais do projeto.

# Sinais do Sistema de Tempo (ATS)
signal time_advanced(total_minutes: int, current_hour: int, current_minute: int)
signal day_changed(day_count: int, current_season: String)

# Sinais de Sobrevivência do Jogador
signal hunger_changed(current_hunger: float, max_hunger: float)
signal energy_changed(current_energy: float, max_energy: float)
signal fatigue_changed(accumulated_fatigue: float)
signal player_fainted()
# Sinal de Feedback Visual
signal floating_text_requested(text: String, global_position: Vector2, color: Color)
# Sinal de Notificação em Banner/Toast
signal notification_requested(message: String, color: Color)
