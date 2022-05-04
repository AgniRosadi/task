class UserModel {
  UserModel({
    required this.result,
  });
  late final List<Result> result;

  UserModel.fromJson(Map<String, dynamic> json){
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
    required this.uname,
    required this.nama,
    required this.idrole,
    required this.nmrole,
    required this.alamat,
  });
  late final String uname;
  late final String nama;
  late final int idrole;
  late final String nmrole;
  late final String alamat;

  Result.fromJson(Map<String, dynamic> json){
    uname = json['uname'] ?? "";
    nama = json['nama'] ?? "";
    idrole = json['idrole'] ?? 0;
    nmrole = json['nmrole'] ?? "";
    alamat = json['alamat'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uname'] = uname;
    _data['nama'] = nama;
    _data['idrole'] = idrole;
    _data['nmrole'] = nmrole;
    _data['alamat'] = alamat;
    return _data;
  }
}