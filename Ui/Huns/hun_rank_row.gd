extends Control

@onready var _tier: Label = $HBox/Tier
@onready var _count: Label = $HBox/Count
@onready var _bar_area: Control = $HBox/BarArea
@onready var _bar: ColorRect = $HBox/BarArea/Bar

var _rank: int = 0
var _value: int = 0
var _max_value: int = 1


func set_data(rank: int, value: int, max_value: int) -> void:
	_rank = rank
	_value = value
	_max_value = maxi(1, max_value)
	_tier.text = _rank_badge(rank)
	_count.text = str(value)
	_update_bar()


func _process(_delta: float) -> void:
	_update_bar()


func _update_bar() -> void:
	var area_w := _bar_area.size.x
	if area_w <= 0.0:
		return
	var fraction := float(_value) / float(_max_value)
	var w := area_w * clampf(fraction, 0.0, 1.0)
	_bar.position.x = (area_w - w) * 0.5
	_bar.size.x = w


func _rank_badge(rank: int) -> String:
	# MLM-ish “tier” names. Keep as text until you have real textures.
	match rank:
		0: return "Bronze"
		1: return "Silver"
		2: return "Gold"
		3: return "Platinum"
		4: return "Diamond ◆"
		5: return "Double Diamond ◆◆"
		6: return "Triple Diamond ◆◆◆"
		_: return "Elite ◆×%d" % (rank - 3)

