extends Node2D

@onready var cam: Camera2D = $Camera2D
@onready var info: Label = $CanvasLayer/Info

const PLANET_SCENE: PackedScene = preload("res://scenes/Planet.tscn")
const DATA_FILE: String = "res://data/planets.json"

const AU_TO_PX: float = 3000.0
const RADIUS_SCALE: float = 0.0005
const RADIUS_MIN: float = 3.0
const RADIUS_MAX: float = 120.0
const TIME_SCALE: float = 30000.0

var bodies: Array[Planet] = []

func _ready() -> void:
	cam.position = Vector2.ZERO
	cam.zoom = Vector2.ONE
	_load_solar_system()
	info.text = "Escalas — Distância: %.0f px/AU | Tamanho: %.3f px/km | Tempo: x%.0f Pan: botão direito + arrastar | Zoom: scroll" % [AU_TO_PX, RADIUS_SCALE, TIME_SCALE]

func _process(delta: float) -> void:
	for p in bodies:
		p.update_position(delta)

func _load_solar_system() -> void:
	var f: FileAccess = FileAccess.open(DATA_FILE, FileAccess.READ)
	var txt: String = f.get_as_text()
	var arr: Array = JSON.parse_string(txt) as Array
	for d_ in arr:
		var d: Dictionary = d_ as Dictionary
		var p_inst: Node = PLANET_SCENE.instantiate()
		var p: Planet = p_inst as Planet
		add_child(p)
		p.planet_name = d.get("name", "")
		p.radius_km = float(d.get("radius_km", 0.0))
		p.a_au = float(d.get("a_au", 0.0))
		p.period_days = float(d.get("period_days", 0.0))
		var col_str: String = str(d.get("color", "#FFFFFF"))
		p.color = Color(col_str)
		p.time_scale = TIME_SCALE
		p.set_visual_scale(RADIUS_MIN, RADIUS_MAX, RADIUS_SCALE, AU_TO_PX)
		if p.a_au <= 0.0:
			p.position = Vector2.ZERO
		else:
			p.position = Vector2(p.a_au * AU_TO_PX, 0.0)
		bodies.append(p)
