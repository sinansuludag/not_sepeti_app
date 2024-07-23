import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  const NotListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      "Kategori Ekle",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Kategori Adı",
                            border: OutlineInputBorder(),
                          ),
                          validator: (girilenKategoriAdi) {},
                        )),
                      )
                    ],
                  );
                },
              );
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
    );
  }
}
