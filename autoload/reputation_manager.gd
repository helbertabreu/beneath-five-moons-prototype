# res://autoload/reputation_manager.gd
extends Node

## Gerencia a reputação global do jogador com as facções do mundo na escala do GDD (0 a 10.000).

# Limites Globais de Reputação conforme o GDD Bloco 4
const MIN_REPUTATION: int = 0
const MAX_REPUTATION: int = 10000

# Ranks de Reputação oficiais
enum Rank {
	DESCONHECIDO, # 0 – 999
	RECONHECIDO,  # 1.000 – 2.999
	RESPEITADO,   # 3.000 – 5.999
	ILUSTRE,      # 6.000 – 8.999
	ELEGIVEL      # 9.000 – 10.000 (Gatilho para Governança do Vilarejo)
}

# Dicionário contendo a reputação atual por ID de facção
var factions_reputation: Dictionary = {
	"vilarejo": 0 # Reputação inicial do jogador
}


func add_reputation(faction_id: String, amount: int) -> void:
	var current: int = get_reputation(faction_id)
	var new_rep: int = clamp(current + amount, MIN_REPUTATION, MAX_REPUTATION)
	factions_reputation[faction_id] = new_rep
	
	var rank_name: String = get_reputation_level(faction_id)
	print("REPUTAÇÃO: Facção '%s' alterada para %d pts (Rank: %s | Variação: %+d)" % [faction_id, new_rep, rank_name, amount])
	
	# Dispara notificação flutuante na interface se houver alteração
	if amount != 0:
		var text_color: Color = Color.CYAN if amount > 0 else Color.INDIAN_RED
		var sign_char: String = "+" if amount > 0 else ""
		EventBus.floating_text_requested.emit("%s%d Reputação (%s)" % [sign_char, amount, rank_name], Vector2.ZERO, text_color)


func set_reputation(faction_id: String, amount: int) -> void:
	var new_rep: int = clamp(amount, MIN_REPUTATION, MAX_REPUTATION)
	factions_reputation[faction_id] = new_rep


func get_reputation(faction_id: String) -> int:
	return factions_reputation.get(faction_id, MIN_REPUTATION)


## Retorna o Rank enum da facção
func get_rank(faction_id: String) -> Rank:
	var rep: int = get_reputation(faction_id)
	
	if rep >= 9000:
		return Rank.ELEGIVEL
	elif rep >= 6000:
		return Rank.ILUSTRE
	elif rep >= 3000:
		return Rank.RESPEITADO
	elif rep >= 1000:
		return Rank.RECONHECIDO
	else:
		return Rank.DESCONHECIDO


## Retorna a nomeação oficial textual do Rank de acordo com o GDD
func get_reputation_level(faction_id: String) -> String:
	match get_rank(faction_id):
		Rank.ELEGIVEL:
			return "Elegível (Líder)"
		Rank.ILUSTRE:
			return "Ilustre"
		Rank.RESPEITADO:
			return "Respeitado"
		Rank.RECONHECIDO:
			return "Reconhecido"
		Rank.DESCONHECIDO, _:
			return "Desconhecido"


## Retorna se o jogador possui o pré-requisito de reputação para pleitear a Governança (9.000+ pts)
func is_eligible_for_governance(faction_id: String) -> bool:
	return get_reputation(faction_id) >= 9000


## Retorna o multiplicador de preço ajustado baseado na facção e pontuação
func get_price_multiplier(faction_id: String, faction_resource: FactionData) -> float:
	var rep: int = get_reputation(faction_id)
	if faction_resource != null:
		return faction_resource.get_price_modifier(rep)
	
	# Fallback caso não haja Resource FactionData
	match get_rank(faction_id):
		Rank.ELEGIVEL:
			return 0.80 # 20% desconto
		Rank.ILUSTRE:
			return 0.85 # 15% desconto
		Rank.RESPEITADO:
			return 0.90 # 10% desconto
		Rank.RECONHECIDO:
			return 0.95 # 5% desconto
		Rank.DESCONHECIDO, _:
			return 1.00 # Preço cheio


## Serialização para Save/Load via SaveManager
func get_save_data() -> Dictionary:
	return {
		"factions_reputation": factions_reputation
	}


func load_save_data(data: Dictionary) -> void:
	if data.has("factions_reputation") and data["factions_reputation"] is Dictionary:
		factions_reputation = data["factions_reputation"]
