extends VBoxContainer

const _RowScene: PackedScene = preload("res://Ui/Huns/hun_rank_row.tscn")

@export var show_zero_ranks: bool = false

var _rows: Array[Control] = []
var _last_rank_count: int = -1


func _ready() -> void:
	_rebuild()


func _process(_delta: float) -> void:
	if Resources.huns.rank_count() != _last_rank_count:
		_rebuild()
	_update_rows()


func _rebuild() -> void:
	for c in get_children():
		c.free()
	_rows.clear()
	_last_rank_count = Resources.huns.rank_count()

	# Always show at least rank 0 row if we have no ranks yet.
	var rank_count := maxi(1, _last_rank_count)
	for rank in range(rank_count):
		var row: Control = _RowScene.instantiate()
		add_child(row)
		_rows.append(row)


func _update_rows() -> void:
	var max_pop := maxi(1, Resources.huns.max_count())
	for rank in range(_rows.size()):
		var value := Resources.huns.count_at(rank)
		_rows[rank].visible = show_zero_ranks or value > 0 or rank == 0
		_rows[rank].set_data(rank, value, max_pop)

