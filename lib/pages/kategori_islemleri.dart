import 'package:flutter/material.dart';
import 'package:not_sepeti_app/constants/metods_constants.dart';
import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/utils/kategori_helper.dart';
import 'package:not_sepeti_app/widgets/elevated_button.dart';

class KategoriIslemleri extends StatefulWidget {
  const KategoriIslemleri({super.key});

  @override
  State<KategoriIslemleri> createState() => _KategoriIslemleriState();
}

class _KategoriIslemleriState extends State<KategoriIslemleri> {
  late List<Kategori> tumKategoriler;
  late DatabaseHelper<Kategori> katogoriDatabaseHelper;

  @override
  void initState() {
    super.initState();
    katogoriDatabaseHelper = DatabaseHelper<Kategori>(KategoriHelper());
    tumKategoriler = <Kategori>[];
    kategoriListesiniGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Kategoriler",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              bool result = await Navigator.maybePop(context, true);
              if (!result) {
                Navigator.pop(context, true);
              }
            },
          ),
        ),
        body: tumKategoriler.isEmpty
            ? const Center(
                child: Text("Yükleniyor..."),
              )
            : ListView.builder(
                itemCount: tumKategoriler.length,
                itemBuilder: (context, index) {
                  return _buildCard(index, context);
                },
              ),
      ),
    );
  }

  Card _buildCard(int index, BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => _kategoriGuncelle(tumKategoriler[index]),
        title: Text(tumKategoriler[index].kategoriBaslik),
        trailing: IconButton(
          onPressed: () => _kategoriyiSil(tumKategoriler[index].kategoriID!),
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: const Icon(Icons.category),
      ),
    );
  }

  void kategoriListesiniGuncelle() {
    katogoriDatabaseHelper.getAll().then(
      (kategoriIcerenListe) {
        setState(() {
          tumKategoriler = kategoriIcerenListe;
        });
      },
    );
  }

  _kategoriyiSil(int id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Kategori Sil",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Kategoriyi sildiğinizde bununla ilgili tüm notlar da silinecektir. Yine de silmek istediğinizden emin misiniz?"),
              ButtonBar(
                children: [
                  CustomElevatedButton(
                      title: "Hayır",
                      func: () {
                        Navigator.of(context).pop();
                      }),
                  CustomElevatedButton(
                      title: "Evet",
                      func: () {
                        katogoriDatabaseHelper.delete("kategoriID = ?", [id]);
                        Navigator.of(context).pop(true);
                        setState(() {
                          kategoriListesiniGuncelle();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Kategori Silindi")));
                      }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _kategoriGuncelle(Kategori guncellenecekKategori) async {
    await ConstantMetods.buildKategoriShowDialog(
        context: context,
        databaseHelper: katogoriDatabaseHelper,
        title: "Kategori Güncelle",
        labelText: "Kategori Adı",
        snackText: "Kategori Güncellendi",
        kategori: guncellenecekKategori,
        isInsert: false);
    setState(() {
      kategoriListesiniGuncelle();
    });
  }
}
