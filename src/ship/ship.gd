extends Sprite2D


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Whale:
		body
