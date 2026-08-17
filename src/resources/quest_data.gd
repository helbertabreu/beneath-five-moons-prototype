# res://src/resources/quest_data.gd
class_name QuestData
extends Resource

@export var quest_id: String = "quest_primeira_ferramenta"
@export var title: String = "Primeira Ferramenta do Vilarejo"
@export var description: String = "O armazém precisa de novas ferramentas de cobre. Fabrique e entregue 1 Ferramenta de Cobre."

# Requisito de Entrega
@export var required_item: ItemData
@export var required_amount: int = 1

# Recompensas
@export var reward_coins: int = 150
@export var reward_faction_id: String = "vilarejo"
@export var reward_reputation: int = 15
