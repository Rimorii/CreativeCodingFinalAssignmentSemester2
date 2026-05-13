extends StaticBody3D
	
func interact():
	
	%PickupSound.play()
	await %PickupSound.finished
	print("Interacted!")
	queue_free()
