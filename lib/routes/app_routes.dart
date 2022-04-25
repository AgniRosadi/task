import 'package:flutter/material.dart';
import 'package:supplier/main.dart';
import 'package:supplier/view/home.dart';
import 'package:supplier/view/login.dart';

///Routing with defined name
class AppRoute {

  static const rMain = '/';
  static const rHome = '/home';
  static const rRegister = '/register';
  static const rLogin = '/login';
  static const rListEvent = '/listevent';
  static const rAddEvent = '/addevent';
  static const rMaps = '/maps';
  static const rNEvent = '/nevent';
  static const rHEvent = '/hevent';
  static const rLEPetugas = '/lepetugas';
  static const rCreateSesi = '/creatsesi';
  static const rSettingEvent = '/settingevent';
  static const rStartevent = '/startevent';
  static const rHSesi = '/historysesi';
  static const rListSesi = '/listsesi';
  static const rListUndian = '/listundian';
  static const rVhadiah = '/verifikasihadiah';
  static const rPreview = '/preview';
  static const rLPeserta = '/listpeserta';

  /// Route list
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rMain:
        return _buildRoute(settings, const MainPage());
      case rHome:
        return _buildRoute(settings, const HomePage());
      case rLogin:
        return _buildRoute(settings, const LoginPage());



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