extends Node
# Autoloaded as "Resources"

var gold: float
var rep: float
## Total passive gold/sec this frame (raids from huns + bonus).
var gold_per_sec: float
var rep_per_sec: float

## Extra gold/sec not from hun raids (upgrades, buffs, …). Added to raid output each tick.
var gold_per_sec_bonus: float = 0.0

## Ranked huns (pyramid). Raid and recruit rates are derived from this.
var huns: HunPyramid = HunPyramid.new()

# TODO put formatting here

func _ready() -> void:
	# Starter muster so raid/recruit loop is visible without UI.
	huns.add(0, 3)
	huns.add(1, 1)


func _process(delta: float) -> void:
	var from_raids: float = huns.raid_gold_per_sec()
	gold_per_sec = from_raids + gold_per_sec_bonus
	gold += gold_per_sec * delta
	rep += rep_per_sec * delta
	huns.process_recruitment(delta)
	# TODO guards if per secs can be negative, haven't decided yet
