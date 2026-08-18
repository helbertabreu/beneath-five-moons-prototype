# res://src/entities/enemies/wolf_enemy.gd
class_name WolfEnemy
extends CharacterBody2D

## Controla a IA e o comportamento do inimigo Lobo Esfomeado (ENM-001).

enum State { IDLE, PATROL, CHASE, ATTACK, DEAD }

@export var patrol_speed: float = 50.0
@export var chase_speed: float = 110.0
@export var attack_damage: float = 12.0
@export var xp_reward: int = 25

var current_state: State = State.IDLE
var target_player: CharacterBody2D = null
var patrol_direction: Vector2 = Vector2.RIGHT
var patrol_timer: float = 0.0

@onready var health_component: HealthComponent = $HealthComponent as HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent as HitboxComponent
@onready var detection_area: Area2D = $DetectionArea as Area2D
@onready var attack_timer: Timer = $AttackTimer as Timer


func _ready() -> void:
	add_to_group("enemies")
	
	if health_component:
		health_component.died.connect(_on_died)
		health_component.damage_taken.connect(_on_damage_taken)

	if hitbox_component:
		hitbox_component.damage = attack_damage

	if detection_area:
		detection_area.body_entered.connect(_on_detection_body_entered)
		detection_area.body_exited.connect(_on_detection_body_exited)

	_change_state(State.PATROL)


func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.PATROL:
			_process_patrol(delta)
		State.CHASE:
			_process_chase(delta)
		State.ATTACK:
			_process_attack(delta)

	move_and_slide()


func _change_state(new_state: State) -> void:
	current_state = new_state
	
	if new_state == State.IDLE:
		velocity = Vector2.ZERO
		patrol_timer = randf_range(1.0, 2.5)


func _process_idle(delta: float) -> void:
	patrol_timer -= delta
	if patrol_timer <= 0.0:
		# Alterna direção aleatória de patrulha
		patrol_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		_change_state(State.PATROL)


func _process_patrol(delta: float) -> void:
	velocity = patrol_direction * patrol_speed
	patrol_timer -= delta
	
	if patrol_timer <= 0.0 or is_on_wall():
		_change_state(State.IDLE)


func _process_chase(_delta: float) -> void:
	if target_player == null or not is_instance_valid(target_player):
		_change_state(State.IDLE)
		return

	var direction: Vector2 = (target_player.global_position - global_position).normalized()
	velocity = direction * chase_speed

	var distance: float = global_position.distance_to(target_player.global_position)
	if distance <= 35.0:
		_change_state(State.ATTACK)


func _process_attack(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	if target_player == null or not is_instance_valid(target_player):
		_change_state(State.IDLE)
		return

	# Executa ataque se o timer de recarga estiver livre
	if attack_timer.is_stopped():
		_perform_attack()

	var distance: float = global_position.distance_to(target_player.global_position)
	if distance > 40.0:
		_change_state(State.CHASE)


func _perform_attack() -> void:
	attack_timer.start()
	print("INIMIGO (LOBO): Desferiu mordida no Jogador! (Dano: %.1f)" % attack_damage)


func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		target_player = body as CharacterBody2D
		_change_state(State.CHASE)


func _on_detection_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null
		_change_state(State.IDLE)


func _on_damage_taken(_amount: float, attacker: Node) -> void:
	# Se for atacado à distância antes de detectar, entra imediatamente em estado de perseguição
	if attacker is CharacterBody2D and attacker.is_in_group("player"):
		target_player = attacker as CharacterBody2D
		_change_state(State.CHASE)


func _on_died() -> void:
	_change_state(State.DEAD)
	velocity = Vector2.ZERO
	print("INIMIGO (LOBO): Derrotado! Concedendo %d de XP de Caça/Combate." % xp_reward)
	
	# Emite notificação de XP e recompensa
	EventBus.floating_text_requested.emit("+%d XP Lobo" % xp_reward, global_position, Color.GOLD)
	
	# Desativa colisões
	if hurtbox_component:
		hurtbox_component.monitoring = false
		hurtbox_component.monitorable = false

	# Libera o nó da memória após 0.5s (ou dispara animação de morte)
	get_tree().create_timer(0.5).timeout.connect(queue_free)
