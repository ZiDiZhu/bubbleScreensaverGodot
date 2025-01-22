extends Node2D

class_name Bubble

var velocity = Vector2(200, 150) 
signal popped

var screen_size 
var sprite_size

var isReleased : bool= true # if the bubble is frr floating

func _ready():
	screen_size = get_viewport().size
	sprite_size = $Sprite2D.texture.get_size()

func _process(delta):
	if isReleased:
		if mouseIsOver():
			bounce(delta*0.5)
		else:
		#if position.y - sprite_size.y/2  > -screen_size.y/2: #if on top of screen stop floating
			#floatUp(delta)
		#else: 
			bounce(delta)
		
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if mouseIsOver():
			print("popped")
			emit_signal("popped")
			queue_free()
	
func mouseIsOver() -> bool:
	if global_position.distance_to(get_global_mouse_position())<sprite_size.x/2:
		return true
	return false
	
func floatUp(delta):
	if position.y - sprite_size.y/2  > -screen_size.y/2: #if on top of screen stop floating
		position.y -= velocity.y * delta
	
func bounce(delta):
	# Move the logo
	position += velocity * delta
	# Bounce off the edges
	if isOutOfBoundLeft() or isOutOfBoundRight():
		velocity.x = -velocity.x
	if isOutOfBoundUp() or isOutOfBoundDown():
		velocity.y = -velocity.y

func isOutOfBoundLeft() -> bool:
	if position.x < sprite_size.x/2 -screen_size.x/2:
		return true
	return false

func isOutOfBoundRight() -> bool:
	if  position.x + sprite_size.x/2 > screen_size.x/2:
		return true
	return false
	
func isOutOfBoundUp() -> bool:
	if position.y < sprite_size.y/2 -screen_size.y/2:
		return true
	return false

func isOutOfBoundDown() -> bool:
	if position.y + sprite_size.y/2 > screen_size.y/2:
		return true
	return false
