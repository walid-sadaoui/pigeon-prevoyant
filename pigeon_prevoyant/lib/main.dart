import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PigeonPrevoyant());
}

class PigeonPrevoyant extends StatelessWidget {
  const PigeonPrevoyant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pigeon Prévoyant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        fontFamily: 'RobotoFlex',
        useMaterial3: true,
      ),
      home: const InitBudgetPage(title: 'Pigeon Prévoyant'),
    );
  }
}

class InitBudgetPage extends StatefulWidget {
  const InitBudgetPage({super.key, required this.title});
  final String title;

  @override
  State<InitBudgetPage> createState() => _InitBudgetPageState();
}

class _InitBudgetPageState extends State<InitBudgetPage> {
  final myController = TextEditingController();
  double? _budget;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  /// Load the initial budget value from persistent storage on start,
  /// or fallback to 0 if it doesn't exist.
  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _budget = prefs.getDouble('budget');
    });
  }

  /// After a click, increment the budget state and
  /// asynchronously save it to persistent storage.
  Future<void> _incrementBudget() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _budget = double.parse(myController.text);
      if (_budget != null) {
        prefs.setDouble('budget', _budget as double);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _budget == null ? <Widget>[
            TextField(
              controller: myController,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Votre budget initial'
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _incrementBudget();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const SecondRoute()),
                  // );
              },
              child: const Text("C'est parti !"),
            ),
          ] : 
          <Widget>[
            Text(
              'Solde : $_budget €'
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementBudget,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
