class ModelKategori {
  ModelKategori({
    required this.result,
  });
  late final List<Result> result;

  ModelKategori.fromJson(Map<String, dynamic> json){
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
    required this.idkat,
    required this.nmkat,
  });
  late final String idkat;
  late final String nmkat;

  Result.fromJson(Map<String, dynamic> json){
    idkat = json['idkat'] ?? "";
    nmkat = json['nmkat'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idkat'] = idkat;
    _data['nmkat'] = nmkat;
    return _data;
  }
}