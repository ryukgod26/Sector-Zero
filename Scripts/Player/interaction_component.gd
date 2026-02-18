class_name InteractionComponent
extends Node

var parent
@export var mesh: MeshInstance3D

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

func not_in_range() -> void:
	mesh.material_overlay = null

func on_interact() -> void:
	print(parent.name)

func set_default_mesh() -> void:
	if not mesh:
		for child in parent.get_children():
			if child is MeshInstance3D:
				mesh = child
