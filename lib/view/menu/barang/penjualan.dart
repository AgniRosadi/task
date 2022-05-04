import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/provider/user_info_provider.dart';

import '../../../model/history_admin.dart';

String token = "";

class HAdminPage extends StatelessWidget {
  final dynamic params;

  const HAdminPage({Key? key, this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History",
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
          child: HAdminContent(
            params: params,
          )),
    );
  }
}

class HAdminContent extends StatefulWidget {
  final dynamic params;

  const HAdminContent({Key? key, this.params}) : super(key: key);

  @override
  State<HAdminContent> createState() => _HAdminContentState();
}

class _HAdminContentState extends State<HAdminContent> {
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
      context.read<_ProviderGetData>().setData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<_ProviderGetData>(
      builder: (context, value, child) {
        var rows = value.result;
        if (rows != null) {
          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No transaksi",
                            textScaleFactor: 1,
                            style: GoogleFonts.mochiyPopOne(
                                fontSize: 10),
                          ),
                          Text(rows[index].notrans.toString(),
                              textScaleFactor: 1,
                              style:
                              GoogleFonts.mochiyPopOne(
                                  fontSize: 10)),
                          Text(rows[index].nmbarang.toString(),
                              textScaleFactor: 1,
                              style:
                              GoogleFonts.mochiyPopOne(
                                  fontSize: 10)),
                          if(rows[index].nmkat.isNotEmpty)
                            Text(rows[index].nmkat.toString(),
                                textScaleFactor: 1,
                                style:
                                GoogleFonts.mochiyPopOne(
                                    fontSize: 10)),
                          Text(rows[index].jumlah.toString(),
                              textScaleFactor: 1,
                              style:
                              GoogleFonts.mochiyPopOne(
                                  fontSize: 10)),
                          Text(rows[index].hbeli.toString(),
                              textScaleFactor: 1,
                              style:
                              GoogleFonts.mochiyPopOne(
                                  fontSize: 10)),
                          Text(rows[index].tgl.toString(),
                              textScaleFactor: 1,
                              style:
                              GoogleFonts.mochiyPopOne(
                                  fontSize: 10)),

                        ],
                      ),
                    )),
              );
            },
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


class _ProviderGetData with ChangeNotifier {
  List<Result> result = [];
  int act = 1;
  String filter = "";
  bool isBusy = false;
  bool isDisposed = false;
  List<Result> cBarang = [];

  Future<void> setData(BuildContext context, {bool append = false}) async {
    if (isBusy) return;

    if (!append) {
      result.clear();
      notifyListeners();
    }

    isBusy = true;
    notifyListeners();

    Response response = await Dio().get(
        "https://tugaskuy009.000webhostapp.com/tugas/databeli.php",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
        }));
    if (response.data != null) {
      ModalHistoryAdmin model = ModalHistoryAdmin.fromJson(response.data);
      result.addAll(model.result);
    }
    isBusy = false;
    if (!isDisposed) notifyListeners();
  }

  void getCheckout(Result cBarang) async {
    this.cBarang.add(cBarang);
  }

  Future<void> setSearch([String searchText = ""]) async {
    filter = searchText;
    if (!isDisposed) notifyListeners();
  }

  //diposer navigator agar tidak eror saat pindah navigator secara cepat
  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}

class _IsBusy with ChangeNotifier {
  bool busy = false;

  void isBusy(bool busy) {
    this.busy = busy;
    notifyListeners();
  }
}
