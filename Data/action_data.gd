extends Resource
class_name ActionData

# When active, progresses over time until complete, then does something and resets 

var active:bool=false
var progress_speed:float=1 #progress per second
var max_value:float=1
var name: String
var result_string: String
var current_progress:float=0 

func _init():
	set_result_string()
	
func set_result_string()->void:
	# implement in instance
	pass 

func process(delta:float):
	# Called from _process function in ui
	current_progress+= delta*progress_speed
	if current_progress >= max_value:
		var done:bool = do_action()
		if done:
			current_progress-=max_value
		else:
			active=false
func do_action()->bool:
	# Do something and return true
	# If it can't be done (for example lack of gold), do nothing and return false
	# implement in instance
	return true
