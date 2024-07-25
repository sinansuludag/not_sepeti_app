import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.redAccent,
          )),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  const NotListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Not Sepeti"),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _buildShowDialog(context);
              },
              child: Icon(
                Icons.add_circle,
              ),
              mini: true,
              tooltip: "Kategori Ekle",
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
              tooltip: "Not Ekle",
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Ekle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            _buildForm(),
            ButtonBar(
              children: [
                _buildElevatedButton("Vazgeç", Colors.orangeAccent, () {
                  Navigator.pop(context);
                }),
                _buildElevatedButton("Kaydet", Colors.redAccent, () {})
              ],
            )
          ],
        );
      },
    );
  }

  ElevatedButton _buildElevatedButton(
      String title, Color color, VoidCallback func) {
    return ElevatedButton(
      onPressed: func,
      child: Text(title),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    );
  }
}

class _buildForm extends StatelessWidget {
  const _buildForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Kategori Adı",
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
