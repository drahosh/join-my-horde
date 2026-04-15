extends Control

@export var resource: ActionData

func _ready() -> void:
	if resource == null:
		push_error("Action: assign resource (ActionData).")
		return
	$ProgressBar.value = resource.current_progress
	$ProgressBar.max_value = resource.max_value
	sync_action_full()

func sync_action_basic() -> void:
	if resource == null:
		return
	$ProgressBar.value = resource.current_progress

func sync_action_full() -> void:
	if resource == null:
		return
	sync_action_basic()
	$ProgressBar.max_value = resource.max_value
	$HBoxContainer/Label.text = resource.name
	$HBoxContainer/RichTextLabel.text = resource.result_string + "\n"

func _input(event: InputEvent) -> void:
	if resource == null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			resource.active = !resource.active

func _process(delta: float) -> void:
	if resource == null:
		return
	if resource.active:
		resource.process(delta)
	sync_action_basic()
