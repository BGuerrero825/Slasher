extends CanvasLayer


func _ready():
	hide()


func show():
	$death_notice.show()
	pause_mode = Node.PAUSE_MODE_PROCESS


func hide():
	$death_notice.hide()
	pause_mode = Node.PAUSE_MODE_STOP


func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene("res://main_menu.tscn")
