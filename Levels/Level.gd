extends Node

@export var player: CharacterBody3D
@export var spawn_timer: Timer
@export var spawn_env_timer: Timer
@export var spawn_obstacle_timer: Timer


@export var coin: PackedScene

@export var rock:  PackedScene

@export var road: PackedScene

var startz: float = -50.0
var road_spawnx: Array = [-2, 0, 2]
var tree_startx: Array = [10, -10]



func _ready():
	var x = 0
	var y = 0
	var z = 5
	
	
	
	# Spawn road first (after this, spawn after timeout)
	var road_asset = road.instantiate()
	add_child(road_asset)
	road_asset.global_transform.origin = Vector3(
		0,
		0,
		startz
	)



func _on_spawn_timer_timeout():
	randomize()
	#print("spawned a coin!")
	spawn_timer.wait_time = randi() % 5 + 1 
	
	var random_line_num = randi() % 3
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1
	
	for i in line_count:
		while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
				random_line_num = randi() % 3
		prev_rand_line_n = random_line_num

		for n in randf_range(4, 10):
		
			var coin_inst: MeshInstance3D = coin.instantiate()
	
			add_child(coin_inst)
	
			coin_inst.global_transform.origin = Vector3(
				road_spawnx[random_line_num],
				1.0,
				startz + i * 2.5 # set distance between coins
			)




func _on_spawn_obstacle_timer_timeout():
	randomize()
	#print("spawned an obstacle!")
	spawn_obstacle_timer.wait_time = randi() % 5 + 1
	
	var random_line_num = randi() % 3
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1
	
	for i in line_count:
		while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
				random_line_num = randi() % 3
		prev_rand_line_n = random_line_num

		var rock_inst = rock.instantiate()
# warning-ignore:return_value_discarded
		rock_inst.player_entered.connect(on_player_entered_rock)
	
		add_child(rock_inst)
	
		rock_inst.global_transform.origin = Vector3(
			road_spawnx[random_line_num],
			0.0,
			startz
		)
		rock_inst.rotation_degrees.y = randf_range(0, 360)


func _on_road_spawn_timer_timeout():
	var road_asset = road.instantiate()
	add_child(road_asset)
	road_asset.global_transform.origin = Vector3(
		0,
		0,
		startz
	)
	# After 1st shot, make it 1.85
	($RoadSpawnTimer as Timer).wait_time = 1.85

func on_player_entered_rock():
	player.is_dead = true
	print("Player died!")
	get_tree().paused = true

