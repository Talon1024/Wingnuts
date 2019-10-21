extends Object
# Base class for pilots, which control ships

# This function is called during _process(). It modifies the ship controls,
# which are passed in as a dictionary. It should return the modified ship
# control dictionary.
func think(delta, controls: Dictionary) -> Dictionary:
	return controls