extends Panel

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = not visible


func _on_Unpause_button_up():
	get_tree().paused = not get_tree().paused
	visible = not visible
