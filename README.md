Asymmetrical Fraynkie
=====================

Modified version of assist template but uses asymmetrical sprites.
To demonstrate that it's possible, and how to set it up

Known Quirks
------------
- animations that are looped by the engine will only run left facing frame scripts once!
    - unclear why this is or how to fix, will look into it later


Workflow
===============
> Kinda lazy so probably won't bother with images here, just lemme know if something doesn't make sense

Script Setup
------------
The following script is also used in this templates's [Script.hx](./library/scripts/Character/Script.hx) so can see how it's applied there as well.

1.  Copy the script helper functions into your `Script.hx`:
    ```haxe
    var LEFT_ANIM_SUFFIX = "__left"

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
    ```
    You can use a different value for `LEFT_ANIM_SUFFIX` if you want, just make sure the left-facing animations have the same suffix.

2. Add the following code to the `update` function in your `Script.hx`:
    ```haxe
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
    ```

At this point your the code is setup to show left facing animations if possible but it will not handle the first frame. After setting up the animations, this code should just work.

Example in [Script.hx](./library/scripts/Character/Script.hx)


(Manual) Animation Setup
------------------------
### Entity File
In the `character.entity` file, setup the right facing animation however you would like. The are two important things to keep in mind:
 * The animation should have the same name as the right facing animation but with `__left` at the end.
 * On frame 1 of the `Frame Script` of the **right-facing animation** add the following code:
   ```haxe
   if (self.isFacingLeft()) changeToLeftAnimation();
   ```

The naming is important to make sure the animation available to the update script to flip in special cases. Similarly, the frame script is important to ensure that the animation is flipped *before* the right animation plays.

### Other files
Since you're adding new animations, also need to update `AnimationStats.hx` and `HitboxStats.hx`. 

For `AnimationStats.hx`, can simply put the new animation name with default stats. The `Script.hx` implementation automatically copies the stats of the right facing animation. For example to add the left-facing left-facing walk animations, can simply do:
```haxe
{
    // left facing animations
    walk_in__left: {},
    walk_out__left: {},
    walk_loop__left: {},

    // ... other animations
}
```
Example in [AnimationStats.hx](./library/scripts/Character/AnimationStats.hx)

For `HitboxStats.hx`, unfortunately the code cannot copy the stats automatically, so need to copy them manually. For example, to add left-facing jab animations for Fraynkie, would need to do:
```haxe
{
    // Left-facing jabs (copies of right-facing but renamed accordingly)
    jab1__left: {
        hitbox0: { damage: 2, angle: 80, baseKnockback: 20, knockbackGrowth: 5, hitstop: -1, selfHitstop: -1, limb:AttackLimb.FIST }
    },
    jab2__left: {
        hitbox0: { damage: 3, angle: 80, baseKnockback: 20, knockbackGrowth: 5, hitstop: -1, selfHitstop: -1, limb:AttackLimb.FIST }
    },
    jab3__left: {
        hitbox0: { damage: 1, angle: 85, baseKnockback: 17, knockbackGrowth: 0, hitstop: 1, selfHitstop: 3, hitstopNudgeMultiplier: 0.5, limb:AttackLimb.FOOT }
    },
}
```
Example in [HitboxStats.hx](./library/scripts/Character/HitboxStats.hx)

After adding doing the above steps for any left-facing animation, it should work in game. It is not necessary to implement left-facing animations for every possible animation if not desired, will fallback to the engine behaviour otherwise.


Automated Animation Setup
------------------------
> Optional alternative to the above, only suggested if you've used Python 3 before. If not, and are particularly interested, would suggest these instructions [this guide](https://www.wikihow.com/Use-Windows-Command-Prompt-to-Run-a-Python-File). Also instructions for installing at the top.

> I may eventually translate this script into something you can run *in-browser* to hopefully make it a bit more user-friendly. At least, for chrome (or chromium) users.

The `character.entity` portion of this setup is quite tedious, because there is no way (afaik) to just replace an asset with another in fraytools. So would require remembering the previous x/y coordinate, deleting the old asset, dragging in the new asset and the adjusting the x/y accordingly ...

Instead, I've provided a Python script that can modify this file automatically given two asset directories. script files will still need to be modified manually. For stats files, can use multiple cursors to do it very quickly.

First, duplicate the animations you wish to have left-facing variations. Rename them so they has the same name as the right facing animation but with `__left` at the end.

Place left facing sprites in one folder in the project, and right facing animations into another. Refresh in fraytools, and ensure that the `.meta` files are created for your sprites.

Close fraytools (not required, but can be confusing to edit the entity file from multiple places)

Run the script: In a directory, run `replace_left_anims.py` providing the path to the entity file, folder containing right facing assets and folder containing left facing assets. In the case of this demo, body animations are done, however, can run the script multiple times using different sets of folders if desired. i.e.

```bash
$ cd FraytoolsAsymDemo
$ python3 replace_left_anims.py --entity "library/entities/character.entity"  --left "library/sprites/0_body pieces/body_left" --right "library/sprites/0_body pieces/body"
```

When opening fraytools, may get a message about `conflicting GUIDs` but this appears to be a false positive. Navigate to the `character.entity` file and ensure that all the animations you wanted were edited correctly. When updating a right facing animation, can simply delete the left facing one, and redo the above process for just that animation. The script will ignore keyframes with updated sprites and frame scripts that were already updated.

