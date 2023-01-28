Asymmetrical Fraynkie
=====================

Modified version of assist template but uses asymmetrical sprites.
To demonstrate that it's possible, and how to set it up

Known Quirks
------------
I will probably come back and test/fix these situations but they are relatively minor. 
So hopefully can focus more on documenting workflow in the meantime.

- animations that are looped by the engine will only run left facing frame scripts once!
    - unclear why this is or how to fix ...


Automating Entity Setup
=======================

Also includes script for replacing left animation assets with the correct sprite.

DISCLAIMER: I see the following warning when opening fraytools:
```
 Warning - Assets with conflicting GUIDs exist in the project! (See log panel)
```
so use the script with caution ... doesn't seem to impact anything though.

Pre-requisites
--------------
- script requires Python 3 installed
- directory with right-facing sprites
- directory of left-facing sprites with same names as right-facing ones
    - these sprites should still "face the right" but have whatever differences only apply to the left side
    - alternatively in fraytools, can manually change the scale to flip the sprites after running the steps below
        - this is can't be done automatically since the position also needs to change

Workflow
--------
- Open fraytools with the sprite directories setup, and save 
    - This setups up the metadata
- Duplicate any right-facing animation and change the name from `<animation> (copy)` to `<animation>__left`
- Add all added animations to `AnimationStats.hx`
    - Some animations aren't in the file for right facing! but necessary to be added for left
- Run script:
    - open folder in terminal
    - run script with sprite directories
      i.e. `python3 ./replace_left_anims.py --entity library/entities/character.entity  --left "library/sprites/0_body pieces/body_left" --right "library/sprites/0_body pieces/body"`
- Open fraytools, verify that the __left animations now use the correct sprites
- Export and test

Should be able to rerun the script for any updates to animations or updates to the `character.entity` files. 
