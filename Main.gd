extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("hit",self,"game_over")
	$StartTimer.connect("timeout",self,"game_start")
	# $ScoreTimer.connect("timeout",self,"score_tick")
	$MobTimer.connect("timeout",self,"mob_spawn")
	$HUD.connect("start_game", self, "new_game" )
	
	randomize()

func game_start():
	$MobTimer.start()
	
func score_tick( inp ):
	score += float(inp)
	$HUD.update_score( score )
	
func mob_spawn():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var mob = Mob.instance()
	add_child(mob)
	mob.connect("enemy_died", self, "score_tick", [ 1 ])
	mob.connect("chaos", self, "score_tick", [ 0.2 ] )
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	
	direction += rand_range( -PI/4 , PI/4 )
	mob.rotation = direction
	
	mob.linear_velocity = Vector2( rand_range(mob.min_speed,mob.max_speed), 0 )
	mob.linear_velocity = mob.linear_velocity.rotated( direction )
	
	
func game_over():
	$MobTimer.stop()
	$HUD.game_over()
	get_tree().call_group("mobs","no_score_died", self)
	get_tree().call_group("mobs","queue_free")
	$Music.stop()
	$DeathMusic.play()
	
func new_game():
	score = 0
	$Player.start( $StartPosition.position )
	$HUD.update_score( score )
	$HUD.show_message("Get Ready")
	$StartTimer.start()
	$DeathMusic.stop()
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
