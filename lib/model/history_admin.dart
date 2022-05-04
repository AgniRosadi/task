class ModalHistoryAdmin {
  ModalHistoryAdmin({
    required this.result,
  });
  late final List<Result> result;

  ModalHistoryAdmin.fromJson(Map<String, dynamic> json){
    result = List.from(json['result']).map((e)=>Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.map((e)=>e.toJson()).toList();
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
    required this.hbeli,
    required this.jumlah,
    required this.tgl,
  });
  late final String notrans;
  late final String idbarang;
  late final String nmbarang;
  late final String idkat;
  late final String nmkat;
  late final int hbeli;
  late final int jumlah;
  late final String tgl;

  Result.fromJson(Map<String, dynamic> json){
    notrans = json['notrans'] ??"";
    idbarang = json['idbarang']??"";
    nmbarang = json['nmbarang']??"";
    idkat = json['idkat']??"";
    nmkat = json['nmkat']??"";
    hbeli = json['hbeli']??"";
    jumlah = json['jumlah']??"";
    tgl = json['tgl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notrans'] = notrans;
    _data['idbarang'] = idbarang;
    _data['nmbarang'] = nmbarang;
    _data['idkat'] = idkat;
    _data['nmkat'] = nmkat;
    _data['hbeli'] = hbeli;
    _data['jumlah'] = jumlah;
    _data['tgl'] = tgl;
    return _data;
  }
}