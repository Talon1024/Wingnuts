extends Node
# Base class for pilots, which control ships

func _ready():
	var parent_ship = get_parent()
	if parent_ship.has_method("set_pilot"):
		parent_ship.set_pilot(self)

# This function is called during _process(). It modifies the ship controls,
# which are passed in as a dictionary. It should return the modified ship
# control dictionary.
func think(delta, controls: Dictionary) -> Dictionary:
	return controls