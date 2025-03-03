extends AnimationPlayer

const DAY_START_POSITION = 1200
const DAY_MIDDLE_POSITION = 0
const DAY_END_POSITION = 240

const EVENING_START_POSITION = 240
const EVENING_MIDDLE_POSITION = 420
const EVENING_END_POSITION = 600

const NIGHT_START_POSITION = 600
const NIGHT_MIDDLE_POSITION = 720
const NIGHT_END_POSITION = 840

const MORNING_START_POSITION = 840
const MORNING_MIDDLE_POSITION = 1020
const MORNING_END_POSITION = 1200

enum CYCLE {DAY, EVENING, NIGHT, MORNING}
enum PERIOD {START, MIDDLE, END}

@export var time_of_the_cycle: CYCLE = CYCLE.DAY 
@export var period_of_time: PERIOD = PERIOD.START 
@export var PLAYER: Player

func _ready() -> void:
	match time_of_the_cycle:
		CYCLE.DAY:
			play("day_night_cycle")
			
			match period_of_time:
				PERIOD.START:
					advance(DAY_START_POSITION)
				PERIOD.MIDDLE:
					advance(DAY_MIDDLE_POSITION)
				PERIOD.END:
					advance(DAY_END_POSITION)
			
		CYCLE.EVENING:
			play("day_night_cycle")
			
			match period_of_time:
				PERIOD.START:
					advance(EVENING_START_POSITION)
				PERIOD.MIDDLE:
					advance(EVENING_MIDDLE_POSITION)
				PERIOD.END:
					advance(EVENING_END_POSITION)
			
		CYCLE.NIGHT:
			play("day_night_cycle")
			
			match period_of_time:
				PERIOD.START:
					advance(NIGHT_START_POSITION)
				PERIOD.MIDDLE:
					advance(NIGHT_MIDDLE_POSITION)
				PERIOD.END:
					advance(NIGHT_END_POSITION)
			
		CYCLE.MORNING:
			play("day_night_cycle")
			
			match period_of_time:
				PERIOD.START:
					advance(MORNING_START_POSITION)
				PERIOD.MIDDLE:
					advance(MORNING_MIDDLE_POSITION)
				PERIOD.END:
					advance(MORNING_END_POSITION)

func _process(_delta: float) -> void:
	speed_scale = remap(PLAYER.current_speed, 0, 10, 0, 10)
