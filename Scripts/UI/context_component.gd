class_name ContextComponent
extends CenterContainer

@export var icon: TextureRect
@export var context: Label
@export var default_icon: Texture2D

func _ready() -> void:
	#Globals.ui_context = self
	MessageBus.interaction_focused.connect(update)
	MessageBus.interaction_unfocused.connect(reset)
	reset()

func reset() -> void:
	icon.texture = null
	context.text = ""

func update_icon(image: Texture2D, override: bool) -> void:
	if override:
		icon.texture = image
	else:
		icon.texture = default_icon

func update_context(new_text: String) -> void:
	context.text = new_text

func update(new_text, image = default_icon, override= false) -> void:
	context.text = new_text
	if override:
		icon.texture = image
	else:
		icon.texture = default_icon
