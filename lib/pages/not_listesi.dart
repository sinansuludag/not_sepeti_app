import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_sepeti_app/constants/metods_constants.dart';
import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/models/notlar.dart';
import 'package:not_sepeti_app/pages/kategori_islemleri.dart';
import 'package:not_sepeti_app/pages/not_detay.dart';
import 'package:not_sepeti_app/utils/database_helper.dart';
import 'package:not_sepeti_app/utils/kategori_helper.dart';
import 'package:not_sepeti_app/utils/not_helper.dart';
import 'package:not_sepeti_app/widgets/notlari_getir.dart';

class NotListesi extends StatefulWidget {
  const NotListesi({Key? key}) : super(key: key);
  @override
  _NotListesiState createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  final DatabaseHelper<Kategori> kategoriDatabaseHelper =
      DatabaseHelper<Kategori>(KategoriHelper());
  final DatabaseHelper<Not> notDatabaseHelper =
      DatabaseHelper<Not>(NotHelper());
  late final GlobalKey<NotlariGetirState> _notlariGetirKey;

  @override
  void initState() {
    super.initState();
    _notlariGetirKey = GlobalKey<NotlariGetirState>();
  }

  void _notlariYenile() {
    if (_notlariGetirKey.currentState != null) {
      _notlariGetirKey.currentState?.refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  _buildPopupMenuItem(context),
                ];
              },
            )
          ],
          title: Center(
            child: Text(
              "Not Sepeti",
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        body: NotlariGetir(key: _notlariGetirKey),
      ),
    );
  }

  Column _buildFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await ConstantMetods.buildKategoriShowDialog(
                context: context,
                databaseHelper: kategoriDatabaseHelper,
                title: "Kategori Ekle",
                isInsert: true,
                labelText: "Kategori Adı",
                snackText: "Kategori Eklendi",
                kategori: null);
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
    );
  }

  PopupMenuItem<dynamic> _buildPopupMenuItem(BuildContext context) {
    return PopupMenuItem(
        child: ListTile(
            leading: Icon(Icons.category),
            title: Text("Kategoriler"),
            onTap: () {
              Navigator.pop(context);
              _kategorilerSayfasinaGit(context);
            }));
  }

  void _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: "Yeni Not",
          duzenlenecekNot: Not(
              kategoriID: 0,
              notBaslik: '',
              notIcerik: '',
              notTarih: '',
              notOncelik: 0),
        ),
      ),
    ).then((value) {
      if (value == true) {
        _notlariYenile();
      }
    });
  }

  void _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const KategoriIslemleri(),
        )).then(
      (value) {
        if (value == true) {
          setState(() {
            _notlariYenile();
          });
        }
      },
    );
  }
}
