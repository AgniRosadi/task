class MasterModel {
  MasterModel({
    required this.result,
  });
  late final List<Result> result;

  MasterModel.fromJson(Map<String, dynamic> json){
    result = List.from(json['result'] ?? []).map((e)=>Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Result {
  Result({
    required this.idbarang,
    required this.nmbarang,
    required this.hjual,
    required this.hbeli,
    required this.stok,
    required this.idkat,
    required this.nmkat,
    required this.image,
  });
  late final String idbarang;
  late final String nmbarang;
  late final int hjual;
  late final int hbeli;
  late final int stok;
  late final String idkat;
  late final String nmkat;
  late final String image;

  Result.fromJson(Map<String, dynamic> json){
    idbarang = json['idbarang'] ?? "";
    nmbarang = json['nmbarang'] ?? "";
    hjual = json['hjual'] ?? 0;
    hbeli = json['hbeli'] ?? 0;
    stok = json['stok'] ?? 0;
    idkat = json['idkat'] ?? "";
    nmkat = json['nmkat'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idbarang'] = idbarang;
    _data['nmbarang'] = nmbarang;
    _data['hjual'] = hjual;
    _data['hbeli'] = hbeli;
    _data['stok'] = stok;
    _data['idkat'] = idkat;
    _data['nmkat'] = nmkat;
    _data['image'] = image;
    return _data;
  }
}