class_name DropTableData
extends Resource
## Custom Resource que agrupa entradas de drop e define a regra de rolagem.

enum RollMode {
	INDEPENDENT, # Cada entrada é sorteada de forma isolada
	WEIGHTED,    # Seleção ponderada baseada na chance/peso de cada entrada
	EXCLUSIVE    # Apenas uma entrada é escolhida; se selecionada, encerra o sorteio
}

@export var drop_table_id: String = ""
@export var roll_mode: RollMode = RollMode.INDEPENDENT
@export var entries: Array[DropEntryData] = []
