extends Node


# Classes
const Ship = preload("res://scenes/base/Ship.gd")


# Info
var ship: Ship


# At GodotCon Poznan 2019, someone talked about putting signals on singletons
# to help developers "manage complexity"
signal added
signal removed
