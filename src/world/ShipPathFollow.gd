extends PathFollow2D


@onready var physics_frames := ProjectSettings.get_setting("physics/common/physics_ticks_per_second") as float


@export var speed := 5


@onready var ship := $Ship as Sprite2D
#@onready var 


func _physics_process(delta: float) -> void:
	progress += speed * delta * physics_frames
