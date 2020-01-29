extends Node

# https://indyandyjones.wordpress.com/2010/04/08/intercepting-a-target-with-projectile/
# Calculate the time it will take for a projectile to hit a moving target,
# assuming constant velocities for both the projectile and target
static func get_lead_time(to_target: Vector3,
			target_vel: Vector3, shot_speed: float) -> float:
	var a = target_vel.length_squared() - shot_speed * shot_speed
	var b = 2 * target_vel.dot(to_target)
	var c = to_target.length_squared()
	var radicand = (b * b) - (4 * a * c)
	if radicand < 0:
		# Cannot calculate intercept time
		return -1.0
	var time = (-b - sqrt(radicand)) / (2 * a)
	return time

static func find_lead_time(shot_pos: Vector3, target_pos: Vector3,
			target_vel: Vector3, shot_speed: float) -> float:
	var to_target = target_pos - shot_pos
	return get_lead_time(to_target, target_vel, shot_speed)
