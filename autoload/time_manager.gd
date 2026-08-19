## 5. Refatoração: `autoload/time_manager.gd`
# Remoção do avanço de tempo realtime e implementação estrita do **Action Time System**[cite: 1, 6].

extends Node
## TimeManager - Autoridade temporal centralizada.
##
## Opera estritamente via Action Time System. O tempo avança apenas através de
## chamadas explícitas de ações atômicas.

var day: int = 1
var hour: int = 6
var minute: int = 0

const MINUTES_PER_DAY: int = 1440

## Avança o relógio do jogo em uma quantidade discreta de minutos.
func advance_time(minutes: int) -> void:
	if minutes <= 0:
		return
		
	minute += minutes
	while minute >= 60:
		minute -= 60
		hour += 1
		if EventBus != null:
			EventBus.emit_signal("hour_changed", hour)
		
		if hour >= 24:
			hour -= 24
			day += 1
			_on_new_day_started()

	if EventBus != null:
		EventBus.emit_signal("time_advanced", minutes)

## Retorna a quantidade total de minutos transcorridos desde o dia 1 às 00:00.
func get_total_minutes() -> int:
	return ((day - 1) * MINUTES_PER_DAY) + (hour * 60) + minute

## Retorna string formatada do horário atual (ex: "06:15").
func get_time_string() -> String:
	return "%02d:%02d" % [hour, minute]

## Processa regras do início do novo dia.
func _on_new_day_started() -> void:
	if EventBus != null:
		EventBus.emit_signal("day_started", day)
