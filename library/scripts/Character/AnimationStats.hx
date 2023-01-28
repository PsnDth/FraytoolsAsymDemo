// Animation stats for CharacterTemplate
// Many values are automatically set by our Common class
// Values assigned in this file will override those values
{
	/// LEFT FACING ANIMS
	//MOTIONS
	stand__left: {},
	stand_turn__left: {},
	walk_in__left: {},
	walk_loop__left: {},
	walk_out__left: {},
	dash__left: {},
	run__left: {},
	run_turn__left: {},
	skid__left: {},
	jump_squat__left: {},
	jump_in__left: {},
	jump_loop__left: {},
	jump_midair__left: {},
	jump_out__left: {},
	fall_loop__left: {},
	fall_special__left: {},
	land_light__left: {},
	land_heavy__left: {},
	crouch_in__left: {},
	crouch_loop__left: {},
	crouch_out__left: {},

	//AIRDASHES
	airdash_up__left: {},
	airdash_down__left: {},
	airdash_forward__left: {},
	airdash_back__left: {},
	airdash_forward_up__left: {},
	airdash_forward_down__left: {},
	airdash_back_up__left: {},
	airdash_back_down__left: {},

	//DEFENSE
	shield_in__left: {},
	shield_loop__left: {},
	shield_hurt__left: {},
	shield_out__left: {}, 
	parry_in__left: {},
	parry_success__left: {},
	parry_fail__left: {},
	roll__left: {},
	spot_dodge__left: {},

	//ASSIST CALL
	assist_call__left: {},
	assist_call_air__left: {},

	//LIGHT ATTACKS
	jab1__left: {},
	jab2__left: {},
	jab3__left: {},
	dash_attack__left: {},
	tilt_forward__left: {},
	tilt_up__left: {},
	tilt_down__left: {},

	//STRONG ATTACKS
	strong_forward_in__left: {},
	strong_forward_charge__left: {},
	strong_forward_attack__left: {},
	strong_up_in__left: {},
	strong_up_charge__left: {},
	strong_up_attack__left: {},
	strong_down_in__left: {},
	strong_down_charge__left: {},
	strong_down_attack__left: {},

	//AERIAL ATTACKS
	aerial_neutral__left: {},
	aerial_forward__left: {},
	aerial_back__left: {},
	aerial_up__left: {},
	aerial_down__left: {},

	//AERIAL ATTACK LANDING
	aerial_neutral_land__left: {},
	aerial_forward_land__left: {},
	aerial_back_land__left: {},
	aerial_up_land__left: {},
	aerial_down_land__left: {},

	//SPECIAL ATTACKS
	special_neutral__left: {},
	special_neutral_air__left: {},
	special_up__left: {},
	special_up_air__left: {},
	special_side__left: {},
	special_side_air__left: {},
	special_down__left: {},
	special_down_loop__left: {},
	special_down_endlag__left: {},
	special_down_air__left: {},
	special_down_air_loop__left: {},
	special_down_air_endlag__left: {},

	//THROWS
	grab__left: {},
	grab_hold__left: {},
	throw_forward__left: {},
	throw_back__left: {},
	throw_up__left: {},
	throw_down__left: {},

	//HURT ANIMATIONS
	hurt_light_low__left: {},
	hurt_light_middle__left: {},
	hurt_light_high__left: {},
	hurt_medium__left: {},
	hurt_heavy__left: {},
	hurt_thrown__left: {},
	tumble__left: {},

	//CRASH
	crash_bounce__left: {},
	crash_loop__left: {},
	crash_get_up__left: {},
	crash_attack__left: {},
	crash_roll__left: {},

	//LEDGE
	ledge_in__left: {},
	ledge_loop__left: {},
	ledge_roll__left: {},
	ledge_climb__left: {},
	ledge_attack__left: {},

	//MISC
	revival__left: {},

	/// RIGHT FACING ANIMS
	//MOTIONS
	stand: {},
	stand_turn: {},
	walk_in: {},
	walk: {},
	walk_out: {},
	dash: {},
	run: {},
	run_turn: {},
	skid: {},
	jump_squat: {},
	jump_in: {},
	jump_midair: {},
	jump_out: {},
	fall_loop: {},
	fall_special: {},
	land_light: {},
	land_heavy: {},
	crouch_in: {},
	crouch_loop: {},
	crouch_out: {},

	//AIRDASHES
	airdash_up: {},
	airdash_down: {},
	airdash_forward: {},
	airdash_back: {},
	airdash_forward_up: {},
	airdash_forward_down: {},
	airdash_back_up: {},
	airdash_back_down: {},

	//DEFENSE
	shield_in: {},
	shield_loop: {},
	shield_hurt: {},
	shield_out: {}, 
	parry_in: {},
	parry_success: {},
	parry_fail: {},
	roll: {},
	spot_dodge: {},

	//ASSIST CALL
	assist_call: {},
	assist_call_air: {},

	//LIGHT ATTACKS
	jab1: {},
	jab2: {},
	jab3: {},
	dash_attack: {xSpeedConservation: 1},
	tilt_forward: {},
	tilt_up: {},
	tilt_down: {},

	//STRONG ATTACKS
	strong_forward_in: {},
	strong_forward_charge: {},
	strong_forward_attack: {},
	strong_up_in: {},
	strong_up_charge: {},
	strong_up_attack: {},
	strong_down_in: {},
	strong_down_charge: {},
	strong_down_attack: {},

	//AERIAL ATTACKS
	aerial_neutral: {landAnimation:"aerial_neutral_land"},
	aerial_forward: {landAnimation:"aerial_forward_land"},
	aerial_back: {landAnimation:"aerial_back_land"},
	aerial_up: {landAnimation:"aerial_up_land"},
	aerial_down: {landAnimation:"aerial_down_land", xSpeedConservation: 0.5, ySpeedConservation: 0.5, gravityMultiplier:0, allowMovement: false},

	//AERIAL ATTACK LANDING
	aerial_neutral_land: {},
	aerial_forward_land: {},
	aerial_back_land: {},
	aerial_up_land: {},
	aerial_down_land: {xSpeedConservation: 0},

	//SPECIAL ATTACKS
	special_neutral: {},
	special_neutral_air: {},
	special_up: {leaveGroundCancel:false, xSpeedConservation:0.5, ySpeedConservation:0.5, allowMovement: true, groundSpeedCap: 5.5, aerialSpeedCap: 3.25, nextState:CState.FALL_SPECIAL}, 
	special_up_air: {leaveGroundCancel:false, xSpeedConservation:0.5, ySpeedConservation:0.5, groundSpeedCap: 5.5, aerialSpeedCap: 3.25, nextState:CState.FALL_SPECIAL, landType:LandType.TOUCH}, 
	special_side: {allowFastFall: false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, landType:LandType.TOUCH, landAnimation: "land_heavy", singleUse:true},
	special_side_air: {allowFastFall: false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, landType:LandType.TOUCH, landAnimation: "land_heavy", singleUse:true}, 
	special_down: {allowFastFall:false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, xSpeedConservation:0, ySpeedConservation:0, gravityMultiplier:0.75}, 
	special_down_loop: {endType:AnimationEndType.LOOP, allowJump:true},
	special_down_endlag: {allowJump:true},
	special_down_air: {allowFastFall:false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, xSpeedConservation:0, ySpeedConservation:0, gravityMultiplier:0.75, landType:LandType.LINK_FRAMES, landAnimation:"special_down"},
	special_down_air_loop: {endType:AnimationEndType.LOOP, allowJump:true, landType:LandType.LINK_FRAMES, landAnimation:"special_down_loop"},
	special_down_air_endlag: {allowJump:true, landType:LandType.LINK_FRAMES, landAnimation:"special_down"},

	//THROWS
	grab: {},
	grab_hold: {},
	throw_forward: {},
	throw_back: {},
	throw_up: {},
	throw_down: {},

	//HURT ANIMATIONS
	hurt_light_low: {},
	hurt_light_middle: {},
	hurt_light_high: {},
	hurt_medium: {},
	hurt_heavy: {},
	hurt_thrown: {},
	tumble: {},

	//CRASH
	crash_bounce: {},
	crash_loop: {},
	crash_get_up: {},
	crash_attack: {},
	crash_roll: {},

	//LEDGE
	ledge_in: {},
	ledge_loop: {},
	ledge_roll: {},
	ledge_climb: {},
	ledge_attack: {},

	//MISC
	revival: {},
	emote: {}
}
