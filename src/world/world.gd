extends Node2D


func _process(_delta: float) -> void:
	$Borders/Upper.position = Vector2(60.0, -24.0 * $Whale.scale.x)
	var depth: float
	depth = clampf($Whale.position.y, 0.0, 928.0) / 928.0
	$DirectionalLight2D.energy = (1 - depth) * 2.0


func _on_whale_dead() -> void:
	get_tree().reload_current_scene()


func _ready() -> void:
	get_tree().paused = false
