extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const DAMAGE_TIME = 60

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent

var prev_health : float
var play_damage : bool

func _ready() -> void:
	prev_health = health_component.health

func _physics_process(delta: float) -> void:
	# add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# get's input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
		# flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# play animation
	if is_on_floor() and not play_damage:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	elif not play_damage:
		animated_sprite.play("jump")
		
	if prev_health > health_component.health:
		play_damage = true
		animated_sprite.play("damage")
		prev_health = health_component.health
		timer.start()
	
	# apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout() -> void:
	play_damage = false
