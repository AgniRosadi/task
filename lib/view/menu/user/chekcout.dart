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

class CPage extends StatelessWidget {
  final dynamic params;

  const CPage({Key? key, this.params}) : super(key: key);

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
          child: CContent(
            params: params,
          )),
    );
  }
}

class CContent extends StatefulWidget {
  final dynamic params;

  const CContent({Key? key, this.params}) : super(key: key);

  @override
  State<CContent> createState() => _CContentState();
}

class _CContentState extends State<CContent> {
  int counter = 1;
  final formKey = GlobalKey<FormState>();
  final alamatC = TextEditingController();
  final List<int> _event = [];
  final List<int> _counter = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await AppSharedPrefs.getToken().then((value) => token = value);
      await AppSharedPrefs.getString(SharedPrefsConst.alamat)
          .then((value) => alamatC.text = value);
      final args = widget.params as Map<String, dynamic>;
      await context.read<_ProviderGetData>().setData(args['rows']);
      await context.read<_ProviderGetData>().setCbarang(args['res']);
      // context.read<_ProviderGetData>().setCounter(0);
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
              Expanded(
                child: ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  if (rows[index].image.isNotEmpty)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            'https://tugaskuy009.000webhostapp.com/tugas/product/images/' +
                                                rows[index].image,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (rows[index].nmkat.isNotEmpty)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            rows[index]
                                                                .nmbarang
                                                                .trim(),
                                                            textScaleFactor: 1,
                                                            style: GoogleFonts
                                                                .mochiyPopOne(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          Text(
                                                              rows[index]
                                                                  .nmkat
                                                                  .trim(),
                                                              textScaleFactor:
                                                                  1,
                                                              style: GoogleFonts
                                                                  .mochiyPopOne(
                                                                      fontSize:
                                                                          10)),
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
                                              Text(rows[index].hjual.toString(),
                                                  textScaleFactor: 1,
                                                  style:
                                                      GoogleFonts.mochiyPopOne(
                                                          fontSize: 10)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text("Total Biaya",
                                                  textScaleFactor: 1,
                                                  style:
                                                      GoogleFonts.mochiyPopOne(
                                                          fontSize: 10)),
                                              // Builder(builder: (context) {
                                              // int total = rows[index].hjual *
                                              //     _counter;
                                              // return Text(total.toString(),
                                              //     textScaleFactor: 1,
                                              //     style: GoogleFonts
                                              //         .mochiyPopOne(
                                              //             fontSize: 10));
                                              // }),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              const CircleBorder(),
                                                        ),
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  _ProviderGetData>()
                                                              .setAddCount(
                                                                  index);
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          size: 20,
                                                        )),
                                                  ),
                                                  Text(
                                                    context
                                                        .read<
                                                            _ProviderGetData>()
                                                        .count
                                                        .toString(),
                                                    textScaleFactor: 1,
                                                    style: GoogleFonts
                                                        .mochiyPopOne(
                                                            fontSize: 10),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    const CircleBorder()),
                                                        onPressed: () {
                                                          // if (_counter > 0) {
                                                          //   setState(() {
                                                          //     _counter--;
                                                          //     widget.params;
                                                          //   });
                                                          // _incrementCounter(index);
                                                          // context.read<_ProviderGetData>().tes();
                                                          // context.read<_ProviderGetData>().setCounter(0);
                                                          //   context.read<_ProviderGetData>().counter--;
                                                          // }
                                                          // context
                                                          //     .read<
                                                          //         _ProviderGetData>()
                                                          //     .setCounter(0);
                                                          // }
                                                          // context.read<_ProviderGetData>().setAddCounter();
                                                          context
                                                              .read<
                                                                  _ProviderGetData>()
                                                              .setRemoveCount(
                                                                  index);
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
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
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
                            // if(rows.firstWhere((element) => false))
                            // context.read<_IsBusy>().isBusy(true);
                            // Future.delayed(
                            //     const Duration(milliseconds: 100),
                            //     () async {
                            //   if (context.read<_IsBusy>().busy) {
                            //    await AppDialogs.showProgressDialog(
                            //         context: context,
                            //         title: "Proses..",
                            //         message: "Proses pembelian");
                            //   }
                            // }).timeout(Duration.zero,onTimeout: () async {
                            //   setState(() {
                            //     AppDialogs.hideProgressDialog();
                            //   });
                            //   //
                            //   // return ;
                            // },);
                            // final o = await AppDialogs.resultDialog(
                            //     context: context,
                            //     title: "Berhasil",
                            //     message: "Barang Berhasil dibeli");
                            // if (AppDialogAction.yes == o) {
                            //   Navigator.pop(context);
                            // }
                            // context.read<_IsBusy>().isBusy(false);
                            List<String> idBarang = [];
                            List<int> jumlah = [];
                            for (var item in rows) {
                              idBarang.add(item.idbarang);
                            }
                            // jumlah.add(_counter);
                            print(idBarang);
                            print(jumlah);
                          },
                          child: Text(
                            "Beli",
                            style: GoogleFonts.mochiyPopOne(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textScaleFactor: 1,
                          )),
                    ),
                  ],
                ),
              ),
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
  int act = 2;
  AppDialogs.showProgressDialog(
      context: context, title: "Prosess", message: "Proses tambah data");
  Response response = await Dio().post(
      "https://tugaskuy009.000webhostapp.com/tugas/beli.php?act=$act",
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
  List<Result> result = [];
  List<Result> cBarang = [];
  int count = 0;
  int index = 0;
  List<int> event = [];
  List<int> c = [];

  Future<void> setData(List<Result> result) async {
    if (result.isNotEmpty) {
      this.result = result;
    }
    print(result);
    notifyListeners();
  }

  Future<void> setCbarang(List<Result> cBarang) async {
    if (cBarang.isNotEmpty) {
      this.cBarang = cBarang;
    }
    print(cBarang);
    notifyListeners();
  }

  Future<void> setAddCount(int index) async {
    this.index = index;
      count++;
    event.add(count);
    print(event.last);
    notifyListeners();
  }

  Future<void> setRemoveCount(int index) async {
    if (this.index == index) {
      count--;
      event.remove(count);
    }
    notifyListeners();
  }
}

// _decrementCounter(int i) {
//   if (_counter[i] <= 0) {
//     _counter[i] = 0;
//   } else {
//     _counter[i]--;
//   }
//   _event.add(_counter[i]);
// }

class _IsBusy with ChangeNotifier {
  bool busy = false;

  void isBusy(bool busy) {
    this.busy = busy;
    notifyListeners();
  }
}
