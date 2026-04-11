## Cat Companion — thin coordinator that wires modular cat systems together
## Children: CatBrain, CatMovement, CatAnimation, CatProcedural, CatMemory
## Behaviours:
##   - Wanders rooms idly, sits on surfaces, naps
##   - Leads player to urgent/overdue tasks (walks, pauses, looks back)
##   - Hisses at monster tasks (arched back, raised fur)
##   - Purrs when player completes a task (confirmation sound)
##   - Meows to get attention for important items
##   - Perches on furniture, follows territory paths
##   - Has Tamagotchi-like emotional state based on player engagement
extends CharacterBody3D

signal cat_meowed(reason: String)
signal cat_hissed(at_task_id: String)
signal cat_purred()

# Node references
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var cat_mesh: Node3D = $CatMesh
@onready var brain: Node = $CatBrain
@onready var movement: Node = $CatMovement
@onready var anim: Node = $CatAnimation
@onready var procedural: Node = $CatProcedural
@onready var memory: Node = $CatMemory
@onready var skin: Node = $CatSkin


func _ready() -> void:
	add_to_group("cat")

	# Wire up module cross-references
	if movement and movement.has_method("setup"):
		movement.setup(self, nav_agent)

	if procedural and procedural.has_method("setup"):
		procedural.setup(cat_mesh)

	if anim and anim.has_method("setup"):
		anim.setup(brain, procedural)

	if skin and skin.has_method("setup"):
		skin.setup(cat_mesh)

	if brain:
		brain.movement = movement
		brain.memory = memory

	# Visibility tied to enabled state
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if not GameState.cat_enabled:
		visible = false
		return
	visible = true


func set_player(player: CharacterBody3D) -> void:
	if brain and brain.has_method("set_player"):
		brain.set_player(player)
	if procedural and procedural.has_method("set_player"):
		procedural.set_player(player)
