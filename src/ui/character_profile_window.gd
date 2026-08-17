# res://src/ui/character_profile_window.gd
class_name CharacterProfileWindow
extends PanelContainer

@onready var profession_name_label: Label = $VBoxContainer/ProfessionSection/ProfessionName
@onready var xp_bar: ProgressBar = $VBoxContainer/ProfessionSection/XPBar
@onready var xp_text_label: Label = $VBoxContainer/ProfessionSection/XPText

@onready var hunger_label: Label = $VBoxContainer/SurvivalSection/HungerLabel
@onready var energy_label: Label = $VBoxContainer/SurvivalSection/EnergyLabel
@onready var fatigue_label: Label = $VBoxContainer/SurvivalSection/FatigueLabel

@onready var close_button: Button = $VBoxContainer/CloseButton

var current_player: PlayerController = null

func _ready() -> void:
	visible = false
	close_button.pressed.connect(hide)

func open(player: PlayerController) -> void:
	current_player = player
	_refresh_data()
	visible = true

func _refresh_data() -> void:
	if current_player == null:
		return

	# 1. Atualiza Profissão e XP
	var prof: ProfessionComponent = current_player.profession_component
	if prof != null:
		var xp_needed: int = prof.current_level * 100
		profession_name_label.text = "Profissão: %s (Nível %d)" % [prof.active_profession, prof.current_level]
		
		xp_bar.max_value = xp_needed
		xp_bar.value = prof.current_xp
		xp_text_label.text = "XP: %d / %d" % [prof.current_xp, xp_needed]

	# 2. Atualiza Sobrevivência e Atributos
	var surv: SurvivalComponent = current_player.survival_component
	if surv != null:
		hunger_label.text = "Fome: %.1f / %.1f" % [surv.current_hunger, surv.max_hunger]
		energy_label.text = "Energia: %.1f / %.1f" % [surv.current_energy, surv.get_effective_max_energy()]
		fatigue_label.text = "Fadiga: %d%%" % int(surv.accumulated_fatigue * 100)
