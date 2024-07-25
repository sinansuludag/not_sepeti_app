class Not {
  int? notID; // Nullable yapıyoruz çünkü otomatik olarak atanabilir
  late int kategoriID;
  late String notBaslik;
  late String notIcerik;
  late String notTarih;
  late int notOncelik;

  Not({
    this.notID,
    required this.kategoriID,
    required this.notBaslik,
    required this.notIcerik,
    required this.notTarih,
    required this.notOncelik,
  });

  // Map'ten nesneye dönüştürme yapıcı metodu
  Not.fromMap(Map<String, dynamic> map) {
    notID = map['notID'];
    kategoriID = map['kategoriID'];
    notBaslik = map['notBaslik'];
    notIcerik = map['notIcerik'];
    notTarih = map['notTarih'];
    notOncelik = map['notOncelik'];
  }

  // Nesneyi Map'e dönüştürme metodu
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (notID != null) {
      // `notID` null değilse ekleyin
      map['notID'] = notID;
    }
    map['kategoriID'] = kategoriID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;
    return map;
  }

  @override
  String toString() {
    return 'Not{notID: $notID, kategoriID: $kategoriID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }
}
