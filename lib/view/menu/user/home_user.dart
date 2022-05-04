import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supplier/helper/ui/app_dialog.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/model/master_model.dart';
import 'package:supplier/provider/user_info_provider.dart';
import 'package:supplier/routes/app_routes.dart';
import 'package:supplier/view/menu/user/navigator.dart';

class HomeUserPage extends StatelessWidget {
  const HomeUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => ProviderGetData(),
                ),
                ChangeNotifierProvider(
                  create: (context) => ProviderClear(),
                ),
              ],
              child: _HomeUserContent())),
    );
  }
}

class _HomeUserContent extends StatefulWidget {
  const _HomeUserContent({Key? key}) : super(key: key);

  @override
  _HomeUserContentState createState() => _HomeUserContentState();
}

String token = "";

class _HomeUserContentState extends State<_HomeUserContent> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await AppSharedPrefs.getToken().then((value) => token = value);
      if (token.isNotEmpty) {
        await context.read<ProviderGetData>().setData(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.height / 7)),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid),
                ),
                height: MediaQuery.of(context).size.height / 2.9,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.height / 7)),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid),
                ),
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "MAIN MENU",
                              style: GoogleFonts.mochiyPopOne(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textScaleFactor: 1,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  var res = await AppDialogs.confirmDialog(
                                      context: context,
                                      title: "Logout",
                                      message: "Keluar dari aplikasi?",
                                      yesButtonLabel: "KELUAR",
                                      noButtonLabel: "BATAL");
                                  if (res == AppDialogAction.yes) {
                                    await AppSharedPrefs.setLogin(false);
                                    Navigator.pushReplacementNamed(
                                        context, AppRoute.rMain);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                        'Makasih yaa!',
                                        textScaleFactor: 1,
                                      ),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      duration: const Duration(seconds: 1),
                                    ));
                                  }
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hai, ${context.read<UserInfoProvider>().userFullName}",
                              style: GoogleFonts.mochiyPopOne(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textScaleFactor: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (context.watch<UserInfoProvider>().userRoleId == 2) _user()
        ],
      ),
    );
  }

  Widget _user() {
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
                        visible: context.watch<ProviderClear>().isShow,
                        child: InkWell(
                          onTap: () {
                            context.read<ProviderGetData>().setSearch();
                            _searchController.text = "";
                            context.read<ProviderClear>().setClearData(false);
                            context.read<ProviderGetData>().setData(context);
                          },
                          child: const Icon(Icons.close),
                        ))),
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  if (value.isEmpty) {
                    context.read<ProviderClear>().setClearData(false);
                    context.read<ProviderGetData>().setData(context);
                  } else {
                    context.read<ProviderClear>().setClearData(true);
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
    return Consumer<ProviderGetData>(
      builder: (context, value, child) {
        var rows = value.result;
        bool isBusy = value.isBusy;
        if (rows.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    if (rows[index].stok < 1) {
                      return Container();
                    } else {
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          shadowColor: Colors.black,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (rows[index].image.isNotEmpty)
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      // AppDialogs.resultDialog(context: context, title: "Berhasil", message: "Barang berhasil dibeli");
                                      Navigator.pushNamed(context, AppRoute.rCheckout1, arguments: {"rows" : rows[index]});
                                      // context.read<ProviderGetData>().getCheckout(rows[index]);
                                    },
                                    child: Text(
                                      "Beli",
                                      style: GoogleFonts.mochiyPopOne(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textScaleFactor: 1,
                                    )),
                              )
                            ],
                          ));
                    }
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

  Widget _list() {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      primary: true,
      children: [
        _box("Kategori", Icons.list_alt,
            () => Navigator.pushNamed(context, AppRoute.rKategori)),
        _box("Barang", Icons.list_alt,
            () => Navigator.pushNamed(context, AppRoute.rBarang)),
        _box("User", Icons.person,
            () => Navigator.pushNamed(context, AppRoute.rUser)),
        _box("Keluar", Icons.logout, () async {
          var res = await AppDialogs.confirmDialog(
              context: context,
              title: "Logout",
              message: "Keluar dari aplikasi?",
              yesButtonLabel: "KELUAR",
              noButtonLabel: "BATAL");
          if (res == AppDialogAction.yes) {
            await AppSharedPrefs.setLogin(false);
            Navigator.pushReplacementNamed(context, AppRoute.rMain);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                'Makasih yaa!',
                textScaleFactor: 1,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
            ));
          }
        }),
      ],
    );
  }

  Widget _box(String title, IconData icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 100,
        width: 200,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Text(title,
                textScaleFactor: 1,
                style: GoogleFonts.mochiyPopOne(
                    fontSize: 20, color: Colors.white)),
          ],
        )),
      ),
    );
  }

  void doSearch() {
    context.read<ProviderGetData>().setSearch(_searchController.text);
    context.read<ProviderGetData>().setData(context);
  }
}

class ProviderGetData with ChangeNotifier {
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

class ProviderClear with ChangeNotifier {
  bool isShow = false;

  void setClearData(bool isShow) {
    this.isShow = isShow;
    notifyListeners();
  }
}

