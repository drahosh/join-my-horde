extends ActionData
class_name Pillage

## Gold granted each time the action completes.
var gold_yield: float = 15.0

func _init(p_gold_yield: float = 15.0) -> void:
	gold_yield = p_gold_yield
	name = "Pillage"
	progress_speed = 1.0
	max_value = 4.0
	super._init()

func set_result_string() -> void:
	result_string = "+%s gold" % str(snappedf(gold_yield, 0.1))

func do_action() -> bool:
	Resources.gold += gold_yield
	return true
