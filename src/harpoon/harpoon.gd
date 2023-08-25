extends Node2D
class_name Harpoon


signal launched
signal returned


enum MoveMode {KEEP, EXTEND, RETRACT}


@export var speed := 100.0
@export var length := 150.0


var move_mode := MoveMode.KEEP
var direction := Vector2.DOWN


@onready var rope_line := $RopeLine as Line2D
@onready var head := $HeadArea as Area2D


func get_rope_vector() -> Vector2:
	return rope_line.points[1] - rope_line.points[0]


func set_head_position(pos: Vector2) -> void:
	rope_line.points[1] = pos
	head.position = pos


func launch(launch_direction: Vector2) -> void:
	if move_mode != MoveMode.KEEP:
		return
	direction = launch_direction.normalized()
	head.rotation = Vector2.RIGHT.angle_to(direction)
	move_mode = MoveMode.EXTEND
	launched.emit()


func extend(change: Vector2) -> void:
	set_head_position(head.position + change)
	if get_rope_vector().length() >= length:
		move_mode = MoveMode.RETRACT


func retract(change: Vector2) -> void:
	set_head_position(head.position - change)
	if get_rope_vector().length() < length * 0.1:
		set_head_position(Vector2.ZERO)
		move_mode = MoveMode.KEEP
		returned.emit()


func _physics_process(delta: float) -> void:
	var frame_change := delta * speed * direction
	match move_mode:
		MoveMode.EXTEND:
			extend(frame_change)
		MoveMode.RETRACT:
			retract(frame_change)


func _on_head_area_body_entered(body: Node2D) -> void:
	if body is Whale:
		body
