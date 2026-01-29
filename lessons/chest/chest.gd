#get_node = $ pretty much a shortcut
extends Area2D
@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var possible_item: Array[PackedScene] = []

func open() -> void:
	animation_player.play("open")
	input_pickable = false
	if possible_item.is_empty():
		return
	for current_item in range(randi_range(1,3)):
		_spawn_random_item()

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	


func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 3.0, 6.0, 0.08)




func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 3.0, 5.0, 0.08)
	
func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)

func _input_event(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	if event_is_mouse_click:
		open()

func _spawn_random_item() -> void:
	var loot_item: Area2D = possible_item.pick_random().instantiate()
	add_child(loot_item)
	var random_angle := randf_range(0.0, 2.0 * PI)
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	var random_distance := randf_range(60,120)
	loot_item.position = random_direction * random_distance
