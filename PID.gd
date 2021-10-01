extends Node
class_name PID

var _prev_error = Vector2( 0.0, 0.0 )
var _integral = Vector2( 0.0, 0.0 )
var _int_max = 200
export var _Kp: float = 2
export var _Ki: float = 0.01
export var _Kd: float = 0.01


func _ready():
	pass

func calculate(setpoint, pv, dt ):
	if dt == 0:
		return pv
		
	var error = setpoint - pv
	var tkp 
	var tki 
	var tkd
	
	if error.length_squared() < 16:
		tkp = _Kp
		tki = 0
		tkd = 0
	else:
		tkp = _Kp
		tki = _Ki
		tkd = _Kd
		
	var Pout = tkp * error
	
	_integral += error * dt
	var Iout = tki * _integral
	
	var derivative = (error - _prev_error) / dt
	var Dout = tkd * derivative
	
	var output = Pout + Iout + Dout
	
	if _integral.length() > _int_max:
		_integral = _integral.normalized() * _int_max
	_prev_error = error
	return output

func reset_integral():
	_integral = Vector2( 0.0, 0.0 )
