import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';

class PreloadAssets {
  static final Map<String, Sprite> _enviromentSpriteList = {
    "floor1": Sprite("enviroment/floor1.png"),
    "floor2": Sprite("enviroment/floor2.png"),
    "floor3": Sprite("enviroment/floor3.png"),
    "floor4": Sprite("enviroment/floor4.png"),
    "floor5": Sprite("enviroment/floor5.png"),
    "grass1": Sprite("enviroment/grass1.png"),
    "grass2": Sprite("enviroment/grass2.png"),
    "grass3": Sprite("enviroment/grass3.png"),
    "grass4": Sprite("enviroment/grass4.png"),
    "grass5": Sprite("enviroment/grass5.png"),
    "grass6": Sprite("enviroment/grass6.png"),
    "grass7": Sprite("enviroment/grass7.png"),
    "grass8": Sprite("enviroment/grass8.png"),
    "grass9": Sprite("enviroment/grass9.png"),
    "grass10": Sprite("enviroment/grass10.png"),
    "grass11": Sprite("enviroment/grass11.png"),
    "grass12": Sprite("enviroment/grass12.png"),
    "grass13": Sprite("enviroment/grass13.png"),
    "grass14": Sprite("enviroment/grass14.png"),
  };

  static final Map<String, SpriteBatch> _trees = {};

  static final Map<String, Sprite> _wallSpriteList = {
    "wall1": Sprite("walls/wall1.png"),
    "wall2": Sprite("walls/wall2.png"),
    "wall3": Sprite("walls/wall3.png"),
    "wall4": Sprite("walls/wall4.png"),
    "wall5": Sprite("walls/wall5.png"),
    "wall6": Sprite("walls/wall6.png"),
    "wall7": Sprite("walls/wall7.png"),
    "wall8": Sprite("walls/wall8.png"),
    "low_wall1": Sprite("walls/low_wall1.png"),
    "low_wall2": Sprite("walls/low_wall2.png"),
    "low_wall3": Sprite("walls/low_wall3.png"),
    "low_wall4": Sprite("walls/low_wall4.png"),
    "low_wall5": Sprite("walls/low_wall5.png"),
    "low_wall6": Sprite("walls/low_wall6.png"),
    "low_wall7": Sprite("walls/low_wall7.png"),
    "low_wall8": Sprite("walls/low_wall8.png"),
  };

  static final Map<String, Sprite> _floorSpriteList = {
    "floor1": Sprite("floors/floor1.png"),
    "floor2": Sprite("floors/floor2.png"),
    "floor3": Sprite("floors/floor3.png"),
    "floor4": Sprite("floors/floor4.png"),
  };

  static final Map<String, Sprite> _effects = {
    "shadown_large": Sprite("shadown_large.png"),
    "shadown_square": Sprite("shadown_square.png"),
    "ripple": Sprite("effects/ripple.png"),
    "rip": Sprite("effects/rip.png"),
  };

  static final Map<String, Sprite> _uiSpriteList = {
    "foundation": Sprite("ui/foundation.png"),
    "wall": Sprite("ui/wall.png"),
    "floor_icon": Sprite("ui/floor_icon.png"),
    "furniture": Sprite("ui/furniture.png"),
    "config": Sprite("ui/config.png"),
    "handsaw": Sprite("ui/handsaw.png"),
    "accept": Sprite("ui/accept.png"),
    "cancel": Sprite("ui/cancel.png"),
    "floor1": Sprite("ui/floor1.png"),
    "floor2": Sprite("ui/floor2.png"),
    "floor3": Sprite("ui/floor3.png"),
    "floor4": Sprite("ui/floor4.png"),
    "floor5": Sprite("ui/floor5.png"),
    "floor6": Sprite("ui/floor6.png"),
    "floor7": Sprite("ui/floor7.png"),
    "wall1": Sprite("ui/wall1.png"),
    "wall2": Sprite("ui/wall2.png"),
    "wall3": Sprite("ui/wall3.png"),
    "wall4": Sprite("ui/wall4.png"),
    "wall5": Sprite("ui/wall5.png"),
    "wall6": Sprite("ui/wall6.png"),
    "wall7": Sprite("ui/wall7.png"),
    "wall8": Sprite("ui/wall8.png"),
  };

  PreloadAssets() {
    loadSprites();
  }

  void loadSprites() async {
    print("Loading sprites Trees Assets");
    SpriteBatch.withAsset('trees/tree01.png')
        .then((value) => _trees['tree01'] = value);
    SpriteBatch.withAsset('trees/tree02.png')
        .then((value) => _trees['tree02'] = value);
    SpriteBatch.withAsset('trees/tree03.png')
        .then((value) => _trees['tree03'] = value);
    SpriteBatch.withAsset('trees/tree04.png')
        .then((value) => _trees['tree04'] = value);
  }

  static Sprite getEnviromentSprite(String grass) {
    return _enviromentSpriteList[grass];
  }

  static SpriteBatch getTreeSprite(String tree) {
    return _trees[tree];
  }

  static Sprite getWallSprite(String wall) {
    return _wallSpriteList[wall];
  }

  static Sprite getFloorSprite(String floor) {
    return _floorSpriteList[floor];
  }

  static Sprite getEffectSprite(String effect) {
    return _effects[effect];
  }

  static Sprite getUiSprite(String ui) {
    return _uiSpriteList[ui];
  }
}
