import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../utils/preload_assets.dart';
import '../../utils/sprite_controller.dart';
import '../entity.dart';
import 'foundation.dart';

class Wall extends Entity {
  List<Sprite> sprites = [];
  Sprite leftSprite;
  Sprite rightSprite;

  Sprite lowLeftSprite;
  Sprite lowRightSprite;

  int spriteIndex = 0;

  Sprite currentSprite;
  Sprite currentLowSprite;

  List<Sprite> lowSprites = [];
  int imageId;
  String _imgPath;
  final double zoom = 1;

  bool showLow = false;
  bool showCollisionBox = false;

  final Foundation _foundation;

  Wall(double newPosX, double newPosY, this.imageId, this._foundation)
      : super(newPosX.floor() * 16.0 + 8, newPosY.ceil() * 16.0) {
    _imgPath = getImageId(imageId);
    loadSprite();

    shadownSize = 1;
    shadownLarge = PreloadAssets.getEffectSprite('shadown_square');
    //shadownLarge = Sprite("shadown_square.png");
    shadownOffset = Offset(0, 13);

    height = (zoom * 16) * 5;
    id = '_${newPosX.floor()}_${posY.ceil()}';
  }

  void loadSprite() {
    lowSprites.add(PreloadAssets.getWallSprite('low_$_imgPath'));
    sprites.add(PreloadAssets.getWallSprite(_imgPath));

    leftSprite = PreloadAssets.getWallSprite('${_imgPath}_left');
    rightSprite = PreloadAssets.getWallSprite('${_imgPath}_right');
    lowLeftSprite = PreloadAssets.getWallSprite('low_${_imgPath}_left');
    lowRightSprite = PreloadAssets.getWallSprite('low_${_imgPath}_right');

    for (var i = 2; i <= 5; i++) {
      var nextSprite = PreloadAssets.getWallSprite('${_imgPath}_$i');
      if (nextSprite == null) return;
      sprites.add(nextSprite);

      var lowNextSprite = PreloadAssets.getWallSprite('low_${_imgPath}_$i');
      if (nextSprite == null) return;
      lowSprites.add(lowNextSprite);
    }
  }

  void draw(Canvas c) {
    if (sprites.isEmpty || lowSprites.isEmpty) return;
    var pivot = Offset((zoom * 16) / 2, height);

    selectWallSprite();

    if (showLow) {
      currentLowSprite.render(c,
          position: Vector2(x - pivot.dx, y - pivot.dy - z), size: Vector2(SpriteController.spriteSize, height));
    } else {
      currentSprite.render(c,
          position: Vector2(x - pivot.dx, y - pivot.dy - z), size: Vector2(SpriteController.spriteSize, height));
    }

    showCollisionBox ? debugDraw(c) : null;
  }

  void selectWallSprite() {
    spriteIndex = posX % sprites.length;
    //if (spriteIndex >= sprites.length) spriteIndex = 0;
    currentSprite = sprites[spriteIndex];
    currentLowSprite = lowSprites[spriteIndex];

    var leftWall = _foundation.wallList['_${posX - 1}_$posY'];
    var rightWall = _foundation.wallList['_${posX + 1}_$posY'];
    if (leftWall == null && rightWall != null && leftSprite != null) {
      currentSprite = leftSprite;
    }
    if (rightWall == null && leftWall != null && rightSprite != null) {
      currentSprite = rightSprite;
    }
  }

  String getImageId(int imageId) {
    return 'wall$imageId';
  }

  @override
  String toString() {
    return """id:$imageId, x:$posX y:$posY""";
  }

  dynamic toObject() {
    return {'id': imageId, 'x': posX, 'y': posY};
  }
}

enum WallLevel { low, mid, hight, upstair }
