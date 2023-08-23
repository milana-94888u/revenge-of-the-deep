extends CharacterBody2D


var action_to_direction := {
	"ui_up": Vector2.UP,
	"ui_right": Vector2.RIGHT,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT,
}

var target_direction: Vector2


func _physics_process(delta: float) -> void:
	print(velocity)
	velocity = target_direction * 500
	move_and_slide()


func set_direction_strenght(event: InputEvent, action: StringName) -> void:
	var direction: Vector2 = action_to_direction[action]
	if event.is_action_pressed(action):
		target_direction += direction
	elif event.is_action_released(action):
		target_direction -= direction


func _unhandled_input(event: InputEvent) -> void:
	for action in action_to_direction:
		set_direction_strenght(event, action)
