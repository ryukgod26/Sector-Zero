extends CanvasLayer

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused

func _on_resume_pressed() -> void:
	get_tree().paused = not get_tree().paused


func _on_quit_pressed() -> void:
	get_tree().quit(0)
