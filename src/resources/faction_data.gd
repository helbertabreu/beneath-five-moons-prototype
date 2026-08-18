# res://src/resources/faction_data.gd
class_name FactionData
extends Resource

## Define os dados da facção e as regras de modificador de preço por reputação (0 - 10.000).

@export var faction_id: String = "vilarejo"
@export var faction_name: String = "Moradores do Vilarejo"
@export_range(0, 10000) var base_reputation: int = 0


## Retorna o modificador de preço com base na pontuação de reputação (GDD Bloco 4):
## - 9.000 a 10.000 (Elegível): Desconto de 20% (Multiplicador 0.80)
## - 6.000 a 8.999  (Ilustre):  Desconto de 15% (Multiplicador 0.85)
## - 3.000 a 5.999  (Respeitado): Desconto de 10% (Multiplicador 0.90)
## - 1.000 a 2.999  (Reconhecido): Desconto de 5%  (Multiplicador 0.95)
## - 0 a 999        (Desconhecido): Preço Base   (Multiplicador 1.00)
func get_price_modifier(reputation: int) -> float:
	if reputation >= 9000:
		return 0.80
	elif reputation >= 6000:
		return 0.85
	elif reputation >= 3000:
		return 0.90
	elif reputation >= 1000:
		return 0.95
	else:
		return 1.00
