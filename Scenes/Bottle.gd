extends Node2D

var normalSprite = preload("res://Assets/bubble_blower_1.png")
var selectedSprite = preload("res://Assets/bubble_blower_1_selected.png")
var bottleSprite = preload("res://Assets/bubble_blower_1_bottle1.png")
var wandSprite = preload("res://Assets/bubble_blower_1_wand2.png")


var bubble_scene = preload("res://Scenes/bubble.tscn")
var current_bubble : Bubble = null  # To track the bubble being created
var bubble_timer = 0.0  # To control bubble growth
const MAX_BUBBLE_SIZE = 2.0  # Maximum scale factor for bubbles


var sprite_size
var is_selected = false  # Tracks if the sprite is clicked
var wand_instance: Sprite2D  # Instance for the wand sprite

func _ready() -> void:
	sprite_size = $Sprite2D.texture.get_size()
	
	# Create the wand sprite instance but hide it initially
	wand_instance = Sprite2D.new()
	wand_instance.texture = wandSprite
	wand_instance.visible = false
	add_child(wand_instance)

func _process(delta: float) -> void:
	# Handle hover effect
	if is_selected:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if current_bubble == null:
				create_bubble()
			else:
				grow_bubble(delta)
				# current_bubble.position = current_bubble.to_global(get_global_mouse_position())
		elif Input.is_action_just_released("left_click") and current_bubble != null:
			release_bubble()
	if mouseIsOver() and not is_selected:
		$Sprite2D.texture = selectedSprite
	else:
		if not is_selected:
			$Sprite2D.texture = normalSprite
	
	# Update wand position if it is visible
	if wand_instance.visible:
		wand_instance.global_position = get_global_mouse_position()-Vector2(wand_instance.texture.get_width()/5,0) #offset

func _input(event: InputEvent) -> void:
	# Handle click event to toggle selected state
	if event is InputEventMouseButton and event.pressed and mouseIsOver():
		is_selected = not is_selected
		if is_selected:
			$Sprite2D.texture = bottleSprite  # Show the bottle sprite
			wand_instance.visible = true     # Show the wand
		else:
			$Sprite2D.texture = normalSprite  # Reset to the normal sprite
			wand_instance.visible = false    # Hide the wand

func create_bubble():
	# Spawn a new bubble at the wand's tip
	current_bubble = bubble_scene.instantiate()
	print("new bubble")
	current_bubble.isReleased = false
	current_bubble.velocity = Vector2(0,0)
	#offset the transform of the bubble blower bottle
	current_bubble.position = current_bubble.to_global(get_global_mouse_position()-Vector2(wand_instance.texture.get_width()/2,0))
	get_tree().root.add_child(current_bubble)

func grow_bubble(delta):
	# Gradually increase the size of the bubble
	if current_bubble.scale.x < MAX_BUBBLE_SIZE:
		bubble_timer += delta
		current_bubble.scale += Vector2(delta * 0.5, delta * 0.5)

func release_bubble():
	# Start moving the bubble upwards
	current_bubble.velocity = Vector2(randf_range(-100, 100), -200)
	current_bubble.isReleased = true
	current_bubble = null
	bubble_timer = 0.0
	


func mouseIsOver() -> bool:
	# Check if the mouse is within the sprite bounds
	return global_position.distance_to(get_global_mouse_position()) < sprite_size.x / 2
