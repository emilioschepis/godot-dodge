extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Music.play()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var mob = Mob.instance()
	add_child(mob)

	mob.position = $MobPath/MobSpawnLocation.position

	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
