extends Node2D

var show = false

func _process(delta: float) -> void:
	$Control/Control.visible = show

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_about_pressed() -> void:
	if show == true:
		show = false
	else:
		show = true
