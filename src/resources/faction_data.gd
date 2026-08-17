# res://src/resources/faction_data.gd
class_name FactionData
extends Resource

@export var faction_id: String = "vilarejo"
@export var faction_name: String = "Moradores do Vilarejo"
@export var base_reputation: int = 0 # Varia de -100 (Odiado) a +100 (Exaltado)

# Retorna o modificador de preço baseado na reputação:
# Reputação Alta (> 50) -> Desconto de até 20%
# Reputação Baixa (< -20) -> Ágio/Aumento de até 50%
func get_price_modifier(reputation: int) -> float:
	if reputation >= 75:
		return 0.80 # 20% de desconto
	elif reputation >= 25:
		return 0.90 # 10% de desconto
	elif reputation <= -50:
		return 1.50 # 50% de aumento (ágio)
	elif reputation <= -20:
		return 1.25 # 25% de aumento
	return 1.0 # Preço padrão
