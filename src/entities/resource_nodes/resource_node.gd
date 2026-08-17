# res://src/entities/resource_nodes/resource_node.gd
class_name ResourceNode
extends StaticBody2D

## Representa uma jazida ou nó de recurso dinâmico com exaustão e regeneração.

enum NodeState { INTACT, DEGRADED, EXHAUSTED }

@export var node_name: String = "Jazida de Cobre"
@export var primary_item: ItemData
@export var secondary_item: ItemData # Item de menor valor obtido no estado DEGRADED (ex: Pedra)

@export var max_charges: int = 5 # Quantidade de coletas no estado INTACT
@export var degraded_charges: int = 3 # Coletas adicionais no estado DEGRADED

@export var base_time_cost: int = 15 # 15 minutos do ATS por nó
@export var base_energy_cost: float = 10.0
@export var base_hunger_cost: float = 2.0

var current_state: NodeState = NodeState.INTACT
var current_charges: int = 5
var days_recovering: int = 0

func _ready() -> void:
	current_charges = max_charges
	# Escuta a virada dos dias para gerenciar a regeneração
	EventBus.day_changed.connect(_on_day_changed)

func interact(player: PlayerController) -> void:
	if current_state == NodeState.EXHAUSTED:
		print("NÓ EXAUSTO: %s está sem recursos no momento. Aguarde a regeneração natural." % node_name)
		# Feedback flutuante em vermelho alertando que está esgotado
		EventBus.floating_text_requested.emit("Esgotado!", global_position + Vector2(0, -20), Color.INDIAN_RED)
		return

	# Tenta consumir os recursos de sobrevivência e tempo do jogador
	var success: bool = player.survival_component.consume_resources_for_action(
		base_hunger_cost,
		base_energy_cost,
		base_time_cost
	)

	if not success:
		print("ENERGIA/FOME INSUFICIENTE: O jogador não consegue realizar o trabalho de coleta.")
		# Feedback flutuante indicando falta de energia
		EventBus.floating_text_requested.emit("Exausto!", player.global_position + Vector2(0, -30), Color.ORANGE)
		return

	# Determina qual item será entregue com base no estado de exaustão
	var collected_item: ItemData = primary_item
	var text_color: Color = Color.GOLD # Cor padrão para item principal (Cobre)
	
	if current_state == NodeState.DEGRADED:
		collected_item = secondary_item
		text_color = Color.LIGHT_GRAY # Cor para resíduo/pedra

	# Adiciona ao inventário do jogador e exibe o feedback flutuante
	if collected_item != null:
		player.inventory_component.add_item(collected_item, 1)
		
		# Dispara o texto flutuante exatamente sobre a jazida
		var display_text: String = "+1 %s" % collected_item.name
		EventBus.floating_text_requested.emit(display_text, global_position + Vector2(-20, -30), text_color)

	_process_charge_consumption()

func _process_charge_consumption() -> void:
	current_charges -= 1
	
	if current_charges <= 0:
		if current_state == NodeState.INTACT:
			current_state = NodeState.DEGRADED
			current_charges = degraded_charges
			print("NÓ DEGRADADO: %s teve seus recursos principais esgotados! Agora rende apenas resíduos." % node_name)
		elif current_state == NodeState.DEGRADED:
			current_state = NodeState.EXHAUSTED
			days_recovering = 0 # Inicia o contador de regeneração
			print("NÓ EXAUSTO: %s foi totalmente esgotado! Entrou em descanso natural." % node_name)

func _on_day_changed(_day: int, _season: String) -> void:
	if current_state == NodeState.EXHAUSTED or current_state == NodeState.DEGRADED:
		days_recovering += 1
		# Regra do Bloco 6 do GDD: 3 dias sem uso para regeneração total
		if days_recovering >= 3:
			current_state = NodeState.INTACT
			current_charges = max_charges
			days_recovering = 0
			print("NÓ REGENERADO: %s se recuperou completamente e está intacto novamente!" % node_name)
