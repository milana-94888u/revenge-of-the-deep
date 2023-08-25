extends Node2D


func _process(_delta: float) -> void:
	var depth: float
	if has_node("Whale"):
		depth = clampf($Whale.position.y, 0.0, 928.0) / 928.0
	$DirectionalLight2D.energy = (1 - depth) * 2.0
