extends Camera2D
## Controle de câmera por toque e mouse:
## - 1 dedo: arrastar (pan)
## - 2 dedos: pinch para zoom in/out
## - Mouse: botão direito arrasta, scroll faz zoom

@export var min_zoom := 0.4          # limite mínimo (mais próximo)
@export var max_zoom := 3.0          # limite máximo (mais distante)
@export var zoom_sensitivity := 1.0  # sensibilidade do pinch
@export var pan_enabled := true
@export var pinch_enabled := true

var _touches := {}          # { index: { "pos": Vector2, "prev": Vector2 } }
var _last_pinch_dist := -1.0
var _last_pinch_center := Vector2.ZERO

func _unhandled_input(event):
	# Registra início e fim dos toques
	if event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = {"pos": event.position, "prev": event.position}
		else:
			_touches.erase(event.index)
			if _touches.size() < 2:
				_last_pinch_dist = -1.0

	# Atualiza posição de toques em movimento
	elif event is InputEventScreenDrag:
		if _touches.has(event.index):
			_touches[event.index]["prev"] = _touches[event.index]["pos"]
			_touches[event.index]["pos"] = event.position

		var count := _touches.size()

		# Pan (1 dedo)
		if count == 1 and pan_enabled:
			for k in _touches.keys():
				var info = _touches[k]
				var delta = info["pos"] - info["prev"]
				position -= delta * zoom.x

		# Pinch (2 dedos)
		elif count == 2 and pinch_enabled:
			var keys = _touches.keys()
			var p1 = _touches[keys[0]]["pos"]
			var p2 = _touches[keys[1]]["pos"]
			var center = (p1 + p2) * 0.5
			var curr_dist = p1.distance_to(p2)

			if _last_pinch_dist < 0.0:
				_last_pinch_dist = curr_dist
				_last_pinch_center = center
			else:
				if curr_dist != 0.0 and _last_pinch_dist != 0.0:
					var factor = curr_dist / _last_pinch_dist
					var target_zoom = clamp(zoom.x * pow(1.0/factor, zoom_sensitivity), min_zoom, max_zoom)
					_apply_zoom_around_point(target_zoom, center)
				_last_pinch_dist = curr_dist
				_last_pinch_center = center

	# Controles de mouse (para teste em PC)
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and pan_enabled:
		position -= event.relative * zoom.x

	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom_around_point(clamp(zoom.x * 0.9, min_zoom, max_zoom), get_viewport().get_mouse_position())

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom_around_point(clamp(zoom.x * 1.1, min_zoom, max_zoom), get_viewport().get_mouse_position())

			
# Mantém o zoom centrado no ponto de toque (ou mouse)
func _apply_zoom_around_point(new_zoom: float, screen_point: Vector2):
	var from = get_global_mouse_position()
	zoom = Vector2(new_zoom, new_zoom)
	var to = get_global_mouse_position()
	position += from - to
