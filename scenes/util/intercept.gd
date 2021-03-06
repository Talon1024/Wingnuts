extends Node

# https://indyandyjones.wordpress.com/2010/04/08/intercepting-a-target-with-projectile/
# Very important (paraphrased) excerpt from that particular blog post:
# Squaring or multiplying two vectors means taking their dot product.

# Calculate the time it will take for a projectile to hit a moving target,
# assuming constant velocities for both the projectile and target
static func get_lead_time(to_target: Vector3,
			target_vel: Vector3, shot_speed: float) -> float:
	var a = target_vel.length_squared() - shot_speed * shot_speed
	var b = 2 * target_vel.dot(to_target)
	var c = to_target.length_squared()
	var radicand = (b * b) - (4 * a * c)
	if radicand < 0:
		# Cannot calculate impact time. Maybe the target is moving too fast,
		# or vice versa.
		return 0.0
	# This aims ahead of the target. If the other root was used, the calculated
	# impact point would be behind the target.
	var time = (-b - sqrt(radicand)) / (2 * a)
	# It is more flexible to return just the impact time as opposed to the
	# impact position. Then, it is possible to calculate the impact position
	# like this: ImpactPos = TargetPos + (TargetVel * ImpactTime)
	return time


# Same as get_lead_time, but calculates to_target beforehand.
static func find_lead_time(shot_pos: Vector3, target_pos: Vector3,
			target_vel: Vector3, shot_speed: float) -> float:
	var to_target = target_pos - shot_pos
	return get_lead_time(to_target, target_vel, shot_speed)
