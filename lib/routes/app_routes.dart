import 'package:flutter/material.dart';
import 'package:supplier/main.dart';
import 'package:supplier/view/menu/barang/add_barang.dart';
import 'package:supplier/view/home.dart';
import 'package:supplier/view/login.dart';
import 'package:supplier/view/menu/barang/penjualan.dart';
import 'package:supplier/view/menu/barang/screen_barang.dart';
import 'package:supplier/view/menu/barang/update_barang.dart';
import 'package:supplier/view/menu/kategori/screen_kategori.dart';
import 'package:supplier/view/menu/user/chekcout.dart';
import 'package:supplier/view/menu/user/home_user.dart';
import 'package:supplier/view/menu/user/navigator.dart';
import 'package:supplier/view/menu/user/new_checkout.dart';
import 'package:supplier/view/menu/user/screen_user.dart';

///Routing with defined name
class AppRoute {

  static const rMain = '/';
  static const rHome = '/home';
  static const rRegister = '/register';
  static const rLogin = '/login';
  static const rBarang = '/barang';
  static const rAddBarang = '/addbarang';
  static const rUpdateBarang = '/updatebarang';
  static const rKategori = '/kategori';
  static const rUser = '/user';
  static const rCheckout = '/checkout';
  static const rCheckout1 = '/checkout1';
  static const rNav = '/nav';
  static const rUpage = '/upage';
  static const rUadmin = '/uadmin';

  /// Route list
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rMain:
        return _buildRoute(settings, const MainPage());
      case rHome:
        return _buildRoute(settings, const HomePage());
      case rLogin:
        return _buildRoute(settings, const LoginPage());
      case rBarang:
        return _buildRoute(settings, const ScreenBarangPage());
      case rAddBarang:
        return _buildRoute(settings, const AddBarangPage());
      case rUpdateBarang:
        return _buildRoute(settings, const UpdateBarangPage());
      case rKategori:
        return _buildRoute(settings, const KategoriPage());
      case rUser:
        return _buildRoute(settings, const UserPage());
      case rCheckout:
        return _buildRoute(settings, const CPage());
      case rNav:
        return _buildRoute(settings, const NavPage());
      case rCheckout1:
        return _buildRoute(settings, const CNewPage());
      case rUpage:
        return _buildRoute(settings, const HomeUserPage());
      case rUadmin:
        return _buildRoute(settings, const HAdminPage());



      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('Page not found : ${settings.name}')
              ),
            ));
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }

}