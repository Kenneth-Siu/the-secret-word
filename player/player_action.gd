extends Reference

class_name PlayerAction

var non_hostile: NonHostileAction = NonHostileAction.new()
var hostile: HostileAction = HostileAction.new()

class NonHostileAction:
	var gain_trust: int = 0

class HostileAction:
	var deal_damage: int = 0
