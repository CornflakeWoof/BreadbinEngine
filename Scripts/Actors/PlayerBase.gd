extends ActorBase
class_name PlayerActor

##PLAYER SPECIFIC VARIABLES


##MOVEMENT

var jump_possible : bool = false

##COMBAT

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	process_priority = (100-Player_Number)
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	setup_initial_values()
	create_timer("StartSprintingTimer",0.5,true,false)
	create_timer("PostSprintJumpWindowTimer",0.5,true,false)
	#print_debug(ActorAnimationPlayer.get_animation_list())

func handle_player_input(timescale:float):
	var PlayerLeft:String = "P"+str(Player_Number)+"_MoveLeft"
	var PlayerRight:String = "P"+str(Player_Number)+"_MoveRight"
	var PlayerUp:String = "P"+str(Player_Number)+"_MoveUp"
	var PlayerDown:String = "P"+str(Player_Number)+"_MoveDown"
	var TreeRootMotion:Transform3D = ActorAnimationTreeNode.get_root_motion_transform()
	
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	current_speed = 0
	
	if (Input.is_action_pressed(PlayerUp) ||  Input.is_action_pressed(PlayerDown) ||  Input.is_action_pressed(PlayerLeft) ||  Input.is_action_pressed(PlayerRight)):
		direction = Vector3(Input.get_action_strength(PlayerLeft) - Input.get_action_strength(PlayerRight),
					0,
					Input.get_action_strength(PlayerUp) - Input.get_action_strength(PlayerDown))
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		if sprinting == true:
			current_speed = sprint_speed
		else:
			current_speed = starting_speed
	
	## SERIOUSLY THANK YOU SO, SO, SO MUCH PEMGUIN005 I LITERALLY COULD NEVER HAVE DONE THIS
	#WITHOUT YOU FULL CREDIT TO HIM FOR PRETTY MUCH ALL OF THIS FUNCTION, I JUST TRANSLATED
	#IT TO GODOT 4


	horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * current_speed * movement_multiplier, acceleration * timescale)
	
	velocity.z = horizontal_velocity.z + vertical_velocity.z + TreeRootMotion.origin.z
	velocity.x = horizontal_velocity.x + vertical_velocity.x + TreeRootMotion.origin.x
	velocity.y = vertical_velocity.y

	move_and_slide()

func handle_player_tree_animation():
	if abs(velocity.x) > 1 || abs(velocity.z) > 1:
		ActorAnimationTreeNode.set("parameters/PlayerState/current", "state 1")
	else:
		ActorAnimationTreeNode.set("parameters/PlayerState/current", "state 0")
	
func handle_player_animation():
	var NewAnimationName:String
	
	#CATCH A BLANK OR UNAVAILABLE NEW ANIMATION AND DEFAULT IT TO
	#THE IDLE ANIMATION NAME (SEE ACTORBASE.GD)
	if NewAnimationName == "" or ActorAnimationPlayerNode.has_animation(str(NewAnimationName)) == false:
		NewAnimationName = IdleAnimationName
	
	if CanChangeAnimation == true:
		CanChangeAnimation = false
	
	match ActorState:
		"rolling":
			if ActorAnimationPlayerNode.has_animation(RollAnimationName):
				NewAnimationName = RollAnimationName
		"attacking":
			if ActorAnimationPlayerNode.has_animation(CurrentAttackAnimation):
				NewAnimationName = CurrentAttackAnimation
		_:
			if abs(velocity.x) > 1 || abs(velocity.z) > 1:
				if sprinting == false:
					NewAnimationName = "HumanoidBase/walk"
				else:
					NewAnimationName = "HumanoidBase/run"
			else:
				NewAnimationName = IdleAnimationName
	match ActorState:
		"rolling":
			if roll_queued == true:
				CanChangeAnimation = true
		_:
			if NewAnimationName != CurrentAnimationName:
				CanChangeAnimation = true
	if CanChangeAnimation == true:
		call_deferred("play_actormesh_animation",NewAnimationName)

func play_actormesh_animation(animationtoplay:String):
	ActorMesh.get_node("AnimationPlayer").play(animationtoplay)
	CurrentAnimationName = animationtoplay

func setup_attack_animation(inputstring:String="R1"):

	var NextAttackAnimation : String = ""
	var AttackArray = construct_attack_array_to_query(inputstring)
	var AttackResult : int
	var Attack_Table = get_node("/root/AttackTable").attacktable
	
	match Two_Handing_State:
		2:
			Current_Weapon = L_Weapon
		1:
			Current_Weapon = R_Weapon
		_:
			Current_Weapon = R_Weapon
			match inputstring:
				"L1","L2":
					Current_Weapon = L_Weapon
	if current_combo > Current_Weapon.get(AttackArray).size()-1:
		current_combo = 0
	AttackResult=Current_Weapon.get(AttackArray)[current_combo]
	
	NextAttackAnimation = get_attack_name_from_attacktable(AttackResult)
	#print_debug(NextAttackAnimation)

	if can_combo == true:
		CurrentAttackAnimation = NextAttackAnimation
		handle_actor_state("attacking")
		can_combo = false
		current_combo += 1
	
func construct_attack_array_to_query(inputstring:String="R1"):
	var AttackArrayNameToReturn : String = ""
	var TwoHandedStatus : String = ""
	var InputStatus : String = ""
	
	TwoHandedStatus = "1H" if Two_Handing_State == 0 else "2H"
	
	if !is_on_floor() and velocity.y < 2:
		InputStatus="FallingAttack"
	elif sprinting == true:
		InputStatus="RunningAttack"
		sprinting = false
	else:
		InputStatus=inputstring
	##NEED TO ADD BACKSTABS ETC LATER
	
	
	AttackArrayNameToReturn = "Weapon_"+str(TwoHandedStatus)+"_"+str(InputStatus)
	#print(AttackArrayNameToReturn)
	
	return AttackArrayNameToReturn
	
func handle_attack_inputs():
	var R1 : String = "P"+str(Player_Number)+"_R1"
	var R2 : String = "P"+str(Player_Number)+"_R2"
	var L1 : String = "P"+str(Player_Number)+"_L1"
	var L2 : String = "P"+str(Player_Number)+"_L2"
	var Roll : String = "P"+str(Player_Number)+"_Roll"
	
	if Input.is_action_just_pressed(Roll):
		if is_on_floor():
			roll_queued = true
			rolling = true
			handle_actor_state("rolling")
	if Input.is_action_just_pressed(R1):
		setup_attack_animation("R1")
	if Input.is_action_just_pressed(R2):
		setup_attack_animation("R2")
	if Input.is_action_just_pressed(L1):
		setup_attack_animation("L1")
	if Input.is_action_just_pressed(L2):
		setup_attack_animation("L2")

func handle_player_rotation(timescale:float):
	if abs(velocity.x) > 1 or abs(velocity.z) > 1:
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
		if jump_possible == true and velocity != Vector3.ZERO and ActorState=="idle":
			try_actor_jump()
			jump_possible = false
		else:
			if ActorState=="idle":
				get_node("StartSprintingTimer").start()
		
	if Input.is_action_just_released("P"+str(Player_Number)+"_Jump"):
		get_node("StartSprintingTimer").stop()
		if sprinting == true:
			jump_possible = true
			get_node("PostSprintJumpWindowTimer").start()
			call_deferred("affect_sprint")
			
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



func _custom_process(_delta):
	call_deferred("handle_player_tree_animation")
	if alive == true:
		handle_running_or_jumping()
		if ActorState != "rolling":
			handle_attack_inputs()

func _custom_physics_process(delta):
	
	handle_player_rotation(delta)
	if Player_Number != 0 and alive==true:
		handle_player_input(delta)
