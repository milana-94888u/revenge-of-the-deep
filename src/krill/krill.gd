extends Node2D
class_name Krill


@export var krill_level := 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Whale:
		body.eat_krill(self)
