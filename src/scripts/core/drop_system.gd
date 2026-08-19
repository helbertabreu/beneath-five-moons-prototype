class_name DropSystem
extends RefCounted
## Serviço desacoplado responsável por processar e gerar recompensas a partir de tabelas de drop.
##
## Aplica regras do GDD (modificadores ambientais/estações) e suporta modos INDEPENDENT, WEIGHTED e EXCLUSIVE.

## Processa uma DropTableData e retorna uma Array de Dicionários com o formato: [{"item_id": String, "amount": int}]
static func evaluate_drop_table(table: DropTableData, season_modifier: float = 1.0, weather_modifier: float = 1.0, profession_modifier: float = 1.0) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if table == null or table.entries.is_empty():
		return result

	var total_modifier: float = season_modifier * weather_modifier * profession_modifier

	match table.roll_mode:
		DropTableData.RollMode.INDEPENDENT:
			for entry in table.entries:
				if entry == null:
					continue
				if entry.guaranteed or _roll_success(entry.chance * total_modifier):
					var qty: int = randi_range(entry.min_quantity, entry.max_quantity)
					result.append({"item_id": entry.item_id, "amount": qty})

		DropTableData.RollMode.EXCLUSIVE:
			for entry in table.entries:
				if entry == null:
					continue
				if entry.guaranteed or _roll_success(entry.chance * total_modifier):
					var qty: int = randi_range(entry.min_quantity, entry.max_quantity)
					result.append({"item_id": entry.item_id, "amount": qty})
					break # Encerra após o primeiro item sorteado

		DropTableData.RollMode.WEIGHTED:
			var selected_entry: DropEntryData = _roll_weighted(table.entries, total_modifier)
			if selected_entry != null:
				var qty: int = randi_range(selected_entry.min_quantity, selected_entry.max_quantity)
				result.append({"item_id": selected_entry.item_id, "amount": qty})

	return result

## Realiza a verificação de probabilidade contra o valor sorteado pelo RNG.
static func _roll_success(chance: float) -> bool:
	return randf() <= clamp(chance, 0.0, 1.0)

## Realiza o sorteio ponderado (Weighted Roll) acumulando probabilidades.
static func _roll_weighted(entries: Array[DropEntryData], modifier: float) -> DropEntryData:
	var total_weight: float = 0.0
	for entry in entries:
		if entry != null:
			total_weight += entry.chance * modifier

	if total_weight <= 0.0:
		return null

	var roll: float = randf() * total_weight
	var accumulated: float = 0.0

	for entry in entries:
		if entry == null:
			continue
		accumulated += entry.chance * modifier
		if roll <= accumulated:
			return entry

	return null
