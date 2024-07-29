import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/widgets/elevated_button.dart';

class ConstantMetods {
  static Future<dynamic> buildKategoriShowDialog(
      {required BuildContext context,
      required DatabaseHelper<Kategori> databaseHelper,
      required String title,
      required String labelText,
      required String snackText,
      required bool isInsert,
      required Kategori? kategori}) {
    var formKey = GlobalKey<FormState>();
    String? kategoriAdi;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue:
                      isInsert == true ? "" : kategori!.kategoriBaslik,
                  decoration: InputDecoration(
                    labelText: labelText,
                    enabledBorder: buildOutlineInputBorder(Colors.black),
                    focusedBorder: buildOutlineInputBorder(Colors.red),
                  ),
                  onSaved: (value) {
                    kategoriAdi = value!;
                  },
                ),
              ),
            ),
            ButtonBar(
              children: [
                CustomElevatedButton(
                    title: "Vazgeç",
                    func: () {
                      Navigator.pop(context);
                    }),
                CustomElevatedButton(
                  title: "Kaydet",
                  func: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      isInsert == true
                          ? databaseHelper.insert(
                              Kategori(kategoriBaslik: kategoriAdi ?? ''))
                          : databaseHelper.update(
                              Kategori(kategoriBaslik: kategoriAdi!),
                              "kategoriID = ?",
                              [kategori!.kategoriID]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(snackText)),
                      );
                      isInsert == true
                          ? Navigator.pop(context)
                          : Navigator.of(context).pop(true);
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

  static OutlineInputBorder buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.solid, color: color),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }
}
