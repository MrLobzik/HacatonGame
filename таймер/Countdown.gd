extends Control

export (int) var seconds = 0
export (int) var minutes = 0
var dsecs = 0

func _physics_process(delta):
	if seconds > 0 and dsecs <= 0 :
		seconds -= 1
		dsecs = 10
	if minutes > 0 and seconds <=0 :
		minutes -= 1
		seconds = 60 
	
	if seconds >= 10:
		$sec.set_text(str(seconds))
	else:
		$sec.set_text("0"+str(seconds))
	if dsecs >= 10:
		$dsecs.set_text(str(dsecs))
	else:
		$dsecs.set_text("0"+str(dsecs))
	if minutes >= 10:
		$min.set_text(str(minutes))
	else:
		$min.set_text("0"+str(minutes))

func _on_Timer_timeout():
	if dsecs >=0:
		dsecs -= 1
	
	
