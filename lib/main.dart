import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mime Definer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mime Definer Default Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Array of string containing default values
  List<String> defaultValues = [
    "text/plain"
        "text/html"
        "text/css"
        "text/javascript"
        "text/csv"
        "text/xml"
        "text/markdown"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            for (final mimeType in defaultValues)
              SizedBox(height: 50, child: Center(child: Text(mimeType))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: ProgramChooser(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> listApplication() async {
  ProcessResult result = await Process.run('ls', ["/usr/share/applications"]);
  if (result.exitCode != 0) {
    return [];
  }
  String output = result.stdout.toString();
  return output.split('\n');
}

class ProgramChooser extends StatefulWidget {
  const ProgramChooser({super.key});
  @override
  State<ProgramChooser> createState() => _ProgramChooserState();
}

class _ProgramChooserState extends State<ProgramChooser> {
  List<String>? applicationList;
  String? selected;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      icon: const Icon(Icons.arrow_downward),
      items: <DropdownMenuItem<String>>[
        if (applicationList != null)
          for (final application in applicationList!)
            DropdownMenuItem<String>(
              value: application,
              child: Text(application),
            )
      ],
      onChanged: (String? value) {
        setState(() {
          selected = value;
        });
      },
    );
  }

  // Initialize the _displayText variable with the result of an async function
  void _initializeData() async {
    List<String> data = await listApplication();
    setState(() {
      applicationList = data;
      selected = applicationList?.first;
    });
  }
}

// void main(List<String> arguments) async {
//   if (arguments.isEmpty) {
//     print('Usage: dart main.dart <get|set> <mime-type> [desktop-entry]');
//     return;
//   }

//   String operation = arguments[0];
//   String mimeType = arguments[1];

//   if (operation == 'get') {
//     await getDefaultApp(mimeType);
//   } else if (operation == 'set') {
//     if (arguments.length < 3) {
//       print('Error: Missing desktop entry');
//       return;
//     }
//     String desktopEntry = arguments[2];
//     await setDefaultApp(mimeType, desktopEntry);
//   } else {
//     print('Error: Invalid operation');
//   }
// }

// Future<void> getDefaultApp(String mimeType) async {
//   ProcessResult result =
//       await Process.run('xdg-mime', ['query', 'default', mimeType]);
//   if (result.exitCode == 0) {
//     print('Default application for $mimeType: ${result.stdout}');
//   } else {
//     print('Error: ${result.stderr}');
//   }
// }

// Future<void> setDefaultApp(String mimeType, String desktopEntry) async {
//   ProcessResult result =
//       await Process.run('xdg-mime', ['default', desktopEntry, mimeType]);
//   if (result.exitCode == 0) {
//     print('Default application for $mimeType set to $desktopEntry');
//   } else {
//     print('Error: ${result.stderr}');
//   }
// }
