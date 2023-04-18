// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../map/map_controller2.dart';
import 'enemy.dart';

class Skull extends Enemy {
  Skull(double x, double y, MapController2 map, String name, String id, {Offset moveTo = Offset.zero})
      : super(x, y, map, "enemys/miniskull", id) {
    iaController.walkSpeed = 1;

    moveTo != Offset.zero ? iaController.moveTo(moveTo.dx, moveTo.dy) : null;

    super.name = name;
    status.setLevel(2, .5);
  }
}
