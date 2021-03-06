extends ReferenceRect

class_name Enemy

signal enemy_dealt_player_damage
signal enemy_action_complete
signal enemy_convinced
signal enemy_became_hostile
signal enemy_died

var is_hostile: bool = false

var max_trust: int
var trust: int

var max_suspicion: int
var suspicion: int

var max_health: int
var health: int

func _init(
	starting_max_trust: int,
	starting_max_suspicion: int,
	starting_max_health: int
):
	max_trust = starting_max_trust
	trust = 0
	max_suspicion = starting_max_suspicion
	suspicion = 0
	max_health = starting_max_health
	health = max_health
	update_labels()

func get_action() -> EnemyAction:
	return EnemyAction.new()

func take_action() -> void:
	if trust == max_trust or health == 0:
		return
	var action = get_action()
	if action.deal_damage:
		emit_signal("enemy_dealt_player_damage", action.deal_damage)
	if action.gain_suspicion:
		gain_suspicion(action.gain_suspicion)
	emit_signal("enemy_action_complete")

func gain_trust(trust_amount: int) -> void:
	if is_hostile:
		push_warning("Can't gain trust when enemy is hostile")
		return
	if trust_amount > max_trust - trust:
		trust = max_trust
	else:
		trust += trust_amount
	update_trust_label()
	if trust == max_trust:
		become_convinced()

func gain_suspicion(suspicion_amount: int) -> void:
	if is_hostile:
		push_warning("Can't gain suspicion when enemy is hostile")
		return
	if suspicion_amount > max_suspicion - suspicion:
		suspicion = max_suspicion
	else:
		suspicion += suspicion_amount
	update_suspicion_label()
	if suspicion == max_suspicion:
		become_hostile()

func take_damage(damage_amount: int) -> void:
	if !is_hostile:
		push_warning("Can't take damage when enemy is not hostile")
		return
	if damage_amount > health:
		health = 0
	else:
		health -= damage_amount
	update_health_label()
	if health == 0:
		die()

func update_labels() -> void:
	if !is_hostile:
		update_trust_label()
		update_suspicion_label()
		clear_health_label()
	else:
		clear_trust_label()
		clear_suspicion_label()
		update_health_label()

func update_trust_label() -> void:
	$TrustLabel.text = "Trust: %d/%d" % [trust, max_trust]
	
func clear_trust_label() -> void:
	$TrustLabel.text = ""

func update_suspicion_label() -> void:
	$SuspicionLabel.text = "Suspicion: %d/%d" % [suspicion, max_suspicion]
	
func clear_suspicion_label() -> void:
	$SuspicionLabel.text = ""

func update_health_label() -> void:
	$HealthLabel.text = "Health: %d/%d" % [health, max_health]
	
func clear_health_label() -> void:
	$HealthLabel.text = ""

func become_convinced() -> void:
	emit_signal("enemy_convinced")

func become_hostile() -> void:
	is_hostile = true
	update_labels()
	emit_signal("enemy_became_hostile", trust)

func die() -> void:
	emit_signal("enemy_died")
