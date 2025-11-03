extends Node2D
class_name Planet

signal clicked(planet: Planet)

@export var planet_name: String = ""
@export var radius_km: float = 0.0
@export var a_au: float = 0.0
@export var period_days: float = 0.0
@export var color: Color = Color.WHITE
@export var draw_orbit: bool = true

var angle: float = 0.0
var radius_px: float = 5.0
var au_to_px: float = 1000.0
var time_scale: float = 20000.0

@onready var area: Area2D = $Area2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var name_label: Label = $NameLabel

func _ready() -> void:
	# Garante shape explícito
	if shape.shape == null:
		var c: CircleShape2D = CircleShape2D.new()
		c.radius = radius_px
		shape.shape = c
	name_label.text = planet_name
	_redraw_shape()

func set_visual_scale(radius_px_min: float, radius_px_max: float, radius_scale: float, _au_to_px: float) -> void:
	au_to_px = _au_to_px
	radius_px = clamp(radius_km * radius_scale, radius_px_min, radius_px_max)
	if shape.shape != null:
		var c2: CircleShape2D = shape.shape as CircleShape2D
		if c2 != null:
			c2.radius = radius_px
	_redraw_shape()

func _redraw_shape() -> void:
	queue_redraw()

func _draw() -> void:
	# Planeta
	draw_circle(Vector2.ZERO, radius_px, color)
	# Contorno
	draw_arc(Vector2.ZERO, radius_px, 0.0, TAU, 64, Color(0,0,0,0.5), 1.0)
	# Órbita (se habilitada e não for o Sol)
	if draw_orbit and a_au > 0.0:
		var r: float = a_au * au_to_px
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 256, Color(1,1,1,0.2), 1.0)

func update_position(delta: float) -> void:
	# Sol (ou itens sem período) não orbitam
	if period_days <= 0.0 or a_au <= 0.0:
		position = Vector2.ZERO
		return
	# ω = 2π / T; T em segundos (dias*86400) e acelerado por time_scale
	var omega: float = TAU / (period_days * 86400.0 / time_scale)
	angle = fmod(angle + omega * delta, TAU)
	var r: float = a_au * au_to_px
	position = Vector2(cos(angle), sin(angle)) * r

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("clicked", self)
