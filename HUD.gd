extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$MessageTimer.connect("timeout", self, "on_msg_timeout" )
	$Restart.connect("pressed",self, "on_start" )
	$Instructions.show()
	pass # Replace with function body.

func show_message( text ):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func on_msg_timeout():
	$Message.hide()
	
func on_start():
	$Restart.hide()
	$Instructions.hide()
	emit_signal("start_game")
	
func game_over():
	show_message("YOU DIED")
	yield($MessageTimer, "timeout" )
	$Restart.show()
	$Instructions.show()
	
func update_score(score):
	$Score.text = str(score)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
