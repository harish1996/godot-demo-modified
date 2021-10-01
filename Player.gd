extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed=250
var screen_size
var target = Vector2()

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
	var velocity  = Vector2()
	var sprite = $AnimatedSprite
	
	
	velocity = target - position
	if velocity.length_squared() < 4:
		velocity.x = 0 
		velocity.y = 0
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp( position.x, 0, screen_size.x )
	position.y = clamp( position.y, 0, screen_size.y )
	
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
	
	
