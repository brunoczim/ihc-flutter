import 'dart:collection';

class PresTableState {
  int autoInc = 0;
  final Map<int, String> idToName = new HashMap(); 
}

class PresTable extends Iterable<MapEntry<int, String>> {
  final PresTableState _state;
  final void Function() _onUpdate;

  PresTable(): 
    _state = PresTableState(),
    _onUpdate = (() {});

  PresTable.proxy({ required target, required onUpdate }):
    _state = target._state,
    _onUpdate = (() {
      onUpdate();
      target._onUpdate();
    });

  Iterator<MapEntry<int, String>> get iterator {
    return _state.idToName.entries.iterator;
  }

  String get(int id) {
    return _state.idToName[id] ?? "?";
  }

  int insert(String name) {
    int id = _state.autoInc;
    _state.autoInc += 1;
    _state.idToName[id] = name;
    _onUpdate();
    return id;
  }

  void rename(int id, String newName) {
    _state.idToName[id] = newName;
    _onUpdate();
  }

  void remove(int id) {
    _state.idToName.remove(id);
    _onUpdate();
  }
}

