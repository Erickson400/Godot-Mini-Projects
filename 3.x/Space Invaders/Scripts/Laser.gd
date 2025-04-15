extends Area

const speed = 200

func _ready():
	$Life_Time.start()

func _process(delta):
	translate(Vector3(0,0,-speed*delta))




func _on_Life_Time_timeout():
	queue_free()


func _on_Laser_area_entered(area):
	area.queue_free()
	queue_free()
	
	
