# res://autoload/reputation_manager.gd
extends Node

## Gerencia a reputação global do jogador com as facções do mundo.

var factions_reputation: Dictionary = {
	"vilarejo": 0 # Reputação inicial Neutra
}


func add_reputation(faction_id: String, amount: int) -> void:
	var current: int = factions_reputation.get(faction_id, 0)
	var new_rep: int = clamp(current + amount, -100, 100)
	factions_reputation[faction_id] = new_rep
	print("REPUTAÇÃO: Facção '%s' alterada para %d (Variação: %+d)" % [faction_id, new_rep, amount])


func get_reputation(faction_id: String) -> int:
	return factions_reputation.get(faction_id, 0)


func get_price_multiplier(faction_id: String, faction_resource: FactionData) -> float:
	var rep: int = get_reputation(faction_id)
	if faction_resource != null:
		return faction_resource.get_price_modifier(rep)
	return 1.0


## Retorna a classificação textual com base na pontuação (-100 a +100)
func get_reputation_level(faction_id: String) -> String:
	var rep: int = get_reputation(faction_id)
	
	if rep <= -60:
		return "Odiado"
	elif rep <= -20:
		return "Hostil"
	elif rep < 20:
		return "Neutro"
	elif rep < 60:
		return "Amigável"
	else:
		return "Exaltado"
