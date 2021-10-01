extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var min_speed = 100
export var max_speed = 200

signal enemy_died
signal chaos

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[ randi() % mob_types.size()]
	$VisibilityNotifier2D.connect("screen_exited",self, "on_screen_out" )
	self.connect("body_entered",self,"collision_handle")
	
func on_screen_out():
	queue_free()
	emit_signal("enemy_died")

func collision_handle( node ):
	linear_velocity = Vector2( linear_velocity.x*1.2, linear_velocity.y*1.2 )
	emit_signal("chaos")
	
func _process(delta):
	$AnimatedSprite.play()

func no_score_died( cls ):
	disconnect("enemy_died", cls, "score_tick")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
