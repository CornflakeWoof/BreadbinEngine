extends ActorBase
class_name PlayerActor

##PLAYER SPECIFIC VARIABLES


##MOVEMENT

var sprinting : bool = false
var jump_possible : bool = false

##COMBAT

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	setup_initial_values()
	create_timer("StartSprintingTimer",0.5,true,false)
	create_timer("PostSprintJumpWindowTimer",0.5,true,false)
	#print_debug(ActorAnimationPlayer.get_animation_list())

func handle_player_input():
	var PlayerLeft:String = "P"+str(Player_Number)+"_MoveLeft"
	var PlayerRight:String = "P"+str(Player_Number)+"_MoveRight"
	var PlayerUp:String = "P"+str(Player_Number)+"_MoveUp"
	var PlayerDown:String = "P"+str(Player_Number)+"_MoveDown"
	
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	
	var input_dir = Input.get_vector(PlayerLeft, PlayerRight, PlayerUp, PlayerDown)
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, h_rot).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	
func handle_player_animation():
	var NewAnimationName:String
	
	#CATCH A BLANK OR UNAVAILABLE NEW ANIMATION AND DEFAULT IT TO
	#THE IDLE ANIMATION NAME (SEE ACTORBASE.GD)
	if NewAnimationName == "" or ActorAnimationPlayerNode.has_animation(str(NewAnimationName)) == false:
		NewAnimationName = IdleAnimationName
	
	if attacking:
		if ActorAnimationPlayerNode.has_animation(CurrentAttackAnimation):
			NewAnimationName = CurrentAttackAnimation
		else:
			NewAnimationName = IdleAnimationName
			attacking = false
	else:
		if abs(velocity.x) || abs(velocity.z) > 0.1:
			NewAnimationName = "HumanoidBase/walk"
		else:
			NewAnimationName = IdleAnimationName
		
	if NewAnimationName != CurrentAnimationName:
		ActorAnimationPlayerNode.play(NewAnimationName)
		CurrentAnimationName = NewAnimationName

func setup_attack_animation(input:String="R1",LeftWeapon:bool=false):

	var NextAttackAnimation : String = ""
	var inputstring : String = input
	var twohandstring: String = "1H"
	var WeaponToQuery = ActorMesh.Current_Weapon_R
	var FinalAnimationString : String = ""
	var SpecialAttackQueued : bool = false
	
	#IF WE TRY AND ATTACK WHILE WE CAN'T COMBO, QUEUE AN ATTACK TO DO WHEN WE CAN
	if can_combo==false:
		attack_queued = true
	
	print(current_combo)
	
	#TO GET OUR NEXT ATTACK ANIMATION, WE CONSTRUCT A STRING THAT'LL BE THE
	#VARIABLE NAME WE ASK OUR CURRENT WEAPON FOR THE VALUE OF AND PASS THE
	#ANIMATION NAME IT HOPEFULLY RETURNS TO OUR ANIMATION PLAYER TO PLAY IT
	
	#FIRST WE ASK WHICH WEAPON WE'RE QUERYING
	if LeftWeapon == true:
		WeaponToQuery = ActorMesh.Current_Weapon_L
	
	#THEN CONSTRUCT WHETHER WE'RE ASKING FOR A 2H OR 1H ATTACK
	if Two_Handing_State != 0:
		twohandstring = "2H"
	
	#NOW WE DETERMINE IF THERE ARE ANY SPECIAL CIRCUMSTANCES PRESENT -
	#IF WE'RE FALLING QUICKLY ENOUGH WE OVERRIDE EVERYTHING ELSE TO
	#ASK THE WEAPON FOR ITS FALLING ATTACK, IF WE'RE SPRINTING WE ASK
	#FOR ITS RUNNING ATTACK ETC. AND WE ANNOUNCE WE'RE NOT ASKING FOR AN R1/L1 ATTACK NAME
	#ARRAY BUT A R1/L1 SPECIAL ATTACK STRING
	if abs(velocity.y) > 2:
		FinalAnimationString = "Weapon_"+twohandstring+"_FallingAttack"
		SpecialAttackQueued = true
	elif sprinting == true:
		FinalAnimationString = "Weapon_"+twohandstring+"_RunningAttack"
		SpecialAttackQueued = true
	else:
		FinalAnimationString = "Weapon_"+twohandstring+"_"+inputstring
	
	#IF WE DON'T HAVE A SPECIAL ATTACK QUEUED, ASK OUR QUERIED WEAPON FOR THE
	#NAME OF THE ANIMATION AT WHATEVER THE CURRENT COMBO VALUE'S PLACE IS IN
	#THE ARRAY. 
	if SpecialAttackQueued == false:
		var CurrentQueryArraySize = get_node(WeaponToQuery.get_path()).get(FinalAnimationString).size()
		#print_debug("Size of "+str(FinalAnimationString)+": "+str(CurrentQueryArraySize))
		pass
		if current_combo > CurrentQueryArraySize-1:
			#print_debug(str(FinalAnimationString)+str(current_combo)+" not found, defaulting to 0")		
			current_combo = 0
		NextAttackAnimation = str(WeaponToQuery.get(FinalAnimationString)[current_combo])
	else:
		if ActorAnimationPlayerNode.has_animation(WeaponToQuery.get(FinalAnimationString)):
			NextAttackAnimation = str(WeaponToQuery.get(FinalAnimationString))
		else:
			NextAttackAnimation = IdleAnimationName
		current_combo = 0
	

	current_combo += 1
	if attack_queued == true:
		QueuedAttackAnimation = NextAttackAnimation
	else:
		CurrentAttackAnimation = NextAttackAnimation
			
		can_combo = false
			
	print_debug(CurrentAttackAnimation)
		
	attacking = true
	
func handle_attack_inputs():
	var R1 : String = "P"+str(Player_Number)+"_R1"
	var R2 : String = "P"+str(Player_Number)+"_R2"
	var L1 : String = "P"+str(Player_Number)+"_L1"
	var L2 : String = "P"+str(Player_Number)+"_L2"
	
	if Input.is_action_just_pressed(R1):
		setup_attack_animation("R1",false)
	elif Input.is_action_just_pressed(R2):
		setup_attack_animation("R2",false)
	elif Input.is_action_just_pressed(L1):
		setup_attack_animation("L1",false)
	elif Input.is_action_just_pressed(L2):
		setup_attack_animation("L2",false)

func handle_player_rotation(timescale:float):
	if abs(velocity.x) > 2 or abs(velocity.z) > 2:
		ActorMesh.rotation.y = lerp_angle(ActorMesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, timescale * (rotation_speed*rotation_multiplier))

func affect_sprint(startsprinting:bool=false):
	if startsprinting == true:
		current_speed = int(starting_speed*2)
		sprinting = true
		#print_debug("Player sprinting!")
	else:
		current_speed = starting_speed
		#print_debug("Player no longer sprinting!")
		sprinting = false

func handle_running_or_jumping():
	# Handle Jump.
	if Input.is_action_just_pressed("P"+str(Player_Number)+"_Jump"):
		if jump_possible == true and velocity != Vector3.ZERO and attacking == false:
			try_actor_jump()
			jump_possible = false
		else:
			if attacking == false:
				get_node("StartSprintingTimer").start()
		
	if Input.is_action_just_released("P"+str(Player_Number)+"_Jump"):
		get_node("StartSprintingTimer").stop()
		if sprinting == true:
			jump_possible = true
			get_node("PostSprintJumpWindowTimer").start()
			call_deferred("affect_sprint")

func set_position_rm():
	pass
			
## COMBAT FUNCTIONS

func change_player_weapon(weapon_name:String="DefaultWeapon",UpgradeLevel:int=0,LeftHand:bool=false):
	var newweapon:PackedScene = load("res://Scenes/Weapons/"+str(weapon_name)+".tscn")
	var newweaponinst = newweapon.instance()
	newweaponinst.IsLeftHandWeapon = LeftHand
	
	if LeftHand == true:
		ActorMesh.LHandWeapon_Bone.add_child(newweaponinst)
	else:
		ActorMesh.RHandWeapon_Bone.add_child(newweaponinst)
	

##TIMER STUFF

func _StartSprintingTimer_timeout():
	affect_sprint(true)

func _PostSprintJumpWindowTimer_timeout():
	jump_possible = false



func _process(_delta):
	handle_player_animation()
	handle_running_or_jumping()
	handle_attack_inputs()

func _physics_process(delta):
	
	set_position_rm()
	handle_actor_gravity(delta)
	handle_player_rotation(delta)
	if Player_Number != 0:
		handle_player_input()
