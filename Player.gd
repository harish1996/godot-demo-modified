extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var max_speed= 350
var m_s_2 = max_speed * max_speed
var screen_size
var target = Vector2()
var velocity = Vector2(0,0)
export var accel = 100

signal hit
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	self.connect("body_entered",self,"on_body_entered")
	hide()

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var sprite = $AnimatedSprite
#	print(target,position)
	var diff = target-position
	var new_v
	
	if target != position:
		new_v = $PID.calculate( diff, velocity, delta )
		if ( new_v - velocity ).length() > accel * delta:
			velocity += ( new_v - velocity ).normalized() * accel * delta
		else:
			velocity = new_v
			 
		if velocity.length_squared() > m_s_2:
			velocity = velocity.normalized() * max_speed
			$AnimatedSprite.play()
			
		$AccelerationPointer.set_rotation( diff.angle())
		$AccelerationPointer.set_scale( Vector2( clamp( diff.length()/accel, 0 , 1 ), 0.3 ) )
		$VelocityPointer.set_rotation( velocity.angle() )
		$VelocityPointer.set_scale( Vector2( clamp( velocity.length()/max_speed, 0 , 1 ), 0.3 ) )
	else:
		$AnimatedSprite.stop()
			
#	if velocity.length_squared() < 4:
#		velocity.x = 0 
#		velocity.y = 0
		
#	if velocity.length_squared() > 0:
#		velocity = velocity.normalized() * speed
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp( position.x, 0, screen_size.x )
	position.y = clamp( position.y, 0, screen_size.y )
	if [ 0, screen_size.x ].has(position.x):
		velocity.x = 0
	if [ 0, screen_size.y ].has(position.y):
		velocity.y = 0
	
	if velocity.x != 0:
		sprite.animation = "walk"
		sprite.flip_v = false
		sprite.flip_h = velocity.x > 0
	elif velocity.y != 0:
		sprite.animation = "up"
		sprite.flip_h = false
		sprite.flip_v = velocity.y > 0
		

func on_body_entered(_node):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled",true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
