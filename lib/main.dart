import 'package:flutter/material.dart';

void main() {
  runApp(const PresApp());
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
  const PresApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PresHomePage(),
    );
  }
}

class PresHomePage extends StatefulWidget {
  const PresHomePage({super.key});

  @override
  State<PresHomePage> createState() => _PresHomePageState([
    "Campos Quânticos",
    "Gravidade em Loop"
  ]);
}

class _PresHomePageState extends State<PresHomePage> {
  List<String> _presentations = [];

  _PresHomePageState(List<String> presentations) {
    _presentations = presentations;
  }

  void addFile(String title) {
    setState(() {
      _presentations.add(title);
    });
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
                    actionName: "Criar",
                  )),
                );
              },
            ),
            ..._presentations.map((title) => PresButton(
              text: title,
              textStyle: Theme.of(context).textTheme.headlineLarge,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresActionPage(title: title))
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
  final String title;

  const PresActionPage({super.key, required this.title});

  @override
  State<PresActionPage> createState() => _PresActionPageState();
}

class _PresActionPageState extends State<PresActionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Arquivo: ' + widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PresButton(
              text: 'EDITAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PresSavePage(
                    actionName: "Renomear",
                    previousTitle: widget.title,
                  )),
                );
              },
            ),
            PresButton(
              text: 'RENOMEAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
            PresButton(
              text: 'DELETAR',
              textStyle: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.red),
              buttonStyle: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red)
              ),
              onPressed: () {
              },
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
                  MaterialPageRoute(builder: (context) => PresHomePage())
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
  final String previousTitle;
  final String actionName;

  const PresSavePage({super.key, required this.actionName, this.previousTitle = ""});

  @override
  State<PresSavePage> createState() => _PresSavePageState(title: this.previousTitle);
}

class _PresSavePageState extends State<PresSavePage> {
  String _title;

  _PresSavePageState({required title}): _title = title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.actionName + ': ' + widget.previousTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PresButton(
              text: 'SALVAR',
              textStyle: Theme.of(context).textTheme.headlineMedium,
              onPressed: () {
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
