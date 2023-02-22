class_name FluddPickup
extends Pickup


@export var nozzle_award: int # (Singleton.n)


func _award_pickup(body):
	body.current_nozzle = nozzle_award
	body.water = max(body.water, 100)
	body.switch_anim(body.sprite.animation.replace("_fludd", ""))
	queue_free()
