# res://autoload/time_manager.gd
extends Node

## Gerenciador do Action Time System (ATS) e Calendário.

const MINUTES_PER_DAY: int = 1440
const START_HOUR: int = 6 # O dia começa às 06:00

enum Season { PRIMAVERA, VERÃO, OUTONO, INVERNO }

var current_day: int = 1
var total_minutes_today: int = START_HOUR * 60
var current_season: Season = Season.PRIMAVERA

func _ready() -> void:
	call_deferred("_emit_initial_signals")

func advance_time(minutes: int) -> void:
	if minutes <= 0:
		return
		
	var previous_minutes: int = total_minutes_today
	total_minutes_today += minutes
	
	var end_of_day_limit: int = (24 + START_HOUR) * 60
	
	while total_minutes_today >= end_of_day_limit:
		total_minutes_today -= 1440
		_advance_day()
		
	EventBus.time_advanced.emit(minutes, get_current_hour(), get_current_minute())

func get_current_hour() -> int:
	return (int(total_minutes_today / 60.0)) % 24

func get_current_minute() -> int:
	return total_minutes_today % 60

func is_late_night() -> bool:
	var hour: int = get_current_hour()
	return hour >= 22 or hour < 2

func is_overnight() -> bool:
	var hour: int = get_current_hour()
	return hour >= 2 and hour < 6

func get_season_name() -> String:
	match current_season:
		Season.PRIMAVERA: return "Primavera"
		Season.VERÃO: return "Verão"
		Season.OUTONO: return "Outono"
		Season.INVERNO: return "Inverno"
		_: return "Desconhecido"

## Aplica os dados carregados pelo SaveManager recalculando os minutos e estação
func load_time_state(day: int, hour: int, minute: int, season_val) -> void:
	current_day = day
	total_minutes_today = (hour * 60) + minute
	
	if season_val is int or season_val is float:
		current_season = int(season_val) as Season
	elif season_val is String:
		match season_val:
			"Primavera": current_season = Season.PRIMAVERA
			"Verão": current_season = Season.VERÃO
			"Outono": current_season = Season.OUTONO
			"Inverno": current_season = Season.INVERNO
			_: current_season = Season.PRIMAVERA

	_emit_initial_signals()

func _advance_day() -> void:
	current_day += 1
	total_minutes_today = (START_HOUR * 60) + (total_minutes_today % 60)
	
	var season_index: int = int((current_day - 1) / 7.0) % 4
	current_season = season_index as Season
	
	EventBus.day_changed.emit(current_day, get_season_name())
	_notify_time_change()

func _notify_time_change() -> void:
	EventBus.time_advanced.emit(total_minutes_today, get_current_hour(), get_current_minute())

func _emit_initial_signals() -> void:
	EventBus.day_changed.emit(current_day, get_season_name())
	_notify_time_change()
