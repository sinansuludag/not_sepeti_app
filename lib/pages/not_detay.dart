import 'package:flutter/material.dart';
import 'package:not_sepeti_app/constants/metods_constants.dart';
import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/models/notlar.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/utils/kategori_helper.dart';
import 'package:not_sepeti_app/utils/not_helper.dart';
import 'package:not_sepeti_app/widgets/elevated_button.dart';

// ignore: must_be_immutable
class NotDetay extends StatefulWidget {
  String baslik;
  Not duzenlenecekNot;
  NotDetay({
    Key? key,
    required this.baslik,
    required this.duzenlenecekNot,
  }) : super(key: key);

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper<Kategori> kategoriDatabaseHelper;
  late DatabaseHelper<Not> notDatabaseHelper;
  late int kategoriID;
  late int oncelikID;
  String notBaslik = '';
  String notIcerik = '';
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = [];
    kategoriDatabaseHelper = DatabaseHelper<Kategori>(KategoriHelper());
    notDatabaseHelper = DatabaseHelper<Not>(NotHelper());
    _kategoriVerileriniGetir();

    if (widget.duzenlenecekNot != null) {
      kategoriID = widget.duzenlenecekNot.kategoriID;
      oncelikID = widget.duzenlenecekNot.notOncelik;
    } else {
      kategoriID =
          (tumKategoriler.isNotEmpty ? tumKategoriler.first.kategoriID : 0)!;
      oncelikID = 0;
    }
  }

  Future<void> _kategoriVerileriniGetir() async {
    List<Kategori> kategoriList = await kategoriDatabaseHelper.getAll();
    setState(() {
      tumKategoriler = kategoriList;
      // Eğer kategoriID geçerli değilse, ilk kategoriyi seç
      if (!tumKategoriler
          .any((kategori) => kategori.kategoriID == kategoriID)) {
        kategoriID =
            (tumKategoriler.isNotEmpty ? tumKategoriler.first.kategoriID : 0)!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.baslik),
        ),
        body: tumKategoriler.isEmpty
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
                            initialValue:
                                widget.duzenlenecekNot.notBaslik ?? "",
                            hintText: "Not başlığını giriniz",
                            labelText: "Başlık",
                            onSaved: (value) {
                              notBaslik = value!;
                            },
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextFormField(
                            initialValue:
                                widget.duzenlenecekNot.notIcerik ?? "",
                            hintText: "Not içeriğini giriniz",
                            labelText: "İçerik",
                            onSaved: (value) {
                              notIcerik = value!;
                            },
                            maxLines: 4,
                          ),
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
                                title: "Vazgeç", func: _geriGel),
                            CustomElevatedButton(
                              title: "Kaydet",
                              func: _notuKaydet,
                            ),
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
              value: items.any((item) => item.value == value) ? value : null,
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
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        )
      ],
    );
  }

  TextFormField _buildTextFormField(
      {required String initialValue,
      required String hintText,
      required String labelText,
      required FormFieldSetter<String> onSaved,
      required int maxLines}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: ConstantMetods.buildOutlineInputBorder(Colors.black),
          enabledBorder: ConstantMetods.buildOutlineInputBorder(Colors.black),
          focusedBorder: ConstantMetods.buildOutlineInputBorder(Colors.red)),
      onSaved: onSaved,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Lütfen bu alanı boş geçmeyiniz";
        }
      },
      initialValue: initialValue,
      maxLines: maxLines,
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

  _geriGel() {
    Navigator.pop(context);
  }

  void _notuKaydet() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var suankiTarih = DateTime.now();
      if (widget.baslik == "Yeni Not") {
        notDatabaseHelper
            .insert(Not(
                kategoriID: kategoriID,
                notBaslik: notBaslik,
                notIcerik: notIcerik,
                notTarih: suankiTarih.toString(),
                notOncelik: oncelikID))
            .then(
          (value) {
            if (value != 0) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Not Eklendi")));
              formKey.currentState!.reset();
              setState(() {
                oncelikID = 0;
                kategoriID = 0;
              });
              Navigator.pop(context, true);
            }
          },
        );
      } else {
        notDatabaseHelper.update(
            Not(
                kategoriID: kategoriID,
                notBaslik: notBaslik,
                notIcerik: notIcerik,
                notTarih: suankiTarih.toString(),
                notOncelik: oncelikID),
            "notID=?",
            [widget.duzenlenecekNot.notID]).then(
          (guncellenenID) {
            if (guncellenenID != 0) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Not Güncellendi")));
              formKey.currentState!.reset();
              setState(() {
                oncelikID = 0;
                kategoriID = 0;
              });
              Navigator.pop(context, true);
            }
          },
        );
      }
    }
  }
}
