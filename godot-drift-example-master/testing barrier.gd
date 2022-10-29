extends KinematicBody2D
var vel = Vector2() #это создаём вектор хранящий в себе значения x и y
var speedX #это переменная

func _ready():
	randomize() #делаем по настоящему случайное число
	speedX = rand_range(-3, 3) #генерируем его
func _physics_process(delta):
	vel.x = speedX #задаём вектору со значением x скорость
	vel = move_and_slide(vel, Vector2(0, -1))

