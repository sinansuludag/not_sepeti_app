class Kategori {
  int? kategoriID; // Nullable yapıyoruz
  String kategoriBaslik;

  Kategori({this.kategoriID, required this.kategoriBaslik});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (kategoriID != null) {
      map['kategoriID'] = kategoriID;
    }
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map)
      : kategoriID = map['kategoriID'],
        kategoriBaslik = map['kategoriBaslik'] ?? '';

  @override
  String toString() {
    return 'Kategori{kategoriID:$kategoriID, kategoriBaslik:$kategoriBaslik}';
  }
}
