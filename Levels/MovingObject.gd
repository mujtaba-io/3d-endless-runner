extends Node3D

var timer: Timer = Timer.new()

signal player_entered


func _ready():
	timer.wait_time = 5
	timer.autostart = true
# warning-ignore:return_value_discarded
	timer.timeout.connect(timer_timeout)
	add_child(timer)


# warning-ignore:unused_argument
func _process(delta):
	global_translate(Vector3(0, 0, 0.25))


func timer_timeout():
	#print("tree destroyed")
	queue_free()



func _on_area_3d_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		player_entered.emit()
