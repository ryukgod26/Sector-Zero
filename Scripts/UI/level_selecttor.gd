extends Control


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")



func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_3.tscn")


func _on_test_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/test/game.tscn")
