extends CharacterBody2D


@onready var physics_frames := ProjectSettings.get_setting("physics/common/physics_ticks_per_second") as float


@export var speed := 400.0
@export var acceleration := 40.0
@export var friction := 60.0


@onready var sprite := $AnimatedSprite2D


var rotation_axis := Vector2.RIGHT


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
	if input_direction:
		accelerate(input_direction.normalized(), delta * physics_frames)
	else:
		add_friction(delta * physics_frames)
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


func _unhandled_input(event: InputEvent) -> void:
	for action in action_to_direction:
		set_input_direction_strenght(event, action)