import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supplier/helper/ui/app_dialog.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/model/master_model.dart';
import 'package:supplier/routes/app_routes.dart';
import 'package:supplier/view/menu/barang/add_barang.dart';

String token = "";

class ScreenBarangPage extends StatelessWidget {
  const ScreenBarangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _ProviderGetData(),
        ),
        ChangeNotifierProvider(
          create: (context) => _ProviderClear(),
        ),
      ],
      child: const _root(),
    );
  }
}

class _root extends StatelessWidget {
  const _root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Barang",
            textScaleFactor: 1,
            style: GoogleFonts.mochiyPopOne(fontSize: 20, color: Colors.white)),
      ),
      body: const SafeArea(child: ScreenBarangContent()),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, AppRoute.rAddBarang);
            context.read<_ProviderGetData>().setData(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

class ScreenBarangContent extends StatefulWidget {
  const ScreenBarangContent({Key? key}) : super(key: key);

  @override
  State<ScreenBarangContent> createState() => _ScreenBarangContentState();
}

class _ScreenBarangContentState extends State<ScreenBarangContent> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await AppSharedPrefs.getToken().then((value) => token = value);
      if (token.isNotEmpty) {
        await context.read<_ProviderGetData>().setData(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextFormField(
                onFieldSubmitted: (_) {
                  doSearch();
                },
                textInputAction: TextInputAction.search,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _searchController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Search Product",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Visibility(
                        visible: context.watch<_ProviderClear>().isShow,
                        child: InkWell(
                          onTap: () {
                            context.read<_ProviderGetData>().setSearch();
                            _searchController.text = "";
                            context.read<_ProviderClear>().setClearData(false);
                            context.read<_ProviderGetData>().setData(context);
                          },
                          child: const Icon(Icons.close),
                        ))),
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  if (value.isEmpty) {
                    context.read<_ProviderClear>().setClearData(false);
                    context.read<_ProviderGetData>().setData(context);
                  } else {
                    context.read<_ProviderClear>().setClearData(true);
                  }
                },
              ),
            ),
            _listContent(),
          ],
        ),
      ),
    );
  }

  Widget _listContent() {
    return Consumer<_ProviderGetData>(
      builder: (context, value, child) {
        var rows = value.result;
        bool isBusy = value.isBusy;
        if (rows.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const BehindMotion(),

                            // A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(onDismissed: () {}),

                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: (_) async {
                                  await _deleteApi(context, jsonEncode({
                                    "idbarang" : rows[index].idbarang
                                  }));
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                              SlidableAction(
                                onPressed: (_) async {
                                  await Navigator.pushNamed(context, AppRoute.rUpdateBarang, arguments: {"rows" : rows[index]});
                                  context.read<_ProviderGetData>().setData(context);

                                },
                                backgroundColor: const Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 10,
                              shadowColor: Colors.black,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (rows[index].image.isNotEmpty)
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                              'https://tugaskuy009.000webhostapp.com/tugas/product/images/' +
                                                  rows[index].image,
                                              height: 200),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rows[index].nmbarang.trim(),
                                            textScaleFactor: 1,
                                            style: GoogleFonts.mochiyPopOne(
                                                fontSize: 15),
                                          ),
                                          if (rows[index].nmkat.isNotEmpty)
                                            Text(rows[index].nmkat.trim(),
                                                textScaleFactor: 1,
                                                style: GoogleFonts.mochiyPopOne(
                                                    fontSize: 10)),
                                          Text(
                                              "Stok Barang: " +
                                                  rows[index].stok.toString(),
                                              textScaleFactor: 1,
                                              style: GoogleFonts.mochiyPopOne(
                                                  fontSize: 10)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Divider(
                                            height: 1,
                                            color: Colors.black,
                                            thickness: 2,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text("Harga Beli:",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts
                                                            .mochiyPopOne(
                                                                fontSize: 10)),
                                                    Text(
                                                        " Rp. " +
                                                            rows[index]
                                                                .hbeli
                                                                .toString(),
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts
                                                            .mochiyPopOne(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Text("Harga Jual:",
                                                      textScaleFactor: 1,
                                                      style: GoogleFonts
                                                          .mochiyPopOne(
                                                              fontSize: 10)),
                                                  Text(
                                                      " Rp. " +
                                                          rows[index]
                                                              .hjual
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: GoogleFonts
                                                          .mochiyPopOne(
                                                              fontSize: 10)),
                                                ],
                                              )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ));
                  },
                ),
                if (isBusy)
                  const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator())
              ],
            ),
          );
        } else {
          if (isBusy) {
            return const Center(
              child: Text("no data"),
            );
          } else {
            if (value.filter == "") {
              return const Center(
                  child: Text(
                "Belum ada data.",
                style: TextStyle(fontFamily: "Rubrik", fontSize: 16),
                textScaleFactor: 1,
              ));
            } else {
              return Center(
                  child: Text(
                "Tidak ada data dengan pencarian '" + value.filter + "'",
                style: const TextStyle(fontFamily: "Rubrik", fontSize: 16),
                textScaleFactor: 1,
              ));
            }
          }
        }
      },
    );
  }

  void doSearch() {
    context.read<_ProviderGetData>().setSearch(_searchController.text);
    context.read<_ProviderGetData>().setData(context);
  }
}


Future<void> _deleteApi(BuildContext context, dynamic params) async {
  int act = 4;
 AppDialogs.showProgressDialog(context: context, title: "Prosess", message: "Proses hapus data");
  Response response = await Dio().post(
      "https://tugaskuy009.000webhostapp.com/tugas/dist.php?act=$act", data: params,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "token": token
      }));
   AppDialogs.hideProgressDialog();
  if (response.data['result'] != null) {
    await AppDialogs.resultDialog(context: context, title: "Berhasil", message: "Data berhasil dihapus");
    context.read<_ProviderGetData>().setData(context);
  }
}

class _ProviderGetData with ChangeNotifier {
  List<Result> result = [];
  int act = 1;
  String filter = "";
  bool isBusy = false;

  Future<void> setData(BuildContext context, {bool append = false}) async {
    if (isBusy) return;

    if (!append) {
      result.clear();
      notifyListeners();
    }

    isBusy = true;
    notifyListeners();

    Response response = await Dio().get(
        "https://tugaskuy009.000webhostapp.com/tugas/dist.php?act=$act&filter=$filter",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
        }));
    if (response.data != null) {
      MasterModel model = MasterModel.fromJson(response.data);
      result.addAll(model.result);
    }
    isBusy = false;
    notifyListeners();
  }

  Future<void> setSearch([String searchText = ""]) async {
    filter = searchText;
    notifyListeners();
  }
}

class _ProviderClear with ChangeNotifier {
  bool isShow = false;

  void setClearData(bool isShow) {
    this.isShow = isShow;
    notifyListeners();
  }
}
