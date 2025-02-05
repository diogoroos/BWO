// ignore_for_file: lines_longer_than_80_chars

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../game_controller.dart';
import '../../character_creation/character_creation.dart';
import '../../game_scene.dart';
import '../auth.dart';

class FirebaseAuth implements AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  FirebaseFirestore firestore;

  CollectionReference usersCollection;
  GoogleSignInAccount mAccount;

  String appVersion;

  FirebaseAuth(this.appVersion) {
    _googleSignIn.onCurrentUserChanged.listen((var account) {
      print('account $account');
      mAccount = account;

      // _getVersionNumber();
      _createOrReplaceAndLogUser();
    });
    _googleSignIn.signInSilently(); //auto login
    //logout(); // force login
  }

  Future<void> _handleSignIn() async {
    _googleSignIn.isSignedIn().then((isLogged) {
      try {
        _googleSignIn.signIn();
      } on Exception catch (error) {
        print(error);
      }

      // print('You are already logged in, welcome ${mAccount?.displayName}');
      // _getVersionNumber();
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void login() {
    _handleSignIn();
  }

  void logout() {
    _handleSignOut();
  }

  void _getVersionNumber() async {
    // var data = FirebaseDatabase.instance.ref().child('version');

    // data.once().then((event) {
    //   if (event.snapshot.value == appVersion) {
    //     _createOrReplaceAndLogUser();
    //   } else {
    //     Toast.add("You are out of date. The new version is: ${event.snapshot.value}");
    //     logout();
    //   }
    // });
  }

  //firebase
  void _createOrReplaceAndLogUser() async {
    await Firebase.initializeApp();

    firestore = FirebaseFirestore.instance;
    usersCollection = firestore.collection('users');

    var user = {
      "id": mAccount.id,
      "displayName": mAccount.displayName,
      "email": mAccount.email,
      "photoUrl": mAccount.photoUrl
    };
    await usersCollection.doc(user["id"]).set(user, SetOptions(merge: true));

    //checks if user account has a character already
    await getCharacterNameFromUserAccount().then((charName) {
      print('playing with character $charName');
      if (charName != null) {
        retriveCharacterData(charName);
      } else {
        print('No characters found, moving to '
            'character creation windows.');
        GameController.currentScene = CharacterCreation(this);
      }
    });
  }

  void retriveCharacterData(String characterName) async {
    var usersCollection = await firestore.collection('users').doc(mAccount.id).get();
    if (usersCollection != null && usersCollection.data() != null) {
      print('Retrieved character information: ${usersCollection.data()}');
      var data = usersCollection.data();
      var pName = data['name'] ?? data['characterName'] ?? 'Player';
      var pX = num.parse(data['x'] ?? '0.0'.toString());
      var pY = num.parse(data['y'] ?? '0.0'.toString());
      var pSprite = data['sprite'] ?? 'human/male1';
      var pHp = int.parse(data['hp'] ?? 10.toString());
      var pXp = int.parse(data['xp'] ?? 10.toString());
      var pLv = int.parse(data['lv'] ?? 10.toString());

      print('creating player $pName on position: $pX, $pY');

      GameController.currentScene = GameScene(pName, Offset(pX, pY), pSprite, pHp, pXp, pLv);
    } else {
      print('Character not found, moving to character creation windows.');
      GameController.currentScene = CharacterCreation(this);
    }

    // data.once().then((event) {
    //   if (event.snapshot.value != null) {
    //     print('Retrieved character information: ${event.snapshot.value}');
    //     var value = event.snapshot.value;
    //     Map<String, dynamic> data = value as Map;
    //     var pName = data['name'];
    //     var pX = double.parse(data['x'].toString());
    //     var pY = double.parse(data['y'].toString());
    //     var pSprite = data['sprite'];
    //     var pHp = int.parse(data['hp'].toString());
    //     var pXp = int.parse(data['xp'].toString());
    //     var pLv = int.parse(data['lv'].toString());

    //     print('creating player $pName on position: $pX, $pY');

    //     GameController.currentScene = GameScene(pName, Offset(pX, pY), pSprite, pHp, pXp, pLv);
    //   } else {
    //     print('Character not found, moving to character creation windows.');
    //     GameController.currentScene = CharacterCreation(this);
    //   }
    // });
  }

  Future<bool> isNameAvailable(String characterName) async {
    // var data = FirebaseDatabase.instance.ref().child('${ServerUtils.database}/state/players/$characterName');

    // var isAvaiable = false;

    // await data.once().then((event) {
    //   if (event.snapshot.value == null) {
    //     isAvaiable = true;
    //   } else {
    //     Toast.add('Character name already taken: ${(event.snapshot.value as Map)["name"]}');
    //   }
    // });
    // isAvaiable = true;
    // return isAvaiable;
    return true;
  }

  Future createCharacterForUser(String characterName) async {
    print('saving character name: $characterName to account: ${mAccount.id}');
    var user = {
      "id": mAccount.id,
      "characterName": characterName,
    };

    await usersCollection.doc(user["id"]).set(user, SetOptions(merge: true));
  }

  Future<String> getCharacterNameFromUserAccount() async {
    //checks if user account has a character already

    var charName = await usersCollection.doc(mAccount.id).get().then((value) {
      var rawData = value.data();
      Map<String, dynamic> data = rawData as Map;
      if (data.containsKey('characterName')) {
        var charName = value.get('characterName');
        return charName;
      }
      return null;
    });
    return charName;
  }
}
