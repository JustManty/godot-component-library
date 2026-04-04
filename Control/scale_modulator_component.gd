class_name ScaleModulatorComponent
extends Node

var _parent : Node = get_parent()
var _current_state : _State
var _min_size_percent : float = 100
var _max_size_percent : float = 100

enum _State {GROWING, SHRINKING}

@export var growth_amount : int = 0 ## The amount to grow and/or shrink by as a percentage
@export var growth_rate : int = 5 ## The rate of change in the node's scale
@export var do_shrink : bool = false ## Should this node shink from its original size?
@export var do_grow : bool = false ## Should this node grow from its original size?

func _ready() -> void:
	if _parent is Control:
		if growth_amount < 0:
			push_warning("SizeModulatorComponent's Growth Amount cannot be less than zero.  Setting to 0 at runtime.")
			growth_amount = 0
			
		if do_shrink:
			_current_state = _State.SHRINKING
			_min_size_percent = maxf(0, _parent.scale - _parent.scale * growth_amount / 100)
			
		if do_grow:
			_current_state = _State.GROWING
			_max_size_percent = _parent.scale + _parent.scale * growth_amount / 100
		
		if not do_grow and not do_shrink:
			push_warning("SizeModulatorComponent must have `Do Shrink` or `Do Grow` selected to have any effect on its parent node.")
	
	else:
		push_error("SizeModulatorComponent is attached to " + _parent.name + " but should only be used with a Control node.")
		return

func _process(delta: float) -> void:
	if _parent is Control:
		if _current_state == _State.GROWING:
			if _parent.scale < _max_size_percent / 100:
				_parent.scale += growth_rate * delta
			else:
				_current_state = _State.SHRINKING
		elif _current_state == _State.SHRINKING:
			if _parent.scale > _min_size_percent / 100:
				_parent.scale -= growth_rate * delta
			else:
				_current_state = _State.GROWING
