class ModelHistory {
  ModelHistory({
    required this.result,
  });

  late final List<Result> result;

  ModelHistory.fromJson(Map<String, dynamic> json) {
    result = List.from(json['result']).map((e) => Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Result {
  Result({
    required this.notrans,
    required this.idbarang,
    required this.nmbarang,
    required this.idkat,
    required this.nmkat,
    required this.hjual,
    required this.jumlah,
    required this.tgl,
    required this.nama,
    required this.alamat,
  });

  late final String notrans;
  late final String idbarang;
  late final String nmbarang;
  late final String idkat;
  late final String nmkat;
  late final int hjual;
  late final int jumlah;
  late final String tgl;
  late final String nama;
  late final String alamat;

  Result.fromJson(Map<String, dynamic> json) {
    notrans = json['notrans'] ?? "";
    idbarang = json['idbarang'] ?? "";
    nmbarang = json['nmbarang'] ?? "";
    idkat = json['idkat'] ?? "";
    nmkat = json['nmkat'] ?? "";
    hjual = json['hjual'] ?? 0;
    jumlah = json['jumlah'] ?? 0;
    tgl = json['tgl'] ?? "";
    nama = json['nama'] ?? "";
    alamat = json['alamat'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notrans'] = notrans;
    _data['idbarang'] = idbarang;
    _data['nmbarang'] = nmbarang;
    _data['idkat'] = idkat;
    _data['nmkat'] = nmkat;
    _data['hjual'] = hjual;
    _data['jumlah'] = jumlah;
    _data['tgl'] = tgl;
    _data['nama'] = nama;
    _data['alamat'] = alamat;
    return _data;
  }
}
