class_name Weapons
extends Resource


@export var name: StringName
@export_category("Weapon Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export var scale: Vector3
@export_category("weapon Sway")
@export var sway_min = Vector2(-20.,-20.)
@export var sway_max = Vector2(20.,20.)
@export_range(0,0.2,0.01) var sway_speed_position := 0.07
@export_range(0,0.2,0.01) var sway_speed_rotation := 0.1
@export_range(0,0.25,0.01) var sway_amount_position := 0.1
@export_range(0,50,0.1) var sway_amount := 30.
@export var idle_sway_adjustment := 10.
@export var idle_sway_rotation_strength := 300.
@export_range(0.1,10.,0.1) var random_sway_amount := 5.
@export_category("Visual Settings")
@export var mesh: Mesh
@export var shadow: bool
