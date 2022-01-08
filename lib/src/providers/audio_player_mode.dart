import 'package:flutter/cupertino.dart';

class AudioPlayerMode extends ChangeNotifier {
  bool _isPlaying = false;
  Duration _songDuration = Duration(milliseconds: 0);
  Duration _current = Duration(milliseconds: 0);

  String get songTotalDuration => this.printDuration(this._songDuration);
  String get currentSecond => this.printDuration(this._current);

  double get porcentaje => (this._songDuration.inSeconds > 0)
      ? this._current.inSeconds / this._songDuration.inSeconds
      : 0;

  late AnimationController _controller;
  set controller(AnimationController controller) {
    this._controller = controller;
  }

  AnimationController get controller => this._controller;

  bool get isPlaying => this._isPlaying;

  set isPlaying(bool value) {
    this._isPlaying = value;
    notifyListeners();
  }

  Duration get songDuration => this._songDuration;

  set songDuration(Duration value) {
    this._songDuration = value;
    notifyListeners();
  }

  Duration get current => this._current;

  set current(Duration value) {
    this._current = value;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitsMinutes:$twoDigitSeconds";
  }
}
