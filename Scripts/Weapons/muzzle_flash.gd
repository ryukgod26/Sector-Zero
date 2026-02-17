extends Node3D

@export var weapon: WeaponController
@export var flash_time := .05
@onready var omni_light: OmniLight3D = $OmniLight3D
@onready var gpu_particles: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
	omni_light.visible = false
	weapon.weapon_fired.connect(add_muzzle_flash)

func add_muzzle_flash() -> void:
	omni_light.visible = true
	gpu_particles.emitting = true
	await get_tree().create_timer(flash_time).timeout
	omni_light.visible = false
