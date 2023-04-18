import 'package:flutter/material.dart';

import '../../entities/enemys/enemy.dart';
import '../../entities/player/player.dart';
import '../../hud/build/build_hud.dart';
import '../../map/map_controller2.dart';
import '../../map/tree2.dart';
import '../../utils/tap_state.dart';

// import '../enemys/enemy.dart';

class PlayerActions {
  Player player;
  PlayerActions(this.player);

  bool isDoingAction = false;

  void interactWithTrees(MapController map) {
    if (!player.isMine) {
      return;
    }
    isDoingAction = false;

    if (BuildHUD.buildBtState == BuildButtonState.build) return;

    if (TapState.isTapingLeft()) {
      for (var entity in map.entitysOnViewport) {
        var target = Offset(entity.x, entity.y);
        var distance = (Offset(player.x, player.y) - target).distance;

        if (distance <= 3.0 * player.worldSize && isDoingAction == false) {
          if (entity is Tree2 && entity.status.isAlive()) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites) {
              var hasEnergy = player.status.useEnergy(1);
              if (hasEnergy) {
                player.equipmentController.setAction(DoAction2.attack);
                player.currentSprite = player.attackSprites;
                player.status.consumeHungriness(0.3);
                //entity.doDamage();

                player.playerNetwork
                    .sendHitTree(entity.x.round(), entity.y.round(), player.equipmentController.getMaxCutTreeDamage());
              }
            }
            player.setDirection(target);
          } else if (entity is Enemy) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites && entity.status.isAlive()) {
              player.currentSprite = player.attackSprites;
              player.equipmentController.setAction(DoAction2.attack);

              /*entity.getHut(
                  player.equipmentController.getMaxAttackDamage(), player,
                  isMine: true);*/
              //send damage to cloud
              player.playerNetwork.attackEnemy(entity.id, player.equipmentController.getMaxAttackDamage());
            }
            player.setDirection(target);
          }
        }
      }
    } else {
      //player.currentSprite = player.walkSprites;
    }
  }
}

enum DoAction2 { attack }
