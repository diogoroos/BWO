import 'dart:math';

import 'package:BWO/Effects/RippleWaterEffect.dart';
import 'package:BWO/Effects/WalkEffect.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Entity/Status.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

abstract class Entity {
  Status status = Status();
  bool marketToBeRemoved = false;
  bool isActive = true;

  int posX;
  int posY;

  double x, y, z = 0;
  var mapHeight = 1;
  double width = 16;
  double height = 16;

  Rect collisionBox;
  bool isCollisionTrigger = false;

  double worldSize;
  double _gravity = 0.0;
  double _acceleraction = 0.0;
  double bounciness = .1;
  double friction = 3;

  Offset velocity = Offset.zero;
  Offset impulse = Offset.zero;
  Offset inputSpeed = Offset.zero;

  Paint p = new Paint();

  double shadownSize = 2;
  Sprite shadown = new Sprite("shadown.png");
  Sprite shadown_large = new Sprite("shadown_large.png");
  RippleWaterEffect _rippleWaterEffect = RippleWaterEffect();
  WalkEffect _walkEffect = WalkEffect();

  Entity(this.x, this.y) {
    worldSize = GameController.worldSize.toDouble();

    updatePhysics();
  }

  void draw(Canvas c) {
    print("drawning wrongly, this print should never appears.");
  }

  void debugDraw(Canvas c) {
    p.color = Colors.red;
    p.strokeWidth = 1;
    p.style = PaintingStyle.stroke;
    c.drawRect(collisionBox, p);
  }

  void drawEffects(Canvas c) {
    if (!isActive) {
      return;
    }
    _drawShadown(c);
    if (this is Player) {
      _rippleWaterEffect.draw(c, x, y, mapHeight);
      _walkEffect.draw(c, x, y, mapHeight, inputSpeed);
    }
  }

  void _drawShadown(Canvas c) {
    var distanceToGround = 1 - (z.abs().clamp(0, 100) / 100);
    Paint p = Paint();
    p.color = Color.fromRGBO(255, 255, 255, distanceToGround);

    var sizeX = 16 * shadownSize / 2;
    var sizeY = (16 - 4) * shadownSize;

    shadown_large.renderScaled(
      c,
      Position(
        x - sizeX * distanceToGround,
        y - sizeY * distanceToGround,
      ),
      scale: shadownSize * distanceToGround,
      overridePaint: p,
    );
  }

  void updatePhysics() {
    posX = x ~/ worldSize;
    posY = y ~/ worldSize;

    collisionBox = Rect.fromLTWH(x - (width / 2), y - height, width, height);

    updateGravity();
    moveFriction();
  }

  void moveWithPhysics(double xSpeed, double ySpeed) {
    velocity = Offset(
      xSpeed * GameController.deltaTime * 50,
      ySpeed * GameController.deltaTime * 50,
    );
    x -= velocity.dx;
    y -= velocity.dy;

    inputSpeed = Offset(xSpeed, ySpeed);
  }

  void moveFriction() {
    impulse =
        Offset.lerp(impulse, Offset.zero, GameController.deltaTime * friction);
    x += impulse.dx;
    y += impulse.dy;
  }

  void updateGravity() {
    if (z > 0) {
      _acceleraction += (1 * GameController.deltaTime);
      _gravity += _acceleraction * 1.0;

      if (_gravity > 10) {
        //_gravity max 10m/s err. I mean 10pixels/deltaTime
        _gravity = 10;
      }
      z -= _gravity;
    }

    if (z < 0) {
      z = 0;
      if (_gravity >= 1) {
        z = 1;
        var impulseForce = _gravity / 2;
        double rForceX = (Random().nextDouble() - 0.5) * impulseForce;
        double rForceY = (Random().nextDouble() - 0.5) * impulseForce;
        impulse = Offset(rForceX, rForceY);
      }
      _gravity = -_gravity * bounciness;
      _acceleraction = 0;
    }
  }

  void onTriggerStay(Entity entity) {}

  void destroy() {
    marketToBeRemoved = true;
  }
}
