extends CharacterBody3D

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $Character/AnimationPlayer
@onready var gui: Control = $gui

const MOVE_SPEED: float = 8.0
const JUMP_VELOCITY: float = 8.0  # Jump strength
const GRAVITY: float = 24.0  # Gravity strength
const LANES: Array = [-2, 0, 2]  # Lane positions on x-axis

var starting_point: Vector3 = Vector3.ZERO
var current_lane: int = 1  # Start at lane index 1 (x = 0)
var target_lane: int = 1

var is_jumping: bool = false
var is_dead: bool = false

func _ready() -> void:
	gui.get_node("label").text = "Coins: "
	starting_point = global_transform.origin

func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	
	# Handle lane switching
	if Input.is_action_just_pressed("ui_left") and target_lane > 0:
		target_lane -= 1
	if Input.is_action_just_pressed("ui_right") and target_lane < LANES.size() - 1:
		target_lane += 1
	
	# Move towards the target lane
	var target_x: float = LANES[target_lane]
	var current_x: float = global_transform.origin.x
	global_transform.origin.x = lerp(current_x, target_x, MOVE_SPEED * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on the floor

	# Jumping logic
	if is_on_floor() and Input.is_action_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY  # Apply jump velocity

	# Apply the velocity and move the character
	move_and_slide()

	# Play animations based on movement
	if not is_on_floor():
		animation_player.play("Jump")
	else:
		animation_player.play("Run")

	if is_dead:
		print('dead')
		is_dead = false

var coin_count: int = 0
func _on_collision_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("coins"):
		audio_player.play()
		coin_count += 1
		gui.get_node("label").text = "Coins: " + str(coin_count)
		parent.queue_free()
