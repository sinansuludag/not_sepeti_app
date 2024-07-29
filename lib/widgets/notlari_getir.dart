import 'dart:io';

import 'package:flutter/material.dart';
import 'package:not_sepeti_app/models/notlar.dart';
import 'package:not_sepeti_app/pages/not_detay.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/utils/not_helper.dart';

class NotlariGetir extends StatefulWidget {
  const NotlariGetir({Key? key}) : super(key: key);

  @override
  NotlariGetirState createState() => NotlariGetirState();
}

class NotlariGetirState extends State<NotlariGetir> {
  late List<Not> tumNotlar;
  late DatabaseHelper<Not> notDatabaseHelper;
  late Future<List<Not>> _notListFuture;

  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    notDatabaseHelper = DatabaseHelper<Not>(NotHelper());
    _notListFuture = notDatabaseHelper.getAll();
  }

  void refreshNotes() {
    setState(() {
      _notListFuture = notDatabaseHelper.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Not>>(
      future: _notListFuture,
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            tumNotlar = snapshot.data!;
            sleep(Duration(milliseconds: 300));
            return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                    title: Text(tumNotlar[index].notBaslik),
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildExpansionTileRow(
                                title: "Kategori",
                                text: tumNotlar[index].kategoriBaslik),
                            _buildExpansionTileRow(
                                title: "Oluşturulma Tarihi",
                                text: notDatabaseHelper.dateFormat(
                                    DateTime.parse(tumNotlar[index].notTarih))),
                            Text("İçerik",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor)),
                            _buildTextIcerik(index),
                            ButtonBar(
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _notSil(tumNotlar[index].notID),
                                  child: Text(
                                    "SİL",
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _detaySayfasinaGit(
                                          context, tumNotlar[index]);
                                    },
                                    child: Text(
                                      "GÜNCELLE",
                                      //style: TextStyle(color: Colors.green),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Hiç not bulunamadı"),
            );
          }
        } else {
          return Center(
            child: Text("Yükleniyor..."),
          );
        }
      },
    );
  }

  Padding _buildTextIcerik(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        tumNotlar[index].notIcerik,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Row _buildExpansionTileRow({required title, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
        ),
      ],
    );
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          radius: 25,
          child: Text(
            "AZ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade100,
        );
      case 1:
        return CircleAvatar(
          radius: 25,
          child: Text("ORTA", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent.shade400,
        );
      case 2:
        return CircleAvatar(
          radius: 25,
          child: Text("ACİL", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent.shade700,
        );
    }
  }

  _notSil(int? notID) {
    notDatabaseHelper.delete("notID = ?", [notID]).then(
      (silinenID) {
        if (silinenID != 0) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Not Silindi")));
          setState(() {
            refreshNotes();
          });
        }
      },
    );
  }

  void _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: "Notu Düzenle",
          duzenlenecekNot: not,
        ),
      ),
    ).then(
      (value) {
        if (value == true) {
          setState(() {
            refreshNotes();
          });
        }
      },
    );
  }
}
