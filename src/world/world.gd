extends Node2D


func _process(delta: float) -> void:
	var depth := clampf($Whale.position.y, 0.0, 928.0) / 928.0
	$DirectionalLight2D.energy = (1 - depth) * 2.0