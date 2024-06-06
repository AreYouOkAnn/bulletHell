extends Area2D

@export var speed = 800
@export var power = 1
func _physics_process(delta):
	global_position.x += - speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Enemy:
		area.take_damage(power)
		queue_free()
