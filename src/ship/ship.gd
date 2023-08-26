extends PathFollow2D


@export var speed := 50.0

var moving := true

@onready var harpoon := $Harpoon as Harpoon


func _physics_process(delta: float) -> void:
	if moving:
		progress += speed * delta


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Whale:
		if body.growth_modifier < 4.0:
			harpoon.launch(body.global_position - global_position)


func _on_harpoon_launched() -> void:
	moving = false


func _on_harpoon_returned() -> void:
	moving = true


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Whale:
		if body.growth_modifier >= 4.0:
			call_deferred("remove_child", $Ship)
			call_deferred("remove_child", $Harpoon)
			call_deferred("remove_child", $AttackArea)
			call_deferred("remove_child", $DamageArea)
			$DestroyParticles.emitting = true
		body.end_game()
