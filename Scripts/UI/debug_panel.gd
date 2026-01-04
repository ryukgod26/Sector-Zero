extends PanelContainer

@onready var property_container: VBoxContainer = $MarginContainer/VBoxContainer

#var property
var fps: String

func _ready() -> void:
	visible = false
	Globals.debug = self
	#add_debug_property("FPS",fps)

func _process(delta: float) -> void:
	if not visible:
		return
	fps = "%.2f" % (1.0/delta)
	#property.text = property.name + ": " + fps

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = not visible

func add_property(title: String,value,order):
	var target = property_container.find_child(title,true,false)
	
	if  not target :
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = target.name + ': ' + str(value)
		property_container.move_child(target,order)

#func add_debug_property(title: String,val):
	#property = Label.new()
	#property_container.add_child(property)
	#property.name = title
	#property.text = property.name + val
