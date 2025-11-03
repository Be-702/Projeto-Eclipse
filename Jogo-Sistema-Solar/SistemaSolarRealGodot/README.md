
# Sistema Solar — Escala Real (Godot 4)

Renderiza o Sistema Solar com **tamanhos e distâncias proporcionais reais** (com limites visuais) e **órbitas** aceleradas via `TIME_SCALE`.

## Como abrir
1. Godot 4.x → **Import** → selecione `project.godot`.
2. Execute `Main.tscn` (já é a principal).

## Controles
- **Pan**: botão direito + arrastar
- **Zoom**: scroll

## Ajustes (scripts/Main.gd)
- `AU_TO_PX` — pixels por AU (distância).
- `RADIUS_SCALE` — pixels por km (tamanho).
- `RADIUS_MIN/MAX` — limites de tamanho.
- `TIME_SCALE` — acelera as órbitas (dias reais → segundos).

## Dados (data/planets.json)
- `radius_km` — raio em km
- `a_au` — semi-eixo maior em AU (aprox.)
- `period_days` — período orbital em dias
