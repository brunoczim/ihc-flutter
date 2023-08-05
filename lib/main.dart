import 'package:flutter/material.dart';
import './table.dart';
import './page.dart';

void main() {
  PresTable presTable = PresTable();
  runApp(PresApp(presTable: presTable));
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
