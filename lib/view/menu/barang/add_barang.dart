import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supplier/helper/ui/app_dialog.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/model/kategoi_model.dart';
import 'package:http_parser/http_parser.dart';

String token = "";

class AddBarangPage extends StatelessWidget {
  const AddBarangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => _ProviderGetKategori(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProviderGetImage(),
      ),
    ], child: const AddBarangContent());
  }
}

class AddBarangContent extends StatefulWidget {
  const AddBarangContent({Key? key}) : super(key: key);

  @override
  State<AddBarangContent> createState() => _AddBarangContentState();
}

class _AddBarangContentState extends State<AddBarangContent> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _hargaBeliController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await AppSharedPrefs.getToken().then((value) => token = value);
      if (token.isNotEmpty) {
        await context.read<_ProviderGetKategori>().setData(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Barang", textScaleFactor: 1,
            style: GoogleFonts.mochiyPopOne(),
      ),
    ),
      body: _valueDialogAdd(),
    );
  }

  Widget _valueDialogAdd() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _namaBarangController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Nama Barang",
                        ),
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mohon mengisi nama barang";
                          }
                          if (value.length < 2) {
                            return "Masukkan nama barnag dengan benar";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _hargaJualController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Harga Jual",
                        ),
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mohon mengisi harga jual";
                          }
                          if (value.length < 2) {
                            return "Masukkan harga jual dengan benar";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _hargaBeliController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Harga Beli",
                        ),
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mohon mengisi Harga Beli";
                          }
                          if (value.length < 2) {
                            return "Masukkan Harga Beli dengan benar";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<_ProviderGetKategori>(
                      builder: (context, value, child) {
                        var resDevice = value.result;
                        if (resDevice.isEmpty) {
                          return const Center(
                              child: Text(
                            "Sedang memuat data",
                            textScaleFactor: 1,
                          ));
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border:
                                  Border.all(style: BorderStyle.solid, width: 0.40),
                            ),
                            child: DropdownButton<Result>(
                              value: value.selectKategori,
                              iconSize: 24,
                              isExpanded: true,
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              onChanged: (newValue) {
                                value.setSelectKategori(newValue!);
                              },
                              underline: const SizedBox.shrink(),
                              items: resDevice.map((Result result) {
                                return DropdownMenuItem<Result>(
                                  value: result,
                                  child: Text(
                                    result.nmkat,
                                    textScaleFactor: 1,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        context
                            .read<ProviderGetImage>()
                            .setImageView(context, image);
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              labelText: "Foto Barang (max. 10MB) *",
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.image),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Consumer<ProviderGetImage>(
                      builder: (context, viewImage, child) {
                        ImageProvider? img = viewImage.imageView;
                        if (img != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                clipBehavior: Clip.hardEdge,
                                child: Image(image: img, height: MediaQuery.of(context).size.height / 3, width: MediaQuery.of(context).size.width,))
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:  Text(
                      'Tutup',
                        textScaleFactor: 1,
                        style: GoogleFonts.mochiyPopOne(
                            fontSize: 15)
                    )),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final fileImage = context.read<ProviderGetImage>().filenya;
                      final image = fileImage!.path;
                      List<int> imageBytes = fileImage.readAsBytesSync();
                      var a = base64Encode(imageBytes);
                      _addApi(context, {
                        "nmbarang": _namaBarangController.text,
                        "hjual": _hargaJualController.text,
                        "hbeli": _hargaBeliController.text,
                        "idkat": context.read<_ProviderGetKategori>().selectKategori!.idkat,
                        if (fileImage != null)
                          "image": a,
                      });
                    },
                    child:  Text(
                      'Submit',
                        textScaleFactor: 1,
                        style: GoogleFonts.mochiyPopOne(
                            fontSize: 15)
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class ImageContent extends StatelessWidget {
  final Function() onTap;

  const ImageContent({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderGetImage(),
        ),
      ],
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              ImagePicker picker = ImagePicker();
              XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              context.read<ProviderGetImage>().setImageView(context, image);
            },
            child: IgnorePointer(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    labelText: "Foto Selfie (max. 10MB) *",
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.image),
                    )),
              ),
            ),
          ),
          Consumer<ProviderGetImage>(
            builder: (context, viewImage, child) {
              ImageProvider? img = viewImage.imageView;
              if (img != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    maxRadius: 70.0,
                    minRadius: 50.0,
                    backgroundImage: img,
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}

class ProviderGetImage with ChangeNotifier {
  ImageProvider? imageView;
  File? filenya;
  XFile? xfilenya;

  void setImageView(BuildContext context, XFile? file) {
    if (file != null) {
      filenya = File(file.path);
      if (filenya != null) {
        final bytes = filenya!.readAsBytesSync().lengthInBytes;
        final kb = bytes / 1024;
        final mb = kb / 1024;
        if (mb >= 10) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "* Format Foto tidak didukung atau ukuran melebihi batas",
              textScaleFactor: 1,
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          xfilenya = file;
          imageView = FileImage(filenya!);
        }
      }
    }
    notifyListeners();
  }
}

Future<void> _addApi(BuildContext context, dynamic params) async {
  print(params);
  int act = 2;
  AppDialogs.showProgressDialog(context: context, title: "Prosess", message: "Proses tambah data");
  Response response = await Dio().post(
      "https://tugaskuy009.000webhostapp.com/tugas/dist.php?act=$act", data: params,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "token": token
      }));
  AppDialogs.hideProgressDialog();
  if (response.data['result'] != null) {
    await AppDialogs.resultDialog(context: context, title: "Berhasil", message: "Data berhasil ditambahkan");
    Navigator.pop(context);
  }
}


class _ProviderGetKategori with ChangeNotifier {
  List<Result> result = [];
  Result? selectKategori;
  int act = 1;

  Future<void> setData(BuildContext context, {bool append = false}) async {
    Response response = await Dio().get(
        "https://tugaskuy009.000webhostapp.com/tugas/kat.php?act=$act",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
        }));
    if (response.data != null) {
      ModelKategori model = ModelKategori.fromJson(response.data);
      result.clear();
      result.addAll(model.result);
      selectKategori = result[0];
    }
    notifyListeners();
  }

  void setSelectKategori(Result result) {
    selectKategori = result;
    notifyListeners();
  }
}
