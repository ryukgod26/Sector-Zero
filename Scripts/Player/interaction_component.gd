class_name InteractionComponent
extends Node

var parent
@export var mesh: MeshInstance3D
@export var context: String
@export var override_icon: bool
@export var new_icon: Texture2D

signal player_interacted(object)

var highlight_material = preload("res://Materials/interactable_highlights.tres")

func _ready() -> void:
	parent = get_parent()
	connect_parent()
	set_default_mesh()

func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	parent.connect("focused",Callable(self,"in_range"))
	parent.connect("unfocused",Callable(self,"not_in_range"))
	parent.connect("interacted",Callable(self,"on_interact"))

func in_range() -> void:
	mesh.material_overlay = highlight_material
	MessageBus.interaction_focused.emit(context,new_icon,override_icon)
	#Globals.ui_context.update_context(context)
	#Globals.ui_context.update_icon(new_icon,override_icon)

func not_in_range() -> void:
	mesh.material_overlay = null
	#Globals.ui_context.reset()
	MessageBus.interaction_unfocused.emit()

func on_interact() -> void:
	print(parent.name)
	player_interacted.emit(parent)

func set_default_mesh() -> void:
	if not mesh:
		for child in parent.get_children():
			if child is MeshInstance3D:
				mesh = child
