import 'package:flutter/foundation.dart';

class MergedListenable extends ChangeNotifier {
  final List<Listenable> _listenables;

  MergedListenable(this._listenables) {
    for (var l in _listenables) {
      l.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (var l in _listenables) {
      l.removeListener(notifyListeners);
    }
    super.dispose();
  }
}

Listenable mergeListenables(List<Listenable> listenables) {
  return MergedListenable(listenables);
}
