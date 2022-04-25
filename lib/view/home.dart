import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supplier/custom-helper/app_util.dart';
import 'package:supplier/helper/ui/app_dialog.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/model/master_model.dart';
import 'package:supplier/provider/user_info_provider.dart';
import 'package:supplier/routes/app_routes.dart';
import 'package:supplier/view/component/gradient_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          child: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => _ProviderGetData(),
        ),
        ChangeNotifierProvider(
          create: (context) => _ProviderClear(),
        ),
      ], child: const _Content())),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<_ProviderGetData>().setData(context);
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
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: _buildMenus(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
          const SizedBox(
            height: 20,
          ),
          _listContent()
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rows[index].nmbarang.trim()),
                            if (rows[index].nmkat.isNotEmpty)
                              Text(rows[index].nmkat.trim()),
                            Text(rows[index].hbeli.toString()),
                            Text(rows[index].hjual.toString()),
                            Text(rows[index].stok.toString()),
                          ],
                        ),
                      ));
                    },
                  ),
                  if (isBusy)
                    const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator())
                ],
              ),
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

  Widget _buildMenus() {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) {
          int roleId = context.read<UserInfoProvider>().userRoleId;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // if (roleId == AppUtil.admin) _buildMenuItem("SETTING EVENT", () {
              //   Navigator.pushNamed(context, CsiRoute.rNEvent);
              // }),
              // if (roleId == AppUtil.admin) _buildMenuItem("STARTED EVENT", () {
              //   Navigator.pushNamed(context, CsiRoute.rStartevent);
              // }),
              if (roleId == AppUtil.admin)
                _buildMenuItem("LIST EVENT", () {
                  Navigator.pushNamed(context, AppRoute.rListEvent);
                }),
              if (roleId == AppUtil.admin)
                _buildMenuItem("HISTORY EVENT", () {
                  Navigator.pushNamed(context, AppRoute.rHEvent);
                }),

              if (roleId == AppUtil.petugas)
                _buildMenuItem("LIST EVENT", () {
                  Navigator.pushNamed(context, AppRoute.rLEPetugas);
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GradientButton(
        onPressed: onPressed,
        colors: [AppUtil.getSecondaryColor(), Theme.of(context).primaryColor],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Text(
            label,
            style: GoogleFonts.mochiyPopOne(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            textScaleFactor: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  void doSearch() {
    context.read<_ProviderGetData>().setSearch(_searchController.text);
    context.read<_ProviderGetData>().setData(context);
  }
}

class _ProviderGetData with ChangeNotifier {
  List<dynamic> result = [];
  int act = 1;
  String token = "";
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

    await AppSharedPrefs.getToken().then((value) => token = value);
    Response response = await Dio().get(
        "https://duplicode.my.id/tugas/dist.php?act=$act&filter=$filter",
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
