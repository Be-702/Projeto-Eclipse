extends Node2D

@export var orbit_radius: float = 200.0
@export var orbit_speed: float = 1.0
@export var start_angle_deg: float = 0.0
@export var color: Color = Color.BLUE

var angle: float = 0.0

func _ready():
	angle = deg_to_rad(start_angle_deg)

func _process(delta):
	angle += orbit_speed * delta
	position = Vector2(cos(angle), sin(angle)) * orbit_radius
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, 15, color)
