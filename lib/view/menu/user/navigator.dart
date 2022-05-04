import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/model/master_model.dart';
import 'package:supplier/view/menu/user/history.dart';
import 'package:supplier/view/menu/user/home_user.dart';

import 'chekcout.dart';
String token = "";

class NavPage extends StatelessWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ProviderGetData(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProviderClear(),
      ),
    ], child: const _NavContent());
  }
}

class _NavContent extends StatefulWidget {
  const _NavContent({Key? key}) : super(key: key);

  @override
  State<_NavContent> createState() => _NavContentState();
}

class _NavContentState extends State<_NavContent> {
  int currenIndex = 0;
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await AppSharedPrefs.getToken().then((value) => token = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeUserPage(),
      // CPage(params: {"rows" : context.watch<ProviderGetData>().cBarang, "res" :context.watch<ProviderGetData>().result}),
      HPage()
    ];
    return Scaffold(
      body: screens[currenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: currenIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => currenIndex = index),
      ),
    );
  }
}




class ModelKeranjang {
  String? idbarang;
  String? nmbarang;
  int? hjual;
  int? hbeli;
  int? stok;
  String? idkat;
  String? nmkat;
  String? image;


  ModelKeranjang({
    this.idbarang,
    this.nmbarang,
    this.hjual,
    this.hbeli,
    this.stok,
    this.idkat,
    this.nmkat,
    this.image,
  });
}