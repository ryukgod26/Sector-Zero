extends Node

@export var _weapon_resources: Array[Weapons]
@export var start_weapons: Array[String]

var currnt_weapon = null
var weapon_stack = []
var wapon_indiator = 0
var next_weapon: String
var weapon_list = {}

func _ready() -> void:
	Intialize(start_weapons)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon1"):
		weapon_indicator = min(weapon_indicator+1,weapon_stack.size()-1)
		exit(weapon_stack[weapon_indicator])
	
	if event.is_action_pressed("weapon2"):
		weapon_indiicator = max(weapon_indicator-1,0)
		exit(weapon_stack[weapon_indicator])

func Intialize(_start_weapons: Array):
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	
	for i in _start_weapons:
		weapon_stack.push_back(i)
	
	currnt_weapon = weapon_list[weapon_stack[0]]
	enter()

func enter():
	#animation_player.queue(currnt_weapon.activate_info)
	pass

func exit(_next_weapon: String):
	if _next_weapon != currnt_weapon.weapon_name:
		pass

func change_weapon():
	pass
