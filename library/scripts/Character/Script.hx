// API Script


var neutralSpecialProjectile = self.makeObject(null); // Tracks active Neutral Special projectile (in case we need to handle any special cases)

var lastDisabledNSpecStatusEffect = self.makeObject(null);

var downSpecialLoopCheckTimer = self.makeInt(-1);

//offset projectile start position
var NSPEC_PROJ_X_OFFSET = 40;
var NSPEC_PROJ_Y_OFFSET = -50;

var NEUTRAL_SPECIAL_COOLDOWN = 60;
var LEFT_ANIM_SUFFIX = "__left";

// start helper functions ---
function isLeftAnim(anim: String) {
    // Try to find LEFT_ANIM_SUFFIX in animation name
    return anim.indexOf(LEFT_ANIM_SUFFIX, anim.length - LEFT_ANIM_SUFFIX.length) != -1;
}

function getOppositeAnim(anim: String) {
    if (isLeftAnim(anim)) {
        return anim.substr(0, anim.length - LEFT_ANIM_SUFFIX.length);
    } else {
        return anim + LEFT_ANIM_SUFFIX;
    }
}

// start general functions --- 

//Runs on object init
function initialize(){
    self.addEventListener(GameObjectEvent.LINK_FRAMES, handleLinkFrames, {persistent:true});
}

function update(){
    // This is a fallback if the first frame of the previous anim didn't handle the flipping
    // Examples of where this is needed:
    // - intro (probably a bug in API/engine)
    // - allowTurnOnFirstFrame and player actually reverses the direction
    var anim = self.getAnimation();
    var frame_num = self.getCurrentFrame();
    if (isLeftAnim(anim) != self.isFacingLeft()) {
        if (self.hasAnimation(getOppositeAnim(anim))) {
            changeAnimation(getOppositeAnim(anim));
            self.playFrame(frame_num);
        }
    }
}

// CState-based handling for LINK_FRAMES
// needed to ensure important code that would be skipped during the transition is still executed
function handleLinkFrames(e){
	if(self.inState(CState.SPECIAL_SIDE)){
		if(self.getCurrentFrame() >= 14){
			self.updateAnimationStats({bodyStatus:BodyStatus.NONE});
		}
	} else if(self.inState(CState.SPECIAL_DOWN)){
        specialDown_resetTimer();
        downSpecialLoopCheckTimer.set(self.addTimer(1, -1, specialDown_checkLoop));    
    }
}

function onTeardown() {
	
}

// --- end general functions

function changeAnimation(animation: String) {
    // NOTE: Copies all animation stats, this is technically dumb for `name` & `attackId` 
    //       but doesn't do any harm it seems
    var animStats = {
        // AnimationStats
        aerialSpeedAcceleration: self.getAnimationStat("aerialSpeedAcceleration"),
        aerialSpeedCap: self.getAnimationStat("aerialSpeedCap"),
        attackId: self.getAnimationStat("attackId"),
        autoRotate: self.getAnimationStat("autoRotate"),
        bodyStatus: self.getAnimationStat("bodyStatus"),
        bodyStatusStrength: self.getAnimationStat("bodyStatusStrength"),
        chargeFramesMax: self.getAnimationStat("chargeFramesMax"),
        chargeFramesTotal: self.getAnimationStat("chargeFramesTotal"),
        endType: self.getAnimationStat("endType"),
        grabLimit: self.getAnimationStat("grabLimit"),
        gravityMultiplier: self.getAnimationStat("gravityMultiplier"),
        groundSpeedAcceleration: self.getAnimationStat("groundSpeedAcceleration"),
        groundSpeedCap: self.getAnimationStat("groundSpeedCap"),
        immovable: self.getAnimationStat("immovable"),
        interruptible: self.getAnimationStat("interruptible"),
        landAnimation: self.getAnimationStat("landAnimation"),
        landType: self.getAnimationStat("landType"),
        leaveGroundCancel: self.getAnimationStat("leaveGroundCancel"),
        metadata: self.getAnimationStat("metadata"),
        name: self.getAnimationStat("name"),
        nextAnimation: self.getAnimationStat("nextAnimation"),
        nextState: self.getAnimationStat("nextState"),
        pause: self.getAnimationStat("pause"),
        resetId: self.getAnimationStat("resetId"),
        resetRotation: self.getAnimationStat("resetRotation"),
        rotationSpeed: self.getAnimationStat("rotationSpeed"),
        shadows: self.getAnimationStat("shadows"),
        slideOff: self.getAnimationStat("slideOff"),
        solid: self.getAnimationStat("solid"),
        storedChargePercent: self.getAnimationStat("storedChargePercent"),
        xSpeedConservation: self.getAnimationStat("xSpeedConservation"),
        ySpeedConservation: self.getAnimationStat("ySpeedConservation"),
        // CharacterAnimationStats
        allowFastFall: self.getAnimationStat("allowFastFall"),
        allowJump: self.getAnimationStat("allowJump"),
        allowMovement: self.getAnimationStat("allowMovement"),
        allowTurn: self.getAnimationStat("allowTurn"),
        allowTurnOnFirstFrame: self.getAnimationStat("allowTurnOnFirstFrame"),
        autocancel: self.getAnimationStat("autocancel"),
        doubleJumpCancel: self.getAnimationStat("doubleJumpCancel"),
        grabLedgeBehind: self.getAnimationStat("grabLedgeBehind"),
        grabLedgeRising: self.getAnimationStat("grabLedgeRising"),
        singleUse: self.getAnimationStat("singleUse")
    };
    self.playAnimation(animation);
    self.updateAnimationStats(animStats);
}

function changeToLeftAnimation() {
    changeAnimation(self.getAnimation() + LEFT_ANIM_SUFFIX);
}


//Rapid Jab logic
function jab3Loop(){
    if (self.getHeldControls().ATTACK) {
    	self.playFrame(2);
	}
}
//-----------NEUTRAL SPECIAL-----------

//projectile
function fireNSpecialProjectile(){
    neutralSpecialProjectile.set(match.createProjectile(self.getResource().getContent("asym_demoNspecProjectile"), self));
    neutralSpecialProjectile.get().setX(self.getX() + self.flipX(NSPEC_PROJ_X_OFFSET));
    neutralSpecialProjectile.get().setY(self.getY() + NSPEC_PROJ_Y_OFFSET);
}

//cooldown timer
function startNeutralSpecialCooldown(){
    disableNeutralSpecial();
    self.addTimer(NEUTRAL_SPECIAL_COOLDOWN, 1, enableNeutralSpecial, {persistent:true});
}

function disableNeutralSpecial(){
    if (lastDisabledNSpecStatusEffect.get() != null) {
        self.removeStatusEffect(StatusEffectType.DISABLE_ACTION, lastDisabledNSpecStatusEffect.get().id);
    }
    lastDisabledNSpecStatusEffect.set(self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_NEUTRAL));
}

function enableNeutralSpecial(){
    if (lastDisabledNSpecStatusEffect.get() != null) {
        self.removeStatusEffect(StatusEffectType.DISABLE_ACTION, lastDisabledNSpecStatusEffect.get().id);
        lastDisabledNSpecStatusEffect.set(null);
    }
}

//-----------SIDE SPECIAL-----------

//shield hit slowdown 
function sideSpecialShieldHit(){
	self.setXSpeed(-4);
}

//jump cancel hit confirm
function sideSpecialHit(){
	self.updateAnimationStats({allowJump: true});
}

//-----------DOWN SPECIAL-----------

function specialDown_gotoEndlag(){
    if(self.isOnFloor()){
        self.playAnimation("special_down_endlag");
    } else {
        self.playAnimation("special_down_air_endlag");
    }
}

function specialDown_resetTimer(){
    self.removeTimer(downSpecialLoopCheckTimer.get());
    downSpecialLoopCheckTimer.set(-1);
}

function specialDown_checkLoop(){
    var heldControls:ControlsObject = self.getHeldControls();

    if(!heldControls.SPECIAL){
        specialDown_resetTimer();
        specialDown_gotoEndlag();
    }
}

function specialDown_gotoLoop(){
    if(self.isOnFloor()){
        self.playAnimation("special_down_loop");
    } else {
        self.playAnimation("special_down_air_loop");
    }
    //failsafe
    specialDown_resetTimer();

    // start checking inputs
    downSpecialLoopCheckTimer.set(self.addTimer(1, -1, specialDown_checkLoop));    
}