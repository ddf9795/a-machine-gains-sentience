extends ViewportContainer

#const SEED = "the_artificial_mind"
var offset_x = 1
var offset_y = 1
var character = "."
var table = []
var framecount = 0
var erratic_x = 10
var erratic_y = 10
var erratic_table_x = []
var erratic_table_y = []

var r = 1
var g = 1
var b = 1

onready var font = preload("Font.tres")

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		if event.scancode == KEY_R:
			get_tree().change_scene("res://blank.tscn")

func _ready():
#	seed(hash(SEED))
	for i in range(get_viewport().size.y / 16):
		table.append([])
		for j in range(get_viewport().size.x / 16):
			table[i].append(sin(deg2rad(j * cos(deg2rad(i * 5)))))
		
	for i in range(table[0].size()):
		erratic_table_x.append(0)
	for i in range(table.size()):
		erratic_table_y.append(0)

func _process(delta):
	framecount += 1
	
	if framecount >= 3900:
#	if framecount >= 600:
		get_tree().change_scene("res://blank.tscn")
	
	var noise = material.get_shader_param("NoiseMap")
	noise.noise_offset.x += 0.5
	noise.noise_offset.y += 1
	material.set_shader_param("NoiseMap", noise)
	material.set_shader_param("ColorIn1", Color(r,g,b))
	material.set_shader_param("ColorIn2", Color(b,g,r))
	
	var noise2 = $"%Label".material.get_shader_param("NoiseMap")
	noise2.noise_offset.x += 0.5
	noise2.noise_offset.y += 1
	$"%Label".material.set_shader_param("NoiseMap", noise2)
	$"%Label".material.set_shader_param("ColorIn1", Color(r,g,b))
	$"%Label".material.set_shader_param("ColorIn2", Color(b,g,r))
	if framecount % 300 == 0:
		var coin = randi() % 2
		match coin:
			0:
				erratic_x += 1
			1:
				erratic_y += 1
		
	if framecount % 75 == 0:
		var d3 = randi() % 3
		match d3:
			0:
				offset_x -= erratic_x
				r = min(r + 0.1, 1.0)
				g = max(g - 0.1, 0.0)
				b = max(b - 0.1, 0.0)
			1:
				r = max(r - 0.1, 0.0)
				g = min(g + 0.1, 1.0)
				b = max(b - 0.1, 0.0)
			2:
				offset_x += erratic_x
				r = max(r - 0.1, 0.0)
				g = max(g - 0.1, 0.0)
				b = min(b + 0.1, 1.0)
		if offset_x == 0:
			offset_x = 1
		for x in erratic_table_x.size():
			if randi() % int(abs(offset_x)) <= int(floor(abs(offset_x) / 2.0)):
				if randi() % 2 == 0: 
					erratic_table_x[x] += offset_x
	if framecount % 150 == 0:
		var d3 = randi() % 3
		match d3:
			0:
				offset_y -= erratic_y
			1:
				pass
			2:
				offset_y += erratic_y
		if offset_y == 0:
			offset_y = 1
		for y in erratic_table_y.size():
			if randi() % int(abs(offset_y)) <= int(floor(abs(offset_y) / 2.0)):
				if randi() % 2 == 0: 
					erratic_table_y[y] += offset_y
	update()

func _draw():
	if framecount >= 3600:
#	if framecount >= 300:
		$"%Label".show()
		draw_string(font, Vector2(960, 540), "may i please think?")
	if framecount < 3600:
#	if framecount < 300:
		$"%Label".hide()
		for i in range(table.size()):
			var jitter_y = rand_range(0, erratic_table_y[i])
			for j in range(table[i].size()):
				var jitter_x = rand_range(0, erratic_table_x[j])
				draw_char(font, Vector2(j * 16 + jitter_x, i * 16 + jitter_y), pseudorandom_character(j * 16 + offset_x * 16, i * 16 + offset_y * 16, int(get_viewport().size.x), int(get_viewport().size.y)), '', Color(r, g, b, table[get_table_pos(table.size(), i + erratic_table_y[i])][get_table_pos(table[i].size(), j + erratic_table_x[j])] * 30 / ((framecount % 75) + 1)))

func get_table_pos(table_size, value):
	return abs(value) % table_size

func pseudorandom_character(x, y, width, height):
	match int(floor(abs(x) % width)) < width / 2:
		true:
			match int(floor(abs(y) % height)) < height / 2:
				true:
					return '.'
				false:
					return '!'
		false:
			match int(floor(abs(y))) < height / 2:
				true:
					return 'o'
				false:
					return 'x'
