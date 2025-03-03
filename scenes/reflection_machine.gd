class_name ReflectionMachine
extends Node

var probes: Array = []

func _ready() -> void:
	for probe in get_tree().get_nodes_in_group(Glob.REFLECTION_GROUP):
		if probe is TurnableProbe:
			probes.append(probe)
	
	for checkpoint in get_tree().get_nodes_in_group(Glob.CHECKPOINT_GROUP):
		if checkpoint is Checkpoint:
			checkpoint.checkpointed.connect(update_probes)

func update_probes(active_probes: Array[TurnableProbe] = [], lp_active_probes: Array[TurnableProbe] = []) -> void:
	for probe in probes:
		if active_probes.find(probe) > -1:
			probe.enable()
		else:
			probe.disable()
