class Not {
  int notID;
  int kategoriID;
  String notBaslik;
  String notIcerik;
  String notTarih;
  int notOncelik;

  // Yapıcı metod
  Not({
    required this.notID,
    required this.kategoriID,
    required this.notBaslik,
    required this.notIcerik,
    required this.notTarih,
    required this.notOncelik,
  });

  // Map'ten nesneye dönüştürme yapıcı metodu
  Not.fromMap(Map<String, dynamic> map)
      : notID = map['notID'] ?? 0,
        kategoriID = map['kategoriID'] ?? 0,
        notBaslik = map['notBaslik'] ?? '',
        notIcerik = map['notIcerik'] ?? '',
        notTarih = map['notTarih'] ?? '',
        notOncelik = map['notOncelik'] ?? 0;

  // Nesneyi Map'e dönüştürme metodu
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = notID;
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
