extends KinematicBody2D

var velocity = Vector2()
const acceleration = Vector2(0,-10)
const braking = 20
const resistances = 2 # трение о землю и воздух, постоянное для простоты.
# сила замедления колес, когда они не находятся в одном и том же положении
const wheelDriftResistance = 5 #направление относительно скорости
const maxSpeed = 1000
const rotationSpeed = .08
# минимальный процент разницы углов. Если направление более низкой скорости
const minWDrResStr = 0.05 # changed to car direction. 1 = PI/2, should be less then rotationSpeed
const spriteAngle = -PI/2 # default sprite image and thus acceleration vector angle
const spriteSize = Vector2(32,64)

func _physics_process(_delta):
	var res = resistances
	if Input.is_action_pressed("ui_a") or Input.is_action_pressed("ui_d"):
		if Input.is_action_pressed("ui_a"):
			$Sprite.rotation -= rotationSpeed
		else:
			$Sprite.rotation += rotationSpeed
	if Input.is_action_pressed('ui_w'):
		velocity += acceleration.rotated($Sprite.rotation)
		$Sprite/Particles2D.visible = true
	else:
		$Sprite/Particles2D.visible = false
		if Input.is_action_pressed('ui_s'):
			# pressing down is equivalent to braking, no reverse gear for simplicity
			res += braking
			
	if velocity.length() > res:
		# angle between where car is facing and where it actually moves (drifting)
		var angle = velocity.angle()-($Sprite.rotation-spriteAngle)
		# strength of wheel resistance to drift, strongest if drift perpendicular to car facing
		var wDrResStr = sin(angle)
		if abs(wDrResStr) > minWDrResStr:
			velocity += Vector2(wDrResStr*wheelDriftResistance,0).rotated($Sprite.rotation)
		else: # if angle difference in minimal, then we discard
		# drift portion of velocity and leave the other making car move where it faces
			velocity *= abs(cos(angle))
		# applying triction and braking, if we brake
		velocity += -velocity.normalized() * res
		if velocity.length() > maxSpeed:
			# limiting our velocity to maxSpeed
			velocity = velocity / velocity.length() * maxSpeed
	else:
		velocity = Vector2()
	# let's not forget to save remainder of velocity, so it can be processed in future frames,
	# if we don't do it, then we will not be able to slide/drift and accelerate more
	velocity = move_and_slide(velocity)
	
	# so we can stay on screen
	if position.x < -spriteSize.x:
		position.x = OS.get_window_size().x
	elif position.y < -spriteSize.y:
		position.y = OS.get_window_size().y
	elif position.x > OS.get_window_size().x+spriteSize.x:
		position.x = 0
	elif position.y > OS.get_window_size().y+spriteSize.y:
		position.y = 0
