# res://src/entities/enemies/night_bandit.gd
class_name NightBandit
extends CharacterBody2D

## Controla a IA e o comportamento do inimigo Salteador da Noite (ENM-002).

enum State { IDLE, PATROL, CHASE, ATTACK, DEAD }

@export var patrol_speed: float = 60.0
@export var chase_speed: float = 120.0
@export var attack_damage: float = 15.0
@export var xp_reward: int = 40

var current_state: State = State.IDLE
var target_player: CharacterBody2D = null
var patrol_direction: Vector2 = Vector2.LEFT
var patrol_timer: float = 0.0

# Referências seguras e defensivas de nós filhos
var health_component: HealthComponent
var hurtbox_component: HurtboxComponent
var hitbox_component: HitboxComponent
var detection_area: Area2D
var attack_timer: Timer


func _ready() -> void:
	add_to_group("enemies")
	
	# Busca os nós de forma segura para não quebrar no editor, em testes ou no jogo
	health_component = get_node_or_null("HealthComponent") as HealthComponent
	hurtbox_component = get_node_or_null("HurtboxComponent") as HurtboxComponent
	hitbox_component = get_node_or_null("HitboxComponent") as HitboxComponent
	detection_area = get_node_or_null("DetectionArea") as Area2D
	attack_timer = get_node_or_null("AttackTimer") as Timer

	if health_component:
		health_component.max_health = 60.0
		health_component.current_health = 60.0
		if not health_component.died.is_connected(_on_died):
			health_component.died.connect(_on_died)

	if hitbox_component:
		hitbox_component.damage = attack_damage

	if detection_area:
		if not detection_area.body_entered.is_connected(_on_detection_body_entered):
			detection_area.body_entered.connect(_on_detection_body_entered)
		if not detection_area.body_exited.is_connected(_on_detection_body_exited):
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
		patrol_timer = randf_range(1.5, 3.0)


func _process_idle(delta: float) -> void:
	patrol_timer -= delta
	if patrol_timer <= 0.0:
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
	if distance <= 40.0:
		_change_state(State.ATTACK)


func _process_attack(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	if target_player == null or not is_instance_valid(target_player):
		_change_state(State.IDLE)
		return

	if attack_timer != null and attack_timer.is_stopped():
		_perform_attack()

	var distance: float = global_position.distance_to(target_player.global_position)
	if distance > 45.0:
		_change_state(State.CHASE)


func _perform_attack() -> void:
	if attack_timer != null:
		attack_timer.start()
	print("INIMIGO (SALTEADOR): Desferiu golpe de adaga no Jogador! (Dano: %.1f)" % attack_damage)


func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		target_player = body as CharacterBody2D
		_change_state(State.CHASE)


func _on_detection_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null
		_change_state(State.IDLE)


func _on_died() -> void:
	_change_state(State.DEAD)
	velocity = Vector2.ZERO
	print("INIMIGO (SALTEADOR): Derrotado! Concedendo %d de XP e drop de saques." % xp_reward)
	
	EventBus.floating_text_requested.emit("+%d XP Salteador" % xp_reward, global_position, Color.GOLD)
	
	if hurtbox_component:
		hurtbox_component.monitoring = false
		hurtbox_component.monitorable = false

	get_tree().create_timer(0.5).timeout.connect(queue_free)
