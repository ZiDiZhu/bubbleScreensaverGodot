extends Control

var is_running = false
var elapsed_time = 0.0

@onready var bgmToggle := $bgmToggle 
@onready var bgm_selector = $OptionButton
@onready var bgm = $bgm
var bgm_tracks = [preload("res://Assets/blue_moon_apartment.wav"), preload("res://Assets/bbblllsss.ogg"), preload("res://Assets/bbblllsss2.ogg")]
# Current track index
var current_track_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgmToggle.toggled.connect(_on_toggle_music)
	start()
	bgm_selector.clear()
	for i in range(bgm_tracks.size()):
		bgm_selector.add_item("BGM " + str(i + 1))

	# Set the first track as default and play it
	play_track(current_track_index)

	# Connect the dropdown menu signal
	bgm_selector.connect("item_selected", _on_bgm_selected)

	# Connect to track finished signal
	bgm.connect("finished",_on_track_finished)

func play_track(index):
	# Change the current track
	bgm.stream = bgm_tracks[index]
	bgm.play()

func _on_bgm_selected(index):
	# User selects a track from the dropdown menu
	current_track_index = index
	play_track(current_track_index)

func _on_track_finished():
	# Loop to the next track when the current one finishes
	current_track_index = (current_track_index + 1) % bgm_tracks.size()
	play_track(current_track_index)
	
	
func _process(delta):
	# Update the elapsed time if the stopwatch is running
	if is_running:
		elapsed_time += delta
		$TimerLabel.text = format_time(elapsed_time)
	$DateLabel.text = format_datetime(Time.get_datetime_string_from_system())

func format_datetime(datetime_string):
	# Example format: "2025-01-25T19:20:00"
	var datetime = datetime_string.split("T")  # Split into date and time
	var date = datetime[0]  # "2025-01-25"
	var time = datetime[1].substr(0, 5)  # "19:20" (only hours and minutes)

	# Parse the date into year, month, day
	var date_parts = date.split("-")
	var year = date_parts[0]
	var month = date_parts[1]
	var day = date_parts[2]

	# Combine into the desired format
	return "%s/%s/%s %s" % [year, month, day, time]



func _on_toggle_music(button_pressed: bool):
	# CheckButton toggles music on/off
	if button_pressed:
		$bgm.play()
	else:
		$bgm.stop()


# Function to start the stopwatch
func start():
	is_running = true

# Function to stop the stopwatch
func stop():
	is_running = false

# Function to reset the stopwatch
func reset():
	is_running = false
	elapsed_time = 0.0
	$TimerLabel.text = "0:00.00"
	

func format_time(seconds):
	var hours = int(seconds) / 3600
	var minutes = (int(seconds) % 3600) / 60
	var secs = int(seconds) % 60
	return "%d:%02d:%02d" % [hours, minutes, secs]


func _on_exit_pressed() -> void:
	pass # Replace with function body.
