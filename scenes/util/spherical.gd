extends Node

# Convert Cartesian coordinates to Spherical coordinates
# https://en.wikipedia.org/wiki/Spherical_coordinate_system#Coordinate_system_conversions
static func to_spherical(vector: Vector3) -> Vector3:
	var distance = vector.length()
	var normalized_vector = Vector3.FORWARD if distance == 0 else vector.normalized()
	var azimuth = atan2(normalized_vector.x, -normalized_vector.z)
	var inclination = acos(-normalized_vector.y)
	return Vector3(azimuth, inclination, distance)
