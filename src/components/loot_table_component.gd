class_name LootTableComponent
extends Node
## Componente encarregado de disparar a geração de saques em nós do mundo ou inimigos.

@export var drop_table: DropTableData

## Executa a rolagem do loot e retorna os itens gerados.
func generate_loot() -> Array[Dictionary]:
	if drop_table == null:
		return []
	return DropSystem.evaluate_drop_table(drop_table)
