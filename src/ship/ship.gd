extends PathFollow2D


@export var speed := 50.0

var moving := true

@onready var harpoon := $Harpoon as Harpoon


func _physics_process(delta: float) -> void:
	if moving:
		progress += speed * delta


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Whale:
		harpoon.launch(body.global_position - global_position)


func _on_harpoon_launched() -> void:
	moving = false


func _on_harpoon_returned() -> void:
	moving = true
