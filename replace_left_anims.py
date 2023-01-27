#!/usr/bin/env python3
"""
Updates entity files with right assets with the equivalent left asset

See --help for usage
"""
import json
from pathlib import Path
from argparse import ArgumentParser

# TODO: Should probably* be an argument with this as default
LEFT_ANIM_SUFFIX = "__left"

def json_contents(json_path):
    with json_path.open() as json_file:
        return json.load(json_file)

def save_json(json_contents, json_path):
    with json_path.open("w") as json_file:
        return json.dump(json_contents, json_file)

class EntityInfo:
    def __init__(self, entity: dict):
        self._entity = entity


    def get_subfield_if(self, field_name, subfield_name, condition):
        for field in self._entity[field_name]:
            if subfield_name not in field or not condition(field):
                continue
            subfield = field[subfield_name]
            if type(subfield) is list:
                for val in subfield:
                    yield field, val
            else:
                yield field, subfield

    def __getitem__(self, field_name):
        return self._entity[field_name]

    @staticmethod
    def from_json(fpath: Path):
        return EntityInfo(json_contents(fpath))

    def to_json(self, fpath: Path):
        save_json(self._entity, fpath)


# find all image asset ids and map it from old to new
def map_assets(left_folder, right_folder):
    right_assets = {}
    asset_map = {}
    for right_file in right_folder.iterdir():
        if right_file.suffix != ".meta":
            continue
        metadata = json_contents(right_file)
        right_assets[right_file.name] = metadata["guid"]
    for left_file in left_folder.iterdir():
        if left_file.suffix != ".meta":
            continue
        if left_file.name not in right_assets:
            continue
        metadata = json_contents(left_file)
        asset_map[right_assets[left_file.name]] = metadata["guid"]
    return asset_map

# find all symbols used in all layers of left animations
def find_symbols_to_update(char_entity):
    def get_subfield_set(field_name, subfield_name, cond):
        values = set()
        for field, subfield in char_entity.get_subfield_if(field_name, subfield_name, cond):
            values.add(subfield)
        return values

    left_layers = get_subfield_set("animations", "layers", lambda animation: animation["name"].endswith(LEFT_ANIM_SUFFIX))
    left_keyframes = get_subfield_set("layers", "keyframes", lambda layer: layer["$id"] in left_layers)
    left_symbols = get_subfield_set("keyframes", "symbol", lambda keyframe: keyframe["$id"] in left_keyframes)
    return left_symbols

# replace image asset in symbol if it's one of mapped assets
def update_entity_assets(char_entity, asset_map):
    left_symbols = find_symbols_to_update(char_entity)
    for symbol in char_entity["symbols"]:
        if symbol["$id"] not in left_symbols:
            continue
        if "imageAsset" not in symbol:
            continue
        asset = symbol["imageAsset"]
        # set to mapped value or default to same value
        symbol["imageAsset"] = asset_map.get(asset, asset)

def find_keyframes_to_update(char_entity):
    # right animations w/ a left animation variant
    animations = {animation["name"][:-len(LEFT_ANIM_SUFFIX)] for animation in char_entity["animations"] if animation["name"].endswith(LEFT_ANIM_SUFFIX)}

    layers = char_entity.get_subfield_if("animations", "layers", lambda animation: animation["name"] in animations)
    layer_to_anim = {layer: animation["name"]  for animation, layer in layers}

    keyframes = char_entity.get_subfield_if("layers", "keyframes", lambda layer: layer["$id"] in layer_to_anim)
    keyframe_to_layer = {keyframe: layer["$id"]  for layer, keyframe in keyframes if keyframe == layer["keyframes"][0]}

    keyframe_to_anim =  {keyframe: layer_to_anim[layer] for keyframe, layer in keyframe_to_layer.items()}

    is_relevant_keyframe = lambda kf: kf["$id"] in keyframe_to_anim
    is_script_keyframe = lambda kf: kf["type"] == "FRAME_SCRIPT"
    return {kf["$id"]: keyframe_to_anim[kf["$id"]] for kf in char_entity["keyframes"] if is_relevant_keyframe(kf) and is_script_keyframe(kf)}

def update_entity_scripts(char_entity, asset_map):
    keyframes = find_keyframes_to_update(char_entity)
    for keyframe in char_entity["keyframes"]:
        if keyframe["$id"] not in keyframes:
            continue
        code = keyframe["code"] or ""
        anim_script = f'if (self.isFacingLeft()) self.playAnimation("{keyframes[keyframe["$id"]]}{LEFT_ANIM_SUFFIX}");'
        if anim_script in code:
            continue
        keyframe["code"] = code + "\r\n" + anim_script;

def update_entity(left_folder, right_folder, char_entity_path):
    char_entity = EntityInfo.from_json(char_entity_path)

    # Backup old entity
    backup_entity_path = char_entity_path.with_suffix(char_entity_path.suffix + ".bk")
    char_entity.to_json(Path(backup_entity_path.name)) # backup to current directory, not entity one

    # Update existing entity
    asset_map = map_assets(left_folder, right_folder)
    update_entity_assets(char_entity, asset_map)
    update_entity_scripts(char_entity, asset_map)
    char_entity.to_json(char_entity_path)


def get_args():
    parser = ArgumentParser()
    parser.add_argument('-l', '--left', required=True, type=Path)
    parser.add_argument('-r', '--right', required=True, type=Path)
    parser.add_argument('-e', '--entity', required=True, type=Path)
    args = parser.parse_args()
    assert args.entity.is_file(), "Path provided by `--entity` is not a file"
    assert args.left.is_dir(), "Path provided by `--left` is not a directory"
    assert args.right.is_dir(), "Path provided by `--right` is not a directory"
    return args.left, args.right, args.entity



if __name__ == "__main__":
    update_entity(*get_args())