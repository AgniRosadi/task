import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supplier/helper/constant/shared_prefs_const.dart';
import 'package:supplier/helper/ui/app_dialog.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/model/master_model.dart';
import 'package:supplier/provider/user_info_provider.dart';

String token = "";

class CNewPage extends StatelessWidget {
  final dynamic params;

  const CNewPage({Key? key, this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout",
            textScaleFactor: 1,
            style: GoogleFonts.mochiyPopOne(fontSize: 20, color: Colors.white)),
      ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => _ProviderGetData(),
            ),
            ChangeNotifierProvider(
              create: (context) => _IsBusy(),
            ),
          ],
          child: CNewContent(
            params: params,
          )),
    );
  }
}

class CNewContent extends StatefulWidget {
  final dynamic params;

  const CNewContent({Key? key, this.params}) : super(key: key);

  @override
  State<CNewContent> createState() => _CNewContentState();
}

class _CNewContentState extends State<CNewContent> {
  int counter = 0;
  final formKey = GlobalKey<FormState>();
  final alamatC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await AppSharedPrefs.getToken().then((value) => token = value);
      await AppSharedPrefs.getString(SharedPrefsConst.alamat)
          .then((value) => alamatC.text = value);
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        args as Map<String, dynamic>;
        await context.read<_ProviderGetData>().setData(args['rows']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<_ProviderGetData>(
      builder: (context, value, child) {
        var rows = value.result;
        if (rows != null) {
          return Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rows.image.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                                'https://tugaskuy009.000webhostapp.com/tugas/product/images/' +
                                    rows.image,
                                height: 200),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (rows.nmkat.isNotEmpty)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                rows.nmbarang.trim(),
                                                textScaleFactor: 1,
                                                style:
                                                    GoogleFonts.mochiyPopOne(
                                                        fontSize: 15),
                                              ),
                                              Text(rows.nmkat.trim(),
                                                  textScaleFactor: 1,
                                                  style: GoogleFonts
                                                      .mochiyPopOne(
                                                          fontSize: 10)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  Text(
                                    "Harga barang",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.mochiyPopOne(
                                        fontSize: 10),
                                  ),
                                  Text(rows.hjual.toString(),
                                      textScaleFactor: 1,
                                      style: GoogleFonts.mochiyPopOne(
                                          fontSize: 10)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Total Biaya",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.mochiyPopOne(
                                          fontSize: 10)),
                                  Builder(builder: (context) {
                                  int total = rows.hjual *
                                      counter;
                                  return Text(total.toString(),
                                      textScaleFactor: 1,
                                      style: GoogleFonts
                                          .mochiyPopOne(
                                              fontSize: 10));
                                  }),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jumlah barang",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.mochiyPopOne(
                                        fontSize: 10),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                counter++;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              size: 20,
                                            )),
                                      ),
                                      Text(
                                        counter.toString(),
                                        textScaleFactor: 1,
                                        style: GoogleFonts.mochiyPopOne(
                                            fontSize: 10),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder()),
                                            onPressed: () {
                                              if (counter > 0) {
                                                setState(() {
                                                  counter--;
                                                });
                                              }
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              size: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Form(
                            key: formKey,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: alamatC,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Alamat ...",
                                  alignLabelWithHint: true),
                              maxLines: 9,
                              minLines: 5,
                              enableSuggestions: false,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "alamat diisi dong.";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _buyApi(context, {
                                    "data" : [ {
                                  "idbarang" : rows.idbarang,
                                  "jumlah" : counter,

                                  }]
                                  });
                                },
                                child: Text(
                                  "Checkout",
                                  style: GoogleFonts.mochiyPopOne(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textScaleFactor: 1,
                                )),
                          ),
                        ],
                      ),

                    ],
                  )),
            ],
          );
        } else {
          return const Center(
              child: Text(
            "Belum ada data.",
            style: TextStyle(fontFamily: "Rubrik", fontSize: 16),
            textScaleFactor: 1,
          ));
        }
      },
    );
  }
}

Future<void> _buyApi(BuildContext context, dynamic params) async {
  print(params);
  // int act = 2;
  AppDialogs.showProgressDialog(
      context: context, title: "Prosess", message: "Proses tambah data");
  Response response = await Dio().post(
      "https://tugaskuy009.000webhostapp.com/tugas/jual.php",
      data: params,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "token": token
      }));
  AppDialogs.hideProgressDialog();
  if (response.data['result'] != null) {
    await AppDialogs.resultDialog(
        context: context,
        title: "Berhasil",
        message: "Data berhasil ditambahkan");
    Navigator.pop(context);
  }
}

class _ProviderGetData with ChangeNotifier {
  Result? result;

  Future<void> setData(Result result) async {
    this.result = result;
    print(result);
    notifyListeners();
  }
}

class _IsBusy with ChangeNotifier {
  bool busy = false;

  void isBusy(bool busy) {
    this.busy = busy;
    notifyListeners();
  }
}
