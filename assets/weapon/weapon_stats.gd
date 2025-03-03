class_name Weapon_Stats
extends Resource

@export_category("Damage")
@export_enum("CLOSE", "RANGE") var damage_type: int = 0
@export var damage_amount: float = 1.0
@export var penetration: int = 0

@export_category("Reload")
@export var ready_time: float = 0.5
@export var reload_time: float = 2.0

@export_category("Ammo")
@export var max_ammo: int = 100
@export var magazine_size: int = 10
