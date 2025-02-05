import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../effects/foam_water_effect.dart';
import '../effects/water_stars_effect2.dart';
import '../utils/preload_assets.dart';
import '../utils/sprite_controller.dart';
import 'tile.dart';

class Ground extends Tile {
  WaterStarsEffect waterStarsEffect;
  FoamWaterEffect foamWaterEffect;
  Sprite grass;

  static const water = 95;
  static const lowWater = 110;
  static const lowSand = 112;
  static const sand = 118;
  static const lowGrass = 140;

  Ground(int posX, int posY, int height, int size, Color color) : super(posX, posY, height, size, color) {
    var tileColor = getTileDetailsBasedOnHight(this.height);
    boxPaint.color = color != null ? color : tileColor;

    if (height < 107) {
      waterStarsEffect = WaterStarsEffect(boxRect);
    }
    if (height >= 108 && height <= 110) {
      foamWaterEffect = FoamWaterEffect();
    }
  }

  void draw(Canvas c) {
    if (height >= 108 && height <= 110) {
      boxPaint.color = foamWaterEffect.getFoamColor(height, posX, posY); //Colors.blue[200];
    }

    c.drawRect(boxRect, boxPaint);

    if (grass != null) {
      grass.render(c, position: Vector2(boxRect.left, boxRect.top), size: Vector2.all(SpriteController.spriteSize * 1));
    }

    if (height < 107) {
      waterStarsEffect.blinkWaterEffect(c);
    }
  }

  Color getTileDetailsBasedOnHight(int heightLvl) {
    height = heightLvl;
    var green = 255 - heightLvl;

    if (heightLvl > 142 && heightLvl < 152 && math.Random().nextInt(100) > 98) {
      var id = math.Random().nextInt(5) + 1;
      grass = PreloadAssets.getEnviromentSprite("floor$id");
      /*grass = Sprite("enviroment/floor${id}.png",
          width: size.toDouble(), height: size.toDouble());*/
    }

    if (heightLvl < 50) {
      return Colors.blue[700];
    } else if (heightLvl < 75) {
      return Colors.blue[600];
    } else if (heightLvl < water) {
      return Colors.blue;
    } else if (heightLvl < lowWater) {
      return Colors.blue[400];
    } else if (heightLvl < lowSand) {
      return Color.fromRGBO(255, 224, 130, .94);
    } else if (heightLvl < sand) {
      return Colors.amber[200];
    } else if (heightLvl < lowGrass) {
      if (math.Random().nextInt(100) > 95) {
        var id = math.Random().nextInt(4) + 7;
        grass = PreloadAssets.getEnviromentSprite("grass$id");
        /*grass = Sprite("enviroment/grass$id.png",
            width: size.toDouble(), height: size.toDouble());*/
      }
      return Color.fromRGBO(116, green + 50, 54, 1);
    } else if (heightLvl < 160) {
      if (math.Random().nextInt(100) > 96) {
        var id = math.Random().nextInt(2) + 11;
        grass = PreloadAssets.getEnviromentSprite("grass$id");
        /*grass = Sprite("enviroment/grass$id.png",
            width: size.toDouble(), height: size.toDouble());*/
      }
      return Color.fromRGBO(82, green + 40, 46, 1);
    } else if (heightLvl < 185) {
      if (math.Random().nextInt(100) > 98) {
        var id = math.Random().nextInt(2) + 13;
        grass = PreloadAssets.getEnviromentSprite("grass$id");
        /*grass = Sprite("enviroment/grass${id}.png",
            width: size.toDouble(), height: size.toDouble());*/
      }
      return Color.fromRGBO(75, green + 36, 65, 1);
    } else if (heightLvl < 195) {
      return Color.fromRGBO(82, green, 46, 1);
    } else {
      return Color.fromRGBO(heightLvl - 130, heightLvl - 130, heightLvl - 130, 1);
    }
  }
}
