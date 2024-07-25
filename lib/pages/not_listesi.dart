import 'package:flutter/material.dart';
import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/pages/not_detay.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/utils/kategori_helper.dart';
import 'package:not_sepeti_app/widgets/elevated_button.dart';

class NotListesi extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper<Kategori>(KategoriHelper());

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
                _buildKategoriShowDialog(context);
              },
              heroTag: "Kategori ekle",
              child: Icon(
                Icons.add_circle,
              ),
              mini: true,
              tooltip: "Kategori Ekle",
            ),
            FloatingActionButton(
              onPressed: () => _detaySayfasinaGit(context),
              heroTag: "Not ekle",
              child: Icon(Icons.add),
              tooltip: "Not Ekle",
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }

  Future<dynamic> _buildKategoriShowDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String? yeniKategoriAdi;
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
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Kategori Adı",
                    border: OutlineInputBorder(),
                  ),
                  validator: (girilenKategoriAdi) {
                    if (girilenKategoriAdi!.length < 3) {
                      return "En az 3 karakter giriniz";
                    }
                  },
                  onSaved: (value) {
                    yeniKategoriAdi = value!;
                  },
                ),
              ),
            ),
            ButtonBar(
              children: [
                CustomElevatedButton(
                    title: "Vazgeç",
                    color: Colors.orangeAccent,
                    func: () {
                      Navigator.pop(context);
                    }),
                CustomElevatedButton(
                  title: "Kaydet",
                  color: Colors.redAccent,
                  func: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await databaseHelper.insert(
                          Kategori(kategoriBaslik: yeniKategoriAdi ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kategori eklendi")),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotDetay(
            baslik: "Yeni Not",
          ),
        ));
  }
}
