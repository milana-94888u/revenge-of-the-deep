extends CharacterBody2D
class_name Whale


signal dead


@export var speed := 200.0
@export var acceleration := 10.0
@export var friction := 15.0


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
	InputEventAction.new()
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


func _unhandled_input(event: InputEvent) -> void:
	for action in action_to_direction:
		set_input_direction_strenght(event, action)


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


func eat_krill(krill: Krill) -> void:
	pass

