extends RefCounted
class_name HunPyramid
## Ranked hun counts (MLM-style pyramid). Rank 0 is the “leaf” tier.
## Raid: rank 0+ → passive gold/sec. Recruit: rank 1+ → new rank-0 huns/sec.
##
## Coaching (not implemented): a hun of rank x should be able to take a hun of rank 0..x-2
## and increase that hun’s rank by 1. Requires pairing rules, validation, and UI later.

## Gold per second from one hun at rank 0 before multipliers. Higher ranks scale via _raid_rank_multiplier.
var raid_gold_per_hun_at_rank: float = 0.06

## Rank-0 huns per second from one recruiter at rank 1 before multipliers. Ranks >= 1 recruit.
var recruit_rank0_per_hun_at_rank: float = 0.04

var _counts: Array[int] = []
var _recruit_accumulator: float = 0.0


func count_at(rank: int) -> int:
	if rank < 0 or rank >= _counts.size():
		return 0
	return _counts[rank]


func total_huns() -> int:
	var n := 0
	for c in _counts:
		n += c
	return n


func set_count(rank: int, amount: int) -> void:
	_ensure_rank(rank)
	_counts[rank] = maxi(0, amount)


func add(rank: int, amount: int) -> void:
	if amount <= 0:
		return
	_ensure_rank(rank)
	_counts[rank] += amount


## Returns false if not enough huns at that rank.
func try_remove(rank: int, amount: int) -> bool:
	if amount <= 0:
		return true
	if count_at(rank) < amount:
		return false
	_counts[rank] -= amount
	_trim_trailing_zeros()
	return true


func raid_gold_per_sec() -> float:
	var total := 0.0
	for rank in range(_counts.size()):
		total += float(_counts[rank]) * raid_gold_per_hun_at_rank * _raid_rank_multiplier(rank)
	return total


func recruit_rank0_per_sec() -> float:
	var total := 0.0
	for rank in range(1, _counts.size()):
		total += float(_counts[rank]) * recruit_rank0_per_hun_at_rank * _recruit_rank_multiplier(rank)
	return total


func process_recruitment(delta: float) -> void:
	var rate := recruit_rank0_per_sec()
	if is_zero_approx(rate):
		return
	_recruit_accumulator += rate * delta
	while _recruit_accumulator >= 1.0:
		add(0, 1)
		_recruit_accumulator -= 1.0


func _raid_rank_multiplier(rank: int) -> float:
	return 1.0 + float(rank) * 0.12


func _recruit_rank_multiplier(rank: int) -> float:
	return 1.0 + float(rank - 1) * 0.1


func _ensure_rank(rank: int) -> void:
	while _counts.size() <= rank:
		_counts.append(0)


func _trim_trailing_zeros() -> void:
	while _counts.size() > 0 and _counts[_counts.size() - 1] == 0:
		_counts.resize(_counts.size() - 1)
