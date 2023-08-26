extends CharacterBody2D
class_name Whale


signal dead


@export var speed := 100.0
@export var acceleration := 10.0
@export var friction := 15.0


@onready var sprite := $AnimatedSprite2D


var rotation_axis := Vector2.RIGHT

var growth_modifier := 1.0:
	set(value):
		if floori(value) >= 2: #floori(growth_modifier):
			set_level(floori(value))
		growth_modifier = value
		scale = Vector2.ONE * clampf(value * 2.0 / 3.0, 1.0, 2.5)
		$Camera2D.zoom = Vector2.ONE * clampf(5.0 - value, 2.0, 4.0)
		$UI/LevelProgressBar.value = value - 1.0


var air := 100.0:
	set(value):
		$UI/AirProgressBar.value = value
		air = value
		if value <= 0.0:
			die()


var breath_efficiency := 0.07


var action_to_direction := {
	"ui_up": Vector2.UP,
	"ui_right": Vector2.RIGHT,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT,
}

var input_direction: Vector2


func _ready() -> void:
	sprite.play("default")


func adjust_rotation() -> void:
	if velocity.x < 0:
		rotation_axis = Vector2.LEFT
		sprite.flip_h = true
	elif velocity.x > 0:
		rotation_axis = Vector2.RIGHT
		sprite.flip_h = false
	rotation = rotation_axis.angle_to(velocity)


func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	breath()
	if input_direction:
		accelerate(input_direction.normalized(), delta * 60.0)
	else:
		add_friction(delta * 60.0)
	adjust_rotation()
	move_and_slide()


func accelerate(direction: Vector2, delta_scale: float) -> void:
	velocity = velocity.move_toward(direction * speed, acceleration * delta_scale)


func add_friction(delta_scale: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta_scale)


func set_input_direction_strenght(event: InputEvent, action: StringName) -> void:
	var direction: Vector2 = action_to_direction[action]
	if event.is_action_pressed(action):
		input_direction += direction
	elif event.is_action_released(action):
		input_direction -= direction


func breath() -> void:
	if global_position.y < 32.0:
		air = 100.0
	else:
		air -= breath_efficiency


func capture(harpoon_x_position: float) -> void:
	if global_position.x > harpoon_x_position:
		skew = 0.25 * PI
	else:
		skew = -0.25 * PI
	set_process(false)
	set_process_unhandled_input(false)
	$CollisionShape2D.set_deferred("disabled", true)


func die() -> void:
	dead.emit()


func set_level(level: int) -> void:
	match level:
		1:
			speed = 100.0
			breath_efficiency = 0.07
			$UI/LevelProgressBar.min_value = 0.0
			$UI/LevelProgressBar.max_value = 1.0
			$UI/LevelProgressBar/Label.text = "Level 1"
		2:
			speed = 200.0
			breath_efficiency = 0.05
			$UI/LevelProgressBar.min_value = 1.0
			$UI/LevelProgressBar.max_value = 2.0
			$UI/LevelProgressBar/Label.text = "Level 2"
		3:
			speed = 300.0
			breath_efficiency = 0.03
			$UI/LevelProgressBar.min_value = 2.0
			$UI/LevelProgressBar.max_value = 3.0
			$UI/LevelProgressBar/Label.text = "Level 3"
		4:
			speed = 400.0
			breath_efficiency = 0.01
			$UI/LevelProgressBar.min_value = 3.0
			$UI/LevelProgressBar.max_value = 3.0
			$UI/LevelProgressBar/Label.text = "Level 4"


func eat_krill(krill: Krill) -> void:
	match krill.krill_level:
		1:
			growth_modifier += 0.01
		2:
			growth_modifier += 0.01
		3:
			growth_modifier += 0.02
	krill.queue_free()
