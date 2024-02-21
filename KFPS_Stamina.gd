extends Node

##Add to a KFPS_Actor to manage stamina
class_name KFPS_Stamina

@export var capacity:float = 100

var pool:float = capacity

@export var recovery_rate:float = 10

@export var recovery_delay:float = 1

var since:float = 0

func _ready():
	pass

func _physics_process(delta):
	since += delta
	if since >= recovery_delay:
		pool = move_toward(pool,capacity,delta*recovery_rate)

func use(amount:float)->bool:
	pool = clamp(pool-amount,0,capacity)
	since = 0
	return pool-amount >= 0

func replenish(amount:float):
	pool = clamp(pool+amount,0,capacity)
	since = 0

func get_stamina_percent()->float:
	return pool/capacity
