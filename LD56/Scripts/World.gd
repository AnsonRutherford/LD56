class_name World
extends Node3D

const creature_colors = [Color.RED, Color.BLUE, Color.YELLOW, Color.CYAN, Color.MAGENTA, Color.GREEN]
const creature_sizes = [0.4] #0.2, 0.2, 0.3, 0.3, 0.3, 0.4, 0.4, 0.5]

static var instance
static var collection = []

var food_timer = 2

var collection_timer = 0

func _ready():
	instance = self
	initial_spawn.call_deferred()
	
func _process(delta):
	if collection_timer > 0:
		collection_timer -= delta
		if collection_timer <= 0:
			collection_timer = 0
			var matches = 0
			if len(collection) > 1:
				for i in len(collection):
					var found_match = false
					for j in range(i+1, len(collection)):
						if collection[i].food_type1 == collection[j].food_type1 and collection[i].food_type2 == collection[j].food_type2:
							found_match = true
					if found_match:
						matches += 1
			if matches == 1:
				Message.spawn_message(self, "Pair Match", 1.5, 0.5)
				for i in 2:
					spawn_creature()
			elif matches == 2:
				Message.spawn_message(self, "Trio Match!", 1.5, 0.5)
				for i in 4:
					spawn_creature()
			elif matches == 3:
				Message.spawn_message(self, "Quadruple Match! Wow!", 1.5, 0.5)
				for i in 8:
					spawn_creature()
			elif matches >= 4:
				Message.spawn_message(self, "HUGE MATCH, YOU WIN!!!", 1.5, 0.5)
				for i in pow(2, matches):
					spawn_creature()
			for creature in collection:
				creature.queue_free()
			collection = []
			
	food_timer -= delta
	if food_timer < 0:
		Food.spawn_food(get_tree().root, randi_range(0,5), randi_range(0,5), Color.ORANGE, Vector3(randf_range(-5, 5), 50 + randf() * 20, randf_range(-5, 5)), Vector3.ZERO)
		food_timer = 0.2
		
	
func initial_spawn():
	await get_tree().physics_frame
	for i in 10:
		spawn_creature()
	
func spawn_creature():
	# Too many parameters, using a dict so I can easily remember which is which (ugly)
	var type1 = randi_range(0, len(creature_colors) - 1)
	var type2 = randi_range(0, len(creature_colors) - 1)
	
	var params = {
		"size" = creature_sizes[randi_range(0, len(creature_sizes) - 1)],
		"face_color" = creature_colors[type1],
		"hat_color" = creature_colors[type2],
		"food_type1" = type1,
		"food_type2" = type2,
		"leg_height" = randf() * 0.5,
		"leg_splay" = randf() * 0.5 + 1,
		"leg_scale" = 0.5
	}
	Creature.spawn_creature(self, params, Vector3(randf_range(-5, 5), 50 + randf() * 20, randf_range(-5, 5)))
	Creature.spawn_creature(self, params, Vector3(randf_range(-5, 5), 50 + randf() * 20, randf_range(-5, 5)))
	
static func lever_pulled():
	instance.collection_timer = 3
	
static func collect(creature):
	if instance.collection_timer > 0 and abs(creature.global_position.x + 8) < 2 and abs(creature.global_position.z + 8) < 2 :
		collection.append(creature)
		return true
