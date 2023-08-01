import 'package:flutter/material.dart';
import 'dart:collection';

void main() {
  PresTable presTable = PresTable();
  runApp(PresApp(presTable: presTable));
}

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

class PresButton extends StatelessWidget {
  final String text;

  final double margin;

  final double padding;

  final void Function()? onPressed;

  final TextStyle? textStyle;

  final ButtonStyle? buttonStyle;

  PresButton({
    super.key,
    required this.text,
    this.margin = 8.0,
    this.padding = 8.0,
    this.onPressed = null,
    this.textStyle = null,
    this.buttonStyle = null,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            text,
            style: textStyle,
          ),
        )
      )
    );
  }
}

class PresApp extends StatelessWidget {
  final PresTable presTable;

  PresApp({super.key, required this.presTable});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PresHomePage(presTable: presTable),
    );
  }
}

class PresHomePage extends StatefulWidget {
  final PresTable presTable;

  PresHomePage({super.key, required this.presTable});

  @override
  State<PresHomePage> createState() => _PresHomePageState(this.presTable);
}

class _PresHomePageState extends State<PresHomePage> {
  PresTable _presTable;

  _PresHomePageState(PresTable presTable): _presTable = presTable {
    _presTable = PresTable.proxy(target: presTable, onUpdate: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Baixa-Apresentação'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PresButton(
              text: '+ NOVO',
              textStyle: Theme.of(context).textTheme.headlineMedium,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresSavePage(
                    actionText: "Criar",
                    presTable: _presTable,
                  )),
                );
              },
            ),
            ..._presTable.map((entry) => PresButton(
              text: entry.value,
              textStyle: Theme.of(context).textTheme.headlineLarge,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresActionPage(
                    id: entry.key,
                    presTable: _presTable,
                  ))
                );
              }
            ))
          ],
        ),
      ),
    );
  }
}

class PresActionPage extends StatefulWidget {
  final int id;
  final PresTable presTable;

  PresActionPage({super.key, required this.id, required this.presTable});

  @override
  State<PresActionPage> createState() => _PresActionPageState(presTable);
}

class _PresActionPageState extends State<PresActionPage> {
  PresTable _presTable;

  _PresActionPageState(PresTable presTable): _presTable = presTable {
    _presTable = PresTable.proxy(target: presTable, onUpdate: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Arquivo: ' + _presTable.get(widget.id)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PresButton(
              text: 'EDITAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
            PresButton(
              text: 'RENOMEAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresSavePage(
                    actionText: "Renomear",
                    id: widget.id,
                    presTable: _presTable,
                  )),
                );
              },
            ),
            PresButton(
              text: 'DELETAR',
              textStyle: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.red),
              buttonStyle: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red)
              ),
              onPressed: () {
                _presTable.remove(widget.id);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }
            ),
            PresButton(
              text: 'COMPARTILHAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
            PresButton(
              text: 'TELA INICIAL',
              textStyle: Theme.of(context).textTheme.headlineMedium,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresHomePage(presTable: _presTable))
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

class PresSavePage extends StatefulWidget {
  final String actionText;
  final int? id;
  final PresTable presTable;

  PresSavePage({super.key, required this.actionText, this.id = null, required this.presTable }); 

  @override
  State<PresSavePage> createState() => _PresSavePageState(presTable, this.id);
}

class _PresSavePageState extends State<PresSavePage> {
  String _name;
  PresTable _presTable;

  _PresSavePageState(PresTable presTable, int? id):
    _name = id is int ? presTable.get(id!) : "",
   _presTable = presTable
  {
    _presTable = PresTable.proxy(target: presTable, onUpdate: () => setState(() {}));
  }

  String _previousName() {
    return widget.id is int ? _presTable.get(widget.id!) : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.actionText + ': ' + _previousName()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                maxLines: null,
                onChanged: (text) {
                  _name = text;
                },
              ),
            ),
            PresButton(
              text: 'SALVAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
              onPressed: () {
                if (widget.id is int) {
                  _presTable.rename(widget.id!, _name);
                } else {
                  _presTable.insert(_name);
                }
                Navigator.pop(context);
              },
            ),
            PresButton(
              text: 'CANCELAR',
              textStyle: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.red),
              buttonStyle: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
