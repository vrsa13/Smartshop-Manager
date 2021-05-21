import 'package:flutter/cupertino.dart';

class Song extends ChangeNotifier {
  String songTitle = 'Title';

  void updateSongTitle(String newTitle) {
    songTitle = newTitle;

    notifyListeners();
  }
}
