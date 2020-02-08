extends "res://scenes/pilots/Pilot.gd"
class_name PilotPlayer, "res://editor/icons/pilot.png"

var yaw_amount: float
var pitch_amount: float
var roll_amount: float
var throttle: float
var afterburner: bool
var fire_gun: bool
var fire_missile: bool
var glide: bool
var throttle_increment: float
# State of each keyboard action as defined in the project settings.
# TODO: Move to the KeyboardControls node
var key_state = {}
onready var control_state: Node = $ControlState
var state_commands = [
	"pitch_up",
	"pitch_down",
	"turn_left",
	"turn_right",
	"roll_left",
	"roll_right",
]


# Look at the stored key state, and if the "pos" action is true, return 1.0,
# but if the "neg" action is true, return -1.0. Otherwise, return 0.0 if
# neither action is pressed.
func poll_key_pair_state(pos: String, neg: String) -> float:
	if key_state.get(pos, false):
		return 1.0
	elif key_state.get(neg, false):
		return -1.0
	else:
		return 0.0


# Look at the event, and if the given action was pressed, return true. If the
# given action was released, return false. Otherwise, return the original value.
func handle_boolean(action: String, event: InputEvent, orig_value: bool) -> bool:
	if event.is_action_pressed(action):
		return true
	elif event.is_action_released(action):
		return false
	return orig_value


# Set the default values for the actions to track with key_state.
func _ready():
	for command in state_commands:
		key_state[command] = false


# Handle input events
func _input(event):
	for command in state_commands:
		key_state[command] = handle_boolean(command, event, key_state[command])
	if event.is_action_pressed("speed_stop"):
		throttle = 0
	elif event.is_action_pressed("speed_full"):
		throttle = 1
	elif event.is_action_pressed("speed_increment"):
		throttle_increment = .25
	elif event.is_action_released("speed_increment"):
		throttle_increment = 0.0
	elif event.is_action_pressed("speed_decrement"):
		throttle_increment = -.25
	elif event.is_action_released("speed_decrement"):
		throttle_increment = 0.0
	if event.is_action_pressed("toggle_glide"):
		glide = not glide
	afterburner = handle_boolean("afterburner", event, afterburner)
	fire_gun = handle_boolean("fire_gun", event, fire_gun)
	fire_missile = handle_boolean("fire_missile", event, fire_missile)

# Handle player's inputs
func think(delta, controls: Dictionary) -> Dictionary:
	controls.pitch = poll_key_pair_state("pitch_up", "pitch_down")
	controls.yaw = poll_key_pair_state("turn_left", "turn_right")
	controls.roll = poll_key_pair_state("roll_left", "roll_right")
	throttle += throttle_increment * delta
	if throttle > 1:
		throttle = 1
	elif throttle < 0:
		throttle = 0
	controls.glide = glide
	controls.throttle = throttle
	controls.afterburner = afterburner
	controls.fire_gun = fire_gun
	controls.fire_missile = fire_missile
	return controls
