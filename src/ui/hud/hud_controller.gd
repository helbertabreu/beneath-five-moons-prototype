# res://src/ui/hud/hud_controller.gd
extends Control

## Controlador da Interface do Usuário (HUD) reativo aos sinais do EventBus.

@onready var time_label: Label = $CanvasLayer/MainPanel/VBoxContainer/TimeLabel
@onready var season_label: Label = $CanvasLayer/MainPanel/VBoxContainer/SeasonLabel
@onready var hunger_bar: ProgressBar = $CanvasLayer/MainPanel/VBoxContainer/HungerBar
@onready var energy_bar: ProgressBar = $CanvasLayer/MainPanel/VBoxContainer/EnergyBar
@onready var inventory_panel: InventoryPanel = $InventoryPanel
@onready var crafting_window: CraftingWindow = $CraftingWindow
@onready var vendor_window: VendorWindow = $VendorWindow
@onready var quest_log_window: QuestLogWindow = $QuestLogWindow
@onready var character_profile_window: CharacterProfileWindow = $CharacterProfileWindow

# Pré-carregamento das cenas visuais de UI
var floating_text_scene: PackedScene = preload("res://src/ui/floating_text.tscn")
var notification_toast_scene: PackedScene = preload("res://src/ui/notification_toast.tscn")

func _ready() -> void:
	# Conecta com os sinais globais sem acoplamento direto com o Player
	EventBus.time_advanced.connect(_on_time_advanced)
	EventBus.day_changed.connect(_on_day_changed)
	EventBus.hunger_changed.connect(_on_hunger_changed)
	EventBus.energy_changed.connect(_on_energy_changed)
	EventBus.floating_text_requested.connect(_on_floating_text_requested)
	EventBus.notification_requested.connect(_on_notification_requested)
	EventBus.player_fainted.connect(_on_player_fainted)

	# BUSCA DIRETA DE FRAME 0: Atualiza os valores visuais no instante do carregamento
	call_deferred("_force_initial_hud_update")
	
func _force_initial_hud_update() -> void:
	# Atualiza os rótulos de tempo iniciais
	if TimeManager:
		_on_time_advanced(0, TimeManager.get_current_hour(), TimeManager.get_current_minute())
		if "current_day" in TimeManager and "current_season" in TimeManager:
			season_label.text = "Dia %d - %s" % [TimeManager.current_day, TimeManager.current_season]

	# Busca o player na cena para forçar a renderização das barras de fome e energia em 100%
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		var player = players[0]
		if player and "survival_component" in player and player.survival_component:
			var surv = player.survival_component
			_on_hunger_changed(surv.current_hunger, surv.max_hunger)
			_on_energy_changed(surv.current_energy, surv.get_effective_max_energy())

func _on_floating_text_requested(text: String, spawn_pos: Vector2, color: Color) -> void:
	if floating_text_scene == null:
		return
		
	var ft_instance = floating_text_scene.instantiate() as FloatingText
	if ft_instance:
		# Adiciona o texto à cena principal
		get_tree().current_scene.add_child(ft_instance)
		ft_instance.setup(text, spawn_pos, color)

func _on_time_advanced(_total_minutes: int, hour: int, minute: int) -> void:
	time_label.text = "Horário: %02d:%02d" % [hour, minute]

func _on_day_changed(day: int, season: String) -> void:
	season_label.text = "Dia %d - %s" % [day, season]
	# Notificação automática ao virar o dia
	EventBus.notification_requested.emit("Um novo dia começou: Dia %d (%s)" % [day, season], Color.GOLD)

func _on_player_fainted() -> void:
	# Notificação automática em caso de desmaio por exaustão
	EventBus.notification_requested.emit("Você desmaiou de exaustão e perdeu tempo!", Color.CRIMSON)

func _on_notification_requested(message: String, color: Color) -> void:
	if notification_toast_scene == null:
		return
		
	var toast = notification_toast_scene.instantiate() as NotificationToast
	if toast:
		# Adiciona ao CanvasLayer da HUD para garantir que fique fixo na tela
		$CanvasLayer.add_child(toast)
		
		# Centraliza o Toast no topo da tela
		toast.anchor_left = 0.5
		toast.anchor_right = 0.5
		toast.anchor_top = 0.05
		toast.anchor_bottom = 0.05
		toast.grow_horizontal = Control.GROW_DIRECTION_BOTH
		
		toast.setup(message, color)

func _on_hunger_changed(current: float, max_val: float) -> void:
	hunger_bar.max_value = max_val
	hunger_bar.value = current

func _on_energy_changed(current: float, max_val: float) -> void:
	energy_bar.max_value = max_val
	energy_bar.value = current

func toggle_inventory(player: PlayerController) -> void:
	if inventory_panel.visible:
		inventory_panel.hide()
	else:
		inventory_panel.open(player)

func toggle_quest_log(player: PlayerController) -> void:
	if quest_log_window.visible:
		quest_log_window.hide()
	else:
		quest_log_window.open(player)

# Alterna a exibição do Perfil do Jogador [NOVO]
func toggle_character_profile(player: PlayerController) -> void:
	if character_profile_window.visible:
		character_profile_window.hide()
	else:
		character_profile_window.open(player)

func open_crafting_window(workstation: Workstation, player: PlayerController) -> void:
	if crafting_window:
		crafting_window.open(workstation, player)

# Abre a janela do comerciante
func open_vendor_window(vendor: NPCVendor, player: PlayerController) -> void:
	if vendor_window:
		vendor_window.open(vendor, player)
