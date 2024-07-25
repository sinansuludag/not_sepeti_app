// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/utils/Idatabase_helper.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/utils/kategori_helper.dart';
import 'package:not_sepeti_app/widgets/elevated_button.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  NotDetay({
    Key? key,
    required this.baslik,
  }) : super(key: key);

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper kategoriDatabaseHelper;
  int kategoriID = 0;
  int oncelikID = 0;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = [];
    kategoriDatabaseHelper = DatabaseHelper<Kategori>(KategoriHelper());
    kategoriDatabaseHelper.getAll().then(
      (kategoriIcerenMapListesi) {
        for (Map<String, dynamic> okunanDeger in kategoriIcerenMapListesi) {
          tumKategoriler.add(Kategori.fromMap(okunanDeger));
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.baslik),
        ),
        body: tumKategoriler.length <= 0
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildRowDropDownButton(
                            text: "Kategori :",
                            value: kategoriID,
                            items: _kategoriItemleriOlustur(),
                            onChanged: (value) {
                              setState(() {
                                kategoriID = value;
                              });
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextFormField(
                              hintText: "Not başlığını giriniz",
                              labelText: "Başlık"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextFormField(
                              hintText: "Not içeriğini giriniz",
                              labelText: "İçerik"),
                        ),
                        _buildRowDropDownButton(
                            text: "Öncelik :",
                            value: oncelikID,
                            items: _oncelikliSiralamasiOlustur(),
                            onChanged: (value) {
                              setState(() {
                                oncelikID = value;
                              });
                            }),
                        ButtonBar(
                          mainAxisSize: MainAxisSize.min,
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomElevatedButton(
                                title: "Vazgeç",
                                color: Colors.orangeAccent,
                                func: () {}),
                            CustomElevatedButton(
                                title: "Kaydet",
                                color: Colors.redAccent,
                                func: () {}),
                          ],
                        )
                      ],
                    )),
              ),
      ),
    );
  }

  Row _buildRowDropDownButton({
    required String text,
    required int value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              items: items,
              value: value,
              onChanged: (secilenID) {
                if (secilenID != null) {
                  onChanged(secilenID);
                }
              },
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.redAccent, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        )
      ],
    );
  }

  TextFormField _buildTextFormField(
      {required String hintText, required String labelText}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  List<DropdownMenuItem<int>> _kategoriItemleriOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
            value: kategori.kategoriID,
            child: Text(
              kategori.kategoriBaslik,
              style: const TextStyle(fontSize: 20),
            )))
        .toList();
  }

  List<DropdownMenuItem<int>> _oncelikliSiralamasiOlustur() {
    return _oncelik.map(
      (oncelik) {
        return DropdownMenuItem<int>(
          value: _oncelik.indexOf(oncelik),
          child: Text(
            oncelik,
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    ).toList();
  }
}
